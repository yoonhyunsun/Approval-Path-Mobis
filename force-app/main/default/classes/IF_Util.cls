/**
 * Created by hyodongmin on 2022/07/28.
 */

public without sharing class IF_Util {

    /**
     * 간단하게 로그 남김 (IF_LOG__c)
     * 
     * @param aName 일종의 제목
     * @param aText 로그 내용
     * @param aIdOrNull IF_INFO__C
     */
    public static void logSimple(String aName, String aText, Id aIdOrNull) {
        // insert a log
        Datetime kNow = Datetime.newInstance(System.currentTimeMillis());
        IF_LOG__c kLog = new IF_LOG__c();
        kLog.IF_INFO__c = aIdOrNull;
        kLog.MSGGUID__c = aName;
        kLog.IFID__c = aName;
        kLog.IFDATE__c = kNow.formatGmt(IF_Base.FORMAT_DATETIME);
        kLog.OERRORTEXT__c = aText;
        kLog.Processing_End_Time__c = kNow;

        insert kLog;
    }

    /**
     * 에러 메시지가 있다면 해당 System Administrator 에게 이메일 전송
     *
     * @param aClass  Class object
     * @param aError error message
     */
    public static void sendEmailIfError(Object aClass, String aError) {
        if (String.isNotBlank(aError)) {
            String currentClassName = String.valueOf(aClass).substring(0, String.valueOf(aClass).indexOf(':'));

            // 관리자 Email 조회 후 전송.
            List<String> receivers = new List<String>();
            List<User> kUsers = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator'];
            for (User kUser : kUsers) {
                receivers.add(kUser.Email);
            }

            // 프로그램 최종수정자의 Email 조회 후 전송.
            List<ApexClass> kApexClasses = [SELECT LastModifiedBy.Email, Name FROM ApexClass WHERE Name = :currentClassName];
            for (ApexClass kApexClass : kApexClasses) {
                receivers.add(kApexClass.LastModifiedBy.Email);
            }

            String body = 'Since an error has occurred in the scheduled job, Please check the following error. \n\r' + aError;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(receivers);
            mail.setSubject('[' + currentClassName + '] Scheduled job Error!!!');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody(body);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
    }

    /**
     * Chain context 에 이메일 발송 활성 상태에 따라서 메일 처리
     *
     * @param aContext EXEC_ChainContext
     * @param aClass  Class object
     * @param aError error message
     */
    public static void sendEmailWithContext(EXEC_ChainContext aContext, Object aClass, String aError) {
        if (null != aContext && true == aContext.enableEmailSending) {
            sendEmailIfError(aClass, aError);
        } else {
            System.debug(LoggingLevel.WARN, '-------------------------------------------------------------------');
            System.debug(LoggingLevel.WARN, aClass);
            System.debug(LoggingLevel.WARN, aError);
            System.debug(LoggingLevel.WARN, '-------------------------------------------------------------------');
        }
    }

    /**
     * @deprecated {@link IF_Util.notifyApproval(Id)}
     */
    @Future(Callout=true)
    public static void notifyApproval(Id aUserId, Id aApprovalId) {
        notifyApprovalInner(aApprovalId, '1');
    }

    /**
     * 결재 요청 시 모비스 시스템으로 알림을 발송한다.
     *
     * @param aApprovalId 결재 상세 Id
     */
    @Future(Callout=true)
    public static void notifyApproval(Id aApprovalId) {
        notifyApprovalInner(aApprovalId, '1');
    }

    /**
     * @deprecated {@link IF_Util.removeApprovalNotification(Id)}
     */
    @Future(Callout=true)
    public static void removeApprovalNotification(Id aUserIdContactId, Id aApprovalId) {
        notifyApprovalInner(aApprovalId, '0');
    }

    /**
     * 결재 완료 시 모시스 시스템의 알림을 제거한다.
     *
     * @param aApprovalId 결재 상세 Id
     */
    @Future(Callout=true)
    public static void removeApprovalNotification(Id aApprovalId) {
        notifyApprovalInner(aApprovalId, '0');
    }

    /**
     * @param aApprovalId 결재 상세 Id
     * @param a1Or0 '1' = 알림 등록, '0' = 알림 삭제
     */
    static void notifyApprovalInner(Id aApprovalId, String a1Or0) {
        try {
            ApprovalProcessPath__c kApprovalPath = [
                    SELECT Id, Name, RequestDateTime__c, CreatedBy.Name, ApprovalProcess__r.Name, Employee__r.EmployeeNumber__c, ApprovalUser__c, ApprovalProcessPathUID__c
                    FROM ApprovalProcessPath__c
                    WHERE Id = :aApprovalId
            ];

            if (null != kApprovalPath) {
                String kApprovalUrl;
                if(null == kApprovalPath.ApprovalUser__c) { // 협조자
                    kApprovalUrl = ApprovalProcessSettings__c.getInstance('MobisApprovalProcessSettings').PublicSiteURL__c;
                    kApprovalUrl += 'approve?uid=' + kApprovalPath.ApprovalProcessPathUID__c + '&';
                } else {
                    kApprovalUrl = Url.getOrgDomainUrl().toExternalForm() + '/lightning/r/' + aApprovalId + '/view';
                }
                IF_SFDC_ONE_APPROVAL.DataOneApproval kData = new IF_SFDC_ONE_APPROVAL.DataOneApproval();
                kData.DOCNBR = kApprovalPath.Name;// 문서번호, 공백으로 보내면 정상작동 안함
                kData.DOCNAM = kApprovalPath.ApprovalProcess__r.Name;// 제목
                kData.PEMPNO = kApprovalPath.Employee__r.EmployeeNumber__c;// 차기 결재자 사번
                kData.PNAME = kApprovalPath.CreatedBy.Name;// 상신자 이름
                kData.DOCDTE = kApprovalPath.RequestDateTime__c.format('yyyyMMdd'); // 기안일자
                kData.APPURL = kApprovalUrl;// 링크 URL
                kData.APPARA = '_';// 파라미터, 공백으로 보내면 정상작동 안함
                IF_Outbound.Result kResult = new IF_SFDC_ONE_APPROVAL(new IF_OutboundBasicRequester(), kData, a1Or0).execute(IF_Comm.giveAGGR());
                System.debug(LoggingLevel.WARN, 'Result code: ' + kResult.code);
                System.debug(LoggingLevel.WARN, 'Result message: ' + kResult.message);
            } else {
                System.debug(LoggingLevel.ERROR, aApprovalId + ' is null.');
            }
        } catch (Exception e) {
            String kText = 'ACNT_CNT: ' + a1Or0 + ', ApprovalId: ' + aApprovalId + ', Message: ' + e.getMessage();
            logSimple('EAI notify Error', kText, null);
        }
    }

//    @Future(Callout=true)
//    public static void notinoti() {
//        System.debug([SELECT Id, Name, UserId__c, EmployeeNumber__c FROM Contact WHERE UserId__c = '0055i000000OVvPAAW' AND IsEmployee__c = TRUE LIMIT 1]);
//    }
}