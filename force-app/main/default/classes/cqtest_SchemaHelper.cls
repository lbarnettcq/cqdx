@IsTest
private class cqtest_SchemaHelper {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        DescribeSObjectResult objectResult = cq_SchemaHelper.GetDescribe(Account.getSObjectType());
        DescribeFieldResult fieldResult = cq_SchemaHelper.GetDescribe(Account.Id);
        List<Integer> fieldHashesResult = cq_SchemaHelper.GetFieldHashes(Account.getSObjectType());
        Id generatedIdResult = cq_SchemaHelper.GenerateIdFor(Account.getSObjectType());
        Boolean userIsSetupObject = cq_SchemaHelper.IsSetupSObject(User.getSObjectType());
        Test.stopTest();
    }
}