/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Invoices extends service_Base {
    private final String STATUS_NEW = 'New';
    private final String STATUS_PENDING = 'Pending';
    private final String STATUS_PAID = 'Paid';

    private Map<String, String> chainStatuses = new Map<String, String> {//TODO:Create list from schema enum
        STATUS_NEW => STATUS_PENDING,
        STATUS_PENDING => STATUS_PAID
    };

    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
            when 'getTotalCount' {
                getTotalCount(request, response);
            }
            when 'getListItems' {
                getListItems(request, response);
            }
            when 'getTotalItemsCount' {
                getTotalItemsCount(request, response);
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
            when 'refreshInvoices' {
                refreshInvoices(request, response);
            }
            when 'refreshInvoiceLineItems' {
                refreshInvoiceLineItems(request, response);
            }
            when 'availableEntity' {
                availableEntity(request, response);
            }
            when 'getListByParams' {
                getListByParams(request, response);
            }
        }
    }

    public void getList(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');
        Integer offset = (Integer)request.Parameters.get('offset');

        List<InvoiceWrapper> invoices = getInvoices();

        invoices.sort();

        response.Parameters.put('list', filter(invoices, limits, offset));
    }

    public void getTotalCount(service_Request request, service_Response response) {
        response.Parameters.put('count', getInvoices().size());
    }

    public void getListItems(service_Request request, service_Response response) {
        Integer limits = (Integer)request.Parameters.get('limits');//TODO: review: is not used
        Integer offset = (Integer)request.Parameters.get('offset');//TODO: review: is not used
        String invoiceId = (String)request.Parameters.get('invoiceId');

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c invoice = getInvoiceById(invoiceId);

        List<InvoiceWrapper> invoiceItems = getInvoiceItems(invoiceId);

        invoiceItems.sort();

        response.Parameters.put('list', filter(invoiceItems, limits, offset));
    }

    public void getTotalItemsCount(service_Request request, service_Response response) {
        String invoiceId = (String)request.Parameters.get('invoiceId');

        Invoice__c invoice = getInvoiceById(invoiceId);

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> invoicesLineItem = daoInvoicesLineItem.findByInvoice(invoiceId);

        response.Parameters.put('count', invoicesLineItem.size());
    }

    public void getInformation(service_Request request, service_Response response) {
        String invoiceId = String.valueof(request.Parameters.get('invoiceId'));
        Map<String,Object> invoiceInfo = new Map<String,Object>();

        Invoice__c invoice = getInvoiceById(invoiceId);

        dao_Account daoAccount = new dao_Account();
        Account account = daoAccount.findOne(invoice.Account__c);

        invoiceInfo = new Map<String, Object> {
            'invoiceId' => invoiceId,
            'invoiceNumber' => invoice.Name,
            'lastModifiedDate'=> invoice.Last_updated__c,
            'status' => invoice.Status__c,
            'accountId' => invoice.Account__c,
            'accountName' => account.Name,
            'startDate' => invoice.startDate__c,
            'endDate' => invoice.endDate__c,
            'issueDate' => invoice.issueDate__c,
            'dueDate' => invoice.dueDate__c,
            'totalMinutes' => invoice.Minutes__c,
            'totalExpenses' => (Decimal)(invoice.Expenses__c).setScale(2),
            'totalAmount' => (Decimal)(invoice.Amount__c + invoice.Expenses__c).setScale(2),
            'isPaid' => invoice.is_Paid__c,
            'paymentDate' => invoice.paymentDate__c
        };
        

        response.Parameters.put('item', invoiceInfo);
    }

    //TODO:CRITICAL:REPLACE
    public void insertEntry(service_Request request, service_Response response) {
        String accountId = String.valueof(request.Parameters.get('accountId'));
        Date startDate = Date.valueof(request.Parameters.get('startDate'));
        Date endDate = Date.valueof(request.Parameters.get('endDate'));
        Date issueDate = Date.valueof(request.Parameters.get('issueDate'));
        Date dueDate = Date.valueof(request.Parameters.get('dueDate'));

        if(accountId == null || startDate == null || endDate == null || issueDate == null || dueDate == null) {
            generateNoAccessError('You can not insert without params');
        }

        dao_Account daoAccount = new dao_Account();
        Account acc = daoAccount.findOne(accountId);

        if(acc == null) {
            generateNoDataFoundError('Account ' + accountId + ' not found');
        }

        Map<String, Object> conditions = new Map<String, Object>{
            'accountId' => accountId,
            'startDate' => startDate,
            'endDate' => endDate,
            'invoiceId' => null
        };

        dao_Invoices daoInvoices = new dao_Invoices();
        Boolean validatePeriod = daoInvoices.checkDatesInPeriods(conditions);
           
        if(!validatePeriod) {
            generateNoAccessError('You already have invoices for these dates');
        }

        Invoice__c invoice = new Invoice__c();
        invoice.Account__c = accountId;
        invoice.StartDate__c = startDate;
        invoice.EndDate__c = endDate;
        invoice.IssueDate__c = issueDate;
        invoice.DueDate__c = dueDate;
        invoice.Status__c = 'New';
        invoice.Last_updated__c = Datetime.now();

        insert invoice;

        Decimal totalAmount = 0;
        Decimal totalExpenses = 0;
        Decimal totalMinutes = 0;

        List<Map<String,Object>> timesheets = getTimesheets(accountId, startDate, endDate);

        if(!timesheets.isEmpty()) {
            List<Invoice_Line_Item__c> invoiceItemList = new List<Invoice_Line_Item__c>();
            Set<String> timesheetIds = new Set<String>();

            for(Map<String, Object> timesheet : timesheets) {
                Invoice_Line_Item__c invoiceItem = new Invoice_Line_Item__c();

                invoiceItem.Invoice__c = invoice.Id;
                invoiceItem.Timesheet__c = (String)timesheet.get('timesheetId');
                invoiceItem.Minutes__c = (Decimal)timesheet.get('totalMinutes');
                totalMinutes += (Decimal)timesheet.get('totalMinutes');
                invoiceItem.Expenses__c = (Decimal)timesheet.get('totalExpenses');

                if((Decimal)timesheet.get('totalExpenses') != null) {
                    totalExpenses += (Decimal)timesheet.get('totalExpenses');
                }

                invoiceItem.Amount__c = (Decimal)timesheet.get('totalAmount');

                if((Decimal)timesheet.get('totalAmount') != null) {
                    totalAmount += (Decimal)timesheet.get('totalAmount');
                }

                invoiceItemList.add(invoiceItem);
                timesheetIds.add((String)timesheet.get('timesheetId'));
            }

            insert invoiceItemList;

            if(!timesheetIds.isEmpty()) {
                    dao_Timesheet daoTimesheet = new dao_Timesheet();
                    List<Timesheet__c> listTimesheets = daoTimesheet.findAllByIds(timesheetIds);//REPLACE to new Timesheet__c with set id and status
                    String timesheetStatus = 'Invoiced';

                    if(!listTimesheets.isEmpty()) {
                        List<Timesheet__c> listTimesheetsToUpdate = new List<Timesheet__c>();

                        for(Timesheet__c timesheet : listTimesheets) {
                            timesheet.Status__c = timesheetStatus;
                            listTimesheetsToUpdate.add(timesheet);
                        }

                        update listTimesheetsToUpdate;
                    }
            }
        }
    
        invoice.Amount__c = totalAmount.setScale(2);
        invoice.Expenses__c = totalExpenses.setScale(2);
        invoice.Minutes__c = totalMinutes;

        update invoice;

        response.Parameters.put('item', invoice);  
    }
    
    //TODO:CRITICAL:REPLACE
    public void updateEntry(service_Request request, service_Response response) {
        String invoiceId = String.valueof(request.Parameters.get('invoiceId'));
        String accountId = String.valueof(request.Parameters.get('accountId'));
        Date startDate = Date.valueof(request.Parameters.get('startDate'));
        Date endDate = Date.valueof(request.Parameters.get('endDate'));
        Date issueDate = Date.valueof(request.Parameters.get('issueDate'));
        Date dueDate = Date.valueof(request.Parameters.get('dueDate'));

        Invoice__c invoice = getInvoiceById(invoiceId);

        if(invoice.Status__c == STATUS_PAID) {
            generateNoAccessError('You can not edit invoice with "Paid" status');   
        } 

        Boolean validatePeriod = true;

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> invoiceLineItems = daoInvoicesLineItem.findByInvoice(invoiceId);

        if(invoice.StartDate__c != startDate || invoice.EndDate__c != endDate || invoice.Account__c != accountId) {
            Map<String, Object> conditions = new Map<String, Object> {
                'accountId' => accountId,
                'startDate' => startDate,
                'endDate' => endDate,
                'invoiceId' => invoice.Id
            };

            dao_Invoices daoInvoices = new dao_Invoices();
            validatePeriod = daoInvoices.checkDatesInPeriods(conditions);
        }

        if(!validatePeriod) {
            generateNoAccessError('You already have invoices for these dates');
        }  

        invoice.Account__c = accountId;
        invoice.StartDate__c = startDate;
        invoice.EndDate__c = endDate;
        invoice.IssueDate__c = issueDate;
        invoice.DueDate__c = dueDate;
        invoice.Status__c = 'New';
        invoice.Last_updated__c = Datetime.now();

        Decimal totalAmount = 0;
        Decimal totalExpenses = 0;
        Decimal totalMinutes = 0;

        if(!invoiceLineItems.isEmpty()) {
            Set<String> timesheetIds = new Set<String>();

            for(Invoice_Line_Item__c invoiceLineItem : invoiceLineItems) {
                timesheetIds.add(invoiceLineItem.Timesheet__c);
            }

            if(!timesheetIds.isEmpty()) {
                dao_Timesheet daoTimesheet = new dao_Timesheet();
                List<Timesheet__c> listTimesheets = daoTimesheet.findAllByIds(timesheetIds);

                List<Timesheet__c> listTimesheetsToUpdate = new List<Timesheet__c>();

                for(Timesheet__c timesheet : listTimesheets) {
                    timesheet.Status__c = 'Approved';
                    listTimesheetsToUpdate.add(timesheet);
                }

                update listTimesheetsToUpdate;
            }

            delete invoiceLineItems;
        }  

        List<Map<String,Object>> timesheets = getTimesheets(accountId, startDate, endDate);

        if(!timesheets.isEmpty()) {
            List<Invoice_Line_Item__c> invoiceItemList = new List<Invoice_Line_Item__c>();
            Set<String> timesheetIds = new Set<String>();

            for(Map<String, Object> timesheet : timesheets) {
                Invoice_Line_Item__c invoiceItem = new Invoice_Line_Item__c();

                invoiceItem.Invoice__c = invoice.Id;
                invoiceItem.Timesheet__c = (String)timesheet.get('timesheetId');
                invoiceItem.Minutes__c = (Decimal)timesheet.get('totalMinutes');
                totalMinutes += (Decimal)timesheet.get('totalMinutes');
                invoiceItem.Expenses__c = (Decimal)timesheet.get('totalExpenses');

                if((Decimal)timesheet.get('totalExpenses') != null) {
                    totalExpenses += (Decimal)timesheet.get('totalExpenses');
                }

                invoiceItem.Amount__c = (Decimal)timesheet.get('totalAmount');
                if((Decimal)timesheet.get('totalAmount') != null) {
                    totalAmount += (Decimal)timesheet.get('totalAmount');
                }
 
                invoiceItemList.add(invoiceItem);
                timesheetIds.add((String)timesheet.get('timesheetId'));
            }
            
            insert invoiceItemList;

            if(!timesheetIds.isEmpty()) {
                    dao_Timesheet daoTimesheet = new dao_Timesheet();
                    List<Timesheet__c> listTimesheets = daoTimesheet.findAllByIds(timesheetIds);
                    String timesheetStatus = 'Invoiced';

                    if(!listTimesheets.isEmpty()) {
                        List<Timesheet__c> listTimesheetsToUpdate = new List<Timesheet__c>();

                        for(Timesheet__c timesheet : listTimesheets) {
                            timesheet.Status__c = timesheetStatus;
                            listTimesheetsToUpdate.add(timesheet);
                        }

                        update listTimesheetsToUpdate;
                    }
            }
        }
    
        invoice.Amount__c = totalAmount.setScale(2);
        invoice.Expenses__c = totalExpenses.setScale(2);
        invoice.Minutes__c = totalMinutes;

        update invoice;

        response.Parameters.put('item', invoice);
    }

    public void deleteEntry(service_Request request, service_Response response) {
        String invoiceId = String.valueof(request.Parameters.get('invoiceId'));

        Invoice__c invoice = getInvoiceById(invoiceId);
        
        if(invoice.Status__c != STATUS_NEW) {
            generateNoAccessError('You can not delete invoice with "' + invoice.Status__c + '" status'); 
        } 

        Set<String> timesheetIds = new Set<String>();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> listInvoicesLineItem =  daoInvoicesLineItem.findByInvoice(invoiceId);

        for(Invoice_Line_Item__c invoiceLineItem : listInvoicesLineItem) {
            timesheetIds.add(invoiceLineItem.Timesheet__c);
        }

        if(!timesheetIds.isEmpty()) {
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            List<Timesheet__c> listTimesheets = daoTimesheet.findAllByIds(timesheetIds);
            
            List<Timesheet__c> listTimesheetsToUpdate = new List<Timesheet__c>();

            for(Timesheet__c timesheet : listTimesheets) {
                timesheet.Status__c = 'Approved';
                listTimesheetsToUpdate.add(timesheet);
            }

            update listTimesheetsToUpdate;
        }

        delete invoice;

        response.Parameters.put('status', AppConfig.STATUS.get('success'));
    }

    public void updateStatus(service_Request request, service_Response response) {
        String invoiceId = String.valueof(request.Parameters.get('invoiceId'));
        Date paymentDate = Date.valueof(request.Parameters.get('paymentDate'));

        Invoice__c invoice = getInvoiceById(invoiceId);

        if(invoice.Minutes__c == 0 || invoice.Amount__c == 0) {
            generateNoAccessError('You can not send empty Invoice');
        }

        String status = invoice.Status__c;

        if(invoice.Status__c != STATUS_PAID) {
            invoice.Last_updated__c = Datetime.now();
            String invoiceStatus = getStatus(invoice.Status__c);
            invoice.Status__c = invoiceStatus;

            if(invoice.Status__c == STATUS_PAID) {
                if(paymentDate != null) {
                    if(paymentDate >= invoice.issueDate__c) {
                        invoice.paymentDate__c = paymentDate;
                    } else {
                        generateNoAccessError('Payment Date should not be before Issue Date');                    
                    }
                } else {
                    invoice.paymentDate__c = Date.today();
                }

                invoice.is_Paid__c = true;

                dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
                List<Invoice_Line_Item__c> listInvoicesLineItems = daoInvoicesLineItem.findByInvoice(invoiceId);

                if(!listInvoicesLineItems.isEmpty()) {
                    Set<String> timesheetIds = new Set<String>();
                    String timesheetStatus = invoiceStatus;

                    for(Invoice_Line_Item__c invoicesLineItem : listInvoicesLineItems) {
                        timesheetIds.add((String)invoicesLineItem.Timesheet__c);
                    }

                    if(!timesheetIds.isEmpty()) {
                        dao_Timesheet daoTimesheet = new dao_Timesheet();
                        List<Timesheet__c> listTimesheets = daoTimesheet.findAllByIds(timesheetIds);

                        if(!listTimesheets.isEmpty()) {
                            List<Timesheet__c> listTimesheetsToUpdate = new List<Timesheet__c>();

                            for(Timesheet__c timesheet : listTimesheets) {
                                timesheet.Status__c = timesheetStatus;
                                listTimesheetsToUpdate.add(timesheet);
                            }

                            update listTimesheetsToUpdate;
                        }
                    }
                }        
            }

            Datetime lastUpdated = Datetime.valueOf(invoice.Last_updated__c);
            Date pendingInvoicesStartDate = Date.newInstance(lastUpdated.year(), lastUpdated.month(), lastUpdated.day());

            request.Parameters.put('invoiceId', invoice.id);
            request.Parameters.put('startDate', invoice.startDate__c);
            request.Parameters.put('endDate', invoice.endDate__c);
            request.Parameters.put('paidInvoices', (invoice.Status__c == STATUS_PAID ? true : false));
            request.Parameters.put('pendingInvoices', (invoice.Status__c == STATUS_PENDING ? true : false));
            request.Parameters.put('pendingInvoicesStartDate', (invoice.Status__c == STATUS_PENDING ? pendingInvoicesStartDate : null));
            request.Parameters.put('action', 'refreshPayments');

            service_Response result = service_Controller.process(Services.Payments, request);

            update invoice;

            status = invoice.Status__c;
        }

        response.Parameters.put('status', status);
    }

    public void availableEntity(service_Request request, service_Response response) {
        String invoiceId = String.valueof(request.Parameters.get('invoiceId'));

        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c invoice = daoInvoices.findOne(invoiceId);

        if(invoice != null) {
            response.Parameters.put('status', 'available');
            response.Parameters.put('message', 'This record is available.');
        } else {
            response.Parameters.put('status', 'unavailable');
            response.Parameters.put('message', 'This record is no longer available. Ask your administrator for help.');
        }
    }

    //TODO: CRITICAL: NEED REVIEW
    public void refreshInvoices(service_Request request, service_Response response) {  
        List<Timesheet__c> timesheets = (List<Timesheet__c>)request.Parameters.get('timesheets');

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        Timesheet__c timesheet = daoTimesheet.findOne(timesheets[0].Id);

        if(timesheet == null) {
            generateNoDataFoundError('Timesheet ' + timesheet.Id + ' not found');
        }

        dao_Contract daoContract = new dao_Contract();
        Contract contractInfo = daoContract.findOneByContractResource(timesheet.Contract_Resource__c);
        String accountId =  contractInfo.Account.Id;

        dao_Invoices daoInvoices = new dao_Invoices();
        Map<String,Object> conditions = new Map<String,Object> {
            'startDate' => timesheet.startDate__c,
            'endDate' => timesheet.endDate__c,
            'accountId' => accountId
        };

        Invoice__c invoice = daoInvoices.findOneByDates(conditions);

        if(invoice != null && invoice.Status__c == 'New') {
            
            timesheet.Status__c = 'Invoiced';
            update timesheet;

            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            List<AggregateResult> timesheetTotalTimeList = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(new Set<String>{timesheet.id});

            Decimal timesheetTotalMinutes = 0;
            if(!timesheetTotalTimeList.isEmpty()) {
                timesheetTotalMinutes = (Decimal)timesheetTotalTimeList[0].get('total');
            }

            conditions = new Map<String,Object> {
                'timesheetIds' => new Set<String>{timesheet.id},
                'isBillable' => true, 
                'isApproved' => true
            };

            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            List<AggregateResult> listAggregateExpenses = daoExpenseEntry.getTotalAmount(conditions);
            Decimal timesheetTotalExpenses = 0;
            if(!listAggregateExpenses.isEmpty()) {
                timesheetTotalExpenses = (Decimal)listAggregateExpenses[0].get('amount');
            }

            Invoice_Line_Item__c invoiceItem = new Invoice_Line_Item__c();
            invoiceItem.Invoice__c = invoice.Id;
            invoiceItem.Timesheet__c = timesheet.id;
            invoiceItem.Minutes__c = timesheetTotalMinutes;
            invoiceItem.Expenses__c = timesheetTotalExpenses;        
            invoiceItem.Amount__c = timesheetTotalMinutes > 0 ? (timesheetTotalMinutes/60) * timesheet.Contract_Resource__r.Rate__c : timesheetTotalMinutes;
                
            insert invoiceItem;

            Decimal totalMinutes = invoice.Minutes__c + invoiceItem.Minutes__c;
            Decimal totalAmount = invoice.Amount__c + invoiceItem.Amount__c;

            if(invoiceItem.Expenses__c != null) {
                invoice.Expenses__c = (invoice.Expenses__c + invoiceItem.Expenses__c).setScale(2);
            }
            invoice.Minutes__c = totalMinutes;
            invoice.Amount__c = totalAmount.setScale(2);
            invoice.Last_updated__c = Datetime.now();

            update invoice;
        }

        response.Parameters.put('item', invoice);
    }

    //TODO: CRITICAL: NEED REPLACE: + or - from total line item and invoice and search in line items: SPLIT TIMESHEET UPDATE STATUS FROM UPDATE INVOICE
    public void refreshInvoiceLineItems(service_Request request, service_Response response) {
        List<Timesheet__c> timesheets = (List<Timesheet__c>)request.Parameters.get('timesheets');//Result From Trigger timesheet

        List<Timesheet__c> timesheetsToUpdate = new List<Timesheet__c>();

        Set<String> listTimesheetIds = (Set<String>)request.Parameters.get('listTimesheetIds');

        if(listTimesheetIds != null && !listTimesheetIds.isEmpty()) {
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
            dao_Invoices daoInvoices = new dao_Invoices();

            for(String timesheetId : listTimesheetIds) {
                Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);//REPLACE TO ALL IN SET Ids

                if(timesheet == null) {
                    continue;
                }

                Invoice_Line_Item__c invoiceLineItemToDelete = daoInvoicesLineItem.findByTimesheet(timesheet.Id);//REPLACE TO ALL IN SET Ids

                if(invoiceLineItemToDelete != null ) {
                    String invoiceId =  invoiceLineItemToDelete.Invoice__c;
                    Invoice__c invoice = daoInvoices.findOne(invoiceId);

                    if(invoice.Status__c == STATUS_PAID) {//TODO: CRITICAL: we neeed first check and then lock and unlock after that
                        generateNoAccessError('You can not unlock entries wich contains in invoice with "' + invoice.Status__c + '" status');
                    }

                    delete invoiceLineItemToDelete;

                    Decimal totalAmount = 0;
                    Decimal totalExpenses = 0;
                    Decimal totalMinutes = 0;

                    List<Invoice_Line_Item__c> invoiceLineItems = daoInvoicesLineItem.findByInvoice(invoiceId);
                    for(Invoice_Line_Item__c invoiceLineItem : invoiceLineItems) {
                            if(invoiceLineItem.Minutes__c != null) {
                                totalMinutes += invoiceLineItem.Minutes__c;
                            }
                            if(invoiceLineItem.Expenses__c != null) {
                                totalExpenses += invoiceLineItem.Expenses__c;
                            }
                            if(invoiceLineItem.Amount__c != null) {
                                totalAmount += invoiceLineItem.Amount__c;
                            }
                    }

                    invoice.Status__c = STATUS_NEW;
                    invoice.Amount__c = totalAmount.setScale(2);
                    invoice.Expenses__c = totalExpenses;
                    invoice.Minutes__c = totalMinutes;
                    invoice.Last_updated__c = Datetime.now();

                    update invoice;
                }

                timesheet.Status__c = STATUS_NEW;//TODO:CRITICAL:MOVE TO TIMESHEETS
                timesheetsToUpdate.add(timesheet);
            }

            update timesheetsToUpdate;
        }

        response.Parameters.put('items', timesheetsToUpdate);
    }

    public static void getListByParams(service_Request request, service_Response response) {
        List<Invoice__c> invoices = new List<Invoice__c>();

        Date startDate = (Date)request.Parameters.get('startDate');
        Date endDate = (Date)request.Parameters.get('endDate');
        List<String> statuses = (List<String>)request.Parameters.get('statuses');

        if(startDate != null &&  endDate != null && statuses != null && !statuses.isEmpty()) {
            Date pendingInvoicesStartDatetime = (Date)request.Parameters.get('pendingInvoicesStartDatetime');

            //TODO: MOVE TO DAO INVOICE
            if(pendingInvoicesStartDatetime != null) {
                invoices = [
                    SELECT 
                        Id, 
                        Status__c,
                        StartDate__c,
                        EndDate__c,
                        (SELECT Id, Timesheet__c FROM Invoice_Line_Items__r) 
                    FROM 
                        Invoice__c
                    WHERE 
                        EndDate__c >= :startDate
                        AND
                        StartDate__c <= :endDate
                        AND
                        Status__c IN :statuses
                        AND
                        Last_updated__c >= :pendingInvoicesStartDatetime 
                ];
            } else {
                invoices = [
                    SELECT 
                        Id, 
                        Status__c,
                        StartDate__c,
                        EndDate__c,
                        (SELECT Id, Timesheet__c FROM Invoice_Line_Items__r) 
                    FROM 
                        Invoice__c
                    WHERE 
                        EndDate__c >= :startDate
                        AND
                        StartDate__c <= :endDate
                        AND
                        Status__c IN :statuses
                ];
            }
        }

        
        response.Parameters.put('list', invoices);
    }

    private String getStatus(String status) {
       return chainStatuses.get(status);
    }

    //TODO:REPLACE
    private List<InvoiceWrapper> getInvoices() {
        List<InvoiceWrapper> invoicesList = new List<InvoiceWrapper>();
        InvoiceWrapper invoiceRecord = null;
       
        dao_Account daoAccount = new dao_Account();
        List<Account> listAccounts = daoAccount.findAll();
        Map<String,String> mapAccounts = new Map<String,String>();

        for(Account account : listAccounts){
            mapAccounts.put(account.Id,account.Name);
        }

        dao_Invoices daoInvoices = new dao_Invoices();
        List<Invoice__c> invoices = daoInvoices.findAll(null, null);

        for (Invoice__c invoice : invoices) {
            String accountName = mapAccounts.get(invoice.Account__c);
            Decimal totalAmount = invoice.Amount__c + invoice.Expenses__c;
            
            invoiceRecord = new InvoiceWrapper(new Map<String, Object> {
                        'invoiceId' => invoice.Id,
                        'invoiceNumber' => invoice.Name,                
                        'account' => accountName,
                        'accountId' => invoice.Account__c,
                        'accountLink' => AppConfig.getAccountUrl(invoice.Account__c),
                        'startDate' => invoice.startDate__c,
                        'endDate' => invoice.endDate__c,
                        'issueDate' => invoice.issueDate__c,
                        'dueDate' => invoice.dueDate__c,
                        'paymentDate' => invoice.paymentDate__c ,
                        'totalAmount' => totalAmount.setScale(2),
                        'status' => invoice.Status__c,
                        'lastModifiedDate' => invoice.Last_updated__c    
            });

            invoicesList.add(invoiceRecord);
        }

        return invoicesList;
    }   

    //TODO:replace
    private List<InvoiceWrapper> getInvoiceItems(String invoiceId) {
        List<InvoiceWrapper> timesheetsList = new List<InvoiceWrapper>();

        dao_InvoicesLineItem daoInvoicesLineItem = new dao_InvoicesLineItem();
        List<Invoice_Line_Item__c> listInvoicesLineItem = daoInvoicesLineItem.findByInvoice(invoiceId);

        Set<String> timesheetIds = new Set<String>();

        for(Invoice_Line_Item__c invoiceLineItem : listInvoicesLineItem) {
            timesheetIds.add(invoiceLineItem.Timesheet__c);
        }
        
        if(!timesheetIds.isEmpty()) {
            dao_Contract daoContract = new dao_Contract();
            List<Contract> listContracts = daoContract.findAll();
            Map<String,Object> mapContracts = new Map<String,Object>();
            for(Contract contract : listContracts) {
                mapContracts.put(contract.Id, contract);
            }

            dao_ContractResource daoContractResource = new dao_ContractResource();
            List<Contract_Resource__c> listContractResources = daoContractResource.findAll();
            Map<String,Object> mapContractResources = new Map<String,Object>();
            Map<String,Object> mapRates = new Map<String,Object>();
            for(Contract_Resource__c contractResource : listContractResources){
                mapContractResources.put(contractResource.Id,mapContracts.get(contractResource.Contract__c));
                mapRates.put(contractResource.Id,contractResource.Rate__c);
            }

            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            List<AggregateResult> listTimesheetEntries = daoTimesheetEntry.getTotalTimeForTimesheetsByIds(timesheetIds);
            Map<String,AggregateResult> mapTimesheetEntries = new Map<String,AggregateResult>();
            for(AggregateResult timesheetEntry : listTimesheetEntries){
                String timesheetId = String.valueof(timesheetEntry.get('TimesheetId__c'));
                mapTimesheetEntries.put(timesheetId, timesheetEntry);
            }
            
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            List<Timesheet__c> timesheets = daoTimesheet.findAllByIds(timesheetIds);

            InvoiceWrapper timesheetRecord = null;

            for (Timesheet__c timesheet : timesheets) {
                Decimal totalMinutes = 0;
                AggregateResult entry = mapTimesheetEntries.get(timesheet.Id);
                if(entry != null) {
                    totalMinutes = (Decimal) entry.get('total');
                }
                String contractResourceId = timesheet.Contract_Resource__c;
     
                Contract contractInfo = (Contract) mapContractResources.get(contractResourceId);
                Decimal rate = (Decimal) mapRates.get(contractResourceId);

                timesheetRecord = new InvoiceWrapper(new Map<String, Object> {
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
                            'totalMinutes' => totalMinutes,
                            'status' => timesheet.Status__c,
                            'rate' => rate,
                            'totalAmount' => Double.valueOf((totalMinutes/60)*rate)
                });

                timesheetsList.add(timesheetRecord);
            }
        }

        return timesheetsList;
    }

    //TODO:CRITICAL:Replace
    private List<Map<String,Object>> getTimesheets(String accountId, Date startDate, Date endDate) {
        List<Map<String,Object>> timesheets = new List<Map<String,Object>>();

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> listContractResources = daoContractResource.findAllByAccount(accountId);

        if(listContractResources.isEmpty()) {
            generateNoDataFoundError('Contract Resources not available');
        }

        Set<String> contractResources = new Set<String>();
        for(Contract_Resource__c contractResource : listContractResources) {
            contractResources.add(contractResource.Id);
        }

        Map<String, Decimal> mapExpensesAmount = new Map<String, Decimal>();
        Map<String, Decimal> mapTimesheetEntriesAmount = new Map<String, Decimal>();

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> listTimesheets = daoTimesheet.findAllForInvoice(contractResources, startDate, endDate);

        if(!listTimesheets.isEmpty()) {
            Set<String> timesheetsIds = new Set<String>();

            for(Timesheet__c timesheetObj : listTimesheets) {
                timesheetsIds.add(timesheetObj.Id);
            }        

            Map<String,Object> conditions = new Map<String,Object> {
                'timesheetIds' => timesheetsIds,
                'isBillable' => true, 
                'isApproved' => true
            };

            dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();
            List<AggregateResult> listAggregateExpenses = daoExpenseEntry.getTotalAmount(conditions);
            if(!listAggregateExpenses.isEmpty()) {
                for(AggregateResult expense : listAggregateExpenses) {
                    String timesheetId = (String)expense.get('TimesheetId__c');
                    Decimal expenseTotalAmount = (Decimal)expense.get('amount');

                    mapExpensesAmount.put(timesheetId, expenseTotalAmount);
                }
            }

            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            List<AggregateResult> listAggregateTimesheets = daoTimesheetEntry.findByTimesheets(timesheetsIds, startDate, endDate);

            if(!listAggregateTimesheets.isEmpty()) {
                for(AggregateResult timesheet : listAggregateTimesheets) {
                    String timesheetId = (String)timesheet.get('TimesheetId__c');
                    Decimal totalMinutes = (Decimal)timesheet.get('total');

                    mapTimesheetEntriesAmount.put(timesheetId, totalMinutes);
                }
            }           

            for(Timesheet__c timesheet : listTimesheets) {
                Decimal totalExpenses = 0;                        

                if((Decimal)mapExpensesAmount.get(timesheet.Id) != null) {
                    totalExpenses = (Decimal)mapExpensesAmount.get(timesheet.Id);
                }  

                Decimal totalAmount = 0;
                Decimal totalMinutes = 0;
                
                if((Decimal)mapTimesheetEntriesAmount.get(timesheet.Id) != null) {
                    totalMinutes = (Decimal)mapTimesheetEntriesAmount.get(timesheet.Id);
                    Decimal rateTimesheet = (Decimal)timesheet.Contract_Resource__r.Rate__c;

                    if(rateTimesheet != null) {
                        totalAmount = (totalMinutes/60) * rateTimesheet;
                    }        
                }                    

                Map<String, Object> item = new Map<String, Object> {
                    'timesheetId' => timesheet.Id,
                    'totalMinutes' => totalMinutes,
                    'totalExpenses' => totalExpenses,
                    'totalAmount' => totalAmount
                };

                timesheets.add(item);
            }    
        }
        
        return timesheets;
    }

    private List<Map<String, Object>> filter(List<InvoiceWrapper> invoices, Integer limits, Integer offset) {
        List<Map<String,Object>> result = new List<Map<String,Object>>();

        if(offset == null) {
            offset = 0;
        }

        Integer invoicesSize = invoices.size();

        if(limits == null || limits > invoicesSize) {
            limits = invoices.size();
        }

        Integer countInvoices = offset + limits;

        if(countInvoices > invoicesSize) {
            countInvoices = invoicesSize;
        }

        for(Integer i = offset; i < countInvoices; i++) {
            result.add(((InvoiceWrapper)invoices.get(i)).Invoice);
        }

        return result;
    }

    private void generateNoDataFoundError(String message) {
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }

    private void generateNoAccessError(String message) {
        NoAccessException ex = new NoAccessException();
        ex.setMessage(message);
        throw ex; 
    }

    private Invoice__c getInvoiceById(String invoiceId) {
        dao_Invoices daoInvoices = new dao_Invoices();
        Invoice__c invoice = daoInvoices.findOne(invoiceId);

        if(invoice == null) {
            generateNoDataFoundError('Invoice ' + invoiceId + ' not found');
        }

        return invoice;
    }
}