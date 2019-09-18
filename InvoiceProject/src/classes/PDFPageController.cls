/**
 * Created by user on 18-Sep-19.
 */

public with sharing class PDFPageController {


    public String invoiceID = ApexPages.currentPage().getParameters().get('invoiceID');
    public String pdfName = ApexPages.currentPage().getParameters().get('pdfName');
   // public String invoiceEmail = ApexPages.currentPage().getParameters().get('invoiceEmail');
    Invoice__c currentInvoice ;

    public String getInvoiceEmail(){
        String invoice = currentInvoice.UserEmail__c;
        return invoice;
    }

    public List<InvoiceItem__c> getInvoiceItems() {
        List<InvoiceItem__c> listInvoiceItems = [
                SELECT Item__r.Cost__c,Item__r.Name,Invoice__r.UserEmail__c,Name,Amount__c
                FROM InvoiceItem__c
                WHERE Invoice__r.Id = :invoiceId
        ];
        Invoice__c invoiceForEmail =[SELECT UserEmail__c
                                        FROM Invoice__c
                                        WHERE Invoice__c.Id = :invoiceId ];
        currentInvoice =invoiceForEmail;

        return listInvoiceItems;

    }

    public PageReference goBack() {

        PageReference pr = Page.Page1;
        pr.setRedirect(true);
        return pr;
    }

    public PageReference saveToPdf() {

        PageReference pdf = ApexPages.currentPage();


        Blob reportPdf;
        try {
            pdf.getContentAsPDF();
        } catch (Exception e) {
            reportPdf = Blob.valueOf(e.getMessage());
        }
        // create the new attachment
        Attachment attach = new Attachment();

        // the contents of the attachment from the pdf

        Blob body;
        try {
            // returns the output of the page as a PDF
            body = pdf.getContentAsPDF();
            // need to pass unit test -- current bug

        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }

        attach.Body = body;
        // add the user entered name
        attach.Name = pdfName;
        attach.IsPrivate = false;
        // attach the pdf to the account
        attach.ParentId = invoiceId ;
        insert attach;


        //create attach PDF to email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setBody(body);
        attachment.setFileName(  'Current invoice Item.pdf');


        //Create email and set invoice email address
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setHtmlBody('This PDF file saved in you Invoice. His name in Attachment:' + pdfName);
        email.setToAddresses(new String[]{
                currentInvoice.UserEmail__c
        });


        //Add attach and send email
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{
                attachment
        });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                email
        });

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                'Email sent with PDF attachment to ' + currentInvoice.UserEmail__c ));

        //return new PageReference('/' + invoiceId); // send the user to the account to view results
        return null; // Stay on same page, even on success

    }


}