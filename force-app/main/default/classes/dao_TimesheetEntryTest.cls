@isTest
public with sharing class dao_TimesheetEntryTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
        
        Timesheet_Entry__c te = TestDataFactory.getTimesheetEntryFromDB();
        String expectId = te.Id;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNotExistInDB_ReturnNull() {
        Boolean expectNotExistItem = true;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOne(id);
        System.debug('@@@ FindOne_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem == null);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNull_ReturnNull() {
        Timesheet_Entry__c expectNotExistItem = null;
            
        String id = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_ValidDatesParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Timesheet__c timesheet = TestDataFactory.getTimesheet('Approved');

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findAll(params);
        System.debug('@@@ FindAll_ValidDatesParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAll_DatesRangeNotValid_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START_WITHOUT_DATA),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END_WITHOUT_DATA)
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findAll(params);
        System.debug('@@@ FindAll_DatesRangeNotValid_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAll_TimesheetIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Timesheet__c timesheet = TestDataFactory.getTimesheet(TestDataFactory.TIMESHEET_STATUS_APPROVED);

        Map<String, Object> params = new Map<String, Object>{
            'timesheetId' => timesheet.Id
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findAll(params);
        System.debug('@@@ FindAll_TimesheetIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findAll(params);
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAll_ParamsNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findAll(params);
        System.debug('@@@ FindAll_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByDates_ValidParamsWithTimesheet_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        Timesheet__c  timesheet = TestDataFactory.getTimesheetByEmployee(employeeId);
        List<Date> dates = new List<Date>();
        Date startDate = timesheet.StartDate__c;
        Date endDate = timesheet.EndDate__c;

        while(startDate <= endDate) {
            dates.add(startDate);
            startDate = startDate.addDays(1);
        } 

        Map<String, Object> params = new Map<String, Object>{
            'dateList' => dates,
            'employeeId' => employeeId,
            'timesheetId' => timesheet.Id
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDates(params);
        System.debug('@@@ FindByDates_ValidParamsWithTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByDates_ValidParamsWithoutTimesheet_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        Timesheet__c  timesheet = TestDataFactory.getTimesheetByEmployee(employeeId);
        List<Date> dates = new List<Date>();
        Date startDate = timesheet.StartDate__c;
        Date endDate = timesheet.EndDate__c;

        while(startDate <= endDate) {
            dates.add(startDate);
            startDate = startDate.addDays(1);
        }

        Map<String, Object> params = new Map<String, Object>{
            'dateList' => dates,
            'employeeId' => employeeId
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDates(params);
        System.debug('@@@ FindByDates_ValidParamsWithoutTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByDates_EmptyList_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{};

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDates(params);
        System.debug('@@@ FindByDates_EmptyList_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByDates_ListNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDates(params);
        System.debug('@@@ FindByDates_EmptyList_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByDateRange_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        Timesheet__c  timesheet = TestDataFactory.getTimesheetByEmployee(employeeId);

        Map<String, Object> conditions = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c,
            'employeeId' => employeeId
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDateRange(conditions);
        System.debug('@@@ FindByDateRange_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByDateRange_EmptyList_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDateRange(params);
        System.debug('@@@ FindByDateRange_EmptyList_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByDateRange_ListNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByDateRange(params);
        System.debug('@@@ FindByDateRange_ListNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdExistInDB_ReturnItem() {   
        Timesheet_Entry__c notExistItem = null;

        String id = TestDataFactory.getTimesheetId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdNotExistInDB_ReturnNull() {
        Timesheet_Entry__c expectNotExistItem = null;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdNull_ReturnItem() {
        Timesheet_Entry__c notExistItem = null;
            
        String id = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdNull_ReturnItem:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_IdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
            
        String id = TestDataFactory.getTimesheetId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByTimesheet(id);
        System.debug('@@@ FindByTimesheet_IdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_IdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultListItems = daoTimesheetEntry.findByTimesheet(id);
        System.debug('@@@ FindByTimesheet_IdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_IdNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
            
        String id = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c>  resultListItems = daoTimesheetEntry.findByTimesheet(id);
        System.debug('@@@ FindByTimesheet_IdNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindTimesheetsByContractResources_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        String employeeId = UserInfo.getUserId();
        Set<String> contractResourcesIds = TestDataFactory.getContractResourcesIds(employeeId);
        
        Date startDate = null;
        Date endDate = null;

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                startDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate')));
                endDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate')));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findTimesheetsByContractResources(contractResourcesIds, startDate, endDate);
        System.debug('@@@ FindTimesheetsByContractResources_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindTimesheetsByContractResources_ContractResourcesIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> contractResourcesIds = TestDataFactory.getNotExistIds();

        Date startDate = null;
        Date endDate = null;

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                startDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate')));
                endDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate')));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findTimesheetsByContractResources(contractResourcesIds, startDate, endDate);
        System.debug('@@@ FindTimesheetsByContractResources_ContractResourcesIdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindTimesheetsByContractResources_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> contractResourcesIds = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findTimesheetsByContractResources(contractResourcesIds, startDate, endDate);
        System.debug('@@@ FindTimesheetsByContractResources_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByContractResources_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
            
        String employeeId = UserInfo.getUserId();
        Set<String> contractResourcesIds = TestDataFactory.getContractResourcesIds(employeeId);

        Set<Date> dates = new Set<Date>();

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                dates.add(Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate'))));
                dates.add(Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate'))));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByContractResources(contractResourcesIds, dates);
        System.debug('@@@ FindByContractResources_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByContractResources_ContractResourcesIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> contractResourcesIds = TestDataFactory.getNotExistIds();
        
        Set<Date> dates = new Set<Date>();

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                dates.add(Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate'))));
                dates.add(Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate'))));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByContractResources(contractResourcesIds, dates);
        System.debug('@@@ FindByContractResources_ContractResourcesIdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByContractResources_ParamsNull_ReturnEmptyList() {
        Boolean expectEmptyList = true;
            
        Set<String> contractResourcesIds = null;
        Set<Date> dates = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByContractResources(contractResourcesIds, dates);
        System.debug('@@@ FindByContractResources_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectEmptyList, resultListItems.size() == 0);

        Test.stopTest();
    }

    @isTest static void FindByContractResources_ParamsEmpty_ReturnEmptyList() {
        Boolean expectEmptyList = true;
            
        Set<String> contractResourcesIds = new Set<String>();
        Set<Date> dates = new Set<Date>();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByContractResources(contractResourcesIds, dates);
        System.debug('@@@ FindByContractResources_ParamsEmpty_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectEmptyList, resultListItems.size() == 0);

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        Set<String> ids = new Set<String>();

        Set<Id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }

        Date startDate = null;
        Date endDate = null;

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                startDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate')));
                endDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate')));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByTimesheets(ids, startDate, endDate);
        System.debug('@@@ FindByTimesheets_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_TimesheetsIdsNotExistInDB_ReturnEmptyList() {
        Boolean expectEmptyList = true;
            
        Set<String> timesheetsIds = TestDataFactory.getNotExistIds();
        
        Date startDate = null;
        Date endDate = null;

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();

        for(Object dateRange : dateRanges) {
            if((Boolean)((Map<String, Object>)dateRange).get('createTimesheet')) {
                startDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate')));
                endDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate')));
                break;
            }
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByTimesheets(timesheetsIds, startDate, endDate);
        System.debug('@@@ FindByTimesheets_TimesheetsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectEmptyList, resultListItems.size() == 0);

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByTimesheets(timesheetsIds, startDate, endDate);
        System.debug('@@@ FindByTimesheets_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindEmployeeByTimesheet_IdExistInDB_ReturnItem() {
        Boolean expectItem = true;
        Boolean expectEmployee = true;
            
        String timesheetId = TestDataFactory.getTimesheetId();
        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findEmployeeByTimesheet(timesheetId);
        System.debug('@@@ FindEmployeeByTimesheet_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectItem, resultItem != null);
        System.assertEquals(expectEmployee, resultItem.Employee__c != null);
        

        Test.stopTest();
    }

    @isTest static void FindEmployeeByTimesheet_IdNotExistInDB_ReturnNull() {
        Timesheet_Entry__c expectNotExistItem = null;
            
        String timesheetId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findEmployeeByTimesheet(timesheetId);
        System.debug('@@@ FindEmployeeByTimesheet_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindEmployeeByTimesheet_IdNull_ReturnItem() {
        Boolean expectExistItem = true;
        Timesheet_Entry__c notExistItem = null;
            
        String timesheetId = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c resultItem = daoTimesheetEntry.findEmployeeByTimesheet(timesheetId);
        System.debug('@@@ FindEmployeeByTimesheet_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != notExistItem);

        Test.stopTest();
    }

    @isTest static void FindByReport_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        List<Timesheet__c> timesheets = TestDataFactory.getTimesheetsFromDB(TestDataFactory.TIMESHEET_STATUS_PENDING);
        Timesheet__c timesheet = timesheets[0];

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        Timesheet_Entry__c timesheetEntry = timesheetEntries[0];

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c,
            'employeeId' => timesheetEntry.Employee__c,
            'status' => (timesheetEntry.Is_Approved__c ? 'approved' : 'unlocked'),//TODO:Change to Boolean
            'timesheetId' => timesheet.Id
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_TimesheetIdNull_ReturnNotEmptyList() {
        Boolean expectList = true;
        Integer sizeEmptyList = 0;
            
        List<Timesheet__c> timesheets = TestDataFactory.getTimesheetsFromDB(TestDataFactory.TIMESHEET_STATUS_PENDING);
        Timesheet__c timesheet = timesheets[0];

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        Timesheet_Entry__c timesheetEntry = timesheetEntries[0];

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c,
            'employeeId' => timesheetEntry.Employee__c,
            'status' => (timesheetEntry.Is_Approved__c ? 'approved' : 'unlocked'),//TODO:Change to Boolean
            'timesheetId' => null
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultList = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_TimesheetIdNull_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectList, resultList.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_StatusNullTimesheetIdExistInDB_ReturnNotEmptyList() {
        Boolean expectList = true;
        Integer sizeEmptyList = 0;

        List<Timesheet__c> timesheets = TestDataFactory.getTimesheetsFromDB(TestDataFactory.TIMESHEET_STATUS_PENDING);
        Timesheet__c timesheet = timesheets[0];

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        Timesheet_Entry__c timesheetEntry = timesheetEntries[0];

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c,
            'employeeId' => timesheetEntry.Employee__c,
            'status' => null,
            'timesheetId' => timesheet.Id
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_StatusNullTimesheetIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_StatusTimesheetIdNull_ReturnNotEmptyList() {
        Boolean expectList = true;
        Integer sizeEmptyList = 0;

        List<Timesheet__c> timesheets = TestDataFactory.getTimesheetsFromDB(TestDataFactory.TIMESHEET_STATUS_PENDING);
        Timesheet__c timesheet = timesheets[0];

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        Timesheet_Entry__c timesheetEntry = timesheetEntries[0];

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c,
            'employeeId' => timesheetEntry.Employee__c,
            'status' => null,
            'timesheetId' => null
        };

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_StatusTimesheetIdNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByReport_EmptyList_ReturnEmptyList() {
        Boolean expectEmptyList = true;
            
        Map<String, Object> params = new Map<String, Object>{};

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_EmptyList_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectEmptyList, resultListItems.size() == 0);

        Test.stopTest();
    }

    @isTest static void FindByReport_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Map<String, Object> params = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.findByReport(params);
        System.debug('@@@ FindByReport_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

     @isTest static void GetTotalTime_TimesheetIdExistInDB_ReturnTotalTime() {
        Boolean expectTotalTime = true;
        Boolean expectProperty = true;
        Integer sizeEmptyMap = 0;
        String notExistProperty = null;
            
        String timesheetId = TestDataFactory.getTimesheetId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Map<String, String> resultTotalTime = daoTimesheetEntry.getTotalTime(timesheetId);
        System.debug('@@@ GetTotalTime_TimesheetIdExistInDB_ReturnTotalTime:result: ' + resultTotalTime);

        System.assertEquals(expectTotalTime, resultTotalTime.size() > sizeEmptyMap);
        System.assertEquals(expectProperty, resultTotalTime.get('employeeId') != notExistProperty);
        System.assertEquals(expectProperty, resultTotalTime.get('contractResourceId') != notExistProperty);
        System.assertEquals(expectProperty, resultTotalTime.get('totalMinutes') != notExistProperty);

        Test.stopTest();
    }

     @isTest static void GetTotalTime_TimesheetIdNotExistInDB_ReturnEmptyTotalTime() {
        Integer expectSizeEmptyMap = 0;
            
        String timesheetId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Map<String, String> resultTotalTime = daoTimesheetEntry.getTotalTime(timesheetId);
        System.debug('@@@ GetTotalTime_TimesheetIdNotExistInDB_ReturnEmptyTotalTime:result: ' + resultTotalTime);

        System.assertEquals(expectSizeEmptyMap, resultTotalTime.size());

        Test.stopTest();
    }


    @isTest static void GetTotalTime_TimesheetIdNull_ReturnTotalTime() {
        Boolean expectTotalTime = true;
        Boolean expectProperty = true;
        Integer sizeEmptyMap = 0;
        String notExistProperty = null;
            
        String timesheetId = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Map<String, String> resultTotalTime = daoTimesheetEntry.getTotalTime(timesheetId);
        System.debug('@@@ GetTotalTime_TimesheetIdNull_ReturnTotalTime:result: ' + resultTotalTime);

        System.assertEquals(expectTotalTime, resultTotalTime.size() > sizeEmptyMap);
        System.assertEquals(expectProperty, resultTotalTime.get('employeeId') != notExistProperty);
        System.assertEquals(expectProperty, resultTotalTime.get('contractResourceId') != notExistProperty);
        System.assertEquals(expectProperty, resultTotalTime.get('totalMinutes') != notExistProperty);

        Test.stopTest();
    }

    @isTest static void GetTotalTimeForTimesheets_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.getTotalTimeForTimesheets();
        System.debug('@@@ GetTotalTimeForTimesheets_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalTimeForTimesheetsByIds_IdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
            
        Set<String> ids = new Set<String>();

        Set<Id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultListItems = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(ids);//convert from string to id
        System.debug('@@@ GetTotalTimeForTimesheetsByIds_IdsExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalTimeForTimesheetsByIds_IdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> ids = TestDataFactory.getNotExistIds();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultList = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(ids);
        System.debug('@@@ GetTotalTimeForTimesheetsByIds_IdsNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTotalTimeForTimesheetsByIds_WithoutIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> ids = new Set<String>();

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultList = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(ids);
        System.debug('@@@ GetTotalTimeForTimesheetsByIds_WithoutIds_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTotalTimeForTimesheetsByIds_IdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> ids = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> resultList = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(ids);
        System.debug('@@@ GetTotalTimeForTimesheetsByIds_IdsNull_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    //Salesperson
    @isTest static void GetTimesheetsEntriesBySalesperson_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        Timesheet__c ts = TestDataFactory.getTimesheet(TestDataFactory.TIMESHEET_STATUS_APPROVED);
        Set<String> ids = new Set<String>{ts.Id};

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(ids);
        Timesheet_Entry__c te = timesheetEntries[0];

        String receiverId = te.Contract_Resource__r.Contract__r.Salesperson__c;
        Date startDate = ts.StartDate__c;
        Date endDate = ts.EndDate__c;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySalesperson_ValidParams_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectNotEmptyList, resultList.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySalesperson_TimesheetIdsNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = TestDataFactory.getNotExistIds();
        String receiverId = UserInfo.getUserId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySalesperson_TimesheetIdsNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySalesperson_ReceiverIdNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = new Set<String>();
        Set<id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }
        String receiverId = TestDataFactory.getNotExistId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySalesperson_ReceiverIdNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySalesperson_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = new Set<String>();
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySalesperson_WithoutParams_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySalesperson_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = null;
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySalesperson(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySalesperson_ParamsNull_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    //Refferal
    @isTest static void GetTimesheetsEntriesByRefferal_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Timesheet__c ts = TestDataFactory.getTimesheet(TestDataFactory.TIMESHEET_STATUS_APPROVED);
        Set<String> ids = new Set<String>{ts.Id};

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(ids);
        Timesheet_Entry__c te = timesheetEntries[0];

        String receiverId = te.Contract_Resource__r.Contract__r.Referred_By__c;
        Date startDate = ts.StartDate__c;
        Date endDate = ts.EndDate__c;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesByRefferal(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesByRefferal_ValidParams_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectNotEmptyList, resultList.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesByRefferal_TimesheetIdsNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = TestDataFactory.getNotExistIds();
        String receiverId = TestDataFactory.getAccountId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesByRefferal(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesByRefferal_TimesheetIdsNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesByRefferal_ReceiverIdNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = new Set<String>();
        Set<id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }
        String receiverId = TestDataFactory.getNotExistId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesByRefferal(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesByRefferal_ReceiverIdNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesByRefferal_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = new Set<String>();
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesByRefferal(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesByRefferal_WithoutParams_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesByRefferal_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = null;
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesByRefferal(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesByRefferal_ParamsNull_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    //Subcontractor
    @isTest static void GetTimesheetsEntriesBySubcontractor_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        
        Set<String> ids = new Set<String>();
        Set<id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }

        String receiverId = TestDataFactory.getAccountId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySubcontractor_ValidParams_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectNotEmptyList, resultList.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySubcontractor_TimesheetIdsNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = TestDataFactory.getNotExistIds();
        String receiverId = TestDataFactory.getAccountId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySubcontractor_TimesheetIdsNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySubcontractor_ReceiverIdNotExistInDB_ReturnEmptyList() {
        Integer sizeEmptyList = 0;
            
        Set<String> ids = new Set<String>();
        Set<id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }
        String receiverId = TestDataFactory.getNotExistId();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(ids, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySubcontractor_ReceiverIdNotExistInDB_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(sizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySubcontractor_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = new Set<String>();
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySubcontractor_WithoutParams_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void GetTimesheetsEntriesBySubcontractor_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
            
        Set<String> timesheetsIds = null;
        String receiverId = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> resultList = daoTimesheetEntry.getTimesheetsEntriesBySubcontractor(timesheetsIds, receiverId, startDate, endDate);
        System.debug('@@@ GetTimesheetsEntriesBySubcontractor_ParamsNull_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }
}