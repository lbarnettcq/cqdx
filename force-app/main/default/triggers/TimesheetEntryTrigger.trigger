trigger TimesheetEntryTrigger on Timesheet_Entry__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    Trigger_Settings__c settings = Trigger_Settings__c.getInstance();
    
    if (settings != null && settings.Timesheet_Entry_Trigger_Enabled__c == true) {
        System.debug('### Running TimesheetEntryTrigger!');
        trigger_Controller.getInstance().process(Timesheet_Entry__c.sObjectType);
    }
}