public class SalesOrderTriggerHelper {
    
    public static void afterUpdate (List<Sales_Order__c> lstOfSalesOrder){
        
        if(preventRecursion.firstCall){
            if (!preventRecursion.firstCall) {
            return;
        }
            preventRecursion.firstCall=false;
            SalesOrderQueueableHandler queueableHandler = new SalesOrderQueueableHandler(lstOfSalesOrder);
            
            System.enqueueJob(queueableHandler);
            
            System.debug('preventRecursion :: '+preventRecursion.firstCall);
            
        }
        
        
    }
    
}