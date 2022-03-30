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
public class TranItemRestCallout {
    /**********************************************************************************************
    @description  This method is used to create JSON payload to send through HTTP callout body.
    @param TranItemData [List<Transaction_Item__c>]
    @return String
  	**********************************************************************************************/
    Public Static String CreateTranItemPayload(List<Transaction_Item__c> TranItemData){
        String TranItemPayload='';
        for(Transaction_Item__c SingleTranData: TranItemData){
            JSONGenerator gen = JSON.createGenerator(true);
				gen.writeStartObject();
                gen.writeFieldName('Keys');
                gen.writeStartObject();
                gen.writeObjectField('TransactionItemID',SingleTranData.Id);
                gen.writeEndObject();
                gen.writeFieldName('Values');
                gen.writeStartObject();
                gen.writeObjectField('ItemCost',SingleTranData.Item_Cost__c);
                gen.writeObjectField('ItemName',SingleTranData.Item_Name__c);
                gen.writeEndObject();
            	gen.writeEndObject(); 
                TranItemPayload = TranItemPayload+',' + gen.getAsString();
        }
        TranItemPayload= '['+TranItemPayload+']';
        return TranItemPayload;
    }
    /**********************************************************************************************
    @description  This method is used to create JSON payload to send through HTTP callout body.
    @param TranData [Transaction__c]
    @return String
  	**********************************************************************************************/
    Public Static String CreateTranPayload(Transaction__c TranData){
        		String TransPayload= '';
                JSONGenerator gen = JSON.createGenerator(true);
				gen.writeStartObject();
                gen.writeFieldName('Keys');
                gen.writeStartObject();
                gen.writeObjectField('TransactionItemID',TranData.Id);
                gen.writeEndObject();
                gen.writeFieldName('Values');
                gen.writeStartObject();
                gen.writeObjectField('TotalCost',TranData.Transaction_Cost__c);
                gen.writeObjectField('TotalDiscount',TranData.Total_Discount__c);
                gen.writeObjectField('TransactionDate',TranData.CreatedDate);
                gen.writeEndObject();
            	gen.writeEndObject(); 
                TransPayload = TransPayload + gen.getAsString();
        return TransPayload;
    }
    /**********************************************************************************************
    @description  This method is used to create Http Callouts to the external systems.
    @param TranItemIds [Set<Id> ]
    @return
  	**********************************************************************************************/
    @future(callout=True)
    public Static void SendTranDataRest(Set<Id> TranItemIds){
        	//Due to salesforce limitation of the future method need to pass only premetive datatypes Set<id>. Based on that records are fetched from the provided Ids.
        	List<Transaction_Item__c> newItemList= [SELECT Id, Name, Item_Cost__c, Item_Name__c,Transaction__r.Id, Transaction__r.Transaction_Count__c,Transaction__r.Related_Transaction_Count__c FROM Transaction_Item__c WHERE Id In :TranItemIds];
        	// Map is created to store Transaction Id along with list of related Transaction Item records for future use.
        Map<Id,List<Transaction_Item__c>> TranIdList = new Map<Id,List<Transaction_Item__c>> ();
        //Using for each loop checking wheather a record is already there in map if yes then just add new list item otherwise created new map record.
        for(Transaction_Item__c EachTranItem: newItemList){
            //here checking that if the related transaction count is equal to the tranasaction count on transaction object.
            if(EachTranItem.Transaction__r.Related_Transaction_Count__c==EachTranItem.Transaction__r.Transaction_Count__c){
                if(TranIdList.containsKey(EachTranItem.Transaction__r.Id)==True){
                   List<Transaction_Item__c> TranItemList= TranIdList.get(EachTranItem.Transaction__r.Id);
                    TranItemList.add(EachTranItem);
                    TranIdList.put(EachTranItem.Transaction__r.Id, TranItemList);
                }else{
                    TranIdList.put(EachTranItem.Transaction__r.Id, new list<Transaction_Item__c>{EachTranItem});
                }
            }
        }
		//Looping through the map to create a JSON payload for attaching to the first callout body.
        for(Id TranItemId:TranIdList.keySet()){ 
            //Used for excaption handling.
            try{
                List<Transaction_Item__c> TranItemData= TranIdList.get(TranItemId);
        			String SamplePayload= CreateTranItemPayload(TranItemData);
				// Make first Callout to the external system.
            	Http http1= new Http();
                HttpRequest req1= new HttpRequest();
                //Post reuest method used.
                req1.setMethod('POST');
                //Created a dummy endpoint as we dont have endpoint available at current state & Whitlisted the endpoint in remote site setting already.
             	req1.setEndpoint('https://xyz.com');
                req1.setHeader('Content-Type', 'application/json;charset=UTF-8');
                req1.setBody(SamplePayload);
            	HttpResponse res1 = new HttpResponse();
                //Sending http callout to extenal system.
                res1=http1.send(req1);
            		// Checking if the first rest callout is successful or not & if it is successful then we are making our second callout.
                    if(res1.getStatusCode()==200){
                        Transaction__c Transrec= [Select Id, Name, Transaction_Cost__c,Total_Discount__c, Transaction_Count__c, CreatedDate From Transaction__c Where Id=:TranItemId ];
                        String TransPayload= CreateTranPayload(Transrec);
                        Http http2= new Http();
                        HttpRequest req2= new HttpRequest();
                        req2.setMethod('POST');
                        req2.setEndpoint('https://xyz.com');
                        req2.setHeader('Content-Type', 'application/json;charset=UTF-8');
                        req2.setBody(TransPayload);
                        HTTPResponse res2=new HTTPResponse();
                        res2= http2.send(req2);
                        //If the response is not success then creating a record inside custome erro log object to keep the error log documented. 
                        if(res2.getStatusCode()!=200){
                            Error_Log__c Error= New Error_Log__c();
                            Error.Error_Code__c=res1.getStatusCode();
                            Error.Error_Message__c=res1.getStatus();
                            insert Error;
                        }
                    }else{
                        Error_Log__c Error= New Error_Log__c();
                        Error.Error_Code__c=res1.getStatusCode();
                        Error.Error_Message__c=res1.getStatus();
                        insert Error;
                    }
            }
            //if there is any exception then creating a error log record.
            catch(exception e){
                Error_Log__c Error= New Error_Log__c();

                        Error.Error_Message__c=e.getMessage();
                        insert Error;
            }
        }
    }
	
}