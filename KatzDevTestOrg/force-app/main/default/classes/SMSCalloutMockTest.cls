@isTest
public class SMSCalloutMockTest implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"failed"}');
        res.setStatusCode(400);
        return res;
    }
}