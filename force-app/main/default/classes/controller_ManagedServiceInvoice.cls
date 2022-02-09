public with sharing class controller_ManagedServiceInvoice 
{
    private dao_MonthlyManagedService daoMonthlyManagedService = new dao_MonthlyManagedService();
    private dao_MonthlyManagedServiceActivity daoMonthlyManagedServiceActivity = new dao_MonthlyManagedServiceActivity();

	public Monthly_Managed_Service__c mms { get; set; }
    public List<Monthly_Managed_Service_Activity__c> mmsaList { get; set; }

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public controller_ManagedServiceInvoice(ApexPages.StandardController stdController) 
    {
        this.mms = (Monthly_Managed_Service__c) stdController.getRecord();
        this.mms = (Monthly_Managed_Service__c) daoMonthlyManagedService.getById(mms.Id);

        Set<Id> mmsIds = new Set<Id> { mms.Id };

        this.mmsaList = daoMonthlyManagedServiceActivity.getMonthlyManagedServiceActivitiesByMMS(mmsIds);
    }

    public String getRecordName() 
    {
        return 'Hello World!';
    }
}