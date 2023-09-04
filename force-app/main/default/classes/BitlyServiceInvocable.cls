public with sharing class BitlyServiceInvocable {

    @InvocableMethod(label='Shorten URL' description='Generate short url with bitly.' category='Course')
    public static void shorten(List<Id> courseId){
        shortenFuture(courseId);
    }
    
    
    @future(callout=true)
    public static void shortenFuture(list<Id> courseIds){
        List<Course__c> courseList = [SELECT Id,Name,Course_URL__c,Coupan_Codes__c FROM Course__c WHERE Id IN : courseIds];
        BitlyService bservice = new BitlyService();
        for(Course__c course : courseList){
            String fullURL = course.Course_URL__c;

            if(course.Coupan_Codes__c != null){
                fullURL = fullURL +'?coupanCode='+course.Coupan_Codes__c; 
            }
            String shortUrl = bservice.shorten(fullURL);
            course.Short_URL__c = shortUrl;
        }

        if(courseList.size()> 0){
            update courseList;
        }
    }

}