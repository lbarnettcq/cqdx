/**
 * Class description
 *
 * @author Dmytro Mytsko
 * @author Oleg Pasenchuk
 * @version 1.0.0
 */
public with sharing class service_Email extends service_Base {
    public override void process(service_Request request, service_Response response) {
        switch on (String)request.Parameters.get('action') {
            when 'send' {
                send(request, response);
            }          
        }
    }

    public void send(service_Request request, service_Response response) {
        String status = 'error';

        PageReference reportPage = (PageReference)request.Parameters.get('reportPage');
        String id = (String)request.Parameters.get('id');

        Messaging.SingleEmailMessage message = this.createMessage();

        Blob filePDF = this.createPdfFile(reportPage, id);

        if(filePDF != null) {
            Messaging.EmailFileAttachment attachment = this.createPDFAttachment('test', filePDF);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        }

        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{message});

        Messaging.SendEmailResult emailResult = result.get(0);

        if(emailResult.isSuccess()) {
            status = 'success';
        }

        response.Parameters.put('status', status);
    }

    private Messaging.SingleEmailMessage createMessage() {
        String[] recipientsEmails = new String[]{
            'dmytro@deepinspire.com'
        };

        String subject = 'Account summary for name';
        String body = 'Here\'s a summary for the name account.';

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(recipientsEmails);
        message.setSubject(subject);
        message.setHtmlBody(body);

        return message;
    }

    private Messaging.EmailFileAttachment createPDFAttachment(String fileName, Blob reportPdf) {
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setContentType('application/pdf');
        attachment.setFileName('Summary-' + fileName + '.pdf');
        attachment.setInline(false);
        attachment.setBody(reportPdf);

        return attachment;
    }

    private Blob createPdfFile(PageReference reportPage, String id) {
        reportPage.getParameters().put('id', id);

        Blob reportPdf;

        try {
            reportPdf = reportPage.getContentAsPDF();
        } catch (Exception e) {
            reportPdf = Blob.valueOf(e.getMessage());
        }

        return reportPdf;
    }
}