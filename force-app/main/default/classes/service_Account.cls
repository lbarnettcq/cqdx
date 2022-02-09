/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Account extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
        }
    }

    public void getList(service_Request request, service_Response response) {       
        List<Map<String, Object>> resultListAccounts = new List<Map<String, Object>>();

        String contractStatus = (String)request.Parameters.get('status');
        String employeeId = (String)request.Parameters.get('employeeId');
        String timesheetId = (String)request.Parameters.get('timesheetId');
        String contractResourceId = null;

        if(String.isNotBlank(timesheetId)) {
            dao_Timesheet daoTimesheet = new dao_Timesheet();
            Timesheet__c timesheet = daoTimesheet.findOne(timesheetId);

            if(timesheet != null) {
                contractResourceId = timesheet.Contract_Resource__c;
            }
        }

        dao_Account daoAccount = new dao_Account();
        List<Account> listAccounts = daoAccount.findAllWithContracts(contractStatus, employeeId, contractResourceId, null);//TODO:replace order params
       
        if(!listAccounts.isEmpty()) {
            Set<String> contractIds = new Set<String>();

            Date startDate = (Date)request.Parameters.get('startDate');
            Date endDate = (Date)request.Parameters.get('endDate');

            if(startDate != null && endDate != null) {
                List<Timesheet_Entry__c>  timesheetEntries = getTimesheetEntries(employeeId, startDate, endDate);

                if(!timesheetEntries.isEmpty()) {
                    Set<String> countractResourceIds = new Set<String>();

                    for(Timesheet_Entry__c timesheetEntry : timesheetEntries){
                        countractResourceIds.add(timesheetEntry.Contract_Resource__c);
                    }

                    dao_ContractResource daoContractResource = new dao_ContractResource();
                    List<Contract_Resource__c> listContractResources = daoContractResource.findAllByIds(countractResourceIds);

                    for(Contract_Resource__c contractResource : listContractResources) {
                        contractIds.add(contractResource.Contract__c);
                    }                    
                } 
            }

            for(Account account : listAccounts) {
                List<Contract> listContracts = account.Contracts;
                List<Map<String,Object>> resultListContracts = new List<Map<String,Object>>();

                for(Contract contract : listContracts) {

                    if(startDate != null && endDate != null) {
                        if(contract.StartDate <= endDate && contract.EndDate >= startDate){
                                Map<String, Object> contractItem = new Map<String,Object> {
                                  'id' => contract.Id,
                                  'contractNumber' => contract.ContractNumber,
                                  'status'=> (contractIds.contains(contract.Id)) ? 'active' : 'unactive'
                                };

                                resultListContracts.add(contractItem);
                            }
                    } else {
                                Map<String, Object> contractItem = new Map<String,Object> {
                                  'id' => contract.Id,
                                  'contractNumber' => contract.ContractNumber,
                                  'status'=> (contractIds.contains(contract.Id)) ? 'active' : 'unactive'
                                };

                                resultListContracts.add(contractItem);
                    }
                }

                if(!resultListContracts.isEmpty()) {
                    Map<String, Object> accountItem = new Map<String,Object> {
                        'id' => account.Id,
                        'name' => account.Name,
                        'contracts' => resultListContracts
                    };

                    resultListAccounts.add(accountItem);
                }
            }
        }

        response.Parameters.put('list', resultListAccounts);
    }

    //TODO: review and discussion; extract to service timesheet entries
    private List<Timesheet_Entry__c> getTimesheetEntries(String employeeId, Date startDate, Date endDate) {
        Map<String, Object> conditions = new Map<String, Object> {
            'startDate' => startDate,
            'endDate' => endDate,
            'employeeId' => employeeId
        };

        dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();
        List<Timesheet_Entry__c> listTimesheetEntries = daoTimesheetEntry.findByDateRange(conditions);

        final Integer PREVIOUS_WEEK = -7;

        conditions.put('startDate', startDate.addDays(PREVIOUS_WEEK));
        conditions.put('endDate', endDate.addDays(PREVIOUS_WEEK));
    
        listTimesheetEntries.addAll(daoTimesheetEntry.findByDateRange(conditions));

        return listTimesheetEntries;
    }
}