@isTest
public class CheckCaseTriggerEventTest {

	@isTest private static void testValidEvent() {    
    
     	Case c = new Case();
        c.Status = 'New';
        c.Reason = 'Equipement';
        c.Origin = 'Email';
        insert c;


        Test.startTest();
		c.Status = 'Closed';
        update c;
        Test.stopTest();
        System.assertEquals(c.Status, 'Closed', 'Status Updated');
        
}
}