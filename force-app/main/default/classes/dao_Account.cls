/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 */
public with sharing class dao_Account extends sql_Dao {
    public dao_Account() {
        setSObject(Account.sObjectType);

        addField(Account.Id);
        addField(Account.Name);
        addField(Account.Send_Invoice_To__c);
    }

    //SANDBOX 
    public List<Account> findAccountsByNames(Set<String> names) {
        if(names == null || names.isEmpty()) {
            return new List<Account>();
        }
        addOrderBy(sql_Order.Ascending(Account.Name));
        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Name, names));
    }

    public Account findOne(String accountId) {
        List<Account> accounts = getWhere(sql_Criteria.Equals(Account.Id, accountId));
        
        if(accounts.isEmpty()) {
            return null;
        }

        return accounts[0];
    }

    public List<Account> findAll() {
        addOrderBy(sql_Order.Ascending(Account.Name));
        return (List<Account>)getAll();
    }

    public List<Account> findAllByIds(Set<String> ids) {
        if(ids == null || ids.isEmpty()) {
            return new List<Account>();
        }
        addOrderBy(sql_Order.Ascending(Account.Name));
        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Id, ids));
    }

    public List<Account> findAllByNames(Set<String> names) {
        if(names == null || names.isEmpty()) {
            return new List<Account>();
        }
        addOrderBy(sql_Order.Ascending(Account.Name));
        return (List<Account>)getWhere(sql_Criteria.ValueIn(Account.Name, names));
    }

    public List<Account> findAllWithContracts(String status, String employeeId, String contractResourceId, Set<String> contractIds) {
        sql_Query contractsQuery = new sql_Query();

        contractsQuery.setSObject('Contracts');
        
        contractsQuery.addField(Contract.Id);
        contractsQuery.addField(Contract.ContractNumber);
        contractsQuery.addField(Contract.Status);
        contractsQuery.addField(Contract.StartDate);
        contractsQuery.addField(Contract.EndDate);

        List<String> listCriterias = new List<String>();

        if(String.isNotBlank(status)) {
            listCriterias.add(sql_Criteria.Equals(Contract.Status, status));
        }

        listCriterias.add(sql_Criteria.ValueIn(Contract.Id, createContractResourcesQuery(contractResourceId, employeeId, contractIds)));
        contractsQuery.setCriteria(sql_Criteria.AndCriterias(listCriterias));

        addChild(contractsQuery);
        addOrderBy(sql_Order.Ascending(Account.Name));
        List<Account> listAccounts = getAll();

        query.children.clear();

        return listAccounts;
    }

    private sql_Query createContractResourcesQuery(String contractResourceId, String employeeId, Set<String> contractIds) {
        sql_Query contractsQuery = new sql_Query();

        contractsQuery.setSObject('Contract_Resource__c');
        
        contractsQuery.addField(Contract_Resource__c.Contract__c);

        List<String> listCriterias = new List<String>();

        if(String.isNotBlank(contractResourceId)) {
           listCriterias.add(sql_Criteria.Equals(Contract_Resource__c.Id, contractResourceId));
        } else {
            if(String.isNotBlank(employeeId)) {
                listCriterias.add(sql_Criteria.Equals(Contract_Resource__c.Employee__c, employeeId));
            }

            if(contractIds != null && !contractIds.isEmpty()) {
                listCriterias.add(sql_Criteria.ValueIn(Contract_Resource__c.Contract__c, contractIds));
            }
        }

        if(listCriterias.size() > 0) {
            contractsQuery.setCriteria(sql_Criteria.AndCriterias(listCriterias));
        }

        return contractsQuery;
    }
}