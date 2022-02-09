public with sharing class trigger_TestData extends test_Data
{
	public Contract contract1 { get; set; }
	public Case case1 { get; set; }
	public Case case2 { get; set; }
	public Case case3 { get; set; }

    public trigger_TestData() 
    {
    	Trigger_Settings__c settings = new Trigger_Settings__c();
    	settings.Case_Trigger_Enabled__c = true;
    	insert settings;

        contract1 = new Contract();
        contract1.AccountId = acct1.Id;
        contract1.StartDate = Date.today().addMonths(-1);
        contract1.ContractTerm = 12;
        contract1.Is_Managed_Services__c = true;
        contract1.Monthly_Case_Allotment__c = 40;
        contract1.Monthly_Developer_Hours__c = 12;
        contract1.Monthly_Cost__c = 2300;
        insert contract1;

        case1 = new Case();
        case1.AccountId = acct1.Id;
        case1.ContactId = cont1.Id;
        case1.OwnerId = UserInfo.getUserId();
        case1.Subject = 'TEST 1';
        case1.Description = 'TEST 1';
        insert case1;

        case2 = new Case();
        case2.AccountId = acct1.Id;
        case2.ContactId = cont2.Id;
        case2.OwnerId = UserInfo.getUserId();
        case2.Subject = 'TEST 2';
        case2.Description = 'TEST 2';
        insert case2;

        case3 = new Case();
        case3.AccountId = acct1.Id;
        case3.ContactId = cont2.Id;
        case3.OwnerId = UserInfo.getUserId();
        case3.Subject = 'TEST 3';
        case3.Description = 'TEST 3';
        insert case3;
    }
}