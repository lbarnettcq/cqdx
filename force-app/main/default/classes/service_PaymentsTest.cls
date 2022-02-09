@isTest
public with sharing class service_PaymentsTest {
    @testSetup static void setup() {
        DIPaymentsTestDataFactory.init();
    }

    @isTest static void GetTypes_WithoutParams_ReturnNotEmptyList() {
        Integer sizeList = 4;
        Boolean expectSubcontractor = true;
        Boolean expectCommisions = true;
        Boolean expectReferral = true;
        Boolean expectExpensesReimbursement = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTypes');

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultList = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetTypes_WithoutParams_ReturnNotEmptyList:result: ' + resultList);

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

    @isTest static void GetList_ParamsNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_LimitOffsetZero_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Integer limits = 0;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitOffsetZero_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
        Integer maxSizeList = 10;

        Integer limits = maxSizeList;
        Integer offset = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_LimitCountItemsOffsetZero_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, sizeEmptyList < resultListItems.size() && resultListItems.size() <= maxSizeList);

        Test.stopTest();
    }

    @isTest static void GetTotalCount_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer zeroTotalCount = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalCount');

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalCount_WithoutParams_ReturnNotEmptyList:result: ' + resultTotalCount);

        System.assertEquals(expectNotEmptyList, resultTotalCount > zeroTotalCount);

        Test.stopTest();
    }

    @isTest static void GetListItems_PaymentIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Integer limits = null;
        Integer offset = null;
        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String,Object>>)response.Parameters.get('list');
        System.debug('@@@ GetListItems_PaymentIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetListItems_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String paymentId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
            System.debug('@@@ GetListItems_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListItems_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetListItems_PaymentIdNull_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String paymentId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
            System.debug('@@@ GetListItems_PaymentIdNull_ReturnNotFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetListItems_PaymentIdNull_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_PaymentIdExistInDB_ReturnCountItems() {
        Boolean expectNotEmptyList = true;
        Integer zeroTotalCount = 0;

        Integer limits = null;
        Integer offset = null;
        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Integer resultTotalCount = (Integer)response.Parameters.get('count');
        System.debug('@@@ GetTotalItemsCount_PaymentIdExistInDB_ReturnCountItems:result: ' + resultTotalCount);

        System.assertEquals(expectNotEmptyList, resultTotalCount > zeroTotalCount);

        Test.stopTest();
    }


    @isTest static void GetTotalItemsCount_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String paymentId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Integer resultTotalCount = (Integer)response.Parameters.get('count');
            System.debug('@@@ GetTotalItemsCount_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + resultTotalCount);
        } catch (Exception ex) {
            System.debug('@@@ GetTotalItemsCount_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetTotalItemsCount_PaymentIdNull_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Integer limits = null;
        Integer offset = null;
        String paymentId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTotalItemsCount');
        request.Parameters.put('limits', limits);
        request.Parameters.put('offset', offset);
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Integer resultTotalCount = (Integer)response.Parameters.get('count');
            System.debug('@@@ GetTotalItemsCount_PaymentIdNull_ReturnNotFoundError:result: ' + resultTotalCount);
        } catch (Exception ex) {
            System.debug('@@@ GetTotalItemsCount_PaymentIdNull_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeSubcontractor_ReturnNotEmptyList() {//TODO:extract to one test method
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getReceivers');
        request.Parameters.put('paymentType', DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetReceivers_PaymentTypeSubcontractor_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void GetReceivers_PaymentTypeReferral_ReturnNotEmptyList() {//TODO:extract to one test method
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getReceivers');
        request.Parameters.put('paymentType', DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetReceivers_PaymentTypeReferral_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeCommissions_ReturnNotEmptyList() {//TODO:extract to one test method
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getReceivers');
        request.Parameters.put('paymentType', DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetReceivers_PaymentTypeCommissions_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeExpensesReimbursement_ReturnNotEmptyList() {//TODO:extract to one test method
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getReceivers');
        request.Parameters.put('paymentType', DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetReceivers_PaymentTypeExpensesReimbursement_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetReceivers_PaymentTypeNotExist_ReturnEmptyList() {//TODO:extract to one test method
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getReceivers');
        request.Parameters.put('paymentType', DIPaymentsTestDataFactory.PAYMENT_TYPE_NOT_EXIST);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Map<String, String>> resultListItems = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetReceivers_PaymentTypeNotExist_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdBySubcontractorExistInDB_ReturnItem() {
        Boolean expectItem = true;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR);
        Payment__c payment = payments[0];

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', payment.Id);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_PaymentIdBySubcontractorExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectItem, resultItem.size() > 0);

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdByReferralExistInDB_ReturnItem() {
        Boolean expectItem = true;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL);
        Payment__c payment = payments[0];

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', payment.Id);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_PaymentIdByReferralExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectItem, resultItem.size() > 0);

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdByCommissionsExistInDB_ReturnItem() {
        Boolean expectItem = true;

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsByType(DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS);
        Payment__c payment = payments[0];

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', payment.Id);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
        System.debug('@@@ GetInformation_PaymentIdByCommissionsExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectItem, resultItem.size() > 0);

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdNotExistInDB_ReturnNotFoundError() {//TODO: return error not found
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String paymentId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
            System.debug('@@@ GetInformation_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ GetInformation_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetInformation_PaymentIdNull_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String paymentId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Map<String, Object> resultItem = (Map<String, Object>)response.Parameters.get('item');
            System.debug('@@@ GetInformation_PaymentIdNull_ReturnNotFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ GetInformation_PaymentIdNull_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsNotExistPaymentType_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = DIPaymentsTestDataFactory.PAYMENT_TYPE_NOT_EXIST;
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Payment__c resultItem = (Payment__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ValidParamsNotExistPaymentType_ReturnNotFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsNotExistPaymentType_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsNotExistReceiverId_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = TestDataFactory.getNotExistId();
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Payment__c resultItem = (Payment__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ValidParamsNotExistReceiverId_ReturnNotFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsNotExistReceiverId_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

     @isTest static void InsertEntry_ParamsDateRangeOut_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment();
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END);
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Payment__c resultItem = (Payment__c)response.Parameters.get('item');
            System.debug('@@@ InsertEntry_ParamsDateRangeOut_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ParamsDateRangeOut_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithSubcontractor_ReturnInsertedPayment() {
        String nullPaymentId = null;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_SUBCONTRACTOR);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParamsWithSubcontractor_ReturnInsertedPayment:result: ' + resultItem);

        System.assertNotEquals(nullPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 
        //invoice.Status__c = 'New';

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithReferral_ReturnInsertedPayment() {
        String nullPaymentId = null;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_REFERRAL);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParamsWithReferral_ReturnInsertedPayment:result: ' + resultItem);

        System.assertNotEquals(nullPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 
        //invoice.Status__c = 'New';

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithCommisions_ReturnInsertedPayment() {
        String nullPaymentId = null;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_COMMISIONS);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParamsWithCommisions_ReturnInsertedPayment:result: ' + resultItem);

        System.assertNotEquals(nullPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 
        //invoice.Status__c = 'New';

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithExpensesReimbursement_ReturnInsertedPayment() {
        String nullPaymentId = null;
        String expectStatus = DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW;

        Map<String, Object> item = DIPaymentsTestDataFactory.getNewPayment(DIPaymentsTestDataFactory.PAYMENT_TYPE_EXPENSES_REIMBURSEMENT);
     
        String expectPaymentType = (String)item.get('paymentType');
        String expectReceiverId = (String)item.get('receiverId');
        Date expectStartDate = (Date)item.get('startDate');
        Date expectEndDate = (Date)item.get('endDate');
        Boolean expectPaidInvoices = (Boolean)item.get('paidInvoices');
        Boolean expectPendingInvoices = (Boolean)item.get('pendingInvoices');
        Date expectPendingInvoicesStartDate = (Date)item.get('pendingInvoicesStartDate');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ InsertEntry_ValidParamsWithExpensesReimbursement_ReturnInsertedPayment:result: ' + resultItem);

        System.assertNotEquals(nullPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);//TODO: change to camel case 
        //invoice.Status__c = 'New';

        Test.stopTest();
    }
    
    @isTest static void UpdateEntry_ValidParamsWithExistPaymentId_ReturnUpdatedPayment() {
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
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('paymentId', expectPaymentId);
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ UpdateEntry_ValidParamsWithExistPaymentId_ReturnUpdatedPayment:result: ' + resultItem);

        System.assertEquals(expectPaymentId, resultItem.Id);
        System.assertEquals(expectPaymentType, (String)resultItem.Payment_type__c);
        System.assertEquals(expectStatus, (String)resultItem.Status__c);
        System.assertEquals(expectStartDate, (Date)resultItem.StartDate__c);
        System.assertEquals(expectEndDate, (Date)resultItem.EndDate__c);        
        System.assertEquals(expectPaidInvoices, (Boolean)resultItem.Is_Paid_Invoices__c);
        System.assertEquals(expectPendingInvoices, (Boolean)resultItem.Is_Pending_invoices__c);
        System.assertEquals(expectPendingInvoicesStartDate, (Date)resultItem.Pending_invoices_startDate__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntry_ValidParamsWithNotExistPaymentIdInDB_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = TestDataFactory.getNotExistId();
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = payment.StartDate__c;
        Date expectEndDate = payment.EndDate__c;
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = (payment.StartDate__c).addDays(1);
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('paymentId', expectPaymentId);
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_ValidParamsWithNotExistPaymentIdInDB_ReturnNotFoundError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_ValidParamsWithNotExistPaymentIdInDB_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntry_PaymentsExistInDateRange_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = payment.Id;
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = Date.valueOf(TestDataFactory.DATE_START);
        Date expectEndDate = Date.valueOf(TestDataFactory.DATE_END);
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = (payment.StartDate__c).addDays(1);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntry');
        request.Parameters.put('paymentId', expectPaymentId);
        request.Parameters.put('paymentType', expectPaymentType);
        request.Parameters.put('receiverId', expectReceiverId);
        request.Parameters.put('startDate', expectStartDate);
        request.Parameters.put('endDate', expectEndDate);
        request.Parameters.put('paidInvoices', expectPaidInvoices);
        request.Parameters.put('pendingInvoices', expectPendingInvoices);
        request.Parameters.put('pendingInvoicesStartDate', expectPendingInvoicesStartDate);

        service_Response response = new service_Response();

        Test.startTest();
            
        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            Payment__c resultItem = (Payment__c)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ UpdateEntry_PaymentsExistInDateRange_ReturnNoAccessError:result: ' + resultItem);
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntry_PaymentsExistInDateRange_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_PaymentIdNotExistInDB_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String paymentId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ DeleteEntry_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_PaymentIdNotExistInDB_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_PaymentIdPaidExistInDB_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            String resultStatus = (String)response.Parameters.get('item');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ DeleteEntry_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_PaymentIdNewExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ DeleteEntry_PaymentIdNewExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_PaymentIdNotExistInDB_ReturnNoFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String paymentId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ UpdateStatus_PaymentIdNotExistInDB_ReturnNoFoundError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ UpdateStatus_PaymentIdNotExistInDB_ReturnNoFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateStatus_PaymentIdNewExistInDB_ReturnStatusPaid() {
        //'New' => 'Paid'
        String expectStatus = 'Paid';

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;
        Date paymentDate = payment.EndDate__c;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('paymentId', paymentId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ UpdateStatus_PaymentIdNewExistInDB_ReturnStatusPaid:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void UpdateStatus_PaymentIdPaidExistInDB_ReturnNoAccessError() {
        //'New' => 'Paid'
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;
        Date paymentDate = payment.EndDate__c;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateStatus');
        request.Parameters.put('paymentId', paymentId);
        request.Parameters.put('paymentDate', paymentDate);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');
            System.debug('@@@ UpdateStatus_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + resultStatus);
        } catch (Exception ex) {
            System.debug('@@@ UpdateStatus_PaymentIdPaidExistInDB_ReturnNoAccessError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void AvailableEntity_PaymentIdExistInDB_ReturnStatusAvailable() {
        String expectStatus = 'available';
        Boolean expectMessage = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_PAID);
        String paymentId = payment.Id;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'availableEntity');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        String resultMessage = (String)response.Parameters.get('message');
        System.debug('@@@ AvailableEntity_PaymentIdExistInDB_ReturnStatusAvailable:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void AvailableEntity_PaymentIdNotExistInDB_ReturnStatusUnavailable() {
        String expectStatus = 'unavailable';
        Boolean expectMessage = true;

        String paymentId = TestDataFactory.getNotExistId();
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'availableEntity');
        request.Parameters.put('paymentId', paymentId);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        String resultMessage = (String)response.Parameters.get('message');
        System.debug('@@@ AvailableEntity_PaymentIdNotExistInDB_ReturnStatusUnavailable:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);
        System.assertEquals(expectMessage, String.isNotBlank(resultMessage));

        Test.stopTest();
    }

    @isTest static void RefreshPayments_ValidParamsWithInvoiceIdPendingExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Payment__c payment = null;
        List<Invoice__c> invoices = new List<Invoice__c>();

        List<Payment__c> payments = DIPaymentsTestDataFactory.getPaymentsFromDB();
        for(Payment__c p : payments) {
            if(p.Payment_Line_Items__r.size() > 0 && p.Is_Paid_Invoices__c && p.Is_Pending_invoices__c) {
                payment = p;
                break;
            }
        }   

        List<Invoice__c> listInvoices = DIInvoicesTestDataFactory.getInvoicesFromDB(new List<String>{DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING, DIInvoicesTestDataFactory.INVOICE_STATUS_PAID});
        for(Invoice__c i : listInvoices) {
            if(i.StartDate__c >= payment.StartDate__c && i.EndDate__c <= payment.EndDate__c) {
                invoices.add(i);
            }
        }   
        
        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshPayments');
        request.Parameters.put('invoices', invoices);

        service_Response response = new service_Response();

        Test.startTest();

        service_Payments servicePayments = new service_Payments();
        servicePayments.process(request, response);
        List<Payment__c> resultItems = (List<Payment__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
        System.debug('@@@ RefreshPayments_ValidParamsWithInvoiceIdPendingExistInDB_ReturnNotEmptyList:result: ' + resultItems);

        System.assertEquals(expectNotEmptyList, resultItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void RefreshPayments_WithEmptyListParams_ReturnNotFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;
        List<Invoice__c> invoices = new List<Invoice__c>();

        service_Request request = new service_Request();
        request.Parameters.put('invoices', invoices);
        request.Parameters.put('action', 'refreshPayments');

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            List<Payment__c> resultItems = (List<Payment__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ RefreshPayments_WithoutParams_ReturnEmptyList:result: ' + resultItems);
        }
        catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsNotExistPaymentType_ReturnNotFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

        @isTest static void RefreshPayments_WithoutParams_ReturnNullPointerError() {
        String expectedExceptionThrown = 'System.NullPointerException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'refreshPayments');

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_Payments servicePayments = new service_Payments();
            servicePayments.process(request, response);
            List<Payment__c> resultItems = (List<Payment__c>)response.Parameters.get('items');//TODO://Need convert to Map<String, Object>
            System.debug('@@@ RefreshPayments_WithoutParams_ReturnEmptyList:result: ' + resultItems);
        }
        catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsNotExistPaymentType_ReturnNullPointerError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

}