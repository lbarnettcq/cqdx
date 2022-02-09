@isTest
public with sharing class TimesheetsControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetAccounts_ParamsExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListAccounts = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListAccounts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListAccounts, resultSizeListAccounts > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ParamsNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String status = TestDataFactory.STATUS_NOT_EXIST;
        String employeeId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String status = null;
        String employeeId = null;

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getList(limits, offset);
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZero_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        Integer limits = 0;
        Integer offset = 0;
 
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getList(limits, offset);
        System.debug('@@@ GetList_LimitOffsetZero_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnNumberRecords() {
        String expectResponseStatus = 'success';
        Boolean expectNotZeroNumberTimesheets = true;
        Integer zeroNumberTimesheets = 0;

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getTotalCount();
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnNumberRecords:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultNumberTimesheets = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotZeroNumberTimesheets, resultNumberTimesheets > zeroNumberTimesheets);

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdExistInDB_ReturnInfo() {
        String expectResponseStatus = 'success';
        Boolean expectExistItem = true;
        INteger zeroProperties = 0;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_NEW);

        Test.startTest();

        Map<String, Object> result = TimesheetsController.getInformation(timesheetId);
        System.debug('@@@ GetInformation_TimesheetIdExistInDB_ReturnInfo:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');
        Integer resultNumberProperties = resultItem.size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(timesheetId, (String)resultItem.get('timesheetId'));
        System.assertEquals(expectExistItem, resultNumberProperties > zeroProperties);

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdNotExistInDB_ReturnEmptyItem() {
        String expectResponseStatus = 'success';
        Integer expectNumberProperties = 0;

        String timesheetId = TestDataFactory.getNotExistId();
 
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getInformation(timesheetId);
        System.debug('@@@ GetInformation_TimesheetIdNotExistInDB_ReturnEmptyItem:result: ' + result);//TODO: add generate error: not found

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');
        Integer resultNumberProperties = resultItem.size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNumberProperties, resultNumberProperties);

        Test.stopTest();
    }

    @isTest static void GetInformation_TimesheetIdNull_ValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String timesheetId = null;
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getInformation(timesheetId);
        System.debug('@@@ GetInformation_TimesheetIdNull_ValidationErrors:result: ' + result);

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

    @isTest static void InsertEntry_ValidParams_ReturnInsertedTimesheet() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedId = true;

        Map<String, Object> itemTimesheet = TestDataFactory.getNewTimesheet();//TODO: add new period with timesheet entries without timesheet into test data factory

        String expectEmployeeId = (String)itemTimesheet.get('employeeId');
        String expectContractId = (String)itemTimesheet.get('contractId');
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.insertEntry(expectEmployeeId, expectContractId, expectStartDate, expectEndDate);
        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedTimesheet:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Timesheet__c resultItem = ((Timesheet__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedId, resultItem.Id != null);
        System.assertEquals(expectEmployeeId, (String)resultItem.OwnerId);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);

        Test.stopTest();
    }

    @isTest static void InsertEntry_ExistTimesheet_ReturnError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String expectEmployeeId = (String)itemTimesheet.get('employeeId');
        String expectContractId = (String)itemTimesheet.get('contractId');
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.insertEntry(expectEmployeeId, expectContractId, expectStartDate, expectEndDate);
        System.debug('@@@ InsertEntry_ExistTimesheet_ReturnError:result: ' + result);

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

    @isTest static void InsertEntry_NotExistEmployeeContract_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> itemTimesheet = TestDataFactory.getNewTimesheet();

        String expectEmployeeId = TestDataFactory.getNotExistId();
        String expectContractId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.insertEntry(expectEmployeeId, expectContractId, expectStartDate, expectEndDate);
        System.debug('@@@ InsertEntry_NotExistEmployeeContract_ReturnNotFoundError:result: ' + result);

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

    @isTest static void InsertEntry_ParamsWithFutureDateRange_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> itemTimesheet = TestDataFactory.getNewTimesheet();

        String expectEmployeeId = (String)itemTimesheet.get('employeeId');
        String expectContractId = (String)itemTimesheet.get('contractId');

        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START_WITHOUT_DATA);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END_WITHOUT_DATA);
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.insertEntry(expectEmployeeId, expectContractId, expectStartDate, expectEndDate);
        System.debug('@@@ InsertEntry_ParamsWithFutureDateRange_ReturnNotFoundError:result: ' + result);

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

    @isTest static void UpdateEntry_NotExistTimesheetIdInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String timesheetId = TestDataFactory.getNotExistId();
        String employeeId = (String)itemTimesheet.get('employeeId');
        String contractId = (String)itemTimesheet.get('contractId');
        Date startDate = (Date)itemTimesheet.get('startDate');
        Date endDate = (Date)itemTimesheet.get('endDate');
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.updateEntry(timesheetId, employeeId, contractId, startDate, endDate);
        System.debug('@@@ UpdateEntry_NotExistTimesheetIdInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void UpdateEntry_NotExistEmployeeContract_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String timesheetId = (String)itemTimesheet.get('timesheetId');
        String employeeId = TestDataFactory.getNotExistId();
        String contractId = TestDataFactory.getNotExistId();
        Date startDate = (Date)itemTimesheet.get('startDate');
        Date endDate = (Date)itemTimesheet.get('endDate');
        
        Test.startTest();
            
        Map<String, Object> result = TimesheetsController.updateEntry(timesheetId, employeeId, contractId, startDate, endDate);
        System.debug('@@@ UpdateEntry_NotExistEmployeeContract_ReturnNotFoundError:result: ' + result);

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

    @isTest static void UpdateEntry_ValidParams_ReturnUpdatedTimesheet() {
        String expectResponseStatus = 'success';

        Map<String, Object> itemTimesheet = TestDataFactory.getExistTimesheet();

        String expectTimesheetId = (String)itemTimesheet.get('timesheetId');
        String employeeId = (String)itemTimesheet.get('employeeId');
        String contractId = (String)itemTimesheet.get('contractId');
        Date expectStartDate = (Date)itemTimesheet.get('startDate');
        Date expectEndDate = (Date)itemTimesheet.get('endDate');
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.updateEntry(expectTimesheetId, employeeId, contractId, expectStartDate, expectEndDate);
        System.debug('@@@ UpdateEntry_ValidParams_ReturnUpdatedTimesheet:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Timesheet__c resultItem = (Timesheet__c)resultData.get('item');//TODO:convert from Timesheet__c to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectTimesheetId, resultItem.Id);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsNull_ReturnValidationError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 5;

        String timesheetId = null;
        String employeeId = null;
        String contractId = null;
        Date startDate = null;
        Date endDate = null;
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.updateEntry(timesheetId, employeeId, contractId, startDate, endDate);
        System.debug('@@@ UpdateEntry_ParamsNull_ReturnValidationError:result: ' + result);

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

    @isTest static void DeleteEntry_ExistApprovedTimesheetIdInDB_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String timesheetId = TestDataFactory.getTimesheetId('Approved');

        Test.startTest();

        Map<String, Object> result = TimesheetsController.deleteEntry(timesheetId);
        System.debug('@@@ DeleteEntry_ExistApprovedTimesheetIdInDB_ReturnNoAccessError:result: ' + result);

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

    @isTest static void DeleteEntry_ExistNotApprovedTimesheetIdInDB_ReturnStatusSuccess() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        String timesheetId = TestDataFactory.getTimesheetId('New');

        Test.startTest();

        Map<String, Object> result = TimesheetsController.deleteEntry(timesheetId);
        System.debug('@@@ DeleteEntry_ExistNotApprovedTimesheetIdInDB_ReturnStatusSuccess:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
      }

    @isTest static void DeleteEntry_NotExistTimesheetIdInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String timesheetId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = TimesheetsController.deleteEntry(timesheetId);
        System.debug('@@@ DeleteEntry_NotExistTimesheetIdInDB_ReturnNoFoundError:result: ' + result);

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

    @isTest static void DeleteEntry_TimesheetIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String timesheetId = null;
        
        Test.startTest();

        Map<String, Object> result = TimesheetsController.deleteEntry(timesheetId);
        System.debug('@@@ DeleteEntry_TimesheetIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void UpdateStatus_TimesheetIdNew_ReturnStatusPending() {
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = 'Pending';

        String timesheetId = TestDataFactory.getTimesheetId('New');//TODO:get time sheet with status: new, pending, approved

        Test.startTest();

        Map<String, Object> result = TimesheetsController.updateStatus(timesheetId);
        System.debug('@@@ UpdateStatus_TimesheetIdNew_ReturnStatusPending:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Timesheet__c resultItem = (Timesheet__c)resultData.get('item');//TODO:Convert Timesheet__c to Map

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultItem.Status__c);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_TimesheetIdPending_ReturnStatusApproved() {
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = TestDataFactory.TIMESHEET_STATUS_APPROVED;

        String timesheetId = TestDataFactory.getTimesheetId(TestDataFactory.TIMESHEET_STATUS_PENDING);//TODO:get time sheet with status: new, pending, approved

        Test.startTest();

        Map<String, Object> result = TimesheetsController.updateStatus(timesheetId);
        System.debug('@@@ UpdateStatus_TimesheetIdPending_ReturnStatusApproved:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Timesheet__c resultItem = (Timesheet__c)resultData.get('item');//TODO:Convert Timesheet__c to Map

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultItem.Status__c);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_TimesheetIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String timesheetId = null;
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.updateStatus(timesheetId);
        System.debug('@@@ UpdateStatus_TimesheetIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetContractsAndUsersListByAccount_ExistAccountIdInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListExpenses = true;
        Integer sizeEmptyList = 0;

        String accountId = TestDataFactory.getAccountId();
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_ExistAccountIdInDB_ReturnNotEmptyList:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListExpenses, resultSizeListExpenses > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContractsAndUsersListByAccount_NotExistAccountId_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String accountId = TestDataFactory.getNotExistId();
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_NotExistAccountId_ReturnEmptyList:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeListExpenses);

        Test.stopTest();
    }

    @isTest static void GetContractsAndUsersListByAccount_AccountIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String accountId = null;
       
        Test.startTest();

        Map<String, Object> result = TimesheetsController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_AccountIdNull_ReturnValidationErrors:result ' + result);

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