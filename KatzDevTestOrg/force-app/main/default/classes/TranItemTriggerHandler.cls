/**
 * @Author              : Tejas P
 * @description         : TranItemRestCallout class includes 
 * 						  3 different methods out of which SendTranDataRest 
 * 						  is future method which is used to make callout from this system.
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/
public class TranItemTriggerHandler implements TriggerInterface{
    /**********************************************************************************************
    @description  created a generic method which takes parameters as list<sObject> & Map<Id, sObject>.
    @param TranItemData [List<Transaction_Item__c>]
    @return String
  	**********************************************************************************************/
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
     	// Explicitly typecasting to get records of Transaction item objects.
        Map<Id, Transaction_Item__c> jsonString = (Map<Id, Transaction_Item__c>) newMap; 
        //Passing list of ids to the future method as Rollup summary fields are calculated 
        //in step 13 of the database save logic, while triggers execute during step 4 (before event triggers) 
        //and step 8 (after event triggers).  For our current scenario we need these values for some sort of calculation, 
        //we must use a @future method instead, which guarantees that the entire batch of records have had their summary 
        //values updated.
			TranItemRestCallout.SendTranDataRest(newMap.keySet());
    }
}