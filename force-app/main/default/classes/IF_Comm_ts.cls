/**
 * Created by rudy on 3/10/22.
 */

@IsTest
public with sharing class IF_Comm_ts {

    @IsTest
    public static void testErrorDebug(){
        IF_Comm.errorDebug(new DmlException());
    }

    @IsTest
    public static void testErrorText(){
        String error = IF_Comm.errorText(new DmlException('message'));
        System.assert(error.contains('Message'));
        System.assert(error.contains('Stack trace'));
    }

    @IsTest
    public static void testGiveAGGR(){
        Pattern myPattern = Pattern.compile('[\\w]{8}-[\\w]{4}-[\\w]{4}-[\\w]{4}-[\\w]{12}');
        Matcher myMatcher = myPattern.matcher(IF_Comm.giveAGGR());
        System.assert(myMatcher.matches());
    }
}