/**
 * Created by changheekim on 2022/11/07.
 */

public with sharing class DevelopmentPartsVolumesWrapper {
    public String key;
    public Value value;
    public String className;

    public class Value{
        public String id;
        public String name;
        public String vehicleVolume;
        public String optionRate;
        public String mobisProductVolume;
        public String cost;
        public String crRate;
        public String totalAmount;
        public String relevantYear;
        public String devPartsId;
        public String usage;
    }
    public static DevelopmentPartsVolumesWrapper parse(String json) {
        return (DevelopmentPartsVolumesWrapper) System.JSON.deserialize(json, DevelopmentPartsVolumesWrapper.class);
    }
}