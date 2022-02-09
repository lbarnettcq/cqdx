/**
 * Created by dcano on 12/27/19.
 */

public with sharing class service_ContractResourceRate extends service_Base
{
    private dao_Contract daoContract = new dao_Contract();
    private dao_PricebookEntry daoPricebookEntry = new dao_PricebookEntry();

    //TODO:UNIT TESTS: ADD TESTS
    public override void process(service_Request request, service_Response response)
    {
        List<Contract_Resource__c> contractResources = (List<Contract_Resource__c>) request.Parameters.get('contractResources');

        if (contractResources != null && !contractResources.isEmpty())
        {
            Set<Id> contractIds = sql_Utility.getIds(Contract_Resource__c.Contract__c, contractResources);
            List<Contract> contracts = (List<Contract>) daoContract.getByIds(contractIds);
            Map<Id, Contract> contractMap = new Map<Id, Contract>(contracts);

            Set<Id> pricebookIds = sql_Utility.getIds(Contract.Pricebook2Id, contracts);
            List<PricebookEntry> pricebookEntries = daoPricebookEntry.getPricebookEntriesByPricebook(pricebookIds);
            Map<Id, List<PricebookEntry>> pricebookEntryMap = new Map<Id, List<PricebookEntry>>();

            for (PricebookEntry pEntry : pricebookEntries)
            {
                if (!pricebookEntryMap.containsKey(pEntry.Product2Id))
                {
                    pricebookEntryMap.put(pEntry.Product2Id, new List<PricebookEntry>());
                }

                pricebookEntryMap.get(pEntry.Product2Id).add(pEntry);
            }

            dao_ContractResource daoContractResource = new dao_ContractResource();

            for (Contract_Resource__c contractResource : contractResources)
            {
                Contract cont = contractMap.get(contractResource.Contract__c);
                List<PricebookEntry> pentries = pricebookEntryMap.get(contractResource.Product__c);
                Boolean found = false;

                if (pentries != null && !pentries.isEmpty())
                {
                    for (PricebookEntry pentry : pentries)
                    {
                        if (pentry.Pricebook2Id == cont.Pricebook2Id
                        && pentry.Product2Id == contractResource.Product__c)
                        {
                            contractResource.Rate__c = pentry.UnitPrice;
                            found = true;
                        }
                    }
                }

                if (!found)
                {
                    contractResource.addError('PricebookEntry not found for Product selected!');
                }

                //TODO:extract and replace
                Contract_Resource__c cr = daoContractResource.findOne(contractResource.Contract__c,contractResource.Employee__c);
                if (cr != null && cr.Id != contractResource.Id)
                {
                    contractResource.addError('There is already a Contract Resource record for this employee. Please select another employee to proceed.');
                }
            }
        }
    }
}