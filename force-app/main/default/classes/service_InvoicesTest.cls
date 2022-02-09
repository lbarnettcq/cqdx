@isTest
public with sharing class service_InvoicesTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZero_ReturnEmptyList() {
        Integer expectSizeList = 0;

        Integer limits = 0;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitOffsetZero_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList() {
        Integer expectSizeList = DIInvoicesTestDataFactory.getInvoicesFromDB().size();

        Integer limits = expectSizeList;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        Integer resultSizeList = resultListItems.size();
        System.debug('@@@ GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsGreatMaxOffset_ReturnNotEmptyList() {
        Integer expectSizeList = DIInvoicesTestDataFactory.getInvoicesFromDB().size();

        Integer limits = expectSizeList*5;
        Integer offset = 1;
        expectSizeList -= offset;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        Integer resultSizeList = resultListItems.size();
        System.debug('@@@ GetList_LimitCountItemsGreatMaxOffset_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnTotalCount() {
        Boolean expectNotZero = true;
        Integer zeroItems = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnTotalCount:result: ' + resultTotalCount);

        System.assertEquals(expectNotZero, resultTotalCount > zeroItems);

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice();
        String invoiceId = invoice.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetListItems_InvoiceIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String invoiceId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
            System.debug('@@@ GetListItems_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListItems_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdNull_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String invoiceId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
            System.debug('@@@ GetListItems_InvoiceIdNull_ReturnNoFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListItems_InvoiceIdNull_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_InvoiceIdExistInDB_ReturnCountItems() {
        Boolean expectNotZeroTotalCount = true;
        Integer zeroItems = 0;

        Integer limits = null;
        Integer offset = null;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice();
        String invoiceId = invoice.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalItemsCount_InvoiceIdExistInDB_ReturnCountItems:result: ' + resultTotalCount);

        System.assertEquals(expectNotZeroTotalCount, resultTotalCount > zeroItems);

        Test.stopTest();
    }


    @isTest static void GetTotalItemsCount_InvoiceIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String invoiceId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Integer resultTotalCount = (Integer)response.Parameters.get('count');
            System.debug('@@@ GetTotalItemsCount_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + resultTotalCount);
        } catch (Exception ex) {
            System.debug('@@@ GetTotalItemsCount_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_InvoiceIdNull_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String invoiceId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Integer resultTotalCount = (Integer)response.Parameters.get('count');
            System.debug('@@@ GetTotalItemsCount_InvoiceIdNull_ReturnNoFoundError:result: ' + resultTotalCount);
        } catch (Exception ex) {
            System.debug('@@@ GetTotalItemsCount_InvoiceIdNull_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetInformation_InvoiceIdExistInDB_ReturnItem() {
        Boolean expectItem = true;
        Integer zeroProperties = 0;
        Map<String, Object> notExistItem = null;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = invoice.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_InvoiceIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);
        System.assertEquals(expectItem, resultItem.size() > zeroProperties);
        System.assertEquals(invoiceId, (String)resultItem.get('invoiceId'));
        System.assertEquals(invoice.Minutes__c, (Decimal)resultItem.get('totalMinutes'));
        System.assertEquals(invoice.Expenses__c, (Decimal)resultItem.get('totalExpenses'));
        System.assertEquals(invoice.Amount__c, (Decimal)resultItem.get('totalAmount'));

        Test.stopTest();
    }

    @isTest static void GetInformation_InvoiceIdNotExistInDB_ReturnNoFoundError() {//TODO: return error not found
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String invoiceId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
            System.debug('@@@ GetInformation_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ GetInformation_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

     @isTest static void GetInformation_InvoiceIdNotNull_ReturnNoFoundError() {//TODO: return error not found
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String invoiceId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
            System.debug('@@@ GetInformation_InvoiceIdNotNull_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ GetInformation_InvoiceIdNotNull_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_NotExistAccountInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Date expectIssueDate = (Date)item.get('issueDate');
        Date expectDueDate = (Date)item.get('dueDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_NotExistAccountInDB_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_NotExistAccountInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_InvoiceExistInDateRange_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = (String)item.get('accountId');
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END);
        Date expectIssueDate = (Date)item.get('issueDate');
        Date expectDueDate = (Date)item.get('dueDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_InvoiceExistInDateRange_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_InvoiceExistInDateRange_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParams_ReturnInsertedInvoice() {
        Boolean expectCreatedInvoiceId = true;
        Invoice__c notExistItem = null;
        String notExistId = null;
        Boolean expectAmount = true;
        Boolean expectExpenses = true;
        Boolean expectMinutes = true;
        integer zeroNumber = 0;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = (String)item.get('accountId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Date expectIssueDate = (Date)item.get('issueDate');
        Date expectDueDate = (Date)item.get('dueDate');
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedInvoice:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);
        System.assertNotEquals(notExistId, resultItem.Id);
        System.assertEquals(expectAccountId, resultItem.Account__c);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);
        System.assertEquals(expectIssueDate, resultItem.IssueDate__c);
        System.assertEquals(expectDueDate, resultItem.DueDate__c);
        System.assertEquals(expectAmount, resultItem.Amount__c > zeroNumber);
        System.assertEquals(expectExpenses, resultItem.Expenses__c > zeroNumber);
        System.assertEquals(expectMinutes, resultItem.Minutes__c > zeroNumber);
        
        //invoice.Status__c = 'New';

        Test.stopTest();
    }

    @isTest static void InsertEntry_ParamsNull_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Date expectIssueDate = null;
        Date expectDueDate = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ParamsNull_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ParamsNull_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithExistInvoiceId_ReturnUpdatedInvoice() {
        Invoice__c notExistItem = null;
        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);

        Map<String, Object> newInvoice = DIInvoicesTestDataFactory.getNewInvoice();

        String expectInvoiceId = invoice.Id;
        String expectAccountId = (String)newInvoice.get('accountId');
        Date expectStartDate = (Date)newInvoice.get('startDate');
        Date expectEndDate = (Date)newInvoice.get('endDate');
        Date expectIssueDate = (Date)newInvoice.get('endDate');
        Date expectDueDate = (Date)newInvoice.get('endDate');
        Boolean expectAmount = true;
        Boolean expectExpenses = true;
        Boolean expectMinutes = true;
        integer zeroNumber = 0;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('invoiceId', expectInvoiceId);
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ UpdateEntry_ValidParamsWithExistInvoiceId_ReturnUpdatedInvoice:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);
        System.assertEquals(expectInvoiceId, resultItem.Id);
        System.assertEquals(expectAccountId, resultItem.Account__c);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);
        System.assertEquals(expectIssueDate, resultItem.IssueDate__c);
        System.assertEquals(expectDueDate, resultItem.DueDate__c);
        System.assertEquals(expectAmount, resultItem.Amount__c > zeroNumber);
        System.assertEquals(expectExpenses, resultItem.Expenses__c > zeroNumber);
        System.assertEquals(expectMinutes, resultItem.Minutes__c > zeroNumber);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithNotExistInvoiceIdInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);

        String expectInvoiceId  = TestDataFactory.getNotExistId();
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = item.StartDate__c;
        Date expectEndDate = item.EndDate__c;
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;
        
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('invoiceId', expectInvoiceId);
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ UpdateEntry_ValidParamsWithNotExistInvoiceIdInDB_ReturnNoFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ValidParamsWithNotExistInvoiceIdInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_DateRangeOut_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessError';
        Boolean expectedExceptionMessage = true;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);

        String expectInvoiceId  = item.Id;
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = ((Date)(item.StartDate__c)).addDays(-1);
        Date expectEndDate = ((Date)(item.EndDate__c)).addDays(1);
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('invoiceId', expectInvoiceId);
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_DateRangeOut_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_DateRangeOut_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsWithPaidInvoice_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);

        String expectInvoiceId  = item.Id;
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = item.StartDate__c;
        Date expectEndDate = item.EndDate__c;
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('invoiceId', expectInvoiceId);
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_ParamsWithPaidInvoice_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ParamsWithPaidInvoice_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsNull_ReturnNoDataFoundException() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String expectInvoiceId  = null;
        String expectAccountId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Date expectIssueDate = null;
        Date expectDueDate = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('invoiceId', expectInvoiceId);
        request.Parameters.put('accountId', expectAccountId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('issueDate', expectIssueDate);
        request.Parameters.put('dueDate', expectDueDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_ParamsNull_ReturnNoDataFoundException:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ParamsNull_ReturnNoDataFoundException:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdNotExistInDB_ReturnErrorNoFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String invoiceId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ DeleteEntry_InvoiceIdNotExistInDB_ReturnErrorNoFound:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_InvoiceIdNotExistInDB_ReturnErrorNoFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdPaidExistInDB_ReturnErrorNoAccess() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);
        String invoiceId = invoice.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ DeleteEntry_InvoiceIdPaidExistInDB_ReturnErrorNoAccess:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_InvoiceIdPaidExistInDB_ReturnErrorNoAccess:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdNewExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';
        
        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = invoice.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ DeleteEntry_InvoiceIdNewExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdNotExistInDBWithPaymentDate_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String invoiceId = TestDataFactory.getNotExistId();
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('invoiceId', invoiceId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ UpdateStatus_InvoiceIdNotExistInDBWithPaymentDate_ReturnNoFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ UpdateStatus_InvoiceIdNotExistInDBWithPaymentDate_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdNewExistInDBWithPaymentDate_ReturnStatusPending() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = 'Pending';

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = invoice.Id;
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('invoiceId', invoiceId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateStatus_InvoiceIdNewExistInDBWithPaymentDate_ReturnStatusPending:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDate_ReturnStatusPaid() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = DIInvoicesTestDataFactory.INVOICE_STATUS_PAID;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING);
        String invoiceId = invoice.Id;
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('invoiceId', invoiceId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDate_ReturnStatusPaid:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDateNull_ReturnStatusPaid() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = DIInvoicesTestDataFactory.INVOICE_STATUS_PAID;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING);
        String invoiceId = invoice.Id;
        Date paymentDate = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('invoiceId', invoiceId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDateNull_ReturnStatusPaid:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdPaidExistInDBWithPaymentDate_ReturnStatusPaid() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectStatus = 'Paid';

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);
        String invoiceId = invoice.Id;
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('invoiceId', invoiceId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateStatus_InvoiceIdPaidExistInDBWithPaymentDate_ReturnStatusPaid:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void AvailableEntity_InvoiceIdExistInDB_ReturnStatusAvailable() {
        String expectStatus = 'available';
        Boolean expectMessage = true;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = invoice.Id;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'availableEntity');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        String resultMessage = (String)response.Parameters.get('message');
        System.debug('@@@ AvailableEntity_InvoiceIdExistInDB_ReturnStatusAvailable:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_InvoiceIdNotExistInDB_ReturnStatusUnavailable() {
        String expectStatus = 'unavailable';
        Boolean expectMessage = true;

        String invoiceId = TestDataFactory.getNotExistId();
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'availableEntity');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        String resultMessage = (String)response.Parameters.get('message');
        System.debug('@@@ AvailableEntity_InvoiceIdNotExistInDB_ReturnStatusUnavailable:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_InvoiceIdNull_ReturnStatusUnavailable() {
        String expectStatus = 'unavailable';
        Boolean expectMessage = true;

        String invoiceId = null;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'availableEntity');
        request.Parameters.put('invoiceId', invoiceId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        String resultMessage = (String)response.Parameters.get('message');
        System.debug('@@@ AvailableEntity_InvoiceIdNotExistInDB_ReturnStatusUnavailable:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void RefreshInvoices_TimesheetIdExistInDB_ReturnUpdatedInvoice() {
        Invoice__c notExistItem = null;
        Boolean expectAmount = true;
        Boolean expectExpenses = true;
        Boolean expectMinutes = true;
        integer zeroNumber = 0;

        List<String> usersIds = new List<String>(TestDataFactory.getUsersIds());

        String employeeFirst = usersIds.get(0);
        String employeeSecond = usersIds.get(1);

        Map<String, Object> tsF = TestDataFactory.getNewTimesheet(employeeFirst);
        Map<String, Object> tsS = TestDataFactory.getNewTimesheet(employeeSecond);

        Map<String, Timesheet__c> contractResourceToTimesheet = new Map<String, Timesheet__c>();

        Timesheet__c timesheetFirst = new Timesheet__c();
        timesheetFirst.OwnerId = (String)tsF.get('employeeId');
        timesheetFirst.StartDate__c = (Date)tsF.get('startDate');
        timesheetFirst.EndDate__c = (Date)tsF.get('endDate');
        timesheetFirst.Status__c = TestDataFactory.TIMESHEET_STATUS_APPROVED;
        timesheetFirst.CreatedDate__c = (Date)tsF.get('startDate');
        timesheetFirst.LastModifiedDate__c = (Date)tsF.get('endDate');
        contractResourceToTimesheet.put(String.valueOf((Date)tsF.get('startDate')) + '_' + String.ValueOf((Date)tsF.get('endDate')) + '_' + String.valueOf((String)tsF.get('contractResourceId')), timesheetFirst);

        Timesheet__c timesheetSecond = new Timesheet__c();
        timesheetSecond.OwnerId = (String)tsS.get('employeeId');
        timesheetSecond.StartDate__c = (Date)tsS.get('startDate');
        timesheetSecond.EndDate__c = (Date)tsS.get('endDate');
        timesheetSecond.Status__c = TestDataFactory.TIMESHEET_STATUS_NEW;
        timesheetSecond.CreatedDate__c = (Date)tsS.get('startDate');
        timesheetSecond.LastModifiedDate__c = (Date)tsS.get('endDate');
        contractResourceToTimesheet.put(String.valueOf((Date)tsS.get('startDate')) + '_' + String.ValueOf((Date)tsS.get('endDate')) + '_' + String.valueOf((String)tsS.get('contractResourceId')), timesheetSecond);

        List<Timesheet__c> timesheets = new List<Timesheet__c>{timesheetFirst, timesheetSecond};
        
        TestDataFactory.insertTimesheetEntries(new Set<String>{employeeFirst, employeeSecond});
        insert timesheets;

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDb(new Set<String>{
            (String)tsF.get('contractResourceId'), 
            (String)tsS.get('contractResourceId')
        });

        for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
            if(timesheetEntry.TimesheetId__c == null) {        
                for(Timesheet__c timesheet : timesheets) {
                    if(timesheet.StartDate__c <= timesheetEntry.Date__c && timesheetEntry.Date__c <= timesheet.EndDate__c) {
                        String keyMap = String.valueOf(timesheet.StartDate__c) + '_' + String.valueOf(timesheet.EndDate__c) + '_' + timesheetEntry.Contract_Resource__c;
                        Timesheet__c ts = contractResourceToTimesheet.get(keyMap);
                        if(ts != null) {
                            timesheetEntry.TimesheetId__c = ts.Id;

                            if(ts.Status__c == TestDataFactory.TIMESHEET_STATUS_APPROVED) {
                                timesheetEntry.Is_Approved__c = true;
                                timesheetEntry.InternalApproval__c = timesheet.EndDate__c;
                                timesheetEntry.InternalApprovalBy__c = timesheet.OwnerId;
                            }
                        }
                    }
                }
            }
        }

        update timesheetEntries;

        DIInvoicesTestDataFactory.insertInvoices(new List<Timesheet__c>{timesheetFirst}, true);

        timesheetSecond.Status__c = TestDataFactory.TIMESHEET_STATUS_APPROVED;
        
        update timesheetSecond;

        String timesheetId = timesheetSecond.Id;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoices');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        Invoice__c resultItem = (Invoice__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ RefreshInvoices_TimesheetIdExistInDB_ReturnUpdatedInvoice:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);
        System.assertEquals(expectAmount, resultItem.Amount__c > zeroNumber);
        System.assertEquals(zeroNumber, resultItem.Expenses__c);
        System.assertEquals(expectMinutes, resultItem.Minutes__c > zeroNumber);

        Test.stopTest();
    }

    @isTest static void RefreshInvoices_TimesheetIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoices');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ RefreshInvoices_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ RefreshInvoices_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void RefreshInvoices_TimesheetIdNull_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoices');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ RefreshInvoices_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ RefreshInvoices_TimesheetIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void RefreshInvoiceLineItems_TimesheetsIdsNewExistInDB_ReturnUpdatedTimesheets() {
        String expectStatusNew = TestDataFactory.TIMESHEET_STATUS_NEW;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();

        for(Invoice_Line_Item__c ili : item.Invoice_Line_Items__r) {
            invoiceLineItems.add(ili);
        }

        Timesheet__c timesheet = TestDataFactory.getTimesheetById(invoiceLineItems[0].Timesheet__c);

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        for(Timesheet_Entry__c te : timesheetEntries) {
            te.Is_Approved__c = false;
        }

        update timesheetEntries;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoiceLineItems');
        request.Parameters.put('listTimesheetIds', new Set<String>{timesheet.Id});

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Timesheet__c> resultItems = (List<Timesheet__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
        Timesheet__c ts = resultItems[0];
        System.debug('@@@ RefreshInvoiceLineItems_TimesheetsIdsNewExistInDB_ReturnUpdatedTimesheets:result: ' + resultItems);

        System.assertEquals(expectStatusNew, ts.Status__c);

        Test.stopTest();
    }

    @isTest static void RefreshInvoiceLineItems_TimesheetsIdsPaidExistInDB_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);
        List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();

        for(Invoice_Line_Item__c ili : item.Invoice_Line_Items__r) {
            invoiceLineItems.add(ili);
        }

        Timesheet__c timesheet = TestDataFactory.getTimesheetById(invoiceLineItems.get(0).Timesheet__c);

        List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
        for(Timesheet_Entry__c te : timesheetEntries) {
            te.Is_Approved__c = false;
        }

        update timesheetEntries;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoiceLineItems');
        request.Parameters.put('listTimesheetIds', new Set<String>{timesheet.Id});

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Invoices serviceInvoices = new service_Invoices();
            serviceInvoices.process(request, response);
            List<Timesheet__c> resultItems = (List<Timesheet__c>)response.Parameters.get('items');
            System.debug('@@@ RefreshInvoiceLineItems_TimesheetsIdsPaidExistInDB_ReturnNoAccessError:result: ' + resultItems);
        } catch (Exception ex) {
            System.debug('@@@ RefreshInvoiceLineItems_TimesheetsIdsPaidExistInDB_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void RefreshInvoiceLineItems_TimesheetsIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoiceLineItems');
        request.Parameters.put('listTimesheetIds', new Set<String>{TestDataFactory.getNotExistId()});

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Timesheet__c> resultItems = (List<Timesheet__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ RefreshInvoiceLineItems_TimesheetsIdsNotExistInDB_ReturnEmptyList:result: ' + resultItems);

        System.assertEquals(expectSizeEmptyList, resultItems.size());

        Test.stopTest();
    }

    @isTest static void RefreshInvoiceLineItems_WithoutTimesheetsIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshInvoiceLineItems');
        request.Parameters.put('listTimesheetIds', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Timesheet__c> resultItems = (List<Timesheet__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ RefreshInvoiceLineItems_WithoutTimesheetsIds_ReturnEmptyList:result: ' + resultItems);

        System.assertEquals(expectSizeEmptyList, resultItems.size());

        Test.stopTest();
    }

    @isTest static void GetListByParams_DateRangeWithInvoicesExcludePending_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);
        Date pendingInvoicesStartDatetime = null;
        List<String> statuses = new List<String>{
            DIInvoicesTestDataFactory.INVOICE_STATUS_NEW,
            DIInvoicesTestDataFactory.INVOICE_STATUS_PAID
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);
        request.Parameters.put('pendingInvoicesStartDatetime', pendingInvoicesStartDatetime);
        request.Parameters.put('statuses', statuses);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Invoice__c> resultListItems = (List<Invoice__c>)response.Parameters.get('list');
        System.debug('@@@ GetListByParams_DateRangeWithInvoices_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListByParams_DateRangeWithInvoicesOnlyPending_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);
        Date pendingInvoicesStartDatetime = Date.valueOf(TestDataFactory.DATE_START);
        List<String> statuses = new List<String>{
            DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);
        request.Parameters.put('pendingInvoicesStartDatetime', pendingInvoicesStartDatetime);
        request.Parameters.put('statuses', statuses);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Invoice__c> resultListItems = (List<Invoice__c>)response.Parameters.get('list');
        System.debug('@@@ GetListByParams_DateRangeWithInvoicesOnlyPending_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListByParams_DateRangeWithInvoicesAll_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Date startDate = Date.valueOf(TestDataFactory.DATE_START);
        Date endDate = Date.valueOf(TestDataFactory.DATE_END);
        Date pendingInvoicesStartDatetime = Date.valueOf(TestDataFactory.DATE_START);
        List<String> statuses = new List<String>{
            DIInvoicesTestDataFactory.INVOICE_STATUS_NEW,
            DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING,
            DIInvoicesTestDataFactory.INVOICE_STATUS_PAID
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);
        request.Parameters.put('pendingInvoicesStartDatetime', pendingInvoicesStartDatetime);
        request.Parameters.put('statuses', statuses);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Invoice__c> resultListItems = (List<Invoice__c>)response.Parameters.get('list');
        System.debug('@@@ GetListByParams_DateRangeWithInvoicesAll_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListByParams_DateRangeWithoutInvoices_ReturnEmptyList() {
        Integer sizeEmptyList = 0;

        Date startDate = Date.valueOf(DIInvoicesTestDataFactory.DATE_START_WITHOUT_INVOICES);
        Date endDate = Date.valueOf(DIInvoicesTestDataFactory.DATE_END_WITHOUT_INVOICES);
        Date pendingInvoicesStartDatetime = Date.valueOf(DIInvoicesTestDataFactory.DATE_START_WITHOUT_INVOICES);
        List<String> statuses = new List<String>{
            DIInvoicesTestDataFactory.INVOICE_STATUS_NEW, 
            DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING,
            DIInvoicesTestDataFactory.INVOICE_STATUS_PAID
        };

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);
        request.Parameters.put('pendingInvoicesStartDatetime', pendingInvoicesStartDatetime);
        request.Parameters.put('statuses', statuses);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Invoice__c> resultListItems = (List<Invoice__c>)response.Parameters.get('list');
        System.debug('@@@ GetListByParams_DateRangeWithInvoices_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(sizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetListByParams_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Date startDate = null;
        Date endDate = null;
        Date pendingInvoicesStartDatetime = null;
        List<String> statuses = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListByParams');
        request.Parameters.put('startDate', startDate);
        request.Parameters.put('endDate', endDate);
        request.Parameters.put('pendingInvoicesStartDatetime', pendingInvoicesStartDatetime);
        request.Parameters.put('statuses', statuses);

        service_Response response = new service_Response();

        Test.startTest();

        service_Invoices serviceInvoices = new service_Invoices();
        serviceInvoices.process(request, response);
        List<Invoice__c> resultListItems = (List<Invoice__c>)response.Parameters.get('list');
        System.debug('@@@ GetListByParams_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }
}