public with sharing class service_ManagedServiceCase extends service_Base
{
	private dao_Contract daoContract = new dao_Contract();
	private dao_MonthlyManagedService daoMonthlyManagedService = new dao_MonthlyManagedService();
	private dao_MonthlyManagedServiceActivity daoMonthlyManagedServiceActivity = new dao_MonthlyManagedServiceActivity();

	private Map<Id, List<Contract>> contractsMap;
	private Map<Id, List<Monthly_Managed_Service__c>> mmsMap;
	private Map<Id, Monthly_Managed_Service_Activity__c> mmsaMap;

	public override void process(service_Request request, service_Response response)
	{
		System.debug('### service_ManagedServiceCase.process');

		List<Case> cases = (List<Case>) request.Parameters.get('cases');

		if (cases != null && !cases.isEmpty())
		{
			Set<Id> acctIds = new Set<Id>();
			Set<Id> caseIds = new Set<Id>();

			for (Case tcase : cases)
			{
				acctIds.add(tcase.AccountId);
				caseIds.add(tcase.Id);
			}

			if (!acctIds.isEmpty())
			{
				System.debug('### service_ManagedServiceCase.process - Getting Contracts and Monthly Managed Services');

				getContractsMap(acctIds);
				getMonthlyManagedServicesMap(acctIds);
			}

			if (!caseIds.isEmpty())
			{
				System.debug('### service_ManagedServiceCase.process - Getting Monthly Managed Services Activities');

				getMonthlyManagedServiceActivitiesMap(caseIds);
			}

			if (cases != null && !cases.isEmpty())
			{
				List<Monthly_Managed_Service_Activity__c> mmsaListToInsert = new List<Monthly_Managed_Service_Activity__c>();
				
				for (Case tcase : cases)
				{
					Contract tcontract = getContract(tcase.AccountId, tcase.ClosedDate);

					if (tcontract != null && tcontract.Is_Managed_Services__c == true)
					{
						System.debug('### service_ManagedServiceCase.process - Found Contract');

						Decimal caseAllotment = tcontract.Monthly_Case_Allotment__c;
						Decimal developerHours = tcontract.Monthly_Developer_Hours__c;
						Decimal caseOverage = tcontract.Monthly_Case_Overage__c;
						Decimal developerHoursOverage = tcontract.Monthly_Developer_Hour_Overage__c;
						Decimal monthlyCost = tcontract.Monthly_Cost__c;

						Monthly_Managed_Service__c mms = getMonthlyManagedService(tcase.AccountId, tcase.ClosedDate);
						Monthly_Managed_Service__c pmms = getPreviousMonthlyManagedService(tcase.AccountId, tcase.ClosedDate);

						if (mms.Id == null)
						{
							System.debug('### service_ManagedServiceCase.process - Creating new Monthly Managed Service');

							Date bdate = tcase.ClosedDate.date().toStartOfMonth();
							Integer daysInMonth = Date.daysInMonth(bdate.year(), bdate.month());
							Date edate = bdate.addDays(daysInMonth - 1);

							if (pmms != null)
							{
								System.debug('### service_ManagedServiceCase.process - Carrying Over from Previous Month');
								caseAllotment = caseAllotment + pmms.Cases_to_Carryover__c;
								developerHours = developerHours + pmms.Developer_Hours_to_Carryover__c;
							}

							mms.Account__c = tcase.AccountId;
							mms.Begin_Date__c = bdate;
							mms.End_Date__c = edate;
							mms.Case_Allotment__c = caseAllotment;
							mms.Case_Overage_Cost__c = caseOverage;
							mms.Developer_Hours__c = developerHours;
							mms.Developer_Overage_Cost__c = developerHoursOverage;
							mms.Monthly_Base_Cost__c = monthlyCost;
							insert mms;
						}

						Monthly_Managed_Service_Activity__c mmsa = mmsaMap.get(tcase.Id);

						if (mmsa == null)
						{
							System.debug('### service_ManagedServiceCase.process - Getting Contracts and Monthly Managed Service Activity'); 
							
							mmsa = new Monthly_Managed_Service_Activity__c();
							mmsa.Activity_Type__c = 'Case';
							mmsa.Case__c = tcase.Id;
							mmsa.Date_Closed__c = tcase.ClosedDate.date();
							mmsa.Date_Opened__c = tcase.CreatedDate.date();
							mmsa.Monthly_Managed_Service__c = mms.Id;
							mmsa.Summary__c = tcase.Subject;
							mmsa.Who_Closed__c = tcase.OwnerId;
							mmsa.Who_Opened__c = tcase.ContactId;

							mmsaListToInsert.add(mmsa);
						}
					}
				}

				if (!mmsaListToInsert.isEmpty())
				{
					System.debug('### service_ManagedServiceCase.process - Inserting new Monthly Managed Services Activities');
					insert mmsaListToInsert;
				}
			}	
		}
	}

	private Monthly_Managed_Service__c getMonthlyManagedService(Id acctId, Datetime closedDate)
	{
		System.debug('### getMonthlyManagedService - AcctId: ' + acctId + ' ClosedDate: ' + closedDate);

		List<Monthly_Managed_Service__c> mmsList = mmsMap.get(acctId);

		if (mmsList != null 
		&& !mmsList.isEmpty())
		{
			for (Monthly_Managed_Service__c mms : mmsList)
			{
				if (mms.Begin_Date__c <= closedDate.date() 
				&& mms.End_Date__c >= closedDate.date())
				{
					System.debug('### getMonthlyManagedService Found Monthly Managed Service: ' + mms);
					return mms;
				}
			}
		}

		System.debug('### getMonthlyManagedService Did NOT Find Monthly Managed Service');
		
		return new Monthly_Managed_Service__c();
	}

	private Monthly_Managed_Service__c getPreviousMonthlyManagedService(Id acctId, Datetime closedDate)
	{
		System.debug('### getPreviousMonthlyManagedService - AcctId: ' + acctId + ' ClosedDate: ' + closedDate);

		List<Monthly_Managed_Service__c> mmsList = mmsMap.get(acctId);
		Date pcdate = closedDate.date().addMonths(-1);

		if (mmsList != null 
		&& !mmsList.isEmpty())
		{
			for (Monthly_Managed_Service__c mms : mmsList)
			{
				if (mms.Begin_Date__c <= pcdate 
				&& mms.End_Date__c >= pcdate)
				{
					System.debug('### getPreviousMonthlyManagedService Found Previous Monthly Managed Service: ' + mms);
					return mms;
				}
			}
		}
		
		System.debug('### getPreviousMonthlyManagedService Did NOT Find Previous Monthly Managed Service');

		return null;
	}

	private Contract getContract(Id acctId, Datetime closedDate)
	{
		System.debug('### getContract - AcctId: ' + acctId + ' ClosedDate: ' + closedDate);

		List<Contract> contracts = contractsMap.get(acctId);

		if (contracts != null 
		&& !contracts.isEmpty())
		{
			for (Contract tcontract : contracts)
			{
				if (tcontract.AccountId == acctId 
				&& tcontract.StartDate <=  closedDate.date()
				&& tcontract.EndDate >= closedDate.date())
				{
					System.debug('### getContract Found Contract: ' + tcontract);
					return tcontract;
				}
			}
		}

		System.debug('### getContract Did NOT Find Contract');

		return null;
	}

	private void getContractsMap(Set<Id> acctIds)
	{
		List<Contract> contracts = daoContract.getManagedServicesContractsByAccounts(acctIds);
		
		contractsMap = new Map<Id, List<Contract>>();

		if (contracts != null 
		&& !contracts.isEmpty())
		{
			for (Contract tcontract : contracts)
			{
				if (!contractsMap.containsKey(tcontract.AccountId))
				{
					contractsMap.put(tcontract.AccountId, new List<Contract>());
				}

				contractsMap.get(tcontract.AccountId).add(tcontract);
			}
		}
	}

	private void getMonthlyManagedServicesMap(Set<Id> acctIds)
	{
		List<Monthly_Managed_Service__c> mmsList = daoMonthlyManagedService.getMonthlyManagedServicesByAccounts(acctIds);
		
		mmsMap = new Map<Id, List<Monthly_Managed_Service__c>>();

		if (mmsList != null 
		&& !mmsList.isEmpty())
		{
			for (Monthly_Managed_Service__c mms : mmsList)
			{
				if (!mmsMap.containsKey(mms.Account__c))
				{
					mmsMap.put(mms.Account__c, new List<Monthly_Managed_Service__c>());
				}

				mmsMap.get(mms.Account__c).add(mms);
			}
		}
	}

	private void getMonthlyManagedServiceActivitiesMap(Set<Id> caseIds)
	{
		List<Monthly_Managed_Service_Activity__c> mmsaList = daoMonthlyManagedServiceActivity.getMonthlyManagedServiceActivitiesByCases(caseIds);
		
		mmsaMap = new Map<Id, Monthly_Managed_Service_Activity__c>();

		if (mmsaList != null 
		&& !mmsaList.isEmpty())
		{
			for (Monthly_Managed_Service_Activity__c mmsa : mmsaList)
			{
				if (!mmsaMap.containsKey(mmsa.Case__c))
				{
					mmsaMap.put(mmsa.Case__c, mmsa);
				}
			}
		}
	}
}