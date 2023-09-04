public class SalesOrderQueueableHandler implements Queueable {
    private List<Sales_Order__c> salesOrders;
    private String contexts;
    
    public SalesOrderQueueableHandler(List<Sales_Order__c> salesOrders, String contexts) {
        this.salesOrders = salesOrders;
        this.contexts = contexts;
    }
    
       
      public void execute(QueueableContext context) {
        if (salesOrders != null && !salesOrders.isEmpty()) {
            if (contexts == 'before') {
                // Perform actions for before trigger
                // Call the corresponding methods
                // updateSalesOrderOwnerBefore(salesOrders);
                // updateContactRxCountsBefore(salesOrders);
             // setOwnerID(salesOrders);
                UpdateSalesOrderOwner(salesOrders);
              
                
            } else if (contexts == 'after') {
            updateContactRxCounts(salesOrders);
            DaySinceLastRxCount(salesOrders);
            UpdateFirstReferralDate(salesOrders);
            UpdateLastReferralDate(salesOrders);
            ConversionRate(salesOrders);
            
            }
        }
    }  
    
    
    private static void UpdateSalesOrderOwner(List<Sales_Order__c> salesOrders) {
        Set<Id> contactIds = new Set<Id>();
        //Map<Id,Boolean> salesIds = new Map<Id,Boolean>();
        for (Sales_Order__c order : salesOrders) {
            if (order.Contact__c != null) {
                contactIds.add(order.Contact__c);
                
            }
        }
        
        System.debug('ContactIds: ' + contactIds);
        
        Map<Id, Id> salesRepUserMap = new Map<Id, Id>();
        Map<Id, Id> contactSalesRepMap = new Map<Id, Id>();
        List<Sales_Order__c> updatedSalesOrders = new List<Sales_Order__c>();
        
        // Retrieve Sales Rep and User information for the Contacts
        for (Contact contact : [SELECT Id, Sales_Rep__c, Sales_Rep__r.User__c FROM Contact WHERE Id IN :contactIds]) {
            contactSalesRepMap.put(contact.Id, contact.Sales_Rep__c);
            
            // Check if Sales Rep has a User associated with it
            if (contact.Sales_Rep__r.User__c != null) {
                salesRepUserMap.put(contact.Sales_Rep__c, contact.Sales_Rep__r.User__c);
            }
        }
        
        // Prepare the updated Sales Orders with new OwnerIds
        for (Sales_Order__c salesOrder : salesOrders) {
            if (salesOrder.Contact__c != null) {
                Id contactId = salesOrder.Contact__c;
                Id salesRepId = contactSalesRepMap.get(contactId);
                
                // Check if Sales Rep has a User associated with it
                if (salesRepUserMap.containsKey(salesRepId)) {
                    Sales_Order__c updatedOrder = new Sales_Order__c();
                        updatedOrder.Id = salesOrder.Id;
                        updatedOrder.OwnerId = salesRepUserMap.get(salesRepId);
                   
                    updatedSalesOrders.add(updatedOrder);
					System.debug('updatedSalesOrders ===>>>'+updatedSalesOrders);
                }
            }
        }
        
        // Update the modified Sales Order records outside of the trigger/queueable context
        //if (!updatedSalesOrders.isEmpty()) {

          //  update updatedSalesOrders;
           // System.debug('updatedSalesOrders line 92   '+updatedSalesOrders);
            
            //Database.update(updatedSalesOrders, false); // Use false to avoid recursive triggers
            
       // }
       // 
       // 
       
        
        if (!updatedSalesOrders.isEmpty()) {
        Database.update(updatedSalesOrders, false); // Use false to avoid recursive triggers
    }
    }
    
    public static void setOwnerID(List<Sales_Order__c> salesOrders){
         
        Set<Id> contactIds = new Set<Id>();
        for(Sales_Order__c so : salesOrders){
            if(so.Contact__c != null){
                contactIds.add(so.Contact__c);
            }
        } 
        
        System.debug('contactIds '+contactIds);

        Map<Id, Sales_Order__c> brightreeUsers = new Map<Id, Sales_Order__c>(
            [SELECT Id,
            Contact__r.Sales_Rep__r.User__c
            FROM Sales_Order__c
            WHERE Id IN :contactIds]);
        
        System.debug('brightreeUsers ===>'+brightreeUsers);

        //Sets SO__c.OwnerId to Brightree_User__c.Salesforce_User__c
        for(Sales_Order__c so : salesOrders){
            if(so.Contact__c != null && brightreeUsers.containsKey(so.Contact__r.Sales_Rep__c)){
                    Sales_Order__c btUser = brightreeUsers.get(so.Contact__r.Sales_Rep__r.User__c);
                System.debug('btUser --> '+btUser);
                    if (btUser.Contact__c != null) {
                        so.OwnerId = btUser.Contact__r.Sales_Rep__r.User__c;
                    }
            }
        }

    }
    
        public static void updateSalesOrderOwners(List<Sales_Order__c> salesOrders) {
       // List<Sales_Order__c> salesOrders = [SELECT Id, Contact__r.Sales_Rep__r.User__c, OwnerId FROM Sales_Order__c WHERE Contact__c != null];

        Map<Id, Id> salesRepUserMap = new Map<Id, Id>();

        // Collect the Sales Rep Ids
        Set<Id> salesRepIds = new Set<Id>();
        for (Sales_Order__c salesOrder : salesOrders) {
            salesRepIds.add(salesOrder.Contact__c);
        }
            System.debug('salesRepIds'+salesRepIds);

        // Query Sales Rep records to retrieve User Ids
        for (Sales_Rep__c salesRep : [SELECT Id, User__c FROM Sales_Rep__c WHERE Id IN :salesRepIds AND User__c != null]) {
            salesRepUserMap.put(salesRep.Id, salesRep.User__c);
        }

        for (Sales_Order__c salesOrder : salesOrders) {
            // Check if the Sales Rep User Id is available
            if (salesRepUserMap.containsKey(salesOrder.Contact__r.Sales_Rep__c)) {
                // Update the Sales Order OwnerId to the Sales Rep User Id
                salesOrder.OwnerId = salesRepUserMap.get(salesOrder.Contact__r.Sales_Rep__c);
            }
        }
    }
    
    private static void updateContactRxCounts(List<Sales_Order__c> salesOrders) {
        Set<Id> contactIds = new Set<Id>();
        for (Sales_Order__c salesOrder : salesOrders) {
            if (salesOrder.Contact__c != null) {
                contactIds.add(salesOrder.Contact__c);
            }
        }
        
        List<Contact> contacts = [SELECT Id, This_Month_Rx_Count__c, X12_Month_Rx_Count__c, X3_Months_Rx_Count__c FROM Contact WHERE Id IN :contactIds];
        
        Integer thisMonth = System.now().month();
        Integer thisYear = Date.today().addDays(-365).year();
        Integer thisYears = System.now().year();
        
        Map<Id, Integer> thisMonthCount = new Map<Id, Integer>();
        Map<Id, Integer> x12MonthCount  = new Map<Id, Integer>();
        Map<Id, Integer> x3MonthCount   = new Map<Id, Integer>(); 
        
        List<Sales_Order__c> mySalesOrder = [SELECT Id, Contact__c, Create_Date__c FROM Sales_Order__c WHERE Contact__c IN :contactIds AND Contact__c != null];
        
        for (Sales_Order__c sOrder : mySalesOrder) {
            if (sOrder.Create_Date__c.month() == thisMonth && sOrder.Create_Date__c.year() == thisYears) {
                if (thisMonthCount.containsKey(sOrder.Contact__c)) {
                    thisMonthCount.put(sOrder.Contact__c, thisMonthCount.get(sOrder.Contact__c) + 1);
                    
                } else {
                    thisMonthCount.put(sOrder.Contact__c, 1);
                }
            }
            if (sOrder.Create_Date__c >= Date.today().addDays(-365)) {
                if (x12MonthCount.containsKey(sOrder.Contact__c)) {
                    x12MonthCount.put(sOrder.Contact__c, x12MonthCount.get(sOrder.Contact__c) + 1);
                } else {
                    x12MonthCount.put(sOrder.Contact__c, 1);
                }
            }
            
            if (sOrder.Create_Date__c >= System.today().addMonths(-3)) {
                if (x3MonthCount.containsKey(sOrder.Contact__c)) {
                    x3MonthCount.put(sOrder.Contact__c, x3MonthCount.get(sOrder.Contact__c) + 1);
                } else {
                    x3MonthCount.put(sOrder.Contact__c, 1);
                }
            }
        }
        
        // Update the contact records with the new Rx counts
        for (Contact contact : contacts) {
            contact.This_Month_Rx_Count__c = thisMonthCount.get(contact.Id) != null ? thisMonthCount.get(contact.Id) : null;
            contact.X12_Month_Rx_Count__c = x12MonthCount.get(contact.Id) != null ? x12MonthCount.get(contact.Id) : null;
            contact.X3_Months_Rx_Count__c = x3MonthCount.get(contact.Id) != null ? x3MonthCount.get(contact.Id) : null;
        }
        
        update contacts;
    }
    
    
    private static void DaySinceLastRxCount(List<Sales_Order__c> salesOrders) {
        Set<Id> contactIds = new Set<Id>();
        Date currentDate = Date.today();
        
        for (Sales_Order__c so : salesOrders) {
            contactIds.add(so.Contact__c);
        }
        
        List<Sales_Order__c> mostRecentSalesOrdersMap = [
            SELECT Id, Contact__c, Create_Date__c
            FROM Sales_Order__c
            WHERE Contact__c IN :contactIds
            ORDER BY Create_Date__c ASC
        ];
        
        Map<Id, Contact> contactsMap = new Map<Id, Contact>([
            SELECT Id, Days_Since_Last_Rx__c
            FROM Contact
            WHERE Id IN :contactIds
        ]);
        
        for (Contact contact : contactsMap.values()) {
            // Sales_Order__c mostRecentSalesOrder = mostRecentSalesOrdersMap.get(0).(contact.Id);
            // System.debug('mostRecentSalesOrder'+mostRecentSalesOrder);
            Decimal lastRxDays = null;
            for (Sales_Order__c so : mostRecentSalesOrdersMap) {
                if (so.Contact__c == contact.Id && (lastRxDays == null || currentDate.daysBetween(so.Create_Date__c) < lastRxDays)) {
                    lastRxDays = so.Create_Date__c.daysBetween(currentDate);
                    //lastRxDays = currentDate.daysBetween(so.Create_Date__c);
                }
            }
            contact.Days_Since_Last_Rx__c = lastRxDays == null ? null :  Math.abs(lastRxDays.intValue());
        }
        
        update contactsMap.values();
        
    }
    
    
    
    private void UpdateFirstReferralDate(List<Sales_Order__c> orders) {
        // Collect Contact Ids
        Set<Id> contactIds = new Set<Id>();
        for (Sales_Order__c order : orders) {
            contactIds.add(order.Contact__c);
        }
        
        // Query for Contacts with related Sales_Order__c records
        List<Contact> contactsToUpdate = [
            SELECT Id, First_Referral_Date__c,
            (SELECT Id, Create_Date__c FROM Sales_Orders__r ORDER BY Create_Date__c ASC LIMIT 1)
            FROM Contact
            WHERE Id IN :contactIds
        ];
        
        // Update Contact records with First_Referral_Date__c value
        List<Contact> contactsToUpdateList = new List<Contact>();
        for (Contact contact : contactsToUpdate) {
            if (contact.Sales_Orders__r.size() > 0) {
                // Retrieve the first Sales_Order__c record's CreatedDate
                Date firstOrderDate = contact.Sales_Orders__r[0].Create_Date__c;
                // Update the First_Referral_Date__c field on the Contact object
                // if (contact.First_Referral_Date__c == null || contact.First_Referral_Date__c > firstOrderDate) {
                contact.First_Referral_Date__c = firstOrderDate;
                contactsToUpdateList.add(contact);
                //  }
            } else {
                contact.First_Referral_Date__c = null;
                contactsToUpdateList.add(contact);
            }
        }
        
        // Update Contact records
        update contactsToUpdateList;
    }
    
    private void UpdateLastReferralDate(List<Sales_Order__c> orders) {
        // Collect Contact Ids
        Set<Id> contactIds = new Set<Id>();
        for (Sales_Order__c order : orders) {
            contactIds.add(order.Contact__c);
        }
        
        // Query for Contacts with related Sales_Order__c records
        List<Contact> contactsToUpdate = [
            SELECT Id, Last_Referral_Date__c ,
            (SELECT Id, Create_Date__c FROM Sales_Orders__r ORDER BY Create_Date__c DESC LIMIT 1)
            FROM Contact
            WHERE Id IN :contactIds
        ];
        
        // Update Contact records with Last_Referral_Date__c value
        List<Contact> contactsToUpdateList = new List<Contact>();
        for (Contact contact : contactsToUpdate) {
            if (contact.Sales_Orders__r.size() > 0) {
                // Retrieve the first Sales_Order__c record's CreatedDate
                Date lastOrderDate = contact.Sales_Orders__r[0].Create_Date__c;
                // Update the Last_Referral_Date__c field on the Contact object
                // if (contact.Last_Referral_Date__c == null || contact.Last_Referral_Date__c < lastOrderDate) {
                contact.Last_Referral_Date__c = lastOrderDate;
                contactsToUpdateList.add(contact);
                //}
            } else {
                contact.Last_Referral_Date__c = null;
                contactsToUpdateList.add(contact);
            }
        }
        
        // Update Contact records
        update contactsToUpdateList;
    }
    
    private static void ConversionRate(List<Sales_Order__c> salesOrders) {
        Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();
        Set<Id> contactIds = new Set<Id>();
        
        // Collect the Contact Ids from the Sales Orders
        for (Sales_Order__c order : salesOrders) {
            if (order.Contact__c != null) {
                contactIds.add(order.Contact__c);
            }
        }
        
        // Retrieve the Doctors with Scheduled Delivery Date
        list<Contact> myList = [SELECT Id, Conversion_Rate__c, (SELECT Id, Scheduled_Delivery_Date__c FROM Sales_Orders__r WHERE Contact__c =: contactIds) FROM Contact WHERE Id IN :contactIds];
        
        for (Contact contact : myList) {
            List<Sales_Order__c> allSalesOrders = contact.Sales_Orders__r;
            Integer allCount = allSalesOrders.size();
            
            Integer scheduleDeliveryDateCount = 0;
            
            // Iterate over the Sales Orders and count the number of Scheduled Delivery Dates
            for (Sales_Order__c order : allSalesOrders) {
                if (order.Scheduled_Delivery_Date__c < Date.today()) {
                    scheduleDeliveryDateCount++;
                }
            }
            
            // Calculate the Conversion Rate
            Decimal conversionRate = 0;
            if (allCount > 0) {
                conversionRate = (Decimal) scheduleDeliveryDateCount / allCount * 100;
                conversionRate = conversionRate.setScale(2);
            }
            contact.Conversion_Rate__c = String.valueOf(conversionRate) + '%';
            
            contactsToUpdate.put(contact.Id, contact);
        }
        
        // Update the Contacts with the updated Conversion Rate
        if (contactsToUpdate.size() > 0) {
            update contactsToUpdate.values();
        }
    }
}