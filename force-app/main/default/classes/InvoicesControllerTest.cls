@isTest
public with sharing class InvoicesControllerTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void GetAccounts_ParamsExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ParamsNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String status = TestDataFactory.STATUS_NOT_EXIST;
        String employeeId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String status = null;
        String employeeId = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getAccounts(status, employeeId);
        System.debug('@@@ GetAccounts_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }
    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getList(limits, offset);
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZero_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        Integer limits = 0;
        Integer offset = 0;
 
        Test.startTest();

        Map<String, Object> result = InvoicesController.getList(limits, offset);
        System.debug('@@@ GetList_LimitOffsetZero_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeList = DIInvoicesTestDataFactory.getInvoicesFromDB().size();

        Integer limits = expectSizeList;
        Integer offset = 0;
 
        Test.startTest();

        Map<String, Object> result = InvoicesController.getList(limits, offset);
        System.debug('@@@ GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsGreatMaxOffset_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeList = DIInvoicesTestDataFactory.getInvoicesFromDB().size();

        Integer limits = expectSizeList*5;
        Integer offset = 1;
        expectSizeList -= offset;
 
        Test.startTest();

        Map<String, Object> result = InvoicesController.getList(limits, offset);
        System.debug('@@@ GetList_LimitCountItemsGreatMaxOffset_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnTotalCount() {
        String expectResponseStatus = 'success';
        Boolean expectNotZero = true;
        Integer zeroItems = 0;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getTotalCount();
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnTotalCount:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultCountItems = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotZero, resultCountItems > zeroItems);

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String invoiceId = DIInvoicesTestDataFactory.getInvoice().Id;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getListItems(invoiceId);
        System.debug('@@@ GetListItems_InvoiceIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getListItems(invoiceId);
        System.debug('@@@ GetListItems_InvoiceIdNotExistInDB_ReturnNotFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void GetListItems_InvoiceIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getListItems(invoiceId);
        System.debug('@@@ GetListItems_InvoiceIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetTotalItemsCount_InvoiceIdExistInDB_ReturnCountItems() {
        String expectResponseStatus = 'success';
        Boolean expectTotalCount = true;
        Integer sizeEmptyList = 0;

        String invoiceId = DIInvoicesTestDataFactory.getInvoice().Id;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getTotalItemsCount(invoiceId);
        System.debug('@@@ GetTotalItemsCount_ValidParams_ReturnCountItems:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultCountItems = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectTotalCount, resultCountItems > sizeEmptyList);

        Test.stopTest();
    }


    @isTest static void GetTotalItemsCount_InvoiceIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getTotalItemsCount(invoiceId);
        System.debug('@@@ GetTotalItemsCount_InvoiceIdNotExistInDB_ReturnNotFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_InvoiceIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.getTotalItemsCount(invoiceId);
        System.debug('@@@ GetTotalItemsCount_InvoiceIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetInformation_InvoiceIdExistInDB_ReturnItem() {
        String expectResponseStatus = 'success';
        Boolean expectExistItem = true;
        INteger zeroProperties = 0;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getInformation(invoice.Id);
        System.debug('@@@ GetInformation_InvoiceIdExistInDB_ReturnItem:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectExistItem, resultItem.size() > zeroProperties);
        System.assertEquals(invoice.Id, (String)resultItem.get('invoiceId'));
        System.assertEquals(invoice.Minutes__c, (Decimal)resultItem.get('totalMinutes'));
        System.assertEquals(invoice.Expenses__c, (Decimal)resultItem.get('totalExpenses'));
        System.assertEquals(invoice.Amount__c, (Decimal)resultItem.get('totalAmount'));

        Test.stopTest();
    }

    @isTest static void GetInformation_InvoiceIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.getInformation(invoiceId);
        System.debug('@@@ GetInformation_InvoiceIdNotExistInDB_ReturnNotFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void GetInformation_InvoiceIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = null;
 
        Test.startTest();

        Map<String, Object> result = InvoicesController.getInformation(invoiceId);
        System.debug('@@@ GetInformation_InvoiceIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void InsertEntry_NotExistAccountInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Date expectIssueDate = (Date)item.get('issueDate');
        Date expectDueDate = (Date)item.get('dueDate');

        Test.startTest();
            
        Map<String, Object> result = InvoicesController.insertEntry(expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ InsertEntry_NotExistAccountInDB_ReturnNotFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

     @isTest static void InsertEntry_DateRangeOut_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> item = DIInvoicesTestDataFactory.getNewInvoice();
     
        String expectAccountId = (String)item.get('accountId');
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START_WITHOUT_DATA);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END_WITHOUT_DATA);
        Date expectIssueDate = (Date)item.get('issueDate');
        Date expectDueDate = (Date)item.get('dueDate');

        Test.startTest();
            
        Map<String, Object> result = InvoicesController.insertEntry(expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ InsertEntry_DateRangeOut_ReturnNoAccessError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParams_ReturnInsertedInvoice() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedInvoiceId = true;
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
        
        Test.startTest();
            
        Map<String, Object> result = InvoicesController.insertEntry(expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ InsertEntry_ValidParams_ReturnInsertedInvoice:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Invoice__c resultItem = ((Invoice__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedInvoiceId, resultItem.Id != null);
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

    @isTest static void InsertEntry_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 5;

        String expectAccountId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Date expectIssueDate = null;
        Date expectDueDate = null;
        
        Test.startTest();
            
        Map<String, Object> result = InvoicesController.insertEntry(expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
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

    @isTest static void UpdateEntry_ValidParamsWithExistInvoiceId_ReturnUpdatedInvoice() {
        String expectResponseStatus = 'success';
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
       
        Test.startTest();

        Map<String, Object> result = InvoicesController.updateEntry(expectInvoiceId, expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ UpdateEntry_ValidParamsWithExistInvoiceId_ReturnUpdatedInvoice:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Invoice__c resultItem = (Invoice__c)resultData.get('item');//TODO:convert from Timesheet__c to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);

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

    @isTest static void UpdateEntry_ValidParamsWithNotExistInvoiceIdInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);

        String expectInvoiceId  = TestDataFactory.getNotExistId();
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = item.StartDate__c;
        Date expectEndDate = item.EndDate__c;
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;
        
        Test.startTest();
            
        Map<String, Object> result = InvoicesController.updateEntry(expectInvoiceId, expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ UpdateEntry_ValidParamsWithNotExistInvoiceIdInDB_ReturnNotFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_DateRangeOut_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);

        String expectInvoiceId  = item.Id;
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = ((Date)(item.StartDate__c)).addDays(-1);
        Date expectEndDate = ((Date)(item.EndDate__c)).addDays(1);
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;

        Test.startTest();
            
        Map<String, Object> result = InvoicesController.updateEntry(expectInvoiceId, expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ UpdateEntry_DateRangeOut_ReturnNoAccessError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsWithPaidInvoice_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);

        String expectInvoiceId  = item.Id;
        String expectAccountId = TestDataFactory.getAccountId();
        Date expectStartDate = item.StartDate__c;
        Date expectEndDate = item.EndDate__c;
        Date expectIssueDate = item.IssueDate__c;
        Date expectDueDate = item.DueDate__c;

        Test.startTest();
            
        Map<String, Object> result = InvoicesController.updateEntry(expectInvoiceId, expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ UpdateEntry_ParamsWithPaidInvoice_ReturnNoAccessError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ParamsNull_ReturnValidationError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 6;

        String expectInvoiceId  = null;
        String expectAccountId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Date expectIssueDate = null;
        Date expectDueDate = null;
       
        Test.startTest();

        Map<String, Object> result = InvoicesController.updateEntry(expectInvoiceId, expectAccountId, expectStartDate, expectEndDate, expectIssueDate, expectDueDate);
        System.debug('@@@ UpdateEntry_ParamsNull_ReturnValidationError:result: ' + result);

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

    @isTest static void DeleteEntry_InvoiceIdNotNewExistInDB_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);
        String invoiceId = item.Id;

        Test.startTest();

        Map<String, Object> result = InvoicesController.deleteEntry(invoiceId);
        System.debug('@@@ DeleteEntry_InvoiceIdNotNewExistInDB_ReturnNoAccessError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdNewExistInDB_ReturnStatusSuccess() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = item.Id;

        Test.startTest();

        Map<String, Object> result = InvoicesController.deleteEntry(invoiceId);
        System.debug('@@@ DeleteEntry_InvoiceIdNewExistInDB_ReturnStatusSuccess:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdNotExistInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = InvoicesController.deleteEntry(invoiceId);
        System.debug('@@@ DeleteEntry_InvoiceIdNotExistInDB_ReturnNoFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_InvoiceIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;


        String invoiceId = null;
        
        Test.startTest();

        Map<String, Object> result = InvoicesController.deleteEntry(invoiceId);
        System.debug('@@@ DeleteEntry_InvoiceIdNull_ReturnValidationErrors:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdNotExistInDBWithPaymentDate_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = TestDataFactory.getNotExistId();//TODO:get invoice with status: new, pending, approved; add status to config
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        Map<String, Object> result = InvoicesController.updateStatus(invoiceId, paymentDate);
        System.debug('@@@ UpdateStatus_InvoiceIdNotExistInDBWithPaymentDate_ReturnNoFoundError:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultErrors = (Map<String, Object>)result.get('errors');        
        Integer resultCodeError = (Integer)resultErrors.get('code');
        String resultMessageError = (String)resultErrors.get('message');
        Integer resultSizeListErrors = ((List<Object>)resultErrors.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCodeError, resultCodeError);
        System.assertEquals(expectMessage, resultMessageError.length() > 0);
        System.assertEquals(expectSizeListErrors, resultSizeListErrors);


        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdNewExistInDBWithPaymentDate_ReturnStatusPending() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = 'Pending';

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = item.Id;
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        Map<String, Object> result = InvoicesController.updateStatus(invoiceId, paymentDate);
        System.debug('@@@ UpdateStatus_InvoiceIdNewExistInDBWithPaymentDate_ReturnStatusPending:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');//TODO:Convert status to item

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultStatus);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDate_ReturnStatusPaid() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = DIInvoicesTestDataFactory.INVOICE_STATUS_PAID;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING);
        String invoiceId = item.Id;
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        Map<String, Object> result = InvoicesController.updateStatus(invoiceId, paymentDate);
        System.debug('@@@ UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDate_ReturnStatusPaid:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');//TODO:Convert status to item

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultStatus);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDateNull_ReturnStatusPaid() {
        //'New' => 'Pending',
        //'Pending' => 'Paid'
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = DIInvoicesTestDataFactory.INVOICE_STATUS_PAID;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING);
        String invoiceId = item.Id;
        Date paymentDate = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.updateStatus(invoiceId, paymentDate);
        System.debug('@@@ UpdateStatus_InvoiceIdPendingExistInDBWithPaymentDateNull_ReturnStatusPaid:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');//TODO:Convert status to item

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultStatus);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = null;
        Date paymentDate = null;

        Test.startTest();

        Map<String, Object> result = InvoicesController.updateStatus(invoiceId, paymentDate);
        System.debug('@@@ UpdateStatus_ParamsNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void AvailableEntity_InvoiceIdExistInDB_ReturnStatusAvailable() {
        String expectResponseStatus = 'success';
        String expectStatus = 'available';
        Boolean expectMessage = true;

        Invoice__c item = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW);
        String invoiceId = item.Id;
       
        Test.startTest();

        Map<String, Object> result = InvoicesController.availableEntity(invoiceId);
        System.debug('@@@ AvailableEntity_InvoiceIdExistInDB_ReturnStatusAvailable:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');
        String resultMessage = (String)resultData.get('message');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, !String.isBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_InvoiceIdNotExistInDB_ReturnStatusUnavailable() {
        String expectResponseStatus = 'success';
        String expectStatus = 'unavailable';
        Boolean expectMessage = true;

        String invoiceId = TestDataFactory.getNotExistId();
       
        Test.startTest();

        Map<String, Object> result = InvoicesController.availableEntity(invoiceId);
        System.debug('@@@ AvailableEntity_InvoiceIdNotExistInDB_ReturnStatusUnavailable:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');
        String resultMessage = (String)resultData.get('message');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, !String.isBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_InvoiceIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String invoiceId = null;
       
        Test.startTest();

        Map<String, Object> result = InvoicesController.availableEntity(invoiceId);
        System.debug('@@@ AvailableEntity_InvoiceIdNull_ReturnValidationErrors:result ' + result);

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