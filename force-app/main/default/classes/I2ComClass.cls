/****************************************************************************************
  * @filename      : I2ComClass
  * @author        : I2MAX
  * @date          : 2020-12-29 오후 5:04
  * @group         : 
  * @group-content : 
  * @description   : 
  * @tester        : I2ComClass_ts.cls
  * @reference     :
  * @release       : v1.0.0
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date                     author              description
  * ===============================================================
    0.1     2020-12-29 오후 5:04      I2MAX               Create
****************************************************************************************/
public with sharing class I2ComClass {
    /**
     * 공통 : 초기화 공통 클래스
     */
    public abstract class InitData {
        @AuraEnabled
        public Map<String, Object> defaultMap = new Map<String, Object>();
    }

    /**
     * 공통 : Select Option 공통 클래스
     */
    public class Option {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public Boolean selected { get; set; }

        public Option(String label, String value) {
            this.label = label;
            this.value = value;
            this.selected = false;
        }
    }

    /**
     * 페이징 공통 클래스
     */
    public virtual class ResData {
        @AuraEnabled
        public Integer totalSize { get; set; }
        @AuraEnabled
        public List<SObject> recordList { get; set; }
        @AuraEnabled
        public Integer recordSize {
            get {
                return this.recordList.size();
            }
            set;
        }

        public ResData(final Integer totalSize, List<SObject> recordList) {
            this.totalSize = totalSize > 2000 ? 2000 : totalSize;
            this.recordList = recordList;
        }
    }
}