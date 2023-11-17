public with sharing class OpportunityTriggerHandler {
    public static void DiscountAmount(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            if(Opp.Amount != null && opp.Discount__c != null){
                Decimal Discount = (opp.Discount__c * opp.Amount) / 100;
                Decimal DiscountPrice = opp.Amount - Discount;
                opp.Discount_Price__c = Discount;
                opp.PriceAfterDiscount__c = DiscountPrice;

                System.debug('Discount '+Discount+' DiscountPrice '+DiscountPrice);
            }
        }
    }
}