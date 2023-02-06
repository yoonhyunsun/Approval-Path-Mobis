/**
 * Created by changheekim on 2022/11/07.
 */

public with sharing class DevelopmentPartsWrapper {

    public String developmentId;
    public String id;
    public Integer mobisTotal;
    public String name;
    public String pinNumber;
    public String totalAmount;
    public Integer vehicleTotal;
    public String checked;
    public String description;
    public String className;

    public static DevelopmentPartsWrapper parse(String json) {
        return (DevelopmentPartsWrapper) System.JSON.deserialize(json, DevelopmentPartsWrapper.class);
    }
}