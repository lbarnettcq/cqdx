/**
 * Request object generated and sent by all .trigger classes into cq_SObjectDomain
 * Wraps all Trigger context data, so that cq_SObjectDomain can be executed manually via Unit Tests
 * Use Fluent Methods to insert data when outside of Trigger context
 */
public without sharing class cq_TriggerRequest {
    public SObjectType targetSObject { get; set; }
    public Boolean isBefore { get; set; }
    public Boolean isAfter { get; set; }
    public Boolean isInsert { get; set; }
    public Boolean isUpdate { get; set; }
    public Boolean isDelete { get; set; }
    public List<SObject> newRecords { get; set; }
    public List<SObject> oldRecords { get; set; }
    public Map<Id, SObject> newRecordMap { get; set; }
    public Map<Id, SObject> oldRecordMap { get; set; }

    public String action { get { return isBefore ? 'Before' : 'After'; } }

    public String process {
        get {
            return isInsert ? 'Insert'
                    : isUpdate ? 'Update'
                    : isDelete ? 'Delete'
                    : 'Unknown';
        }
    }

    public cq_TriggerProcess triggerProcess {
        get {
            return isBefore
            ? isInsert ? cq_TriggerProcess.BeforeInsert 
                : isUpdate ? cq_TriggerProcess.BeforeUpdate
                : isDelete ? cq_TriggerProcess.BeforeDelete
                : cq_TriggerProcess.Unknown
            : isInsert ? cq_TriggerProcess.AfterInsert 
                : isUpdate ? cq_TriggerProcess.AfterUpdate
                : isDelete ? cq_TriggerProcess.AfterDelete
                : cq_TriggerProcess.Unknown;
        }
    }

    public cq_TriggerRequest(SObjectType target) {
        targetSObject = target;
        isBefore = false;
        isAfter = false;
        isInsert = false;
        isUpdate = false;
        isDelete = false;
        if (!Trigger.isExecuting) { return; }
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;
        newRecords = Trigger.new;
        newRecordMap = Trigger.newMap;
        if (Trigger.isInsert) { return; }
        oldRecords = Trigger.old;
        oldRecordMap = Trigger.oldMap;
    }

    public cq_TriggerRequest SetBefore(Boolean state) { isBefore = state; return this; }
    public cq_TriggerRequest SetAfter(Boolean state) { isAfter = state; return this; }
    public cq_TriggerRequest SetInsert(Boolean state) { isInsert = state; return this; }
    public cq_TriggerRequest SetUpdate(Boolean state) { isUpdate = state; return this; }
    public cq_TriggerRequest SetDelete(Boolean state) { isDelete = state; return this; }
    public cq_TriggerRequest SetNewRecords(List<SObject> data) { newRecords = data; return this; }
    public cq_TriggerRequest SetNewRecordMap(Map<Id, SObject> data) { newRecordMap = data; return this; }
    public cq_TriggerRequest SetOldRecords(List<SObject> data) { oldRecords = data; return this; }
    public cq_TriggerRequest SetOldRecordMap(Map<Id, SObject> data) { oldRecordMap = data; return this; }

    public static cq_TriggerRequest FromSvcRequest(cq_ServiceRequest svc) {
        if (!svc.Parameters.containsKey('cq_TriggerRequest')) { return null; }
        Object val = svc.Parameters.get('cq_TriggerRequest');
        if (val instanceOf cq_TriggerRequest) { return (cq_TriggerRequest) val; }
        return null;
    }
}