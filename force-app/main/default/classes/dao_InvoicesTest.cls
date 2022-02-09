@isTest
public with sharing class dao_InvoicesTest {
    @testSetup static void setup() {
        DIInvoicesTestDataFactory.init();
    }

    @isTest static void FindOne_InvoiceIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String invoiceId = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_NEW).Id;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOne(invoiceId);
        System.debug('@@@ FindOne_InvoiceIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);

        Test.stopTest();
    }

    @isTest static void FindOne_InvoiceIdNotExistInDB_ReturnNull() {
        Invoice__c expectNotExistItem = null;
         
        String invoiceId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOne(invoiceId);
        System.debug('@@@ FindOne_InvoiceIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_InvoiceIdNull_ReturnNull() {
        Invoice__c expectNotExistItem = null;
         
        String invoiceId = null;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOne(invoiceId);
        System.debug('@@@ FindOne_InvoiceIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByDates_ValidParams_ReturnItem() {
        Invoice__c notExistItem = null;

        List<Invoice__c> invoices = DIInvoicesTestDataFactory.getInvoicesFromDB();
        Invoice__c invoice = invoices[0];

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => invoice.StartDate__c,
            'endDate' => invoice.EndDate__c,
            'accountId' => invoice.Account__c,
            'status' => invoice.Status__c
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOneByDates(params);
        System.debug('@@@ FindOneByDates_ValidParams_ReturnItem:result: ' + resultItem);

        System.assertNotEquals(notExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByDates_AccountIdNotExistInDB_ReturnNull() {
        Invoice__c expectNotExistItem = null;
         
        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'accountId' => TestDataFactory.getNotExistId()
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOneByDates(params);
        System.debug('@@@ FindOneByDates_AccountIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOneByDates_ParamsNull_ReturnNull() {
        Invoice__c expectNotExistItem = null;
         
        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'accountId' => null
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOneByDates(params);
        System.debug('@@@ FindOneByDates_ParamsNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }
    @isTest static void FindOneByDates_WithoutParams_ReturnNull() {
        Invoice__c expectNotExistItem = null;
         
        Map<String, Object> params = null;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c resultItem = daoInvoices.findOneByDates(params);
        System.debug('@@@ FindOneByDates_WithoutParams_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Integer limits = 0;
        Integer offsets = 0;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> resultListInvoices = daoInvoices.findAll(limits, offsets);//TODO:remove parameters
        System.debug('@@@ FindAll_WithoutParams_ReturnNotEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectNotEmptyList, resultListInvoices.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_ValidParams_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'pendingInvoicesStartDate' => Date.valueOf(TestDataFactory.DATE_START),
            'accountIds' => TestDataFactory.getAccountsIds(),
            'status' => DIInvoicesTestDataFactory.INVOICE_STATUS_PAID
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> resultListInvoices = daoInvoices.findAllByParams(params);
        System.debug('@@@ FindAllByParams_ValidParams_ReturnNotEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectNotEmptyList, resultListInvoices.size() > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_AccountsIdsNotExistInDB_ReturnEmptyList() {
        Boolean expectEmptyList = true;
        Integer sizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'pendingInvoicesStartDate' => Date.valueOf(TestDataFactory.DATE_START),
            'accountIds' => TestDataFactory.getNotExistIds(),
            'status' => DIInvoicesTestDataFactory.INVOICE_STATUS_PAID
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> resultListInvoices = daoInvoices.findAllByParams(params);
        System.debug('@@@ FindAllByParams_AccountsIdsNotExistInDB_ReturnEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectEmptyList, resultListInvoices.size() == sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void FindAllByParams_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'pendingInvoicesStartDate' => null,
            'accountIds' => null,
            'status' => null
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> resultListInvoices = daoInvoices.findAllByParams(params);
        System.debug('@@@ FindAllByParams_ParamsNull_ReturnEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectSizeEmptyList, resultListInvoices.size());

        Test.stopTest();
    }

    @isTest static void FindAllByParams_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = null;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> resultListInvoices = daoInvoices.findAllByParams(null);
        System.debug('@@@ FindAllByParams_WithoutParams_ReturnEmptyList:result: ' + resultListInvoices);

        System.assertEquals(expectSizeEmptyList, resultListInvoices.size());

        Test.stopTest();
    }

    @isTest static void CheckDatesInPeriods_ExistInvoiceForNewPeriod_ReturnFalse() {
        Boolean expectExistItem = false;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);

        Map<String, Object> conditions = new Map<String, Object>{
            'startDate' => Date.valueOf(invoice.StartDate__c).addDays(-1),
            'endDate' => Date.valueOf(invoice.EndDate__c).addDays(1),
            'accountId' => invoice.Account__c,
            'invoiceId' => invoice.Id
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean resultExistItem = daoInvoices.checkDatesInPeriods(conditions);
        System.debug('@@@ CheckDatesInPeriods_ExistInvoiceForNewPeriod_ReturnFalse:result: ' + resultExistItem);

        System.assertEquals(expectExistItem, resultExistItem);

        Test.stopTest();
    }

    @isTest static void CheckDatesInPeriods_NotExistInvoiceForNewPeriod_ReturnTrue() {
        Boolean expectNotExistItem = true;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(invoice.StartDate__c).addDays(1),
            'endDate' => Date.valueOf(invoice.EndDate__c).addDays(-1),
            'accountId' => invoice.Account__c,
            'invoiceId' => invoice.Id
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean resultNotExistItem = daoInvoices.checkDatesInPeriods(params);
        System.debug('@@@ CheckDatesInPeriods_NotExistInvoiceForNewPeriod_ReturnTrue:result: ' + resultNotExistItem);

        System.assertEquals(expectNotExistItem, resultNotExistItem);

        Test.stopTest();
    }

    @isTest static void CheckDatesInPeriods_AccountIdNotExistInDB_ReturnTrue() {//TODO: check result when patams are null
        Boolean expectNotExistItem = true;

        Invoice__c invoice = DIInvoicesTestDataFactory.getInvoice(DIInvoicesTestDataFactory.INVOICE_STATUS_PAID);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => Date.valueOf(TestDataFactory.DATE_START),
            'endDate' => Date.valueOf(TestDataFactory.DATE_END),
            'accountId' => TestDataFactory.getNotExistId(),
            'invoiceId' => invoice.Id
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean resultNotExistItem = daoInvoices.checkDatesInPeriods(params);
        System.debug('@@@ CheckDatesInPeriods_AccountIdNotExistInDB_ReturnTrue:result: ' + resultNotExistItem);

        System.assertEquals(expectNotExistItem, resultNotExistItem);

        Test.stopTest();
    }

    @isTest static void CheckDatesInPeriods_ParamsNull_ReturnTrue() {//TODO: check result when patams are null
        Boolean expectNotExistItem = true;

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'accountId' => null,
            'invoiceId' => null
        };

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean resultNotExistItem = daoInvoices.checkDatesInPeriods(params);
        System.debug('@@@ CheckDatesInPeriods_ParamsNull_ReturnTrue:result: ' + resultNotExistItem);

        System.assertEquals(expectNotExistItem, resultNotExistItem);

        Test.stopTest();
    }

    @isTest static void CheckDatesInPeriods_WithoutParams_ReturnTrue() {//TODO: check result when patams are null
        Boolean expectNotExistItem = true;

        Map<String, Object> params = null;

        Test.startTest();

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean resultNotExistItem = daoInvoices.checkDatesInPeriods(params);
        System.debug('@@@ CheckDatesInPeriods_WithoutParams_ReturnTrue:result: ' + resultNotExistItem);

        System.assertEquals(expectNotExistItem, resultNotExistItem);

        Test.stopTest();
    }
}