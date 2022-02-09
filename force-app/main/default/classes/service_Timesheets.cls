/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Timesheets extends service_Base {
    public static final String STATUS_PENDING = 'Pending';

    Map<String,String> changeStatus = new Map<String, String> {
        'New' => STATUS_PENDING,
        STATUS_PENDING => 'Approved',
        'Approved' => 'Invoiced',
        'Invoiced' => 'Paid'
    };

    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
            when 'getTotalCount' {
                getTotalCount(request, response);
            }
            when 'getInformation' {
                getInformation(request, response);
            }
            when 'insertEntry' {
                insertEntry(request, response);
            }
            when 'updateEntry' {
                updateEntry(request, response);
            }
            when 'deleteEntry' {
                deleteEntry(request, response);
            }  
            when 'updateStatus' {
                updateStatus(request, response);
            }
            when 'refresh' {
                refresh(request, response);
            }           
        }
    }

    public void getList(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');
        Integer offset = (Integer)request.Parameters.get('offset');

        List<TimesheetEntryWrapper> timesheets = new List<TimesheetEntryWrapper>();

        timesheets = getTimesheets();
        timesheets.sort();

        response.Parameters.put('list', filter(timesheets, limits, offset));
    }

    public void getTotalCount(service_Request request, service_Response response) {
        List<TimesheetEntryWrapper> listTimesheets = getTimesheets();
        response.Parameters.put('count', listTimesheets.size());
    }

    public void getInformation(service_Request request, service_Response response) {
        String timesheetId = String.valueof(request.Parameters.get('timesheetId'));

        Map<String, Object> timesheetInfo = new Map<String, Object>();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet != null) {
            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            Map<String,Object> timesheetEntriesData  = daoTimesheetEntry.getTotalTime(timesheetId); 

            String totalMinutes = '0';

            if(timesheetEntriesData != null) {
                totalMinutes = (String)timesheetEntriesData.get('totalMinutes');
            }

            dao_User daoUser = new dao_User();
            String userId = timesheet.Contract_Resource__r.Employee__c;
            User userName = daoUser.findOne(userId);

            String contractResourceId = timesheet.Contract_Resource__c;   
            Set<String> listContractResources = new Set<String>{contractResourceId};

            Map<String,Object> conditions = new Map<String,Object>{
                'startDate' => timesheet.startDate__c,
                'endDate' => timesheet.endDate__c,
                'listContractResources' => listContractResources,
                'isBilliable' => true, 
                'isApproved' => true
            };

            Decimal totalExpences = 0;

            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            List<AggregateResult> listAggregateExpenses = daoExpenseEntry.getTotalAmount(conditions);

            if(!listAggregateExpenses.isEmpty()) {
                totalExpences = (Decimal)listAggregateExpenses[0].get('amount');
            }

            dao_Contract daoContract = new dao_Contract();
            Contract contractInfo = daoContract.findOneByContractResource(contractResourceId);

            String contactName = null;
            dao_Contact daoContact = new dao_Contact();
            Contact contactInfo = daoContact.findOne(contractInfo.Client_Manager__c);

            if(contactInfo != null) {
                contactName = contactInfo.Name;
            }

            Map<String, Object> params = new Map<String, Object> {
                'employeeId' => userId,
                'contractResourceId' => contractResourceId,
                'startDate' => timesheet.StartDate__c,
                'endDate' => timesheet.EndDate__c
            };

            List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findAll(params);

            //TODO:Grouping by properties
            timesheetInfo = new Map<String,Object> {
                'timesheetId' => timesheetId,
                'timesheetNumber' => timesheet.Name,
                'lastModifiedDate'=> timesheet.LastModifiedDate__c,
                'status' => timesheet.Status__c,
                'accountId' => contractInfo.Account.Id,
                'accountName' => contractInfo.Account.Name,
                'contractId' => contractInfo.Id,
                'contractResourceId' => contractResourceId,
                'contractName' => contractInfo.ContractNumber,
                'userId' => userId,
                'userName' => userName.Name,
                'contactName' => contactName,
                'startDate' => timesheet.startDate__c,
                'endDate' => timesheet.endDate__c,
                'totalMinutes' => totalMinutes,
                'totalExpences' => totalExpences,
                'approvedEntries' => approvedEntries(timesheetEntries)
            };
        }

        response.Parameters.put('item', timesheetInfo);
    }

    public void insertEntry(service_Request request, service_Response response) {
        String employeeId = String.valueof(request.Parameters.get('userId'));
        Date startDate = Date.valueof(request.Parameters.get('startDate'));
        Date endDate = Date.valueof(request.Parameters.get('endDate'));
        String contractId = String.valueof(request.Parameters.get('contractId'));

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c contractResource = daoContractResource.findOne(contractId, employeeId);

        if(contractResource == null) {
            generateNoDataFoundError('Contract Resource not found');
        }
        
        Map<String, Object> conditions = new Map<String, Object> {
            'employeeId' => employeeId,
            'contractResourceId' => contractResource.Id,
            'startDate' => startDate,
            'endDate' => endDate
        };

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_entry__c> listTimesheetEntries = daoTimesheetEntry.findAll(conditions);

        conditions = new Map<String, Object> {
            'billiable' => true,
            'listContractResourcesIds' => new Set<String>{contractResource.Id},
            'startDate' => startDate,
            'endDate' => endDate
        };

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> listExpenseEntries = daoExpenseEntry.findAll(conditions);

        Boolean existTimesheet = false;

        if(listTimesheetEntries.size() > 0) {
            for(Timesheet_entry__c entry : listTimesheetEntries) {
                if(entry.TimesheetId__c != null) {
                    existTimesheet = true;
                    break;
                }
            }
        }    

        if(!existTimesheet) {
            Timesheet__c timesheet = new Timesheet__c();
            timesheet.OwnerId = UserInfo.getUserId();
            timesheet.StartDate__c = StartDate;
            timesheet.EndDate__c = EndDate;
            timesheet.CreatedDate__c = Datetime.now();
            timesheet.LastModifiedDate__c = Datetime.now();
            timesheet.Contract_Resource__c = contractResource.Id;

            insert timesheet;

            List<Timesheet_entry__c> listTimesheetEntriesToUpdate = new List<Timesheet_entry__c>();
            for(Timesheet_entry__c timesheetEntry : listTimesheetEntries) {
                timesheetEntry.TimesheetId__c = timesheet.id;
                listTimesheetEntriesToUpdate.add(timesheetEntry);
            }

            update listTimesheetEntriesToUpdate;

            List<Expense_Entry__c> listExpenseEntriesToUpdate = new List<Expense_Entry__c>();
            for(Expense_Entry__c expenseEntry : listExpenseEntries) {
                expenseEntry.TimesheetId__c = timesheet.id;
                listExpenseEntriesToUpdate.add(expenseEntry);
            }
       
            update listExpenseEntriesToUpdate;
      
            response.Parameters.put('item', timesheet);
        } else {
            generateError('You already have timesheets for these dates');
        }

    }

    public void updateEntry(service_Request request, service_Response response) {
        String timesheetId = (String)request.Parameters.get('timesheetId');

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet == null) {
            generateNoDataFoundError('Timesheet ' + timesheetId + ' not found');
        }

        String employeeId = (String)request.Parameters.get('userId');
        String contractId = (String)request.Parameters.get('contractId');

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c contractResource = daoContractResource.findOne(contractId, employeeId);

        if(contractResource == null) {
            generateNoDataFoundError('Contract Resource not found for contract ' + contractId + ' and employee ' + employeeId);
        }
   
        timesheet.Contract_Resource__c = contractResource.Id;

        if(request.Parameters.get('startDate') != null) {
            timesheet.StartDate__c = Date.valueof(request.Parameters.get('startDate'));
        }

        if(request.Parameters.get('endDate') != null) {
            timesheet.EndDate__c = Date.valueof(request.Parameters.get('endDate'));
        }
       
        timesheet.LastModifiedDate__c = Datetime.now();

        Map<String, Object> conditions = new Map<String, Object> {
            'employeeId' => employeeId,
            'contractResourceId' => contractResource.Id,
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c
        };

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> listTimesheetEntries = daoTimesheetEntry.findAll(conditions);

        for(Timesheet_entry__c entry : listTimesheetEntries) {
            if(entry.TimesheetId__c != timesheetId && entry.TimesheetId__c != null) {
                generateError('You already have timesheets for these dates');
            }            
        }

        List<Timesheet_Entry__c> listTimesheetEntriesWithTimesheet = daoTimesheetEntry.findByTimesheet(timesheetId);

        List<Timesheet_Entry__c> deleteListTimesheetEntries = new List<Timesheet_Entry__c>();
        List<Timesheet_Entry__c> updateListTimesheetEntries = new List<Timesheet_Entry__c>();
        
        for(Timesheet_entry__c timesheetsEntry :listTimesheetEntriesWithTimesheet) {
            timesheetsEntry.TimesheetId__c = null;
            deleteListTimesheetEntries.add(timesheetsEntry);
        }

        update deleteListTimesheetEntries;

        for(Timesheet_entry__c tsEntry : listTimesheetEntries) {
            tsEntry.TimesheetId__c = timesheet.id;
            updateListTimesheetEntries.add(tsEntry);
        }

        update updateListTimesheetEntries;


        conditions = new Map<String, Object> {
            'billiable' => true,
            'listContractResourcesIds' => new Set<String>{contractResource.Id},
            'startDate' => timesheet.StartDate__c,
            'endDate' => timesheet.EndDate__c
        };

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<Expense_Entry__c> listExpenseEntries = daoExpenseEntry.findAll(conditions);
        List<Expense_Entry__c> listExpenseEntriesWithTimesheet =  daoExpenseEntry.findByTimesheets(new Set<String>{timesheetId});

        List<Expense_Entry__c> deleteListExpenseEntries = new List<Expense_Entry__c>();
        List<Expense_Entry__c> updateListExpenseEntries = new List<Expense_Entry__c>();
        
        for(Expense_Entry__c expenseEntry : listExpenseEntriesWithTimesheet) {
            expenseEntry.TimesheetId__c = null;
            deleteListExpenseEntries.add(expenseEntry);
        }

        update deleteListExpenseEntries;

        for(Expense_Entry__c expenseEntry : listExpenseEntries) {
            expenseEntry.TimesheetId__c = timesheet.id;
            updateListExpenseEntries.add(expenseEntry);
        }

        update updateListExpenseEntries;

        update timesheet;

        response.Parameters.put('item', timesheet); 
    }

    public void deleteEntry(service_Request request, service_Response response) {        
        String timesheetId = String.valueof(request.Parameters.get('timesheetId'));

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet == null) {
             generateNoDataFoundError('Timesheet ' + timesheetId + ' not found');
        }

        if(timesheet.Status__c == 'Approved') {
            generateNoAccessError('Can not delete approved timesheet ' + timesheetId);
        }

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> timesheetEntryList = daoTimesheetEntry.findByTimesheet(timesheetId);
        List<Timesheet_Entry__c> updateTimesheetEntryList  = new List<Timesheet_Entry__c>();

        for(Timesheet_Entry__c tsEntry : timesheetEntryList) {
            tsEntry.TimesheetId__c = null;
            updateTimesheetEntryList.add(tsEntry);
        }

        update updateTimesheetEntryList;

        delete timesheet;

        response.Parameters.put('status', AppConfig.STATUS.get('success'));
    }

    public void updateStatus(service_Request request, service_Response response) {//TODO:review code        
        String timesheetId = String.valueof(request.Parameters.get('timesheetId'));

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet == null) {
            generateNoDataFoundError('Timesheet ' + timesheetId + ' not found');
        }

        String status = getStatus(timesheet.Status__c);

        if(status != null) {
            switch on status {
                when 'Pending' {
                    dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
                    List<Timesheet_Entry__c> listTimesheetEntries = daoTimesheetEntry.findByTimesheet(timesheetId);

                    if(listTimesheetEntries != null && !listTimesheetEntries.isEmpty()) {
                        List<Timesheet_Entry__c> listToUpdateTimesheetEntries = new List<Timesheet_Entry__c>();
                        for(Timesheet_Entry__c entry : listTimesheetEntries) {
                            entry.Is_Approved__c = true;
                            entry.InternalApproval__c = Datetime.now();
                            entry.InternalApprovalBy__c = UserInfo.getUserId();

                            listToUpdateTimesheetEntries.add(entry);
                        }

                        update listToUpdateTimesheetEntries;
                    }

                    dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
                    List<Expense_Entry__c> listExpenses = daoExpenseEntry.findByTimesheets(new Set<String>{timesheetId});

                    if(!listExpenses.isEmpty()) {
                        List<Expense_Entry__c> listExpensesToUpdate = new List<Expense_Entry__c>();
                        for(Expense_Entry__c expense : listExpenses) {
                            expense.Is_Approved__c = true;
                            expense.InternalApproval__c = DateTime.now();
                            expense.InternalApprovalBy__c = UserInfo.getUserId();

                            listExpensesToUpdate.add(expense);                    
                        }

                        update listExpensesToUpdate;
                    }  

                    //sendEmail(timesheetId);            
                }
                when 'Approved' {
                    timesheet.Approved__c = DateTime.now();
                    timesheet.ApprovedBy__c = timesheet.Contract_Resource__r.Contract__r.Client_Manager__c;
                }      
            }

            timesheet.Status__c = status;

            update timesheet;
        }
        
        response.Parameters.put('item', timesheet);//TODO:return status: success or error(when we can not update)
    }

    //TODO:UNIT TESTS: ADD UNIT TESTS
    public void refresh(service_Request request, service_Response response) {
        List<Timesheet_Entry__c> newTimesheetEntries = (List<Timesheet_Entry__c>)request.Parameters.get('newTimesheetEntries');
        List<Timesheet_Entry__c> oldTimesheetEntries = (List<Timesheet_Entry__c>)request.Parameters.get('oldTimesheetEntries');
        Map<Id, Timesheet_Entry__c> mapOldTimesheetEntries = new Map<Id, Timesheet_Entry__c>();

        if(oldTimesheetEntries == null) {
            oldTimesheetEntries = new List<Timesheet_Entry__c>();
        }

        for(Timesheet_Entry__c te : oldTimesheetEntries) {
            mapOldTimesheetEntries.put(te.Id, te);
        }
        
        System.debug('@@@ DEBUG TIMESHEETS REFRESH : newTimesheetEntries:' + newTimesheetEntries);
        System.debug('@@@ DEBUG TIMESHEETS REFRESH : oldTimesheetEntries:' + oldTimesheetEntries);

        List<Timesheet__c> timesheetsStatusNew = new List<Timesheet__c>();
        List<Timesheet_Entry__c> updateTimesheetsEntries = new List<Timesheet_Entry__c>();

        Set<Id> excludeTimesheetsIds = new Set<Id>();

        Map<Id, List<Timesheet_Entry__c>> mapTimesheetEntries = new Map<Id, List<Timesheet_Entry__c>>();
        Set<Id> timesheetsIds = new Set<Id>();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> timesheets = daoTimesheet.findAll();
        Map<Id, Timesheet__c> mapTimesheets = new Map<Id, Timesheet__c>();

        for(Timesheet__c ts : timesheets) {
            mapTimesheets.put(ts.Id, ts);
        }

        for(Timesheet_Entry__c newTimesheetEntry : newTimesheetEntries) {
            if(newTimesheetEntry.TimesheetId__c == null) {
                for(Timesheet__c ts : timesheets) {
                    if(ts.StartDate__c  <= newTimesheetEntry.Date__c && newTimesheetEntry.Date__c <= ts.EndDate__c) {
                        List<Timesheet_Entry__c> tmes = mapTimesheetEntries.get(ts.Id);

                        if(tmes == null) {
                            tmes = new List<Timesheet_Entry__c>();
                            mapTimesheetEntries.put(ts.Id, tmes);
                        }

                        tmes.add(newTimesheetEntry);
                        timesheetsIds.add(ts.Id);
                    }
                }
            } else {
                Timesheet_Entry__c oldTimesheetEntry = mapOldTimesheetEntries.get(newTimesheetEntry.Id);

                if(newTimesheetEntry.Is_Approved__c == false && oldTimesheetEntry.Is_Approved__c == true && !excludeTimesheetsIds.contains(newTimesheetEntry.TimesheetId__c)) {
                    Timesheet__c ts = mapTimesheets.get(newTimesheetEntry.TimesheetId__c);

                    if(ts != null && ts.Status__c != 'Paid' && ts.Id == newTimesheetEntry.TimesheetId__c) {
                        ts.Status__c = 'New';
                        ts.Approved__c = null;
                        ts.ApprovedBy__c = null;
                        timesheetsStatusNew.add(ts);
                        break;
                    }
                    
                    excludeTimesheetsIds.add(newTimesheetEntry.TimesheetId__c);
                }  
            }
        }

        excludeTimesheetsIds.clear();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findByTimesheets(timesheetsIds);

        for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
            if(!excludeTimesheetsIds.contains(timesheetEntry.TimesheetId__c)) {
                List<Timesheet_Entry__c> timesheetEntriesForTimesheet = mapTimesheetEntries.get(timesheetEntry.TimesheetId__c);

                if(timesheetEntriesForTimesheet != null) {
                    for(Timesheet_Entry__c te : timesheetEntriesForTimesheet) {
                        if(timesheetEntry.Contract_Resource__c == te.Contract_Resource__c) {
                            te.TimesheetId__c = timesheetEntry.TimesheetId__c;
                            updateTimesheetsEntries.add(te);
                        }
                    }
                }

                excludeTimesheetsIds.add(timesheetEntry.TimesheetId__c);
            }
        }

        if(!timesheetsStatusNew.isEmpty()) {
            update timesheetsStatusNew;
        }

        response.Parameters.put('status', AppConfig.STATUS.get('success'));
    }

    private List<TimesheetEntryWrapper> getTimesheets() {
        List<TimesheetEntryWrapper> timesheetsList = new List<TimesheetEntryWrapper>();
        TimesheetEntryWrapper timesheetRecord = null;
       
        dao_User daoUser = new dao_User();
        List<User> listUsers = daoUser.getAll();
        Map<String,String> mapUsers = new Map<String,String>();

        for(User user : listUsers){
            mapUsers.put(user.Id,user.Name);
        }

        dao_Contract daoContract = new dao_Contract();
        List<Contract> listContracts= daoContract.findAll();
        Map<String,Object> mapContracts = new Map<String,Object>();
        for(Contract contract : listContracts){
            mapContracts.put(contract.Id , contract);
        }

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> listContractResources = daoContractResource.findAll();
        Map<String,Object> mapContractResources = new Map<String,Object>();

        for(Contract_Resource__c contractResource : listContractResources){
           mapContractResources.put(contractResource.Id,mapContracts.get(contractResource.Contract__c)); 
        }

        String role = AppConfig.ROLES.get('manager');

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<AggregateResult> listTimesheetEntries = daoTimesheetEntry.getTotalTimeForTimesheets();
        Map<String,AggregateResult> mapTimesheetEntries = new Map<String,AggregateResult>();
        if(listTimesheetEntries.size() > 0){
            for(AggregateResult timesheetEntry : listTimesheetEntries){
                String timesheetId = String.valueof(timesheetEntry.get('TimesheetId__c'));
                mapTimesheetEntries.put(timesheetId, timesheetEntry);
            }
        }

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> timesheets = daoTimesheet.findAll();

        for (Timesheet__c timesheet : timesheets) {
            AggregateResult entry = mapTimesheetEntries.get(timesheet.Id);

			String employeeId = timesheet.Contract_Resource__r.Employee__c;
            String contractResourceId = timesheet.Contract_Resource__c;
            String totalMinutes = '0';

            if(mapTimesheetEntries.get(timesheet.Id) != null) {
                totalMinutes = String.valueof(entry.get('total'));
            }
        
            String employeeName = mapUsers.get(employeeId);

            if(!mapContractResources.containsKey(contractResourceId)) {
                generateNoDataFoundError('Contract Resource not found');
            }
            Contract contractInfo = (Contract) mapContractResources.get(contractResourceId);

            Map<String, Object> conditions = new Map<String, Object>{
                'employeeId' => employeeId,
                'contractResourceId' => contractResourceId,
                'startDate' => timesheet.StartDate__c,
                'endDate' => timesheet.EndDate__c
            };

            List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findAll(conditions);
            
            timesheetRecord = new TimesheetEntryWrapper(new Map<String, Object> {
                          'timesheetId' => timesheet.Id,
                          'timesheetLink' => AppConfig.getTimesheetUrl(timesheet.Id),
                          'timesheetNumber' => timesheet.Name,
                          'account' => contractInfo.Account.Name,
                          'accountId' => contractInfo.Account.Id,
                          'accountLink' => AppConfig.getAccountUrl(contractInfo.Account.Id),
                          'contractNumber' => contractInfo.contractNumber,
                          'contractId' => contractInfo.id,
                          'contractResourceId' => contractResourceId,
                          'contractLink' => AppConfig.getContractUrl(contractInfo.id),
                          'startDate' => timesheet.StartDate__c,
                          'endDate' => timesheet.EndDate__c,
                          'userName' => employeeName,
                          'userId' => employeeId,   
                          'userLink' => AppConfig.getUserUrl(employeeId),
                          'totalMinutes' => totalMinutes,
                          'status' => timesheet.Status__c,    
                          'lastModifiedDate'=> timesheet.LastModifiedDate__c,
                          'approvedEntries' => approvedEntries(timesheetEntries) 
            });

            timesheetsList.add(timesheetRecord);
        }

        return timesheetsList;
    }

    private List<Map<String,Object>> filter(List<TimesheetEntryWrapper> timesheets, Integer limits, Integer offset) {
        List<Map<String,Object>> result = new List<Map<String,Object>>();

        if(offset == null) {
            offset = 0;
        }

        Integer timesheetsSize = timesheets.size();

        if(limits == null || limits > timesheetsSize) {
            limits = timesheets.size();
        }

        Integer countTimesheets = offset + limits;

        if(countTimesheets > timesheetsSize) {
            countTimesheets = timesheetsSize;
        }

        for(Integer i = offset; i < countTimesheets; i++) {
            result.add(((TimesheetEntryWrapper)timesheets.get(i)).timesheetEntry);
        }

        return result;
    }

    private Boolean approvedEntries(List<Timesheet_Entry__c> timesheetEntries){
        Boolean approvedEntries = true;
        
        for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
            if(timesheetEntry.Is_Approved__c == false){
                    approvedEntries = false;
                    break;
            }
        }

        return approvedEntries;
    }

    private String getStatus(String status) {
       return changeStatus.get(status);
    }

    //TODO:extract to error class
    private void generateError(String message) {
        IllegalArgumentException ex = new IllegalArgumentException();
        ex.setMessage(message);
        throw ex; 
    }

    //TODO:extract to error class
    private void generateNoDataFoundError(String message) {
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }

    //TODO:extract to error class
    private void generateNoAccessError(String message) {
        NoAccessException ex = new NoAccessException();
        ex.setMessage(message);
        throw ex; 
    }

    private void sendEmail(String timesheetId) {
        service_Request request = new service_Request();
        request.Parameters.put('action', 'send');
        request.Parameters.put('id', timesheetId);
        request.Parameters.put('reportPage', Page.TimesheetPDF);

        service_Response result = service_Controller.process(Services.Email, request);  
    }
}