trigger ContractTrigger on Contract (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    Trigger_Settings__c settings = Trigger_Settings__c.getInstance();

    if (settings != null && settings.Contract_Trigger_Enabled__c == true) {
        System.debug('### Running ContractTrigger!');
        trigger_Controller.getInstance().process(Contract.sObjectType);
    }
}