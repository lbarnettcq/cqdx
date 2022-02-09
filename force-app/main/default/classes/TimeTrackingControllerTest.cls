@isTest
public with sharing class TimeTrackingControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetProducts_WithoutParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getProducts();
        System.debug('@@@ GetProducts_WithoutParams_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListProducts = ((List<Product2>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListProducts > sizeEmptyList);

        Test.stopTest();
    } 

    @isTest static void GetList_ValidParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<String> employeesIds = new List<String>{employeeId};

        List<String> contractsIds = TestDataFactory.getContractsIdsFromContractResources(employeeId);        

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));
        Boolean previousWeek = false;

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getList(contractsIds, employeesIds, startDate, endDate, previousWeek);
        System.debug('@@@ GetList_ValidParams_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_NotExistContractEmployee_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer expectSizeEmptyList = 0;      

        List<String> contractsIds = new List<String>{TestDataFactory.getNotExistId()};
        List<String> employeesIds = new List<String>{TestDataFactory.getNotExistId()};

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));
        Boolean previousWeek = false;

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getList(contractsIds, employeesIds, startDate, endDate, previousWeek);
        System.debug('@@@ GetList_NotExistContractEmployee_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetList_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 3;

        List<String> contractsIds = null;
        List<String> employeesIds = null;
        Date startDate = null;
        Date endDate = null;
        Boolean previousWeek = false;
       
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getList(contractsIds, employeesIds, startDate, endDate, previousWeek);
        System.debug('@@@ GetList_ParamsNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void InsertEntry_ValidParams_ReturnInsertedTimeTracking() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedExpenseId = true;
        Integer expectNumberItems = 1;

        Map<String, Object> itemTimeTracking = TestDataFactory.getNewTimeTracking();    

        Date createdDate = (Date)itemTimeTracking.get('createdDate');
        DateTime dt = DateTime.newInstanceGMT(createdDate.year(), createdDate.month(), createdDate.day());
        String expectCreatedDate = dt.formatGmt(TestDataFactory.DATE_FORMAT);

        String contractId = (String)itemTimeTracking.get('contractId');
        String expectProductId = (String)itemTimeTracking.get('productId');        
        String expectMinutes = String.valueOf(itemTimeTracking.get('minutes'));
        String employeeId = (String)itemTimeTracking.get('employeeId');

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.insertEntry(contractId, expectProductId, expectCreatedDate, expectMinutes, employeeId);
        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedTimeTracking:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        List<Timesheet_Entry__c> resultListItems = ((List<Timesheet_Entry__c>)resultData.get('list'));
        Timesheet_Entry__c resultItem = resultListItems[0];//TODO: Convert item to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectCreatedExpenseId, resultItem.Id != null);
        System.assertEquals(expectProductId, (String)resultItem.Product__c);
        System.assertEquals(expectCreatedDate, String.valueOf(resultItem.Date__c));
        System.assertEquals(expectMinutes, String.valueOf(resultItem.Minutes__c));

        Test.stopTest();
    }

    @isTest static void InsertEntry_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 4;

        String contractId = null;
        String productId = null;
        String createdDate = null;
        String hours = null;
        String employeeId = null;
       
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.insertEntry(contractId, productId, createdDate, hours, employeeId);
        System.debug('@@@ InsertEntry_ParamsNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void InsertEntries_ValidParams_ReturnInsertedTimeTracking() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedExpenseId = true;
        Integer expectNumberItems = 1;

        Map<String, Object> itemTimeTracking = TestDataFactory.getNewTimeTracking();    

        Date createdDate = (Date)itemTimeTracking.get('createdDate');
        DateTime dt = DateTime.newInstanceGMT(createdDate.year(), createdDate.month(), createdDate.day());
        String expectCreatedDate = dt.formatGmt(TestDataFactory.DATE_FORMAT);

        String contractResourceId = (String)itemTimeTracking.get('contractResourceId');
        String contractId = (String)itemTimeTracking.get('contractId');
        String expectProductId = (String)itemTimeTracking.get('productId');
        String expectMinutes = String.valueOf(itemTimeTracking.get('minutes'));
        String employeeId = (String)itemTimeTracking.get('employeeId');

        List<Map<String, Object>> listEntries = new List<Map<String, Object>>{
            new Map<String, Object>{
                'contractResourceId' => contractResourceId, 
                'productId' => expectProductId, 
                'date' => expectCreatedDate,
                'minutes' => expectMinutes
            }
        };

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.insertEntries(contractId, listEntries, employeeId);
        System.debug('@@@ InsertEntries_ValidParams_ReturnInsertedTimeTracking:result:' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        List<Timesheet_Entry__c> resultListItems = ((List<Timesheet_Entry__c>)resultData.get('list'));
        Timesheet_Entry__c resultItem = resultListItems[0];//TODO: Convert item to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectCreatedExpenseId, resultItem.Id != null);
        System.assertEquals(expectProductId, (String)resultItem.Product__c);
        System.assertEquals(expectCreatedDate, String.valueOf(resultItem.Date__c));
        System.assertEquals(expectMinutes, String.valueOf(resultItem.Minutes__c));
        
        Test.stopTest();
    }

    @isTest static void InsertEntries_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 2;

        String contractId = null;        
        List<Map<String, Object>> listEntries = null;
        String employeeId = null;

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.insertEntries(contractId, listEntries, employeeId);
        System.debug('@@@ InsertEntries_ParamsAreNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void UpdateEntry_ValidParams_ReturnUpdatedList() {
        String expectResponseStatus = 'success';
        Integer expectNumberItems = 1;

        String employeeId = UserInfo.getUserId();

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByEmployee(employeeId, 'New');
        Timesheet_Entry__c timesheetEntry = timesheetEntries.get(0);

        String expectTimesheetEntryId = timesheetEntry.Id;     
        Decimal expectMinutes = TestDataFactory.MINUTES_150;
        
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.updateEntry(expectTimesheetEntryId, String.valueOf(expectMinutes));
        System.debug('@@@ UpdateEntry_ValidParams_ReturnUpdatedList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');       
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)resultData.get('list');
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectTimesheetEntryId, resultItem.Id);
        System.assertEquals(expectMinutes, resultItem.Minutes__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 2;

        String timesheetEntryId = null;    
        String minutes = null;
       
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.updateEntry(timesheetEntryId, minutes);
        System.debug('@@@ UpdateEntry_ParamsNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void UpdateEntries_ValidParams_ReturnInsertedList() {
        String expectResponseStatus = 'success';
        Integer expectNumberItems = 1;

        String employeeId = UserInfo.getUserId();
        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByEmployee(employeeId, 'New');
        Timesheet_Entry__c timesheetEntry = timesheetEntries.get(0);

        Id expectTimesheetEntryId = timesheetEntry.Id;     
        Decimal expectMinutes = TestDataFactory.MINUTES_150;

        List<Map<String, Object>> listEntries = new List<Map<String, Object>>{
            new Map<String, Object>{
                'id' => expectTimesheetEntryId, 
                'minutes' => String.valueOf(expectMinutes)
            }
        };

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.updateEntries(listEntries);
        System.debug('@@@ UpdateEntries_ValidParams_ReturnInsertedList:result:' + result);
        
        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)resultData.get('list');
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectTimesheetEntryId, resultItem.Id);
        System.assertEquals(expectMinutes, resultItem.Minutes__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntries_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        List<Map<String, Object>> listEntries = null;
       
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.updateEntries(listEntries);
        System.debug('@@@ UpdateEntries_ParamsNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetContractsAndUsersListByAccount_AccountIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String accountId = TestDataFactory.getAccountId();

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_AccountIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContractsAndUsersListByAccount_AccountIdNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String accountId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_AccountIdNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetContractsAndUsersListByAccount_AccountIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String accountId = null;
       
        Test.startTest();

        Map<String, Object> result = TimeTrackingController.getContractsAndUsersListByAccount(accountId);
        System.debug('@@@ GetContractsAndUsersListByAccount_AccountIdNull_ReturnValidationErrors:result: ' + result);
        
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