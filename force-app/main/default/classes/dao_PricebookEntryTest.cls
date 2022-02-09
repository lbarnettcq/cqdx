@isTest
public with sharing class dao_PricebookEntryTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_IdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
        
        PricebookEntry pe = TestDataFactory.getPricebookEntryFromDb();
        String expectId = pe.Id;

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        PricebookEntry resultItem = daoPricebookEntry.findOne(expectId);
        System.debug('@@@ FindOne_IdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNotExistInDB_ReturnNull() {
        PricebookEntry expectNotExistItem = null;
        
        String id = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        PricebookEntry resultItem = daoPricebookEntry.findOne(id);
        System.debug('@@@ FindOne_IdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_IdNull_ReturnNull() {
        PricebookEntry expectNotExistItem = null;
        
        String id = null;

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        PricebookEntry resultItem = daoPricebookEntry.findOne(id);
        System.debug('@@@ FindOne_IdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        List<PricebookEntry> resultListItems = daoPricebookEntry.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void FindByIds_IdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Set<String> ids = TestDataFactory.getPricebookEntriesIds();

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        List<PricebookEntry> resultListItems = daoPricebookEntry.findByIds(ids);
        System.debug('@@@ FindByIds_IdsExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByIds_IdsNotExistInDB_ReturnEmptyList() {
        Integer expecSizeEmptyList = 0;
         
        Set<String> ids = TestDataFactory.getNotExistIds();

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        List<PricebookEntry> resultListItems = daoPricebookEntry.findByIds(ids);
        System.debug('@@@ FindByIds_IdsNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expecSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByIds_IdsEmptyList_ReturnEmptyList() {
        Integer expecSizeEmptyList = 0;
         
        Set<String> ids = new Set<String>();

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        List<PricebookEntry> resultListItems = daoPricebookEntry.findByIds(ids);
        System.debug('@@@ FindByIds_IdsEmptyList_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expecSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByIds_IdsNull_ReturnEmptyList() {
        Integer expecSizeEmptyList = 0;
         
        Set<String> ids = new Set<String>();

        Test.startTest();

        dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
        List<PricebookEntry> resultListItems = daoPricebookEntry.findByIds(ids);
        System.debug('@@@ FindByIds_IdsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expecSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }
}