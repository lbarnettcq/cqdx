/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
 //TODO:REVIEW:DUPLICATE CODE
public with sharing class service_TimeReports extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
            when 'getTotalCount' {
                getTotalCount(request, response);
            }    
            when 'findByReport' {
                findByReport(request, response);
            }
            when 'updateMultipleStatus' {
                updateMultipleStatus(request, response);
            }
        }
    }

    public void getList(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');
        Integer offset = (Integer)request.Parameters.get('offset');

        List<TimeReportsWrapper> timeReports = null;

        String timesheetId = (String)request.Parameters.get('timesheetId');

        if(timesheetId != null) {
           timeReports = getTimeReports(timesheetId); 
        } else {
           timeReports = getTimeReports();
        }

        timeReports.sort();

        response.Parameters.put('list', filter(timeReports, limits, offset));
    }

    public void getTotalCount(service_Request request, service_Response response) {
        String timesheetId = (String)request.Parameters.get('timesheetId');

        if(timesheetId != null) {            
            response.Parameters.put('count', getTimeReports(timesheetId).size());
        } else {
            response.Parameters.put('count', getTimeReports().size());
        }
    }
    
    //TODO:Critical:review
    public void findByReport(service_Request request, service_Response response) {
        String timesheetId = (String)request.Parameters.get('timesheetId');
        String employeeId = (String)request.Parameters.get('employeeId');
        Object startDate = request.Parameters.get('startDate'); 
        Object endDate = request.Parameters.get('endDate');
        
        List<Map<String, Object>> items = new List<Map<String, Object>>(); 
        Set<String> contractResourcesIds = new Set<String>();
        
        if(timesheetId != null) {
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

            if(timesheet != null && timesheet.Status__c == 'Paid') {
                return;//TODO: add generate error or default result for paid
            }

            contractResourcesIds.add(timesheet.Contract_Resource__c);
        } else {
            dao_ContractResource daoContractResource = new dao_ContractResource();
            List<Contract_Resource__c> contractResources = daoContractResource.findAllByUser(employeeId);
            
            for(Contract_Resource__c contractResource : contractResources) {
                contractResourcesIds.add(contractResource.Id);
            }
        }

        Map<String, Object> timesheetsEntriesConditions = new Map<String, Object> {
            'startDate' => startDate,
            'endDate' => endDate,
            'employeeId' => employeeId,
            'status' =>  request.Parameters.get('status'),
            'timesheetId' =>  request.Parameters.get('timesheetId')
        };

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> timesheetsEntries = daoTimesheetEntry.findByDateRange(timesheetsEntriesConditions);//TODO:review

        for(Timesheet_Entry__c timesheetEntry : timesheetsEntries) {
           if(timesheetEntry.TimesheetId__c != null && timesheetEntry.TimesheetId__r.Status__c == 'Paid') {
                contractResourcesIds.remove(timesheetEntry.Contract_Resource__c);
           }
        }

        Map<String, Object> amountByDate = new Map<String, Object>(); 

        Map<String, Object> expensesConditions = new Map<String, Object>{
            'listContractResourcesIds' => contractResourcesIds,
            'startDate' => startDate,
            'endDate' => endDate,
            'status' =>  request.Parameters.get('status')
        };

        dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
        List<AggregateResult> expenseEntryAmount = daoExpenseEntry.getTotalAmountByDates(expensesConditions);

        for(AggregateResult expenseEntry : expenseEntryAmount) {
             amountByDate.put(String.valueof(expenseEntry.get('Submittal_Date__c')).substring(0, 10), expenseEntry.get('amount'));//TODO:review
        } 
    
        timesheetsEntriesConditions.put('listContractResourcesIds', contractResourcesIds);
        List<AggregateResult> timesheetEntriesTotal = daoTimesheetEntry.findByReport(timesheetsEntriesConditions);//TODO:review

        for(AggregateResult  entry : timesheetEntriesTotal) {
            String entryDate = String.valueof(entry.get('Date__c')).substring(0, 10);//TODO:review

            Map<String, Object> item = new Map<String, Object> {
                'date' => entry.get('Date__c'), 
                'totalMinutes' => entry.get('totalMinutes'),
                'status' => (entry.get('Is_Approved__c') == true ? 'approved' : 'for_approval'),
                'totalPrice' => (amountByDate.get(entryDate) != null ? amountByDate.get(entryDate) : null)
            };   

            items.add(item);
        }

        response.Parameters.put('list',items);        
    }

    public void updateMultipleStatus(service_Request request, service_Response response) {
        String result = AppConfig.STATUS.get('error');
        String timesheetId = (String) request.Parameters.get('timesheetId');
        String employeeId = (String) request.Parameters.get('employeeId');
        List<Date> dateList = (List<Date>)request.Parameters.get('dateList');
        Boolean status = (Boolean)request.Parameters.get('status');

        Map<String, Object> params = new Map<String, Object> {
            'dateList' => dateList,
            'employeeId' => employeeId,
            'timesheetId' => timesheetId,
            'status' => status//TODO:check status if use
        };

        Map<String, Object> conditions = new Map<String, Object>();  

        List<String> conditionFields = new List<String> {
            'dateList', 'employeeId', 'timesheetId'
        };

        for(String field : conditionFields) {
            if(params.containsKey(field)) {
                conditions.put(field, params.get(field));            
            }
        }

        Set<String> listTimesheetIds = new Set<String>();

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findByDates(conditions);  
        List<Timesheet_Entry__c> updateList = new List<Timesheet_Entry__c>();
        
        if(timesheetEntries.size() > 0) {
            for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
                timesheetEntry.Is_Approved__c = status;

                if(timesheetEntry.Is_Approved__c == true) {
                    timesheetEntry.InternalApproval__c = Datetime.now();
                    timesheetEntry.InternalApprovalBy__c = UserInfo.getUserId();                  
                } else {
                    timesheetEntry.InternalApproval__c = null;
                    timesheetEntry.InternalApprovalBy__c = null;

                    if(timesheetEntry.TimesheetId__c != null) {
                        listTimesheetIds.add(timesheetEntry.TimesheetId__c);
                    }
                }

                updateList.add(timesheetEntry);
            }

            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            List<Expense_Entry__c> listExpenses = new List<Expense_Entry__c>();
            if(timesheetId != null) {
                listExpenses = daoExpenseEntry.findByTimesheets(new Set<String> {timesheetId});
            } else {
                dao_ContractResource daoContractResource = new dao_ContractResource();
                List<Contract_Resource__c> listContractResources = new List<Contract_Resource__c>();
                listContractResources = daoContractResource.findAllByUser(employeeId);
                
                Set<String> contractResourcesIds = new Set<String>();
                for(Contract_Resource__c contractResource : listContractResources){
                    contractResourcesIds.add(contractResource.Id);
                }
    
                conditions = new Map<String,Object> {
                    'dateList' => dateList,
                    'listContractResourcesIds' => contractResourcesIds
                };   
         
                listExpenses = daoExpenseEntry.findByDates(conditions);
            }    

            List<Expense_Entry__c> listExpensesToUpdate = new List<Expense_Entry__c>();
   
            if(!listExpenses.isEmpty()) {
                for(Expense_Entry__c expense : listExpenses) {
                    expense.Is_Approved__c = status;

                    if(expense.Is_Approved__c == true) {
                        expense.InternalApproval__c = Datetime.now();
                        expense.InternalApprovalBy__c = UserInfo.getUserId();                       
                    } else {
                        expense.InternalApproval__c = null;
                        expense.InternalApprovalBy__c = null;
                    }

                    listExpensesToUpdate.add(expense);                    
                }
                update listExpensesToUpdate;
            }
        
            //TODO:CRITICAL:REPLACE TO TRIGGER
            if(listTimesheetIds.size() > 0) {
                request.Parameters.put('listTimesheetIds', listTimesheetIds);
                request.Parameters.put('action', 'refreshInvoiceLineItems');

                service_Response resultResponse = service_Controller.process(Services.Invoices, request); 
            }

            update updateList;

            result = AppConfig.STATUS.get('success');
        }

        response.Parameters.put('status', result);
    }

    //TODO: JOIN methods: getTimeReports
    private List<TimeReportsWrapper> getTimeReports() {
        Map<String, TimeReportsWrapper> timeReports = new Map<String, TimeReportsWrapper>();

        Map<String,Date> dateRange = null;
        String keyDateRange = null;
        TimeReportsWrapper timeReportRecord = null;

        dao_User daoUser = new dao_User();
        List<User> listUsers = daoUser.findAllWithTimesheetEntries();

        for(User currentUser : listUsers) {
            for(Timesheet_Entry__c timesheetEntry : currentUser.Timesheet_Entries__r) {
                dateRange = getDateRange(timesheetEntry.Date__c);
                keyDateRange = dateRange.get('startDate') + '_' + dateRange.get('endDate') + '_' + currentUser.Id;

                if(timeReports.containsKey(keyDateRange)) {
                    timeReportRecord = (TimeReportsWrapper)timeReports.get(keyDateRange);
                    Map<String, Object> timeReportRecordNew = timeReportRecord.timereport;

                    timeReportRecordNew.put('totalMinutes',(decimal)timeReportRecordNew.get('totalMinutes') + timesheetEntry.Minutes__c);

                    DateTime lastModifiedDate = (DateTime)timeReportRecordNew.get('lastModifiedDate');

                    if(timesheetEntry.LastModifiedDate > lastModifiedDate) {
                         timeReportRecordNew.put('lastModifiedDate', timesheetEntry.lastModifiedDate);
                    }
                    String status = (timesheetEntry.Is_Approved__c == true) ? 'approved' : 'for_approval';
                    String previousStatus = (String)timeReportRecordNew.get('status');

                    if(previousStatus != status && previousStatus != 'in_progress') {
                        timeReportRecordNew.put('status', 'in_progress');
                    }                    
                } else {
                    timeReportRecord = new TimeReportsWrapper(new Map<String, Object>{
                            'startDate' => dateRange.get('startDate'),
                            'endDate' => dateRange.get('endDate'),                    
                            'userId' => timesheetEntry.Employee__c,
                            'userLink' => AppConfig.getUserUrl(timesheetEntry.Employee__c),
                            'userName' => currentUser.Name,    
                            'totalMinutes' => timesheetEntry.Minutes__c,
                            'status' => (timesheetEntry.Is_Approved__c == true ? 'approved' : 'for_approval'),
                            'lastModifiedDate' => timesheetEntry.LastModifiedDate
                        });

                    timeReports.put(keyDateRange, timeReportRecord);
                }
            }
        }

        return timeReports.values();
    }

    //TODO: JOIN methods: getTimeReports
    private List<TimeReportsWrapper> getTimeReports(String timesheetId) {
        Map<String, TimeReportsWrapper> timeReports = new Map<String, TimeReportsWrapper>();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

        if(timesheet != null) {
            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findByTimesheet(timesheetId);

            dao_User daoUser = new dao_User();
            User userName  = daoUser.findOneByTimesheet(timesheetId);

            Map<String,Date> dateRange = null;
            String keyDateRange = null;
            Date startDateRange = null;
            Date endDateRange = null;
            TimeReportsWrapper timeReportRecord = null;

            for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
                dateRange = getDateRange(timesheetEntry.Date__c);

                startDateRange = Date.valueOf(dateRange.get('startDate'));

                if(startDateRange < timesheet.startDate__c){
                    startDateRange = timesheet.startDate__c;
                } 

                endDateRange = Date.valueOf(dateRange.get('endDate'));

                if(endDateRange > timesheet.endDate__c){
                    endDateRange = timesheet.endDate__c;
                } 

                keyDateRange = startDateRange + '_' + endDateRange;

                if(timeReports.containsKey(keyDateRange)) {
                    timeReportRecord = (TimeReportsWrapper)timeReports.get(keyDateRange);
                    Map<String, Object> timeReportRecordNew = timeReportRecord.timereport;

                    timeReportRecordNew.put('totalMinutes',(decimal)timeReportRecordNew.get('totalMinutes') + timesheetEntry.Minutes__c);

                    DateTime lastModifiedDate = (DateTime)timeReportRecordNew.get('lastModifiedDate');

                    if(timesheetEntry.LastModifiedDate > lastModifiedDate) {
                         timeReportRecordNew.put('lastModifiedDate', timesheetEntry.lastModifiedDate);
                    }

                    String status = (timesheetEntry.Is_Approved__c == true) ? 'approved' : 'for_approval';
                    String previousStatus = (String)timeReportRecordNew.get('status');

                    if(previousStatus != status && previousStatus != 'in_progress') {
                        timeReportRecordNew.put('status', 'in_progress');
                    }                    
                } else {
                    timeReportRecord = new TimeReportsWrapper(new Map<String, Object>{
                            'startDate' => startDateRange,
                            'endDate' => endDateRange,              
                            'userId' => timesheetEntry.Employee__c,
                            'userLink' => AppConfig.getUserUrl(timesheetEntry.Employee__c),
                            'userName' => userName.Name,    
                            'totalMinutes' => timesheetEntry.Minutes__c,
                            'status' => (timesheetEntry.Is_Approved__c == true ? 'approved' : 'for_approval'),
                            'lastModifiedDate' => timesheetEntry.LastModifiedDate
                        });

                    timeReports.put(keyDateRange,timeReportRecord);
                }
            }
        }

        return timeReports.values();
    }

    private Map<String,Date> getDateRange(Date currentDate) {
        Date startDate = currentDate.toStartOfWeek();
        Date endDate = startDate.addDays(6);

        return new Map<String,Date>{
            'startDate' => startDate,
            'endDate' => endDate
        }; 
    }

    private List<Map<String, Object>> filter(List<TimeReportsWrapper> timeReports, Integer limits, Integer offset) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        if(offset == null) {
            offset = 0;
        }

        Integer timeReportsSize = timeReports.size();

        if(limits == null || limits > timeReportsSize) {
            limits = timeReports.size();
        }

        Integer countTimeReports = offset + limits;

        if(countTimeReports > timeReportsSize) {
            countTimeReports = timeReportsSize;
        }

        for(Integer i = offset; i < countTimeReports; i++) {
            result.add(((TimeReportsWrapper)timeReports.get(i)).timereport);
        }

        return result;
    }
}