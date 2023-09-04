public with sharing class SearchAccountController {

    @AuraEnabled(cacheable = true)
    public static List<Account> fetchAccounts( String searchKey ) {
        String theKey = '%' + searchKey + '%';
        return [SELECT Id, Name,AccountNumber,Industry, Rating FROM Account WHERE Name LIKE: theKey];
    }
}