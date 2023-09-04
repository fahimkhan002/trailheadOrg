public with sharing class BitlyService {
    public String shorten(String courseURL){
        //HTTP POST callout
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        //Callout named crendentials
        req.setEndpoint('callout:Bitly/v4/shorten');
        req.setHeader('Authorization', 'Bearer {!$credential.password}');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String,Object> {
            
            'long_url' => courseURL,
            'domain' => 'bit.ly'
        }));

       HttpResponse res =  h.send(req);
       Map<String,Object> response = ( Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        system.debug(res.getStatusCode() + ': ' + res.getBody());
       String surl = (String) response.get('link');
       return surl;
}
}