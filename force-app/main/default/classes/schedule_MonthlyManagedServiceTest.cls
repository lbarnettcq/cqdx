/**
 * Created by dcano on 10/7/19.
 */

@IsTest
private class schedule_MonthlyManagedServiceTest
{
    @IsTest
    static void testBehavior()
    {
        trigger_TestData data = new trigger_TestData();

        Test.startTest();

        String schedmon5am = '0 00 05 ? * 2';
        schedule_MonthlyManagedService mmsSchedule = new schedule_MonthlyManagedService();
        System.schedule('schedule_MonthlyManagedService', schedmon5am, mmsSchedule);

        Test.stopTest();
    }
}