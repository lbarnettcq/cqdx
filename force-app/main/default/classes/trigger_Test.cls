@isTest(SeeAllData=false)
private class trigger_Test 
{
    @isTest static void testTriggerDomain()
    {
        trigger_TestData data = new trigger_TestData();

        Test.startTest();

        trigger_Domain domain = new trigger_Domain();
        List<Account> accts = new List<Account>{ data.acct1, data.acct2 };
        Map<Id, Account> acctsMap = new Map<Id, Account>(accts);

        domain.beforeInsert(accts);
        domain.beforeInsert(acctsMap);
        domain.beforeUpdate(accts, accts);
        domain.beforeUpdate(acctsMap, acctsMap);
        domain.beforeDelete(accts);
        domain.beforeDelete(acctsMap);

        domain.afterInsert(accts);
        domain.afterInsert(acctsMap);
        domain.afterUpdate(accts, accts);
        domain.afterUpdate(acctsMap, acctsMap);
        domain.afterDelete(accts);
        domain.afterDelete(acctsMap);

        update data.acct1; 

        Test.stopTest();
    }

    @isTest static void testTriggerController()
    {
        trigger_TestData data = new trigger_TestData();

        Test.startTest();

        update data.acct1; 

        Test.stopTest();
    }

    @isTest static void testTriggerCase()
    {
        trigger_TestData data = new trigger_TestData();

        Test.startTest();

        data.case1.Status = 'Closed';
        update data.case1;

        data.case2.Status = 'Closed';
        update data.case2;

        data.case3.Status = 'Closed';
        update data.case3;

        data.case3.Is_Billable__c = false;
        update data.case3;

        Test.stopTest();
    }
}