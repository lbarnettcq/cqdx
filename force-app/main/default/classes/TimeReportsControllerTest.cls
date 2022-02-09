@isTest
public with sharing class TimeReportsControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_TimesheetIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String timesheetId = TestDataFactory.getTimesheetId('New');
        Integer limits = null;
        Integer offset = null;

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getList(limits, offset, timesheetId);
        System.debug('@@@ GetList_TimesheetIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeListTimeReports = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListTimeReports > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void GetList_TimesheetIdNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String timesheetId = TestDataFactory.getNotExistId();
        Integer limits = null;
        Integer offset = null;
 
        Test.startTest();

        Map<String, Object> result = TimeReportsController.getList(limits, offset, timesheetId);//TODO: add generate error: not found timesheet
        System.debug('@@@ GetList_TimesheetIdNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeListExpenses);

        Test.stopTest();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String timesheetId = null;
        Integer limits = null;
        Integer offset = null;
 
        Test.startTest();

        Map<String, Object> result = TimeReportsController.getList(limits, offset, timesheetId);
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListTimeReports = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListTimeReports > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_TimesheetIdNull_ReturnNumberTimeReports() {
        String expectResponseStatus = 'success';
        Boolean expectNotZeroNumberTimeReports = true;
        Integer zeroNumberTimeReports = 0;

        String timesheetId = null;

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getTotalCount(timesheetId);
        System.debug('@@@ GetTotalCount_TimesheetIdNull_ReturnNumberTimeReports:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultNumberTimeReports = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotZeroNumberTimeReports, resultNumberTimeReports > zeroNumberTimeReports);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_TimesheetIdExistInDB_ReturnNumberTimeReports() {
        String expectResponseStatus = 'success';
        Boolean expectNotZeroNumberTimeReports = true;
        Integer zeroNumberTimeReports = 0;

        String timesheetId = TestDataFactory.getTimesheetId('New');

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getTotalCount(timesheetId);
        System.debug('@@@ GetTotalCount_TimesheetIdExistInDB_ReturnNumberTimeReports:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultNumberTimeReports = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotZeroNumberTimeReports, resultNumberTimeReports > zeroNumberTimeReports);

        Test.stopTest();
    }

    @isTest static void GetReport_ValidAllParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));     
        String status = TestDataFactory.TIME_REPORTS_STATUS_APPROVED;
        String timesheetId = TestDataFactory.getTimesheetId('Approved');

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getReport(employeeId, startDate, endDate, status, timesheetId);
        System.debug('@@@ GetReport_ValidAllParams_ReturnNotEmptyList:result: ' + result);

        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultResponseStatus = (String)result.get('status');
        Integer resultSizeListTimeReports = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListTimeReports > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReport_ValidAllParamsWithoutTimesheetId_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));     
        String status = TestDataFactory.TIME_REPORTS_STATUS_APPROVED;
        String timesheetId = null;

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getReport(employeeId, startDate, endDate, status, timesheetId);
        System.debug('@@@ GetReport_ValidAllParamsWithoutTimesheetId_ReturnNotEmptyList:result: ' + result);

        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultResponseStatus = (String)result.get('status');
        Integer resultSizeListTimeReports = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListTimeReports > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReport_InvalidAllParams_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 4;

        String employeeId = null;
        Date startDate =  null;
        Date endDate = null;
        String status = null;
        String timesheetId = null;
       
        Test.startTest();

        Map<String, Object> result = TimeReportsController.getReport(employeeId, startDate, endDate, status, timesheetId);
        System.debug('@@@ GetReport_InvalidAllParams_ReturnValidationErrors:result: ' + result);

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

    @isTest static void SetMultipleStatus_ValidAllParams_ReturnSuccessStatus() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        String employeeId = UserInfo.getUserId(); 

        List<Timesheet_Entry__c> timesheetEntries =  TestDataFactory.getTimesheetEntriesFromDBByEmployee(employeeId, 'New');
        Timesheet_Entry__c timesheetEntry = timesheetEntries.get(0);

        List<Date> dateList = new List<Date>{timesheetEntry.Date__c};
        
        Boolean status = true;//TODO:incorrect value for status
        String timesheetId = (String)timesheetEntry.TimesheetId__c;

        Test.startTest();

        Map<String, Object> result = TimeReportsController.setMultipleStatus(dateList, employeeId, status, timesheetId);
        System.debug('@@@ SetMultipleStatus_ValidAllParams_ReturnSuccessStatus:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }


    @isTest static void SetMultipleStatus_ValidAllParamsWithoutTimesheet_ReturnSuccessStatus() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        List<Date> dateList = new List<Date>{startDate};
        String employeeId = UserInfo.getUserId();
        Boolean status = true;//TODO:incorrect value for status
        String timesheetId = null;

        Test.startTest();

        Map<String, Object> result = TimeReportsController.setMultipleStatus(dateList, employeeId, status, timesheetId);
        System.debug('@@@ SetMultipleStatus_ValidAllParamsWithoutTimesheet_ReturnSuccessStatus:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void SetMultipleStatus_InvalidAllParams_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 3;

        List<Date> dateList = null;
        String employeeId = null; 
        Boolean status = null;
        String timesheetId = null;
       
        Test.startTest();

        Map<String, Object> result = TimeReportsController.setMultipleStatus(dateList, employeeId, status, timesheetId);
        System.debug('@@@ SetMultipleStatus_InvalidAllParams_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetUser_UserIdExistInDB_ReturnUser() {
        String expectResponseStatus = 'success';

        String expectUserId = UserInfo.getUserId(); 

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getUser(expectUserId);
        System.debug('@@@ GetUser_UserIdExistInDB_ReturnUser:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Map<String, String> resultUser = (Map<String, String>)resultData.get('user');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUserId, resultUser.get('id'));

        Test.stopTest();
    }

    @isTest static void GetUser_UserIdNotExistInDB_ReturnNull() {
        String expectResponseStatus = 'success';
        Map<String, String> expectUserNull = null;

        String userId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = TimeReportsController.getUser(userId);//TODO: add generate error: not found user
        System.debug('@@@ GetUser_UserIdNotExistInDB_ReturnNull:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Map<String, String> resultUser = (Map<String, String>)resultData.get('user');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUserNull, resultUser);

        Test.stopTest();
    }

     @isTest static void GetUser_UserIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String userId = null;
       
        Test.startTest();

        Map<String, Object> result = TimeReportsController.getUser(userId);
        System.debug('@@@ GetUser_UserIdNull_ReturnValidationErrors:result: ' + result);

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