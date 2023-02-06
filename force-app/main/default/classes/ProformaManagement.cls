/***************************************************************************************
  * Project Name : Hyundai Mobis
  * File Name    : ProformaManagement
  * Description  : 
  * Copyright    : Copyright © I2max. All Rights Reserved. 2022 
  * Author       : KyeJin Cheong
  * Created Date : 2022-11-14
****************************************************************************************/

public with sharing class ProformaManagement {

    /**
     * Initialize
     */
    @AuraEnabled
    public static ComponentResponse init() {
        ComponentResponse response = new ComponentResponse();

        String connected = 'connected';

        response.setData('connected', connected);

        return response;
    }

    /**
     * @description 현재 CSV 파일은 최근 생성 기준으로 20개만 가져온다
     * @return Document Link list
     */
    @AuraEnabled
    public static ComponentResponse getFileList() {

        ComponentResponse response = new ComponentResponse();

        String prefix = System.Label.CSV_PROFORMA_MANAGEMENT;
        prefix = prefix + '%';

        List<ContentDocument> documentList = [
                SELECT Id
                FROM ContentDocument
                WHERE OwnerId =:UserInfo.getUserId()
                AND Title LIKE :prefix
        ];

        Set<Id> documentIds = new Set<Id>();
        for(ContentDocument document : documentList) {
            documentIds.add(document.Id);
        }

        // Map : Keys
        List<ContentDocumentLink> files = new List<ContentDocumentLink>();
        if(!documentIds.isEmpty()){
            files = [
                    SELECT ContentDocumentId
                    FROM ContentDocumentLink
                    WHERE ContentDocumentId =: documentIds
                    ORDER BY ContentDocument.CreatedDate DESC
                    LIMIT 20
            ];
        }

        System.debug('files.size() > ' + files.size());

        List<Id> fileIDs = new List<Id>();
        for(ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        // Map : Values
        List<ContentVersion> docs = [
                SELECT ContentDocumentId, FileExtension, Title, Description
                FROM ContentVersion
                WHERE ContentDocumentId IN :fileIDs
                ORDER BY ContentDocument.CreatedDate DESC
        ];
        Map<Id, ContentVersion> mapIdTitle = new Map<Id, ContentVersion>();

        for(ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink);
        }

        System.debug('mapIdTitle.size() > ' + mapIdTitle.size());

        response.setData('mapIdTitle', mapIdTitle);

        return response;
    }

}