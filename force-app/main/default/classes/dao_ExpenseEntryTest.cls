@isTest
public with sharing class dao_ExpenseEntryTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void FindOne_EntryIdExistInDB_ReturnItem() {
        Boolean expectExistItem = true;
         
        String expectEntryId = TestDataFactory.getExpenseEntryId();

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Expense_Entry__c resultItem = daoExpenseEntry.findOne(expectEntryId);
        System.debug('@@@ FindOne_EntryIdExistInDB_ReturnItem:result: ' + resultItem);

        System.assertEquals(expectExistItem, resultItem != null);
        System.assertEquals(expectEntryId, resultItem.Id);

        Test.stopTest();
    }

    @isTest static void FindOne_EntryIdNotExistInDB_ReturnNull() {
        Expense_Entry__c expectNotExistItem = null;
         
        String entryId = TestDataFactory.getNotExistId();

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Expense_Entry__c resultItem = daoExpenseEntry.findOne(entryId);
        System.debug('@@@ FindOne_EntryIdNotExistInDB_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindOne_EntryIdNull_ReturnNull() {
        Expense_Entry__c expectNotExistItem = null;
         
        String entryId = null;

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Expense_Entry__c resultItem = daoExpenseEntry.findOne(entryId);
        System.debug('@@@ FindOne_EntryIdNull_ReturnNull:result: ' + resultItem);

        System.assertEquals(expectNotExistItem, resultItem);

        Test.stopTest();
    }

    @isTest static void FindByDates_ValidDatesWithContractResourcesExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
         
        Map<String, Object> params = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findByDates(params);
        System.debug('@@@ FindByDates_ValidDatesWithContractResourcesExistInDB_ReturnNotEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectNotEmptyList, resultListExpenseEntries.size() > 0);

        Test.stopTest();
    }

    @isTest static void FindByDates_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>();

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findByDates(params);
        System.debug('@@@ FindByDates_WithoutParams_ReturnEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectSizeEmptyList, resultListExpenseEntries.size());

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_TimeshetIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
         
        Set<Id> ids = TestDataFactory.getTimesheetsIds();
        Set<String> timesheetIds = (Set<String>)JSON.deserialize(JSON.serialize(ids), Set<String>.class);
        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findByTimesheets(timesheetIds);
        System.debug('@@@ FindByTimesheets_TimeshetIdsExistInDB_ReturnNotEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectNotEmptyList, resultListExpenseEntries.size() > 0);

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_TimeshetIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> timesheetIds = TestDataFactory.getNotExistIds();
        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findByTimesheets(timesheetIds);
        System.debug('@@@ FindByTimesheets_TimeshetIdsNotExistInDB_ReturnEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectSizeEmptyList, resultListExpenseEntries.size());

        Test.stopTest();
    }

    @isTest static void FindByTimesheets_TimeshetEmptyIds_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> timesheetIds = new Set<String>();
        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findByTimesheets(timesheetIds);
        System.debug('@@@ FindByTimesheets_TimeshetEmptyIds_ReturnEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectSizeEmptyList, resultListExpenseEntries.size());

        Test.stopTest();
    }

    @isTest static void FindAll_ContractResourcesIdsExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
         
        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
           'listContractResourcesIds' => data.get('listContractResourcesIds')
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findAll(params);
        System.debug('@@@ FindAll_ContractResourcesIdsExistInDB_ReturnNotEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectNotEmptyList, resultListExpenseEntries.size() > 0);

        Test.stopTest();
    }

    @isTest static void FindAll_ContractResourcesIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Map<String, Object> params = new Map<String, Object>{
           'listContractResourcesIds' => TestDataFactory.getNotExistIds()
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findAll(params);
        System.debug('@@@ FindAll_ContractResourcesIdsNotExistInDB_ReturnEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectSizeEmptyList, resultListExpenseEntries.size());

        Test.stopTest();
    }

    @isTest static void FindAll_WithoutContractResourcesIds_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;
         
        Map<String, Object> params = new Map<String, Object>();

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> resultListExpenseEntries = daoExpenseEntry.findAll(params);
        System.debug('@@@ FindAll_WithoutContractResourcesIds_ReturnNotEmptyList:result: ' + resultListExpenseEntries);

        System.assertEquals(expectNotEmptyList, resultListExpenseEntries.size() > sizeEmptyList);

        Test.stopTest();
    }

  /*  @isTest static void GetTotalAmount_ValidParams_ReturnTotalAmount() {
        Boolean expectAmount = true;
         
        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => data.get('listContractResourcesIds'),
            'isApproved' => true,//TODO: Rename isApproved to approved
            'isBillable' => true//TODO: Rename isBillable to billabled
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getTotalAmount(params);
        System.debug('@@@ GetTotalAmount_ValidParams_ReturnTotalAmount:result: ' + resultTotalAmount);

        System.assertEquals(expectAmount, resultTotalAmount > 0);//TODO:move get amount to method getTotalAmount

        Test.stopTest();
    }

    @isTest static void GetTotalAmount_ParamsNull_ReturnTotalAmountZero() {
        Integer expectZeroAmount = 0;
         
        Set<String> listContractResourcesIds = new Set<String>();

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'listContractResourcesIds' => null,
            'isApproved' => null,//TODO: Rename isApproved to approved
            'isBillable' => null//TODO: Rename isGetTotalAmount_ParamsNull_ReturnCountItemsBillable to billabled
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getTotalAmount(params);
        System.debug('@@@ GetTotalAmount_ParamsNull_ReturnTotalAmountZero:result: ' + resultTotalAmount);

        System.assertEquals(expectZeroAmount, resultTotalAmount);

        Test.stopTest();
    }

    @isTest static void GetTotalAmount_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnTotalAmountZero() {
        Integer expectZeroTotalAmount = 0;
        
        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => TestDataFactory.getNotExistIds(),
            'isApproved' => true,//TODO: Rename isApproved to approved
            'isBillable' => true//TODO: Rename isBillable to billabled
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getTotalAmount(params);
        System.debug('@@@ GetTotalAmount_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnTotalAmountZero:result: ' + resultTotalAmount);

        System.assertEquals(expectZeroTotalAmount, resultTotalAmount);

        Test.stopTest();
    }
*/
    @isTest static void GetTotalAmountByDates_ValidParams_ReturnListAggregateResult() {
        Boolean expectNotEmptyList = true;       
        Integer sizeEmptyList = 0;

        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => data.get('listContractResourcesIds'),
            'status' => 'approved'
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<AggregateResult> resultListTotalAmount = daoExpenseEntry.getTotalAmountByDates(params);//TODO: change name method
        System.debug('@@@ GetTotalAmountByDates_ValidParams_ReturnListAggregateResult:result: ' + resultListTotalAmount);

        System.assertEquals(expectNotEmptyList, resultListTotalAmount.size() > sizeEmptyList);

        Test.stopTest();
    }

   @isTest static void GetTotalAmountByDates_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        Set<String> listContractResourcesIds = new Set<String>();

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => null,
            'endDate' => null,
            'listContractResourcesIds' => null,
            'status' => null
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<AggregateResult> resultListTotalAmount = daoExpenseEntry.getTotalAmountByDates(params);//TODO: change name method
        System.debug('@@@ GetTotalAmountByDates_ParamsNull_ReturnEmptyList:result: ' + resultListTotalAmount);

        System.assertEquals(expectSizeEmptyList, resultListTotalAmount.size());

        Test.stopTest();
    }

    @isTest static void GetTotalAmountByDates_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;       

        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => TestDataFactory.getNotExistIds(),
            'status' => 'approved'
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<AggregateResult> resultListTotalAmount = daoExpenseEntry.getTotalAmountByDates(params);//TODO: change name method
        System.debug('@@@ GetTotalAmountByDates_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnEmptyList:result: ' + resultListTotalAmount);

        System.assertEquals(expectSizeEmptyList, resultListTotalAmount.size());

        Test.stopTest();
    }

    @isTest static void GetAmount_ValidParams_ReturnTotalAmount() {
        Boolean expectTotalAmount = true;

        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => data.get('listContractResourcesIds')
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getAmount(params);
        System.debug('@@@ GetAmount_ValidParams_ReturnTotalAmount:result: ' + resultTotalAmount);

        System.assertEquals(expectTotalAmount, resultTotalAmount > 0);//TODO:move get amount to method getTotalAmount

        Test.stopTest();
    }

    @isTest static void GetAmount_WithoutParams_ReturnTotalAmountZero() {
        Decimal expectTotalAmountZero = 0;

        Map<String, Object> params = new Map<String, Object>();

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getAmount(params);
        System.debug('@@@ GetAmount_WithoutParams_ReturnTotalAmountZero:result: ' + resultTotalAmount);

        System.assertEquals(expectTotalAmountZero, resultTotalAmount);

        Test.stopTest();
    }

    @isTest static void GetAmount_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnTotalAmountZero() {
        Decimal expectTotalAmountZero = 0;

        Map<String, Object> data = TestDataFactory.getContractResourcesAndDatesFromExpenses(10, true, true);

        Map<String, Object> params = new Map<String, Object>{
            'startDate' => data.get('startDate'),
            'endDate' => data.get('endDate'),
            'listContractResourcesIds' => TestDataFactory.getNotExistIds()
        };

        Test.startTest();

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Decimal resultTotalAmount = daoExpenseEntry.getAmount(params);
        System.debug('@@@ GetAmount_ValidParamsWithContractResourcesIdsNotExistInDB_ReturnTotalAmountZero:result: ' + resultTotalAmount);

        System.assertEquals(expectTotalAmountZero, resultTotalAmount);

        Test.stopTest();
    }
}