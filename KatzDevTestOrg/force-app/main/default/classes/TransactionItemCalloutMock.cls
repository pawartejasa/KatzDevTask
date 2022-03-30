/**
 * @Author              : Tejas P
 * @description         : TransactionItemCalloutMock to create Mock response for positive scenarios
 * @Modification Log    :
 * -----------------------------------------------------------
 * Date             Author              Details
 * -----------------------------------------------------------
 * 30/03/2022       Tejas P           Created
 **/
@isTest
public class TransactionItemCalloutMock implements HttpCalloutMock {
    /**********************************************************************************************
    @description  This method is to create Mockresponse for Http requests
    @param req [HttpRequest]
    @return HttpResponse
  **********************************************************************************************/
	public HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(200);
        return res;
    }
}