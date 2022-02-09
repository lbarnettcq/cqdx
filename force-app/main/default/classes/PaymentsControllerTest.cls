@isTest
public with sharing class PaymentsControllerTest {
    @testSetup static void setup() {
        DIPaymentsTestDataFactory.init();
    }

    @isTest static void GetTypes_WithoutParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Integer sizeList = 4;
        Boolean expectSubcontractor = true;
        Boolean expectCommisions = true;
        Boolean expectReferral = true;
        Boolean expectExpensesReimbursement = true;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getTypes();
        System.debug('@@@ GetTypes_WithoutParams_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        List<Map<String, Object>> resultList = (List<Map<String, Object>>)resultData.get('list');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(sizeList, resultList.size());
        System.assertEquals(expectSubcontractor, resultList.contains(new Map<String, String>{
            'id' => DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR,
            'label' => DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR
        }));
        System.assertEquals(expectCommisions, resultList.contains(new Map<String, String>{
            'id' => DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS,
            'label' => DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS
        }));
        System.assertEquals(expectReferral, resultList.contains(new Map<String, String>{
            'id' => DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL,
            'label' => DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL
        }));
        System.assertEquals(expectExpensesReimbursement, resultList.contains(new Map<String, String>{
            'id' => DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT,
            'label' => DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT
        }));

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeSUBCONTRACTOR_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String paymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeSUBCONTRACTOR_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeREFERRAL_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String paymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeREFERRAL_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeEXPENSESREIMBURSEMENT_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String paymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeEXPENSESREIMBURSEMENT_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeCOMMISIONS_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeList = true;
        Integer sizeEmptyList = 0;

        String paymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeCOMMISIONS_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeNotExistInDB_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeEmptyList = 0;

        String paymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_NOT_EXIST;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeNotExistInDB_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeEmptyList, resultSizeList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentType = null;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getReceivers(paymentType);
        System.debug('@@@ GetReceivers_PaymentTypeNull_ReturnValidationErrors:result: ' + result);

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
    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getList(limits, offset);
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

        Map<String, Object> result = PaymentsController.getList(limits, offset);
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
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        Integer maxSizeNotEmptyList = DIPaymentsTestDataFactory.PAYMENTS_COUNT;

        Integer limits = maxSizeNotEmptyList;
        Integer offset = 0;
 
        Test.startTest();

        Map<String, Object> result = PaymentsController.getList(limits, offset);
        System.debug('@@@ GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, sizeEmptyList < resultSizeList && resultSizeList <= maxSizeNotEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;

        Integer sizeEmptyList = 0;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getTotalCount();
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultCountItems = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultCountItems > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListItems_PaymentIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String paymentId = DIPaymentsTestDataFactory.getPayment().Id;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getListItems(paymentId);
        System.debug('@@@ GetListItems_PaymentIdExistInDB_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeList = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeList > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListItems_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = PaymentsController.getListItems(paymentId);
        System.debug('@@@ GetListItems_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void GetListItems_PaymentIdIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getListItems(paymentId);
        System.debug('@@@ GetListItems_PaymentIdIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetTotalItemsCount_PaymentIdExistInDB_ReturnCountItems() {
        String expectResponseStatus = 'success';
        Boolean expectTotalCount = true;
        Integer sizeEmptyList = 0;

        String paymentId = DIPaymentsTestDataFactory.getPayment().Id;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getTotalItemsCount(paymentId);
        System.debug('@@@ GetTotalItemsCount_PaymentIdExistInDB_ReturnCountItems:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultCountItems = (Integer)resultData.get('count');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectTotalCount, resultCountItems > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = PaymentsController.getTotalItemsCount(paymentId);
        System.debug('@@@ GetTotalItemsCount_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void GetTotalItemsCount_PaymentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = PaymentsController.getTotalItemsCount(paymentId);
        System.debug('@@@ GetTotalItemsCount_PaymentIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void GetInformation_PaymentIdBySubcontractorExistInDB_ReturnItem() {
        String expectResponseStatus = 'success';
        Boolean expectExistItem = true;
        INteger zeroProperties = 0;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR);
        Payment__c payment = payments[0];

        Test.startTest();

        Map<String, Object> result = PaymentsController.getInformation(payment.Id);
        System.debug('@@@ GetInformation_PaymentIdBySubcontractorExistInDB_ReturnItem:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectExistItem, resultItem.size() > zeroProperties);
        System.assertEquals(payment.Id, (String)resultItem.get('paymentId'));
        System.assertEquals(payment.Total_Minutes__c, (Decimal)resultItem.get('totalMinutes'));
        System.assertEquals(payment.Total_Amount__c, (Decimal)resultItem.get('totalAmount'));

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdByReferralExistInDB_ReturnItem() {
        String expectResponseStatus = 'success';
        Boolean expectExistItem = true;
        INteger zeroProperties = 0;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL);
        Payment__c payment = payments[0];

        Test.startTest();

        Map<String, Object> result = PaymentsController.getInformation(payment.Id);
        System.debug('@@@ GetInformation_PaymentIdByReferralExistInDB_ReturnItem:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectExistItem, resultItem.size() > zeroProperties);
        System.assertEquals(payment.Id, (String)resultItem.get('paymentId'));
        System.assertEquals(payment.Total_Minutes__c, (Decimal)resultItem.get('totalMinutes'));
        System.assertEquals(payment.Total_Amount__c, (Decimal)resultItem.get('totalAmount'));

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdByCommissionsExistInDB_ReturnItem() {
        String expectResponseStatus = 'success';
        Boolean expectExistItem = true;
        INteger zeroProperties = 0;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS);
        Payment__c payment = payments[0];

        Test.startTest();

        Map<String, Object> result = PaymentsController.getInformation(payment.Id);
        System.debug('@@@ GetInformation_PaymentIdByCommissionsExistInDB_ReturnItem:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Map<String, Object> resultItem = (Map<String, Object>)resultData.get('item');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectExistItem, resultItem.size() > zeroProperties);
        System.assertEquals(payment.Id, (String)resultItem.get('paymentId'));
        System.assertEquals(payment.Total_Minutes__c, (Decimal)resultItem.get('totalMinutes'));
        System.assertEquals(payment.Total_Amount__c, (Decimal)resultItem.get('totalAmount'));

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = PaymentsController.getInformation(paymentId);
        System.debug('@@@ GetInformation_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void GetInformation_PaymentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;
 
        Test.startTest();

        Map<String, Object> result = PaymentsController.getInformation(paymentId);
        System.debug('@@@ GetInformation_PaymentIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void InsertEntry_ValidParamsPaymentTypeNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_NOT_EXIST;
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsPaymentTypeNotExistInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void InsertEntry_ValidParamsReceiverIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsReceiverIdNotExistInDB_ReturnNotFoundError:result: ' + result);

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

     @isTest static void InsertEntry_PaymentsExistInDateRange_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END);
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_PaymentsExistInDateRange_ReturnNoAccessError:result: ' + result);

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

    @isTest static void InsertEntry_ValidParamsWithSubcontractor_ReturnInsertedPayment() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedPaymentId = true;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsWithSubcontractor_ReturnInsertedPayment:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Payment__c resultItem = ((Payment__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedPaymentId, resultItem.Id != null);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithReferral_ReturnInsertedPayment() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedPaymentId = true;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsWithReferral_ReturnInsertedPayment:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Payment__c resultItem = ((Payment__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedPaymentId, resultItem.Id != null);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithCommisions_ReturnInsertedPayment() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedPaymentId = true;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsWithCommisions_ReturnInsertedPayment:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Payment__c resultItem = ((Payment__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedPaymentId, resultItem.Id != null);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithExpensesReimbursement_ReturnInsertedPayment() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedPaymentId = true;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ InsertEntry_ValidParamsWithExpensesReimbursement_ReturnInsertedPayment:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Payment__c resultItem = ((Payment__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedPaymentId, resultItem.Id != null);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 

        Test.stopTest();
    }

    @isTest static void InsertEntry_ParamsNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 4;

        String expectPaymentType = null;
        String expectReceiverId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Boolean expectPaidInvoices = null;
        Boolean expectPendingInvoices = null;
        Date expectPendingInvoicesStartDate = null;
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.insertEntry(expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
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

    @isTest static void UpdateEntry_ValidParamsWithExistPaymentIdInDB_ReturnUpdatedPayment() {
        String expectResponseStatus = 'success';
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = payment.Id;
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = payment.StartDate__c;
        Date expectEndDate = payment.EndDate__c;
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = (payment.StartDate__c).addDays(1);
       
        Test.startTest();

        Map<String, Object> result = PaymentsController.updateEntry(expectPaymentId, expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ UpdateEntry_ValidParamsWithExistPaymentIdInDB_ReturnUpdatedPayment:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Payment__c resultItem = (Payment__c)resultData.get('item');//TODO:convert from Payment__c to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);

        System.assertEquals(expectPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, resultItem.Payment_type__c);
        System.assertEquals(expectStatus, resultItem.Status__c);
        System.assertEquals(expectStartDate, resultItem.StartDate__c);
        System.assertEquals(expectEndDate, resultItem.EndDate__c);        
        System.assertEquals(expectPaidInvoices, resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, resultItem.Pending_invoices_startDate__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithNotExistPaymentIdInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = TestDataFactory.getNotExistId();
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = payment.StartDate__c;
        Date expectEndDate = payment.EndDate__c;
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = (payment.StartDate__c).addDays(1);
        
        Test.startTest();
            
        Map<String, Object> result = PaymentsController.updateEntry(expectPaymentId, expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ UpdateEntry_ValidParamsWithNotExistPaymentIdInDB_ReturnNotFoundError:result: ' + result);

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

    @isTest static void UpdateEntry_PaymentsExistInDateRange_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;
        String receiverId = null;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsFromDB();
        for(Payment__c p : payments) {
            if(p.Payment_type__c == payment.Payment_type__c && p.id != payment.Id) {
                receiverId = p.ReceiverId__c;
            }
        }

        String expectPaymentId = payment.Id;
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = receiverId;
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END);
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = payment.Pending_invoices_startDate__c;

        Test.startTest();
            
        Map<String, Object> result = PaymentsController.updateEntry(expectPaymentId, expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
        System.debug('@@@ UpdateEntry_PaymentsExistInDateRange_ReturnNoAccessError:result: ' + result);

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
        Integer expectSizeListErrors = 5;

        String expectPaymentId = null;
        String expectPaymentType = null;
        String expectReceiverId = null;
        Date expectStartDate = null;
        Date expectEndDate = null;
        Boolean expectPaidInvoices = null;
        Boolean expectPendingInvoices = null;
        Date expectPendingInvoicesStartDate = null;
       
        Test.startTest();

        Map<String, Object> result = PaymentsController.updateEntry(expectPaymentId, expectPaymentType, expectReceiverId, expectStartDate, expectEndDate,
            expectPaidInvoices, expectPendingInvoices, expectPendingInvoicesStartDate);
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

    @isTest static void DeleteEntry_PaymentIdPaidExistInDB_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;

        Test.startTest();

        Map<String, Object> result = PaymentsController.deleteEntry(paymentId);
        System.debug('@@@ DeleteEntry_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + result);

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

    @isTest static void DeleteEntry_PaymentIdNewExistInDB_ReturnStatusSuccess() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        Test.startTest();

        Map<String, Object> result = PaymentsController.deleteEntry(paymentId);
        System.debug('@@@ DeleteEntry_PaymentIdNewExistInDB_ReturnStatusSuccess:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_PaymentIdNotExistInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = PaymentsController.deleteEntry(paymentId);
        System.debug('@@@ DeleteEntry_PaymentIdNotExistInDB_ReturnNoFoundError:result: ' + result);

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

    @isTest static void DeleteEntry_PaymentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;
        
        Test.startTest();

        Map<String, Object> result = PaymentsController.deleteEntry(paymentId);
        System.debug('@@@ DeleteEntry_PaymentIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void UpdateStatus_PaymentIdNotExistInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = TestDataFactory.getNotExistId();
        Date paymentDate = Date.valueOf(TestDataFactory.DATE_END);

        Test.startTest();

        Map<String, Object> result = PaymentsController.updateStatus(paymentId, paymentDate);
        System.debug('@@@ UpdateStatus_PaymentIdNotExistInDB_ReturnNoFoundError:result: ' + result);

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

    @isTest static void UpdateStatus_PaymentIdNewExistInDB_ReturnStatusPaid() {
        //'New' => 'Paid',
        String expectResponseStatus = 'success';
        String expectUpdatedItemStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;
        Date paymentDate = payment.EndDate__c;

        Test.startTest();

        Map<String, Object> result = PaymentsController.updateStatus(paymentId, paymentDate);
        System.debug('@@@ UpdateStatus_PaymentIdNewExistInDB_ReturnStatusPaid:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');//TODO: Convert status to item

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectUpdatedItemStatus, resultStatus);//TODO:check updated status: new->pending, pending->approved

        Test.stopTest();
    }

    @isTest static void UpdateStatus_PaymentIdPaidExistInDB_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;
        Date paymentDate = payment.EndDate__c;

        Test.startTest();

        Map<String, Object> result = PaymentsController.updateStatus(paymentId, paymentDate);
        System.debug('@@@ UpdateStatus_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + result);

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

    @isTest static void UpdateStatus_PaymentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;
        Date paymentDate = null;

        Test.startTest();

        Map<String, Object> result = PaymentsController.updateStatus(paymentId, paymentDate);
        System.debug('@@@ UpdateStatus_PaymentIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void AvailableEntity_PaymentIdExistInDB_ReturnStatusAvailable() {
        String expectResponseStatus = 'success';
        String expectStatus = 'available';
        Boolean expectMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;
       
        Test.startTest();

        Map<String, Object> result = PaymentsController.availableEntity(paymentId);
        System.debug('@@@ AvailableEntity_PaymentIdExistInDB_ReturnStatusAvailable:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');
        String resultMessage = (String)resultData.get('message');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_PaymentIdNotExistInDB_ReturnStatusUnavailable() {
        String expectResponseStatus = 'success';
        String expectStatus = 'unavailable';
        Boolean expectMessage = true;

        String paymentId = TestDataFactory.getNotExistId();
       
        Test.startTest();

        Map<String, Object> result = PaymentsController.availableEntity(paymentId);
        System.debug('@@@ AvailableEntity_PaymentIdNotExistInDB_ReturnStatusUnavailable:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        String resultStatus = (String)resultData.get('status');
        String resultMessage = (String)resultData.get('message');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_PaymentIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String paymentId = null;
       
        Test.startTest();

        Map<String, Object> result = PaymentsController.availableEntity(paymentId);
        System.debug('@@@ AvailableEntity_PaymentIdNull_ReturnValidationErrors:result ' + result);

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