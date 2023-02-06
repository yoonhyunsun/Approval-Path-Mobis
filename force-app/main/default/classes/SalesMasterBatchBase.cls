/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : SalesMasterBatchBase
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-23
****************************************************************************************/

public abstract inherited sharing class SalesMasterBatchBase implements Database.Batchable<SObject>, Database.Stateful {

    //--------------------------------
    // Batch Log
    //--------------------------------
    public BatchLogger logger;          // BatchLogger
    public Integer gCnt;                // Scope guess count
    public Integer tCnt;                // Scope total count
    //--------------------------------
    // Param
    //--------------------------------
    public Date ifDate;                 // Interface Date
    public String searchStartDate;      // ifDate 를 기반으로 한 조회 시작일시
    public String searchEndDate;        // ifDate 를 기반으로 한 조회 종료일시
    public Boolean isContinue = true;   // Chain 후속 배치 실행 여부
    public Boolean isChatter = false;   // Error 발생 시 Chatter 전송 여부
    public String whereCondition;
    public String ifAggregation;
    //--------------------------------
    // Interface
    //--------------------------------
    public List<User> interfaceUsers = [SELECT Id FROM User WHERE Profile.Name LIKE '%Interface%' AND IsActive = TRUE];

    // Batch Initialize
    public void init(Database.BatchableContext bc) {
        System.debug('< ServiceMasterBatchBase init() >');
        logger = new BatchLogger(BC.getJobId(), String.valueOf(this));
        logger.start('Start!!');

        gCnt = tCnt = 0;

        // ifDate 가 없으면 오늘 날짜로 셋팅
        if (ifDate == null) ifDate = Date.today();

        // searchStartDate ~ searchEndDate, Default = 1 day
        Datetime dt = Datetime.newInstance(ifDate, Time.newInstance(0, 0, 0, 0));
        searchStartDate = searchStartDate != null ? searchStartDate : dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        searchEndDate = searchEndDate != null ? searchEndDate : dt.addDays(1).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        System.debug('searchStartDate >> ' + searchStartDate + ' / searchEndDate >> ' + searchEndDate);

    }

    // Start, Execute 는 각 배치에서 override
    public abstract Database.QueryLocator start(Database.BatchableContext context);
    public abstract void execute(Database.BatchableContext context, List<SObject> scope);

    public void finish(Database.BatchableContext context) {
        String currentClassName = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));

        System.debug('< ' + currentClassName + ' Finish >');

        logger.finish(gCnt, tCnt);

        if (String.isNotBlank(logger.getError())) {
            if(isChatter){
                System.debug('< Chatter 전송 >');
                List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
                ConnectApi.BatchInput batchInput;

                String content = 'Batch Error';
                batchInput = new ConnectApi.BatchInput(chatterPost(content, UserInfo.getUserId(), logger.getBlId()));
                batchInputs.add(batchInput);
                if (!batchInputs.isEmpty()) ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            }
        }

        // 후속 배치 실행

    }

    private ConnectApi.FeedItemInput chatterPost(String content, String mentionId, String loggerId) {

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        ConnectApi.TextSegmentInput newLine = new ConnectApi.TextSegmentInput();

        // Content
        newLine.text = '\r\n';
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        textSegmentInput.text = content + '\r\n\r\n';
        messageBodyInput.messageSegments.add(textSegmentInput);
        messageBodyInput.messageSegments.add(newLine);
        messageBodyInput.messageSegments.add(newLine);

        // Mention
        if (Util.isNotEmpty(mentionId)) {
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();

            mentionSegmentInput.id = (String) mentionId; // userId
            messageBodyInput.messageSegments.add(mentionSegmentInput);
        }

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = loggerId;
        feedItemInput.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;

        return feedItemInput;
    }
}