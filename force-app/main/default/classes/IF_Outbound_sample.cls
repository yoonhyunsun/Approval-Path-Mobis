/**
 * Created by hyodongmin on 2022/08/05.
 */

public with sharing class IF_Outbound_sample extends IF_Outbound {
    
    public IF_Outbound_sample(IF_OutboundIRequester aRequester){
        super(aRequester);
    }
    
    // ***************************************
    // Own data class
    // ***************************************
    public virtual class T_DATA3 extends IF_Abstract.T_DATA{
        public String updateDt; // 레코드 마지막 수정 일시 ex> 2022-04-03 12:34:00
    }
    
    // ***************************************
    // override
    // ***************************************

    @TestVisible
    protected override void processPre(IF_Abstract.InputAbstract aInput) {
        aInput.getPayload().t_data = null;
    }

    @TestVisible
    protected override HttpRequest prepareRequest(String aReqBody, String aEndPoint) {
        HttpRequest kHttpReq = new HttpRequest();
        kHttpReq.setMethod('POST');
        kHttpReq.setHeader('Content-Type', 'application/json');
        kHttpReq.setHeader('Accept', 'application/json');
        kHttpReq.setEndpoint(aEndPoint);    // Interface url without base URL. ex> '/extra/sfdc/lorem/ipsum'
        kHttpReq.setBody(aReqBody);     // body string

        return kHttpReq;
    }

    @TestVisible
    protected override Integer processPost(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        System.debug('sample response: ' + aOutput);
        return RESULT_CODE_END;
    }

    public override String getIfId() {
        return 'IF_OUTBOUND_SAMPLE';
    }

    public override Object deserialize(String aJson) {
        return super.deserialize(aJson);
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return (T_DATA3) JSON.deserialize(aJson, T_DATA3.class);
    }
}