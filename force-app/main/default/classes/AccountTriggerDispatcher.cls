public with sharing class AccountTriggerDispatcher {
    public static void dispatch(System.TriggerOperation operationType){
        
        switch on operationType {
            when  BEFORE_INSERT{
                AccountTriggerHandler.updateShippingAddress(Trigger.New);
            }
            when AFTER_INSERT {
                
            }

            when BEFORE_UPDATE{

            }
        
            when AFTER_UPDATE{

            }
            when BEFORE_DELETE{

            }
            when AFTER_DELETE{

            }
            when AFTER_UNDELETE{

            }
    }
}
}