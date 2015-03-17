@isTest
private class hpdcDocumentControllerTracker{
    
    static Folder objFolder;
    
    static testMethod void firstMethod() {
        
        loadData();
                
        hpdcDocumentController ob1 = new hpdcDocumentController();
        ob1.returnUrl();
        
        ApexPages.currentPage().getParameters().put('doc','newFile');
        hpdcDocumentController ob = new hpdcDocumentController();
        ob.returnUrl();
    }
    
    static void loadData(){
    
        insertFolder();
        insertDocument();
    }
    
    static void insertFolder(){
        
        objFolder = [select id from Folder where Type = 'Document' limit 1];        
    }
    
    static void insertDocument(){  
        
        Document obj = new Document();
        obj.Name = 'newFile';
        obj.FolderId = objFolder.Id;
        insert obj;
    }
}