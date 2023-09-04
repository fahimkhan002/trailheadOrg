Public class AccountTriggerHandler_AC

{
    @future
    public static void processAccountData(String jsonString){
        
        //deserialize the JSON to the Account List
        
        List<Account> accountList = (List<Account>)Json.deserialize(jsonString,List<Account>.class);
        
        //Printing the Account List
        
        System.debug('---Account List---'+accountList);
        
    }
    
}