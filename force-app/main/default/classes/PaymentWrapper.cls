public  class PaymentWrapper implements Comparable {
    public Map<String, Object> payment;

    public PaymentWrapper(Map<String, Object> pm) {
        payment = pm;
    }

    public  Integer compareTo(Object compareTo) {
        PaymentWrapper compareToPW = (PaymentWrapper)compareTo;
        
        Integer returnValue = 0;
        //TODO: change type from string to date
        if ((String)payment.get('startDate') < (String)compareToPW.payment.get('startDate')) {
            returnValue = 1;
        } else if ((String)payment.get('startDate') > (String)compareToPW.payment.get('startDate')) {
            returnValue = -1;
        }
        
        return returnValue;
    }
}