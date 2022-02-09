@isTest
public with sharing class PaymentWrapperTest {
    @isTest static void CompareTo_TwoDates_ReturnPositiveNumber() {
        Integer expectNumber = 1;

        Map<String, Object> paymentFirst = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_START
        };

        Map<String, Object> paymentSecond = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_END
        };

        Test.startTest();

        PaymentWrapper paymentWrapperFirst = new PaymentWrapper(paymentFirst);
        PaymentWrapper paymentWrapperSecond = new PaymentWrapper(paymentSecond);
        Integer resultNumber = paymentWrapperFirst.compareTo(paymentWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnNegativeNumber() {
        Integer expectNumber = -1;

        Map<String, Object> paymentFirst = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_END
        };

        Map<String, Object> paymentSecond = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_START
        };

        Test.startTest();

        PaymentWrapper paymentWrapperFirst = new PaymentWrapper(paymentFirst);
        PaymentWrapper paymentWrapperSecond = new PaymentWrapper(paymentSecond);
        Integer resultNumber = paymentWrapperFirst.compareTo(paymentWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnZero() {
        Integer expectNumber = 0;

        Map<String, Object> paymentFirst = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_START
        };

        Map<String, Object> paymentSecond = new Map<String, Object>{
            'startDate' => TestDataFactory.DATE_START
        };

        Test.startTest();

        PaymentWrapper paymentWrapperFirst = new PaymentWrapper(paymentFirst);
        PaymentWrapper paymentWrapperSecond = new PaymentWrapper(paymentSecond);
        Integer resultNumber = paymentWrapperFirst.compareTo(paymentWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }
}