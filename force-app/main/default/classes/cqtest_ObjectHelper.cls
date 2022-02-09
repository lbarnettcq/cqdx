@IsTest
private class cqtest_ObjectHelper {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();

        String result1 = cq_ObjectHelper.ConvertToNumberForSoql(42);
        String result2 = cq_ObjectHelper.ConvertToBooleanForSoql(true);
        String result3 = cq_ObjectHelper.ConvertToDateForSoql(DateTime.now().date());
        String result4 = cq_ObjectHelper.ConvertToDateTimeForSoql(DateTime.now());
        String result5 = cq_ObjectHelper.ConvertToStringForSoql(99);

        Test.stopTest();
    }
}