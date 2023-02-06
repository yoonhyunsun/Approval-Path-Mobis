/**
 * Created by hyodongmin on 2022/09/08.
 */

public with sharing class IF_BATCH_START extends IF_Inbound {

    // ***************************************
    // Own data class
    // ***************************************

    /**
     * API Payload request/response
     */
    public class InputPayloadBatch extends IF_Abstract.InputPayload {
        public Boolean disabled;
    }
    public class OutputPayloadBatch extends IF_Abstract.OutputPayload {
        public String status;
        public String reason;
    }

    /**
     * Input / Output innerClass
     * - Request/Response 의 header/payload 를 지정하는 class
     */
    public class InputBatch extends IF_Abstract.InputAbstract {
        private InputPayloadBatch payload = new InputPayloadBatch();
        public override IF_Abstract.InputPayload getPayload() {
            return payload;
        }
        public override void setPayload(IF_Abstract.InputPayload aPayload) {
            payload = (InputPayloadBatch) aPayload;
        }
    }
    public class OutputBatch extends IF_Abstract.OutputAbstract {
        private OutputPayloadBatch payload = new OutputPayloadBatch();
        public override IF_Abstract.OutputPayload getPayload() {
            return payload;
        }
        public override void setPayload(IF_Abstract.OutputPayload aPayload) {
            payload = (OutputPayloadBatch) aPayload;
        }
    }

    /**
     * Body
     * Input / Output Class
     * - Request/Response data 의 전체 구조를 갖는 class
     */
    public class RequestBodyBatch extends IF_Abstract.RequestBodyAbstract {
        private InputBatch request; // = new InputBatch();
        public override IF_Abstract.InputAbstract getRequest() {
            return request;
        }
    }
    public class ResponseBodyBatch extends IF_Abstract.ResponseBodyAbstract {
        private OutputBatch response = new OutputBatch();
        public override IF_Abstract.OutputAbstract getResponse() {
            return response;
        }
    }

    // ***************************************
    // Override
    // ***************************************

    public override void process(IF_Abstract.InputAbstract aInput, IF_Abstract.OutputAbstract aOutput) {
        InputPayloadBatch kInputPayload = (InputPayloadBatch) aInput.getPayload();
        OutputPayloadBatch kOutputPayload = (OutputPayloadBatch) aOutput.getPayload();

        kOutputPayload.t_data = null;
        System.debug('batch disabled: ' + kInputPayload.disabled);
        if (true != kInputPayload.disabled) {
            String kStatus = retrieveJobStatus();

            System.debug(LoggingLevel.WARN, String.format('status -> {0}', new String[]{ kStatus }));

            if ('' == kStatus) {
                kOutputPayload.status = 'S';
                kOutputPayload.reason = '';

                EXEC_ChainContext kContext = new EXEC_ChainContext();
                kContext.enableEmailSending = true;
                EXEC_Manager.first().startChain(kContext);
            } else {
                kOutputPayload.status = 'F';
                kOutputPayload.reason = kStatus;
            }
        } else {
            kOutputPayload.status = 'F';
            kOutputPayload.reason = 'disabled=true';
        }
    }

    @TestVisible
    private static String retrieveJobStatus() {
        // 현재 배치가 실행 중인지 판단.
        // chain 목록 -> 팩토리 를 통해서 배치 클래스 확보, async job object 에서 해당 클래스가 실행 중인지 파악
        List<String> kChains = EXEC_Manager.getChains();
        return EXEC_Util.getChainStatus(EXEC_Util.getChainClassNameSet(kChains));
    }

    public override String getIfId() {
        return IF_FACTORY.IF_BATCH_START;
    }

    public override IF_Abstract.ResponseBodyAbstract getNewResponseBody() {
        return new ResponseBodyBatch();
    }

    public override Object deserialize(String aJson) {
        return (RequestBodyBatch) JSON.deserialize(aJson, RequestBodyBatch.class);
    }

    public override IF_Abstract.T_DATA deserializeOne(String aJson) {
        return null;
    }
}