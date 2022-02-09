@isTest
public with sharing class FileUploadControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_RecordIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        List<Expense_Entry__c> expenseEntries = TestDataFactory.getExpenseEntriesWithFiles();
        String recordId = expenseEntries[0].Id;

        Test.startTest();

        Map<String, Object> result = FileUploadController.getList(recordId);
        System.debug('@@@ GetList_RecordIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_RecordIdNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String recordId = TestDataFactory.getNotExistDocumentId();

        Test.startTest();

        Map<String, Object> result = FileUploadController.getList(recordId);
        System.debug('@@@ GetList_RecordIdNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetList_RecordIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String recordId = null;

        Test.startTest();

        Map<String, Object> result = FileUploadController.getList(recordId);
        System.debug('@@@ GetList_RecordIdNull_ReturnValidationErrors:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Map<String, String>>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void SaveFiles_ValidFiles_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String recordId = TestDataFactory.getExpenseEntryId();
        List<Map<String, String>> files = new List<Map<String, String>>{TestDataFactory.getNewFile(recordId)};

        Test.startTest();

        Map<String, Object> result = FileUploadController.saveFiles(files);
        System.debug('@@@ SaveFiles_ValidFiles_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void SaveFiles_WithoutFiles_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        List<Map<String, String>> files = new List<Map<String, String>>();

        Test.startTest();

        Map<String, Object> result = FileUploadController.saveFiles(files);
        System.debug('@@@ GetList_WithoutFiles_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void SaveFiles_FilesNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        List<Map<String, String>> files = null;

        Test.startTest();

        Map<String, Object> result = FileUploadController.saveFiles(files);
        System.debug('@@@ GetList_FilesNull_ReturnValidationErrors:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Map<String, String>>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdExistInDB_ReturnStatus() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        String documentId = TestDataFactory.getDocumentId();

        Test.startTest();

        Map<String, Object> result = FileUploadController.deleteEntry(documentId);
        System.debug('@@@ DeleteEntry_DocumentIdExistInDB_ReturnStatus:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdNotExistInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String documentId = TestDataFactory.getNotExistDocumentId();

        Test.startTest();

        Map<String, Object> result = FileUploadController.deleteEntry(documentId);
        System.debug('@@@ DeleteEntry_DocumentIdNotExistInDB_ReturnNoFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String documentId = null;
        
        Test.startTest();

        Map<String, Object> result = FileUploadController.deleteEntry(documentId);
        System.debug('@@@ DeleteEntry_DocumentIdNull_ReturnValidationErrors:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }
}