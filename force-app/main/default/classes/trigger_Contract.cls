/**
 * Created by dcano on 12/27/19.
 */

public with sharing class trigger_Contract extends trigger_Domain
{
    public override void beforeInsert(List<sObject> newRecords)
    {
        service_Request request = new service_Request();
        request.Parameters.put('contracts', (List<Contract>)newRecords);
        request.Parameters.put('action', 'updateContract');
        service_Response response = service_Controller.process(Services.Contract, request);
    }
}