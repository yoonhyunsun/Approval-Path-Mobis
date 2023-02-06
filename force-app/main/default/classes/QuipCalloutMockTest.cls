/**
 * @description       : 
 * @author            : Bekhzod Ubaydullaev
 * @group             : 
 * @last modified on  : 11-22-2022
 * @last modified by  : Bekhzod Ubaydullaev
**/
@IsTest
public class QuipCalloutMockTest implements HttpCalloutMock {
  public HttpResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(
      '{"thread": {"author_id": "LJa9EAtQi98","created_usec": 1519926805974011,"id": "AVN9AAeqq5w","is_template": false,"link": "https://corp.quip.com/klUsAqWxr8Ne","owning_company_id": "IMbAcASGu56","secret_path": "klUsAqWxr8Ne","title": "❗️ very important cat pics ❗️","type": "DOCUMENT","updated_usec": 1558224928731511}}'
    );
    res.setStatusCode(200);
    return res;
  }
}