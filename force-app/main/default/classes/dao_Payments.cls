/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 */
public with sharing class dao_Payments extends sql_Dao {
    public dao_Payments() {
        setSObject(Payment__c.sObjectType);

        addField(Payment__c.Id);
        addField(Payment__c.Name);
        addField(Payment__c.ReceiverId__c);
        addField(Payment__c.startDate__c);
        addField(Payment__c.endDate__c);
        addField(Payment__c.Last_updated__c);
        addField(Payment__c.Is_Paid_Invoices__c);
        addField(Payment__c.Payment_type__c);
        addField(Payment__c.Is_Pending_invoices__c);
        addField(Payment__c.Pending_invoices_startDate__c);
        addField(Payment__c.Status__c);
        addField(Payment__c.Total_Amount__c);
        addField(Payment__c.Total_Minutes__c);
        addField(Payment__c.is_Paid__c);
        addField(Payment__c.paymentDate__c);
    }

    public Payment__c findOne(String paymentId) {
        List<Payment__c> payments = getWhere(sql_Criteria.Equals(Payment__c.Id, paymentId));
        
        if(payments.isEmpty()) {
            return null;
        }

        return payments[0];
    }

    public List<Payment__c> findByIds(Set<String> paymentsIds) {
        if(paymentsIds == null || paymentsIds.isEmpty()) {
            return new List<Payment__c>();
        }

        return (List<Payment__c>)getWhere(sql_Criteria.ValueIn(Payment__c.Id, paymentsIds));
    }

    public List<Payment__c> findAll() {
        addOrderBy(sql_Order.Descending(Payment__c.Name));
        return (List<Payment__c>)getAll();
    }

    public List<Payment__c> findByParams(Map<String, Object> conditions) {
        String criteria = '';

        if(conditions != null && !conditions.isEmpty()) {
            String paymentId = (String)conditions.get('paymentId');
            String paymentType = (String)conditions.get('paymentType');
            String receiverId = (String)conditions.get('receiverId');
            Date startDate = (Date)conditions.get('startDate');
            Date endDate = (Date)conditions.get('endDate');        
            Boolean paidInvoices = (Boolean)conditions.get('paidInvoices');
            Boolean pendingInvoices = (Boolean)conditions.get('pendingInvoices');
            Date pendingInvoicesStartDate = (Date)conditions.get('pendingInvoicesStartDate');

            List<String> andCriteria = new List<String>();

            if(String.isNotBlank(paymentId)) {
                andCriteria.add(sql_Criteria.NotEquals(Payment__c.Id, paymentId));
            }

            if(String.isNotBlank(paymentType)) {
                andCriteria.add(sql_Criteria.Equals(Payment__c.Payment_type__c, paymentType));
            }

            if(String.isNotBlank(receiverId)) {
                andCriteria.add(sql_Criteria.Equals(Payment__c.ReceiverId__c, receiverId));
            }

            Boolean excludeDateRange = (Boolean)conditions.get('excludeDateRange');
            if(excludeDateRange == null || excludeDateRange == false) {
                if(startDate != null) {
                    andCriteria.add(sql_Criteria.GreaterThanEquals(Payment__c.startDate__c, startDate));
                }

                if(endDate != null) {
                    andCriteria.add(sql_Criteria.LessThanEquals(Payment__c.endDate__c, endDate));
                }
            }

            if(paidInvoices != null) {
                andCriteria.add(sql_Criteria.Equals(Payment__c.Is_Paid_Invoices__c, paidInvoices));
            }

            if(pendingInvoices != null && pendingInvoicesStartDate != null) {
                andCriteria.add(sql_Criteria.Equals(Payment__c.Is_Pending_invoices__c, pendingInvoices));
                andCriteria.add(sql_Criteria.GreaterThanEquals(Payment__c.Pending_invoices_startDate__c, pendingInvoicesStartDate));
            }

            if(!andCriteria.isEmpty()) {
                criteria = sql_Criteria.AndCriterias(andCriteria);
            }
        }

        return (List<Payment__c>)getWhere(criteria);
    }

    public Boolean existPaymentsInPeriod(Map<String, Object> conditions) {
        if(conditions == null || conditions.isEmpty()) {
            return false;
        }

        conditions.put('excludeDateRange', true);        
        List<Payment__c> payments = findByParams(conditions);

        Date startDate = (Date)conditions.get('startDate');
        Date endDate = (Date)conditions.get('endDate');

        for(Payment__c payment : payments) {
             if(payment.startDate__c <= startDate && payment.endDate__c >= startDate){
                  return true;
             }
             if(payment.startDate__c >= startDate && payment.endDate__c <= endDate){
                  return true;
             }
             if(payment.startDate__c <= endDate && payment.endDate__c >= endDate){
                  return true;
             }
             if(payment.startDate__c <= startDate && payment.endDate__c >= endDate){
                  return true;
             }
        }

        return false;
    }
}