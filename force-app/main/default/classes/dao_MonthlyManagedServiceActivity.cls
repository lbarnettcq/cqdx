public with sharing class dao_MonthlyManagedServiceActivity extends sql_Dao
{
	public dao_MonthlyManagedServiceActivity() 
	{
		setSObject(Monthly_Managed_Service_Activity__c.sObjectType);

		addField(Monthly_Managed_Service_Activity__c.Id);
		addField(Monthly_Managed_Service_Activity__c.Name);
		addField(Monthly_Managed_Service_Activity__c.Activity_Type__c);
		addField(Monthly_Managed_Service_Activity__c.Case__c);
		addField(Monthly_Managed_Service_Activity__c.Date_Closed__c);
		addField(Monthly_Managed_Service_Activity__c.Date_Opened__c);
		addField(Monthly_Managed_Service_Activity__c.Development_Time_Hours__c);
		addField(Monthly_Managed_Service_Activity__c.Monthly_Managed_Service__c);
		addField(Monthly_Managed_Service_Activity__c.Summary__c);
		addField(Monthly_Managed_Service_Activity__c.Who_Closed__c);
		addField(Monthly_Managed_Service_Activity__c.Who_Opened__c);

		addField('Case__r.CaseNumber');
		addField('Who_Closed__r.Name');
		addField('Who_Closed__r.Title');
		addField('Who_Opened__r.Name');
		addField('Who_Opened__r.Title');
	}

	public List<Monthly_Managed_Service_Activity__c> getMonthlyManagedServiceActivitiesByCases(Set<Id> caseIds)
	{
		return (List<Monthly_Managed_Service_Activity__c>) getWhere(sql_Criteria.ValueIn(Monthly_Managed_Service_Activity__c.Case__c, caseIds));
	}

	public List<Monthly_Managed_Service_Activity__c> getMonthlyManagedServiceActivitiesByMMS(Set<Id> mmsIds)
	{
		return (List<Monthly_Managed_Service_Activity__c>) getWhere(sql_Criteria.ValueIn(Monthly_Managed_Service_Activity__c.Monthly_Managed_Service__c, mmsIds));
	}
}