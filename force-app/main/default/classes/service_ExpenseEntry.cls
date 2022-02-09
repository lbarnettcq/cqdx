/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_ExpenseEntry extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getTypes' {
                getTypes(request, response);
            }
            when 'getList' {
                getList(request, response);
            }
            when 'insertEntry' {
                insertEntry(request, response);
            }
            when 'updateEntries' {
                updateEntries(request, response);
            }
            when 'deleteEntry' {
                deleteEntry(request, response);
            }
        }
    } 

    public void getTypes(service_Request request, service_Response response) {//TODO: extract to dao exoense entry
        List<Map<String, String>> types = new List<Map<String, String>>();

        Schema.DescribeFieldResult fieldResult = Expense_Entry__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry pe : ple) {
            Map<String, String> type = new Map<String, String> {
                'id' => pe.getValue(),
                'label' => pe.getLabel()
            };   
             
            types.add(type);
        }     

        response.Parameters.put('list', types);
    }

    //TODO:TESTS: review unit tests after update functionality
    //TODO:CRITICAL:Replace for queries and add limits with offset
    public void getList(service_Request request, service_Response response) {
        String timesheetId = (String)request.Parameters.get('timesheetId');
        String paymentId = (String)request.Parameters.get('paymentId');
        String invoiceId = (String)request.Parameters.get('invoiceId');
        Boolean approved = (Boolean)request.Parameters.get('approved');//TODO: review if use

        List<Expense_Entry__c> listExpenseEntries = new List<Expense_Entry__c>();

        if(invoiceId != null) {
            listExpenseEntries = getListByInvoice(invoiceId, true, true);
        } else if(timesheetId != null) {
            listExpenseEntries = getListByTimesheet(timesheetId);
        } else if(paymentId != null) {
            listExpenseEntries = getListByPayment(paymentId);
        } else {
            List<String> contractsIds = (List<String>)request.Parameters.get('contractsIds');
            String employeeId = (String)request.Parameters.get('employeeId');
            Date startDate = (Date)request.Parameters.get('startDate');
            Date endDate = (Date)request.Parameters.get('endDate');
            listExpenseEntries = getListByContractResources(contractsIds, employeeId, startDate, endDate);
        }       

        List<Map<String, Object>> expenseEntries = new List<Map<String, Object>>(); 

        if(!listExpenseEntries.isEmpty()) {
            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            
            dao_User daoUser = new dao_User();
            List<User> users = daoUser.findAll();

            Map<String, String> mapUsers = new Map<String,String>();
            for(User user : users) {
                mapUsers.put(user.Id, user.Name);
            }
            
            dao_ContractResource daoContractResource = new dao_ContractResource();
            List<Contract_Resource__c> contractResources = daoContractResource.findAll();//TODO: add contractsIds and employee:filter

            Map<Id, Contract_Resource__c> mapContractResources = new Map<Id, Contract_Resource__c>();
            for(Contract_Resource__c contractResource : contractResources) {
                mapContractResources.put(contractResource.Id, contractResource);
            }

            dao_Contract daoContract = new dao_Contract();
            List<Contract> contracts = daoContract.findAll();//TODO: add contract to contract resource(relation)

            Map<Id, Contract> mapContracts = new Map<Id, Contract>();
            for(Contract cntr : contracts) {
                mapContracts.put(cntr.Id, cntr);
            }

            Set<String> expensesIds = new Set<String>();

            for(Expense_Entry__c entry : listExpenseEntries) {
                Contract_Resource__c contractResource = mapContractResources.get(entry.Contract_Resource__c);
            
                if(contractResource != null) {
                    Contract contractInfo = mapContracts.get(contractResource.Contract__c);

                    if(contractInfo != null) {
                        expensesIds.add(entry.Id);

                        Map<String, Object> item = new Map<String, Object> {
                            'id' => entry.Id, 
                            'amount' => entry.Amount__c,
                            'invoicedAmount' => entry.Invoiced_Amount__c,
                            'approvedDate' => entry.InternalApproval__c,
                            'approvedBy' => entry.InternalApprovalBy__c,
                            'approved' => entry.Is_Approved__c,
                            'contractResource' => entry.Contract_Resource__c,
                            'date' => entry.Date__c,
                            'submittalDate' => entry.Submittal_Date__c,
                            'description' => entry.Description__c,
                            'name' => entry.Name,
                            'billable' => entry.Is_Billable__c,
                            'type' => entry.Type__c,                 
                            'accountName' => contractInfo.Account.Name,
                            'accountId' => contractInfo.Account.Id,
                            'contractId' => contractInfo.Id,
                            'contractNumber' => contractInfo.ContractNumber,
                            'userId' => contractResource.Employee__c,
                            'userName' => mapUsers.get(contractResource.Employee__c)
                        };   

                        expenseEntries.add(item);
                    }
                }                
            } 

            if(!expensesIds.isEmpty()) {
                dao_ContentDocumentLink daoContentDocumentLink = new dao_ContentDocumentLink();
                List<ContentDocumentLink> contentDocuments = daoContentDocumentLink.findAllByParams(expensesIds);

                Map<Id, ContentDocumentLink> mapDocuments = new Map<Id, ContentDocumentLink>();
                for(ContentDocumentLink contentDocument : contentDocuments) {
                    mapDocuments.put(contentDocument.LinkedEntityId, contentDocument);
                }

                for(Map<String, Object> expenseEntry : expenseEntries) {
                    expenseEntry.put('haveAttachments', mapDocuments.containsKey((String)expenseEntry.get('id')));
                }
            }
        }

        response.Parameters.put('list', expenseEntries); 
    }

    public void insertEntry(service_Request request, service_Response response) {
        String contractId = (String)request.Parameters.get('contractId');
        Date expenseDate = (Date)request.Parameters.get('expenseDate');
        Date submittalDate = (Date)request.Parameters.get('submittalDate');
        Decimal amount = (Decimal)request.Parameters.get('amount');
        Decimal invoicedAmount = (Decimal)request.Parameters.get('invoicedAmount');
        String description = (String)request.Parameters.get('description');
        Boolean billable = Boolean.valueOf(request.Parameters.get('billable'));
        String type = (String)request.Parameters.get('type');
        String timesheetId = (String)request.Parameters.get('timesheetId');
        String employeeId = (String)request.Parameters.get('employeeId');

        String contractResourceId = null;
        
        Expense_Entry__c expenseEntry = new Expense_Entry__c();

        if(String.isNotBlank(timesheetId)) {
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

            if(timesheet == null) {
                generateNoDataFoundError('Timesheet ' + timesheetId + ' not found');
            }
 
            if(!(submittalDate >= timesheet.StartDate__c && submittalDate <= timesheet.EndDate__c)) {
                generateNoAccessError('This Submittal Date is not in the Time Period of this Timesheet');
            }

            if(timesheet.Status__c != 'New') {
                generateNoAccessError('You can not add expense to timesheet with status ' + timesheet.Status__c);
            }  

            employeeId = timesheet.Contract_Resource__r.Employee__c;
            contractResourceId = timesheet.Contract_Resource__c; 
        } else {
            if(String.isBlank(employeeId)) {
                employeeId = UserInfo.getUserId();
            }

            contractResourceId = getContractResource(contractId, employeeId);

            if(contractResourceId == null) {
                generateNoDataFoundError('Contract Resource not found for contract ' + contractId + ' and employee ' + employeeId);
            }

            Boolean isTseApproved = isTseApproved(contractResourceId, submittalDate);

            if(isTseApproved) {//TODO:add unit test for this case
                generateNoAccessError('You are trying to add expense for already approved date. Please contact your manager.');
            }
            
        }

        Map<String, Object> timesheetInfo = timesheetInfo(contractResourceId, submittalDate);//TODO: add unit test for submittalDate

        if(timesheetInfo.get('timesheetId') != null) {
            if((String)timesheetInfo.get('timesheetStatus') != 'New') {//add unit test for this case
                generateNoAccessError('This date is included into timesheet already sent to the client. Please select another Submittal Date.');
            } else {
                expenseEntry.TimesheetId__c = (String)timesheetInfo.get('timesheetId');
            }
        }

        expenseEntry.Contract_Resource__c = contractResourceId;
        expenseEntry.Date__c = expenseDate;//TODO: add check expenseDate = null
        expenseEntry.Submittal_Date__c = submittalDate;
        expenseEntry.Is_Billable__c = billable;
        expenseEntry.Type__c = type;//TODO: add check if exist type and unit tests for this case
        expenseEntry.Amount__c = amount;
        expenseEntry.Invoiced_Amount__c = invoicedAmount;
        
        if(String.isNotBlank(description)) {
            expenseEntry.Description__c = description;
        }

        insert expenseEntry; 

        response.Parameters.put('item', expenseEntry); 
    }

    //TODO: Absent consistency for response list of expenses(structure data with name fields)
    public void updateEntries(service_Request request, service_Response response) { 
        List<Map<String, String>> data = (List<Map<String, String>>)request.Parameters.get('list');
        List<Expense_Entry__c> expenseEntries = new List<Expense_Entry__c>();

        if(data != null) {
            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();

            for(Map<String, String> obj : data) {
                String id = obj.get('id');
                Expense_Entry__c  expenseEntry = daoExpenseEntry.findOne(id);

                if(expenseEntry != null) {
                    if(expenseEntry.Is_Approved__c == true) {
                        generateNoAccessError('Can not edit approved expenses'); 
                    }   

                    if(obj.containsKey('contractId')) {
                        String employeeId = null;

                        if(obj.containsKey('employeeId')) {
                            employeeId = (String) obj.get('employeeId');
                        } else {
                            employeeId = UserInfo.getUserId(); 
                        }
                      
                        String contractId = (String)obj.get('contractId');
                        expenseEntry.Contract_Resource__c = getContractResource(contractId, employeeId);
                    }

                    if(obj.containsKey('submittalDate')) {
                        Date submittalDate = Date.valueOf(obj.get('submittalDate'));

                        Map<String, Object> timesheetInfo = timesheetInfo(expenseEntry.Contract_Resource__c, submittalDate);//TODO: add unit test for submittalDate

                        if(timesheetInfo.get('timesheetId') != null) {
                            if((String)timesheetInfo.get('timesheetStatus') != 'New') {//add unit test for this case
                                generateNoAccessError('This date is included into timesheet already sent to the client. Please select another Submittal Date.');
                            } else {
                                expenseEntry.TimesheetId__c = (String)timesheetInfo.get('timesheetId');
                            }
                        }

                        if(!obj.containsKey('timesheetId')) {
                            Boolean isTseApproved = isTseApproved(expenseEntry.Contract_Resource__c, submittalDate);

                            if(isTseApproved) {//add unit test for this case
                                generateNoAccessError('You are trying to add expense for already approved date. Please contact your manager.');
                            }
                        }    

                        expenseEntry.Submittal_Date__c = submittalDate;
                    }

                    if(obj.containsKey('expenseDate')) {
                        expenseEntry.Date__c = Date.valueOf(obj.get('expenseDate'));
                    }

                    if(obj.containsKey('amount')) {
                        expenseEntry.Amount__c = Decimal.valueOf(obj.get('amount'));
                    }

                    if(obj.containsKey('invoicedAmount')) {
                        expenseEntry.Invoiced_Amount__c = Decimal.valueOf(obj.get('invoicedAmount'));
                    }

                    if(obj.containsKey('description')) {
                        expenseEntry.Description__c = obj.get('description');
                    }

                    if(obj.containsKey('type')) {
                        expenseEntry.Type__c = obj.get('type');
                    }

                    if(obj.containsKey('billable')) {
                        expenseEntry.Is_Billable__c = Boolean.valueOf(obj.get('billable'));
                    }

                    if(obj.containsKey('isApproved')) {
                        Boolean approved = Boolean.valueOf(obj.get('isApproved'));

                        expenseEntry.Is_Approved__c = approved;

                        if(approved) {
                            expenseEntry.InternalApproval__c = DateTime.now(); 
                            expenseEntry.InternalApprovalBy__c = UserInfo.getUserId();
                        } else {
                            expenseEntry.InternalApproval__c = null;
                            expenseEntry.InternalApprovalBy__c = null;
                        }
                    }

                    expenseEntries.add(expenseEntry);
                }
            }

            update expenseEntries;
        }

        response.Parameters.put('list', expenseEntries);
    }

    public void deleteEntry(service_Request request, service_Response response) {
        String entryId = (String)request.Parameters.get('entryId');

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        Expense_Entry__c expenseEntry = daoExpenseEntry.findOne(entryId);

        if(expenseEntry == null) {//system error when find record with not exist id
            generateNoDataFoundError('Expense entry ' + entryId + ' not found');
        }
        
        if(expenseEntry.Is_Approved__c == true) {
            generateNoAccessError('Can not delete approved expenses'); 
        } 

        delete expenseEntry;
 
        response.Parameters.put('status', 'success');
    }

    //TODO: PACKAGE: move to payment
    //TODO: move get payment to payment service and create general method for get expenses
    private List<Expense_Entry__c> getListByPayment(String paymentId) {
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getInformation');
        request.Parameters.put('paymentId', paymentId);
        service_Response response = service_Controller.process(Services.Payments, request);

        Map<String, Object> payment = null;

        if(response.Errors.size() == 0 ) {
            payment = (Map<String, Object>)response.Parameters.get('item');
        } else {
            generateNoDataFoundError('Payment ' + paymentId + ' not found');
        }
        
        String receiverId = (String)payment.get('receiverId');
        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> listContractResources = daoContractResource.findAllByUser(receiverId);

        if(listContractResources.isEmpty()) {
            generateNoDataFoundError('Contract Resources not found');
        }

        Set<String> listContractResourcesIds = new Set<String>();

        for(Contract_Resource__c contractResource : listContractResources) {
            listContractResourcesIds.add(contractResource.Id);
        }

        List<Expense_Entry__c> listExpenseEntries = null;

        if(!listContractResourcesIds.isEmpty()) {
            Map<String, Object> conditions = new Map<String, Object>();
            conditions.put('listContractResourcesIds', listContractResourcesIds);
            conditions.put('startDate', (Date)payment.get('startDate'));
            conditions.put('endDate', (Date)payment.get('endDate'));
            conditions.put('fieldDate', 'date');

            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            listExpenseEntries = daoExpenseEntry.findAll(conditions);
        } else {
            listExpenseEntries = new List<Expense_Entry__c>();
        }

        return listExpenseEntries;
    }

    //TODO: PACKAGE: move to invoice
    private List<Expense_Entry__c> getListByInvoice(String invoiceId, Boolean biliabled , Boolean approved) {
        service_Request request = new service_Request();
        request.Parameters.put('action', 'getListItems');
        request.Parameters.put('invoiceId', invoiceId);
        service_Response response = service_Controller.process(Services.Invoices, request);

        List<Map<String, Object>> invoiceLineItems = new List<Map<String, Object>>();

        if(response.Errors.size() == 0) {
            invoiceLineItems = (List<Map<String, Object>>)response.Parameters.get('list');
        } else {
            generateNoDataFoundError('Invoice ' + invoiceId + ' not found');
        }

        Map<String, Object> conditions = new Map<String, Object>();
        Set<String> listContractResourcesIds = new Set<String>();
        Set<String> timesheetIds = new Set<String>();

        for(Map<String, Object> invoiceLineItem : invoiceLineItems) {
            timesheetIds.add((String)invoiceLineItem.get('timesheetId'));
        }   

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> listExpenseEntries = daoExpenseEntry.findByTimesheets(timesheetIds);

        return listExpenseEntries;
    }

    private List<Expense_Entry__c> getListByTimesheet(String timesheetId) {
        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet == null) {
            generateNoDataFoundError(timesheetId + ' timesheet not found');
        }

        Set<String> timesheetIds =  new Set<String>{timesheetId};

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> listExpenseEntries = daoExpenseEntry.findByTimesheets(timesheetIds);

        return listExpenseEntries;
    }

    private List<Expense_Entry__c> getListByContractResources(List<String> contractsIds, String employeeId, Date startDate, Date endDate) { 
        Set<String> contractResourcesIds = new Set<String>();

        if(contractsIds != null) {
            dao_ContractResource daoContractResource = new dao_ContractResource();
            List<Contract_Resource__c> contractResources = daoContractResource.findAllByParams(new Set<String>(contractsIds), employeeId);

            for(Contract_Resource__c contractResource : contractResources) {
                contractResourcesIds.add(contractResource.Id);
            }
        }

        Map<String, Object> conditions = new Map<String, Object>();
        conditions.put('listContractResourcesIds', contractResourcesIds);
        conditions.put('startDate', startDate);
        conditions.put('endDate', endDate); 
        conditions.put('employeeId', employeeId);

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> listExpenseEntries = daoExpenseEntry.findByDates(conditions);

        return listExpenseEntries;
    }

    private String getContractResource(String contractId, String employeeId) {
        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c contractResource = daoContractResource.findOne(contractId, employeeId);

        if(contractResource == null) {
            generateNoDataFoundError('contract resource not found');
        }

        return (String)contractResource.Id;
    }

    //TODO: replace timesheetStatus => status and timesheetId => id
    private Map<String, Object> timesheetInfo(String contractResourceId, Date submittalDate) {
        Map<String, Object> result = new Map<String, Object> {
            'timesheetStatus' => null,
            'timesheetId' => null
        };

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> timesheets = daoTimesheet.findAllByContractResources(new Set<String>{contractResourceId});

        for(Timesheet__c timesheet : timesheets) {
            if(submittalDate >= timesheet.startDate__c && submittalDate <= timesheet.endDate__c) {
                if(timesheet.Status__c == 'New') {
                    result.put('timesheetStatus', timesheet.Status__c);
                    result.put('timesheetId', timesheet.Id);
                }

                return result;  
            }
        }

        return result;
    }

    //TODO:replace
    private Boolean isTseApproved(String contractResourceId, Date submittalDate) {
        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> listTimesheetEntries = daoTimesheetEntry.findByContractResources(new Set<String> {contractResourceId}, new Set<Date> {submittalDate});

        if(listTimesheetEntries.isEmpty()) {
            return false;
        }

        return true;
    }

    //TODO: extract to helper error
    private void generateNoDataFoundError(String message) {
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }

    //TODO: extract to helper error
    private void generateNoAccessError(String message) {
        NoAccessException ex = new NoAccessException();
        ex.setMessage(message);
        throw ex; 
    }
}