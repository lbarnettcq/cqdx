trigger DIInvoicesTimesheetTrigger on Timesheet__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	System.debug('### Running DIInvoicesTimesheetTrigger');

	Trigger_Settings__c settings = Trigger_Settings__c.getInstance();

	if (settings != null && settings.DIInvoicesTimesheet_Trigger_Enabled__c == true)
	{
		if (Trigger.isAfter && Trigger.isUpdate) {
			Map<Id, Timesheet__c> oldRecords = Trigger.oldMap;
			Map<Id, Timesheet__c> newRecords = Trigger.newMap;

			List<Timesheet__c> timesheets = new List<Timesheet__c>();

			for (Timesheet__c newRecord : newRecords.values()) {
				Timesheet__c oldRecord = oldRecords.get(newRecord.Id);
				if (oldRecord != null && oldRecord.Status__c != newRecord.Status__c && oldRecord.Status__c == 'Pending') {
					timesheets.add(newRecord);
				}
			}

			if(!timesheets.isEmpty()) {
				service_Request request = new service_Request();
				request.Parameters.put('action', 'refreshInvoices');
				request.Parameters.put('timesheets', timesheets);
				service_Response response = service_Controller.process(Services.Invoices, request);
			}
		}
	}
}