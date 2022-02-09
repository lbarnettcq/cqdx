public without sharing class DIPaymentsScratchOrgDataFactory {
  public static List<Payment_Line_Item__c> getPaymentsLineItemsFromDb() {
    return [SELECT id FROM Payment_Line_Item__c];
  }

  public static List<Payment__c> getPaymentsFromDb() {
    return [SELECT id FROM Payment__c];
  }

  public static void deleteTestData() {
    List<Payment_Line_Item__c> paymentLineItems = getPaymentsLineItemsFromDb();
    delete paymentLineItems;

    List<Payment__c> payments = getPaymentsFromDb();
    delete payments;
  }
}