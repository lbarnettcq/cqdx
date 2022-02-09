/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_ContractResource extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getId' {
                getId(request, response);
            }
            when 'getListByAccount' {
                getListByAccount(request, response);
            }
        }
    }

    public void getId(service_Request request, service_Response response) { 
        Id contractResourceId = null;

        String contractId = (String)request.Parameters.get('contractId');
        String employeeId = (String)request.Parameters.get('employeeId');

        dao_ContractResource daoContractResource = new dao_ContractResource();
        Contract_Resource__c contractResource = daoContractResource.findOne(contractId, employeeId);

        if(contractResource != null) {
            contractResourceId = contractResource.Id;
        }

        response.Parameters.put('id', contractResourceId);
    }

    public void getListByAccount(service_Request request, service_Response response) {       
        String accountId = (String)request.Parameters.get('accountId');

        dao_ContractResource daoContractResource = new dao_ContractResource();
        List<Contract_Resource__c> listContractResources = daoContractResource.findAllByAccount(accountId);

        List<Map<String, Object>> contractsAndUsersList = new List<Map<String, Object>>();

        for(Contract_Resource__c itemContractResource : listContractResources) {
            Map<String, Object> item = new Map<String, Object>{
                'contractResourceId' => itemContractResource.Id,
                'contractId' => itemContractResource.Contract__c,
                'contractNumber' => itemContractResource.Contract__r.ContractNumber,
                'userName' => getUserName(itemContractResource.Employee__c),//TODO: add relation for user
                'userId' => itemContractResource.Employee__c
            };

            contractsAndUsersList.add(item);
        }

        response.Parameters.put('list', contractsAndUsersList);
    }

    //TODO: remove and replace for relation
    private static String getUserName(String userId) {
        String userName = null;

        service_Request request = new service_Request();
        request.Parameters.put('userId', userId);
        request.Parameters.put('action', 'getUserById');

        service_Response response = service_Controller.process(Services.User, request);

        Map<String, String> userData = (Map<String, String>)response.Parameters.get('user');

        if(userData != null) {                  
            userName = userData.get('name');
        }

        return userName;
    }
}