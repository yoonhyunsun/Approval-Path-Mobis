/**
 * 외부로 Web callout 기초 클래스, 생성자로 전달받는 {@link IF_OutboundIRequester} 를 적당히 구현해 인증, 요청을 처리한다.
 * 
 * Created by hyodongmin on 2022/07/28.
 */
public abstract class IF_Outbound extends IF_Abstract implements IF_OutboundIDeserializer {
    public final static Integer RESULT_CODE_END = -1;
    public final static Integer RESULT_CODE_ERROR = -2;
    public final static Integer RESULT_CODE_FAIL = -3;

    private String endpointUrl;
    private Boolean isSkipped;
    private Id ifInfoId;
    
    private final IF_OutboundIRequester requester;

    /**
     * constructor
     * (endpoint URL setting)
     */
    public IF_Outbound(IF_OutboundIRequester aRequester) {
        requester = aRequester;
        init();
    }

    protected virtual void init() {
        String kIfId = getIfId();
        System.debug(kIfId + ' call');
        IF_INFO__c ifInfo = getIfInfo(kIfId);  // DML
        setIfUrl(ifInfo.URL__c);
        setSkip(ifInfo.IsSkip__c);
        setInfoId(ifInfo.Id);
        System.debug(ifInfo.TITLE__c + ' call start');
    }

    @TestVisible
    protected String getIfUrl() {
        return endpointUrl;
    }

    @TestVisible
    protected void setIfUrl(String aUrl) {
        endpointUrl = aUrl;
    }

    @TestVisible
    protected Boolean isSkip() {
        return isSkipped;
    }

    @TestVisible
    protected void setSkip(Boolean aBool) {
        isSkipped = aBool;
    }

    @TestVisible
    protected Id getInfoId() {
        return ifInfoId;
    }

    @TestVisible
    protected void setInfoId(Id aId) {
        ifInfoId = aId;
    }

    // ***************************************
    // public
    // ***************************************
    /**
     * 
     * @param aAggregation request 인식 코드, 페이지만 다른 동일한 요청일 경우 같은 값을 갖는다.
     *
     * @return IF_Outbound.Result
     */

    public virtual IF_Outbound.Result execute(String aAggregation) {
        if (isSkip()) {
            String kMsg = getIfId() + ', skipped by IF_INFO settings.';
            IF_Util.logSimple(getIfId(), kMsg, getInfoId());
            System.debug(LoggingLevel.WARN, kMsg);

            IF_Outbound.Result kResult = new IF_Outbound.Result();
            kResult.message = kMsg;
            kResult.code = RESULT_CODE_END;
            return kResult;
        } else {
            return performExecute(getNewRequestBody(), aAggregation);
        }
    }

    // ***************************************
    // protected
    // ***************************************

    /**
     * perform web call out
     * 
     * @param aRequestBody RequestBody
     * @param aAggregation request 인식 코드, 페이지만 다른 동일한 요청일 경우 같은 값을 갖는다.
     *
     * @return IF_Outbound.Result code: 요청 결과 코드, 추가 요청이 필요한 경우 양수, 끝이라면 -1 (RESULT_CODE_END),
     * 에러 시 -2 (RESULT_CODE_ERROR), 통신 실패 -3 (RESULT_CODE_ERROR)
     */
    @TestVisible
    protected virtual IF_Outbound.Result performExecute(RequestBodyAbstract aRequestBody, String aAggregation) {
        ResponseBodyAbstract outputObj = null;

        String kReq = null;
        String kRes = null;
        InputAbstract kInputReq = aRequestBody.getRequest();
        OutputAbstract kOutputRes = null ;

        String kIfId = getIfId();
        IF_Outbound.Result kOutboundResult = new IF_Outbound.Result();
        kOutboundResult.code = RESULT_CODE_END;
        String kEndpoint;

        try {
            // 로그 timeTemp, Request_to_DIH_Time 세팅
            logInit('SND');

            kInputReq.header = new IF_Base.InputHeader(kIfId);

            // 로그 MSGGID, IFID, IFDATE 세팅
            logStart(kInputReq.header);

            processBefore(kInputReq, aAggregation);

            // callout 전 데이터 설정, {request: {header:{}, body:{}}}
            processPre(kInputReq);

            // JSON TO STRING
            kReq = serialize(aRequestBody);

            // 로그 input, Request_Processing_Time 세팅
            logProcess(IF_Base.LOG_STEP1, kReq);

            kEndpoint = getIfUrl();

            HttpRequest kHttpReq = prepareRequest(kReq, kEndpoint);
            // STRING(JSON) TO OBJECT
            IF_OutboundRequesterResult kResult = requester.request(kHttpReq, this);
            kRes = kResult.raw;

            logProcess(LOG_STEP1_1, kResult.raw);

            outputObj = (ResponseBodyAbstract) kResult.body;

            kOutputRes = outputObj.getResponse();

            IF_Base.InputHeader kHeader = kOutputRes.header;

            // callout 후 데이터 처리
            kOutboundResult.code = doPostProcessIfCalloutSuccess(kHeader.ifResult, kInputReq, kOutputRes);

            if (kOutboundResult.code == RESULT_CODE_FAIL) {  // 실패일 경우 response body 를 첨부
                kOutboundResult.message = 'Result: ' + kOutputRes.header.ifResult + '\n'
                        + 'Fail code: ' + kOutputRes.header.ifFailCode + '\n'
                        + 'Fail message: ' + kOutputRes.header.ifFailMsg;
            }

            kInputReq.header.ifResult = IF_Base.RESULT_SUCCESS;

        } catch (Exception e) {
            // 에러내용 debug 출력
            IF_Comm.errorDebug(e);

            if (null == outputObj || null == outputObj.getResponse()) {
                outputObj = getNewResponseBody();
            }

            kOutputRes = outputObj.getResponse();

            // 내부오류의 경우 ResultCode 'E'로
            kOutputRes.header = new IF_Base.InputHeader(kInputReq.header.ifTrackingId, kIfId, kInputReq.header.ifDateTime);

            // error header value setup
            kOutputRes.header = setOutputHeader(kOutputRes.header, kInputReq.header, e);
            String kEndPointLog = 'Endpoint: ' + kEndpoint;
            kOutputRes.header.ifFailMsg = appendErrorMessage(kOutputRes.header.ifFailMsg, kEndPointLog);

            kOutboundResult.code = RESULT_CODE_ERROR;
            kOutboundResult.message = e.getMessage();
        }
        // 로그 Response_Processing_Time, Response_from_DIH_Time 세팅
        logProcess(IF_Base.LOG_STEP2, kRes);
        kRes = '';
        // 로그 파일 및 row insert
        // IF_Base.logEnd(outputRes.header);
        IF_LOG__c kLog = returnLogParams(kInputReq, kOutputRes);
        logEnd(kOutputRes.header, kLog.ifAggregation__c, kLog.ifTotCnt__c, kLog.ifSplitCnt__c, kLog.ifSplitSeq__c, kLog.ifRcvCnt__c);

        return kOutboundResult;
    }

    @TestVisible
    protected Integer doPostProcessIfCalloutSuccess(String aResult, InputAbstract aInputReq, OutputAbstract aOutputRes) {
        if (getSuccessCode().equals(aResult)) {
            return processPost(aInputReq, aOutputRes);    // -1, 또는 1 이상의 수 반환
        }
        return RESULT_CODE_FAIL;   // API 통신에 실패함
    }

    @TestVisible
    protected virtual String getSuccessCode() {
        return IF_Base.RESULT_SUCCESS;
    }

    @TestVisible
    private static String appendErrorMessage(String body, String aLog) {
        if (String.isNotEmpty(body)) {
            return body + '\n' + aLog;
        } else {
            return aLog;
        }
    }

    // ***************************************
    // protected
    // ***************************************
    /**
     * Request 시 공통 부분 처리, 필요 시 Override
     *
     * @param aInput Request body
     * @param aAggregation request 인식 코드, 페이지만 다른 동일한 요청일 경우 같은 값을 갖는다.
     */
    @TestVisible
    protected virtual void processBefore(IF_Abstract.InputAbstract aInput, String aAggregation) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();

        kInputPayload.ifAggregation = aAggregation;
    }

    // ***************************************
    // abstract, virtual
    // ***************************************

    /**
     *  처리 전 Request data 를 처리한다.
     *
     * @param aInput InputBase 의 구현체
     */
    @TestVisible
    protected abstract void processPre(IF_Abstract.InputAbstract aInput);

    /**
     * Request body 직렬화
     *
     * @param aRequestBody RequestBodyAbstract
     *
     * @return String
     */
    @TestVisible
    protected virtual String serialize(RequestBodyAbstract aRequestBody) {
        return JSON.serialize(aRequestBody, true);
    }

    /**
     * 인터페이스에 알맞는 HttpRequest 생성
     *
     * @param aReqBody Body string
     * @param aEndPoint Interface url without base URL. ex> '/extra/sfdc/lorem/ipsum'
     *
     * @return HttpRequest
     */
    @TestVisible
    protected abstract HttpRequest prepareRequest(String aReqBody, String aEndPoint);

    /**
     * Response data 를 역직렬화한다.
     * 
     * @param aJson HTTP response body
     * @return Object class 로 역직렬화하여 반환, IF_Abstract.ResponseBodyAbstract
     */
    public virtual override Object deserialize(String aJson) {
        IF_Abstract.ResponseBody kResponseBody = (IF_Abstract.ResponseBody) JSON.deserialize(aJson, IF_Abstract.ResponseBody.class);
        if(null != kResponseBody?.getResponse()?.getPayload()) {
            Map<String, Object> kDataMap = (Map<String, Object>) JSON.deserializeUntyped(aJson);
            Map<String, Object> kPayload = (Map<String, Object>) ((Map<String, Object>) kDataMap.get('response')).get('payload');
            ((IF_Abstract.OutputPayload) kResponseBody.getResponse().getPayload()).t_data = deserializePayloadData(kPayload);
        }
        return kResponseBody;
    }

    /**
     * 처리 후 Response data 를 처리한다.
     * 
     * @param aInput InputBase 의 구현체
     * @param aOutput OutputBase 의 구현체
     * @return 다음 페이지가 있다면 페이지 번호, 없다면 -1
     */
    @TestVisible
    protected abstract Integer processPost(InputAbstract aInput, OutputAbstract aOutput);
    
    // ***************************************
    // Inner Class
    // ***************************************
    public class Result {
        /**
         * 요청 결과 코드, 추가 요청이 필요한 경우 양수, 끝이라면 -1 (RESULT_CODE_END),
         * 에러 시 -2 (RESULT_CODE_ERROR), 통신 실패 -3 (RESULT_CODE_ERROR)
         */
        public Integer code = 0;
        public String message = '';
    }
}