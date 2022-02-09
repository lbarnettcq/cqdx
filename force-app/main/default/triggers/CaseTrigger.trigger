trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
	Trigger_Settings__c settings = Trigger_Settings__c.getInstance();

	if (settings != null && settings.Case_Trigger_Enabled__c == true)
	{
		System.debug('### Running CaseTrigger!');
		trigger_Controller.getInstance().process(Case.sObjectType);
	}
}