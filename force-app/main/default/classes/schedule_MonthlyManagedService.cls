/**
 * Created by dcano on 10/7/19.
 */

global with sharing class schedule_MonthlyManagedService implements System.Schedulable
{
    global void execute(SchedulableContext sc)
    {
        batch_MonthlyManagedService.run();
    }
}