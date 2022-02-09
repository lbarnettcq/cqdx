public without sharing class DIPaymentsTestDataFactory {
  public static final String PAYMENT_TYPE_NOT_EXIST = 'PaymentTypeNotExist';  

  public static final Integer PAYMENTS_COUNT = 10; 

  public static final String PAYMENT_STATUS_NEW = 'New';
  public static final String PAYMENT_STATUS_PAID = 'Paid';

  public static final String PAYMENT_TYPE_SUBCONTRACTOR = 'Subcontractor';
  public static final String PAYMENT_TYPE_COMMISIONS = 'Commissions';
  public static final String PAYMENT_TYPE_REFERRAL = 'Referral';
  public static final String PAYMENT_TYPE_EXPENSES_REIMBURSEMENT = 'Expenses Reimbursement';

  public static final String DATE_START_WITHOUT_PAYMENTS = '2019-12-09';
  public static final String DATE_END_WITHOUT_PAYMENTS = '2019-12-15';

  public static void init() {
    DIInvoicesTestDataFactory.init();
    insertPayments();
  }

  public static void insertPayments() {
    List<Payment__c> payments = new List<Payment__c>();
    Map<String, Object> mapPayments = new Map<String, Object>();

    List<Invoice__c> invoices = DIInvoicesTestDataFactory.getInvoicesFromDB(new List<String>{DIInvoicesTestDataFactory.INVOICE_STATUS_PENDING, DIInvoicesTestDataFactory.INVOICE_STATUS_PAID});
    Set<String> timesheetsIds = new Set<String>();

    Map<String, Object> mapTimesheets = new Map<String, Object>();

    for(Invoice__c invoice : invoices) {
      Date startDate = invoice.StartDate__c;
      Date endDate = invoice.EndDate__c;

      if(endDate < Date.valueOf(DATE_START_WITHOUT_PAYMENTS) || startDate > Date.valueOf(DATE_END_WITHOUT_PAYMENTS)) {
        mapPayments.put(startDate + '_' + endDate, new Map<String, Object>{
          'startDate' => startDate,
          'endDate' => endDate,
          'subcontractors' => new Map<String, Object>{
            'receivers' => new Map<String, Object>()
          },
          'referrals' => new Map<String, Object>{
            'receivers' => new Map<String, Object>()
          },
          'commissions' => new Map<String, Object>{
            'receivers' => new Map<String, Object>()
          },
          'expensesReimbursements' => new Map<String, Object>{
            'receivers' => new Map<String, Object>()
          }    
        });

        for(Invoice_Line_Item__c invoiceLineItem : invoice.Invoice_Line_Items__r) {
          timesheetsIds.add(invoiceLineItem.Timesheet__c);
        }
      }
    }

    Map<String, Decimal> rates = getEmployeesRates();

    List<Timesheet_Entry__c> timesheetEntries = TestDataFactory.getTimesheetEntriesFromDBByTimesheets(timesheetsIds);


    for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
      for(String keyDate : mapPayments.keySet()) {
        Map<String, Object> mapDate = (Map<String, Object>)mapPayments.get(keyDate);

        Date startDate = (Date)mapDate.get('startDate');
        Date endDate = (Date)mapDate.get('endDate');

        if(startDate <= timesheetEntry.Date__c && timesheetEntry.Date__c <= endDate) {
          Map<String, Object> subcontractors = (Map<String, Object>)mapDate.get('subcontractors');
          Map<String, Object> receivers = (Map<String, Object>)subcontractors.get('receivers');

          processingPayments(
            payments,
            timesheetEntry, 
            PAYMENT_TYPE_SUBCONTRACTOR, 
            receivers,
            timesheetEntry.Contract_Resource__r.Subcontractor_Account__c,
            startDate, 
            endDate,
            rates
            );

          Map<String, Object> referrals = (Map<String, Object>)mapDate.get('referrals');
          receivers = (Map<String, Object>)referrals.get('receivers');
          processingPayments(payments, timesheetEntry, PAYMENT_TYPE_REFERRAL, receivers, timesheetEntry.Contract_Resource__r.Contract__r.Referred_By__c, startDate, endDate, rates);

          Map<String, Object> commissions = (Map<String, Object>)mapDate.get('commissions');
          receivers = (Map<String, Object>)commissions.get('receivers');
          processingPayments(payments, timesheetEntry, PAYMENT_TYPE_COMMISIONS, receivers, timesheetEntry.Contract_Resource__r.Contract__r.Salesperson__c, startDate, endDate, rates);
        }
      }
    }

    List<Contract_Resource__c> contractResources = TestDataFactory.getContractResourcesFromDb();
    Map<String, List<String>> employees = new Map<String, List<String>>();

    for(Contract_Resource__c contractResource : contractResources) {
      String employeeId = contractResource.Employee__c;
      List<String> ids = employees.get(employeeId);

      if(ids == null) {
        ids = new List<String>{contractResource.Id};
        employees.put(employeeId, ids);
      } else {
        ids.add(contractResource.Id);
      }
    }


    List<Expense_Entry__c> expenseEntries = TestDataFactory.getExpenseEntriesFromDb();

    for(String receiverId : employees.keySet()) {
      for(String keyDate : mapPayments.keySet()) {
        Map<String, Object> mapDate = (Map<String, Object>)mapPayments.get(keyDate);

        Date startDate = (Date)mapDate.get('startDate');
        Date endDate = (Date)mapDate.get('endDate');

        Map<String, Object> expensesReimbursements = (Map<String, Object>)mapDate.get('expensesReimbursements');
        Map<String, Object> receivers = (Map<String, Object>)expensesReimbursements.get('receivers');
        Map<String, Object> receiver = (Map<String, Object>)receivers.get(receiverId);

        Payment__c payment = new Payment__c();
        payment.Payment_type__c = PAYMENT_TYPE_EXPENSES_REIMBURSEMENT;
        payment.StartDate__c = startDate;
        payment.EndDate__c = endDate;
        payment.Status__c = PAYMENT_STATUS_NEW;
        payment.Last_updated__c = endDate;
        payment.Is_Paid_Invoices__c = true;
        payment.Is_Pending_invoices__c = true;
        payment.ReceiverId__c = receiverId;
        
        payment.Pending_invoices_startDate__c = startDate;

        payment.Total_Minutes__c = 0;

        payment.Total_Amount__c = getExpensesReimbursement(receiverId, employees.get(receiverId), payment.StartDate__c, payment.EndDate__c, expenseEntries);

        receiver = new Map<String, Object> {
          'payment' => payment,
          'paymentLineItems' => new Map<String, Object>()
        };

        payments.add(payment);
      }
    }

    Map<String, String> statuses = new Map<String, String>{
      'new' => 'paid',
      'paid' => 'new'
    };

    String currentStatus = 'new';

    for(Payment__c payment : payments) {
      if(currentStatus == 'new') {
        payment.Status__c = PAYMENT_STATUS_NEW;
      } else {
        payment.Status__c = PAYMENT_STATUS_PAID;
      }

      currentStatus = statuses.get(currentStatus);
    }

    insert payments;

    /*System.debug('--DEBUG--SHOW--LOG--payments' + payments);

    for(Payment__c payment : payments) {
      System.debug('--DEBUG--SHOW--LOG--Payment__c' + payment);
    }*/

    List<Payment_Line_Item__c> paymentLineItems = new List<Payment_Line_Item__c>();

    for(String keyDate : mapPayments.keySet()) {
      Map<String, Object> mapDate = (Map<String, Object>)mapPayments.get(keyDate);

      Map<String, Object> receiverData = (Map<String, Object>)mapDate.get('subcontractors');
      Map<String, Object> receivers = (Map<String, Object>)receiverData.get('receivers');

      for(String keyReceiver : receivers.keySet()) {//TODO:extract to method: remove duplicate
        Map<String, Object> receiver = (Map<String, Object>)receivers.get(keyReceiver);

        Payment__c payment = (Payment__c)receiver.get('payment');
        Map<String, Object> plis = (Map<String, Object>)receiver.get('paymentLineItems');
        //System.debug('--DEBUG--SHOW--LOG--plis' + plis);
        for(String keyPLI : plis.keySet()) {
          Payment_Line_Item__c paymentLineItem = (Payment_Line_Item__c)plis.get(keyPLI);
          paymentLineItem.Payment__c = payment.Id;
          paymentLineItems.add(paymentLineItem);
        }
      }

      receiverData = (Map<String, Object>)mapDate.get('referrals');
      receivers = (Map<String, Object>)receiverData.get('receivers');

      for(String keyReceiver : receivers.keySet()) {
        Map<String, Object> receiver = (Map<String, Object>)receivers.get(keyReceiver);

        Payment__c payment = (Payment__c)receiver.get('payment');
        Map<String, Object> plis = (Map<String, Object>)receiver.get('paymentLineItems');
        for(String keyPLI : plis.keySet()) {
          Payment_Line_Item__c paymentLineItem = (Payment_Line_Item__c)plis.get(keyPLI);
          paymentLineItem.Payment__c = payment.Id;
          paymentLineItems.add(paymentLineItem);
        }
      }

      receiverData = (Map<String, Object>)mapDate.get('commissions');
      receivers = (Map<String, Object>)receiverData.get('receivers');

      for(String keyReceiver : receivers.keySet()) {
        Map<String, Object> receiver = (Map<String, Object>)receivers.get(keyReceiver);

        Payment__c payment = (Payment__c)receiver.get('payment');
        Map<String, Object> plis = (Map<String, Object>)receiver.get('paymentLineItems');
        for(String keyPLI : plis.keySet()) {
          Payment_Line_Item__c paymentLineItem = (Payment_Line_Item__c)plis.get(keyPLI);
          paymentLineItem.Payment__c = payment.Id;
          paymentLineItems.add(paymentLineItem);
        }
      }
    }

    insert paymentLineItems;

   /*System.debug('--DEBUG--SHOW--LOG--paymentLineItems' + paymentLineItems);

    for(Payment_Line_Item__c payment : paymentLineItems) {
      System.debug('--DEBUG--SHOW--LOG--Payment_Line_Item__c' + payment);
    }*/
  }

  public static void processingPayments(
    List<Payment__c> payments,
    Timesheet_Entry__c timesheetEntry, 
    String paymentType, 
    Map<String, Object> receivers, 
    Id receiverId,
    Date startDate,
    Date endDate,
    Map<String, Decimal> rates
  ) {
    if(receiverId != null) {
      Map<String, Object> receiver = (Map<String, Object>)receivers.get((String)receiverId);

      Payment__c payment = null;
      Map<String, Object> paymentLineItems = null;

      if(receiver == null) {
        payment = new Payment__c();
        payment.Payment_type__c = paymentType;
        payment.StartDate__c = startDate;
        payment.EndDate__c = endDate;
        payment.Status__c = PAYMENT_STATUS_NEW;
        payment.Last_updated__c = endDate;
        payment.Is_Paid_Invoices__c = true;
        payment.Is_Pending_invoices__c = true;
        payment.ReceiverId__c = receiverId;
        
        payment.Pending_invoices_startDate__c = startDate;

        payment.Total_Amount__c = 0;
        payment.Total_Minutes__c = 0;

        paymentLineItems = new Map<String, Object>();

        receiver = new Map<String, Object> {
          'payment' => payment,
          'paymentLineItems' => paymentLineItems
        };

        receivers.put((String)receiverId, receiver);

        payments.add(payment);
      } else {
        payment = (Payment__c)receiver.get('payment');
        paymentLineItems = (Map<String, Object>)receiver.get('paymentLineItems');
      }
      
      Payment_Line_Item__c paymentLineItem = (Payment_Line_Item__c)paymentLineItems.get(timesheetEntry.Contract_Resource__c);

      if(paymentLineItem == null) {
        paymentLineItem = new Payment_Line_Item__c();
        paymentLineItem.Contract_Resource__c = timesheetEntry.Contract_Resource__c;
        paymentLineItem.Minutes__c = 0;
        paymentLineItem.Amount__c = 0;
        //paymentLineItem.Payment__c = null;
        //System.debug('--DEBUG--SHOW--LOG--Payments--employeeOnePercentRate' + timesheetEntry.Contract_Resource__c + '____' + rates.get(timesheetEntry.Contract_Resource__c));
        Decimal employeeOnePercentRate = (rates.get(timesheetEntry.Contract_Resource__c))/100;

        switch on payment.Payment_type__c {
            when 'Subcontractor' {                  
                paymentLineItem.Rate__c = timesheetEntry.Employee__r.Subcontractor_Rate__c != null ? timesheetEntry.Employee__r.Subcontractor_Rate__c : 0;
            }
            when 'Referral' {                    
                paymentLineItem.Rate__c = timesheetEntry.Contract_Resource__r.Contract__r.Referral_Rate__c != null ? employeeOnePercentRate*timesheetEntry.Contract_Resource__r.Contract__r.Referral_Rate__c : 0;
            }
            when 'Commissions' {                    
                paymentLineItem.Rate__c = timesheetEntry.Contract_Resource__r.Contract__r.Commission_Rate__c != null ? employeeOnePercentRate*timesheetEntry.Contract_Resource__r.Contract__r.Commission_Rate__c : 0;
            }
        }

        paymentLineItems.put(timesheetEntry.Contract_Resource__c, paymentLineItem);
      }

      payment.Total_Amount__c -= paymentLineItem.Amount__c;
      payment.Total_Minutes__c -= paymentLineItem.Minutes__c;

      paymentLineItem.Minutes__c += timesheetEntry.Minutes__c;
      paymentLineItem.Amount__c = paymentLineItem.Rate__c*(timesheetEntry.Minutes__c/60);

      payment.Total_Amount__c += paymentLineItem.Amount__c;
      payment.Total_Minutes__c += paymentLineItem.Minutes__c;
    }
  }

  public static Map<String, Decimal> getEmployeesRates() {
      Map<String, Decimal> rates = new Map<String, Decimal>();

      List<Contract_Resource__c> contarctResources = TestDataFactory.getContractResourcesFromDB();

      for(Contract_Resource__c cr : contarctResources) {
        rates.put(cr.Id, cr.Rate__c);
      }

      //System.debug('--DEBUG--SHOW--LOG--Payments--rates' + rates);
      return rates;
  }

  public static Decimal getEmployeeRate(String contractResourceId) {
      Decimal employeeRate = 0;

      Contract_Resource__c contractResource = [SELECT Contract__c, Employee__c, Rate__c FROM Contract_Resource__c WHERE Contract__c = :contractResourceId LIMIT 1];

      if(contractResource != null) {
        employeeRate = contractResource.Rate__c;
      }

      return employeeRate;
  }

  public static Decimal getExpensesReimbursement(String employeeId, List<String> contractResourcesIds, Date startDate, Date endDate, List<Expense_Entry__c> expenseEntries) {
    Map<String, Object> conditions = new Map<String, Object> {
        'startDate' => startDate,
        'endDate' => endDate,
        'contractResourcesIds' => new Set<String>(contractResourcesIds)
    };

    Decimal totalAmount = DIInvoicesTestDataFactory.getTotalAmountExpenseEntries(expenseEntries, conditions);

    return totalAmount;
  }

  public static AggregateResult getExpensesAmount(Map<String, Object> conditions) {
    Date startDate = (Date)conditions.get('startDate');
    Date endDate = (Date)conditions.get('endDate');
    Set<String> contractResourcesIds = (Set<String>)conditions.get('contractResourcesIds');

    AggregateResult expenseEntries = [
      SELECT 
        SUM(Amount__c) amount 
      FROM   
        Expense_Entry__c  
      WHERE  
        Date__c >= :startDate 
      AND  
        Date__c <= :endDate            
      AND  
        Contract_Resource__c IN :contractResourcesIds
    ]; 

    return expenseEntries;
  }

  public static List<Payment__c> getPaymentsFromDB() {
    List<Payment__c> payments = [
      SELECT 
        Id, 
        Payment_type__c,
        StartDate__c,
        EndDate__c,
        Status__c,
        Last_updated__c,
        Is_Paid_Invoices__c,
        Is_Pending_invoices__c,
        ReceiverId__c,
        Pending_invoices_startDate__c,
        Total_Minutes__c,
        Total_Amount__c,
        (SELECT Id, Contract_Resource__c, Rate__c, Minutes__c, Amount__c, Payment__c FROM Payment_Line_Items__r) 
      FROM 
        Payment__c
      ];

    return payments;
  }

  public static List<Payment__c> getPaymentsFromDB(List<String> statuses) {
    List<Payment__c> payments = [
      SELECT 
        Id, 
        Payment_type__c,
        StartDate__c,
        EndDate__c,
        Status__c,
        Last_updated__c,
        Is_Paid_Invoices__c,
        Is_Pending_invoices__c,
        ReceiverId__c,
        Pending_invoices_startDate__c,
        Total_Minutes__c,
        Total_Amount__c,
        (SELECT Id, Contract_Resource__c, Rate__c, Minutes__c, Amount__c, Payment__c FROM Payment_Line_Items__r) 
      FROM 
        Payment__c
      WHERE 
        Status__c IN :statuses
      ];

    return payments;
  }

  public static Payment__c getPayment() {
    List<Payment__c> payments = getPaymentsFromDB();

    if(payments.isEmpty()) {
      return null;
    }
    return payments[0];
  }

  public static Payment__c getPayment(String status) {
    List<Payment__c> payments = getPaymentsFromDB(new List<String>{status});

    if(payments.isEmpty()) {
      return null;
    }
    return payments[0];
  }

  public static List<Payment__c> getPaymentsByType(String type) {
    List<Payment__c> payments = [
      SELECT 
        Id, 
        Payment_type__c,
        StartDate__c,
        EndDate__c,
        Status__c,
        Last_updated__c,
        Is_Paid_Invoices__c,
        Is_Pending_invoices__c,
        ReceiverId__c,
        Pending_invoices_startDate__c,
        Total_Minutes__c,
        Total_Amount__c,
        (SELECT Id, Contract_Resource__c, Rate__c, Minutes__c, Amount__c, Payment__c FROM Payment_Line_Items__r) 
      FROM 
        Payment__c
      WHERE 
        Payment_type__c = :type
      ];

    return payments;
  }

  public static Map<String, Object> getNewPayment() {
    return getNewPayment(null);
  }

  public static Map<String, Object> getNewPayment(String type) {
    if(type == null) {
      type = PAYMENT_TYPE_SUBCONTRACTOR;
    }

    Map<String, Object> item = new Map<String, Object>{
        'paymentType' => type,
        'receiverId' => getReceiverId(type),
        'startDate' => Date.valueOf(DATE_START_WITHOUT_PAYMENTS),
        'endDate' => Date.valueOf(DATE_END_WITHOUT_PAYMENTS),
        'paidInvoices' => true,
        'pendingInvoices' => true,
        'pendingInvoicesStartDate' => Date.valueOf(DATE_START_WITHOUT_PAYMENTS)
    };

    return item;
  }

  public static String getReceiverId(String paymentType) {
    String receiverId = null;

    switch on paymentType {
      when 'Subcontractor', 'Referral' {
        List<Account> accounts = TestDataFactory.getAccountsFromDb();
        receiverId = accounts.get(0).Id;
      }
      when 'Commissions', 'Expenses Reimbursement' {                    
        receiverId = UserInfo.getUserId();
      }
    } 


    return receiverId;
  }
}