

global class PageController {


    public String invoiceId { get; set; }
    public String pdfName { get; set; }
    public Messaging.Email invoiceEmail { get; set; }



    public List<Invoice__c> getInvoices() {
        List<Invoice__c> listInvoices = [
                SELECT Id,Name,UserEmail__c,UserFirstName__c,UserLastName__c
                FROM Invoice__c
                LIMIT 100
        ];
        return listInvoices;
    }


    public PageReference goToPdfPageReference() {

        PageReference pr = Page.PDFPage;
        pr.setRedirect(true);
        pr.getParameters().put('invoiceID', invoiceId);
        pr.getParameters().put('pdfName', pdfName);
        //pr.getParameters().put('invoiceEmail', invoiceEmail);
        return pr;
    }
}



