/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 12-19-2022
 * @last modified by  : Bekhzod Ubaydullaev
**/
@IsTest
public class QuipBatchCalloutMockTest implements HttpCalloutMock {
  public HttpResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(
      '{"bekhzod.ubaydullaev@i2max.co.kr": {"name": "Ubaydullaev Bekhzod", "id": "GKRAEAWqVaN"},"javoxabi@i2max.co.kr": {"name": "Javoxir Xabibullayev","id": "TGIAEA8MBLb"}}'
    );
    res.setStatusCode(200);
    return res;
  }
}