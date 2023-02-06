/**
 * MOBIS 전자결재 미결문서 등록 https://one.mobis.co.kr/WSAS400/AS400.asmx
 * Created by hyodongmin on 2022/09/26.
 */

public without sharing class IF_SFDC_ONE_APPROVAL extends IF_Outbound {
    final DataOneApproval data;
    final String acntCnt;

    /**
     * @param aRequester IF_OutboundIRequester, 대부분 new IF_OutboundBasicRequester() 를 사용한다.
     * @param aData DataOneApproval
     * @param aAcntCnt '1' = 알림 등록, '0' = 알림 삭제
     */
    public IF_SFDC_ONE_APPROVAL(IF_OutboundIRequester aRequester, DataOneApproval aData, String aAcntCnt) {
        super(aRequester);
        data = aData;
        acntCnt = aAcntCnt;
    }
    // ***************************************
    // Own data class
    // ***************************************
    /**
     * API Payload request/response
     */
    public class DataOneApproval extends IF_Abstract.T_DATA {
        public String APPTYP = 'CR'; //시스템Flag = 'CR'
        public String APPNAM = 'CRM'; //시스템명 = 'CRM'
        public String DOCNBR; // 문서번호
        public String DOCNAM; // 제목
        public String PEMPNO; // 차기 결재자 사번
        public String PNAME; // 상신자 이름
        public String DOCDTE; // 기안일자
        public String APPURL; // 링크 URL
        public String APPARA; // 파라미터
    }
    public class InputDataOneApproval {
        public String ACNT_CNT;
        public DataOneApproval input;
    }
    public class OutputDataOneApproval {
    }
    public class InputPayloadOneApproval extends IF_Abstract.InputPayload {
        public InputDataOneApproval t_data;
        {
            super.t_data = null;
        }
    }
    public class OutputPayloadOneApproval extends IF_Abstract.OutputPayload {
        public OutputDataOneApproval t_data;
        {
            super.t_data = null;
        }
    }

    /**
     * Input / Output innerClass
     * - Request/Response 의 header/payload 를 지정하는 class
     */
    public class InputOneApproval extends IF_Abstract.InputAbstract {
        private InputPayloadOneApproval payload = new InputPayloadOneApproval();
        public override IF_Abstract.InputPayload getPayload() {
            return payload;
        }
        public override void setPayload(IF_Abstract.InputPayload aPayload) {
            payload = (InputPayloadOneApproval) aPayload;
        }
    }
    public class OutputOneApproval extends IF_Abstract.OutputAbstract {
        private OutputPayloadOneApproval payload = new OutputPayloadOneApproval();
        public override IF_Abstract.OutputPayload getPayload() {
            return payload;
        }
        public override void setPayload(IF_Abstract.OutputPayload aPayload) {
            payload = (OutputPayloadOneApproval) aPayload;
        }
    }
    /**
     * Body
     * Input / Output Class
     * - Request/Response data 의 전체 구조를 갖는 class
     */
    public class RequestBodyOneApproval extends IF_Abstract.RequestBodyAbstract {
        private InputOneApproval request = new InputOneApproval();
        public override IF_Abstract.InputAbstract getRequest() {
            return request;
        }
    }
    public class ResponseBodyOneApproval extends IF_Abstract.ResponseBodyAbstract {
        private OutputOneApproval response = new OutputOneApproval();
        public override IF_Abstract.OutputAbstract getResponse() {
            return response;
        }
    }

    // ***************************************
    // Override
    // ***************************************

    @TestVisible
    protected override String getSuccessCode() {
        return 'Z'; // 성공 코드 'Z'
    }

    // {request: {header:{}, body:{}}}
    public override void processPre(IF_Abstract.InputAbstract aInput) {
        InputOneApproval kInput = (InputOneApproval) aInput;
        InputPayloadOneApproval kPayload = (InputPayloadOneApproval) kInput.getPayload();

        kPayload.t_data = new InputDataOneApproval();
        kPayload.t_data.ACNT_CNT = acntCnt;
        kPayload.t_data.input = this.data;

        System.debug(' request payload -> ' + kPayload);
    }

    /**
     * Request 전 Header 설정
     *
     * @param aReqBody body
     * @param aEndPoint end point url without domain prefix
     *
     * @return HttpRequest
     */
    @TestVisible
    protected override HttpRequest prepareRequest(String aReqBody, String aEndPoint) {
        HttpRequest kHttpReq = new HttpRequest();
        kHttpReq.setMethod('POST');
        kHttpReq.setHeader('Content-Type', 'application/json; charset=utf-8');
        kHttpReq.setHeader('Accept', 'application/json;');
        kHttpReq.setEndpoint(aEndPoint);    // Interface url without base URL. ex> '/extra/sfdc/lorem/ipsum'
        kHttpReq.setBody(aReqBody);     // body string

        return kHttpReq;
    }

    @TestVisible
    protected override Integer processPost(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
//        IF_SFDC_ONE_APPROVAL.OutputOneApproval kOutput = (IF_SFDC_ONE_APPROVAL.OutputOneApproval) aOutput;
        return RESULT_CODE_END;
    }

    public override IF_Abstract.RequestBodyAbstract getNewRequestBody() {
        return new RequestBodyOneApproval();
    }
    public override IF_Abstract.ResponseBodyAbstract getNewResponseBody() {
        return new ResponseBodyOneApproval();
    }

    public override String getIfId() {
        return IF_FACTORY.IF_SFDC_ONE_APPROVAL;
    }

    /**
     * Response data 를 역직렬화한다.
     *
     * @param aJson HTTP response body
     * @return Object class 로 역직렬화하여 반환, IF_Abstract.ResponseBodyAbstract
     */
    public override Object deserialize(String aJson) {
        ResponseBodyOneApproval kResponseBody = (ResponseBodyOneApproval) JSON.deserialize(aJson, ResponseBodyOneApproval.class);
        return kResponseBody;
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return null;
    }
}