@isTest
public with sharing class dao_ContentDocumentLinkTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOneByRecordId_RecordIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String recordId = TestDataFactory.getRecordId();

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findOneByRecordId(recordId);
        System.debug('@@@ FindOneByRecordId_RecordIdExistInDB_ReturnNotEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectNotEmptyList, resultListContentDocumentLinks.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindOneByRecordId_RecordIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        String recordId = TestDataFactory.getNotExistDocumentId();

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findOneByRecordId(recordId);
        System.debug('@@@ FindOneByRecordId_RecordIdNotExistInDB_ReturnEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectSizeEmptyList, resultListContentDocumentLinks.size());

        Test.stopTest();
    }

    @isTest static void FindOneByRecordId_RecordIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        String recordId = null;

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findOneByRecordId(recordId);
        System.debug('@@@ FindOneByRecordId_RecordIdNull_ReturnEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectSizeEmptyList, resultListContentDocumentLinks.size());

        Test.stopTest();
    }

    @isTest static void FindAllByParams_RecordsIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Set<String> recordsIds = new Set<String>{TestDataFactory.getRecordId()};

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findAllByParams(recordsIds);
        System.debug('@@@ FindAllByParams_RecordsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectNotEmptyList, resultListContentDocumentLinks.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_RecordIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

         Set<String> recordsIds = new Set<String>{TestDataFactory.getNotExistDocumentId()};

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findAllByParams(recordsIds);
        System.debug('@@@ FindAllByParams_RecordIdNotExistInDB_ReturnEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectSizeEmptyList, resultListContentDocumentLinks.size());

        Test.stopTest();
    }

    @isTest static void FindAllByParams_RecordIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> recordsIds = null;

        Test.startTest();

        dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
        List<ContentDocumentLink> resultListContentDocumentLinks = daoContentDocumentLink.findAllByParams(recordsIds);
        System.debug('@@@ FindAllByParams_RecordIdNull_ReturnEmptyList:result: ' + resultListContentDocumentLinks);

        System.assertEquals(expectSizeEmptyList, resultListContentDocumentLinks.size());

        Test.stopTest();
    }
}