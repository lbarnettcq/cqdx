@isTest
public with sharing class service_ContractResourceTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetId_ValidParams_ReturnItemId() {
        String employeeId = UserInfo.getUserId();
        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources[0];
        String expectId = contractResource.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getId');
        request.Parameters.put('contractId', contractResource.Contract__c);
        request.Parameters.put('employeeId', employeeId);

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        Id resultId = (Id)response.Parameters.get('id');
        System.debug('@@@ GetId_ValidParams_ReturnItemId:result: ' + resultId);

        System.assertEquals(expectId, resultId);

        Test.stopTest();
    }

    @isTest static void GetId_ParamsNotExistInDB_ReturnNull() {
        Id expectNotExistId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getId');
        request.Parameters.put('contractId', TestDataFactory.getNotExistId());
        request.Parameters.put('employeeId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        Id resultId = (Id)response.Parameters.get('id');
        System.debug('@@@ GetId_ParamsNotExistInDB_ReturnNull:result: ' + resultId);

        System.assertEquals(expectNotExistId, resultId);

        Test.stopTest();
    }

    @isTest static void GetId_ParamsNull_ReturnNull() {
        Id expectNotExistId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getId');
        request.Parameters.put('contractId', null);
        request.Parameters.put('employeeId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        Id resultId = (Id)response.Parameters.get('id');
        System.debug('@@@ GetId_ParamsNull_ReturnNull:result: ' + resultId);

        System.assertEquals(expectNotExistId, resultId);

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        List<Contract> contracts = TestDataFactory.getContractsFromDb();
        Id accountId = contracts[0].AccountId;
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('accountId', accountId);

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetListByAccount_AccountIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('accountId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetListByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetListByAccount_AccountIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByAccount');
        request.Parameters.put('accountId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_ContractResource serviceContractResource = new service_ContractResource();
        serviceContractResource.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetListByAccount_AccountIdNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }
}