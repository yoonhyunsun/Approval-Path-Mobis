/**
 * @description       :
 * @author            : Bekhzod Ubaydullaev
 * @group             :
 * @last modified on  : 12-19-2022
 * @last modified by  : Bekhzod Ubaydullaev
 **/
@IsTest
public class QuipAPITest {
  @IsTest
  static void testCallouts() {
    QuipDTO quipDto = new QuipDTO();
    quipDto.threadId = 'quipId';
    QuipDTO result;
    String excpt, Id;
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new QuipCalloutMockTest());
    try {
      result = QuipAPI.checkDocUpdate(quipDto);
      result = QuipAPI.retrievePDF(quipDto);
      result = QuipAPI.createPdfRequest(quipDto, 'opportunityId');
      Id = QuipAPI.idFromUrl('https://corp.quip.com/klUsAqWxr8Ne');
      QuipAPI.lockThread('mobis/quip/test', true);
    } catch (Exception e) {
      excpt = e.getMessage();
    }
    Test.stopTest();
    System.assertNotEquals(null, result);
    System.assertEquals('klUsAqWxr8Ne', Id);
    System.assert(String.isBlank(excpt));
  }

  @IsTest
  static void testParser() {
    QuipDTO quipDto = new QuipDTO();
    quipDto.threadId = 'quipId';
    QuipDTO result;
    result = QuipAPI.checkResponseBody(quipDto, null);
    result = QuipAPI.checkResponseBody(
      quipDto,
      '{"thread": {"updated_usec": 1519926805974011}}'
    );
    result = QuipAPI.checkResponseBody(
      quipDto,
      '{"thread": {"created_usec": 1519926805974011}}'
    );
    result = QuipAPI.checkResponseBody(quipDto, '{"request_id": 12345}');
    result = QuipAPI.checkResponseBody(quipDto, '{"status": "processing"}');
    result = QuipAPI.checkResponseBody(quipDto, '{"error" : "no quip file"}');
    System.assertNotEquals(null, result);
  }

  @IsTest
  static void testQuipId() {
    Test.setMock(HttpCalloutMock.class, new QuipBatchCalloutMockTest());
    Map<String, String> result;
    Test.startTest();
    Map<String, String> teamUserMap = new Map<String, String>();
    teamUserMap.put('Id', 'bekhzod.ubaydullaev@i2max.co.kr');
    result = QuipAPI.getQuipId(teamUserMap);
    Test.stopTest();
    System.assertEquals(result.get('Id'), 'GKRAEAWqVaN');
  }

  @TestSetup
  static void makeData() {
    TestFactory.createCustomSetting();
  }
}