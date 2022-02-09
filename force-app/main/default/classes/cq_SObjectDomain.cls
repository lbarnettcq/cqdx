/**
 * Domain core implementation.
 * This class executes on behalf of all triggers, mapping CMDT-bound DomainActions to the appropriate Trigger process.
 */
public with sharing class cq_SObjectDomain implements cq_iSObjectDomain {
    private cq_TriggerProcess triggerProcess;
    private cq_TriggerRequest request;
    private Boolean disableTrigger = false;

    public cq_SObjectDomain(cq_TriggerRequest triggerRequest) {
        request = triggerRequest;
        if (request == null) { disableTrigger = true; }
    }

    private Boolean TriggersDisabled() {
        if (disableTrigger) { return disableTrigger; }
        CQ_Trigger_Config__c triggerConfig = CQ_Trigger_Config__c.getInstance();
        return (triggerConfig != null && triggerConfig.Disable_Triggers__c == true);
    }

    /**
     * Queries CQ_Domain_Action_Binding__mdt to find all cq_DomainAction implementations
     * Then executes them in sequence, passing in the Trigger's state & data
     */
    public void ExecuteTriggerActions() {
        if (TriggersDisabled()) { return; }
        List<CQ_Domain_Action_Binding__mdt> bindings = cq.App.DomainActionBindings().GetForTrigger(
            request.targetSObject.getDescribe().getName(), request.action, request.process
        );
        for (CQ_Domain_Action_Binding__mdt binding : bindings) {
            String actionName = binding.DomainActionImplementation__c;
            if (String.isBlank(actionName)) { continue; }
            Type actionType = Type.forName(actionName);
            if (actionType instanceOf cq_iDomainAction) {
                cq_iDomainAction dynamicAction = (cq_iDomainAction) actionType.newInstance();
                cq_ServiceResponse response = dynamicAction.Execute(
                    new cq_ServiceRequest(actionName, request.process + ' ' + request.action)
                        .WithParam('cq_TriggerRequest', request)
                );
                if (response.Status == cq_RequestStatus.ERROR) {
                    cq_LogHandler.Instance.Error(response.ThrownException);
                }
            }
        }
    }
}