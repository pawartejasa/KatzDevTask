/**
 * @Author              : Tejas P
 * @description         : Trigger Handler Interface.
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/

public interface TriggerInterface {
    
    /**********************************************************************************************
    @Description : Called by the trigger framework after insert of the records
    @Param : List<sObject> newList , Map<Id, sObject> newMap
    @return String
  	**********************************************************************************************/
    
    void afterInsert(List<sObject> newList, Map<Id, sObject> newMap);

}