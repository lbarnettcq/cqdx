@IsTest
private class cqtest_ServiceRequest {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        cq_ServiceRequest req = new cq_ServiceRequest();
        req.Name = 'Test Request';
        req.Action = 'Do the test';
        req.Parameters = null;

        cq_ServiceRequest req2 = new cq_ServiceRequest('1', '2');
        
        cq_ServiceRequest req3 = new cq_ServiceRequest('1', '2', new Map<String, Object>());
        Test.stopTest();
    }
}