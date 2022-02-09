/**
 * Core App Implementation.
 * Virtual class that provides easy access to bound Selectors, Logger and UoW instances.
 * This class should be extended by each DX Package. See bottom of this class for a template to accomplish this.
 */
public inherited sharing virtual class cq {
    // SINGLETON HANDLING
    private static cq m_instance;
    private cq() {}
    public static cq App {
        get {
            if (m_instance != null) { return m_instance; }
            m_instance = new cq();
            return m_instance;
        }
    }

    // LOGGER BINDING

    public cq_LogHandler Logger = cq_LogHandler.Instance;

    // UNIT OF WORK BINDING

    public virtual List<SObjectType> uowPrecedence() {
        return new List<SObjectType> {
            Account.SObjectType,
            Contact.SObjectType,
            Contract.SObjectType,
            Opportunity.SObjectType,
            OpportunityContactRole.SObjectType
    	};
    }

    public cq_iUnitOfWork UoW { get { return new cq_UnitOfWork(uowPrecedence()); } }

    // START: SELECTOR BINDINGS

    public virtual cq_DomainActionBindingsSelector DomainActionBindings() {
        return (cq_DomainActionBindingsSelector) bindingFor(
            CQ_Domain_Action_Binding__mdt.SObjectType
            , cq_DomainActionBindingsSelector.class); 
    }

    // END::: SELECTOR BINDINGS

    private Map<Schema.SObjectType, Object> selector_mappings = new Map<Schema.SObjectType, Object>();
    private cq_iSObjectSelector bindingFor(Schema.SObjectType sobj, Type target) {
        if (target == null) {
            throw new SelectorBindingException('Binding not provided for '+sobj.getDescribe().getName());
        }
        Object targetInstance = target.newInstance();
        if (!(targetInstance instanceOf cq_iSObjectSelector)) {
            throw new SelectorBindingException('Binding for '+sobj.getDescribe().getName()+' ['+target.getName()+'] is invalid');
        }
        if (!selector_mappings.containsKey(sobj)) {
            selector_mappings.put(
                    sobj,
                    targetInstance
            );
        }
        return (cq_iSObjectSelector) selector_mappings.get(sobj);
    }

    // SELECTOR MOCKING HANDLING

    public void MockSelectorBinding(SObjectType sobj, Type target) {
        if (target == null) {
            throw new SelectorBindingException('Mock Binding not provided for '+sobj.getDescribe().getName());
        }
        Object targetInstance = target.newInstance();
        if (!(targetInstance instanceOf cq_iSObjectSelector)) {
            throw new SelectorBindingException('Mock Binding for '+sobj.getDescribe().getName()+' ['+target.getName()+'] is invalid');
        }
        selector_mappings.put(sobj, targetInstance);
    }

    // EXCEPTIONS

    public class CriteriaException extends Exception {}
    public class SelectorBindingException extends Exception {}
}

/**
 * <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 * <><> TEMPLATE FOR EXTENDING CQ INTO YOUR OWN DX PACKAGE <><><><><><><><><><><><><><><><>
 * <><> COPY THE FOLLOWING CODE INTO A NEW CLASS, AND CHANGE THE PACKAGE ABBREVIATION  <><>
 * <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public inherited sharing virtual class XXXX extends cq {
    // SINGLETON HANDLING
    private static XXXX m_instance;
    private XXXX() {}
    public static XXXX App {
        get {
            if (m_instance != null) { return m_instance; }
            m_instance = new XXXX();
            return m_instance;
        }
    }
    
    public override List<SObjectType> uowPrecedence() {
        return new List<SObjectType> {
            // insert SObjectTypes your DX package touches here, in order of precedence
    	};
    }

    // EXAMPLE SELECTOR BINDINGS (add one for each SObject you use, if it isn't already present in CQ, or override an existing)
    
    public override AccountsSelector Accounts() {
        return (XXXX_AccountsSelector) bindingFor( Account.SObjectType, XXXX_AccountsSelector.class); 
    }
    
    public virtual XXXX_YYYYsSelector YYYYs() {
        return (XXXX_YYYYsSelector) bindingFor( YYYY.SObjectType, XXXX_YYYYsSelector.class); 
    }
}

 * <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 * <><> TEMPLATE FOR EXTENDING CQ INTO YOUR OWN DX PACKAGE <><><><><><><><><><><><><><><><>
 * <><> COPY THE ABOVE CODE INTO A NEW CLASS, AND CHANGE THE PACKAGE ABBREVIATION  <><><><>
 * <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 */