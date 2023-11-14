public class AccountCreator {
  public static void createAccounts(Integer numberOfAccounts) {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < numberOfAccounts; i++) {
      Account account = new Account();
      account.Name = 'New Account ' + i;
      account.Type = 'Customer';
      account.ShippingCity = 'San Francisco';
      account.ShippingState = 'CA';
      account.ShippingCountry = 'USA';
      account.ShippingState = 'ShippingState';

      accounts.add(account);
    }

    insert accounts;
  }
}