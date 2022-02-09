@isTest
private class cqtest_OrderBy {
    @isTest
    private static void regressionCoverage() {
        String scenario1 = 'Name ASC';
        String scenario2 = 'Name DESC';

        Test.startTest();

        String result1 = cq_OrderBy.Ascending(Account.Name).ForSoql();
        String result2 = cq_OrderBy.Descending(Account.Name).ForSoql();

        Test.stopTest();

        System.assertEquals(result1, scenario1);
        System.assertEquals(result2, scenario2);
    }
}