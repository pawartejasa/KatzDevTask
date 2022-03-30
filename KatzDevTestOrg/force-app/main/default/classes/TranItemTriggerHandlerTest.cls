/**
 * @Author              : Tejas P
 * @description         : Test class for TranItemRestCallout [Overall Test Coverage- 91%]
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/

@IsTest
public class TranItemTriggerHandlerTest {
    /**********************************************************************************************
    @description  This method is to test trigger handler class and TransactionItemCalloutMock class
    @param 
    @return 
  **********************************************************************************************/
	@IsTest
    public Static void TestTriggerHandler(){
        //created test record for Transaction__c.
        Transaction__c NewTran= TestDataFactory.createTransactionRecord(1,100.00,50.00);
			insert NewTran;
        //created test record for Transaction_item__c.
        Transaction_Item__c NewTranItem = TestDataFactory.createTransactionItemRecord(NewTran.Id, 100.00, 'TestItem');
        //Test mock response called
        Test.setMock(HttpCalloutMock.class, new TransactionItemCalloutMock());
        //Using startTest and stopTest to test async future method & http callouts.
        Test.startTest();
        	insert NewTranItem;
        Test.stopTest();
       
    }
    /**********************************************************************************************
    @description  This method is to test trigger handler class and TransactionItemCalloutMock class with negative scenarios
    @param 
    @return 
  **********************************************************************************************/
    @isTest
    Public Static void TestTriggerHandlerNeagative(){
        //created test record for Transaction__c.
        Transaction__c NewTran= TestDataFactory.createTransactionRecord(2,200.00,50.00);
			insert NewTran;
        //created test records for Transaction_item__c.
        Transaction_Item__c NewTranItem =TestDataFactory.createTransactionItemRecord(NewTran.Id, 100.00, 'TestItem1');
        Transaction_Item__c NewTranItem2 =TestDataFactory.createTransactionItemRecord(NewTran.Id, 100.00, 'TestItem2');
        List<Transaction_Item__c> AddItems= new List<Transaction_Item__c>();
            AddItems.add(NewTranItem);
            AddItems.add(NewTranItem2);
        //Test mock response called
        Test.setMock(HttpCalloutMock.class, new TransactionItemCalloutMockFailure());
        //Using startTest and stopTest to test async future method & http callouts.
        Test.startTest();
        	insert AddItems;
        Test.stopTest();
    }
}