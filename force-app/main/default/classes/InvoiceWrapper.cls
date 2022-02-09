public  class InvoiceWrapper implements Comparable {
    public Map<String, Object> invoice;

    public InvoiceWrapper(Map<String, Object> inv) {
        invoice = inv;
    }

    public  Integer compareTo(Object compareTo) {
        InvoiceWrapper compareToIW = (InvoiceWrapper)compareTo;
        
        Integer returnValue = 0;

        if ((Date)invoice.get('startDate') < (Date)compareToIW.invoice.get('startDate') ) {
            returnValue = 1;
        } else if ((Date)invoice.get('startDate') > (Date)compareToIW.invoice.get('startDate')) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}