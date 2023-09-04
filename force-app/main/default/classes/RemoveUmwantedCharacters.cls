public class RemoveUmwantedCharacters implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Phone FROM Account';
        return Database.getQueryLocator(query);
    }
    
    public static void execute(Database.BatchableContext bc, List<Account> Acct){
		List<Account> AccountsToUpdate = new List<Account>();
        
        for(Account ac : Acct){
            if(ac.Phone != null){
                String phoneNumber = ac.Phone.replaceAll('[\\D]', '');
                ac.Phone = phoneNumber;
                AccountsToUpdate.add(ac);
            }
        }
        update AccountsToUpdate;
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}