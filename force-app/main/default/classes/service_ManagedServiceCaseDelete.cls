public with sharing class service_ManagedServiceCaseDelete extends service_Base
{
	private dao_MonthlyManagedServiceActivity daoMonthlyManagedServiceActivity = new dao_MonthlyManagedServiceActivity();

	public override void process(service_Request request, service_Response response)
	{
		System.debug('### service_ManagedServiceCaseDelete.process');

		List<Case> cases = (List<Case>) request.Parameters.get('cases');

		if (cases != null && !cases.isEmpty())
		{
			Set<Id> caseIds = sql_Utility.getIds(Case.Id, cases);
			List<Monthly_Managed_Service_Activity__c> mmsaList = daoMonthlyManagedServiceActivity.getMonthlyManagedServiceActivitiesByCases(caseIds);

			if (mmsaList != null && !mmsaList.isEmpty())
			{
				System.debug('### service_ManagedServiceCaseDelete.process - Removing Monthly_Managed_Service_Activity__c');
				delete mmsaList;
			}
		}
	}
}