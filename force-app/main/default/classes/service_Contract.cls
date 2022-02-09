/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Contract extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'getList' {
                getList(request, response);
            }
            when 'getListByAccount' {
                getListByAccount(request, response);
            }
            when 'updateContract' {
                updateContract(request, response);
            }
        }
    }

    public void getList(service_Request request, service_Response response) {       
        String status = (String)request.Parameters.get('status');

        dao_Contract daoContract = new dao_Contract();
        List<Contract> listContracts = daoContract.findAllByStatus(status);
        
        response.Parameters.put('list', listContracts); 
    }

    public void getListByAccount(service_Request request, service_Response response) {       
        String accountId = (String)request.Parameters.get('id');

        dao_Account daoAccount = new dao_Account();
        Account account = daoAccount.findOne(accountId);//TODO:replace frm sytem error to application error not found

        if(account == null) {
            generateNoDataFoundError('Account ' + accountId + '  not found');
        }

        dao_Contract daoContract = new dao_Contract();
        List<Contract> listContracts = daoContract.findAllByAccount(accountId);

        List<Map<String, String>> resultListContracts = new List<Map<String, String>>(); 

        for(Contract itemContract: listContracts) {           
            Map<String, String> item = new Map<String, String>{
                'id' => String.valueOf(itemContract.get('Id')),
                'contractNumber' => String.valueOf(itemContract.get('ContractNumber'))
            };
            resultListContracts.add(item);
        }

        response.Parameters.put('list', resultListContracts);
    }
    //TODO : ADD UNIT TEST
    public void updateContract(service_Request request, service_Response response) {      
        List<Contract> contracts = (List<Contract>)request.Parameters.get('contracts');
        List<Contract> contractsToUpdate = new List<Contract>();

        dao_Account daoAccount = new dao_Account();
        for(Contract contract : contracts) {
            Account account = daoAccount.findOne(contract.AccountId);

            if(account.Send_Invoice_To__c != null && contract.Send_Invoice_To__c == null) {
                contract.Send_Invoice_To__c = account.Send_Invoice_To__c;
                contractsToUpdate.add(contract);
            }
        }

        response.Parameters.put('list', contractsToUpdate);
    }

    private void generateNoDataFoundError(String message) {//TODO:extract to gloab error class
        NoDataFoundException ex = new NoDataFoundException();
        ex.setMessage(message);
        throw ex; 
    }
}