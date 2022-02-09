@isTest
public with sharing class service_TimesheetEntryTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<String> employeesIds = new List<String>{employeeId};

        List<String> contractsIds = TestDataFactory.getContractsIdsFromContractResources(employeeId);        

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('userIds', employeesIds);
        request.Parameters.put('contractIds', contractsIds);
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');//TODO: review if need convert to map
        System.debug('@@@ GetList_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assert(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_NotExistContractEmployee_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;     

        List<String> contractsIds = new List<String>{TestDataFactory.getNotExistId()};
        List<String> employeesIds = new List<String>{TestDataFactory.getNotExistId()};

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('userIds', employeesIds);
        request.Parameters.put('contractIds', contractsIds);
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');//TODO: review if need convert to map
        System.debug('@@@ GetList_NotExistContractEmployee_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('userIds', null);
        request.Parameters.put('contractIds', null);
        request.Parameters.put('startDate', null);
        request.Parameters.put('endDate', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');//TODO: review if need convert to map
        System.debug('@@@ GetList_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParams_ReturnInsertedTimeTracking() {
        Id notCreatedId = null;
        Integer expectNumberItems = 1;
        Integer sizeEmptyList = 0;

        Map<String, Object> itemTimeTracking = TestDataFactory.getNewTimeTracking();    

        Date createdDate = (Date)itemTimeTracking.get('createdDate');
        DateTime dt = DateTime.newInstanceGMT(createdDate.year(), createdDate.month(), createdDate.day());
        String expectCreatedDate = dt.formatGmt(TestDataFactory.DATE_FORMAT);

        String contractId = (String)itemTimeTracking.get('contractId');
        String expectProductId = (String)itemTimeTracking.get('productId');        
        String expectMinutes = String.valueOf(itemTimeTracking.get('minutes'));
        String employeeId = (String)itemTimeTracking.get('employeeId');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', contractId);
        request.Parameters.put('productId', expectProductId);
        request.Parameters.put('createdDate', expectCreatedDate);
        request.Parameters.put('minutes', expectMinutes);
        request.Parameters.put('employeeId', employeeId);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedTimeTracking:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertNotEquals(notCreatedId, resultItem.Id);
        System.assertEquals(expectProductId, (String)resultItem.Product__c);
        System.assertEquals(expectCreatedDate, String.valueOf(resultItem.Date__c));
        System.assertEquals(expectMinutes, String.valueOf(resultItem.Minutes__c));

        Test.stopTest();
    }

    @isTest static void InsertEntry_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        
        System.debug('@@@ InsertEntry_WithoutParams_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void InsertEntry_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', null);
        request.Parameters.put('productId', null);
        request.Parameters.put('createdDate', null);
        request.Parameters.put('minutes', null);
        request.Parameters.put('userId', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        
        System.debug('@@@ InsertEntry_ParamsNull_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void Insert_ValidParams_ReturnNotEmptyList() {
        Id notCreatedId = null;
        Integer expectNumberItems = 1;
        Integer sizeEmptyList = 0;

        Map<String, Object> itemTimeTracking = TestDataFactory.getNewTimeTracking();    

        Date createdDate = (Date)itemTimeTracking.get('createdDate');
        DateTime dt = DateTime.newInstanceGMT(createdDate.year(), createdDate.month(), createdDate.day());
        String expectCreatedDate = dt.formatGmt(TestDataFactory.DATE_FORMAT);

        String contractResourceId = (String)itemTimeTracking.get('contractResourceId');
        String contractId = (String)itemTimeTracking.get('contractId');
        String expectProductId = (String)itemTimeTracking.get('productId');
        String expectMinutes = String.valueOf(itemTimeTracking.get('minutes'));
        String employeeId = (String)itemTimeTracking.get('employeeId');

        List<Map<String, Object>> entries = new List<Map<String, Object>>{
            new Map<String, Object>{
                'contractResourceId' => contractResourceId, 
                'productId' => expectProductId, 
                'date' => expectCreatedDate,
                'minutes' => expectMinutes
            }
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insert');
        request.Parameters.put('employeeId', employeeId);
        request.Parameters.put('list', entries);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.debug('@@@ Insert_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertNotEquals(notCreatedId, resultItem.Id);
        System.assertEquals(expectProductId, (String)resultItem.Product__c);
        System.assertEquals(expectCreatedDate, String.valueOf(resultItem.Date__c));
        System.assertEquals(expectMinutes, String.valueOf(resultItem.Minutes__c));

        Test.stopTest();
    }

    @isTest static void Insert_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insert');

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ Insert_WithoutParams_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void Insert_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insert');
        request.Parameters.put('employeeId', null);
        request.Parameters.put('list', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ Insert_ParamsNull_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParams_ReturnUpdatedList() {
        Integer expectNumberItems = 1;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByEmployee(employeeId, 'New');
        Timesheet_Entry__c timesheetEntry = timesheetEntries.get(0);

        String expectTimesheetEntryId = timesheetEntry.Id;     
        Decimal expectMinutes = TestDataFactory.MINUTES_150;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('timesheetEntryId', expectTimesheetEntryId);
        request.Parameters.put('minutes', expectMinutes);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.debug('@@@ UpdateEntry_ValidParams_ReturnUpdatedList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectTimesheetEntryId, (String)resultItem.Id);
        System.assertEquals(expectMinutes, resultItem.Minutes__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_WithoutParams_ReturnEmptyList() {
        Integer expectNumberItems = 0;  

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ UpdateEntry_WithoutParams_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsNull_ReturnEmptyList() {
        Integer expectNumberItems = 0;  

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('timesheetEntryId', null);
        request.Parameters.put('minutes', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ UpdateEntry_ParamsNull_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateEntries_ValidParams_ReturnUpdatedList() {
        Integer expectNumberItems = 1;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByEmployee(employeeId, 'New');
        Timesheet_Entry__c timesheetEntry = timesheetEntries.get(0);

        Id expectTimesheetEntryId = timesheetEntry.Id;     
        Decimal expectMinutes = TestDataFactory.MINUTES_150;

        List<Map<String, Object>> entries = new List<Map<String, Object>>{
            new Map<String, Object>{
                'id' => expectTimesheetEntryId, 
                'minutes' => String.valueOf(expectMinutes)
            }
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'update');
        request.Parameters.put('list', entries);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map
        Timesheet_Entry__c resultItem = resultListItems[0];

        System.debug('@@@ UpdateEntries_ValidParams_ReturnUpdatedList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());
        System.assertEquals(expectTimesheetEntryId, resultItem.Id);
        System.assertEquals(expectMinutes, resultItem.Minutes__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntries_WithoutParams_ReturnEmptyList() {
        Integer expectNumberItems = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'update');

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ UpdateEntries_WithoutParams_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateEntries_ParamsNull_ReturnEmptyList() {
        Integer expectNumberItems = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'update');
        request.Parameters.put('list', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_TimesheetEntry serviceTimesheetEntry = new service_TimesheetEntry();
        serviceTimesheetEntry.process(request, response);
        List<Timesheet_Entry__c> resultListItems = (List<Timesheet_Entry__c>)response.Parameters.get('list');//TODO: review if need convert to map

        System.debug('@@@ UpdateEntries_ParamsNull_ReturnEmptyList:result: ' + resultListItems);
        
        System.assertEquals(expectNumberItems, resultListItems.size());

        Test.stopTest();
    }
}