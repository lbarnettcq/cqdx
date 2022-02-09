public inherited sharing abstract class cq_DomainActionBase implements cq_iDomainAction {
    public cq_ServiceResponse Execute(cq_ServiceRequest request) {
        cq_ServiceResponse response = new cq_ServiceResponse(request);
        try {
            cq_TriggerRequest triggerRequest = cq_TriggerRequest.FromSvcRequest(request);
            ProcessAction(triggerRequest);
            response.Status = cq_RequestStatus.SUCCESS;
        } catch (Exception ex) {
            response.Status = cq_RequestStatus.ERROR;
            response.ThrownException = ex;
        }
        return response;
    }

    public abstract void ProcessAction(cq_TriggerRequest request);
}

/*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public inherited sharing class XXXX_AccountTriggers {
    public class FixName extends cq_DomainActionBase {
        public override void ProcessAction(cq_TriggerRequest request) {
            // safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            // do stuff here for/with name
        }
    }

    public class FixEmail extends cq_DomainActionBase {
        public override void ProcessAction(cq_TriggerRequest request) {
            // safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            // do stuff here for/with email
        }
    }
}

 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>*/