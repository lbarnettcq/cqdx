@isTest
public with sharing class service_DIInvoicesExpenseEntryTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void GetList_InvoiceIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('invoiceId', invoice.Id);

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_InvoiceIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_InvoiceIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('invoiceId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
            System.debug('@@@ GetList_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetList_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetList_InvoiceIdNull_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('invoiceId', null);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
            System.debug('@@@ GetList_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetList_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }
}