public class SalesOrderTriggerHandler {
    
    
    public static void handleAfterInsert(List<Sales_Order__c> newSalesOrders) {
        String salesOrderJson = JSON.serialize(newSalesOrders);
        handleAfterInsertAsync(salesOrderJson);
    }
    
    public static void handleAfterUpdate(List<Sales_Order__c> updatedSalesOrders) {
        String salesOrderJson = JSON.serialize(updatedSalesOrders);
        handleAfterUpdateAsync(salesOrderJson);
    }
    
    
    @future
    public static void handleAfterInsertAsync(String salesOrderJson) {
        List<Sales_Order__c> newSalesOrders = (List<Sales_Order__c>) JSON.deserialize(salesOrderJson, List<Sales_Order__c>.class);
        UpdateFirstReferralDate(newSalesOrders);
        UpdateLastReferralDate(newSalesOrders);
    }
    @future
    public static void handleAfterUpdateAsync(String salesOrderJson) {
        List<Sales_Order__c> newSalesOrders = (List<Sales_Order__c>) JSON.deserialize(salesOrderJson, List<Sales_Order__c>.class);
        UpdateFirstReferralDate(newSalesOrders);
        UpdateLastReferralDate(newSalesOrders);
    }
    
    public static void UpdateFirstReferralDate(List<Sales_Order__c> orders) {
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
        System.debug(contactsToUpdate);
        // Update Contact records with First_Referral_Date__c value
        List<Contact> contactsToUpdateList = new List<Contact>();
        for (Contact contact : contactsToUpdate) {
            if (contact.Sales_Orders__r.size() > 0) {
                // Retrieve the first Sales_Order__c record's CreatedDate
                Date firstOrderDate = contact.Sales_Orders__r[0].Create_Date__c;
                System.debug(firstOrderDate);
                // Update the First_Referral_Date__c field on the Contact object
                //if (contact.First_Referral_Date__c == null || contact.First_Referral_Date__c > firstOrderDate) {
                    contact.First_Referral_Date__c = firstOrderDate;
                    contactsToUpdateList.add(contact);
                //}
            }
            
            else{
                contact.First_Referral_Date__c = null;
                contactsToUpdateList.add(contact);
            }
        }
        
        // Update Contact records
        update contactsToUpdateList;
        System.debug(contactsToUpdateList);
    }
    
    
    
    public static void UpdateLastReferralDate(List<Sales_Order__c> orders) {
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
                // if (contact.Last_Referral_Date__c == null || contact.Last_Referral_Date__c > lastOrderDate) {
                contact.Last_Referral_Date__c = lastOrderDate;
                contactsToUpdateList.add(contact);
                //}
            }
            else{
                contact.Last_Referral_Date__c = null;
                contactsToUpdateList.add(contact);
            }
        }
        
        // Update Contact records
        update contactsToUpdateList;
        System.debug('Last_Referral_Date__c = '+contactsToUpdateList);
        
    }
    
    
    
}