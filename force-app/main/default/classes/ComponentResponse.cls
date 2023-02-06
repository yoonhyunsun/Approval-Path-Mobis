/****************************************************************************************
 * @author            byeon jw
 * @date              2020-06-03
 * @group             Common
 * @description       컴포넌트 응
  
 * Modification Log
 * ===============================================================
 * Ver     Date                Author              Modification
 * ===============================================================
   0.1     2020-06-03             byeon jw            Create
****************************************************************************************/
public virtual class ComponentResponse {
    @AuraEnabled
    public Map<String, Object> data { get; set; }

    public ComponentResponse() {
        this.data = new Map<String, Object>();
    }

    public ComponentResponse setData(String key, Object value) {
        this.data.put(key, value);
        return this;
    }
    public ComponentResponse setData(Map<String, Object> keyValues) {
        this.data.putAll(keyValues);
        return this;
    }
    public Object getData(String key) {
        return this.data.get(key);
    }
}