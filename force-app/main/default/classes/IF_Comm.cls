/****************************************************************************************
  * @author        : i2max_namho100
  * @date          : 2022-03-10
  *
  * @group         : I/F
  * @group-content : Common
  * @description   : I/F Common class
****************************************************************************************/
public with sharing class IF_Comm{

    public static void errorDebug(Exception e){
        System.debug('Exception type : ' + e.getTypeName());
        System.debug('Message : ' + e.getMessage());
        System.debug('Stack trace : ' + e.getStackTraceString());
    }

    public static String errorText(Exception e){
        String msg = e.getMessage();
        String stackMsg = e.getStackTraceString();
        msg = msg.replaceAll('"', '\'');
        stackMsg = stackMsg.replaceAll('"', '\'');
        String errorText = 'Message : ' + msg + '\n Stack trace : ' + stackMsg;
        return errorText;
    }

    public static String giveAGGR(){
        Blob   b    = Crypto.generateAesKey(128);
        String h    = EncodingUtil.convertToHex(b);
        String guid = h.substring(0,8)+ '-' + h.substring(8,12) + '-' + h.substring(12,16) + '-' + h.substring(16,20) + '-' + h.substring(20);
        return guid;
    }

//    public static String strToDateStr(String yyyymmdd){
//        Integer year = Integer.valueOf( yyyymmdd.subString(0,4) );
//        String month = yyyymmdd.subString(4,6);
//        String day = yyyymmdd.subString(6,8);
//        String newStr;
//
//        // 4000년 이상인경우 4000년으로 치환
//        if(year > 4000){
//            year = 4000;
//            System.debug('[strToDateStr] 9999XXXX: ' + yyyymmdd);
//            month = '12';
//            day = '31';
//        }
//        newStr = String.valueOf(year) + '-' + month + '-' + day;
//        return newStr;
//    }
}