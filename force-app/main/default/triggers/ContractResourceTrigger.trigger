trigger ContractResourceTrigger on Contract_Resource__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    Trigger_Settings__c settings = Trigger_Settings__c.getInstance();

    if (settings != null && settings.Contract_Resource_Trigger_Enabled__c == true) {
        System.debug('### Running ContractResourceTrigger!');
        trigger_Controller.getInstance().process(Contract_Resource__c.sObjectType);
    }
}