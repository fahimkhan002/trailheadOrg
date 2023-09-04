public class UpdateSalesOrderOwnerBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Contact__r.Sales_Rep__r.User__c, OwnerId FROM Sales_Order__c WHERE Contact__c != null';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<Sales_Order__c> salesOrders) {
        Map<Id, Id> salesRepUserMap = new Map<Id, Id>();

        // Collect the Sales Rep Ids
        Set<Id> salesRepIds = new Set<Id>();
        for (Sales_Order__c salesOrder : salesOrders) {
            salesRepIds.add(salesOrder.Contact__r.Sales_Rep__c);
        }

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

        // Update the modified Sales Orders
        if (!salesOrders.isEmpty()) {
            update salesOrders;
        }
    }

    public void finish(Database.BatchableContext context) {
        // Perform any post-processing logic if needed
    }
}