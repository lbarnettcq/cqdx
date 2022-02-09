/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_InvoicesLineItem extends sql_Dao {

    public dao_InvoicesLineItem() {
      setSObject(Invoice_Line_Item__c.sObjectType);

      addField(Invoice_Line_Item__c.Id);
      addField(Invoice_Line_Item__c.Name);
      addField(Invoice_Line_Item__c.Amount__c);
      addField(Invoice_Line_Item__c.Invoice__c);
      addField(Invoice_Line_Item__c.Timesheet__c);
      addField(Invoice_Line_Item__c.Expenses__c);
      addField(Invoice_Line_Item__c.Minutes__c);
    }

    public List<Invoice_Line_Item__c> findByInvoice(String invoiceId) {
       return (List<Invoice_Line_Item__c>)getWhere(sql_Criteria.Equals(Invoice_Line_Item__c.Invoice__c, invoiceId));
    }

    public Invoice_Line_Item__c findByTimesheet(String timesheetId) {
      List<Invoice_Line_Item__c> invoiceLineItems = getWhere(sql_Criteria.Equals(Invoice_Line_Item__c.Timesheet__c, timesheetId));

      if(invoiceLineItems.isEmpty()) {
         return null;
      }

      return invoiceLineItems[0];
    }
}