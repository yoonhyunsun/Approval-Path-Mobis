/****************************************************************************************
  * @filename      : CommonBase_ts
  * @projectname   : HMID DMS
  * @author        : i2max_Byeon.jw
  * @date          : 2020-07-17 오후 1:13
  * @group         : Sales
  * @description   :
  * @reference     :
  * @modification Log
  * ===============================================================
  * ver     date                author              description
  * ===============================================================
    0.1     2020-07-17 오후 1:13     i2max_Byeon.jw       Create
****************************************************************************************/
@IsTest
private class CommonBase_Test {
    // Test Case 02 : Object Describe 조회
    @IsTest
    private static void testCase002() {
        ComponentResponse response = CommonBase.getSObjectDescribe(new List<String>{ 'Account' });
    }
    // Test Case 03 : 현재사용자 정보 조회
    @IsTest
    private static void testCase003() {
        Boolean isAdmin = CommonBase.isCurrentUserIsAdmin();
        Boolean isPartner = CommonBase.isCurrentUserIsPartner();
    }
}