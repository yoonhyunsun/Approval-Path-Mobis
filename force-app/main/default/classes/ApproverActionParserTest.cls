@isTest
private class ApproverActionParserTest {
    @isTest
    static void testParse() {
        String json = '{'+
		'\"uid\": \"1hu2v3iu123\",'+
		'\"action\": \"approved\",'+
		'\"comment\": \"asdasd\"'+
		'}';
		ApproverActionParser obj = ApproverActionParser.parse(json);
		System.assert(obj != null);
        
    }

    @isTest
    static void testConsumeObject() {
        String json = '{'+
        '\"test\": \"asdasd\"'+
		'}';
		ApproverActionParser obj = ApproverActionParser.parse(json);
		System.assert(obj != null);
        
    }
}