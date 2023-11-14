public with sharing class AccountController {
    @AuraEnabled(Cacheable=false)
    public static List<Account> createAccounts(Integer numberOfAccounts) {
        List<String> randType = new List<String>{'Prospect','Customer - Direct','Customer - Channel','Channel Partner / Reseller','Installation Partner','Technology Partner','Other'};
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account account = new Account();
            account.Name = 'New Account ' + i;
            
            // Randomly select a Type from randType list
            Integer randomIndex = (Integer) Math.floor(Math.random() * randType.size());
            account.Type = randType[randomIndex];

            account.ShippingCity = 'San Francisco';
            account.ShippingState = 'CA';
            account.ShippingCountry = 'USA';

            accounts.add(account);
        }

        try {
            insert accounts;
            System.debug(accounts);
          } catch(ListException e) {
            System.debug(e.getStackTraceString()); // Useful output here
          }

          return accounts;
          
        
    }
}