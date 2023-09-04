@isTest
public class SalesOrderQueueableHandlerTest {
    @isTest
    public static void testSalesOrderQueueableHandler() {
        // Create test data for Contact
        Contact contact = new Contact();
        // Set required field values
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        
        Test.startTest();
        insert contact;
        
        // Create test data for Sales_Order__c
        List<Sales_Order__c> salesOrders = new List<Sales_Order__c>();
        for (Integer i = 0; i < 5; i++) {
            Sales_Order__c so = new Sales_Order__c();
            // Set required field values
            so.Contact__c = contact.Id;
            so.Create_Date__c = Date.today();
            salesOrders.add(so);
        }
        insert salesOrders;
        
        // Enqueue the queueable job
        System.enqueueJob(new SalesOrderQueueableHandler(salesOrders));
        
        
        
        Test.stopTest();
        
        // Verify Contact field values
        contact = [SELECT Id, First_Referral_Date__c, Last_Referral_Date__c FROM Contact WHERE Id = :contact.Id];
        System.assertEquals(Date.today(), contact.First_Referral_Date__c);
        System.assertEquals(Date.today(), contact.Last_Referral_Date__c);
    }
}