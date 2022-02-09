@isTest
public with sharing class service_AccountTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }
    
    @isTest static void GetList_ValidParams_ReturnNotEmptyList() {
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', TestDataFactory.CONTRACT_STATUS_ACTIVED);
        request.Parameters.put('employeeId', UserInfo.getUserId());
        request.Parameters.put('timesheetId', TestDataFactory.getTimesheetId());
        request.Parameters.put('startDate', Date.ValueOf(TestDataFactory.DATE_START));
        request.Parameters.put('endDate', Date.valueOf(TestDataFactory.DATE_END));

        service_Response response = new service_Response();

        Test.startTest();

        service_Account serviceAccount = new service_Account();
        serviceAccount.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_ValidParamsWithoutTimesheet_ReturnNotEmptyList() {
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', TestDataFactory.CONTRACT_STATUS_ACTIVED);
        request.Parameters.put('employeeId', TestDataFactory.getUserId());
        request.Parameters.put('startDate', Date.valueOf(TestDataFactory.DATE_START));
        request.Parameters.put('endDate', Date.valueOf(TestDataFactory.DATE_END));

        service_Response response = new service_Response();

        Test.startTest();

        service_Account serviceAccount = new service_Account();
        serviceAccount.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ValidParamsWithoutTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('status', null);
        request.Parameters.put('employeeId', null);
        request.Parameters.put('timesheetId', null);
        request.Parameters.put('startDate', null);
        request.Parameters.put('endDate', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_Account serviceAccount = new service_Account();
        serviceAccount.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }
}