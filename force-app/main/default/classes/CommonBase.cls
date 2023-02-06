/****************************************************************************************
 * @author            byeon jw
 * @date              2020-06-04
 * @group             Sales
 * @description       
  
 * Modification Log
 * ===============================================================
 * Ver     Date                Author              Modification
 * ===============================================================
   0.1     2020-06-04             byeon jw            Create
****************************************************************************************/
public without sharing class CommonBase {
    /**
     * 20.06.04 - byeon jw
     * @description SObject Describe 조회
     * @param sObjectTypes {List<String>} SObject Type 목록 ('Account', 'Asset' ... )
     * @return {ComponentResponse} 응답값
     */
    @AuraEnabled
    public static ComponentResponse getSObjectDescribe(List<String> sObjectTypes) {
        ComponentResponse response = new ComponentResponse();

        Map<String, Object> result = new Map<String, Object>();

        if (!sObjectTypes.isEmpty()) {
            List<DescribeSObjectResult> objectDescribes = Schema.describeSObjects(sObjectTypes);
            for (DescribeSObjectResult dsr : objectDescribes) {
                // Object : Label,Value 생성
                Map<String, Object> describeMap = new Map<String, Object>();
                describeMap.put('label', dsr.getLabel());
                describeMap.put('name', dsr.getName());

                // Object Fields : Label,Value 생성
                Map<String, Schema.SObjectField> describeFields = dsr.fields.getMap();
                for (String fieldName : describeFields.keySet()) {
                    Map<String, Object> fieldItem = new Map<String, Object>();

                    Schema.SObjectField field = describeFields.get(fieldName);
                    Schema.DescribeFieldResult dfr = field.getDescribe();

                    fieldItem.put('label', dfr.getLabel());
                    fieldItem.put('name', dfr.getName());

                    // Picklist : Label,Value 생성
                    if (dfr.getType() == Schema.DisplayType.PICKLIST) {
                        List<Schema.PicklistEntry> picklistEntries = dfr.getPicklistValues();
                        List<Map<String, Object>> picklistOptions = new List<Map<String, Object>>();

                        Map<String, Object> initialOptions = new Map<String, Object>();

                        for (Schema.PicklistEntry pe : picklistEntries) {
                            Map<String, Object> picklistItem = new Map<String, Object>();
                            picklistItem.put('label', pe.getLabel());
                            picklistItem.put('value', pe.getValue());

                            picklistOptions.add(picklistItem);
                        }
                        fieldItem.put('picklistOptions', picklistOptions);
                    }
                    describeMap.put(dfr.getName(), fieldItem);
                }
                result.put(dsr.getName(), describeMap);
            }
        }

        response.setData('objectDesc', result);
        return response;
    }
    /**
     * @description 현재 사용자의 시스템 관리자 여부
     *  : 사용자 언어에 따라  표준 'System Administrator' 프로필의 이름이 바뀔수 있으나, 제공되는 API 키가 별도로 존재하지 않음
     * @return {Boolean} 관리자 여부
     */
    @AuraEnabled
    public static Boolean isCurrentUserIsAdmin() {
        Set<String> adminProfiles = new Set<String>{ 'System Administrator', 'SysAdmin', 'SubAdmin' };

        User user = [SELECT Id, Profile.Name, UserType FROM User WHERE Id = :UserInfo.getUserId()];
        return adminProfiles.contains(user.Profile.Name);
    }
    /**
     * @description 현재 사용자의 파트너 사용자 여부
     * @return {Boolean} 파트너 여부
     */
    @AuraEnabled
    public static Boolean isCurrentUserIsPartner() {
        return 'PowerPartner'.equalsIgnoreCase(UserInfo.getUserType());
    }
}