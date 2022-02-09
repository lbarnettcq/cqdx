public with sharing class TimesheetUtility {
    //method giving ability to send TimesheetPDF
    //implements PDf method below
    public static void send_TimesheetPDF(String fileName, Blob b, List<String> emailAddresses) 
    {
        
        Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
        att.filename = fileName;
        att.contenttype = 'application/pdf';
        att.Body = b;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
        email.setSubject('This is a Subject');
        email.setHtmlBody('');
        email.setPlainTextBody('');
        email.setToAddresses(emailAddresses);


        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    //method that allows for pdf to be saved
    //inserts attachment into database
    public static void save_TimesheetPDF(ID ParentID, String fileName, Blob b) 
    {
        Attachment att = new Attachment();
        att.Body = b;
        att.ContentType = 'application/pdf';
        att.Name = fileName;
        att.ParentID = ParentID;

        insert att;
    }
}