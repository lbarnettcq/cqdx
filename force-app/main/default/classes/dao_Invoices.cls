/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_Invoices extends sql_Dao {

    public dao_Invoices() {
      setSObject(Invoice__c.sObjectType);

      addField(Invoice__c.Id);
      addField(Invoice__c.Name);
      addField(Invoice__c.startDate__c);
      addField(Invoice__c.endDate__c);
      addField(Invoice__c.Status__c);
      addField(Invoice__c.Account__c);
      addField(Invoice__c.dueDate__c);
      addField(Invoice__c.issueDate__c);
      addField(Invoice__c.is_Paid__c);
      addField(Invoice__c.Amount__c);
      addField(Invoice__c.paymentDate__c);
      addField(Invoice__c.Expenses__c);
      addField(Invoice__c.Minutes__c);
      addField(Invoice__c.invoice.Last_updated__c);
    }

     public Invoice__c findOne(String invoiceId) {
          List<Invoice__c>  invoices = getWhere(sql_Criteria.Equals(Invoice__c.Id, invoiceId));

          if(invoices.isEmpty()) {
               return null;
          }

          return invoices[0];
     }

     public Invoice__c findOneByDates(Map<String, Object> conditions) {
          if(conditions == null || conditions.isEmpty()) {
               return null;
          }

          Date startDate = (Date)conditions.get('startDate');
          Date endDate = (Date)conditions.get('endDate');
          
          if(startDate == null || endDate == null) {
               return null;
          }

          String startDateCriteria = sql_Criteria.LessThanEquals(Invoice__c.startDate__c, startDate);
          String endDateCriteria = sql_Criteria.GreaterThanEquals(Invoice__c.endDate__c, endDate);

          List<String> andCriteria = new List<String>{
               startDateCriteria,
               endDateCriteria
          };

          String status = (String)conditions.get('status');
          if(status != null) {
               andCriteria.add(sql_Criteria.Equals(Invoice__c.Status__c, status));
          }
          
          String accountId = (String)conditions.get('accountId');
          if(accountId != null) {
               andCriteria.add(sql_Criteria.Equals(Invoice__c.Account__c, accountId));
          }
          
          List<Invoice__c> invoices = getWhere(sql_Criteria.AndCriterias(andCriteria));

          if(invoices.isEmpty()) {
               return null;
          }

          return invoices[0];
     }

     public List<Invoice__c> findAll(Integer limits, Integer offsets) {//TODO: remove parameters
          return (List<Invoice__c>)getAll();
     }

     public List<Invoice__c> findAllByParams(Map<String, Object> conditions) {
          if(conditions == null || conditions.isEmpty()) {
               return new List<Invoice__c>();
          }

          List<String> andCriteria = new List<String>{};

          Date startDate = (Date)conditions.get('startDate');
          if(startDate != null) {
               andCriteria.add(sql_Criteria.GreaterThanEquals(Invoice__c.startDate__c, startDate));
          }

          Date endDate = (Date)conditions.get('endDate');
          if(endDate != null) {
               andCriteria.add(sql_Criteria.LessThanEquals(Invoice__c.endDate__c, endDate));
          }

          Set<String> accountIds = (Set<String>)conditions.get('accountIds');
          if(accountIds != null) {
               andCriteria.add(sql_Criteria.ValueIn(Invoice__c.Account__c, accountIds));
          }
          
         
          String status = (String)conditions.get('status');
          if(status != null) {
               String statusCriteria = sql_Criteria.Equals(Invoice__c.Status__c, status);

               Date pendingInvoicesStartDate = (Date)conditions.get('pendingInvoicesStartDate');
               if(pendingInvoicesStartDate != null && status == 'Pending') {
                    Datetime pendingInvoicesStartDatetime = Datetime.newInstance(pendingInvoicesStartDate.year(), pendingInvoicesStartDate.month(), pendingInvoicesStartDate.day());
                    String pendingInvoicesStartDateCriteria = sql_Criteria.GreaterThanEquals(Invoice__c.Last_updated__c, pendingInvoicesStartDatetime);
                    andCriteria.add(pendingInvoicesStartDateCriteria);
               }
          }

          if(andCriteria.isEmpty()) {
               return new List<Invoice__c>();
          }

          return (List<Invoice__c>)getWhere(sql_Criteria.AndCriterias(andCriteria));
     }

    public Boolean checkDatesInPeriods(Map<String, Object> conditions) {
          if(conditions == null || conditions.isEmpty()) {
               return true;
          }

          String accountId = (String)conditions.get('accountId');
          Date startDate = (Date)conditions.get('startDate');
          Date endDate = (Date)conditions.get('endDate');

          if(accountId == null || startDate == null || endDate == null) {
               return true;
          }

          String invoiceId = (String)conditions.get('invoiceId');

          List<String> andCriteria = new List<String>();
          andCriteria.add(sql_Criteria.Equals(Invoice__c.Account__c, accountId));

          if(String.isNotBlank(invoiceId)) {
               andCriteria.add(sql_Criteria.NotEquals(Invoice__c.Id, invoiceId));
          }  

          List<Invoice__c> invoices = getWhere(sql_Criteria.AndCriterias(andCriteria)); 

          for(Invoice__c invoice : invoices) {
               if(invoice.startDate__c <= startDate && invoice.endDate__c >= startDate){
                    return false;
               }
               if(invoice.startDate__c >= startDate && invoice.endDate__c <= endDate){
                    return false;
               }
               if(invoice.startDate__c <= endDate && invoice.endDate__c >= endDate){
                    return false;
               }
               if(invoice.startDate__c <= startDate && invoice.endDate__c >= endDate){
                    return false;
               }
          }

          return true;
    }
}