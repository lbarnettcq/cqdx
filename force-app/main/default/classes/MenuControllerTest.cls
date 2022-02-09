@isTest
public with sharing class MenuControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }
    @isTest static void GetAccounts_ParamsExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));   

        Test.startTest();

        Map<String, Object> result = MenuController.getAccounts(status, startDate, endDate, employeeId);
        System.debug('@@@ GetAccounts_ParamsExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void GetAccounts_ParamsNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.STATUS_NOT_EXIST;
        String employeeId = TestDataFactory.getNotExistId();

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));   

        Test.startTest();

        Map<String, Object> result = MenuController.getAccounts(status, startDate, endDate, employeeId);
        System.debug('@@@ GetAccounts_ParamsNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(sizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String status = null;
        String employeeId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        Map<String, Object> result = MenuController.getAccounts(status, startDate, endDate, employeeId);
        System.debug('@@@ GetAccounts_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContractResource_ContractIdExistInDBWithEmployee_ReturnId() {
        String expectResponseStatus = 'success';

        String employeeId = UserInfo.getUserId();
        List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb(employeeId);
        Contract_Resource__c contractResource = contractResources.get(0);
        String contractId = (String)contractResource.Contract__c;
        Id expectId = contractResource.Id;

        Test.startTest();

        Map<String, Object> result = MenuController.getContractResource(contractId, employeeId);
        System.debug('@@@ GetContractResource_ContractIdExistInDBWithEmployee_ReturnId:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Id resultId = (Id)resultData.get('id');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectId, resultId);

        Test.stopTest();
    }


    @isTest static void GetContractResource_ContractIdNotExistInDBWithoutEmployee_ReturnIdIsNull() {
        String expectResponseStatus = 'success';
        String expectIdNull = null;

        String contractId = TestDataFactory.getNotExistId();
        String employeeId = null;

        Test.startTest();

        Map<String, Object> result = MenuController.getContractResource(contractId, employeeId);//TODO: add generate error: not found contract into service_ContractResource
        System.debug('@@@ GetContractResource_ContractIdNotExistInDBWithoutEmployee_ReturnIdIsNull:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Id resultId = (Id)resultData.get('id');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectIdNull, resultId);

        Test.stopTest();
    }

    @isTest static void GetContractResource_ContractIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String contractId = null;
        String employeeId = null;

        Test.startTest();

        Map<String, Object> result = MenuController.getContractResource(contractId, employeeId);
        System.debug('@@@ GetContractResource_ContractIdNull_ReturnValidationErrors:result ' + result);

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
}