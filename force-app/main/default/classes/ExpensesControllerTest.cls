@isTest
public with sharing class ExpensesControllerTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetTypes_WithoutParams_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeList = 4;
        Boolean expectAirFare = true;
        Boolean expectHotelRoom = true;
        Boolean expectMeal = true;
        Boolean expectRentalCar = true;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getTypes();
        System.debug('@@@ GetTypes_WithoutParams_ReturnNotEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        List<Map<String, Object>> resultList = (List<Map<String, Object>>)resultData.get('list');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeList, resultList.size());
        System.assertEquals(expectAirFare, resultList.contains(new Map<String, String>{
            'id' => TestDataFactory.EXPENSE_TYPE_AIRFARE,
            'label' => TestDataFactory.EXPENSE_TYPE_AIRFARE
        }));
        System.assertEquals(expectHotelRoom, resultList.contains(new Map<String, String>{
            'id' => TestDataFactory.EXPENSE_TYPE_HOTEL_ROOM,
            'label' => TestDataFactory.EXPENSE_TYPE_HOTEL_ROOM
        }));
        System.assertEquals(expectMeal, resultList.contains(new Map<String, String>{
            'id' => TestDataFactory.EXPENSE_TYPE_MEAL,
            'label' => TestDataFactory.EXPENSE_TYPE_MEAL
        }));
        System.assertEquals(expectRentalCar, resultList.contains(new Map<String, String>{
            'id' => TestDataFactory.EXPENSE_TYPE_RENTAL_CAR,
            'label' => TestDataFactory.EXPENSE_TYPE_RENTAL_CAR
        }));

        Test.stopTest();
    }

    @isTest static void GetList_ValidParamsWithoutTimesheet_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListExpenses = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<String> contractsIds = TestDataFactory.getContractsIdsFromContractResources(employeeId);

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        Date startDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('startDate'));
        Date endDate = Date.valueOf((String)((Map<String, Object>)dateRanges.get(0)).get('endDate'));        
        String timesheetId = null;
        String invoiceId = null;
        String paymentId = null;
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_ValidParamsWithoutTimesheet_ReturnList:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListExpenses, resultSizeListExpenses > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_InvalidAllParams_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 3;

        String employeeId = null;
        List<String> contractsIds = null;
        Date startDate = null;
        Date endDate = null;
        String timesheetId = null;
        String invoiceId = null;
        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_InvalidAllParams_ReturnValidationErrors:result ' + result);

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

    @isTest static void GetList_TimesheetIdExistInDB_ReturnNotEmptyList() {
        String expectResponseStatus = 'success';
        Boolean expectNotEmptyList = true;

        Integer sizeEmptyList = 0;

        String employeeId = null;
        List<String> contractsIds = null;
        Date startDate = null;
        Date endDate = null;        
        String timesheetId = TestDataFactory.getTimesheetId('approved');
        String invoiceId = null;
        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_TimesheetIdExistInDB_ReturnNotEmptyList:result ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListExpenses = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectNotEmptyList, resultSizeListExpenses > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetList_TimesheetIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String employeeId = null;
        List<String> contractsIds = null;
        Date startDate = null;
        Date endDate = null;
        String timesheetId = TestDataFactory.getNotExistId();
        String invoiceId = null;
        String paymentId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getList(contractsIds, startDate, endDate, employeeId, timesheetId, invoiceId, paymentId);
        System.debug('@@@ GetList_TimesheetIdNotExistInDB_ReturnNotFoundError:result ' + result);

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

    @isTest static void GetAccounts_ValidParamsWithoutTimesheet_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListAccounts = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();
        String timesheetId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getAccounts(status, employeeId, timesheetId);
        System.debug('@@@ GetAccounts_ValidParamsWithoutTimesheet_ReturnList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListAccounts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListAccounts, resultSizeListAccounts > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_ValidParamsWithExistTimesheetInDB_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListAccounts = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();
        String timesheetId = TestDataFactory.getTimesheetId();

        Test.startTest();

        Map<String, Object> result = ExpensesController.getAccounts(status, employeeId, timesheetId);
        System.debug('@@@ GetAccounts_ValidParamsWithExistTimesheetInDB_ReturnList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListAccounts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListAccounts, resultSizeListAccounts > sizeEmptyList);

        Test.stopTest();
    }


    @isTest static void GetAccounts_ValidParamsWithNotExistTimesheetInDB_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListAccounts = true;
        Integer sizeEmptyList = 0;

        String status = TestDataFactory.ACCOUNT_STATUS_ACTIVE;
        String employeeId = UserInfo.getUserId();
        String timesheetId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = ExpensesController.getAccounts(status, employeeId, timesheetId);
        System.debug('@@@ GetAccounts_ValidParamsWithNotExistTimesheetInDB_ReturnList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListAccounts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListAccounts, resultSizeListAccounts > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetAccounts_StatusNullParam_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListAccounts = true;
        Integer sizeEmptyList = 0;

        String status = null;
        String employeeId = UserInfo.getUserId();
        String timesheetId = null;

        Test.startTest();

        Map<String, Object> result = ExpensesController.getAccounts(status, employeeId, timesheetId);
        System.debug('@@@ GetAccounts_StatusNullParam_ReturnList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListAccounts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListAccounts, resultSizeListAccounts > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContracts_AccountIdExistInDB_ReturnList() {
        String expectResponseStatus = 'success';
        Boolean expectSizeListContracts = true;
        Integer sizeEmptyList = 0;

        String accountId = TestDataFactory.getAccountId();
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.getContracts(accountId);
        System.debug('@@@ GetContracts_AccountIdExistInDB_ReturnList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Integer resultSizeListContracts = ((List<Map<String, Object>>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListContracts, resultSizeListContracts > sizeEmptyList);

        Test.stopTest();
    }

    @isTest static void GetContracts_AccountIdNotExistInDB_ReturnNotFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String accountId = TestDataFactory.getNotExistId();
 
        Test.startTest();

        Map<String, Object> result = ExpensesController.getContracts(accountId);
        System.debug('@@@ GetContracts_AccountIdNotExistInDB_ReturnNotFoundError:result: ' + result);


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

    @isTest static void GetContracts_AccountIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String accountId = null;
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.getContracts(accountId);
        System.debug('@@@ GetContracts_AccountIdNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void UpdateEntries_NotEmptyList_ReturnUpdatedList() {
        String expectResponseStatus = 'success';

        List<Object> dateRanges = (List<Object>)TestDataFactory.configDateRanges.values();
        String endDate = (String)((Map<String, Object>)dateRanges.get(0)).get('endDate');    

        String expectExpenseDate = endDate;
        String expectSubmittalDate = endDate;
        String expectAmount = '100';
        String expectInvoicedAmount = '200';
        String expectDescription = 'new description';
        String expectType = 'Airfare';
        String expectBillable = 'true';
        String expectIsApproved = 'true';

        Id expectExpenseId = TestDataFactory.getExpenseEntryId(false);

        List<Map<String, String>> paramListExpenses = new List<Map<String ,String>>{
            new Map<String, String>{
                'id' => expectExpenseId,
                'expenseDate' => expectExpenseDate,
                'submittalDate' => expectSubmittalDate,
                'amount' => expectAmount,
                'invoicedAmount' => expectInvoicedAmount,
                'description' => expectDescription,
                'type' => expectType,
                'billable' => expectBillable,
                'isApproved' => expectIsApproved
            }
        };
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.updateEntries(paramListExpenses);
        System.debug('@@@ UpdateEntries_NotEmptyList_ReturnUpdatedList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        List<Expense_Entry__c> resultListExpenses = (List<Expense_Entry__c>)resultData.get('list');//TODO:convert to map
        Expense_Entry__c resultItem = resultListExpenses[0];

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals((Id)expectExpenseId, resultItem.Id);
        System.assertEquals(Date.valueOf(expectExpenseDate), resultItem.Date__c);
        System.assertEquals(Date.valueOf(expectSubmittalDate), resultItem.Submittal_Date__c);
        System.assertEquals(Decimal.valueOf(expectAmount), resultItem.Amount__c);
        System.assertEquals(Decimal.valueOf(expectInvoicedAmount), resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(expectBillable, String.valueOf(resultItem.Is_Billable__c));
        System.assertEquals(expectIsApproved, String.valueOf(resultItem.Is_Approved__c));

        Test.stopTest();
    }

    @isTest static void UpdateEntries_NotEmptyApprovedList_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        Id expectExpenseId = TestDataFactory.getExpenseEntryId(true);

        List<Map<String, String>> paramListExpenses = new List<Map<String ,String>>{
            new Map<String, String>{
                'id' => expectExpenseId
            }
        };
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.updateEntries(paramListExpenses);
        System.debug('@@@ UpdateEntries_NotEmptyApprovedList_ReturnNoAccessError:result: ' + result);

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

    @isTest static void UpdateEntries_EmptyList_ReturnEmptyList() {
        String expectResponseStatus = 'success';
        Integer expectSizeListExpenses = 0;

        List<Map<String, String>> expenses = new List<Map<String, String>>();
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.updateEntries(expenses);
        System.debug('@@@ UpdateEntries_EmptyList_ReturnEmptyList:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        Integer resultSizeListExpenses = ((List<Object>)resultData.get('list')).size();

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectSizeListExpenses, resultSizeListExpenses);

        Test.stopTest();
    }

    @isTest static void UpdateEntries_ListNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        List<Map<String,String>> expenses = null;
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.updateEntries(expenses);
        System.debug('@@@ UpdateEntries_ListNull_ReturnValidationErrors:result: ' + result);

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

    @isTest static void InsertEntry_ValidParamsWithoutTimesheet_ReturnInsertedExpense() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedExpenseId = true;

        Map<String, Object> itemExpense = TestDataFactory.getNewExpense();

        String expectContractId = (String)itemExpense.get('contractId');
        String expectDescription = (String)itemExpense.get('description');
        Decimal expectAmount = (Decimal)itemExpense.get('amount');
        Decimal expectInvoicedAmount = (Decimal)itemExpense.get('invoicedAmount');
        Date expectExpenseDate = (Date)itemExpense.get('expenseDate');
        Date expectSubmittalDate = (Date)itemExpense.get('submittalDate');
        Boolean expectBillable = (Boolean)itemExpense.get('billable');
        String expectType = (String)itemExpense.get('type');
        String expectTimesheetId = null;
        String expectEmployeeId  = null;

        Test.startTest();
            
        Map<String, Object> result = ExpensesController.insertEntry(
            expectContractId, expectDescription, expectAmount, expectInvoicedAmount, expectExpenseDate, 
            expectSubmittalDate, expectBillable, expectType, expectTimesheetId, expectEmployeeId);
        System.debug('@@@ InsertEntry_ValidParamsWithoutTimesheet_ReturnInsertedExpense:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');    
        Expense_Entry__c resultItem = ((Expense_Entry__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedExpenseId, resultItem.Id != null);
        System.assertEquals(expectExpenseDate, resultItem.Date__c);
        System.assertEquals(expectSubmittalDate, resultItem.Submittal_Date__c);
        System.assertEquals(expectAmount, resultItem.Amount__c);
        System.assertEquals(expectInvoicedAmount, resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(expectBillable, resultItem.Is_Billable__c);

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithTimesheetExistInDB_ReturnInsertedExpense() {
        String expectResponseStatus = 'success';
        Boolean expectCreatedExpenseId = true;

        Map<String, Object> itemExpense = TestDataFactory.getNewExpense();

        String expectContractId = (String)itemExpense.get('contractId');
        String expectDescription = (String)itemExpense.get('description');
        Decimal expectAmount = (Decimal)itemExpense.get('amount');
        Decimal expectInvoicedAmount = (Decimal)itemExpense.get('invoicedAmount');
        Date expectExpenseDate = (Date)itemExpense.get('expenseDate');
        Date expectSubmittalDate = (Date)itemExpense.get('submittalDate');
        Boolean expectBillable = (Boolean)itemExpense.get('billable');
        String expectType = (String)itemExpense.get('type');
        String expectTimesheetId = (String)itemExpense.get('timesheetId');
        String expectEmployeeId  = (String)itemExpense.get('employeeId');

        Test.startTest();
            
        Map<String, Object> result = ExpensesController.insertEntry(
            expectContractId, expectDescription, expectAmount, expectInvoicedAmount, expectExpenseDate, 
            expectSubmittalDate, expectBillable, expectType, expectTimesheetId, expectEmployeeId);
        System.debug('@@@ InsertEntry_ValidParamsWithTimesheetExistInDB_ReturnInsertedExpense:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');        
        Expense_Entry__c resultItem = ((Expense_Entry__c)resultData.get('item'));//TODO://Need convert to Map<String, Object>

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectCreatedExpenseId, resultItem.Id != null);
        System.assertEquals(expectExpenseDate, resultItem.Date__c);
        System.assertEquals(expectSubmittalDate, resultItem.Submittal_Date__c);
        System.assertEquals(expectAmount, resultItem.Amount__c);
        System.assertEquals(expectInvoicedAmount, resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(expectBillable, resultItem.Is_Billable__c);

        Test.stopTest();
    }

    @isTest static void InsertEntry_InvalidAllParams_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 6;

        String contractId = null;
        String description = null;
        Decimal amount = null;
        Decimal invoicedAmount = null;        
        Date expenseDate = null;
        Date submittalDate = null;
        Boolean billable = null;
        String type = null;
        String timesheetId = null;
        String employeeId  = null;
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.insertEntry(
            contractId, description, amount, invoicedAmount, expenseDate, 
            submittalDate, billable, type, timesheetId, employeeId);
        System.debug('@@@ InsertEntry_InvalidAllParams_ReturnValidationErrors:result: ' + result);

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

    @isTest static void DeleteEntry_ExistApprovedExpenseIdInDB_ReturnNoAccessError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String expenseId = (String)TestDataFactory.getExpenseEntryId(true);

        Test.startTest();

        Map<String, Object> result = ExpensesController.deleteEntry(expenseId);
        System.debug('@@@ DeleteEntry_ExistApprovedExpenseIdInDB_ReturnNoAccessError:result: ' + result);

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

    @isTest static void DeleteEntry_ExistNotApprovedExpenseIdInDB_ReturnStatusSuccess() {
        String expectResponseStatus = 'success';
        String expectStatus = 'success';

        String expenseId = (String)TestDataFactory.getExpenseEntryId(false);

        Test.startTest();

        Map<String, Object> result = ExpensesController.deleteEntry(expenseId);
        System.debug('@@@ DeleteEntry_ExistNotApprovedExpenseIdInDB_ReturnStatusSuccess:result: ' + result);

        String resultResponseStatus = (String)result.get('status');
        Map<String, Object> resultData = (Map<String, Object>)result.get('data');
        String resultStatus = (String)resultData.get('status');

        System.assertEquals(expectResponseStatus, resultResponseStatus);
        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
      }

    @isTest static void DeleteEntry_NotExistExpenseIdInDB_ReturnNoFoundError() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 500;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String expenseId = TestDataFactory.getNotExistId();

        Test.startTest();

        Map<String, Object> result = ExpensesController.deleteEntry(expenseId);
        System.debug('@@@ DeleteEntry_NotExistExpenseIdInDB_ReturnNoFoundError:result: ' + result);

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

      @isTest static void DeleteEntry_ExpenseIdNull_ReturnValidationErrors() {
        String expectResponseStatus = 'error';
        Integer expectCodeError = 400;
        Boolean expectMessage = true;
        Integer expectSizeListErrors = 1;

        String expenseId = null;
       
        Test.startTest();

        Map<String, Object> result = ExpensesController.deleteEntry(expenseId);
        System.debug('@@@ DeleteEntry_ExpenseIdNull_ReturnValidationErrors:result: ' + result);

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