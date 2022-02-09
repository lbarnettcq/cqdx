@isTest
public with sharing class dao_PaymentsLineItemTest {
    @testSetup static void setup() {
        DIPaymentsTestDataFactory.init();
    }

    @isTest static void FindByPayment_PaymentIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Payment__c payment = DIPaymentsTestDataFactory.getPayment(DIPaymentsTestDataFactory.PAYMENT_STATUS_NEW);
        String paymentId = payment.Id;

        Test.startTest();

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> resultListItems = daoPaymentsLineItem.findByPayment(paymentId);
        System.debug('@@@ FindByPayment_PaymentIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByPayment_PaymentIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String paymentId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> resultListItems = daoPaymentsLineItem.findByPayment(paymentId);
        System.debug('@@@ FindByPayment_PaymentIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByPayment_PaymentIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String paymentId = null;

        Test.startTest();

        dao_PaymentsLineItem daoPaymentsLineItem = new dao_PaymentsLineItem();
        List<Payment_Line_Item__c> resultListItems = daoPaymentsLineItem.findByPayment(paymentId);
        System.debug('@@@ FindByPayment_PaymentIdNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }
}