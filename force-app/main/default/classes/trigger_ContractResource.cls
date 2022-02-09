/**
 * Created by dcano on 12/27/19.
 */

public with sharing class trigger_ContractResource extends trigger_Domain
{
    public override void beforeInsert(List<sObject> newRecords)
    {
        service_Request request = new service_Request();
        request.Parameters.put('contractResources', (List<Contract_Resource__c>)newRecords);
        service_Response response = service_Controller.process(Services.ContractResourceRate, request);
    }

    public override void beforeUpdate(List<sObject> newRecords, List<sObject> oldRecords)
    {
        service_Request request = new service_Request();
        request.Parameters.put('contractResources', (List<Contract_Resource__c>)newRecords);
        service_Response response = service_Controller.process(Services.ContractResourceRate, request);
    }
}