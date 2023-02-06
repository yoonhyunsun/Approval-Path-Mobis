/****************************************************************************************
  * @author        : i2max_namho100
  * @date          : 2022-03-10
  *
  * @group         : I/F
  * @group-content : Common
  * @description   : I/F Base
****************************************************************************************/
public virtual without sharing class IF_Base {

    // ***************************************
    // const
    // ***************************************
    public static final String RESULT_SUCCESS = 'S';
    public static final String RESULT_FAIL = 'E';

    public static final String LOG_STEP1 = 'STEP1';
    public static final String LOG_STEP1_1 = 'STEP1-1';
    public static final String LOG_STEP2 = 'STEP2';

    public static final String FORMAT_DATETIME = 'yyyy-MM-dd HH:mm:ss';

    private IF_LOG__c ifLog;
    private IF_INFO__c cachedIfInfo;
    private Long timeTemp;
    @TestVisible
    private String inputBody;
    private String outputBody;

    public Boolean forceLogging = null;

    public class IFException extends Exception {
    }

    public class IF_BaseLogVO {
        public IF_LOG__c log;
        public Blob sndJsonBlob;
        public Blob rcvJsonBlob;

        public IF_BaseLogVO(IF_LOG__c log, String sndJsonBlob, String rcvJsonBlob) {
            this.log = log;

            if (sndJsonBlob == null) {
                sndJsonBlob = '';
            }
            if (rcvJsonBlob == null) {
                rcvJsonBlob = '';
            }
            this.sndJsonBlob = Blob.valueOf(sndJsonBlob);
            this.rcvJsonBlob = Blob.valueOf(rcvJsonBlob);
        }
    }

    /**
     * JSON InputHeader of all request header
     */
    public virtual class InputHeader {
        public String ifId { get; set; }  // External interface id, created automatically, so need logic
        public String ifTrackingId { get; set; }  // This should Unique ID from client system to be used for tracking of transaction from client perspective. GUID for message
        public String ifDateTime { get; set; }  // interface datetime
        public String ifResult { get; set; }  // interface result status
        public String ifFailMsg { get; set; }  // interface result error message
        public String ifFailCode { get; set; }  // interface result error code

        public InputHeader() {
            System.debug('InputHeader Init');
        }

        public InputHeader(String taskId) {
            this.ifId = taskId;
            this.ifResult = null;
            this.ifFailMsg = null;
            this.ifFailCode = null;
            genMsg();
        }
        public InputHeader(String taskId, String iFDateTime) {
            this.ifId = taskId;
            this.ifResult = null;
            this.ifFailMsg = null;
            this.ifFailCode = null;
            this.ifTrackingId = giveGUID();
            this.ifDateTime = iFDateTime;
        }
        public InputHeader(String trackingId, String taskId, String iFDateTime) {
            this.ifTrackingId = trackingId;
            this.ifId = taskId;
            this.ifDateTime = iFDateTime;
        }
        public InputHeader(String trackingId, String taskId, String iFDateTime, String resultCode, String errorMsg, String errorCode) {
            this.ifTrackingId = trackingId;
            this.ifId = taskId;
            this.ifDateTime = iFDateTime;
            this.ifResult = resultCode;
            this.ifFailMsg = errorMsg;
            this.ifFailCode = errorCode;
        }
        public void genMsg() {
            this.ifTrackingId = giveGUID();
            this.ifDateTime = Datetime.now().formatGmt(FORMAT_DATETIME);
        }
        public String giveGUID() {
            return IF_Comm.giveAGGR();
        }
    }

    public virtual class Header {
        public InputHeader header { get; set; }
        public Header() {
            header = new InputHeader();
        }
    }

    public InputHeader setOutputHeader(InputHeader output, InputHeader input) {
        output.ifTrackingId = input.ifTrackingId;

        return output;
    }

    public InputHeader setOutputHeader(InputHeader output, InputHeader input, Exception e) {
        output.ifResult = RESULT_FAIL;
        output.ifFailCode = e.getTypeName();
        output.ifFailMsg = IF_Comm.errorText(e);

        return output;
    }

    public void logInit(String logType) {
        ifLog = new IF_LOG__c();
        timeTemp = System.currentTimeMillis();
        ifLog.Request_to_DIH_Time__c = Datetime.newInstance(timeTemp);
        ifLog.LOG_TYPE__c = logType;
    }

    public void logStart(InputHeader input) {
        ifLog.MSGGUID__c = input.ifTrackingId;
        ifLog.IFID__c = input.ifId;
        ifLog.IFDATE__c = input.ifDateTime;
    }

    /**
     * Inbound 처리 시 body log 가 누락되는 경우가 있어 우선 저장할 필요가 있다.
     *
     * @param aBody Inbound Request body
     */
    public void logInputBody(String aBody) {
        inputBody = aBody;
    }

    public void logProcess(String step, String body) {
        if (LOG_STEP1.equals(step)) {
            inputBody = body;
            ifLog.Request_Processing_Time__c = System.currentTimeMillis() - timeTemp;
            timeTemp = System.currentTimeMillis();
        } else if (LOG_STEP1_1.equals(step)) {
            outputBody = body;
            ifLog.Response_Processing_Time__c = System.currentTimeMillis() - timeTemp;
            ifLog.Response_from_DIH_Time__c = Datetime.newInstance(System.currentTimeMillis());
            timeTemp = System.currentTimeMillis();
        } else if (LOG_STEP2.equals(step)) {
            outputBody = body;
            ifLog.Response_Data_Processing_Time__c = System.currentTimeMillis() - timeTemp;
        }
    }

    public void logEnd(InputHeader output, String ifAggregation, String ifTotCnt, String ifSplitCnt, String ifSplitSeq, String ifRcvCnt) {
        ifLog.ifAggregation__c = ifAggregation;
        ifLog.ifTotCnt__c = ifTotCnt;
        ifLog.ifSplitCnt__c = ifSplitCnt;
        ifLog.ifSplitSeq__c = ifSplitSeq;
        ifLog.ifRcvCnt__c = ifRcvCnt;
        logEnd(output);
    }

    public void logEnd(InputHeader output) {
        ifLog.OMSGGUID__c = output.ifTrackingId;
        ifLog.OIFID__c = output.ifId;
        ifLog.OIFDATE__c = output.ifDateTime;
        ifLog.OMSGSTATUS__c = output.ifResult;
        ifLog.OERRORTEXT__c = output.ifFailMsg;
        ifLog.OERRORCODE__c = output.ifFailCode;
        ifLog.Processing_End_Time__c = Datetime.newInstance(System.currentTimeMillis());

        if (forceLogging == null) {
            getIfInfo(ifLog.IFID__c);
        }

        // SUCCESS 인 경우 로그 쌓지 않음
        if (false == RESULT_SUCCESS.equals(output.ifResult) || forceLogging == true) {
            enqueueLog(ifLog);
        }
    }

    private void enqueueLog(IF_LOG__c aIfLogInfo) {
        IF_INFO__c ifInfo = getIfInfo(aIfLogInfo.IFID__c);
        aIfLogInfo.IF_INFO__c = ifInfo.Id;

        IF_BaseLogVO restLog = new IF_BaseLogVO(aIfLogInfo, inputBody, outputBody);
        String restLogJSON = JSON.serialize(restLog);

        System.enqueueJob(new webCallOutLog_qu(restLogJSON));
    }

    // IF_ID로 IF_INFO__c개체 반환 대외 url일 경우
    public IF_INFO__c getIfInfo(String id) {
        if (null != cachedIfInfo) {
            return cachedIfInfo;
        }

        List<IF_INFO__c> ifInfoList;
        ifInfoList = [SELECT IF_ID__c, URL__c, CYCLE__c, FROM__c, TO__c, TITLE__c, FORCE_LOGGING__c, IsSkip__c FROM IF_INFO__c WHERE IF_ID__c = :id LIMIT 1];
        System.debug('ifInfo' + ifInfoList);

        if (ifInfoList.isEmpty()) {
            cachedIfInfo = new IF_INFO__c();
        } else {
            cachedIfInfo = ifInfoList[0];
        }

        if (cachedIfInfo.FORCE_LOGGING__c == true) {
            forceLogging = true;
        }

        return cachedIfInfo;
    }

    // ***************************************
    // static
    // ***************************************

    public static String webCallOut(HttpRequest aHttpReq) {
        String kEndpoint = aHttpReq.getEndpoint();
        System.debug('=================================> Start Request : ' + kEndpoint);

        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        String resBody = null;

        System.debug('requestBody : ' + aHttpReq.getBody());

        aHttpReq.setTimeout(110000);
        httpRes = http.send(aHttpReq);

        System.debug('response Header Key : ' + httpRes.getHeaderKeys());

        System.debug('response Status Code : ' + httpRes.getStatusCode());
        System.debug('response Status : ' + httpRes.getStatus());

        resBody = httpRes.getBody();
        if (resBody.length() > 1900000) {
            System.debug('responseBody : null');
        } else {
            System.debug('responseBody : ' + resBody);
        }

        return resBody;
    }

    // ***************************************
    // Inner class
    // ***************************************
    /**
     *  @description 인터페이스 로그 저장 처리 함수 (future함수 webCallOutLog 대체) Queueable Class
     *               기존 프로세스 : webCallOutLog future함수를 통해 > IF_BaseLogREST API 호출 (Callout 후 로그용 Callout 다시 호출) > LOG 및 Request, Response Attachfile DML 작업
     *  @author shlee
     */
    public without sharing class webCallOutLog_qu implements Queueable {
        public String restLogJSON;

        public webCallOutLog_qu(String restLogJSON) {
            this.restLogJSON = restLogJSON;
            // System.debug('restLogJSON : ' + restLogJSON);
        }

        public void execute(QueueableContext qc) {
            //insert log;
            IF_BaseLogVO restLog = (IF_BaseLogVO) JSON.deserialize(this.restLogJSON, IF_BaseLogVO.class);
            insert restLog.log;

            //insert logFile;
            Attachment attSnd = new Attachment(Name = 'InputParameter' + '.json', Body = restLog.sndJsonBlob, ParentId = restLog.log.Id);
            Attachment attRcv = new Attachment(Name = 'OutputResult' + '.json', Body = restLog.rcvJsonBlob, ParentId = restLog.log.Id);
            insert attSnd;
            insert attRcv;

            System.debug('IF_BaseLogREST log END');
        }

    }
}