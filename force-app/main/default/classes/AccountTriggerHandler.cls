public with sharing class AccountTriggerHandler {
    public static void updateShippingAddress(List<Account> accountList){
        for(Account acc : accountList){
            if(acc.BillingCity != null || acc.BillingCountry != null 
           || acc.BillingState != null || acc.BillingStreet != null){
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingState = acc.BillingState;
                acc.ShippingStreet = acc.BillingStreet;
            }
        }
    }

    public static void handleBeforeInsert(){

    }

    public static void handleBeforeUpdate(){

    }

    public static void handleBeforeDelete(){

    }   

    public static void handleAfterInsert(){
        
    }

}