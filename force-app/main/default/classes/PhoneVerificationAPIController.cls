public class PhoneVerificationAPIController {
      @InvocableMethod(label='Verify Mobile No' description='Makes API Call to PhoneVerification API' category='Account')
		  public static List<Boolean> verifyPhoneNo(List<String> mobileNo) {
             PhoneVerificationAPI.PhoneResponse mobileNumResponse = PhoneVerificationAPI.InvokeVeriPhone(mobileNo[0]);
              return new List<Boolean>{mobileNumResponse.phone_valid};
          }
}