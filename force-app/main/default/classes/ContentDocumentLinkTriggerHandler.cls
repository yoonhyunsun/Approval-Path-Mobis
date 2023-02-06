/****************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ContentDocumentLinkTriggerHandler
  * Description  : ContentDocumentLink 에 대한 Apex Trigger Handler
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-10-19
****************************************************************************************/

public with sharing class ContentDocumentLinkTriggerHandler extends TriggerHandler {

    public override void afterInsert() {
        System.debug('AFTER INSERT');
        setRelation();
    }

    public override void afterUpdate() {
        System.debug('AFTER UPDATE');
        setRelation();
    }

    public override void beforeDelete() {
        System.debug('CDL > BEFORE DELETE');
    }

    /**
     * @author Kyejin Cheong
     * @description Content Document 생성 시, 해당 레코드와 연결되는 Contents 레코드를 조회 후, 연결된 Contents 의 Submitted 체크박스 필드를 업데이트
     */
    private void setRelation() {

        List<ContentDocumentLink> contentDocumentLinks = ( Trigger.new == null ? Trigger.old : Trigger.new );

        Set<Id> linkedEntityIds = new Set<Id>();

        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks) {
            linkedEntityIds.add(contentDocumentLink.LinkedEntityId);
        }

        for(List<Contents__c> contents : [SELECT Id, (SELECT Id FROM ContentDocumentLinks LIMIT 1), (SELECT Id FROM AttachedContentDocuments LIMIT 1), IsSubmitted__c FROM Contents__c WHERE Id IN :linkedEntityIds ORDER BY Id]) {

            if(!contents.isEmpty()){
                for(Contents__c content : contents) {
                    content.IsSubmitted__c = content.ContentDocumentLinks.size() > 0 ? true : false;
                    // content.IsSubmitted__c = content.AttachedContentDocuments.size() > 0 ? true : false;
                }
            }

            update contents;
        }
    }

}