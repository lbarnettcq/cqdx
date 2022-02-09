@isTest
public with sharing class service_ContractTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_StatusExistInDB_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.CONTRACTS_COUNT;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', TestDataFactory.CONTRACT_STATUS_ACTIVED);

        service_Response response = new service_Response();

        Test.startTest();

        service_Contract serviceContract = new service_Contract();
        serviceContract.process(request, response);
        List<Contract> resultListItems = (List<Contract>)response.Parameters.get('list');
        System.debug('@@@ GetList_StatusExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_StatusNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', TestDataFactory.STATUS_NOT_EXIST);

        service_Response response = new service_Response();

        Test.startTest();

        service_Contract serviceContract = new service_Contract();
        serviceContract.process(request, response);
        List<Contract> resultListItems = (List<Contract>)response.Parameters.get('list');
        System.debug('@@@ GetList_StatusNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_StatusNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_Contract serviceContract = new service_Contract();
        serviceContract.process(request, response);
        List<Contract> resultListItems = (List<Contract>)response.Parameters.get('list');
        System.debug('@@@ GetList_StatusNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        List<Contract> contracts = TestDataFactory.getContractsFromDb();
        Id accountId = contracts[0].AccountId;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('id', accountId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Contract serviceContract = new service_Contract();
        serviceContract.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetListByAccount_AccountIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdNotExistInDB_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('id', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Contract serviceContract = new service_Contract();
            serviceContract.process(request, response);
            List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
            System.debug('@@@ GetListByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdNull_ReturnNotDataFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('id', null);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Contract serviceContract = new service_Contract();
            serviceContract.process(request, response);
            List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
            System.debug('@@@ GetListByAccount_AccountIdNull_ReturnNotDataFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListByAccount_AccountIdNull_ReturnNotDataFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }
}