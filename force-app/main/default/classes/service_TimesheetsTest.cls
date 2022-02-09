@isTest
public with sharing class service_TimesheetsTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        Integer expectSizeNotEmptyList = TestDataFactory.getTotalTimesheets();

        Integer limits = null;
        Integer offset = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeNotEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZero_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Integer limits = 0;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitOffsetZero_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList() {
        INteger expectSizeNotEmptyList = TestDataFactory.getTotalTimesheets();

        Integer limits = expectSizeNotEmptyList;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeNotEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnNotEmptyList() {
        Integer expectTotalCount = TestDataFactory.getTotalTimesheets();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnNotEmptyList:result: ' + resultTotalCount);

        System.assertEquals(expectTotalCount, resultTotalCount);

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdExistInDB_ReturnItem() {
        Boolean expectItem = true;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_APPROVED);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_TimesheetIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectItem, resultItem.size() > 0);

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdNotExistInDB_ReturnEmptyItem() {//TODO: return error not found
        Integer expectTotalPropertiesEmptyItem = 0;

        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_TimesheetIdNotExistInDB_ReturnEmptyItem:result: ' + resultItem);

        System.assertEquals(expectTotalPropertiesEmptyItem, resultItem.size());

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdNull_ReturnEmptyItem() {//TODO: return error not found
        Integer expectTotalPropertiesEmptyItem = 0;

        String timesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_TimesheetIdNull_ReturnEmptyItem:result: ' + resultItem);

        System.assertEquals(expectTotalPropertiesEmptyItem, resultItem.size());

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithNotExistContractEmployeeInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = TestDataFactory.getNewTimesheet();
     
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        String expectEmployeeId = TestDataFactory.getNotExistId();
        String expectContractId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('userId', expectEmployeeId);//TODO:rename userId to employeeId
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ValidParamsWithNotExistContractEmployeeInDB_ReturnErrorNotFound:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsWithNotExistContractEmployeeInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ParamsDateRangeOut_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = TestDataFactory.getNewTimesheet();

        String expectEmployeeId = (String)item.get('employeeId');
        String expectContractId = (String)item.get('contractId');

        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START_WITHOUT_DATA);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END_WITHOUT_DATA);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('userId', expectEmployeeId);//TODO:rename userId to employeeId
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ParamsDateRangeOut_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ParamsDateRangeOut_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

     @isTest static void InsertEntry_ValidParamsWithExistTimesheetInDB_ReturnError() {
        String expectedExceptionThrown = 'System.IllegalArgumentException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = TestDataFactory.getExistTimesheet();
     
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        String expectEmployeeId = (String)item.get('employeeId');
        String expectContractId = (String)item.get('contractId');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('userId', expectEmployeeId);//TODO:rename userId to employeeId
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ValidParamsWithExistTimesheetInDB_ReturnError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsWithExistTimesheetInDB_ReturnError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParams_ReturnInsertedTimesheet() {
        Id notCreatedId = null;

        Map<String, Object> item = TestDataFactory.getNewTimesheet();
     
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        String expectEmployeeId = (String)item.get('employeeId');
        String expectContractId = (String)item.get('contractId');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('userId', expectEmployeeId);//TODO:rename userId to employeeId
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedTimesheet:result: ' + resultItem);

        System.assertNotEquals(notCreatedId, resultItem.Id);
        System.assertEquals(expectEmployeeId, (String)resultItem.OwnerId);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);

        Test.stopTest();
    }

     @isTest static void UpdateEntry_ValidParams_ReturnUpdatedTimesheet() {
        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String expectTimesheetId = (String)itemTimesheet.get('timesheetId');
        String expectEmployeeId = (String)itemTimesheet.get('employeeId');
        String contractId = (String)itemTimesheet.get('contractId');
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('userId', expectEmployeeId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('contractId', contractId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ UpdateEntry_ValidParams_ReturnUpdatedTimesheet:result: ' + resultItem);

        System.assertEquals(expectTimesheetId, resultItem.Id);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String expectTimesheetId = TestDataFactory.getNotExistId();
        String expectEmployeeId = (String)itemTimesheet.get('employeeId');
        String contractId = (String)itemTimesheet.get('contractId');
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('userId', expectEmployeeId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('contractId', contractId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String expectTimesheetId = (String)itemTimesheet.get('timesheetId');
        String expectEmployeeId = TestDataFactory.getNotExistId();
        String contractId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('userId', expectEmployeeId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('contractId', contractId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

     @isTest static void DeleteEntry_TimesheetIdNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ DeleteEntry_TimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_TimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_TimesheetIdApprovedExistInDB_ReturnErrorNoAccess() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_APPROVED);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            String resultStatus = (String)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ DeleteEntry_TimesheetIdApprovedExistInDB_ReturnErrorNoAccess:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_TimesheetIdApprovedExistInDB_ReturnErrorNoAccess:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

     @isTest static void DeleteEntry_TimesheetIdNewExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_NEW);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ DeleteEntry_TimesheetIdNewExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_TimesheetIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
            System.debug('@@@ UpdateStatus_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateStatus_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateStatus_TimesheetIdNull_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Timesheets serviceTimesheets = new service_Timesheets();
            serviceTimesheets.process(request, response);
            Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
            System.debug('@@@ UpdateStatus_TimesheetIdNull_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateStatus_TimesheetIdNull_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateStatus_TimesheetIdExistInDBStatusNew_ReturnStatusPending() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = TestDataFactory.TIMESHEET_STATUS_PENDING;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_NEW);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
        System.debug('@@@ UpdateStatus_TimesheetIdExistInDBStatusNew_ReturnStatusPending:result: ' + resultItem);

        System.assertEquals(expectStatus, resultItem.Status__c);

        Test.stopTest();
    }


    @isTest static void UpdateStatus_TimesheetIdExistInDBStatusPending_ReturnStatusApproved() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = TestDataFactory.TIMESHEET_STATUS_APPROVED;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_PENDING);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Timesheets serviceTimesheets = new service_Timesheets();
        serviceTimesheets.process(request, response);
        Timesheet__c resultItem = (Timesheet__c)response.Parameters.get('item');
        System.debug('@@@ UpdateStatus_TimesheetIdExistInDBStatusPending_ReturnStatusApproved:result: ' + resultItem);

        System.assertEquals(expectStatus, resultItem.Status__c);

        Test.stopTest();
    }    
}