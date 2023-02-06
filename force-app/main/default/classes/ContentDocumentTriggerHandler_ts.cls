/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ContentDocumentTriggerHandler_ts
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-25
****************************************************************************************/

@IsTest
private class ContentDocumentTriggerHandler_ts {

    // 테스트 데이터 생성
    @TestSetup
    static void setData() {

        SalesTestDataUtil.setBypass();

        insert SalesTestDataUtil.getContent();

        /**
         * Create File
         */
        List<Contents__c> contents = [SELECT Id, Name, IsSubmitted__c FROM Contents__c];

        ContentVersion contentVersion = new ContentVersion();

        Blob baseData = Blob.valueOf('Test Contents Attachment');

        contentVersion.ContentLocation = 'S';
        contentVersion.PathOnClient = contents[0].Name + '-' + Date.today().format().replace('. ', '_') + '.csv';
        contentVersion.Title = contents[0].Name + '-' + Date.today().format().replace('. ', '_') + '.csv';
        contentVersion.VersionData = baseData;

        insert contentVersion;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();

        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.LinkedEntityId = contents[0].Id;
        contentDocumentLink.ShareType = 'I';
        contentDocumentLink.Visibility = 'AllUsers';

        insert contentDocumentLink;

        contents[0].IsSubmitted__c = true;

        update contents;

    }

    @IsTest
    static void testCase01() {

        Test.startTest();

        List<Contents__c> contents = [SELECT Id, IsSubmitted__c FROM Contents__c];

        System.debug('contents[0].IsSubmitted__c > ' + contents[0].IsSubmitted__c);

        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: contents[0].Id];

        System.debug('contentDocumentLinks.size() > ' + contentDocumentLinks.size());

        List<ContentDocument> contentDocuments = [SELECT Id FROM ContentDocument WHERE Id =: contentDocumentLinks[0].ContentDocumentId];

        delete contentDocuments;
        
        Test.stopTest();
    }
}