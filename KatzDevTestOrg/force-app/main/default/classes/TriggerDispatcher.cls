/**
 * @Author              : Tejas P
 * @description         : Trigger dispatcher.
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/
public class TriggerDispatcher {
    /**********************************************************************************************
    @description  It will invoke the appropriate methods on the handler depending on the trigger context.
    @param handler [TriggerInterface] , triggerName [String]
    @return 
  	**********************************************************************************************/
    public static void run(TriggerInterface handler, string triggerName){
         
        
            switch on Trigger.operationType {
                 
                
                when AFTER_INSERT {
                    //Invoke after insert trigger handler
                    handler.afterInsert(trigger.new, trigger.newMap);
                }
                
            }
        }
    
}