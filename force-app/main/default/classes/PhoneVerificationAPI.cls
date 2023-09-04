public with sharing class PhoneVerificationAPI {

    public static PhoneResponse InvokeVeriPhone(String mobileNum){
        String apiKey = '5F0541E9A72746B39CBBC6FCB6303844';
        String veriPhoneEndPoint = 'https://api.veriphone.io/v2/verify?phone='+mobileNum+'&key='+apiKey;

        //Http
        Http h = new Http();

        //HttpRequest
        HttpRequest req = new HttpRequest();
        req.setEndpoint(veriPhoneEndPoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept','application/json');
        req.setTimeout(60000);
        //HttpResponse

        HttpResponse res = h.send(req);
        //Response Instance to return to PhoneResponse Class
		Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        
        System.debug(m);
        
		//Map<String, Object> m2 = (Map<String, Object>) m.get('phone');
        // System.debug(m2);
        
        String mm = (String) m.get('phone');
         System.debug(mm);
        
        PhoneResponse pres = (PhoneResponse)JSON.deserialize(res.getBody(), PhoneResponse.class);
        return pres;
        // return new PhoneResponse().parse(res.getBody());
        // 
      
    }
    
    
    public class PhoneResponse{
        List<sObject> acct;
        public String phone;
        public Boolean phone_valid;
        public String phone_type;
        public String phone_region; 
        public String country;
        public String country_code;
        public String international_number;
        public String local_number;
        public String e164;
        public String carrier;
    }



}