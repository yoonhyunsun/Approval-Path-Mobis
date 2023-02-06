@SuppressWarnings('PMD.CognitiveComplexity,PMD.NcssConstructorCount')
public class ApproverActionParser {
    public String uid { get; set; }
    public String action { get; set; }
    public String comment { get; set; }

    public ApproverActionParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'uid') {
                        uid = parser.getText();
                    } else if (text == 'action') {
                        action = parser.getText();
                    } else if (text == 'comment') {
                        comment = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'ApproverActionParser consuming unrecognized property: ' + text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public static ApproverActionParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new ApproverActionParser(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
}