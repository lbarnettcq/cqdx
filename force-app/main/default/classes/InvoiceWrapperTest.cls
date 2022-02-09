@isTest
public with sharing class InvoiceWrapperTest {
    @isTest static void CompareTo_TwoDates_ReturnPositiveNumber() {
        Integer expectNumber = 1;

        Map<String, Object> invoiceFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> invoiceSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Test.startTest();

        InvoiceWrapper invoiceWrapperFirst = new InvoiceWrapper(invoiceFirst);
        InvoiceWrapper invoiceWrapperSecond = new InvoiceWrapper(invoiceSecond);
        Integer resultNumber = invoiceWrapperFirst.compareTo(invoiceWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnNegativeNumber() {
        Integer expectNumber = -1;

        Map<String, Object> invoiceFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_END)
        };

        Map<String, Object> invoiceSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        InvoiceWrapper invoiceWrapperFirst = new InvoiceWrapper(invoiceFirst);
        InvoiceWrapper invoiceWrapperSecond = new InvoiceWrapper(invoiceSecond);
        Integer resultNumber = invoiceWrapperFirst.compareTo(invoiceWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }

    @isTest static void CompareTo_TwoDates_ReturnZero() {
        Integer expectNumber = 0;

        Map<String, Object> invoiceFirst = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Map<String, Object> invoiceSecond = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START)
        };

        Test.startTest();

        InvoiceWrapper invoiceWrapperFirst = new InvoiceWrapper(invoiceFirst);
        InvoiceWrapper invoiceWrapperSecond = new InvoiceWrapper(invoiceSecond);
        Integer resultNumber = invoiceWrapperFirst.compareTo(invoiceWrapperSecond);

        System.assertEquals(expectNumber, resultNumber);

        Test.stopTest();
    }
}