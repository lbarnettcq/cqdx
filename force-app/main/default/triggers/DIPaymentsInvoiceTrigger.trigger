trigger DIPaymentsInvoiceTrigger on Invoice__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	System.debug('### Running DIPaymentsInvoiceTrigger');

	Trigger_Settings__c settings = Trigger_Settings__c.getInstance();

	if (settings != null && settings.DIPaymentsInvoice_Trigger_Enabled__c == true)
	{
		if (Trigger.isAfter && Trigger.isUpdate) {
			Map<Id, Invoice__c> oldRecords = Trigger.oldMap;
			Map<Id, Invoice__c> newRecords = Trigger.newMap;

			List<Invoice__c> invoices = new List<Invoice__c>();

			for (Invoice__c newRecord : newRecords.values()) {
				Invoice__c oldRecord = oldRecords.get(newRecord.Id);

				if (oldRecord != null && oldRecord.Status__c != newRecord.Status__c) {
					invoices.add(newRecord);
				}
			}

			if(!invoices.isEmpty()) {
				service_Request request = new service_Request();
				request.Parameters.put('action', 'refreshPayments');
				request.Parameters.put('invoices', invoices);
				service_Response response = service_Controller.process(Services.Payments, request);
			}
		}
	}
}