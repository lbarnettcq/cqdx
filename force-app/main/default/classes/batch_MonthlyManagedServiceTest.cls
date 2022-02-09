/**
 * Created by dcano on 10/7/19.
 */

@IsTest
private class batch_MonthlyManagedServiceTest
{
    @IsTest
    static void testBehavior()
    {
        trigger_TestData data = new trigger_TestData();

        Test.startTest();

        batch_MonthlyManagedService.run();

        Test.stopTest();
    }
}