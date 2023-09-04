public with sharing class RetriveNewsController {

    

    @AuraEnabled(cacheable = true)
    public static Map<String,Object> retriveAllNews(){
        String strResponse = null;
        String apiKey = '94c20775f1cd40d4ba5c7a640b0a584d';

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint('https://newsapi.org/v2/top-headlines?country=us&apiKey='+apiKey);
        httpRequest.setMethod('GET');

        Map<String,Object> newsJsonData = new Map<String,Object>();

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);

            if(httpResponse.getStatusCode() == 200){
                strResponse = httpResponse.getBody();
               

            }else{
                    throw new CalloutException(httpResponse.getBody());
            }

        } catch (Exception ex) {
            throw ex;
            
        }

        if(!String.isBlank(strResponse)){
            newsJsonData = (Map<String,Object>)JSON.deserializeUntyped(strResponse);

        }

        if(!newsJsonData.isEmpty())
        {
            return newsJsonData;
        }

        else {
            return null;
        }

    }
}