/****************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ContentDocumentTriggerHandler
  * Description  : Content Document 에 대한 Apex Trigger Handler
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022
  * Author       : KyeJin Cheong
  * Created Date : 2022-10-24
****************************************************************************************/

public with sharing class ContentDocumentTriggerHandler extends TriggerHandler {

    public override void beforeDelete() {
        System.debug('BEFORE DELETE');
        setRelation();
    }

    /**
     * @author Kyejin Cheong
     * @description Content Document 삭제 전, 해당 Contents 에 존재하는 File List 에 대한 사이즈를 체크 후,
     *              해당 Contents 의 File List 가 1 이면 (= 삭제 이전, 업로드 된 File 이 하나밖에 없다면..), Is Submitted 체크 해제 후 삭제
     */
    private void setRelation() {
        List<ContentDocument> contentDocuments = ( Trigger.new == null ? Trigger.old : Trigger.new );
        Set<Id> contentDocumentIds = new Set<Id>();

        for(ContentDocument contentDocument : contentDocuments) {
            contentDocumentIds.add(contentDocument.Id);
        }

        Set<Id> linkedEntityIds = new Set<Id>();

        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :contentDocumentIds];

        for(ContentDocumentLink contentDocumentLink : contentDocumentLinks) {
            linkedEntityIds.add(contentDocumentLink.LinkedEntityId);
        }

        System.debug('linkedEntityIds.size() > ' + linkedEntityIds.size());

        List<Contents__c> contents = [SELECT Id, (SELECT Id FROM AttachedContentDocuments) FROM Contents__c WHERE Id IN :linkedEntityIds ORDER BY Id];

        if(!contents.isEmpty()){
            for(Contents__c content : contents) {
                content.IsSubmitted__c = content.AttachedContentDocuments.size() == 1 ? false : true;
            }
        }

        update contents;
    }

}