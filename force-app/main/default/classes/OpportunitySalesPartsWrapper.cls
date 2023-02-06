/**
 * Created by changheekim on 2022/09/21.
 */

public with sharing class OpportunitySalesPartsWrapper {

    public String description;
    public String id;
    public Integer lifeCycle;
    public Integer mobisTotal;
    public String name;
    public String opportunityId;
    public String pinNumber;
    public String vehicleProjectId;
    public String productId;
    public String totalAmount;
    public Integer usage;
    public Integer vehicleTotal;
    public Boolean checked;
    public String className;



    public static OpportunitySalesPartsWrapper parse(String json) {
        return (OpportunitySalesPartsWrapper) System.JSON.deserialize(json, OpportunitySalesPartsWrapper.class);
    }
}