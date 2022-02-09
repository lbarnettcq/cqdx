@isTest
private class cqtest_DomainCoverage {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        // build trigger request
        cq_TriggerRequest testTriggerRequest = new cq_TriggerRequest(Account.getSObjectType())
            .SetBefore(true)
            .SetInsert(true)
            .SetNewRecords(new List<Account>())
            .SetNewRecordMap(new Map<Id, Account>());
        
        // call SObjectDomain
        new cq_SObjectDomain(testTriggerRequest).ExecuteTriggerActions();
        Test.stopTest();
    }

    private class testDomainActionOne extends cq_DomainActionBase {
        public override void ProcessAction(cq_TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }

    private class testDomainActionTwo extends cq_DomainActionBase {
        public override void ProcessAction(cq_TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }
}