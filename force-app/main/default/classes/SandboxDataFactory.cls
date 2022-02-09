public without sharing class SandboxDataFactory {
  public static List<String> companies = new List<String>{
    'Broadcom',
    'Netware Inc.',
    'Activex',
    'Silverlight Inc.'
  };

  public static List<String> paymentRefferalCompanies = new List<String>{
    'Refferal Acc.',
    'Acсount Reffaral'
  };

  public static List<Decimal> paymentRefferalRate = new List<Decimal>{
    10,
    11
  };

  public static List<String> paymentSubcontractorCompanies = new List<String>{
    'Subcontractor Acc.',
    'Account Subcontractor'
  };

  public static List<Decimal> paymentCommissionRate = new List<Decimal>{
    12,
    13
  };


  public static List<Decimal> paymentSubcontractorRate = new List<Decimal>{
    14,
    15
  };
  

  public static String patternProductName = 'Development%';

  public static List<String> products = new List<String>{
    'Development',
    'Testing'
  };

  public static List<String> contacts = new List<String>{
    'Johnny Wood',
    'Ellis Morton'
  };

  public static String patternPricebookName = 'pb%';

  public static List<String> pricebooks = new List<String>{
    'pb 1',
    'pb 2',
    'pb 3',
    'pb 4',
    'pb 5',
    'pb 6',
    'pb 7',
    'pb 8'
  };

  public static List<String> datesForExpense = new List<String>{
    '2019-11-20',
    '2019-12-09',
    '2019-12-22',
    '2019-01-11',
    '2020-01-22'
  };

  public static List<String> usersIdsFromSandbox = new List<String>{
    '005f200000A6s4lAAB', // tempdev
    '005f200000A69NkAAJ' // dmytsko
  };

  public static String patternUserName = '%example%';
  
  public static Integer startYear = 2019;
  public static Integer startMonth = 11;
  public static Integer startDay = 1;

  public static Integer countTimesheetEntry = 150;

  public static Integer daysInTimesheetPeriod = 10;
  public static Integer timesheetsPerContractResource = 7;

  public static void insertAccounts(List<String> companies) {
      List<Account> accountList = new List<Account>();
      List<String> listCompanies = companies;
      Integer sizeCompanyList = listCompanies.size();

      for(Integer i = 0; i < sizeCompanyList; i++) {
          Account acc = new Account(Name=listCompanies.get(i));
          accountList.add(acc);
      }

      insert accountList;
  }

  public static void insertProducts() {
      List<Product2> productList = new List<Product2>();
      List<String> listProducts = products;
      Integer sizeProductList = listProducts.size();

      for(Integer i = 0; i < sizeProductList; i++) {
          Product2 pr = new Product2(Name=listProducts.get(i),isActive=true);
          productList.add(pr);
      }

      insert productList;
  }

  public static void insertPricebooks() {
      List<Pricebook2> priceBookList = new List<Pricebook2>();
      List<String> listPricebooks = pricebooks;
      Integer sizePricebooks = listPricebooks.size();

      for(Integer i = 0; i < sizePricebooks; i++) {
          Pricebook2 pb = new Pricebook2();
          pb.Name = listPricebooks.get(i);
          pb.IsActive = true;
          priceBookList.add(pb);
      }

      insert priceBookList;
  }

  public static void insertContacts(List<User> listUser) {
      List<Contact> contactList = new List<Contact>();
      List<String> listContact = contacts;
      Integer sizeContacts = listContact.size();

      for(Integer i = 0; i < sizeContacts; i++) {
          Contact contact = new Contact();
          contact.Lastname = listContact.get(i);
          contact.OwnerId = (listUser.get(i)).id;
          contact.Email = 'info' + i + '@example.com';

          contactList.add(contact);
      }

      insert contactList;
  }

  //SANDBOX
  public static List<Account> getAccountsFromDb(List<String> companies) {
      return [SELECT Id FROM Account WHERE Name IN :companies];
  }

  public static List<Contact> getContactsFromDb(List<String> contacts) {
      return [SELECT Id FROM Contact WHERE Lastname IN :contacts];
  }

  public static List<Contact> getContactsByUserFromDb(String userId) {
      return [SELECT Id,Lastname,OwnerId,Email FROM Contact WHERE OwnerId = :userId];
  }

  public static List<Timesheet_Entry__c> getTimesheetEntryFromDbByParams(Date startDate, Date endDate, String contractResourceId, String employeeId) {
      return [
            SELECT
                 Id,
                 TimesheetId__c
            FROM 
                 Timesheet_Entry__c 
            WHERE
                 Employee__c = :employeeId
            AND 
                 Date__c >= :startDate
            AND 
                 Date__c <= :endDate
            AND 
                 Contract_Resource__c = :contractResourceId              
      ];
  }

  public static List<Contract_Resource__c> getContractResourcesFromDb() {
      return [SELECT Id, Contract__c, Employee__c FROM Contract_Resource__c];
  }

  public static List<Pricebook2> getPricebooksFromDb() {
    return [SELECT Id FROM Pricebook2 WHERE isStandard=false AND Name LIKE :patternPricebookName];
  }

  public static List<Product2> getProductsFromDb() {
    return [SELECT Id, Name FROM Product2  WHERE Name IN :products];
  }

  public static List<User> getUsersFromDb() {
    return [SELECT id FROM User WHERE Username LIKE :patternUserName];
  }

  public static List<Timesheet__c> getTimesheetsFromDb() {
    return [SELECT Id FROM Timesheet__c];
  }

  public static List<Expense_Entry__c> getExpenseEntriesFromDb() {
      return [SELECT Id, Contract_Resource__c, Date__c, Amount__c, Description__c FROM Expense_Entry__c];
  }

  public static List<Contract> getContractsFromDb() {
      return [SELECT Id, AccountId FROM Contract];
  }

  public static List<Timesheet_Entry__c> getTimesheetEntryFromDb() {
    return [SELECT Id FROM Timesheet_Entry__c];
  }

  public static Decimal getRandMinutes() {
    Decimal minutes = 10 + (Integer) (Math.random() * 200);

    return minutes;
  }

  public static void insertTimesheets() {
    Date startDate = date.newInstance(startYear, startMonth, startDay);
    Date endDate = startDate.addDays(daysInTimesheetPeriod);

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb();
    for(Contract_Resource__c contractResource : contractResources) {
      for(Integer i = 1; i <= timesheetsPerContractResource; i++) {
        List<Timesheet_Entry__c> listTimesheetEntries = getTimesheetEntryFromDbByParams(startDate,endDate,contractResource.Id,contractResource.Employee__c);
        Boolean existTimesheet = false;

        if(listTimesheetEntries.size() > 0) {
            for(Timesheet_entry__c entry : listTimesheetEntries) {
                if(entry.TimesheetId__c != null) {
                    existTimesheet = true;
                    break;
                }
            }

            if(!existTimesheet) {
                Timesheet__c timesheet = new Timesheet__c();
                timesheet.OwnerId = contractResource.Employee__c;
                timesheet.StartDate__c = StartDate;
                timesheet.EndDate__c = EndDate;
                timesheet.CreatedDate__c = Datetime.now();
                timesheet.LastModifiedDate__c = Datetime.now();

                insert timesheet;

                List<Timesheet_entry__c> listTimesheetEntriesToUpdate = new List<Timesheet_entry__c>();

                for(Timesheet_entry__c entry : listTimesheetEntries){
                    entry.TimesheetId__c = timesheet.id;
                    listTimesheetEntriesToUpdate.add(entry);
                }

                update listTimesheetEntriesToUpdate;
            }   

            startDate = endDate.addDays(1);
            endDate = startDate.addDays(daysInTimesheetPeriod);
        }  
      }  
      startDate = date.newInstance(startYear, startMonth, startDay);
      endDate = startDate.addDays(daysInTimesheetPeriod);
    }
  }

  public static void insertTestData() {
    insertAccounts(companies);
    List<Account> listAccounts = getAccountsFromDb(companies);
    insertAccounts(paymentRefferalCompanies);
    List<Account> paymentRefferalAccounts = getAccountsFromDb(paymentRefferalCompanies);
    insertAccounts(paymentSubcontractorCompanies);
    List<Account> paymentSubcontractorAccounts = getAccountsFromDb(paymentSubcontractorCompanies);

    insertPricebooks();
    List<Pricebook2> listPricebooks = getPricebooksFromDb();

    insertProducts();
    List<Product2> listProducts = getProductsFromDb();

    List<User> listUsers = getUsersFromDb();

    insertContacts(listUsers);

    for(Integer k = 0; k <= 1; k++) {
        User user = listUsers[k];
        user.Subcontractor_Rate__c = paymentSubcontractorRate[k];

        update user;
    }

    Map<String, String> config = new Map<String, String> {
        listProducts[0].id => listUsers[0].id,
        listProducts[1].id => listUsers[1].id
    };

    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
    integer j = 0;
    integer p = 0;

    for(Account account: listAccounts) {
      for(Product2 product : listProducts) {
            String pricebookId = listPricebooks[j].id;
            j ++;

            Contract cntr = new Contract();
            cntr.AccountId = account.ID;
            cntr.Status = 'Draft';
            cntr.Pricebook2Id = pricebookId;
            cntr.Client_Manager__c = getContactsByUserFromDb((String)config.get(product.id))[0].id;
            if(p <= 1) {
              cntr.Referred_By__c	 = paymentRefferalAccounts[p].id;
              cntr.Referral_Rate__c = paymentRefferalRate[p];

              cntr.Salesperson__c	 = listUsers[p].id;
              cntr.Commission_Rate__c = paymentCommissionRate[p];
            }

            insert cntr;
            cntr.Status = 'Activated';
            update cntr;

            List<PricebookEntry> hasPricebookEntryStandard = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id =: standardPB.id AND Product2Id =: product.id];
            
            if(hasPricebookEntryStandard.isEmpty()) {
                PricebookEntry pricebookEntryStandard = new PricebookEntry();            
                pricebookEntryStandard.IsActive = true;
                pricebookEntryStandard.UnitPrice = 20 + (Integer) (Math.random() * 50);
                pricebookEntryStandard.Pricebook2Id = standardPB.id;
                pricebookEntryStandard.Product2Id = product.id;
                pricebookEntryStandard.UseStandardPrice = false;

                insert pricebookEntryStandard;
            }

            PricebookEntry pricebookEntry = new PricebookEntry();            
            pricebookEntry.IsActive = true;
            pricebookEntry.UnitPrice = 20 + (Integer) (Math.random() * 50);
            pricebookEntry.Pricebook2Id = pricebookId;
            pricebookEntry.Product2Id = product.id;
            pricebookEntry.UseStandardPrice = false;
            
            insert pricebookEntry;

            if(config.containsKey(product.id)) {

              Contract_Resource__c cr = new Contract_Resource__c();
              cr.Contract__c = cntr.Id;
              cr.Employee__c = (String)config.get(product.id);
     
              if(p <= 1) {
                cr.Subcontractor_Account__c = paymentSubcontractorAccounts[p].id;
              }

              insert cr;
 
              p++;

              Date currentDay = date.newInstance(startYear, startMonth, startDay);
 
              List<Expense_Entry__c> listExpenseEntries = new List<Expense_Entry__c>();
                  for(String d : datesForExpense) {
                    Expense_Entry__c expenseEntry = new Expense_Entry__c();

                    expenseEntry.Contract_Resource__c = cr.id;
                    expenseEntry.Date__c = Date.valueOf(d);
                    expenseEntry.Submittal_Date__c = Date.valueOf(d);
                    expenseEntry.Amount__c = Math.random()*50 + 0.3;
                    expenseEntry.Invoiced_Amount__c = Math.random()*50 + 0.3;
                    expenseEntry.Description__c = 'McDonalds №'+ Math.round(Math.random()*100);
                    expenseEntry.Type__c = 'Meal';
                    expenseEntry.Is_Billable__c = true;

                    listExpenseEntries.add(expenseEntry);
                  } 
		  		
              insert listExpenseEntries; 
		  
              List<Timesheet_Entry__c> timesheetEntries = new List<Timesheet_Entry__c>();

              for(integer i = 1; i <= countTimesheetEntry; i++) {
                Timesheet_Entry__c tc = new Timesheet_Entry__c();
                tc.Date__c = currentDay.addDays(i);                
                tc.Minutes__c = getRandMinutes();
                tc.Product__c = product.Id;
                tc.Contract_Resource__c = cr.Id;
                tc.Employee__c = (String)config.get(product.id);
    
                timesheetEntries.add(tc);
              }
    
              insert timesheetEntries;
            }
	    }
    }
  }

  public static void insertTestDataForSandbox() {
    insertAccounts(companies);
    List<Account> listAccounts = getAccountsFromDb(companies);
    insertAccounts(paymentRefferalCompanies);
    List<Account> paymentRefferalAccounts = getAccountsFromDb(paymentRefferalCompanies);
    insertAccounts(paymentSubcontractorCompanies);
    List<Account> paymentSubcontractorAccounts = getAccountsFromDb(paymentSubcontractorCompanies);

    insertPricebooks();
    List<Pricebook2> listPricebooks = getPricebooksFromDb();

    insertProducts();
    List<Product2> listProducts = getProductsFromDb();

    List<User> listUsers = [SELECT id FROM User WHERE Id IN :usersIdsFromSandbox];

    for(Integer k = 0; k <= 1; k++) {
        User user = listUsers[k];
        user.Subcontractor_Rate__c = paymentSubcontractorRate[k];

        update user;
    }

    Map<String, String> config = new Map<String, String> {
        listProducts[0].id => listUsers[0].id,
        listProducts[1].id => listUsers[1].id
    };

    Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
    integer j = 0;
    integer p = 0;

    for(Account account: listAccounts) {
      for(Product2 product : listProducts) {
            String pricebookId = listPricebooks[j].id;
            j ++;

            Contract cntr = new Contract();
            cntr.AccountId = account.ID;
            cntr.Status = 'Draft';
            cntr.Pricebook2Id = pricebookId;
            if(p <= 1) {
              cntr.Referred_By__c	 = paymentRefferalAccounts[p].id;
              cntr.Referral_Rate__c = paymentRefferalRate[p];

              cntr.Salesperson__c	 = listUsers[p].id;
              cntr.Commission_Rate__c = paymentCommissionRate[p];
            }

            insert cntr;
            cntr.Status = 'Activated';
            update cntr;

            List<PricebookEntry> hasPricebookEntryStandard = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id =: standardPB.id AND Product2Id =: product.id];
            
            if(hasPricebookEntryStandard.isEmpty()) {
                PricebookEntry pricebookEntryStandard = new PricebookEntry();            
                pricebookEntryStandard.IsActive = true;
                pricebookEntryStandard.UnitPrice = 20 + (Integer) (Math.random() * 50);
                pricebookEntryStandard.Pricebook2Id = standardPB.id;
                pricebookEntryStandard.Product2Id = product.id;
                pricebookEntryStandard.UseStandardPrice = false;

                insert pricebookEntryStandard;
            }

            PricebookEntry pricebookEntry = new PricebookEntry();            
            pricebookEntry.IsActive = true;
            pricebookEntry.UnitPrice = 20 + (Integer) (Math.random() * 50);
            pricebookEntry.Pricebook2Id = pricebookId;
            pricebookEntry.Product2Id = product.id;
            pricebookEntry.UseStandardPrice = false;
            
            insert pricebookEntry;

            if(config.containsKey(product.id)) {

              Contract_Resource__c cr = new Contract_Resource__c();
              cr.Contract__c = cntr.Id;
              cr.Employee__c = (String)config.get(product.id);
     
              if(p <= 1) {
                cr.Subcontractor_Account__c = paymentSubcontractorAccounts[p].id;
              }

              insert cr;
 
              p++;

              Date currentDay = date.newInstance(startYear, startMonth, startDay);
 
              List<Expense_Entry__c> listExpenseEntries = new List<Expense_Entry__c>();
                  for(String d : datesForExpense) {
                    Expense_Entry__c expenseEntry = new Expense_Entry__c();

                    expenseEntry.Contract_Resource__c = cr.id;
                    expenseEntry.Date__c = Date.valueOf(d);
                    expenseEntry.Submittal_Date__c = Date.valueOf(d);
                    expenseEntry.Amount__c = Math.random()*50 + 0.3;
                    expenseEntry.Invoiced_Amount__c = Math.random()*50 + 0.3;
                    expenseEntry.Description__c = 'McDonalds №'+ Math.round(Math.random()*100);
                    expenseEntry.Type__c = 'Meal';
                    expenseEntry.Is_Billable__c = true;

                    listExpenseEntries.add(expenseEntry);
                  } 
		  		
              insert listExpenseEntries; 
		  
              List<Timesheet_Entry__c> timesheetEntries = new List<Timesheet_Entry__c>();

              for(integer i = 1; i <= countTimesheetEntry; i++) {
                Timesheet_Entry__c tc = new Timesheet_Entry__c();
                tc.Date__c = currentDay.addDays(i);                
                tc.Minutes__c = getRandMinutes();
                tc.Product__c = product.Id;
                tc.Contract_Resource__c = cr.Id;
                tc.Employee__c = (String)config.get(product.id);
    
                timesheetEntries.add(tc);
              }
    
              insert timesheetEntries;
            }
	    }
    }
  }

  public static void deleteTestData() {
    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntryFromDb();
    delete timesheetEntries;

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb();
    delete contractResources;

    List<Timesheet__c> timesheets = getTimesheetsFromDb();
    delete timesheets;

    List<Expense_Entry__c> expenseEntries = getExpenseEntriesFromDb();
    delete expenseEntries;

    List<Product2> products = getProductsFromDb();
    delete products;

    List<Contract> contracts = getContractsFromDb();
    delete contracts;

    List<Contact> contactsList = getContactsFromDb(contacts);
    delete contactsList;

    List<Pricebook2> pricebooks = getPricebooksFromDb();
    delete pricebooks;

    List<String> allCompanies = new List<String>();
    allCompanies.addAll(companies);
    allCompanies.addAll(paymentRefferalCompanies);
    allCompanies.addAll(paymentSubcontractorCompanies);

    List<Account> accounts = getAccountsFromDb(allCompanies);
    delete accounts;
  }
}