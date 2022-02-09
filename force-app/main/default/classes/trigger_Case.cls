public with sharing class trigger_Case extends trigger_Domain
{
	public override void afterInsert(List<sObject> newRecords)
    {
        processManagedServiceCases((List<Case>) newRecords);
    }

    public override void afterUpdate(List<sObject> newRecords, List<sObject> oldRecords)
    {
        processManagedServiceCases((List<Case>) newRecords);
    }

    public override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords)
    {
        processDeletedManagedServiceCases((Map<Id, Case>) newRecords, (Map<Id, Case>) oldRecords);
    }

    public override void afterDelete(List<sObject> newRecords)
    {
        processDeletedManagedServiceCases((List<Case>) newRecords);
    }

    private void processManagedServiceCases(List<Case> cases)
    {
    	try
    	{
    		List<Case> casesToProcess = new List<Case>();

    		for (Case tcase : cases)
    		{
    			System.debug('### Case: ' + tcase);

    			if (tcase.Status == 'Closed' 
				&& tcase.ClosedDate != null 
				&& tcase.Is_Billable__c == true)
				{
					casesToProcess.add(tcase);
				}
    		}

    		service_Request request = new service_Request();
			request.Parameters.put('cases', casesToProcess);
			service_Response response = service_Controller.process(Services.ManagedServiceCase, request);
    	}
    	catch(Exception ex)
    	{
    		System.debug('### ERROR: ' + ex.getMessage() + ': ' + ex.getStackTraceString());
    	}
    }

    private void processDeletedManagedServiceCases(Map<Id, Case> newRecords, Map<Id, Case> oldRecords)
    {
    	List<Case> cases = newRecords.values();

        if (cases != null && !cases.isEmpty())
        {
        	List<Case> casesToProcess = new List<Case>();

	        for (Case tcase : cases)
	        {
	        	System.debug('### Case: ' + tcase);
	        	
	        	Case ocase = oldRecords.get(tcase.Id);

	        	if (ocase != null)
	        	{
	        		if (tcase.Is_Billable__c != ocase.Is_Billable__c 
	        		&& tcase.Is_Billable__c == false)
	        		{
	        			casesToProcess.add(tcase);
	        		}
	        	}
	        }

	        if (!casesToProcess.isEmpty())
	        {
	        	processDeletedManagedServiceCases(casesToProcess);
	        }
        }
    }

    private void processDeletedManagedServiceCases(List<Case> cases)
    {
    	try
    	{
    		service_Request request = new service_Request();
			request.Parameters.put('cases', cases);
			service_Response response = service_Controller.process(Services.ManagedServiceCaseDelete, request);
    	}
    	catch(Exception ex)
    	{
    		System.debug('### ERROR: ' + ex.getMessage() + ': ' + ex.getStackTraceString());
    	}
    }
}