/**
 * Created by hyodongmin on 2022/07/27.
 */

public abstract class IF_Inbound extends IF_Abstract {
    /**
     * POST 요청 처리
     *
     * @param aRequestJson Request body json
     *
     * @return ResponseBodyAbstract
     */
    public ResponseBodyAbstract onPost(String aRequestJson) {
        String kRes = null;

        RequestBodyAbstract kInputObj = getNewRequestBody() ;
        ResponseBodyAbstract kOutputObj = getNewResponseBody();

        InputAbstract kInputReq = null;
        OutputAbstract kOutputRes = kOutputObj.getResponse();

        String kIfId = getIfId();
        try {
            // 로그 timeTemp, Request_to_DIH_Time 세팅
            logInit('RCV');
            logInputBody(aRequestJson);

            if (String.isBlank(aRequestJson)) {
                throw new IF_Base.IFException('Request body is Empty.');
            }

            kInputObj = (RequestBodyAbstract) deserialize(aRequestJson);

            kInputReq = kInputObj.getRequest();

            // 로그 MSGGID, IFID, IFDATE 세팅
            if (String.isBlank(kInputReq.header.ifDateTime)) {
                kInputReq.header.ifDateTime = Datetime.now().format(IF_Base.FORMAT_DATETIME); // 내부에서 설정
            }
            logStart(kInputReq.header);
            // 로그 input, Request_Processing_Time 세팅
            logProcess(IF_Base.LOG_STEP1, aRequestJson);

            // header value setup
            kOutputRes.header = getHeader(kInputReq.header.ifTrackingId, kIfId, kInputReq.header.ifDateTime);

            // log 저장 후 예외 처리
            if (!kIfId.equals(kInputReq.header.ifId)) {
                throw new IF_Base.IFException('IFID is empty or incorrect.');
            }

            Integer kDataSize = kInputReq?.getPayload()?.t_data?.size();
            if(null != kDataSize) {
                throwIfDataSizeOver(kDataSize, kDataSize);
            }

            processBefore(kInputReq, kOutputRes);

            process(kInputReq, kOutputRes);

            setSuccessResult(kOutputRes);
        } catch (Exception e) {
            // 에러내용 debug 출력
            IF_Comm.errorDebug(e);

            kInputReq = kInputObj.getRequest();

            // 내부오류의 경우 ResultCode 'E'로
            kOutputRes.header = getHeader(kInputReq.header.ifTrackingId, kIfId, kInputReq.header.ifDateTime);

            // error header value setup
            kOutputRes.header = setOutputHeader(kOutputRes.header, kOutputRes.header, e);
            setFailResult(kOutputRes, e);
        }
        kRes = JSON.serialize(kOutputObj, true);

        // 로그 Response_Processing_Time, Response_from_DIH_Time 세팅
        logProcess(IF_Base.LOG_STEP2, kRes);
        // 로그 파일 및 row insert
        // IF_Base.logEnd(outputRes.Header);
        IF_LOG__c kLog = returnLogParams(kInputReq, kOutputRes);
        logEnd(kOutputRes.header, kLog.ifAggregation__c, kLog.ifTotCnt__c, kLog.ifSplitCnt__c, kLog.ifSplitSeq__c, kLog.ifRcvCnt__c);

        clearResponse(kOutputRes);

        return kOutputObj;
    }
    private static IF_Base.InputHeader getHeader(String aTrackingId, String aTaskId, String aIfDatetime) {
        return new InputHeader2(aTrackingId, aTaskId, aIfDatetime);
    }

    // ***************************************
    // protected
    // ***************************************
    protected virtual void setSuccessResult(IF_Abstract.OutputAbstract aOutput) {
        aOutput.header.ifResult = IF_Base.RESULT_SUCCESS;
        ((InputHeader2)aOutput.header).ifMessage = 'Success';
        aOutput.header.ifFailCode = null;
    }

    protected virtual void setFailResult(IF_Abstract.OutputAbstract aOutput, Exception e) {
        ((InputHeader2)aOutput.header).ifMessage = aOutput.header.ifFailMsg;
    }
    /**
     * 로그 저장 후 불필요한 필드 null 처리
     * @param aOutput IF_Abstract.OutputAbstract
     */
    protected virtual void clearResponse(IF_Abstract.OutputAbstract aOutput) {
        aOutput.header.ifFailMsg = null;
    }

    @TestVisible
    protected virtual override Integer limitData(Integer aSize) {
        return countPerPage;
    }
    /**
     * Response 전 공통 처리, 필요 시 Override
     *
     * @param aInput Request body
     * @param aOutput Response body
     */
    @TestVisible
    protected virtual void processBefore(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        IF_Abstract.InputPayload kInputPayload = (IF_Abstract.InputPayload) aInput.getPayload();
        IF_Abstract.OutputPayload kOutputPayload = (IF_Abstract.OutputPayload) aOutput.getPayload();

        kOutputPayload.ifAggregation = kInputPayload.ifAggregation;

        if (null != kInputPayload.t_data) {
            kOutputPayload.ifRcvCnt = String.valueOf(kInputPayload.t_data.size());
        }
    }

    /**
     * Request/Response data 를 역직렬화한다.
     * 
     * @param aJson HTTP request/response body
     * @return Object class 로 역직렬화하여 반환
     */
    public virtual override Object deserialize(String aJson) {
        /*
         * 두 번 파싱하는 이유
         * - IF_Abstract.RequestBody 로는 t_data 각 인터페이스 별로 deserializing 할 수 없다.
         * - 각 인터페이스 데이터를 JSON.deserialize() 로 처리하려면 고유의 Data Object (RequestBody) 가 필요하다.
         * - 인터페이스마다 RequestBody 를 지정하려면 많은 클래스들을 재정의 해줘야한다.
         *
         * 우회 방식
         * - JSON.deserializeUntyped()는 Object 구조와 관계없이 데이터 위주로 파싱한다.
         * - RequestBody 의 공통 부분을 제외한 인터페이스 고유의 데이터만 deserializePayloadData() 로 처리한다.
         * - 각 인터페이스는 deserializeOne() 을 구현하여 자신의 데이터를 처리한다.
         *
         * Payload 구조가 다르다면
         * - Data Object 를 재정의 해야하므로 이 method 도 해당 인터페이스에서 다시 구현한다.
         */
        IF_Abstract.RequestBody kRequestBody = (IF_Abstract.RequestBody) JSON.deserialize(aJson, RequestBody.class);
        if (null != kRequestBody?.getRequest()?.getPayload()) {
            Map<String, Object> kDataMap = (Map<String, Object>) JSON.deserializeUntyped(aJson);
            Map<String, Object> kPayloadMap = (Map<String, Object>) ((Map<String, Object>) kDataMap.get('request')).get('payload');
            ((IF_Abstract.InputPayload) kRequestBody.getRequest().getPayload()).t_data = deserializePayloadData(kPayloadMap);
        }
        return kRequestBody;
    }

    // ***************************************
    // abstract
    // ***************************************

    /**
    * Inbound Request, Response data 를 처리한다.
    * 
    * @param aInput Input 의 구현체
    * @param aOutput Output 의 구현체
    */
    public abstract void process(InputAbstract aInput, OutputAbstract aOutput);
}