@isTest
public with sharing class service_FileUploadTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }
    
    @isTest static void GetList_RecordIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('recordId', TestDataFactory.getRecordId());

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetList_RecordIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_RecordIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('recordId', TestDataFactory.getNotExistDocumentId());

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetList_RecordIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_RecordIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('recordId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetList_RecordIdNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void SaveFiles_ValidListFiles_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String recordId = TestDataFactory.getExpenseEntryId();
        List<Map<String, String>> files = new List<Map<String, String>>{TestDataFactory.getNewFile(recordId)};

        service_Request request = new service_Request();
        request.Parameters.put('action', 'saveFiles');
        request.Parameters.put('listFiles', files);

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ SaveFiles_ValidListFiles_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void SaveFiles_WithoutFiles_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'saveFiles');
        request.Parameters.put('listFiles', new List<Map<String, String>>());

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ SaveFiles_WithoutFiles_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void SaveFiles_FilesNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'saveFiles');
        request.Parameters.put('listFiles', new List<Map<String, String>>());

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ SaveFiles_FilesNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('documentId', TestDataFactory.getDocumentId());

        service_Response response = new service_Response();

        Test.startTest();

        service_FileUpload serviceFileUpload = new service_FileUpload();
        serviceFileUpload.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ DeleteEntry_DocumentIdExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('documentId', TestDataFactory.getNotExistDocumentId());

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_FileUpload serviceFileUpload = new service_FileUpload();
            serviceFileUpload.process(request, response);
            String resultStatus = (String)response.Parameters.get('item');//TODO: change to status
            System.debug('@@@ DeleteEntry_DocumentIdNotExistInDB_ReturnNoFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_DocumentIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_DocumentIdNull_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('documentId', TestDataFactory.getNotExistDocumentId());

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_FileUpload serviceFileUpload = new service_FileUpload();
            serviceFileUpload.process(request, response);
            String resultStatus = (String)response.Parameters.get('item');//TODO: change to status
            System.debug('@@@ DeleteEntry_DocumentIdNull_ReturnErrorNotFound:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_DocumentIdNull_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }
}