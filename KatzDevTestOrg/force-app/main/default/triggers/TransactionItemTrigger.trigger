/**
 * @Author              : Tejas P
 * @description         : Trigger for Transaction_Item__c object.
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/

trigger TransactionItemTrigger on Transaction_Item__c (after insert) {
    TriggerDispatcher.run(new TranItemTriggerHandler(), 'TransactionItemTrigger');
 
}