public with sharing class AsyncApexDemo {
    

    public void syncMethod(){
        List<Contact> contList = [SELECT Id,FirstName,LastName FROM Contact WHERE Id = '0032w00000xhCVRAA2'];
        contList[0].Email = 'newUpdatEmailFromBatch@gamil.com';
        
        // scheduleableExample sched = new scheduleableExample(contList);
        // String cron = '0 50 15 * * ?';
        // System.schedule('Schedule Job Demo', cron, sched);
        // AsyncApexDemo.futureMethod(contList[0].Id); 
        // QueueableClassDemo queueExample = new QueueableClassDemo(contList[0]);
        // System.enqueueJob(queueExample);
        String query = 'SELECT Id,FirstName,LastName FROM Contact';
        Database.executeBatch(new batchApexExample(query), 1);
        System.debug('This is contact in sync Method :'+contList[0]);
        update contList;
    }

    @Future
    public static void futureMethod(Id contId){
        List<Contact> contList = [SELECT Id,FirstName,LastName FROM Contact WHERE Id =: contId];
        
        contList[0].FirstName = 'FutureMethod';
        contList[0].LastName = 'Demostration';

        System.debug('Future Method '+contList);

        update contList;
    
    }
}