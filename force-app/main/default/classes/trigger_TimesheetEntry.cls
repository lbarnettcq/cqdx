/**
 * Created by dcano on 12/27/19.
 */

public with sharing class trigger_TimesheetEntry extends trigger_Domain
{
    public override void beforeInsert(List<sObject> newRecords)
    { 
        service_Request request = new service_Request();
        request.Parameters.put('action', 'refresh');
        request.Parameters.put('newTimesheetEntries', (List<Timesheet_Entry__c>)newRecords);
        service_Response response = service_Controller.process(Services.Timesheets, request);
        System.debug('### newRecords ' + newRecords);
    }

    public override void afterUpdate(List<sObject> newRecords, List<sObject> oldRecords)
    {
        service_Request request = new service_Request();
        request.Parameters.put('action', 'refresh');
        request.Parameters.put('newTimesheetEntries', (List<Timesheet_Entry__c>)newRecords);
        request.Parameters.put('oldTimesheetEntries', (List<Timesheet_Entry__c>)oldRecords);
        service_Response response = service_Controller.process(Services.Timesheets, request);
        System.debug('### newRecords ' + newRecords);
    }
}