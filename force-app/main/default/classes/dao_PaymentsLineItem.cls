/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class dao_PaymentsLineItem extends sql_Dao {

    public dao_PaymentsLineItem() {
      setSObject(Payment_Line_Item__c.sObjectType);

      addField(Payment_Line_Item__c.Id);
      addField(Payment_Line_Item__c.Name);
      addField(Payment_Line_Item__c.Amount__c);
      addField(Payment_Line_Item__c.Minutes__c);
      addField(Payment_Line_Item__c.Contract_Resource__c);
      addField(Payment_Line_Item__c.Payment__c);
      addField(Payment_Line_Item__c.Rate__c);
    }


    public List<Payment_Line_Item__c> findByPayment(String paymentId) {
       return (List<Payment_Line_Item__c>)getWhere(sql_Criteria.Equals(Payment_Line_Item__c.Payment__c, paymentId));
    }
}