/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_Contract extends sql_Dao {
        public dao_Contract() {
                setSObject(Contract.sObjectType);

                addField(Contract.Id);
                addField(Contract.Name);        
                addField(Contract.AccountId);      
                addField(Contract.EndDate);
                addField(Contract.StartDate);
                addField(Contract.Is_Managed_Services__c);
                addField(Contract.Monthly_Case_Allotment__c);
                addField(Contract.Monthly_Case_Overage__c);
                addField(Contract.Monthly_Cost__c);
                addField(Contract.Monthly_Developer_Hour_Overage__c);
                addField(Contract.Monthly_Developer_Hours__c);
                addField(Contract.ContractNumber);
                addField(Contract.Pricebook2Id);
                addField(Contract.Salesperson__c);
                addField(Contract.Commission_Rate__c);
                addField(Contract.Referred_By__c);
                addField(Contract.Referral_Rate__c);
                addField(Contract.Client_Manager__c);
                addField(Contract.Send_Invoice_To__c);
        }

        public Contract findOne(String contractId) {
                List<Contract> contracts = [
                        SELECT 
                                Account.Name,
                                Account.Id,
                                Contract.ContractNumber,
                                Contract.Id
                        FROM 
                                Contract
                        WHERE 
                                Contract.Id = :contractId 
                        LIMIT 1                                
                ];

                if(contracts.isEmpty()) {
                        return null;
                }

                return contracts.get(0);
        }

        public Contract findOneByContractResource(String contractResourceId) {
                List<Contract> contracts = [
                        SELECT 
                                Id,
                                ContractNumber,
                                Pricebook2Id,
                                Referred_By__c,
                                Referral_Rate__c,
                                Salesperson__c,
                                Commission_Rate__c,
                                Client_Manager__c,
                                StartDate,
                                EndDate,
                                Account.Name,
                                Account.Id
                        FROM 
                                Contract 
                        WHERE 
                                Contract.Id 
                        IN        
                                (SELECT 
                                        Contract_Resource__c.Contract__c
                                FROM
                                        Contract_Resource__c
                                WHERE 
                                        Contract_Resource__c.Id = :contractResourceId)             
                ];

                if(contracts.isEmpty()) {
                        return null;
                }

                return contracts[0];
        }

        public List<Contract> findAll() {
                List<Contract> contracts = [
                        SELECT 
                                Id,
                                ContractNumber,
                                Pricebook2Id,
                                Referred_By__c,
                                Referral_Rate__c,
                                Salesperson__c,
                                Commission_Rate__c,
                                Account.Name,
                                Account.Id
                        FROM 
                                Contract          
                ];

                return contracts;
        }

        public List<Contract> findAllByAccount(String accountId) {
                return (List<Contract>)getWhere(sql_Criteria.Equals(Contract.AccountId, accountId));
        }

        public List<Contract> findAllByStatus(String status) {
                return (List<Contract>)getWhere(sql_Criteria.Equals(Contract.Status, status));
        }

        public List<Contract> findAllBySalesperson(String employeeId) {
                return (List<Contract>)getWhere(sql_Criteria.Equals(Contract.Salesperson__c, employeeId));
        }  

        public List<Contract> findAllByReferral(String accountId) {
                return (List<Contract>)getWhere(sql_Criteria.Equals(Contract.Referred_By__c, accountId));
        }

        public List<Contract> getManagedServicesContractsByAccounts(Set<Id> acctIds) {
                if(acctIds == null || acctIds.isEmpty()) {
                        return new List<Contract>();
                }

                List<String> andCriterias = new List<String> {
                        sql_Criteria.ValueIn(Contract.AccountId, acctIds),
                        sql_Criteria.Equals(Contract.Is_Managed_Services__c, true)
                };

                String criteria = sql_Criteria.AndCriterias(andCriterias);

                return (List<Contract>)getWhere(criteria);
        }      

        public List<Contract> getContractsWithSalesperson() {
                String status = 'Activated';

                String criteria = sql_Criteria.AndCriterias(new List<String> {
                        sql_Criteria.IsNotNull(Contract.Salesperson__c),
                        sql_Criteria.Equals(Contract.Status, status)
                });

                return (List<Contract>)getWhere(criteria);
        }

        public List<Contract> getContractsWithReferral() {
                String status = 'Activated';

                String criteria = sql_Criteria.AndCriterias(new List<String> {
                        sql_Criteria.IsNotNull(Contract.Referred_By__c),
                        sql_Criteria.Equals(Contract.Status, status)
                });

                return (List<Contract>)getWhere(criteria);
        }
}