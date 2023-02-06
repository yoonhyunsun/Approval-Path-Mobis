/**
 * Created by changheekim on 2022/09/22.
 */

public with sharing class OpportunitySalesPartsVolumeWrapper {
    public String key;
    public Value value;
    public String className;

    public class Value {
        public String id;
        public String name;
        public String cost;
        public String crRate;
        public String mobisProductVolume;
        public String optionRate;
        public String relevantYear;
        public String salesPartsId;
        public String totalAmount;
        public String usage;
        public String vehicleVolume;
        public Boolean yearRange;
        public String pvCurrency;
    }
    public static OpportunitySalesPartsVolumeWrapper parse(String json) {
        return (OpportunitySalesPartsVolumeWrapper) System.JSON.deserialize(json, OpportunitySalesPartsVolumeWrapper.class);
    }
}