public without sharing class DIInvoicesTestDataFactory { 
  public static final Integer INVOICES_COUNT = 10;
  public static final Integer INVOICES_LIST_ITEMS_COUNT = 10;  
  

  public static final String INVOICE_STATUS_NEW = 'New';
  public static final String INVOICE_STATUS_PENDING = 'Pending';
  public static final String INVOICE_STATUS_PAID = 'Paid';

  public static final String DATE_START_WITHOUT_INVOICES = '2019-12-02';
  public static final String DATE_END_WITHOUT_INVOICES = '2019-12-08';

  public static void init() {
    DIInvoicesTestDataFactory.init(false);
  }

  public static void init(Boolean createAllInvoices) {
    TestDataFactory.init();
    insertInvoices(null, createAllInvoices);
  }

  public static void insertInvoices(List<Timesheet__c> timesheets, Boolean createAllInvoices) {
    if(timesheets == null || timesheets.isEmpty()) {
      timesheets = TestDataFactory.getTimesheetsFromDB(TestDataFactory.TIMESHEET_STATUS_APPROVED);
    }

    Set<String> timesheetsIds = new Set<String>();
    Map<String, Object> mapTimesheets = new Map<String, Object>();

    for(Timesheet__c timesheet : timesheets) {
      if(createAllInvoices || (Date.valueOf(DATE_END_WITHOUT_INVOICES) <= timesheet.StartDate__c || timesheet.EndDate__c <= Date.valueOf(DATE_START_WITHOUT_INVOICES))) {
        timesheetsIds.add(timesheet.Id);
        Map<String, Object> ts = new Map<String, Object>{
          'startDate' => timesheet.StartDate__c,
          'endDate' => timesheet.EndDate__c,
          'totalMinutes' => 0,
          'totalAmount' => 0,
          'totalExpenses' => 0,
          'rate' => 0,
          'timesheetId' => timesheet.Id,
          'accountId' => null
        };

        mapTimesheets.put(timesheet.Id, ts);
      }
    }

    //timesheets.clear();      
    List<Expense_Entry__c> expenseEntries = TestDataFactory.getExpenseEntriesFromDb();

    List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(timesheetsIds);

    for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
      Map<String, Object> ts = (Map<String, Object>)mapTimesheets.get(timesheetEntry.TimesheetId__c);

      if(ts != null) {
        Decimal totalMinutes = (Decimal)ts.get('totalMinutes') + timesheetEntry.Minutes__c;
        ts.put('totalMinutes', totalMinutes);

        ts.put('accountId', timesheetEntry.Contract_Resource__r.Contract__r.AccountId);

        Decimal rate = 0;

        if(timesheetEntry.Contract_Resource__c != null && timesheetEntry.Contract_Resource__r.Rate__c != null) {
          rate = timesheetEntry.Contract_Resource__r.Rate__c;
        }

        ts.put('totalAmount', (totalMinutes/60) * rate);  

        Map<String, Object> conditions = new Map<String, Object> {
          'startDate' => (Date)ts.get('startDate'),
          'endDate'=> (Date)ts.get('endDate'),
          'listContractResourcesIds' => new Set<String>{timesheetEntry.Contract_Resource__c},
          'isBilliable' => true, 
          'isApproved' => true
        };

        ts.put('totalExpenses', getTotalAmountExpenseEntries(expenseEntries, conditions));//TODO:refactor: add into cache for get total
      }
    }

    List<Invoice__c> invoices = new List<Invoice__c>();
    Map<String, Object> mapInvoices = new Map<String, Object>();    

    Decimal totalAmount = 0;
    Decimal totalExpenses = 0;
    Integer totalMinutes = 0;

    Integer countInvoices = 0;

    Map<String, String> statuses = new Map<String, String>{
      'new' => 'pending',
      'pending' => 'paid',
      'paid' => 'new'
    };

    String currentStatus = 'new';

    for(String keyTimesheet : mapTimesheets.keySet()) {
      Map<String, Object> timesheet = (Map<String, Object>)mapTimesheets.get(keyTimesheet);
      Date startDate = (Date)timesheet.get('startDate');
      Date endDate = (Date)timesheet.get('endDate');
      String accountId = (String)timesheet.get('accountId');

      String key = accountId + '_' + startDate + '_' + endDate;

      Invoice__c invoice = null;
      Map<String, Object> mapInvoice = (Map<String, Object>)mapInvoices.get(key);      

      if(mapInvoice == null) {
        countInvoices++;

        invoice = new Invoice__c();
        invoice.Account__c = accountId;
        invoice.StartDate__c = startDate;
        invoice.EndDate__c = endDate;
        invoice.IssueDate__c = endDate;
        invoice.DueDate__c = endDate;
        invoice.Last_updated__c = endDate;
        invoice.Amount__c = 0;
        invoice.Expenses__c = 0;
        invoice.Minutes__c = 0;

        if(currentStatus == 'new') {
          invoice.Status__c = INVOICE_STATUS_NEW;
        } else if(currentStatus == 'pending') {
          invoice.Status__c = INVOICE_STATUS_PENDING;
        } else {
          invoice.Status__c = INVOICE_STATUS_PAID;
        }

        invoices.add(invoice);

        mapInvoice = new Map<String, Object>{
          'invoice' => invoice,
          'invoicesLineItems' => new List<Invoice_Line_Item__c>()
        };

        mapInvoices.put(key, mapInvoice);

        currentStatus = statuses.get(currentStatus);
      }

      Invoice_Line_Item__c  invoiceLineItem = new Invoice_Line_Item__c();
      invoiceLineItem.Timesheet__c = (String)timesheet.get('timesheetId');
      invoiceLineItem.Minutes__c = (Decimal)timesheet.get('totalMinutes');
      invoiceLineItem.Amount__c = (Decimal)timesheet.get('totalAmount');
      invoiceLineItem.Expenses__c = (Decimal)timesheet.get('totalExpenses');
      ((List<Invoice_Line_Item__c>)mapInvoice.get('invoicesLineItems')).add(invoiceLineItem);

      invoice = (Invoice__c)mapInvoice.get('invoice');
      invoice.Amount__c += invoiceLineItem.Amount__c ;
      invoice.Expenses__c += invoiceLineItem.Expenses__c;
      invoice.Minutes__c += invoiceLineItem.Minutes__c;
    }

    insert invoices;

    List<Invoice_Line_Item__c> invoiceLineItems = new List<Invoice_Line_Item__c>();

    for(Invoice__c invoice : invoices) {
        String key = invoice.Account__c + '_' + invoice.StartDate__c + '_' + invoice.EndDate__c;
        Map<String, Object> mapInvoice = (Map<String, Object>)mapInvoices.get(key);  

        List<Invoice_Line_Item__c> invoicesLineItems = (List<Invoice_Line_Item__c>)mapInvoice.get('invoicesLineItems');

        for(Invoice_Line_Item__c ili : invoicesLineItems) {
          ili.Invoice__c = invoice.Id;
          invoiceLineItems.add(ili);
        }
    }

    insert invoiceLineItems;
  }

  public static List<Invoice__c> getInvoicesFromDB() {
    List<Invoice__c> invoices = [
      SELECT 
        Id, 
        Status__c,
        StartDate__c,
        EndDate__c,
        IssueDate__c,
        DueDate__c,
        Account__c,
        Amount__c,
        Expenses__c,
        Minutes__c,
        (SELECT Id, Timesheet__c FROM Invoice_Line_Items__r) 
      FROM 
        Invoice__c
      ];

    return invoices;
  }

  public static List<Invoice__c> getInvoicesFromDB(List<String> statuses) {
    List<Invoice__c> invoices = [
      SELECT 
        Id, 
        Status__c,
        StartDate__c,
        EndDate__c,
        IssueDate__c,
        DueDate__c,
        Account__c,
        Amount__c,
        Expenses__c,
        Minutes__c,
        (SELECT Id, Timesheet__c FROM Invoice_Line_Items__r) 
      FROM 
        Invoice__c
      WHERE 
        Status__c IN :statuses
      ];

    return invoices;
  }

  public static List<Invoice_Line_Item__c> getInvoiceLineItemsFromDB() {
      List<Invoice_Line_Item__c> invoiceLineItems = [SELECT Id, Timesheet__c, Minutes__c, Amount__c, Expenses__c FROM Invoice_Line_Item__c];
      return invoiceLineItems;
  }

  public static Invoice__c getInvoice() {
    List<Invoice__c> invoices = getInvoicesFromDB();

    if(invoices.isEmpty()) {
            return null;
    }
    return invoices[0];
  }

  public static Invoice__c getInvoice(String status) {
    List<Invoice__c> invoices = getInvoicesFromDB(new List<String>{status});

    if(invoices.isEmpty()) {
            return null;
    }
    return invoices[0];
  }

  public static Map<String, Object> getNewInvoice() {
    List<Timesheet_entry__c> timesheetEntries = [
        SELECT  
            TimesheetId__c,
            Contract_Resource__r.Contract__r.AccountId
        FROM
            Timesheet_Entry__c
        WHERE
            TimesheetId__c != null
          AND
            Is_Approved__c = true
          AND
            Date__c >= :Date.valueOf(DATE_START_WITHOUT_INVOICES)
          AND
            Date__c <= :Date.valueOf(DATE_END_WITHOUT_INVOICES)
        LIMIT 1                
    ];

    Timesheet_entry__c timesheetEntry = timesheetEntries[0];

    Map<String, Object> newInvoice = new Map<String, Object>{
        'accountId' => timesheetEntry.Contract_Resource__r.Contract__r.AccountId,
        'startDate' => Date.valueOf(DATE_START_WITHOUT_INVOICES),
        'endDate' => Date.valueOf(DATE_END_WITHOUT_INVOICES),
        'issueDate' => Date.valueOf(DATE_END_WITHOUT_INVOICES),
        'dueDate' => Date.valueOf(DATE_END_WITHOUT_INVOICES)
    };

    return newInvoice;
  }

  public static Decimal getTotalAmountExpenseEntries(List<Expense_Entry__c> expenseEntries, Map<String, Object> conditions) {
    Date startDate = (Date)conditions.get('startDate');
    Date endDate = (Date)conditions.get('endDate');
    Set<String> contractResourcesIds = (Set<String>)conditions.get('contractResourcesIds');
    Boolean isApproved = (Boolean)conditions.get('isApproved');
    Boolean isBillable = (Boolean)conditions.get('isBillable');

    Decimal amount = 0;

    for(Expense_Entry__c ee : expenseEntries) {
      if(startDate <= ee.Submittal_Date__c && ee.Submittal_Date__c <= endDate &&
        ee.Is_Billable__c == isBillable && ee.Is_Approved__c == isApproved && 
        contractResourcesIds.contains(ee.Contract_Resource__c)) {
          amount += ee.Invoiced_Amount__c;
      }
    }

    return amount;
  }
}