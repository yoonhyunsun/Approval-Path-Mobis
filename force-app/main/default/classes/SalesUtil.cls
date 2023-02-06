/***************************************************************************************
 * Project Name : Hyundai Mobis
 * File Name    : SalesUtil
 * Description  :
 * Copyright    : Copyright © I2max. All Rights Reserved. 2022
 * Author       : KyeJin Cheong
 * Created Date : 2022-11-08
 ****************************************************************************************/

public inherited sharing class SalesUtil {
  /**
   * @return Proforma CSV External ID
   * @description 코드 수정 - CSV 파일 내 중복값 확인되어서 코드 수정 (외부키 Medium Product Group, Small Product Group)
   */
  public static String getProformaCSVExternalKey(Decimal index, String vehicleProject, String mediumProductGroup, String smallProductGroup) {
    return index + '-' + vehicleProject + '-' + mediumProductGroup + '-' + smallProductGroup;
  }

  /**
   * @return Proforma External ID
   * @description 코드 수정 - CSV 파일 내 중복값 확인되어서 코드 수정 (외부키 Medium Product Group, Small Product Group)
   */
  public static String getProformaExternalKey(Decimal index, String vehicleProject, String mediumProductGroup, String smallProductGroup, Integer relevantYear, Integer oemVehicleVolume, Integer optionRate, Integer piecePrice) {
    return index + '-' + vehicleProject + '-' + mediumProductGroup + '-' + smallProductGroup + '-' + relevantYear + '-' + oemVehicleVolume + '-' + optionRate + '-' + piecePrice;
  }

  /**
   * @description 필드셋 반환
   * @param fieldSetName 필드셋 명
   * @param ObjectName sobject 명
   *
   * @return 필드셋 리스트
   */
  public static List<Schema.FieldSetMember> getFieldSet(
    String fieldSetName,
    String ObjectName
  ) {
    Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();

    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.fieldSets.getMap()
      .get(fieldSetName);

    return fieldSetObj.getFields();
  }

  /**
   * @return Planning External Key
   */
  public static String getPlanningExternalKey(Integer year, Integer index) {
    return year + '-' + index;
  }
}