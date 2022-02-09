@isTest
public with sharing class DIInvoicesExpensesControllerTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void GetList_InvoiceIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;

        Integer sizeEmptyList = 0;

        String employeeId = null;
        List<String> contractsIds = null;
        Date startDate = null;
        Date endDate = null;        
        String timesheetId = null;
        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice();
        String invoiceId = invoice.Id;
        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_InvoiceIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListExpenses > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_InvoiceIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String employeeId = null;
        List<String> contractsIds = null;
        Date startDate = null;
        Date endDate = null;        
        String timesheetId = null;
        String invoiceId = TestDataFactory.getNotExistId();
        String paymentId = null;
        
        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_InvoiceIdNotExistInDB_ReturnNotFoundError:result: ' + result);
        
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
}