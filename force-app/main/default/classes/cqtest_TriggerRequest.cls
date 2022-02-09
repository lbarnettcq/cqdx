@isTest
private class cqtest_TriggerRequest {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        cq_TriggerRequest beforeTriggerRequest = new cq_TriggerRequest(Account.getSObjectType())
            .SetBefore(true)
            .SetAfter(false)
            .SetInsert(true)
            .SetUpdate(false)
            .SetDelete(false)
            .SetNewRecords(new List<Account>())
            .SetNewRecordMap(new Map<Id, Account>())
            .SetOldRecords(new List<Account>())
            .SetOldRecordMap(new Map<Id, Account>());
        cq_ServiceRequest svc = new cq_ServiceRequest().WithParam(
            'cq_TriggerRequest', 
            beforeTriggerRequest
        );
        cq_TriggerRequest afterTriggerRequest = cq_TriggerRequest.FromSvcRequest(svc);
        cq_TriggerProcess tp = afterTriggerRequest.triggerProcess;

        System.assertEquals(beforeTriggerRequest.isBefore, afterTriggerRequest.isBefore);
        System.assertEquals(beforeTriggerRequest.isAfter, afterTriggerRequest.isAfter);
        System.assertEquals(beforeTriggerRequest.isInsert, afterTriggerRequest.isInsert);
        System.assertEquals(beforeTriggerRequest.isUpdate, afterTriggerRequest.isUpdate);
        System.assertEquals(beforeTriggerRequest.isDelete, afterTriggerRequest.isDelete);
        System.assertEquals(beforeTriggerRequest.newRecords, afterTriggerRequest.newRecords);
        System.assertEquals(beforeTriggerRequest.newRecordMap, afterTriggerRequest.newRecordMap);
        System.assertEquals(beforeTriggerRequest.oldRecords, afterTriggerRequest.oldRecords);
        System.assertEquals(beforeTriggerRequest.oldRecordMap, afterTriggerRequest.oldRecordMap);

        afterTriggerRequest.SetUpdate(true);
        afterTriggerRequest.SetInsert(false);
        String proc = afterTriggerRequest.process;
        afterTriggerRequest.SetUpdate(false);
        afterTriggerRequest.SetDelete(true);
        String proc2 = afterTriggerRequest.process;
        
        Test.stopTest();
    }
}