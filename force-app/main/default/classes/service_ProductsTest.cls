@isTest
public with sharing class service_ProductsTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetList_WithoutParams_ReturnNotEmptyList() {
        Integer expectSizeList = TestDataFactory.PRODUCTS_COUNT;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');

        service_Response response = new service_Response();

        Test.startTest();

        service_Products serviceProducts = new service_Products();
        serviceProducts.process(request, response);
        List<Product2> resultListItems = (List<Product2>)response.Parameters.get('list');
        System.debug('@@@ GetList_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }
}