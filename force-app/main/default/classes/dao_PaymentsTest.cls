@isTest
public with sharing class dao_PaymentsTest {
    @testSetup static void setup() {
        DIPaymentsTestDataFactory.init();
    }

    @isTest static void FindOne_PaymentIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
        
        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Payment__c resultItem = daoPayments.findOne(paymentId);
        System.debug('@@@ FindOne_PaymentIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);

        Test.stopTest();
    }

    @isTest static void FindOne_PaymentIdNotExistInDB_ReturnNull() {
        Boolean expectNotExistItem = true;
         
        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Payment__c resultItem = daoPayments.findOne(paymentId);
        System.debug('@@@ FindOne_PaymentIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem == null);

        Test.stopTest();
    }

    @isTest static void FindOne_PaymentIdNull_ReturnNull() {
        Boolean expectNotExistItem = true;
         
        String paymentId = null;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Payment__c resultItem = daoPayments.findOne(paymentId);
        System.debug('@@@ FindOne_PaymentIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem == null);

        Test.stopTest();
    }

    @isTest static void FindByIds_PaymentsIdsExistInDB_ReturnNotEmptyList() {
        Integer expectSizeList = 1;
        
        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        Set<String> paymentsIds = new Set<String>{payment.Id};

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultList = daoPayments.findByIds(paymentsIds);
        System.debug('@@@ FindByIds_PaymentsIdsExistInDB_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeList, resultList.size());

        Test.stopTest();
    }

    @isTest static void FindByIds_PaymentsIdsEmpty_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
        
        Set<String> paymentsIds = new Set<String>();

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultList = daoPayments.findByIds(paymentsIds);
        System.debug('@@@ FindByIds_PaymentsIdsEmpty_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void FindByIds_PaymentsIdsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
        
        Set<String> paymentsIds = null;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultList = daoPayments.findByIds(paymentsIds);
        System.debug('@@@ FindByIds_PaymentsIdsNull_ReturnEmptyList:result: ' + resultList);

        System.assertEquals(expectSizeEmptyList, resultList.size());

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultListItems = daoPayments.findAll();
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByParams_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = null;
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = payment.StartDate__c;
        Date expectEndDate = payment.EndDate__c;
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = payment.Pending_invoices_startDate__c;
        Boolean expectExcludeDateRange = false;

        Map<String, Object> params = new Map<String, Object>{
            'paymentId' => expectPaymentId,
            'paymentType' => expectPaymentType,
            'receiverId' => expectReceiverId,
            'startDate' => expectStartDate,
            'endDate' => expectEndDate,
            'paidInvoices' => expectPaidInvoices,
            'pendingInvoices' => expectPendingInvoices,
            'pendingInvoicesStartDate' => expectPendingInvoicesStartDate,
            'excludeDateRange' => expectExcludeDateRange
        };

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultListInvoices = daoPayments.findByParams(params);
        System.debug('@@@ FindByParams_ValidParams_ReturnNotEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectNotEmptyList, resultListInvoices.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByParams_PaymentIdNotExistInDB_ReturnItem() {
        Integer sizeList = 1;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
     
        String expectPaymentId = TestDataFactory.getNotExistId();
        String expectPaymentType = payment.Payment_type__c;
        String expectReceiverId = payment.ReceiverId__c;
        Date expectStartDate = payment.StartDate__c;
        Date expectEndDate = payment.EndDate__c;
        Boolean expectPaidInvoices = payment.Is_Paid_Invoices__c;
        Boolean expectPendingInvoices = payment.Is_Pending_invoices__c;
        Date expectPendingInvoicesStartDate = payment.Pending_invoices_startDate__c;
        Boolean expectExcludeDateRange = false;

        Map<String, Object> params = new Map<String, Object>{
            'paymentId' => expectPaymentId,
            'paymentType' => expectPaymentType,
            'receiverId' => expectReceiverId,
            'startDate' => expectStartDate,
            'endDate' => expectEndDate,
            'paidInvoices' => expectPaidInvoices,
            'pendingInvoices' => expectPendingInvoices,
            'pendingInvoicesStartDate' => expectPendingInvoicesStartDate,
            'excludeDateRange' => expectExcludeDateRange
        };
        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultListInvoices = daoPayments.findByParams(params);
        System.debug('@@@ FindByParams_PaymentIdNotExistInDB_ReturnItem:result: ' + resultListInvoices);

        System.assertEquals(sizeList, resultListInvoices.size());

        Test.stopTest();
    }

    @isTest static void FindByParams_ParamsNull_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
            'paymentId' => null,
            'paymentType' => null,
            'receiverId' => null,
            'startDate' => null,
            'endDate' => null,
            'paidInvoices' => null,
            'pendingInvoices' => null,
            'pendingInvoicesStartDate' => null,
            'excludeDateRange' => null
        };

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultList = daoPayments.findByParams(params);
        System.debug('@@@ FindByParams_ParamsNull_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectNotEmptyList, resultList.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByParams_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = null;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        List<Payment__c> resultList = daoPayments.findByParams(params);
        System.debug('@@@ FindByParams_WithoutParams_ReturnNotEmptyList:result: ' + resultList);

        System.assertEquals(expectNotEmptyList, resultList.size() > sizeEmptyList);


        Test.stopTest();
    }

    @isTest static void ExistPaymentsInPeriod_ValidParams_ReturTrue() {
        Boolean expectInRange = true;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'paymentType' => payment.Payment_type__c,
            'receiverId' => payment.ReceiverId__c,
            'paymentId' => null
        };

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Boolean resultInRange = daoPayments.existPaymentsInPeriod(params);
        System.debug('@@@ ExistPaymentsInPeriod_ValidParams_ReturTrue:result: ' + resultInRange);

        System.assertEquals(expectInRange, resultInRange);

        Test.stopTest();
    }

    @isTest static void ExistPaymentsInPeriod_ReceiverIdNotExistInDB_ReturnFalse() {//TODO: check result when patams are null
        Boolean expectInRange = false;

        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'paymentType' => payment.Payment_type__c,
            'receiverId' => TestDataFactory.getNotExistId(),
            'paymentId' => payment.Id
        };

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Boolean resultInRange = daoPayments.existPaymentsInPeriod(params);
        System.debug('@@@ ExistPaymentsInPeriod_ReceiverIdNotExistInDB_ReturnFalse:result: ' + resultInRange);

        System.assertEquals(expectInRange, resultInRange);

        Test.stopTest();
    }

    @isTest static void ExistPaymentsInPeriod_ParamsNull_ReturnFalse() {//TODO: check result when patams are null
        Boolean expectInRange = false;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'paymentType' => null,
            'receiverId' => null,
            'paymentId' => null
        };

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Boolean resultInRange = daoPayments.existPaymentsInPeriod(params);
        System.debug('@@@ ExistPaymentsInPeriod_ParamsNull_ReturnFalse:result: ' + resultInRange);

        System.assertEquals(expectInRange, resultInRange);

        Test.stopTest();
    }

    @isTest static void ExistPaymentsInPeriod_WithoutParams_ReturnFalse() {//TODO: check result when patams are null
        Boolean expectInRange = false;

        Map<String, Object> params = null;

        Test.startTest();

        dao_Payments daoPayments = new dao_Payments();
        Boolean resultInRange = daoPayments.existPaymentsInPeriod(params);
        System.debug('@@@ ExistPaymentsInPeriod_WithoutParams_ReturnFalse:result: ' + resultInRange);

        System.assertEquals(expectInRange, resultInRange);

        Test.stopTest();
    }
}