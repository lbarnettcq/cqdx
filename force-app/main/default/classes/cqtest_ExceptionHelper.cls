@isTest
private class cqtest_ExceptionHelper {
    @isTest
    private static void regressionCoverage() {

        Test.startTest();

        String test1 = cq_ExceptionHelper.Format(new cq.CriteriaException('test 1'));
        String test2 = cq_ExceptionHelper.FormatVerbose(new cq.CriteriaException('test 2'));

        Test.stopTest();
    }
}