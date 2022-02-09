@isTest
public with sharing class dao_Product2Test {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.PRODUCTS_COUNT;

        Test.startTest();

        dao_Product2 daoProduct2 = new dao_Product2();
        List<Product2> resultListItems = daoProduct2.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }
}