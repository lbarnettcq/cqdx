/**
 * Executes SOQL against CQ_Domain_Action_Binding__mdt
 */
public without sharing class cq_DomainActionBindingsSelector extends cq_SObjectSelector {
    public cq_DomainActionBindingsSelector() { super(CQ_Domain_Action_Binding__mdt.SObjectType); }

    // implement required GetDefaultFields() method
    public override Set<Schema.SObjectField> GetDefaultFields() {
        return new Set<Schema.SObjectField> {
            CQ_Domain_Action_Binding__mdt.SObject__c,
            CQ_Domain_Action_Binding__mdt.WhenToProcess__c,
            CQ_Domain_Action_Binding__mdt.TriggeredWhen__c,
            CQ_Domain_Action_Binding__mdt.DomainActionImplementation__c,
            CQ_Domain_Action_Binding__mdt.Sequence__c
        };
    }

    // implement required GetDefaultOrderBy() method
    public override List<cq_iOrderBy> GetDefaultOrderBy() {
        return new List<cq_iOrderBy> {
            cq_OrderBy.Ascending(CQ_Domain_Action_Binding__mdt.Sequence__c),
            cq_OrderBy.Ascending(CQ_Domain_Action_Binding__mdt.DomainActionImplementation__c)
        };
    }

    /**
     * Query for retrieving Trigger-specific DomainAction bindings
     * @param  targetSObject String     The SObject the Trigger is executing on
     * @param  process       process    Before/After
     * @param  action        action     Insert/Update/Delete
     * @return  List of CQ_Domain_Action_Binding__mdt entries
     */
    public List<CQ_Domain_Action_Binding__mdt> GetForTrigger(String targetSObject, String process, String action) {
        cq_iQueryFactory qf = GetQueryFactory()
            .WithCriteria(cq_Criteria.Equals(CQ_Domain_Action_Binding__mdt.SObject__c, targetSObject))
            .WithCriteria(cq_Criteria.Equals(CQ_Domain_Action_Binding__mdt.WhenToProcess__c, process))
            .WithCriteria(cq_Criteria.Equals(CQ_Domain_Action_Binding__mdt.TriggeredWhen__c, action));
        // THE PROCESS BELOW SHOULD ONLY BE REPEATED FOR CMDT SOBJECTS
        // YOU CAN NOT INSERT CMDT DURING A UNIT TEST, SO THIS HACK LETS THE UNIT TESTS HAPPEN
        // DO NOT REPEAT THIS PATTERN IN A NORMAL SOBJECT SELECTOR
        if (Test.isRunningTest()) {
            String sObjectName = Account.getSObjectType().getDescribe().getName();
            return new List<CQ_Domain_Action_Binding__mdt>{
                new CQ_Domain_Action_Binding__mdt(
                    SObject__c = sObjectName,
                    WhenToProcess__c = 'Before',
                    TriggeredWhen__c = 'Insert',
                    DomainActionImplementation__c = 'cqtest_SObjectDomain.testDomainActionOne',
                    Sequence__c = 10
                ),
                new CQ_Domain_Action_Binding__mdt(
                    SObject__c = sObjectName,
                    WhenToProcess__c = 'Before',
                    TriggeredWhen__c = 'Insert',
                    DomainActionImplementation__c = 'cqtest_SObjectDomain.testDomainActionOnenTwo',
                    Sequence__c = 10
                )
            };
        } else {
            return (List<CQ_Domain_Action_Binding__mdt>) qf.Execute();
        }
    }
}