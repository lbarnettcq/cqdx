public with sharing class dao_MonthlyManagedService extends sql_Dao
{
	public dao_MonthlyManagedService() 
	{
		setSObject(Monthly_Managed_Service__c.sObjectType);

		addField(Monthly_Managed_Service__c.Id);
		addField(Monthly_Managed_Service__c.Name);
		addField(Monthly_Managed_Service__c.Account__c);
		addField(Monthly_Managed_Service__c.Begin_Date__c);
		addField(Monthly_Managed_Service__c.Case_Allotment__c);
		addField(Monthly_Managed_Service__c.Case_Overage_Cost__c);
		addField(Monthly_Managed_Service__c.Cases_Over__c);
		addField(Monthly_Managed_Service__c.Cases_to_Carryover__c);
		addField(Monthly_Managed_Service__c.Developer_Hours__c);
		addField(Monthly_Managed_Service__c.Developer_Hours_Over__c);
		addField(Monthly_Managed_Service__c.Developer_Hours_to_Carryover__c);
		addField(Monthly_Managed_Service__c.Developer_Overage_Cost__c);
		addField(Monthly_Managed_Service__c.End_Date__c);
		addField(Monthly_Managed_Service__c.Monthly_Base_Cost__c);
		addField(Monthly_Managed_Service__c.Monthly_Case_Overage_Cost__c);
		addField(Monthly_Managed_Service__c.Monthly_Developer_Overage_Cost__c);
		addField(Monthly_Managed_Service__c.Monthly_Total_Cost__c);
		addField(Monthly_Managed_Service__c.Total_Cases__c);
		addField(Monthly_Managed_Service__c.Total_Developer_Hours__c);

		addField('Account__r.Name');
		addField('Account__r.BillingStreet');
		addField('Account__r.BillingCity');
		addField('Account__r.BillingState');
		addField('Account__r.BillingPostalCode');
	}

	public List<Monthly_Managed_Service__c> getMonthlyManagedServicesByAccounts(Set<Id> acctIds)
	{
		return (List<Monthly_Managed_Service__c>) getWhere(sql_Criteria.ValueIn(Monthly_Managed_Service__c.Account__c, acctIds));
	}

	public List<Monthly_Managed_Service__c> getMonthlyManagedServicesByAccountsAndDates(Set<Id> acctIds, Date beginDate, Date endDate)
	{
		String criteria = sql_Criteria.AndCriterias(new List<String> {
			sql_Criteria.ValueIn(Monthly_Managed_Service__c.Account__c, acctIds),
			sql_Criteria.Equals(Monthly_Managed_Service__c.Begin_Date__c, beginDate),
			sql_Criteria.Equals(Monthly_Managed_Service__c.End_Date__c, endDate)
		});
		return (List<Monthly_Managed_Service__c>) getWhere(criteria);
	}
}