public with sharing class scheduleableExample implements Schedulable{

    List<Contact> contList;
    public scheduleableExample( List<Contact> contList){
        this.contList = contList;
    }


    public void execute(SchedulableContext context){

        List<Contact> contList = [SELECT Id,FirstName,LastName FROM Contact];

        for(Contact cont: contList){
            cont.FirstName = 'Schedule First Name';
            cont.LastName = 'Schdule Last Name';
        }

        update contList;
        
    

    }



}