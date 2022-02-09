public  class TimeReportsWrapper implements Comparable {
    public Map<String, Object> timereport;

    public TimeReportsWrapper(Map<String, Object> te) {
        timereport = te;
    }

    public  Integer compareTo(Object compareTo) {
        TimeReportsWrapper compareToTE = (TimeReportsWrapper)compareTo;
        
        Integer returnValue = 0;

        if ((Date)timereport.get('startDate') < (Date)compareToTE.timereport.get('startDate') ) {
            returnValue = 1;
        } else if ((Date)timereport.get('startDate') > (Date)compareToTE.timereport.get('startDate')) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}