public  class TimesheetEntryWrapper implements Comparable {
    public Map<String, Object> timesheetEntry;

    public TimesheetEntryWrapper(Map<String, Object> te) {
        timesheetEntry = te;
    }

    public  Integer compareTo(Object compareTo) {
        TimesheetEntryWrapper compareToTE = (TimesheetEntryWrapper)compareTo;
        
        Integer returnValue = 0;

        if ((Date)timesheetEntry.get('startDate') < (Date)compareToTE.timesheetEntry.get('startDate') ) {
            returnValue = 1;
        } else if ((Date)timesheetEntry.get('startDate') > (Date)compareToTE.timesheetEntry.get('startDate')) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}