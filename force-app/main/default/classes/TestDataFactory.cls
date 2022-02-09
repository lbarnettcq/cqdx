public without sharing class TestDataFactory {
  public static final String ID_NOT_EXIST = '0002D00000NotExist';
  public static final String NAME_NOT_EXIST = 'NameNotExist';
  public static final String STATUS_NOT_EXIST = 'StatusNotExist';  

  public static final Decimal MINUTES_150 = 150;

  public static final String DATE_FORMAT = 'yyyy-MM-dd';

  public static final String DATE_START_WITHOUT_DATA = '2020-01-13';
  public static final String DATE_END_WITHOUT_DATA = '2020-01-19';
  
  public static final String DATE_START = '2019-12-02';
  public static final String DATE_END = '2020-01-12';//2020-01-06

  public static final String DATE_START_WITHOUT_TIMESHEETS = '2020-01-06';
  public static final String DATE_END_WITHOUT_TIMESHEETS = '2020-01-12';
  
  public static final Decimal SUBCONTRACTOR_RATE = 3;
  public static final Decimal COMMISION_RATE = 3;
  public static final Decimal REFERRAL_RATE = 3;

  public static final Integer YEAR_DELTA = 1;

  public static final Integer USERS_COUNT = 10;//300
  public static final String USER_NAME_PATTERN = 'user%';
  public static final Map<String, Object> USER_PATTERN = new Map<String, Object>{
    'alias' => '',
    'email' => '',
    'emailEncodingKey' => 'UTF-8',
    'languageLocaleKey' => 'en_US',
    'localeSidKey' => 'en_US',
    'name' => 'user',
    'lastName' => 'lastname',
    'communityNickname' => '',
    'profileId' => '',
    'timeZoneSidKey' => 'America/Los_Angeles',
    'userName' => '',
    'domain' => 'domain.com'//local variable

  };
  public static List<Map<String, Object>> users = new List<Map<String, Object>>();

  public static final Integer ACCOUNTS_COUNT = 10;//300
  public static final String ACCOUNT_NAME_PATTERN = 'company%';
  public static final String ACCOUNT_STATUS_ACTIVE = 'Activated';
  public static final Map<String, Object> ACCOUNT_PATTERN = new Map<String, Object>{
    'name' => 'company'
  };
  public static List<Map<String, Object>> accounts = new List<Map<String, Object>>();

  public static final Integer CONTACTS_COUNT = 10;//300
  public static final String CONTACT_NAME_PATTERN = 'contact%';
  public static final Map<String, Object> CONTACT_PATTERN = new Map<String, Object>{
    'name' => 'contact',
    'firstName' => 'contact_f',
    'lastName' => 'contact_l',
    'email' => null,
    'accountid' => null,
    'domain' => 'domain.com'
  };
  public static List<Map<String, Object>> contacts = new List<Map<String, Object>>();


  public static final Integer PRODUCTS_COUNT = 10;//300
  public static final String PRODUCT_NAME_PATTERN = 'development%';
  public static final Map<String, Object> PRODUCT_PATTERN = new Map<String, Object>{
    'name' => 'Development',
    'isActive' => true
  };  
  public static List<Map<String, Object>> products = new List<Map<String, Object>>();


  public static final Integer PRICEBOOKS_COUNT = 10;//300
  public static final String PRICEBOOK_NAME_PATTERN = 'pricebook%';
  public static final Map<String, Object> PRICEBOOK_PATTERN = new Map<String, Object>{
      'name' => 'pricebook',
      'isActive' => true,
      'isStandart' => false
  };
  public static List<Map<String, Object>> pricebooks = new List<Map<String, Object>>();


  public static final Integer PRICEBOOK_ENTRIES_COUNT = 10;//300
  public static final Decimal PRICEBOOK_ENTRY_UNIT_PRICE = 50.00;
  public static final Map<String, Object> PRICEBOOK_ENTRY_PATTERN = new Map<String, Object>{
    'isActive' => true,
    'unitPrice' => PRICEBOOK_ENTRY_UNIT_PRICE,
    'pricebook2Id' => null,
    'product2Id' => null,
    'useStandardPrice' => false
  };
  public static List<Map<String, Object>> pricebookEntries = new List<Map<String, Object>>();

  public static final Integer CONTRACTS_COUNT = 10;//300
  public static final String CONTRACT_NAME_PATTERN = 'contract%';
  public static final String CONTRACT_STATUS_IN_Approval_Process = 'In Approval Process';
  public static final String CONTRACT_STATUS_DRAFT = 'Draft';
  public static final String CONTRACT_STATUS_ACTIVED = 'Activated';
  public static final Map<String, Object> CONTRACT_PATTERN = new Map<String, Object>{
    'accountId' => null,
    'status' => CONTRACT_STATUS_DRAFT,
    'startDate' => null,
    'contractTerm' => null,
    'pricebook2Id' => null,
    'name' => 'contract'
  };
  public static List<Map<String, Object>> contracts = new List<Map<String, Object>>{
    new Map<String, Object> {
      'count' => 3,//100
      'useParentId' => true,
      'useDiffParentId' => true,
      'contractTerm' => 8,
      'startDate' => date.newInstance(2019, 6, 1)
    },
    new Map<String, Object> {
      'count' => 6,//150
      'useParentId' => true,
      'useDiffParentId' => true,
      'contractTerm' => 4,
      'startDate' => date.newInstance(2019, 11, 1)
    },
    new Map<String, Object> {
      'count' => 1,//50
      'useParentId' => true,
      'useDiffParentId' => false,
      'contractTerm' => 1,
      'startDate' => date.newInstance(2019, 12, 1)
    }
  };

  public static final Map<String, Object> TIMESHEET_ENTRY_PATTERN = new Map<String, Object>{
    'contractResource' => null,//String:Contract_Resource__c
    'product' => null,//String:Product__c
    'date' => null,//Date:Date__c
    'minutes' => null,//Decimal:Minutes__c
    'employee' => null,//String:Employee__c
    'approved' => null//Boolean:Is_Approved__c
  };
  public static List<Map<String, Object>> timesheetEntries = new List<Map<String, Object>>{};

  public static final String TIMESHEET_STATUS_NEW = 'New';
  public static final String TIMESHEET_STATUS_PENDING = 'Pending';
  public static final String TIMESHEET_STATUS_APPROVED = 'Approved';
  public static final String TIMESHEET_STATUS_PAID = 'Paid';

  public static final String TIME_REPORTS_STATUS_APPROVED = 'Approved';
  public static final String TIME_REPORTS_STATUS_NEW = 'New';
  public static final String TIME_REPORTS_STATUS_UNLOCKED = 'unlocked';

  public static final String EXPENSE_TYPE_AIRFARE = 'Airfare';
  public static final String EXPENSE_TYPE_HOTEL_ROOM = 'Hotel Room';
  public static final String EXPENSE_TYPE_MEAL = 'Meal';
  public static final String EXPENSE_TYPE_RENTAL_CAR = 'Rental Car';

  public static final Map<String, Object> configDateRanges = new Map<String, Object>{
    /*'2019-06-03_2019-06-09' => new Map<String, Object>{
      'startDate' => '2019-06-03',
      'endDate' => '2019-06-09',
      'status' => 'approved'
    },
    '2019-06-10_2019-06-16' => new Map<String, Object>{
      'startDate' => '2019-06-10',
      'endDate' => '2019-06-16',
      'status' => 'approved'
    },
    '2019-06-17_2019-06-23' => new Map<String, Object>{
      'startDate' => '019-06-17',
      'endDate' => '2019-06-23',
      'status' => 'approved'
    },
    '2019-06-24_2019-06-30' => new Map<String, Object>{
      'startDate' => '2019-06-24',
      'endDate' => '2019-06-30',
      'status' => 'approved'
    },
    '2019-07-01_2019-07-07' => new Map<String, Object>{
      'startDate' => '2019-07-01',
      'endDate' => '2019-07-07',
      'status' => 'new'
    },
    '2019-07-08_2019-07-14' => new Map<String, Object>{
      'startDate' => '2019-07-08',
      'endDate' => '2019-07-14',
      'status' => 'new'
    },
    '2019-07-15_2019-07-21' => new Map<String, Object>{
      'startDate' => '2019-07-15',
      'endDate' => '2019-07-21',
      'status' => 'new'
    },
    '2019-07-22_2019-07-28' => new Map<String, Object>{
      'startDate' => '2019-07-22',
      'endDate' => '2019-07-28',
      'status' => 'new'
    },
    '2019-07-29_2019-08-04' => new Map<String, Object>{
      'startDate' => '2019-07-29',
      'endDate' => '2019-08-04',
      'status' => 'new'
    },
    '2019-08-05_2019-08-11' => new Map<String, Object>{
      'startDate' => '2019-08-05',
      'endDate' => '2019-08-11',
      'status' => 'pending'
    },
    '2019-08-12_2019-08-18' => new Map<String, Object>{
      'startDate' => '2019-08-12',
      'endDate' => '2019-08-18',
      'status' => 'pending'
    },
    '2019-08-19_2019-08-25' => new Map<String, Object>{
      'startDate' => '2019-08-19',
      'endDate' => '2019-08-25',
      'status' => 'pending'
    },
    '2019-08-26_2019-09-01' => new Map<String, Object>{
      'startDate' => '2019-08-26',
      'endDate' => '2019-09-01',
      'status' => 'pending'
    },
    '2019-09-02_2019-09-08' => new Map<String, Object>{
      'startDate' => '2019-09-02',
      'endDate' => '2019-09-08',
      'status' => 'approved'
    },
    '2019-09-09_2019-09-15' => new Map<String, Object>{
      'startDate' => '2019-09-09',
      'endDate' => '2019-09-15',
      'status' => 'new'
    },
    '2019-09-16_2019-09-22' => new Map<String, Object>{
      'startDate' => '2019-09-16',
      'endDate' => '2019-09-22',
      'status' => 'pending'
    },
    '2019-09-23_2019-09-29' => new Map<String, Object>{
      'startDate' => '2019-09-23',
      'endDate' => '2019-09-29',
      'status' => 'approved'
    },
    '2019-09-30_2019-10-06' => new Map<String, Object>{
      'startDate' => '2019-09-30',
      'endDate' => '2019-10-06',
      'status' => 'approved'
    },
    '2019-10-07_2019-10-13' => new Map<String, Object>{
      'startDate' => '2019-10-07',
      'endDate' => '2019-10-13',
      'status' => 'new'
    },
    '2019-10-14_2019-10-20' => new Map<String, Object>{
      'startDate' => '2019-10-14',
      'endDate' => '2019-10-20',
      'status' => 'pending'
    },
    '2019-10-21_2019-10-27' => new Map<String, Object>{
      'startDate' => '2019-10-21',
      'endDate' => '2019-10-27',
      'status' => 'approved'
    },
    '2019-10-28_2019-11-03' => new Map<String, Object>{
      'startDate' => '2019-10-28',
      'endDate' => '28_2019-11-03',
      'status' => 'new'
    },
    '2019-11-04_2019-11-10' => new Map<String, Object>{
      'startDate' => '2019-11-04',
      'endDate' => '2019-11-10',
      'status' => 'pending'
    },
    '2019-11-11_2019-11-17' => new Map<String, Object>{
      'startDate' => '2019-11-11',
      'endDate' => '11_2019-11-17',
      'status' => 'pending'
    },
    '2019-11-18_2019-11-24' => new Map<String, Object>{
      'startDate' => '2019-11-18',
      'endDate' => '2019-11-24',
      'status' => 'pending'
    },
    '2019-11-25_2019-12-01' => new Map<String, Object>{
      'startDate' => '2019-11-25',
      'endDate' => '2019-12-01',
      'status' => 'pending'
    },*/
    '2019-12-02_2019-12-08' => new Map<String, Object>{
      'startDate' => '2019-12-02',
      'endDate' => '2019-12-08',
      'status' => 'approved',
      'createTimesheet' => true
    },
    '2019-12-09_2019-12-15' => new Map<String, Object>{
      'startDate' => '2019-12-09',
      'endDate' => '2019-12-15',
      'status' => 'approved',
      'createTimesheet' => true
    },
    '2019-12-16_2019-12-22' => new Map<String, Object>{
      'startDate' => '2019-12-16',
      'endDate' => '2019-12-22',
      'status' => 'approved',
      'createTimesheet' => true
    },
    '2019-12-23_2019-12-29' => new Map<String, Object>{
      'startDate' => '2019-12-23',
      'endDate' => '2019-12-29',
      'status' => 'pending',
      'createTimesheet' => true
    },
    '2019-12-30_2020-01-05' => new Map<String, Object>{
      'startDate' => '2019-12-30',
      'endDate' => '2020-01-05',
      'status' => 'new',
      'createTimesheet' => true
    },
    DATE_START_WITHOUT_TIMESHEETS + '_' + DATE_END_WITHOUT_TIMESHEETS => new Map<String, Object>{
      'startDate' => DATE_START_WITHOUT_TIMESHEETS,
      'endDate' => DATE_END_WITHOUT_TIMESHEETS,
      'status' => 'new',
      'createTimesheet' => false
    }
  };

  public static final List<Map<String, String>> FILES = new List<Map<String, String>>{
    new Map<String, String>{
      'id' => null,
      'type' =>'text/plain',
      'name' => 'file-unit-test.txt',
      'content' => 'dGVzdCBjb250ZW50IGZvciB1bml0IHRlc3QuIGZpbGUgdXBsb2FkCg==',
      'recordId' => null
    }
  };

  public static void init() {
    insertUsers();
    insertAccounts();
    insertContacts();
    updateUsers();
    insertProducts();
    insertPricebooks();
    insertPricebookEntries();
    insertContracts();
    insertContractResources();
    insertTimesheetEntries();
    insertExpenseEntries();
    insertFiles();
    insertTimesheets();
    updateStatusTimesheets();
  }

  public static void insertUsers() {
    List<User> users = new List<User>();

    Profile p = getProfileFromDb('Standard User');

    for(Integer i = 0; i < USERS_COUNT; i++) {
      String name = (String)USER_PATTERN.get('name') + '_' + i;
      String lastname = (String)USER_PATTERN.get('lastName') + '_' + i;
      String uid = (String)USER_PATTERN.get('name') + '_' + i;

      User u = new User(
        Alias = uid, 
        Email = uid + '@' + (String)USER_PATTERN.get('domain'), 
        EmailEncodingKey = (String)USER_PATTERN.get('emailEncodingKey'),
        //Name = name,  
        LastName = lastname, 
        LanguageLocaleKey = (String)USER_PATTERN.get('languageLocaleKey'), 
        LocaleSidKey = (String)USER_PATTERN.get('localeSidKey'), 
        ProfileId = p.Id, 
        TimeZoneSidKey = (String)USER_PATTERN.get('timeZoneSidKey'), 
        UserName = (uid + '@' +  (String)USER_PATTERN.get('domain')),
        Subcontractor_Rate__c = SUBCONTRACTOR_RATE
      );      

      users.add(u);
    }

    insert users;

    User u = [SELECT Id, Subcontractor_Rate__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

    u.Subcontractor_Rate__c = SUBCONTRACTOR_RATE;

    update u;
  }

  public static List<User> getUsersFromDb() {
    Set<String> standardUsers = new Set<String> {
        'User',
        'User User',
        'Automated Process',
        'Data.com Clean',
        'Integration User',
        'Security User',
        'Chatter Expert'
    };

    return [SELECT Id, Alias, Email, Name FROM User WHERE Name NOT IN :standardUsers AND Email LIKE :USER_NAME_PATTERN];
  }

  public static List<User> getStandartUsersFromDb() {
    Set<String> standardUsers = new Set<String> {
        'Automated Process',
        'Data.com Clean',
        'Integration User',
        'Security User',
        'Chatter Expert'
    };

    return [SELECT Id FROM User WHERE Name NOT IN :standardUsers];
  }

  public static Profile getProfileFromDb(String name) {
    return [SELECT Id FROM Profile WHERE Name = :name LIMIT 1]; 
  }
  
  public static void insertAccounts() {
    List<Account> accounts = new List<Account>();

    String name = (String)ACCOUNT_PATTERN.get('name');

    for(Integer i = 0; i < ACCOUNTS_COUNT; i++) {      
      Account account = new Account(Name = (name + '_' + i));
      accounts.add(account);
    }

    insert accounts;
  }

  public static List<Account> getAccountsFromDb() {
    return [SELECT Id, Name, Send_Invoice_To__c FROM Account];
  }

  public static void insertContacts() {
    List<Account> accounts = getAccountsFromDb();
    Integer totalNumberAccounts = accounts.size();
    List<Contact> contacts = new List<Contact>();

    String name = (String)CONTACT_PATTERN.get('name');
    String firstName = (String)CONTACT_PATTERN.get('firstName');
    String lastName = (String)CONTACT_PATTERN.get('lastName');
    String domain = (String)CONTACT_PATTERN.get('domain');

    for(Integer i = 0; i < CONTACTS_COUNT; i++) {      
      Contact contact = new Contact();

      if(i > totalNumberAccounts) {
        contact.AccountId = accounts.get(totalNumberAccounts).Id;
      } else {
        contact.AccountId = accounts.get(i).Id;
      }

      contact.FirstName = (firstName + '_' + i);
      contact.LastName = (lastName + '_' + i);
      contact.Email = (name + '_' + i + '@' + domain);
      contacts.add(contact);
    }

    insert contacts;

    Account account = accounts[0];
    account.Send_Invoice_To__c = contacts[0].Id;

    update account;
  }

  public static List<Contact> getContactsFromDb() {
    return [SELECT Id, Name, AccountId FROM Contact WHERE Email LIKE :CONTACT_NAME_PATTERN];
  }

  public static void updateUsers() {
    List<Contact> contacts = getContactsFromDb();

    List<User> users = getUsersFromDb();

    Integer index = 0;

    for(User u : users) {
      if(index > contacts.size()) {
        break;
      }

      u.ContactId = contacts[index].Id;

      index++;
    }

    update users;
  }

  public static void insertProducts() {
    List<Product2> products = new List<Product2>();

    String name = (String)PRODUCT_PATTERN.get('name');

    for(Integer i = 0; i < PRODUCTS_COUNT; i++) {
      Product2 product = new Product2(Name = (name + '_' + i), IsActive = true);
      products.add(product);
    }

    insert products;
  }

  public static List<Product2> getProductsFromDb() {
    return [SELECT Id, Name FROM Product2 WHERE Name LIKE :PRODUCT_NAME_PATTERN];
  }

  public static void insertPricebooks() {
    List<Pricebook2> pricebooks = new List<Pricebook2>();
    
    String name = (String)PRICEBOOK_PATTERN.get('name');
    Boolean isActive = (Boolean)PRICEBOOK_PATTERN.get('isActive');
    Boolean isStandart = (Boolean)PRICEBOOK_PATTERN.get('isStandart');

    for(Integer i = 0; i < PRICEBOOKS_COUNT; i++) {
      Pricebook2 pricebook = new Pricebook2(Name = (name + '_custom_' + i), IsActive = isActive);
      pricebooks.add(pricebook);
    }

    //Pricebook2 pricebookStandart = pricebooks.get(0);
    //pricebookStandart.Name = (name + '_standart_' + 0);
    //pricebookStandart.isStandard = true;

    insert pricebooks;
  }

  public static List<Pricebook2> getPricebooksFromDb() {
    return [SELECT Id, Name FROM Pricebook2 WHERE IsStandard = false AND Name LIKE :PRICEBOOK_NAME_PATTERN];
  }

  public static void insertPricebookEntries() {
    List<Product2> products = getProductsFromDb();
    List<Pricebook2> pricebooks = getPricebooksFromDb();
    Integer numberPricebooks = pricebooks.size();    

    PricebookEntry pricebookEntry = new PricebookEntry();            
    pricebookEntry.IsActive = (Boolean)PRICEBOOK_ENTRY_PATTERN.get('isActive');
    pricebookEntry.UnitPrice = (Decimal)PRICEBOOK_ENTRY_PATTERN.get('unitPrice');
    pricebookEntry.Pricebook2Id = (String)PRICEBOOK_ENTRY_PATTERN.get('pricebook2Id');
    pricebookEntry.Product2Id = (String)PRICEBOOK_ENTRY_PATTERN.get('product2Id');
    pricebookEntry.UseStandardPrice = (Boolean)PRICEBOOK_ENTRY_PATTERN.get('useStandardPrice');

    Product2 product = products.get(0);  
    pricebookEntry.Product2Id = product.Id;

    pricebookEntry.Pricebook2Id = Test.getStandardPricebookId();

    insert pricebookEntry;

    List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();

    for(Integer i = 0; i < numberPricebooks; i++) {
      pricebookEntry = new PricebookEntry();            
      pricebookEntry.IsActive = (Boolean)PRICEBOOK_ENTRY_PATTERN.get('isActive');
      pricebookEntry.UnitPrice = (Decimal)PRICEBOOK_ENTRY_PATTERN.get('unitPrice');
      pricebookEntry.Pricebook2Id = (String)PRICEBOOK_ENTRY_PATTERN.get('pricebook2Id');
      pricebookEntry.Product2Id = (String)PRICEBOOK_ENTRY_PATTERN.get('product2Id');
      pricebookEntry.UseStandardPrice = (Boolean)PRICEBOOK_ENTRY_PATTERN.get('useStandardPrice');

      product = products.get(0);  
      pricebookEntry.Product2Id = product.Id;

      Pricebook2 pricebook = pricebooks.get(i);
      pricebookEntry.Pricebook2Id = pricebook.Id;
    
      pricebookEntries.add(pricebookEntry);
    }
    
    insert pricebookEntries;
  }

  public static List<PricebookEntry> getPricebookEntriesFromDb() {
    String pricebookId = Test.getStandardPricebookId();
    return [SELECT Id, Product2Id, UnitPrice, UseStandardPrice, Pricebook2Id FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id != :pricebookId];
  }

  public static List<PricebookEntry> getPricebookEntriesFromDb(String pricebookId) {
    return [SELECT Id, Product2Id, UnitPrice, UseStandardPrice, Pricebook2Id FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id = :pricebookId];
  }

  public static PricebookEntry getPricebookEntryFromDb() {
    String pricebookId = Test.getStandardPricebookId();
    return [SELECT Id, Product2Id, UnitPrice, UseStandardPrice FROM PricebookEntry WHERE IsActive = true AND Pricebook2Id != :pricebookId LIMIT 1];
  }

  public static void insertContracts() {
    List<Account> accounts = getAccountsFromDb();
    Integer indexAccount = -1;
    Integer numberAccounts = accounts.size();

    List<User> users = getUsersFromDb();
    Integer indexUser = -1;
    Integer numberUsers = users.size();

    List<Pricebook2> pricebooks = getPricebooksFromDb();
    Integer indexPricebook = -1;
    Integer numberPricebooks = pricebooks.size();

    List<Contract> listContracts = new List<Contract>();
    Integer indexContract = -1;

    String status = (String)CONTRACT_PATTERN.get('status');
    String name = (String)CONTRACT_PATTERN.get('name');

    for(Integer i = 0; i < contracts.size(); i++) {
      Map<String, Object> contract = contracts.get(i);
      Date startDate = (Date)contract.get('startDate');
      Integer contractTerm = (Integer)contract.get('contractTerm');

      if((Boolean)contract.get('useParentId')) {
        Integer numberContracts = (Integer)contract.get('count');

        indexContract++;
        indexAccount++;
        indexUser++;
        indexPricebook++;

        for(Integer j = 0; j < numberContracts; j++) {
          if((Boolean)contract.get('useDiffParentId')) {
            if(j > 0) {
              indexAccount++;
              indexUser++;
              indexPricebook++;
            }

            if(indexAccount > numberAccounts) {
              indexAccount = numberAccounts;
            }

            if(indexUser > numberUsers) {
              indexUser = numberUsers;
            }

            if(indexPricebook > numberPricebooks) {
              indexPricebook = numberPricebooks;
            }
          }

          Contract cntr = new Contract();
          cntr.AccountId = accounts.get(indexAccount).Id;
          cntr.Salesperson__c = users.get(indexUser).Id;
          cntr.Referred_By__c = accounts.get(indexAccount).Id;
          cntr.Commission_Rate__c = COMMISION_RATE;
          cntr.Referral_Rate__c = REFERRAL_RATE;
          cntr.Status = status;
          cntr.StartDate = startDate;
          cntr.ContractTerm = contractTerm;
          cntr.Pricebook2Id = pricebooks.get(indexPricebook).Id;
          cntr.Name = (name + '_' + indexContract);
          cntr.Is_Managed_Services__c = true;

          listContracts.add(cntr);
        }
      }
    }
    
    insert listContracts;

    for(Contract cntr : listContracts) {
      cntr.Status = CONTRACT_STATUS_ACTIVED;
    }

    update listContracts;
  }

  public static List<Contract> getContractsFromDb() {
    return [SELECT Id, AccountId, Pricebook2Id, Salesperson__c, Client_Manager__c, Referred_By__c FROM Contract WHERE Name LIKE :CONTRACT_NAME_PATTERN];
  }

  public static void insertContractResources() {
    List<Account> listAccounts = getAccountsFromDb();
    List<User> listUsers = getUsersFromDb();
    List<Contact> listContacts = getContactsFromDb();
    List<Contract> listContracts = getContractsFromDb();
    Integer totalNumberContracts = listContracts.size();
    List<PricebookEntry> pricebookEntries = getPricebookEntriesFromDb();
    Integer totalNumberPricebookEntries = pricebookEntries.size();

    List<Contract_Resource__c> listContractResources = new List<Contract_Resource__c>();

    Map<Integer, Object> configContracts = new Map<Integer, Object>{
      0 => new Map<String, Object>{
        'countContractResources' => 6,//100
        'countDiffSubcontractor' => 3//30
      },
      1 => new Map<String, Object>{
        'countContractResources' => 4,//50
        'countDiffSubcontractor' => 2//20
      }
    };

    Integer maxSelfContracts = 10;

    Contract_Resource__c contractResource = null;

    Integer indexUser = -1;
    Integer indexAccount = -1;
    Integer indexPricebookEntry = -1;

    for(Integer i = 0; i < totalNumberContracts; i++) {
      String contractId = listContracts.get(i).Id;
      String contactId = listContacts.get(i).Id;

      indexAccount++;

      Map<String, Object> configContract = (Map<String, Object>)configContracts.get(i);

      if(configContract != null) {        
        Integer countDiffSubcontractor = (Integer)configContract.get('countDiffSubcontractor');
        Integer countDiff = 0;

        for(Integer j = 0; j < (Integer)configContract.get('countContractResources'); j++) {
          indexUser++;
          
          countDiff++;

          if(indexUser > (listUsers.size()-1)) {
            indexUser = 0;
          }

          indexPricebookEntry++;
          
          if(indexPricebookEntry > (pricebookEntries.size()-1)) {
            indexPricebookEntry = 0;
          }

          contractResource = new Contract_Resource__c();
          contractResource.Contract__c = contractId;//*
          contractResource.Employee__c = listUsers.get(indexUser).Id;//employee&&subcontractor
          contractResource.Product__c = pricebookEntries.get(indexPricebookEntry).Product2Id;
          contractResource.Rate__c = pricebookEntries.get(indexPricebookEntry).UnitPrice;

          if((1 < countDiff) && (countDiff < countDiffSubcontractor)) {
            indexAccount++;
          }

          if(indexAccount == -1 || (indexAccount > (listAccounts.size()-1))) {
            indexAccount = 0;
          }
          
          contractResource.Subcontractor_Account__c = listAccounts.get(indexAccount).Id;//employee&&subcontractor

          listContractResources.add(contractResource);
        }
      } else {
          indexUser++;
          if(indexUser == -1 || (indexUser > (listUsers.size()-1))) {
            indexUser = 0;
          }

          indexPricebookEntry++;
          
          if(indexPricebookEntry > (pricebookEntries.size()-1)) {
            indexPricebookEntry = 0;
          }

          indexAccount++;
          if(indexAccount == -1 || (indexAccount > (listAccounts.size()-1))) {
            indexAccount = 0;
          }

          String userId = listUsers.get(indexUser).Id;

          if(maxSelfContracts > 0) {
            userId = UserInfo.getUserId();
            maxSelfContracts--;
          }

          contractResource = new Contract_Resource__c();
          contractResource.Contract__c = contractId;//*
          contractResource.Employee__c = userId;//employee&&subcontractor
          contractResource.Subcontractor_Account__c = listAccounts.get(indexAccount).Id;
          contractResource.Product__c = pricebookEntries.get(indexPricebookEntry).Product2Id;
          contractResource.Rate__c = pricebookEntries.get(indexPricebookEntry).UnitPrice;
          listContractResources.add(contractResource);
      }
    }  

    insert listContractResources;
  }

  public static List<Contract_Resource__c> getContractResourcesFromDb() {
    return [
            SELECT 
              Id, 
              Contract__c,
              Employee__c, 
              Subcontractor_Account__c,
              Product__c,
              Rate__c
            FROM 
              Contract_Resource__c
          ];
  }

  public static List<Contract_Resource__c> getContractResourcesFromDb(String employeeId) {
    return [
            SELECT 
              Id, 
              Contract__c,
              Contract__r.AccountId,
              Employee__c, 
              Subcontractor_Account__c,
              Product__c,
              Rate__c
            FROM 
              Contract_Resource__c
            WHERE 
              Employee__c = :employeeId
          ];
  }

  //TODO: JOIN getContractResourcesFromDb use database.query
  public static List<Contract_Resource__c> getContractResourcesFromDb(Set<String> employeesIds) {
    return [
      SELECT 
        Id,
        Contract__c,
        Contract__r.AccountId,
        Employee__c, 
        Subcontractor_Account__c,
        Product__c,
        Rate__c
      FROM 
        Contract_Resource__c
      WHERE 
        Employee__c IN :employeesIds
    ];
  }

  public static Id getProductByContractResource(String contractResourceId) {
    Contract_Resource__c contractResource = [SELECT Product__c FROM Contract_Resource__c LIMIT 1];

    if(contractResource == null) {
      return null;
    }

    return contractResource.Product__c;
  }
  
  public static void insertTimesheetEntries() {
    insertTimesheetEntries(null);
  }

  public static void insertTimesheetEntries(Set<String> employeesIds) {
    List<Timesheet_Entry__c> listTimesheetEntries = new List<Timesheet_Entry__c>();

    if(employeesIds == null) {
      employeesIds = new Set<String>{UserInfo.getUserId()};
    }

    List<Contract_Resource__c> listContractResources = getContractResourcesFromDb(employeesIds);
    Integer numberListContractResurces = listContractResources.size();

    Map<String, Id> contractResourcesToProducts = new Map<String, Id>();
    for(Contract_Resource__c contractResource: listContractResources) {
      contractResourcesToProducts.put(contractResource.Id, getProductByContractResource(contractResource.Id));
    }

    Integer maxDayTime = 1440;
    Integer minuteDayContractResource = (Integer)(maxDayTime/numberListContractResurces);
    Integer maxNumberApproved = (Integer)(numberListContractResurces/2);

    for(String key : configDateRanges.keySet()) {
      Map<String, Object> configDateRange = (Map<String, Object>)configDateRanges.get(key);
      Date startDate = Date.valueOf((String)configDateRange.get('startDate'));
      Date endDate = Date.valueOf((String)configDateRange.get('endDate'));
      String status = (String)configDateRange.get('status');

      while(startDate <= endDate) {
        Integer numberApproved = 0;

        for(Contract_Resource__c contractResource : listContractResources) {
          Timesheet_Entry__c timesheetEntry = new Timesheet_Entry__c();
          timesheetEntry.Contract_Resource__c = contractResource.Id;
          timesheetEntry.Product__c = contractResourcesToProducts.get(contractResource.Id);
          timesheetEntry.Date__c = startDate;
          timesheetEntry.Minutes__c = (Decimal)minuteDayContractResource;
          timesheetEntry.Employee__c = contractResource.Employee__c;

          timesheetEntry.Is_Approved__c = false;
          timesheetEntry.InternalApproval__c = null;
          timesheetEntry.InternalApprovalBy__c = null;

          listTimesheetEntries.add(timesheetEntry);
        }
        startDate = startDate.addDays(1);
      }
    }

    insert listTimesheetEntries;
  }

  public static List<Timesheet_Entry__c> getTimesheetEntriesFromDBByTimesheets(Set<String> ids) {
    return [
      SELECT 
        Id,
        Is_Approved__c,
        Minutes__c,
        Product__c,
        TimesheetId__c,
        Employee__c,
        Employee__r.Subcontractor_Rate__c,
        Date__c,
        Contract_Resource__c,        
        Contract_Resource__r.Contract__r.Id,        
        Contract_Resource__r.Contract__r.AccountId,
        Contract_Resource__r.Contract__r.Referred_By__c,
        Contract_Resource__r.Contract__r.Referral_Rate__c,
        Contract_Resource__r.Contract__r.Salesperson__c,
        Contract_Resource__r.Contract__r.Commission_Rate__c,
        Contract_Resource__r.Employee__c,
        Contract_Resource__r.Subcontractor_Account__c,
        Contract_Resource__r.Product__c,
        Contract_Resource__r.Rate__c,
        InternalApproval__c,
        InternalApprovalBy__c
      FROM 
        Timesheet_Entry__c
      WHERE 
        TimesheetId__c IN :ids
    ];
  }

  public static List<Timesheet_Entry__c> getTimesheetEntriesFromDb(Set<String> contractResourcesIds) {
    return [
      SELECT 
        Id,
        Is_Approved__c,
        Minutes__c,
        Product__c,
        TimesheetId__c,
        Employee__c,
        Employee__r.Subcontractor_Rate__c,
        Date__c,
        Contract_Resource__c,        
        Contract_Resource__r.Contract__r.Id,        
        Contract_Resource__r.Contract__r.AccountId,
        Contract_Resource__r.Contract__r.Referred_By__c,
        Contract_Resource__r.Contract__r.Referral_Rate__c,
        Contract_Resource__r.Contract__r.Salesperson__c,
        Contract_Resource__r.Contract__r.Commission_Rate__c,
        Contract_Resource__r.Employee__c,
        Contract_Resource__r.Subcontractor_Account__c,
        Contract_Resource__r.Product__c,
        Contract_Resource__r.Rate__c,
        InternalApproval__c,
        InternalApprovalBy__c
      FROM 
        Timesheet_Entry__c
      WHERE 
        Contract_Resource__c IN :contractResourcesIds
    ];
  }

  public static List<Timesheet_Entry__c> getTimesheetEntriesFromDb() {
    return [
      SELECT 
        Id,
        Is_Approved__c,
        Minutes__c,
        Product__c,
        TimesheetId__c,
        Employee__c,
        Date__c,
        Contract_Resource__c,
        InternalApproval__c,
        InternalApprovalBy__c
      FROM 
        Timesheet_Entry__c
    ];
  }

  public static List<Timesheet_Entry__c> getTimesheetEntriesFromDBByEmployee(String employeeId, String status) {
    return [
      SELECT 
        Id,
        Is_Approved__c,
        Minutes__c,
        Product__c,
        TimesheetId__c,
        Employee__c,
        Date__c,
        Contract_Resource__c,
        InternalApproval__c,
        InternalApprovalBy__c
      FROM 
        Timesheet_Entry__c
      WHERE 
        Employee__c = :employeeId
        AND
        TimesheetId__r.Status__c = :status
    ];
  }

  public static void insertExpenseEntries() {
    List<Expense_Entry__c> listExpenseEntries = new List<Expense_Entry__c>();

    List<Timesheet_Entry__c> listTimesheetEntries = getTimesheetEntriesFromDb();

    Integer amount = 0;
    Integer invoicedAmount = 0;
    Integer indexType = -1;
    Integer index = -1;
    String description = 'expense description';

    List<String> types = getExpenseEntryTypes();

    for(Timesheet_Entry__c timesheetEntry : listTimesheetEntries) {
        index++;
        indexType++;

        if(indexType > (types.size() - 1)) {
          indexType = 0;
        }

        Expense_Entry__c expenseEntry = new Expense_Entry__c();
        expenseEntry.Contract_Resource__c = timesheetEntry.Contract_Resource__c;
        expenseEntry.Date__c = timesheetEntry.Date__c;
        expenseEntry.Submittal_Date__c = timesheetEntry.Date__c;
        expenseEntry.Amount__c = ++amount;
        expenseEntry.Invoiced_Amount__c = ++invoicedAmount;
        expenseEntry.Type__c = types.get(indexType);
        expenseEntry.Description__c = (description + '_' + index);
        expenseEntry.Is_Approved__c = false;
        expenseEntry.Is_Billable__c = (Math.mod(index, 2) == 0);
        listExpenseEntries.add(expenseEntry);
    }

    insert listExpenseEntries; 
  }

  public static List<String> getExpenseEntryTypes() {
    List<String> types = new List<String>();

    Schema.DescribeFieldResult fieldResult = Expense_Entry__c.Type__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

    for(Schema.PicklistEntry pe : ple) {
      types.add(pe.getValue());
    }     

    return types;
  }

  public static List<Expense_Entry__c> getExpenseEntriesFromDb() {
    return [
      SELECT 
        Id,
        Contract_Resource__c,
        Date__c,
        Submittal_Date__c,
        Amount__c,
        Invoiced_Amount__c,
        Type__c,
        Description__c,
        Is_Approved__c,
        Is_Billable__c,
        TimesheetId__c
      FROM 
        Expense_Entry__c
    ];
  }

  public static List<Expense_Entry__c> getExpenseEntriesFromDb(Set<String> contractResourcesIds) {
    return [
      SELECT 
        Id,
        Contract_Resource__c,
        Date__c,
        Submittal_Date__c,
        Amount__c,
        Invoiced_Amount__c,
        Type__c,
        Description__c,
        Is_Approved__c,
        Is_Billable__c,
        TimesheetId__c
      FROM 
        Expense_Entry__c
      WHERE
       Contract_Resource__c IN : contractResourcesIds  
    ];
  }

  public static void insertFiles() {
    List<Expense_Entry__c> expenseEntries = getExpenseEntriesWithFiles();

    for(Expense_Entry__c expenseEntry : expenseEntries) {
      for(Map<String, String> file : FILES) {
        ContentVersion cv = createContentVersion(file.get('content'), file.get('name'));
        ContentDocumentLink cdl = createContentLink(cv.Id, expenseEntry.Id);
      }
    }
  }

  private static ContentVersion createContentVersion(String base64Content, String filename) {
      ContentVersion cv = new ContentVersion();
      cv.VersionData = EncodingUtil.base64Decode(base64Content);
      cv.Title = filename;
      cv.PathOnClient = filename;
      cv.ContentLocation = 'S';
    
      try {
        insert cv;
        return cv;
      } catch(DMLException e) {
        return null;
      }
  }

  private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
      if (contentVersionId == null || recordId == null) { return null; }

      ContentDocumentLink cdl = new ContentDocumentLink();

      cdl.ContentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion 
            WHERE Id =: contentVersionId
      ].ContentDocumentId;

      cdl.LinkedEntityId = recordId;
      // ShareType is either 'V', 'C', or 'I'
      // V = Viewer, C = Collaborator, I = Inferred
      cdl.ShareType = 'V';
      //cdl.Visibility = 'InternalUsers';

      try {
            insert cdl;
            return cdl;
      } catch(DMLException e) {
            return null;
      }
  }

  //refactor not correct
  public static void insertTimesheets() {
    String employeeId = UserInfo.getUserId();

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);

    Set<String> contractResourcesIds = new Set<String>();

    List<Timesheet__c> timesheets = new List<Timesheet__c>();

    Map<String, Timesheet__c> contractResourceToTimesheet = new Map<String, Timesheet__c>();

    for(String key : configDateRanges.keySet()) {
      Map<String, Object> configDateRange = (Map<String, Object>)configDateRanges.get(key);
      Boolean createTimesheet = (Boolean)configDateRange.get('createTimesheet');

      if(createTimesheet) {
        Date startDate = Date.valueOf((String)configDateRange.get('startDate'));
        Date endDate = Date.valueOf((String)configDateRange.get('endDate'));

        for(Contract_Resource__c contractResource : contractResources) {
            contractResourcesIds.add(contractResource.Id);

            Timesheet__c timesheet = new Timesheet__c();
            timesheet.OwnerId = employeeId;
            timesheet.StartDate__c = startDate;
            timesheet.EndDate__c = endDate;
            timesheet.Status__c = TIMESHEET_STATUS_NEW;
            timesheet.CreatedDate__c = endDate;
            timesheet.LastModifiedDate__c = endDate;

            timesheets.add(timesheet);

            contractResourceToTimesheet.put(String.valueOf(startDate) + '_' + String.ValueOf(endDate) + '_' + contractResource.Id, timesheet);
        }
      }
    }

    insert timesheets;

    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDb(contractResourcesIds);

    for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
      if(timesheetEntry.TimesheetId__c == null) {        
        for(Timesheet__c timesheet : timesheets) {
          if(timesheet.StartDate__c <= timesheetEntry.Date__c && timesheetEntry.Date__c <= timesheet.EndDate__c) {
            String keyMap = String.valueOf(timesheet.StartDate__c) + '_' + String.valueOf(timesheet.EndDate__c) + '_' + timesheetEntry.Contract_Resource__c;
            Timesheet__c ts = contractResourceToTimesheet.get(keyMap);
            if(ts != null) {
              timesheetEntry.TimesheetId__c = ts.Id;
            }
          }
        }
      }
    }

    update timesheetEntries;

    List<Expense_Entry__c> expenseEntries = getExpenseEntriesFromDb(contractResourcesIds);

    for(Expense_Entry__c expensetEntry : expenseEntries) {
      if(expensetEntry.TimesheetId__c == null) {        
        for(Timesheet__c timesheet : timesheets) {
          if(timesheet.StartDate__c <= expensetEntry.Submittal_Date__c && expensetEntry.Submittal_Date__c <= timesheet.EndDate__c) {
            String keyMap = String.valueOf(timesheet.StartDate__c) + '_' + String.valueOf(timesheet.EndDate__c) + '_' + expensetEntry.Contract_Resource__c;
            Timesheet__c ts = contractResourceToTimesheet.get(keyMap);
            if(ts != null) {
              expensetEntry.TimesheetId__c = ts.Id;
            }
          }
        }
      }
    }

    update expenseEntries;
  }

  public static List<Timesheet__c> getTimesheetsFromDB() {
    List<Timesheet__c> timesheets = [SELECT 
      OwnerId,
      StartDate__c,
      EndDate__c,
      Status__c,
      CreatedDate__c,
      LastModifiedDate__c
    FROM
      Timesheet__c
    ];

    return timesheets;
  }

  public static List<Timesheet__c> getTimesheetsFromDB(String status) {
    List<Timesheet__c> timesheets = [SELECT 
      Id,
      OwnerId,
      StartDate__c,
      EndDate__c,
      Status__c,
      CreatedDate__c,
      LastModifiedDate__c
    FROM
      Timesheet__c
    WHERE
      Status__c = :status
    ];

    return timesheets;
  }

  public static Timesheet__c getTimesheet(String status) {
    Timesheet__c ts = [SELECT 
        Id,
        OwnerId,
        StartDate__c,
        EndDate__c,
        Status__c,
        CreatedDate__c,
        LastModifiedDate__c
      FROM
        Timesheet__c
      WHERE
        Status__c = :status
      LIMIT 1    
    ];

    return ts;
  }

  public static Timesheet__c getTimesheetById(String id) {
    List<Timesheet__c> timesheets = [SELECT 
        OwnerId,
        StartDate__c,
        EndDate__c,
        Status__c,
        CreatedDate__c,
        LastModifiedDate__c
      FROM
        Timesheet__c
      WHERE
        Id = :id
      LIMIT 1    
    ];

    if(timesheets.isEmpty()) {
      return null;
    }

    return timesheets.get(0);
  }

  public static void updateStatusTimesheets() {
    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(UserInfo.getUserId());
    Set<String> contractResourcesIds = new Set<String>();

    for(Contract_Resource__c contractResource : contractResources) {
      contractResourcesIds.add(contractResource.Id);
    }

    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDb(contractResourcesIds);

    Map<String, Object> mapTimesheets = new Map<String, Object>();

    Map<String, String> mapPendingTimesheets = new Map<String, String>();

    for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
      for(String keyDateRange : configDateRanges.keySet()) {
        Map<String, Object> configDateRange = (Map<String, Object>)configDateRanges.get(keyDateRange);
        Date startDate = Date.valueOf((String)configDateRange.get('startDate'));
        Date endDate = Date.valueOf((String)configDateRange.get('endDate'));

        if(startDate <= timesheetEntry.Date__c && timesheetEntry.Date__c <= endDate && timesheetEntry.TimesheetId__c != null) {
          String status = (String)configDateRange.get('status');

          switch on status {
            when 'new' {
              String keyMap = timesheetEntry.Contract_Resource__c + '_' + String.valueOf(startDate) + '_' + String.valueOf(endDate);

              if(mapPendingTimesheets.get(keyMap) == null) {
                timesheetEntry.Is_Approved__c = true;
                timesheetEntry.InternalApproval__c = endDate;
                timesheetEntry.InternalApprovalBy__c = UserInfo.getUserId();
                mapPendingTimesheets.put(keyMap, timesheetEntry.Id);
              } else {
                timesheetEntry.Is_Approved__c = false;
                timesheetEntry.InternalApproval__c = null;
                timesheetEntry.InternalApprovalBy__c = null;
                mapTimesheets.put(timesheetEntry.TimesheetId__c, new Map<String, Object>{
                  'status' => 'New',
                  'contractResourceId' => timesheetEntry.Contract_Resource__c,
                  'startDate' => startDate,
                  'endDate' => endDate,
                  'expenseStatus' => 'new'
                });
              }
            }
            when 'pending' {
              timesheetEntry.Is_Approved__c = true;
              timesheetEntry.InternalApproval__c = endDate;
              timesheetEntry.InternalApprovalBy__c = UserInfo.getUserId();
              mapTimesheets.put(timesheetEntry.TimesheetId__c, new Map<String, Object>{
                'status' => 'Pending',
                'contractResourceId' => timesheetEntry.Contract_Resource__c,
                'startDate' => startDate,
                'endDate' => endDate,
                'expenseStatus' => 'approved'
              });
            }
            when 'approved' {
              timesheetEntry.Is_Approved__c = true;
              timesheetEntry.InternalApproval__c = endDate;
              timesheetEntry.InternalApprovalBy__c = UserInfo.getUserId();
              mapTimesheets.put(timesheetEntry.TimesheetId__c, new Map<String, Object>{
                'status' => 'Approved',
                'contractResourceId' => timesheetEntry.Contract_Resource__c,
                'startDate' => startDate,
                'endDate' => endDate,
                'expenseStatus' => 'approved'
              });
            }
          }
          break;
        }
      }
    }

    update timesheetEntries;

    List<Expense_Entry__c> expenseEntries = getExpenseEntriesFromDb();
    List<Expense_Entry__c> expenseEntriesToUpdate = new List<Expense_Entry__c>();

    List<Timesheet__c> timesheets = new List<Timesheet__c>();

    for(String timesheetId : mapTimesheets.keySet()) {
      Map<String, Object> mapTimesheet = (Map<String, Object>)mapTimesheets.get(timesheetId);

      Date startDate = (Date)mapTimesheet.get('startDate');
      Date endDate = (Date)mapTimesheet.get('endDate');
      Id contractResourceId = (Id)mapTimesheet.get('contractResourceId');
      String expenseStatus = (String)mapTimesheet.get('expenseStatus');

      Timesheet__c timesheet = new Timesheet__c(Id = timesheetId, Status__c = (String)mapTimesheet.get('status'));
      timesheets.add(timesheet);

      for(Expense_Entry__c expenseEntry : expenseEntries) {
        if(startDate <= expenseEntry.Submittal_Date__c && expenseEntry.Submittal_Date__c <= endDate && 
          contractResourceId == expenseEntry.Contract_Resource__c && expenseStatus == 'approved') {
            expenseEntry.Is_Approved__c = true;
            expenseEntry.Is_Billable__c = true;
            expenseEntry.TimesheetId__c = timesheetId;
            expenseEntry.InternalApproval__c = DateTime.now();
            expenseEntry.InternalApprovalBy__c = UserInfo.getUserId();
            expenseEntriesToUpdate.add(expenseEntry);
        }
      }
    }

    update expenseEntriesToUpdate;
    update timesheets;
  } 

  public static List<String> getContractsIdsFromContractResources() {
    return getContractsIdsFromContractResources(null);
  }

  public static List<String> getContractsIdsFromContractResources(String employeeId) {
    List<String> contractsIds = new List<String>();

    List<Contract_Resource__c> contractResources = null;
    
    if(employeeId == null) {
      contractResources = [SELECT Contract__c FROM Contract_Resource__c];
    } else {
      contractResources = [SELECT Contract__c FROM Contract_Resource__c WHERE Employee__c = :employeeId];
    }
    
    for(Contract_Resource__c contractResource : contractResources) {
      contractsIds.add(contractResource.Contract__c);
    }

    return contractsIds;
  }

  public static String getTimesheetId() {
    return getTimesheetId(null);
  }

  public static String getTimesheetId(String status) {
    String timesheetId = null;

    if(status == null) {
      timesheetId = [SELECT Id FROM Timesheet__c LIMIT 1].Id;
    } else {
      timesheetId = [SELECT Id FROM Timesheet__c WHERE Status__c = :status LIMIT 1].Id;
    }
    
    return timesheetId;
  }

  public static String getNotExistId() {
    return ID_NOT_EXIST;
  }

  public static String getNotExistName() {
    return NAME_NOT_EXIST;
  }

  public static String getAccountId() {
    String accountId = [SELECT Id FROM Account LIMIT 1].Id;
    return accountId;
  }

  public static Id getExpenseEntryId() {
    return getExpenseEntryId(null);
  }

  public static Id getExpenseEntryId(Boolean approved) {
    String expenseEntryId = null;

    if(approved == null) {
      expenseEntryId = [SELECT Id FROM Expense_Entry__c LIMIT 1].Id;
    } else {
      expenseEntryId = [SELECT Id FROM Expense_Entry__c WHERE Is_Approved__c = :approved LIMIT 1].Id;
    }

    return expenseEntryId;
  }

  public static List<Expense_Entry__c> getExpenseEntryByContractResourcesDate(Set<String> ids, Date createdDate) {
    List<Expense_Entry__c> expenseEntries = [SELECT Id FROM Expense_Entry__c WHERE Contract_Resource__c IN :ids AND Date__C = :createdDate];
    return expenseEntries;
  }

  public static Map<String, Object> getNewExpense() {
    List<Object> dateRanges = (List<Object>)configDateRanges.values();

    Date endDate = null;

    for(Object dateRange : dateRanges) {
      if(((Map<String, Object>)dateRange).get('status') == 'new') {
        endDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('endDate')));
        break;
      }
    }

    String contractId = getContractId();

    String employeeId = UserInfo.getUserId();
    List<String> contractsIds = getContractsIdsFromContractResources(employeeId);
  
    Map<String, Object> item = new Map<String, Object>{
        'contractId' => contractsIds.get(0),
        'description' => 'Cafe',
        'amount'  => 110.00,
        'invoicedAmount'  => 110.00,
        'expenseDate' => endDate,
        'submittalDate' => endDate,
        'billable'  => true,
        'type'  => 'Meal',
        'timesheetId' => getTimesheetId('New'),
        'employeeId'  => employeeId
    };

    return item;
  }

  public static String getContractId() {
    List<String> contractsIds = getContractsIdsFromContractResources(null);
    return contractsIds[0];
  }

  public static Map<String, Object> getNewTimeTracking() {
    List<Object> dateRanges = (List<Object>)configDateRanges.values();
    
    Date startDate = null;

    for(Object dateRange : dateRanges) {
      if(((Map<String, Object>)dateRange).get('status') == 'new') {
        startDate = Date.valueOf((String)(((Map<String, Object>)dateRange).get('startDate')));
        break;
      }
    }

    String employeeId = UserInfo.getUserId();

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);
    Contract_Resource__c contractResource = contractResources.get(0);

    Map<String, Object> timeTracking = new Map<String, Object>{
      'contractResourceId' => contractResource.Id,
      'contractId' => contractResource.Contract__c,
      'productId' => getProductByContractResource(contractResource.Id),
      'createdDate' => startDate,
      'minutes' => MINUTES_150,
      'employeeId' => employeeId
    };
    return timeTracking;
  }

  public static Map<String, Object> getNewTimesheet() {
    return getNewTimesheet(null);
  }

  public static Map<String, Object> getNewTimesheet(String employeeId) {
    employeeId = (employeeId == null) ? UserInfo.getUserId() : employeeId;

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);
    Contract_Resource__c contractResource = contractResources.get(0);

    Map<String, Object> item = new Map<String, Object>{
        'employeeId' => employeeId,
        'contractId' => contractResource.Contract__c,
        'contractResourceId' => contractResource.Id,
        'startDate' => Date.valueOf(DATE_START_WITHOUT_TIMESHEETS),
        'endDate' => Date.valueOf(DATE_END_WITHOUT_TIMESHEETS)
    };

    return item;
  }

  public static Map<String, Object> getExistTimesheet() {    
    Timesheet__c timesheet = getTimesheet(TIMESHEET_STATUS_NEW);
    
    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDBByTimesheets(new Set<String>{timesheet.Id});
    Timesheet_Entry__c te = timesheetEntries.get(0);

    Map<String, Object> item = new Map<String, Object>{
        'timesheetId' => timesheet.Id,
        'employeeId' => te.Employee__c,
        'contractId' => te.Contract_Resource__r.Contract__r.Id,
        'startDate' => timesheet.StartDate__c,
        'endDate' => timesheet.EndDate__c
    };

    return item;
  }

  public static Set<String> getAccountsNames() {
    Set<String> names = new Set<String>();

    String namePattern = (String)ACCOUNT_PATTERN.get('name');

    for(Integer i = 0; i < ACCOUNTS_COUNT; i++) {
        names.add(namePattern + '_' + i);
    }

    return names;
  }

  public static Set<String> getNotExistNames() {
    Set<String> names = new Set<String>{
      getNotExistName()
    };

    return names;
  }

  public static Set<String> getAccountsIds() {
    Set<String> ids = new Set<String>();

    List<Account> accounts = getAccountsFromDB();

    for(Account acc : accounts) {
      ids.add(acc.Id);
    }

    return ids;
  }

  public static Set<String> getContractResourcesIds(String employeeId) {
    Set<String> ids = new Set<String>();

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);
    
    for(Contract_Resource__c cr : contractResources) {
      ids.add(cr.Id);
    }

    return ids;
  }

  public static Set<String> getNotExistIds() {
    Set<String> ids = new Set<String>{
      getNotExistId()
    };

    return ids;
  }

  public static String getAccountIdFromContractResource(String employeeId) {
    List<Contract_Resource__c> contractResources = getContractResourcesFromDB(employeeId);
    Contract_Resource__c cr = contractResources.get(0);
    return cr.Contract__r.AccountId;
  }

  public static Map<String, Object> getContractResourcesAndDatesFromExpenses(Integer numberExpenses, Boolean approved, Boolean billabled) {
      List<Expense_Entry__c> expenseEntries = getExpenseEntriesFromDb();

      Date startDate = null;
      Date endDate = null;
      List<Date> dates = new List<Date>();
      Set<String> contractResourcesIds = new Set<String>();

      for(Integer i = 0; i < expenseEntries.size(); i++) {
          Expense_Entry__c ee = expenseEntries.get(i);

          if(ee.Is_Billable__c == billabled && ee.Is_Approved__c == approved) {
            if(numberExpenses == 0) {
                break;
            }
            
            if(startDate == null) {
              startDate = ee.Submittal_Date__c;
            } else {
              if(startDate > ee.Submittal_Date__c) {
                startDate = ee.Submittal_Date__c;
              }
            }

            if(endDate == null) {
              endDate = ee.Submittal_Date__c;
            } else {
              if(endDate < ee.Submittal_Date__c) {
                endDate = ee.Submittal_Date__c;
              }
            }

            dates.add(ee.Submittal_Date__c);
            contractResourcesIds.add(expenseEntries.get(i).Contract_Resource__c);

            numberExpenses--;
          }
      }

      return new Map<String, Object>{
        'dateList' => dates,
        'listContractResourcesIds' => contractResourcesIds,
        'startDate' => startDate,
        'endDate' => endDate
      };
  }

  public static Set<String> getPricebookEntriesIds() {
    Set<String> ids = new Set<String>();

    List<PricebookEntry> pricebookEntries = getPricebookEntriesFromDb();

    for(PricebookEntry pe : pricebookEntries) {
      ids.add(pe.Id);
    }

    return ids;
  }

  public static Set<String> getPricebooksIds() {
    Set<String> ids = new Set<String>();

    List<Pricebook2> pricebooks = getPricebooksFromDb();

    for(Pricebook2 pb : pricebooks) {
      ids.add(pb.Id);
    }

    return ids;
  }

  public static Contact getContactFromDb() {
    return [SELECT Id FROM Contact LIMIT 1];
  }

  public static Timesheet_Entry__c getTimesheetEntryFromDB() {
    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDb();
    return timesheetEntries.get(0);
  }

  public static Timesheet__c getTimesheetByEmployee(String employeeId) {
    Set<String> contractResourcesIds = new Set<String>();
    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);
    
    for(Contract_Resource__c contractResource : contractResources) {
        contractResourcesIds.add(contractResource.Id);
    }

    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDb(contractResourcesIds);
    Timesheet_Entry__c te = timesheetEntries.get(0);

    return getTimesheetById(te.TimesheetId__c);
  }

  public static Timesheet__c getTimesheetByEmployeeStatus(String employeeId, String status) {
    Set<String> contractResourcesIds = new Set<String>();
    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(employeeId);
    
    for(Contract_Resource__c contractResource : contractResources) {
        contractResourcesIds.add(contractResource.Id);
    }

    List<Timesheet_Entry__c> timesheetEntries = getTimesheetEntriesFromDb(contractResourcesIds);
    
    List<Timesheet__c> timesheets = getTimesheetsFromDB(status);
    Map<String, Timesheet__c> mapTimesheets = new Map<String, Timesheet__c>();

    for(Timesheet__c ts : timesheets) {
      mapTimesheets.put(ts.Id, ts);
    }

    Timesheet__c timesheet = null;

    for(Timesheet_Entry__c te : timesheetEntries) {
      timesheet = mapTimesheets.get(te.TimesheetId__c);
      if(timesheet != null) {
        break;
      }
    }

    return timesheet;
  }

  public static Set<Id> getTimesheetsIds() {
    List<Timesheet__c> tiemsheets = getTimesheetsFromDB();

    Set<Id> ids = new Set<Id>();

    for(Timesheet__c ts : tiemsheets) {
      ids.add(ts.Id);
    }

    return ids;
  }

  public static String getUserId() {
    List<User> users = getUsersFromDb();
    return users.get(0).Id;
  }

  public static Set<String> getUsersIds() {
    Set<String> ids = new Set<String>();

    List<User> users = getUsersFromDb();

    for(User u : users) {
      ids.add((String)u.Id);
    }

    return ids;
  }

  public static Integer getTotalTimesheets() {
    Integer totalDatesForCreateTimesheets = 0;

    for(String key : configDateRanges.keySet()) {
        Map<String, Object> configDateRange = (Map<String, Object>)configDateRanges.get(key);
        Boolean createTimesheet = (Boolean)configDateRange.get('createTimesheet');

        if(createTimesheet) {
          totalDatesForCreateTimesheets++;
        }
    }

    List<Contract_Resource__c> contractResources = getContractResourcesFromDb(UserInfo.getUserId());

    return (totalDatesForCreateTimesheets * contractResources.size());
  }

  public static String getDocumentId() {
    List<Expense_Entry__c> expenseEntries = getExpenseEntriesWithFiles();

    Expense_Entry__c expenseEntry = expenseEntries[0];

    List<ContentDocumentLink> cdls = [
      SELECT
        Id, 
        LinkedEntityId, 
        ContentDocumentId 
      FROM 
        ContentDocumentLink 
      WHERE 
        LinkedEntityId = : expenseEntry.Id
    ];

    ContentDocumentLink cdl = cdls[0];

    return  cdl.ContentDocumentId;
  }

  public static Set<String> getDocumentsIds() {
    return new Set<String>{getDocumentId()};
  }

  public static List<Expense_Entry__c> getExpenseEntriesWithFiles() {
    String employeeId = UserInfo.getUserId();
    Set<String> ids = getContractResourcesIds(employeeId);

    List<Object> dateRanges = configDateRanges.values();
    Map<String, Object> dateRange = (Map<String, Object>)dateRanges.get(0);
    Date startDate = Date.valueOf((String)dateRange.get('startDate'));

    List<Expense_Entry__c> expenseEntries = getExpenseEntryByContractResourcesDate(ids, startDate);

    return expenseEntries;
  }

  public static Map<String, String> getNewFile(String recordId) {
    Map<String, String> newFile =   new Map<String, String>{
      'id' => '',
      'type' =>'text/plain',
      'name' => 'file-unit-test-new-file.txt',
      'content' => 'dGVzdCBjb250ZW50IGZvciB1bml0IHRlc3QuIGZpbGUgdXBsb2FkCg==',
      'recordId' => recordId
    };

    return newFile;
  }

  public static String getNotExistDocumentId() {
    return '0694F0000021IZVQA2';
  }

  public static Set<String> getNotExistDocumentsIds() {
    return new Set<String>{getNotExistDocumentId()};
  }

  public static String getRecordId() {
    List<Expense_Entry__c> expenseEntries = getExpenseEntriesWithFiles();
    return expenseEntries[0].Id;
  }

  public static AggregateResult getTotalAmountExpenseEntries(Map<String, Object> conditions) {
      Date startDate = (Date)conditions.get('startDate');
      Date endDate = (Date)conditions.get('endDate');
      Set<String> contractResourcesIds = (Set<String>)conditions.get('contractResourcesIds');
      Boolean isApproved = (Boolean)conditions.get('isApproved');
      Boolean isBillable = (Boolean)conditions.get('isBillable');

      AggregateResult expenseEntries = [
        SELECT 
          SUM(Invoiced_Amount__c) amount 
        FROM   
          Expense_Entry__c  
        WHERE  
          Submittal_Date__c >= :startDate 
        AND  
          Submittal_Date__c <= :endDate
        AND
          Is_Billable__c = :isBillable
        AND
          Is_Approved__c = :isApproved                   
        AND  
          Contract_Resource__c IN :contractResourcesIds
      ]; 

      return expenseEntries;
  }

  public static String convertDateToString(Date d) {
    DateTime dt = DateTime.newInstanceGMT(d.year(), d.month(), d.day());
    return dt.formatGmt(TestDataFactory.DATE_FORMAT);
  }
}