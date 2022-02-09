@IsTest
private class cqtest_ServiceResponse {
    private static cq_ServiceRequest newTestableRequest(String variant) {
        cq_ServiceRequest req = new cq_ServiceRequest();
        req.Name = 'Test Request '+variant;
        req.Action = 'Do the test '+variant;
        req.Parameters = null;
        return req;
    }

    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        cq_ServiceResponse resp1 = new cq_ServiceResponse(newTestableRequest('1'));
        cq_ServiceResponse resp2 = new cq_ServiceResponse(newTestableRequest('2'), cq_RequestStatus.FAILURE);
        cq_ServiceResponse resp3 = new cq_ServiceResponse(newTestableRequest('3'), cq_RequestStatus.ERROR, new cq.CriteriaException('test'));
        cq_ServiceResponse resp4 = new cq_ServiceResponse(newTestableRequest('4'), cq_RequestStatus.SUCCESS, new Account());
        Test.stopTest();
    }
}