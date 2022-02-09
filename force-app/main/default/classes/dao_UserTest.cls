@isTest
public with sharing class dao_UserTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;            
        String expectId = TestDataFactory.getUserId();

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNotExistInDB_ReturnNull() {
        User expectNotExistItem = null;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOne(id);
        System.debug('@@@ FindOne_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNull_ReturnNull() {
        User expectNotExistItem = null;
            
        String id = null;

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
        User notExistUser = null;
            
        String id = TestDataFactory.getTimesheetId();

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != notExistUser);

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdNotExistInDB_ReturnNull() {
        User expectNotExistItem = null;
            
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByTimesheet_TimesheetIdNull_ReturnItem() {
        Boolean expectExistItem = true;
        User notExistUser = null;
            
        String id = null;

        Test.startTest();

        dao_User daoUser = new dao_User();
        User resultItem = daoUser.findOneByTimesheet(id);
        System.debug('@@@ FindOneByTimesheet_TimesheetIdNull_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != notExistUser);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Set<String> ids = TestDataFactory.getUsersIds();

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = TestDataFactory.getNotExistIds();

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_IdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = null;

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_IdsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAllByIds_WithoutdIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> ids = new Set<String>();

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAllByIds(ids);
        System.debug('@@@ FindAllByIds_WithoutdIds_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindAllWithTimesheetEntries_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_User daoUser = new dao_User();
        List<User> resultListItems = daoUser.findAllWithTimesheetEntries();
        System.debug('@@@ FindAllWithTimesheetEntries_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }
}