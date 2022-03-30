/**
 * @Author              : Tejas P
 * @description         : Test Data Factory class for All object
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/
@isTest
public class TestDataFactory {
    
  /**********************************************************************************************
    @description  This method is to create Transaction__c record for Test methods
    @param TransCount [Integer], TransCost [Decimal], TotDiscount [Decimal]
    @return Transaction__c
  **********************************************************************************************/
    Public Static Transaction__c createTransactionRecord(Integer TransCount, Decimal TransCost, Decimal TotDiscount){
        Transaction__c NewTran= New Transaction__c();
            NewTran.Transaction_Count__c  = TransCount;
            NewTran.Transaction_Cost__c= TransCost;
            NewTran.Total_Discount__c= TotDiscount;
        return NewTran;
    }
    
    /**********************************************************************************************
    @description  This method is to create Transaction_Item__c record for Test methods
    @param NewTran [Id], ItemCost [Decimal], ItemName [String]
    @return Transaction_Item__c
  **********************************************************************************************/
    Public Static Transaction_Item__c createTransactionItemRecord(Id NewTran, Decimal ItemCost, String ItemName){
        Transaction_Item__c NewTranItem =New Transaction_Item__c();
            NewTranItem.Transaction__c=NewTran;
            NewTranItem.Item_Cost__c=ItemCost;
            NewTranItem.Item_Name__c= ItemName;
        return NewTranItem;
    }
}