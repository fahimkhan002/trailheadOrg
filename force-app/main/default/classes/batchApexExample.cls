public with sharing class batchApexExample implements Database.Batchable<SObject> {

 //   List<Contact> contList;
    String query;
    public batchApexExample(String query){
        
       // this.contList = contList;
        this.query = query;
    }
  
    public Database.QueryLocator start(Database.BatchableContext context)
    {
        //return contList;

        return Database.getQueryLocator(query);
    }

    public static void execute(Database.BatchableContext context, List<Contact> contList)
    {
//        List<Contact> contList = [SELECT id,FirstName,LastName FROM Contact];
  
        for(Contact con : contList){
            con.FirstName = 'Batchable';
        }
        
        update contList;
}

    public static void finish(Database.BatchableContext context)
    {


    }
}