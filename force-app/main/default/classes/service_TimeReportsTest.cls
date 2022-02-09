@isTest
public with sharing class service_TimeReportsTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;
        String timesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZeroWithoutTimesheet_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Integer limits = 0;
        Integer offset = 0;
        String timesheetId = null;
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitOffsetZeroWithoutTimesheet_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsOffsetZeroWithoutTimesheet_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.configDateRanges.size();
        
        Integer limits = expectSizeList;
        Integer offset = 0;
        String timesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('timesheetId', timesheetId);
        
        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitCountItemsOffsetZeroWithoutTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_TimesheetIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;
        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_APPROVED);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_TimesheetIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_TimesheetIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;
        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_TimesheetIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

     @isTest static void GetTotalCount_WithoutParams_ReturnTotalCount() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnTotalCount:result: ' + resultTotalCount);

        System.assertEquals(expectNotEmptyList, resultTotalCount > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_TimesheetIdExistInDB_ReturnTotalCount() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');
        request.Parameters.put('timesheetId', TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_APPROVED));

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_TimesheetIdExistInDB_ReturnTotalCount:result: ' + resultTotalCount);

        System.assertEquals(expectNotEmptyList, resultTotalCount > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_TimesheetIdNotExistInDB_ReturnTotalCountZero() {
        Integer expectTotalCount = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');
        request.Parameters.put('timesheetId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();
        
        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_TimesheetIdNotExistInDB_ReturnTotalCountZero:result: ' + resultTotalCount);

        System.assertEquals(expectTotalCount, resultTotalCount);

        Test.stopTest();
    }

    @isTest static void FindByReport_ValidParamsWithoutTimesheet_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'findByReport');
        request.Parameters.put('startDate', Date.valueOf(TestDataFactory.DATE_START));
        request.Parameters.put('endDate', Date.valueOf(TestDataFactory.DATE_END));
        request.Parameters.put('employeeId', UserInfo.getUserId());
        request.Parameters.put('status', TestDataFactory.TIME_REPORTS_STATUS_NEW);
        request.Parameters.put('timesheetId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ FindByReport_ValidParamsWithoutTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_ValidParamsWithTimesheetExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        Timesheet__c ts = TestDataFactory.getTimesheetByEmployeeStatus(employeeId, TestDataFactory.TIMESHEET_STATUS_APPROVED);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'findByReport');
        request.Parameters.put('startDate', ts.StartDate__c);
        request.Parameters.put('endDate', ts.EndDate__c);
        request.Parameters.put('employeeId', employeeId);
        request.Parameters.put('status', TestDataFactory.TIME_REPORTS_STATUS_APPROVED);
        request.Parameters.put('timesheetId', ts.Id);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ FindByReport_ValidParamsWithTimesheetExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_ValidParamsWithTimesheetNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'findByReport');
        request.Parameters.put('startDate', Date.valueOf(TestDataFactory.DATE_START));
        request.Parameters.put('endDate', Date.valueOf(TestDataFactory.DATE_END));
        request.Parameters.put('employeeId', UserInfo.getUserId());
        request.Parameters.put('status', TestDataFactory.TIME_REPORTS_STATUS_NEW);
        request.Parameters.put('timesheetId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ FindByReport_ValidParamsWithTimesheetNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByReport_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'findByReport');
        request.Parameters.put('startDate', null);
        request.Parameters.put('endDate', null);
        request.Parameters.put('employeeId', null);
        request.Parameters.put('status', null);
        request.Parameters.put('timesheetId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ FindByReport_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateMultipleStatus_ValidParamsWithTimesheetExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';

        String employeeId = UserInfo.getUserId();
        Timesheet__c ts = TestDataFactory.getTimesheetByEmployee(employeeId);

        List<Date> dates = new List<Date>{};

        Date startDate = ts.StartDate__c;
        Date endDate = ts.EndDate__c;

        while(startDate <= endDate) {
            dates.add(startDate);
            startDate = startDate.addDays(1);
        }        

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateMultipleStatus');
        request.Parameters.put('timesheetId', ts.Id);
        request.Parameters.put('employeeId', employeeId);
        request.Parameters.put('dateList', dates);
        request.Parameters.put('status', true);//TODO: check if use

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateMultipleStatus_ValidParamsWithTimesheetExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateMultipleStatus_ValidParamsWithTimesheetNotExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'error';

        Map<String, Object> dateRange = (Map<String, Object>)TestDataFactory.configDateRanges.get('2019-12-02_2019-12-08');
        Date startDate = Date.valueOf((String)dateRange.get('startDate'));
        Date endDate = Date.valueOf((String)dateRange.get('endDate'));

        List<Date> dates = new List<Date>();

        while(startDate <= endDate) {
            dates.add(startDate);
            startDate = startDate.addDays(1);
        }

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateMultipleStatus');
        request.Parameters.put('timesheetId', TestDataFactory.getNotExistId());
        request.Parameters.put('employeeId', TestDataFactory.getUserId());
        request.Parameters.put('dateList', dates);
        request.Parameters.put('status', true);//TODO: check if use

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateMultipleStatus_ValidParamsWithTimesheetNotExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateMultipleStatus_ValidParamsWithoutTimesheet_ReturnStatusSuccess() {
        String expectStatus = 'success';

        Map<String, Object> dateRange = (Map<String, Object>)TestDataFactory.configDateRanges.get('2019-12-02_2019-12-08');
        Date startDate = Date.valueOf((String)dateRange.get('startDate'));
        Date endDate = Date.valueOf((String)dateRange.get('endDate'));

        List<Date> dates = new List<Date>();

        while(startDate <= endDate) {
            dates.add(startDate);
            startDate = startDate.addDays(1);
        }

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateMultipleStatus');
        request.Parameters.put('timesheetId', null);
        request.Parameters.put('employeeId', UserInfo.getUserId());
        request.Parameters.put('dateList', dates);
        request.Parameters.put('status', true);//TODO: check if use

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateMultipleStatus_ValidParamsWithoutTimesheet_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateMultipleStatus_ParamsNull_ReturnStatusError() {
        String expectStatus = 'error';

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateMultipleStatus');
        request.Parameters.put('timesheetId', null);
        request.Parameters.put('employeeId', null);
        request.Parameters.put('dateList', null);
        request.Parameters.put('status', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimeReports serviceTimeReports = new service_TimeReports();
        serviceTimeReports.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateMultipleStatus_ParamsNull_ReturnStatusError:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }
}