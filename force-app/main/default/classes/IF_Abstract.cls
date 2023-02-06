/**
 * Created by hyodongmin on 2022/07/27.
 */

public abstract class IF_Abstract extends IF_Base {

    @TestVisible
    protected final Integer countPerPage;

    public IF_Abstract() {
        this.countPerPage = 2000;
    }

    public IF_Abstract(Integer aCountPerPage) {
        this.countPerPage = aCountPerPage;
    }

    // ***************************************
    // Input/Output body base class
    // ***************************************

    /**
     * API Payload request
     */
    public virtual class PayloadBase {
        public String ifAggregation ;
    }

    /**
     * API Payload request
     */
    public virtual class PayloadBaseInput extends PayloadBase {
        public String ifTotCnt ;
        public String ifSplitCnt ;
        public String ifSplitSeq ;
    }

    /**
     * API Payload response
     */
    public virtual class PayloadBaseOutput extends PayloadBase {
        public String ifRcvCnt;
    }

    // ***************************************
    // abstract data class
    // ***************************************

    /**
     * Data Object 의 기초
     */
    public virtual class T_DATA {
    }

    /**
     * Request payload
     */
    public virtual class InputPayload extends PayloadBaseInput {
        public List<T_DATA> t_data = new List<T_DATA>();
    }

    /**
     * Response payload
     */
    public virtual class OutputPayload extends PayloadBaseOutput {
        public List<T_DATA> t_data = new List<T_DATA>();
    }

    public abstract class HeaderAbstract {
        public InputHeader header { get; set; }
        public HeaderAbstract() {
            header = new InputHeader2();
        }
    }

    /**
     * Input / Output innerClass
     * - Request/Response 의 header/payload 를 지정하는 class
     */
    public abstract class InputAbstract extends HeaderAbstract {
        public abstract InputPayload getPayload();
        public abstract void setPayload(InputPayload aPayload);
    }
    public abstract class OutputAbstract extends HeaderAbstract {
        public abstract OutputPayload getPayload();
        public abstract void setPayload(OutputPayload aPayload);
    }

    /**
     * Body
     * Input / Output Class
     * - Request/Response data 의 전체 구조를 갖는 class
     */
    public abstract class RequestBodyAbstract {
        public abstract InputAbstract getRequest();
    }
    public abstract class ResponseBodyAbstract {
        public abstract OutputAbstract getResponse();
    }

    // ***************************************
    // Concrete data class
    // ***************************************
    public virtual class InputHeader2 extends InputHeader {
        public String SYNC_IP;  // sync시스템의 DB IP
        public String SYNC_DT;  // sync날짜(yyyymmddhhmmss)
        public String FLAG; // "sync성공여부 (Y:성공,E:에러,N:예외)"
        public String DESC_reserved916; // sync오류원인
        public String ifMessage;
        public InputHeader2(){
        }
        public InputHeader2(String aTaskId){
            super(aTaskId);
        }
        public InputHeader2(String aTrackingId, String aTaskId, String aIfDatetime) {
            super(aTrackingId, aTaskId, aIfDatetime);
        }
    }
    public class Input extends InputAbstract {
        private InputPayload payload = new InputPayload();
        public override InputPayload getPayload() {
            return payload;
        }
        public override void setPayload(InputPayload aPayload) {
            payload = aPayload;
        }
    }
    public class Output extends OutputAbstract {
        private OutputPayload payload = new OutputPayload();
        public override OutputPayload getPayload() {
            return payload;
        }
        public override void setPayload(OutputPayload aPayload) {
            payload = aPayload;
        }
    }
    public class RequestBody extends RequestBodyAbstract {
        private Input request = new Input();
        public override InputAbstract getRequest() {
            return request;
        }
    }
    public class ResponseBody extends ResponseBodyAbstract {
        private Output response = new Output();
        public override OutputAbstract getResponse() {
            return response;
        }
    }

    // ***************************************
    // virtual method
    // ***************************************

    /**
     * HTTPS Request Body
     * @return IF_Abstract.RequestBody
     */
    public virtual RequestBodyAbstract getNewRequestBody() {
        return new RequestBody();
    }

    /**
     * HTTPS Response Body
     * @return IF_Abstract.ResponseBody
     */
    public virtual ResponseBodyAbstract getNewResponseBody() {
        return new ResponseBody();
    }

    // ***************************************
    // abstract method
    // ***************************************

    /**
     * IFID 반환. 이것으로 IF_INFO 에서 정보를 가져온다.
     * 
     * @return IFID
     */
    public abstract String getIfId();

    /**
     * Request/Response data 를 역직렬화한다.
     * 
     * @param aJson HTTP request/response body
     * @return Object class 로 역직렬화하여 반환
     */
    public abstract Object deserialize(String aJson);

    /**
     * T_DATA 를 각 클래스에서 별도 정의하므로, 그에 맞는 Object 로 변환하도록 구현한다.
     * 
     * @param aJson 각 인터페이스 클래스에서 T_DATA 를 상속하여 정의한 데이터의 JSON 문자열
     *
     * @return 각 인터페이스 클래스에서 T_DATA 를 확장한 클래스
     */
    public abstract T_DATA deserializeOne(String aJson);
    // ***************************************
    // protected
    // ***************************************

    /**
     * 1회 처리 가능한 수를 반환한다. Inbound, Outbound 별 설정. Inbound 는 보통 'countPerPage' 의 값으로 설정
     *
     * @param aSize 주어진 데이터 수
     * @return Data 제한 수
     */
    @TestVisible
    protected virtual Integer limitData(Integer aSize) {
        return aSize;
    }

    /**
     * IF_Base.logEnd() 를 처리하기위한 메서드.
     *
     * @param aInput InputBase 의 구현체
     * @param aOutput OutputBase 의 구현체
     * @return 로그에 필요한 파라메터 값  (String ifAggregation, String ifTotCnt, String ifSplitCnt, String ifSplitSeq, String ifRcvCnt)
     */
    @TestVisible
    protected virtual IF_LOG__c returnLogParams(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_LOG__c kLog = new IF_LOG__c();
        if (null != aInput.getPayload()) {
            kLog.ifAggregation__c = aInput.getPayload().ifAggregation;
            kLog.ifTotCnt__c = aInput.getPayload().ifTotCnt;
            kLog.ifSplitCnt__c = aInput.getPayload().ifSplitCnt;
            kLog.ifSplitSeq__c = aInput.getPayload().ifSplitSeq;
        }
        if (null != aOutput.getPayload()) {
            kLog.ifRcvCnt__c = aOutput.getPayload().ifRcvCnt;
        }
        return kLog;
    }

    @TestVisible
    protected List<IF_Abstract.T_DATA> deserializePayloadData(Map<String, Object> kPayload) {
        List<IF_Abstract.T_DATA> kTDataList = null;
        if (null != kPayload && null != kPayload.get('t_data') && kPayload.get('t_data') instanceof List<Object>) {
            kTDataList = new List<IF_Abstract.T_DATA>();
            List<Object> kList = (List<Object>) kPayload.get('t_data');

            for (Object kObj : kList) {
                kTDataList.add(deserializeOne(JSON.serialize(kObj)));
                throwIfDataSizeOver(kTDataList.size(), kList.size());
            }
        }
        return kTDataList;
    }

    protected void throwIfDataSizeOver(Integer aCurrentSize, Integer aTotalSize) {
        Integer kLimit = limitData(aTotalSize);
        if(aCurrentSize > kLimit) {
            throw new IF_Base.IFException('t_data size over. (max: ' + kLimit + ')');
        }
    }

}