/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_TimesheetEntry extends service_Base {
    private final Integer DECIMAL_MAX = 5;

    //TODO: use findAll or getList
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
            when 'insertEntry' {
                insertEntry(request, response);
            }
            when 'insert' {
                insertEntries(request, response);
            }
            when 'updateEntry' {
                updateEntry(request, response);
            }
            when 'update' {
                updateEntries(request, response);
            }
            when 'deleteEntry' {
                deleteEntry(request, response);
            }
        }
    }

    //TODO: REPLACE METHOD
    //TODO:get contract resource ids by contract and employee => row, get product from pricebook entry;
    public void getList(service_Request request, service_Response response) {
        Map<String, Map<String, Object>> items = new Map<String, Map<String, Object>>();

        Date startDate = (Date)request.Parameters.get('startDate');
        Date endDate = (Date)request.Parameters.get('endDate');

        if(startDate != null && endDate != null) {
            List<String> contractsIds = (List<String>)request.Parameters.get('contractIds');
            List<String> usersIds = (List<String>)request.Parameters.get('userIds');
            String status = 'activated';

            if(contractsIds == null) {
                contractsIds = new List<String>();
            }

            String userId = null;
            if(usersIds != null && usersIds.size() > 0) {
                userId = usersIds[0];
            } else {
                userId = UserInfo.getUserId();
            }

            //TODO:Move to account
            List<Map<String, Object>> contracts = new List<Map<String, Object>>();

            dao_Account daoAccount = new dao_Account();
            List<Account> accounts =  daoAccount.findAllWithContracts(status, userId, null, new Set<String>(contractsIds));

            for(Account account : accounts) {
                String accountName = account.Name;
                String accountId = account.Id;
                for(Contract contract : account.Contracts) {
                    Map<String, Object> contractInfo = new Map<String, Object> {
                        'accountId' => accountId,
                        'accountName' => accountName,
                        'contractId' => contract.Id,
                        'contractNumber' => contract.ContractNumber
                    };

                    contracts.add(contractInfo);
                }
            }

            //TODO:Move to product
            Map<String, String> mapProducts = new Map<String, String>();

            dao_Product2 daoProduct2 = new dao_Product2();
            List<Product2> products = daoProduct2.findAll();

            for(Product2 product : products) {
                mapProducts.put((String)product.Id , (String)product.Name);
            }

            dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();
            dao_ContractResource daoContractResource = new dao_ContractResource();
            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();

            String productKey = null;

            Map<String, Object> item = new Map<String, Object>();

            List<Timesheet_Entry__c> newTimesheetsEntries = new List<Timesheet_Entry__c>();

            Boolean previousWeek = (Boolean)request.Parameters.get('previousWeek');

            for(Map<String, Object> contract : contracts) {
                Contract_Resource__c contractResource = daoContractResource.findOne((String)contract.get('contractId'), userId);

                if(contractResource == null) {
                    continue;
                }

                if(contractResource.Employee__c == null || contractResource.Product__c == null) {
                    continue;
                }

                Map<String,Object> conditions = new Map<String,Object> {
                    'contractResourceId' => contractResource.Id,
                    'employeeId' => userId,
                    'startDate' => startDate,
                    'endDate' => endDate
                }; 

                List<Timesheet_Entry__c> timesheetsEntries = (List<Timesheet_Entry__c>)daoTimesheetEntry.findAll(conditions);

                if(previousWeek == true && timesheetsEntries.size() == 0) {//TODO:CRITICAL:REFACTOR:MASK ACTION FOR NOT EXPECT DATE RANGE
                    conditions = new Map<String,Object> {
                        'contractResourceId' => contractResource.Id,
                        'employeeId' => userId,
                        'startDate' => startDate.addDays(-7),
                        'endDate' => endDate.addDays(-7)
                    };

                    timesheetsEntries = (List<Timesheet_Entry__c>)daoTimesheetEntry.findAll(conditions);
                }

                if(timesheetsEntries.size() == 0) {
                       productKey = contractResource.Product__c + '_' + contractResource.Id;

                        item = new Map<String, Object> {
                            'employeeId' => userId,
                            'accountName' => contract.get('accountName'), 
                            'contractNumber' => contract.get('contractNumber'),
                            'contractId' => contract.get('contractId'),
                            'contractResourceId' => contractResource.Id,
                            'timesheetEntriesList' => new List<Timesheet_Entry__c>(),
                            'productName' => mapProducts.get(contractResource.Product__c),
                            'productId' => contractResource.Product__c
                        }; 

                        items.put(productKey, item);                 
                } else {
                    for(Timesheet_Entry__c entry : timesheetsEntries) {
                        if(entry.Product__c == null) {
                            continue;
                        }

                        productKey = contractResource.Product__c + '_' + contractResource.Id;

                        if(items.containsKey(productKey)) {                                  
                            item = items.get(productKey);
                            newTimesheetsEntries = (List<Timesheet_Entry__c>)item.get('timesheetEntriesList');
                            newTimesheetsEntries.add(entry);
                            item.put('timesheetEntriesList', newTimesheetsEntries);
                        } else {
                            List<Timesheet_Entry__c> timesheetEntryTemp = new List<Timesheet_Entry__c>();
                            timesheetEntryTemp.add(entry);

                            item = new Map<String, Object>{
                                'employeeId' => userId,
                                'accountName' => contract.get('accountName'), 
                                'contractNumber' => contract.get('contractNumber'),
                                'contractId' => contract.get('contractId'),
                                'contractResourceId' => contractResource.Id,
                                'timesheetEntriesList' => timesheetEntryTemp,
                                'productName' => mapProducts.get(contractResource.Product__c),
                                'productId' => contractResource.Product__c
                            };

                            items.put(productKey, item);   
                        }
                    }
                }
            }
        } 
        
        response.Parameters.put('list', items.values());
    }

    public void insertEntry(service_Request request, service_Response response) {//@Deprecated: TODO:JOIN WITH insertEntries
        Object productId = request.Parameters.get('productId');
        Object createdDate = request.Parameters.get('createdDate');
        Object minutes = request.Parameters.get('minutes');

        List<Map<String, Object>> listEntries = new List<Map<String, Object>>{
            new Map<String, Object>{
                  'contractResourceId' => getContractResourceId((String)request.Parameters.get('contractId'), (String)request.Parameters.get('employeeId')), 
                  'productId' => productId, 
                  'date' => createdDate,
                  'minutes' =>  minutes
            }
        };

        request.Parameters.put('list', listEntries);

        insertEntries(request, response);
    }

    public void insertEntries(service_Request request, service_Response response) {
        Map<String, Object> fields = new Map<String, Object>();

        List<String> allowParams = new List<String> {
            'employeeId', 'list'
        };

        for(String param : allowParams) {
            if(request.Parameters.containsKey(param)) {
                fields.put(param, request.Parameters.get(param));            
            }
        }

        fields.put('contractResourceId', getContractResourceId((String)request.Parameters.get('contractId'), (String)request.Parameters.get('employeeId')));

        response.Parameters.put('list', insertAll(fields));
    }

    public void updateEntry(service_Request request, service_Response response) {
        List<Map<String, Object>> listEntries = new List<Map<String, Object>>{
            new Map<String, Object>{
                'id' => request.Parameters.get('timesheetEntryId'), 
                'minutes' => request.Parameters.get('minutes')
            }
        };

        request.Parameters.put('list', listEntries);
        updateEntries(request, response);
    }

    public void updateEntries(service_Request request, service_Response response) {
        Map<String, Object> fields = new Map<String, Object>();

        List<String> allowParams = new List<String>{
             'id', 'list'
        };

        for(String param : allowParams) {
            if(request.Parameters.containsKey(param)) {
                fields.put(param, request.Parameters.get(param));            
            }
        }

        List<Timesheet_Entry__c> updatedEntries = updateAll(fields);

        response.Parameters.put('list', updatedEntries);
    }


    public void deleteEntry(service_Request request, service_Response response) {
        String status = 'error';

        String timesheetEntryId = (String)request.Parameters.get('timesheetEntryId');

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        Timesheet_Entry__c timesheetEntry = daoTimesheetEntry.findOne(timesheetEntryId);

        if(!timesheetEntry.Is_Approved__c) {
            delete timesheetEntry;

            status = 'success';
        }

        response.Parameters.put('status', status);
    }

    //TODO:review code
    private List<Timesheet_Entry__c> insertAll(Map<String, Object> params) {
        List<Timesheet_Entry__c> newEntries = new List<Timesheet_Entry__c>();

        if(params.get('employeeId') != null && params.get('list') != null) {
            String employeeId = (String)params.get('employeeId');
            List<Map<String, Object>> timesheetEntries = (List<Map<String, Object>>)params.get('list');

            for(Map<String, Object> objTimesheetEntry : timesheetEntries) {
                if(checkValidTimesheetEntries(objTimesheetEntry)) {
                    String productId = (String)objTimesheetEntry.get('productId');
                    Decimal minutes = Decimal.valueOf((String)objTimesheetEntry.get('minutes'));
                    Date timesheetEntryDate = Date.valueOf((String)objTimesheetEntry.get('date'));
                    String contractResourceId = (String)objTimesheetEntry.get('contractResourceId');

                    Timesheet_Entry__c timesheetEntry = new Timesheet_Entry__c();
                    timesheetEntry.Contract_Resource__c = contractResourceId;
                    timesheetEntry.Product__c = productId;
                    timesheetEntry.Date__c = timesheetEntryDate;
                    timesheetEntry.Minutes__c = minutes;
                    timesheetEntry.Employee__c = employeeId;

                    newEntries.add(timesheetEntry);   
                }               
            }

            insert newEntries;
        }

        return newEntries;
    }

    private List<Timesheet_Entry__c> updateAll(Map<String, Object> params) {
        List<Timesheet_Entry__c> newEntries = new List<Timesheet_Entry__c>();

        if(params.get('list') != null) {
            List<Map<String, Object>> entries = (List<Map<String, Object>>)params.get('list');
            Set<Id> timesheetEntriesIds = new Set<Id>();
            Map<Id, Object> mapEntries = new Map<Id, Object>();

            for(Map<String, Object> entry : entries) {
                if(entry.get('id') != null && entry.get('minutes') != null) {
                    Id timesheetEntryId = (Id)entry.get('id');
                    Decimal minutes = Decimal.valueOf((String)entry.get('minutes'));
                    mapEntries.put(timesheetEntryId, minutes);
                    timesheetEntriesIds.add(timesheetEntryId);
                }
            }

            Map<String, Object> conditions = new Map<String, Object> {'ids' => timesheetEntriesIds};
            dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
            List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findAll(conditions);

            if(!timesheetEntries.isEmpty()) {
                for(Timesheet_Entry__c timesheetEntry : timesheetEntries) {
                    timesheetEntry.Minutes__c = (Decimal)mapEntries.get(timesheetEntry.Id);
                    newEntries.add(timesheetEntry);
                }
            }

            update newEntries;
        }

        return newEntries;        
    }
    
    private String getContractResourceId(String contractId, String userId) {
      service_Request request = new service_Request();   
      request.Parameters.put('contractId', contractId);
      request.Parameters.put('employeeId', userId);
      request.Parameters.put('action', 'getId');

      service_Response response = service_Controller.process(Services.ContractResource, request);

      String contractResourceId = null;
      
      return (String)response.Parameters.get('id');
    }

    private Map<String, Object> getContractInfo(String contractResourceId, Date tseDate) {
        Map<String, Object> contractInfo = new Map<String, Object> {
            'contractId' => null,
            'contractError' => null
        };

        dao_Contract daoContract = new dao_Contract();
        Contract contract = daoContract.findOneByContractResource(contractResourceId);

        if(contract == null) {
           generateNoDataFoundError('Contract not found');
        }

        if(tseDate < contract.StartDate || tseDate > contract.EndDate) {
            String formattedStartDate = Datetime.newInstance(contract.StartDate.year(), contract.StartDate.month(), contract.StartDate.day()).format('MM/dd/yyyy');
            String formattedEndDate = Datetime.newInstance(contract.EndDate.year(), contract.EndDate.month(), contract.EndDate.day()).format('MM/dd/yyyy');
            String formattedTimesheetEntryDate = Datetime.newInstance(tseDate.year(), tseDate.month(), tseDate.day()).format('MM/dd/yyyy');
            String contractError = 'You cannot add worklog for this date ' + formattedTimesheetEntryDate + ' - This Contract ' + contract.ContractNumber + ' period is (' + formattedStartDate + ' - ' + formattedEndDate + ')';
            
            contractInfo.put('contractId', contract.Id);
            contractInfo.put('contractError', contractError);
        }

        return contractInfo;
    }


    private Map<String, Object> getTimesheetInfo(String contractResourceId, Date tseDate) {
        Map<String, Object> timesheetInfo = new Map<String, Object> {
            'timesheetId' => null,
            'timesheetError' => null
        };

        dao_Timesheet daoTimesheet = new dao_Timesheet();
        List<Timesheet__c> listTimesheets = daoTimesheet.findAll();
        Set<Id> timesheetIds = new Set<Id>();

        for(Timesheet__c timesheet : listTimesheets) {
            if(tseDate >= timesheet.startDate__c && tseDate <= timesheet.endDate__c) {
                timesheetIds.add(timesheet.Id);
            }
        }

        if(timesheetIds.isEmpty()) {
            return timesheetInfo;
        }

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> timesheetEntries = daoTimesheetEntry.findByTimesheets(timesheetIds);

        for(Timesheet_Entry__c timesheetEntry: timesheetEntries) {
            if(timesheetEntry.Contract_Resource__c == contractResourceId) {
                Timesheet__c timesheetObj = daoTimesheet.findOne(timesheetEntry.TimesheetId__c);

                if(timesheetObj != null && timesheetObj.Status__c != 'New') {
                    Date startDate = Date.valueOf(timesheetObj.StartDate__c);
                    String formattedStartDate = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day()).format('yyyy-MM-dd');
                    Date endDate = Date.valueOf(timesheetObj.EndDate__c);
                    String formattedEndDate = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day()).format('yyyy-MM-dd');
                    String formattedDate = Datetime.newInstance(tseDate.year(), tseDate.month(), tseDate.day()).format('yyyy-MM-dd');
                    String timesheetError = 'You cannot add worklog for this date '+ formattedDate +'  for Contract ' + timesheetObj.Contract_Resource__r.Contract__r.ContractNumber;
                    timesheetError +='. It is included into Timesheet (' + formattedStartDate + ' - ' + formattedEndDate + ') which is already sent to the client.';
                    
                    timesheetInfo.put('timesheetId', timesheetObj.id);
                    timesheetInfo.put('timesheetError', timesheetError);

                    return timesheetInfo;
                }
            }
        }

        return timesheetInfo;
    }

    private Boolean checkValidTimesheetEntries(Map<String, Object> timesheetEntry) {
        if(timesheetEntry.get('productId') == null) {
            generateNoDataFoundError('Product is null');
        }

        if(timesheetEntry.get('date') == null) {
            generateNoDataFoundError('Date is null');
        }

        if(timesheetEntry.get('minutes') == null) {
            generateNoDataFoundError('Minutes are null');
        }

        if(timesheetEntry.get('contractResourceId') == null) {
            generateNoDataFoundError('Contract resource is null');
        }

        Date timesheetEntryDate = Date.valueOf((String)timesheetEntry.get('date'));
        String contractResourceId = (String)timesheetEntry.get('contractResourceId');

        Map<String, Object> contractInfo = getContractInfo(contractResourceId, timesheetEntryDate);
        if(contractInfo.get('contractId') != null) {
            generateNoAccessError((String)contractInfo.get('contractError'));
        }
        
        Map<String, Object> timesheetInfo = getTimesheetInfo(contractResourceId, timesheetEntryDate);
        if(timesheetInfo.get('timesheetId') != null) {
            generateNoAccessError((String)timesheetInfo.get('timesheetError'));
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