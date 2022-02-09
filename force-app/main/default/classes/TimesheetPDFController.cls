public with sharing class TimesheetPDFController {

    public Id timesheetId  { get; set; }
    public String recipientEmail { get; set; } 
    public List<Timesheet_Entry__c> timeList { get; set; }
    public List<Expense_Entry__c> expenseList { get; set; }
    TimesheetUtility timesheetUtility =  new TimesheetUtility();
    
    //Create the TimeSheet
    public Map<String, PageReference> TimesheetPDF;
    private List<Map<String,Object>> reports
    {
        get
        {
            if(null == reports)
            {
                reports = new List<Map<String,Object>>();

                Map<String,Object> timesheetPDF = new Map<String,Object>();
                timesheetPDF.put('name', 'timesheet');
                timesheetPDF.put('label', 'Timesheet');
                timesheetPDF.put('page', Page.TimesheetPDF);
                reports.add(timesheetPDF);

                this.TimesheetPDF = new Map<String,PageReference>();
                for(Map<String,Object> report : reports)
                {
                    this.TimesheetPDF.put(
                        (String)report.get('name'), (PageReference)report.get('page'));
                    
                }
            }
            return reports;
        }
        set;
    }


    public  TimesheetPDFController()
    {
        try
        {
            if(ApexPages.currentPage().getParameters().get('id') == null) 
            {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'No Id Found'));
                
                return;
                
            }
                

            timesheetId = Apexpages.currentPage().getParameters().get('id');

            if (String.isNotBlank(timesheetId))
            {
                dao_ExpenseEntry daoExpenseEntry = new dao_ExpenseEntry();

                expenseList = daoExpenseEntry.getExpenseEntryByTimesheet(timesheetId);
                //TODO: Let DI know about changes to dao_TimesheetEntry
                dao_TimesheetEntry daoTimesheetEntry = new dao_TimesheetEntry();

                timeList = daoTimesheetEntry.getTimesheetEntryByTimesheet(timesheetId);
            }
            // Check if VF is checking array at all
        }
        catch(System.ListException e) {
            if (timeList == null) {
                System.debug(e.getMessage());
            }
        }
    }

}