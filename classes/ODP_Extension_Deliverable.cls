public class ODP_Extension_Deliverable {
    
    public Attachment attachDoc{get;set;}
    public LIST<Attachment> attachments{get;set;}
    public Note note{get;set;}
    public List<Note> notes{get;set;}
    public string siteUrl{get;set;}
    
    public class  NotesAndAttachments{
        public string docId{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}         
    }
    
    public List<NotesAndAttachments> notesAndAttachments{get;set;}
    
    
    public string PId{get;set;}
    public string conId {get;set;}
    
    public Release_Deliverable__c DeliberableObj{get;set;}
    public String myEditStates{get;set;}
    public boolean IsFromFlightPlan{get;set;}
    public String OFID{get;set;}
    public ODP_Extension_Deliverable(ApexPages.StandardController controller) {
        
        conId = ApexPages.currentPage().getParameters().get('id');
                siteUrl=ApexPages.currentPage().getHeaders().get('Host');
        OFID = ApexPages.currentPage().getParameters().get('OFID');
        note = new Note();
        attachDoc = new Attachment();
        
        DeliberableObj = (Release_Deliverable__c)controller.getRecord();
        IsFromFlightPlan = false;
        if(DeliberableObj.Id==null)
        {
            myEditStates = 'Create';
            IsFromFlightPlan = false;
            DeliberableObj.Offering_Release__c = OFID;
        }
        else
        {
            DeliberableObj = [select Id, Name,
                                Release_Deliverable_Name__c,
                                Include__c,
                                Deliverable_ID__c,
                                Deliverable_Name__c,
                                Offering_Release__c,
                                Tailoring_Justification__c,
                                Conditional__c,
                                Conditional_Text__c,
                                Review_Criteria__c,
                                Stage_Material__c,
                                Deliverable_ID__r.Description__c
                              from Release_Deliverable__c
                              where Id=:DeliberableObj.Id];
            myEditStates = 'Update';

            if(DeliberableObj.Deliverable_ID__c != null){
                IsFromFlightPlan = true;
            }
            else
            {
                IsFromFlightPlan = false;
            }
            
            notesAndAttachments= new List<NotesAndAttachments>();
            PId = conID;
            attachments = [SELECT id,CreatedById,name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid =:PId ORDER By Name]; 
            notes = [SELECT id,CreatedById,title,LastModifiedDate,ownerid from Note where parentid=:PId Order by title];
            User tempUser = new User();  
            for(Attachment attTemp : attachments){
                    NotesAndAttachments tempObj = new NotesAndAttachments();
                    
                    tempObj.docId= string.valueOf(attTemp.id); 
                    tempObj.name = attTemp.name;
                    tempObj.fileType = 'Attachment';
                    tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
                    tempObj.addBY = tempUser.Name;
                    tempObj.modifyDate = attTemp.lastmodifiedDate.date();
                    //tempObj.lik = null;               
                    notesAndAttachments.add(tempObj);                               
            }
            for(Note note : notes){
                 NotesAndAttachments tempObj = new NotesAndAttachments();
                 tempObj.docId = string.valueOf(note.id);
                 tempObj.name = note.title;
                 tempObj.fileType = 'Note';
                 tempUser = [select email,Name from user where id =: note.CreatedById];
                 tempObj.addBY = tempUser.Name;
                 tempObj.modifyDate = note.lastmodifiedDate.date();
                 notesAndAttachments.add(tempObj);
            }
        }
    }

    public PageReference Save(){
        try
        {
            
            upsert DeliberableObj;
            PageReference DPage = new PageReference('/'+DeliberableObj.Offering_Release__c);
            DPage.setRedirect(true);
            return DPage ;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: saving deliverable exception due to duplicate deliverable name. Please contact IT administrators if any assistance needed'));
            return null;   
        }
    }
    
    public PageReference FileUploadSave(){
        try{
            
            //contributor.completed__c = True;
            attachDoc.ParentId = PId; 
            upsert attachDoc;
            //PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
            PageReference pageRef = new PageReference('/apex/ODP_Page_Deliverable?id=' + conId);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: File upload exception. Please contact IT administrators if any assistance needed'));
            return null;
        }       
  }
      
  public string addtaLinkId{get;set;} 
  public string addtaLinkType{get;set;}   
  public PageReference delNoteAttach(){
      try{
       if(addtaLinkType == 'Attachment'){
                Attachment  attachmentDel = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE id = :addtaLinkId];
                delete attachmentDel;                 
            } 
        else if(addtaLinkType =='Note'){
            Note noteDel=[SELECT id,title,CreatedById,lastmodifiedDate,ownerid FROM Note WHERE id = :addtaLinkId];
            delete noteDel;
        }
        PageReference pageRef = new PageReference('/apex/ODP_Page_Deliverable?id=' + conId );
        pageRef.setRedirect(true); 
        return pageRef;                     
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: deletion exception. Please contact IT administrators if any assistance needed'));
            return null;            
        }
  }
  
  public PageReference saveNote(){
                
         try{
            //note = new Note();
            note.ParentId = PId;
            insert note;
            PageReference pageRef = new PageReference('/apex/ODP_Page_Deliverable?id=' + conId);
            PageRef.setRedirect(true);
            return pageRef;
         }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: saving note exception. Please contact IT administrators if any assistance needed'));
            return null;
         }
   }
  
}