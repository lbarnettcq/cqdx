@isTest
public with sharing class dao_TimesheetTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
            
        String expectId = TestDataFactory.getTimesheetId();

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c resultItem = daoTimesheet.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNotExistInDB_ReturnNull() {
        Timesheet__c expectNotExistItem = null;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c resultItem = daoTimesheet.findOne(id);
        System.debug('@@@ FindOne_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNull_ReturnNull() {
        Timesheet__c expectNotExistItem = null;
            
        String id = null;

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c resultItem = daoTimesheet.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsExistInDB_ReturnNotEmptyList() {
        Boolean expectList = true;

        Set<String> ids = new Set<String>();

        Set<Id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectList, resultListItems.size() > 0);

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = TestDataFactory.getNotExistIds();

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = null;

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

     @isTest static void FindAllByIds_WithoutIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = new Set<String>();

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_WithoutIds_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

   /* @isTest static void FindAllForInvoice_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Set<String> ids = new Set<String>();

        Set<Id> timesheetsIds = TestDataFactory.getTimesheetsIds();
        for(Id id : timesheetsIds) {
            ids.add((String)id);
        }

        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllForInvoice(ids, startDate, endDate);
        System.debug('@@@ FindAllForInvoice_ValidParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllForInvoice_IdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = TestDataFactory.getNotExistIds();
        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllForInvoice(ids, startDate, endDate);
        System.debug('@@@ FindAllForInvoice_IdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAllForInvoice_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = null;
        Date startDate = null;
        Date endDate = null;

        Test.startTest();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> resultListItems = daoTimesheet.findAllForInvoice(ids, startDate, endDate);
        System.debug('@@@ FindAllForInvoice_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }*/
}