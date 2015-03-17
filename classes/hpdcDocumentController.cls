public class hpdcDocumentController {
    
    public String docName{get;set;}
    public String url{get;set;}
    
    public hpdcDocumentController(){
        
        if(System.currentPageReference().getParameters().get('doc') != null){
        
            docName = System.currentPageReference().getParameters().get('doc');
            List<Document> lstDocument = [select id from Document where DeveloperName =: docName];    
            if(lstDocument.size() > 0){
                url = '/servlet/servlet.FileDownload?file='+lstDocument[0].id;
            }
        }
    }
    
    public pagereference returnUrl(){
        
        if(url != null){
            pagereference page = new pagereference(url);
            page.setRedirect(true);
            return page;
        }
        return null;
    }
}