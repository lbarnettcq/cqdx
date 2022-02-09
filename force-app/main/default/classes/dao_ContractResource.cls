/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_ContractResource extends sql_Dao {
    public dao_ContractResource() {
        setSObject(Contract_Resource__c.sObjectType);

        addField(Contract_Resource__c.Id);
        addField(Contract_Resource__c.Contract__c);
        addField(Contract_Resource__c.Employee__c);
        addField(Contract_Resource__c.Subcontractor_Account__c);
        addField(Contract_Resource__c.Product__c);
        addField(Contract_Resource__c.Rate__c);
    }

    public Contract_Resource__c findOne(String contractId, String employeeId) {
        String contractCriteria =  sql_Criteria.Equals(Contract_Resource__c.Contract__c, contractId);
        String employeeCriteria =  sql_Criteria.Equals(Contract_Resource__c.Employee__c, employeeId);

        List<String> andCriteria = new List<String>{contractCriteria, employeeCriteria};

        List<Contract_Resource__c> listContractResources = (List<Contract_Resource__c>)getWhere(sql_Criteria.AndCriterias(andCriteria));

        if(listContractResources.isEmpty()) {
            return null;
        }

        return listContractResources[0];
    }

    public Contract_Resource__c findOneById(String id) {
        List<Contract_Resource__c> contractResources = getWhere(sql_Criteria.Equals(Contract_Resource__c.Id, id));
        
        if(contractResources.isEmpty()) {
            return null;
        }

        return contractResources[0];
    }

    public List<Contract_Resource__c> findAll() {
        return (List<Contract_Resource__c>)getAll();
    }

    public List<Contract_Resource__c> findAllByIds(Set<String> ids) {
        if(ids != null && ids.isEmpty()) {
            return new List<Contract_Resource__c>();
        }

        return (List<Contract_Resource__c>)getWhere(sql_Criteria.ValueIn(Contract_Resource__c.Id, ids));
    }

    public List<Contract_Resource__c> findAllByAccount(String accountId) {
        List<Contract_Resource__c> listContractResources = [
            SELECT 
                  id,
                  Employee__c,
                  Product__c,
                  Rate__c,
                  Contract__c,
                  Contract__r.ContractNumber
            FROM
                  Contract_Resource__c
            WHERE 
                  contract__r.AccountId = :accountId          
        ];

        return listContractResources;
    }
    
    public List<Contract_Resource__c> findAllByContracts(Set<String> contractsIds) {
        if(contractsIds == null || contractsIds.isEmpty()) {
            return new List<Contract_Resource__c>();
        }
        return (List<Contract_Resource__c>)getWhere(sql_Criteria.ValueIn(Contract_Resource__c.Contract__c, contractsIds));
    }

    public List<Contract_Resource__c> findAllByUser(String userId) {
        return (List<Contract_Resource__c>)getWhere(sql_Criteria.Equals(Contract_Resource__c.Employee__c, userId));
    }

    public List<Contract_Resource__c> findAllWithSubcontractor() {
        return (List<Contract_Resource__c>)getWhere(sql_Criteria.IsNotNull(Contract_Resource__c.Subcontractor_Account__c));
    }

    public List<Contract_Resource__c> findAllByParams(Set<String> contractsIds, String employeeId) {
        List<String> criterias = new List<String>();

        if(contractsIds != null && !contractsIds.isEmpty()) {
            criterias.add(sql_Criteria.ValueIn(Contract_Resource__c.Contract__c, contractsIds));
        }

        if(String.isNotBlank(employeeId)) {
            criterias.add(sql_Criteria.Equals(Contract_Resource__c.Employee__c, employeeId));
        }

        String criteria = '';

        if(!criterias.isEmpty()) {
            criteria = sql_Criteria.AndCriterias(criterias);
        }
        
        return (List<Contract_Resource__c>)getWhere(criteria);
    }
}