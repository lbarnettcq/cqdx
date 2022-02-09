@IsTest
private class cqtest_LogHandler {
    @IsTest
    private static void regressionCoverage() {
        cq.App.Logger.Log(System.LoggingLevel.INFO, 'test manual');
        cq.App.Logger.Debug('test Debug');
        cq.App.Logger.Error(new cq.CriteriaException('Exception log test'));
        cq.App.Logger.Warning('test Warning');
        cq.App.Logger.Info('test Info');
    }
}