@isTest
public with sharing class dao_ContentDocumentTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

   @isTest static void FindAllByDocumentIds_DocumentsIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Set<String> documentsIds = TestDataFactory.getDocumentsIds();

        Test.startTest();

        dao_ContentDocument daoContentDocument = new dao_ContentDocument();
        List<ContentDocument> resultListContentDocuments = daoContentDocument.findAllByDocumentsIds(documentsIds);
        System.debug('@@@ FindAllByDocumentIds_DocumentsIdsExistInDB_ReturnNotEmptyList:result: ' + resultListContentDocuments);

        System.assertEquals(expectNotEmptyList, resultListContentDocuments.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByDocumentIds_DocumentsIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> documentsIds = TestDataFactory.getNotExistDocumentsIds();

        Test.startTest();

        dao_ContentDocument daoContentDocument = new dao_ContentDocument();
        List<ContentDocument> resultListContentDocuments = daoContentDocument.findAllByDocumentsIds(documentsIds);//TODO:rename method name on findAll
        System.debug('@@@ FindAllByDocumentIds_DocumentsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListContentDocuments);

        System.assertEquals(expectSizeEmptyList, resultListContentDocuments.size());

        Test.stopTest();
    }

    @isTest static void FindAllByDocumentIds_WithoutDocumentsIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> documentsIds = new Set<String>();

        Test.startTest();

        dao_ContentDocument daoContentDocument = new dao_ContentDocument();
        List<ContentDocument> resultListContentDocuments = daoContentDocument.findAllByDocumentsIds(documentsIds);//TODO:rename method name on findAll
        System.debug('@@@ FindAllByDocumentIds_WithoutDocumentsIds_ReturnEmptyList:result: ' + resultListContentDocuments);

        System.assertEquals(expectSizeEmptyList, resultListContentDocuments.size());

        Test.stopTest();
    }

    @isTest static void FindAllByDocumentIds_DocumentsIdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> documentsIds = null;

        Test.startTest();

        dao_ContentDocument daoContentDocument = new dao_ContentDocument();
        List<ContentDocument> resultListContentDocuments = daoContentDocument.findAllByDocumentsIds(documentsIds);//TODO:rename method name on findAll
        System.debug('@@@ FindAllByDocumentIds_DocumentsIdsNull_ReturnEmptyList:result: ' + resultListContentDocuments);

        System.assertEquals(expectSizeEmptyList, resultListContentDocuments.size());

        Test.stopTest();
    }
}