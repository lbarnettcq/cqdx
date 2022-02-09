public without sharing class DIInvoicesScratchOrgDataFactory {
  public static Integer daysInInvoicePeriod = 5;
  public static Integer invoicesQuantity = 20;

  public static List<Invoice__c> getInvoicesFromDb() {
    return [SELECT Id FROM Invoice__c];
  }

  public static void deleteTestData() {
    List<invoice__c> invoices = getInvoicesFromDb();
    delete invoices;
  }
}