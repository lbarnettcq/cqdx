@isTest
public with sharing class service_ExpenseEntryTest {
    @testSetup static void setup() {
        TestDataFactory.init();
    }

    @isTest static void GetTypes_WithoutParams_ReturnNotEmptyList() {//TODO: add all types and equals
        Integer expectSizeList = 4;
        Boolean expectAirFare = true;
        Boolean expectHotelRoom = true;
        Boolean expectMeal = true;
        Boolean expectRentalCar = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getTypes');

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Map<String, String>> resultList = (List<Map<String, String>>)response.Parameters.get('list');
        System.debug('@@@ GetTypes_WithoutParams_ReturnNotEmptyList:result: ' + resultList);

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

    @isTest static void GetList_TimesheetIdExistInDB_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String timesheetId = TestDataFactory.getTimesheetId('approved');

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_TimesheetIdExistInDB_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void GetList_TimesheetIdNotExistInDB_ReturnNoDataFoundError() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        String timesheetId = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('timesheetId', timesheetId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
            System.debug('@@@ GetList_TimesheetIdNotExistInDB_ReturnNoDataFoundError:result: ' + resultListItems);
        } catch (Exception ex) {
            System.debug('@@@ GetList_TimesheetIdNotExistInDB_ReturnNoDataFoundError:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void GetList_ValidParamsWithoutTimesheet_ReturnNotEmptyList() {
        Boolean expectNotEmptyList = true;
        Integer sizeEmptyList = 0;

        String employeeId = UserInfo.getUserId();
        List<String> contractsIds = TestDataFactory.getContractsIdsFromContractResources(employeeId);

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('contractsIds', contractsIds);
        request.Parameters.put('employeeId', employeeId);
        request.Parameters.put('startDate', Date.valueOf(TestDataFactory.DATE_START));
        request.Parameters.put('endDate', Date.valueOf(TestDataFactory.DATE_END));

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ValidParamsWithoutTimesheet_ReturnNotEmptyList:result: ' + resultListItems);

        System.assertEquals(expectNotEmptyList, resultListItems.size() > sizeEmptyList);

        Test.stopTest();
    }

     @isTest static void GetList_ParamsNull_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'getList');
        request.Parameters.put('timesheetId', null);
        request.Parameters.put('contractsIds', null);
        request.Parameters.put('employeeId', null);
        request.Parameters.put('startDate', null);
        request.Parameters.put('endDate', null);

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Map<String, Object>> resultListItems = (List<Map<String, Object>>)response.Parameters.get('list');
        System.debug('@@@ GetList_ParamsNull_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithoutTimesheet_ReturnInsertedExpense() {
        Expense_Entry__c notCreatedExpense = null;
        Id IdNull = null;

        Map<String, Object> itemExpense = TestDataFactory.getNewExpense();

        String expectContractId = (String)itemExpense.get('contractId');
        String expectDescription = (String)itemExpense.get('description');
        Decimal expectAmount = (Decimal)itemExpense.get('amount');
        Decimal expectInvoicedAmount = (Decimal)itemExpense.get('invoicedAmount');
        Date expectExpenseDate = (Date)itemExpense.get('expenseDate');
        Date expectSubmittalDate = (Date)itemExpense.get('submittalDate');
        Boolean expectBillable = (Boolean)itemExpense.get('billable');
        String expectType = (String)itemExpense.get('type');
        String expectEmployeeId  = UserInfo.getUserId();
        String expectTimesheetId = null;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('expenseDate', expectExpenseDate);
        request.Parameters.put('submittalDate', expectSubmittalDate);
        request.Parameters.put('amount', expectAmount);
        request.Parameters.put('invoicedAmount', expectInvoicedAmount);
        request.Parameters.put('description', expectDescription);
        request.Parameters.put('billable', expectBillable);
        request.Parameters.put('type', expectType);
        request.Parameters.put('employeeId', expectEmployeeId);
        request.Parameters.put('timesheetId', expectTimesheetId);        

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        Expense_Entry__c resultItem = (Expense_Entry__c)response.Parameters.get('item');
        System.debug('@@@ InsertEntry_ValidParamsWithoutTimesheet_ReturnInsertedExpense:result: ' + resultItem);

        System.assertNotEquals(notCreatedExpense,  resultItem);
        System.assertNotEquals(IdNull,  resultItem.Id);
        System.assertEquals(expectExpenseDate, resultItem.Date__c);
        System.assertEquals(expectSubmittalDate, resultItem.Submittal_Date__c);
        System.assertEquals(expectAmount, resultItem.Amount__c);
        System.assertEquals(expectInvoicedAmount, resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(expectBillable, resultItem.Is_Billable__c);

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithTimesheetIdExistInDB_ReturnInsertedExpense() {
        Expense_Entry__c notCreatedExpense = null;
        Id IdNull = null;

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
        String expectEmployeeId  = UserInfo.getUserId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('expenseDate', expectExpenseDate);
        request.Parameters.put('submittalDate', expectSubmittalDate);
        request.Parameters.put('amount', expectAmount);
        request.Parameters.put('invoicedAmount', expectInvoicedAmount);
        request.Parameters.put('description', expectDescription);
        request.Parameters.put('billable', expectBillable);
        request.Parameters.put('type', expectType);
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('employeeId', expectEmployeeId);

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        Expense_Entry__c resultItem = (Expense_Entry__c)response.Parameters.get('item');
        System.debug('@@@ InsertEntry_ValidParamsWithTimesheetIdExistInDB_ReturnInsertedExpense:result: ' + resultItem);

        System.assertNotEquals(notCreatedExpense,  resultItem);
        System.assertNotEquals(IdNull,  resultItem.Id);
        System.assertEquals(expectExpenseDate, resultItem.Date__c);
        System.assertEquals(expectSubmittalDate, resultItem.Submittal_Date__c);
        System.assertEquals(expectAmount, resultItem.Amount__c);
        System.assertEquals(expectInvoicedAmount, resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(expectBillable, resultItem.Is_Billable__c);

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> itemExpense = TestDataFactory.getNewExpense();

        String expectContractId = (String)itemExpense.get('contractId');
        String expectDescription = (String)itemExpense.get('description');
        Decimal expectAmount = (Decimal)itemExpense.get('amount');
        Decimal expectInvoicedAmount = (Decimal)itemExpense.get('invoicedAmount');
        Date expectExpenseDate = (Date)itemExpense.get('expenseDate');
        Date expectSubmittalDate = (Date)itemExpense.get('submittalDate');
        Boolean expectBillable = (Boolean)itemExpense.get('billable');
        String expectType = (String)itemExpense.get('type');
        String expectTimesheetId = TestDataFactory.getNotExistId();
        String expectEmployeeId  = UserInfo.getUserId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('expenseDate', expectExpenseDate);
        request.Parameters.put('submittalDate', expectSubmittalDate);
        request.Parameters.put('amount', expectAmount);
        request.Parameters.put('invoicedAmount', expectInvoicedAmount);
        request.Parameters.put('description', expectDescription);
        request.Parameters.put('billable', expectBillable);
        request.Parameters.put('type', expectType);
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('employeeId', expectEmployeeId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            Expense_Entry__c resultItem = (Expense_Entry__c)response.Parameters.get('item');    
            System.debug('@@@ InsertEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + resultItem);        
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsWithTimesheetIdNotExistInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void InsertEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        Map<String, Object> itemExpense = TestDataFactory.getNewExpense();

        String expectContractId = TestDataFactory.getNotExistId();
        String expectDescription = (String)itemExpense.get('description');
        Decimal expectAmount = (Decimal)itemExpense.get('amount');
        Decimal expectInvoicedAmount = (Decimal)itemExpense.get('invoicedAmount');
        Date expectExpenseDate = (Date)itemExpense.get('expenseDate');
        Date expectSubmittalDate = (Date)itemExpense.get('submittalDate');
        Boolean expectBillable = (Boolean)itemExpense.get('billable');
        String expectType = (String)itemExpense.get('type');
        String expectTimesheetId = null;
        String expectEmployeeId  = TestDataFactory.getNotExistId();

        service_Request request = new service_Request();
        request.Parameters.put('action', 'insertEntry');
        request.Parameters.put('contractId', expectContractId);
        request.Parameters.put('expenseDate', expectExpenseDate);
        request.Parameters.put('submittalDate', expectSubmittalDate);
        request.Parameters.put('amount', expectAmount);
        request.Parameters.put('invoicedAmount', expectInvoicedAmount);
        request.Parameters.put('description', expectDescription);
        request.Parameters.put('billable', expectBillable);
        request.Parameters.put('type', expectType);
        request.Parameters.put('timesheetId', expectTimesheetId);
        request.Parameters.put('employeeId', expectEmployeeId);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            Expense_Entry__c resultItem = (Expense_Entry__c)response.Parameters.get('item');   
             System.debug('@@@ InsertEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound:result: ' + resultItem);         
        } catch (Exception ex) {
            System.debug('@@@ InsertEntry_ValidParamsWithContractEmployeeNotExistInDB_ReturnErrorNotFound:result: ' + ex);
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }
        
        Test.stopTest();
    }

     @isTest static void UpdateEntries_NotApprovedIdExistInDB_ReturnUpdatedList() {
        Id expectExpenseId = TestDataFactory.getExpenseEntryId(false);

        String expectExpenseDate = TestDataFactory.DATE_END;
        String expectSubmittalDate = TestDataFactory.DATE_END;
        String expectAmount = '100';
        String expectInvoicedAmount = '200';
        String expectDescription = 'new description';
        String expectType = 'Airfare';
        String expectBillable = 'true';
        String expectIsApproved = 'true';

        List<Map<String, String>> expenseEntries = new List<Map<String, String>>{
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

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntries');
        request.Parameters.put('list', expenseEntries);//TODO:convert List<Map<String, String>> to List<Map<String, Object>>

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Expense_Entry__c> resultListItems = (List<Expense_Entry__c>)response.Parameters.get('list');
        Expense_Entry__c resultItem = resultListItems[0];
        System.debug('@@@ UpdateEntries_NotApprovedIdExistInDB_ReturnUpdatedList:result: ' + resultListItems);

        System.assertEquals(expectExpenseId, resultItem.Id);
        System.assertEquals(Date.valueOf(expectExpenseDate), resultItem.Date__c);
        System.assertEquals(Date.valueOf(expectSubmittalDate), resultItem.Submittal_Date__c);
        System.assertEquals(Decimal.valueOf(expectAmount), resultItem.Amount__c);
        System.assertEquals(Decimal.valueOf(expectInvoicedAmount), resultItem.Invoiced_Amount__c);
        System.assertEquals(expectDescription, resultItem.Description__c);
        System.assertEquals(expectType, resultItem.Type__c);
        System.assertEquals(Boolean.valueOf(expectBillable), resultItem.Is_Billable__c);
        System.assertNotEquals(null, resultItem.InternalApproval__c);

        Test.stopTest();
    }

    @isTest static void UpdateEntries_ApprovedIdExistInDB_ReturnNoAccessError() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        String expectExpenseId = TestDataFactory.getExpenseEntryId(true);
        String expectExpenseDate = TestDataFactory.DATE_END;
        String expectSubmittalDate = TestDataFactory.DATE_END;
        String expectAmount = '100';
        String expectInvoicedAmount = '200';
        String expectDescription = 'new description';
        String expectType = 'Airfare';
        String expectBillable = 'true';
        String expectIsApproved = 'true';

        List<Map<String, String>> expenseEntries = new List<Map<String, String>>{
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

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntries');
        request.Parameters.put('list', expenseEntries);

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            List<Expense_Entry__c> resultListItems = (List<Expense_Entry__c>)response.Parameters.get('list');
            Expense_Entry__c resultItem = resultListItems[0];
            System.debug('@@@ UpdateEntries_ApprovedIdExistInDB_ReturnNoAccessError:result: ' + resultItem);   
        } catch (Exception ex) {
            System.debug('@@@ UpdateEntries_ApprovedIdExistInDB_ReturnNoAccessError:result: ' + ex);   
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void UpdateEntries_WithoutParams_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;
       
        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntries');

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Expense_Entry__c> resultListItems = (List<Expense_Entry__c>)response.Parameters.get('list');
        System.debug('@@@ UpdateEntries_WithoutParams_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void UpdateEntries_IdNotExistInDB_ReturnEmptyList() {
        Integer expectSizeEmptyList = 0;

        String expectExpenseId = TestDataFactory.getNotExistId();
        String expectExpenseDate = TestDataFactory.DATE_END;
        String expectSubmittalDate = TestDataFactory.DATE_END;
        String expectAmount = '100';
        String expectInvoicedAmount = '200';
        String expectDescription = 'new description';
        String expectType = 'Airfare';
        String expectBillable = 'true';
        String expectIsApproved = 'true';

        List<Map<String, String>> expenseEntries = new List<Map<String, String>>{
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

        service_Request request = new service_Request();
        request.Parameters.put('action', 'updateEntries');
        request.Parameters.put('list', expenseEntries);

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        List<Expense_Entry__c> resultListItems = (List<Expense_Entry__c>)response.Parameters.get('list');
        System.debug('@@@ UpdateEntries_IdNotExistInDB_ReturnEmptyList:result: ' + resultListItems);

        System.assertEquals(expectSizeEmptyList, resultListItems.size());

        Test.stopTest();
    }

    @isTest static void DeleteEntry_EntryIdNotApprovedExistInDB_ReturnStatusSuccess() {
        String expectStatus = 'success';

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('entryId', TestDataFactory.getExpenseEntryId(false));

        service_Response response = new service_Response();

        Test.startTest();

        service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
        serviceExpenseEntry.process(request, response);
        String resultStatus = (String)response.Parameters.get('status');
        System.debug('@@@ DeleteEntry_EntryIdNotApprovedExistInDB_ReturnStatusSuccess:result: ' + resultStatus);

        System.assertEquals(expectStatus, resultStatus);

        Test.stopTest();
    }

    @isTest static void DeleteEntry_EntryIdApprovedInDB_ReturnErrorNoAccess() {
        String expectedExceptionThrown = 'System.NoAccessException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('entryId', TestDataFactory.getExpenseEntryId(true));

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');  
            System.debug('@@@ DeleteEntry_EntryIdApprovedInDB_ReturnErrorNoAccess:result: ' + resultStatus);                         
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_EntryIdApprovedInDB_ReturnErrorNoAccess:result: ' + ex);      
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }

    @isTest static void DeleteEntry_EntryIdNotExistInDB_ReturnErrorNotFound() {
        String expectedExceptionThrown = 'System.NoDataFoundException';
        Boolean expectedExceptionMessage = true;

        service_Request request = new service_Request();
        request.Parameters.put('action', 'deleteEntry');
        request.Parameters.put('entryId', TestDataFactory.getNotExistId());

        service_Response response = new service_Response();

        Test.startTest();

        try {
            service_ExpenseEntry serviceExpenseEntry = new service_ExpenseEntry();
            serviceExpenseEntry.process(request, response);
            String resultStatus = (String)response.Parameters.get('status');   
            System.debug('@@@ DeleteEntry_EntryIdNotExistInDB_ReturnErrorNotFound:result: ' + resultStatus);                       
        } catch (Exception ex) {
            System.debug('@@@ DeleteEntry_EntryIdNotExistInDB_ReturnErrorNotFound:result: ' + ex);      
            System.assertEquals(expectedExceptionThrown, ex.getTypeName());
            System.assertEquals(expectedExceptionMessage, String.isNotBlank(ex.getMessage()));
        }

        Test.stopTest();
    }
}