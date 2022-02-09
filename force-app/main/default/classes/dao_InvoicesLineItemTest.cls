@isTest
public with sharing class dao_InvoicesLineItemTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void FindByInvoice_InvoiceIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);
        String invoiceId = invoice.Id;

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> resultListItems = daoInvoicesLineItem.findByInvoice(invoiceId);
        System.debug('@@@ FindByInvoice_InvoiceIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindByInvoice_InvoiceIdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> resultListItems = daoInvoicesLineItem.findByInvoice(invoiceId);
        System.debug('@@@ FindByInvoice_InvoiceIdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByInvoice_InvoiceIdNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
         
        String invoiceId = null;

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> resultListItems = daoInvoicesLineItem.findByInvoice(invoiceId);
        System.debug('@@@ FindByInvoice_InvoiceIdNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_TimesheetIdExistInDB_ReturnItem() {
        Invoice_Line_Item__c notExistItem = null;
         
        List<Invoice_Line_Item__c> invoiceLineItems = DIInvoicesTestDataFactory.getInvoiceLineItemsFromDB();
        Invoice_Line_Item__c invoiceLineItem = invoiceLineItems.get(0);
        String timesheetId = invoiceLineItem.Timesheet__c;

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        Invoice_Line_Item__c resultItem = daoInvoicesLineItem.findByTimesheet(timesheetId);
        System.debug('@@@ FindByTimesheet_TimesheetIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_TimesheetIdNotExistInDB_ReturnNull() {
        Invoice_Line_Item__c expectNotExistItem = null;
         
        String timesheetId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        Invoice_Line_Item__c resultItem = daoInvoicesLineItem.findByTimesheet(timesheetId);
        System.debug('@@@ FindByTimesheet_TimesheetIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindByTimesheet_TimesheetIdNull_ReturnNull() {
        Invoice_Line_Item__c expectNotExistItem = null;
         
        String timesheetId = null;

        Test.startTest();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        Invoice_Line_Item__c resultItem = daoInvoicesLineItem.findByTimesheet(timesheetId);
        System.debug('@@@ FindByTimesheet_TimesheetIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }
}