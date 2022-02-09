/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class apxt_cancelTransactionsInvocable {
    global apxt_cancelTransactionsInvocable() {

    }
    @InvocableMethod(label='Cancel Conga Sign Transactions' description='Cancel one to many Conga Sign transactions at one time.')
    global static List<APXT_CongaSign.apxt_cancelTransactionsInvocable.CancelTransactionsResult> cancelTransactions(List<APXT_CongaSign.apxt_cancelTransactionsInvocable.CancelTransactionsRequest> cancelTransactionsRequestList) {
        return null;
    }
global class CancelTransactionsRequest {
    @InvocableVariable(label='Send Cancellation Emails' description='Send emails to the recipients notifying them that the transaction is canceled.' required=true)
    global Boolean sendEmails;
    @InvocableVariable(label='Conga Sign Transaction Record Ids' description='The transaction record Ids to cancel.' required=true)
    global List<Id> transactionObjectIds;
    global CancelTransactionsRequest() {

    }
}
global class CancelTransactionsResult {
    @InvocableVariable(label='Message' description='A message on the result of submitting the canceling of the transactions.' required=true)
    global String message;
    @InvocableVariable(label='Submitting Cancellation Successful' description='The status on if the canceling of the transactions were successfully submitted.' required=true)
    global Boolean success;
    global CancelTransactionsResult() {

    }
}
}
