public class ODP_Extension_WorkElementDetail {

    public boolean IsBizEngaPartners{get;set;}
    public Stage_Work_Element__c swe{get;set;}
    public string host{get;set;}
    public string CurSweID{get;set;}
    public List<Contributor__c> ContribList{get;set;}
    public List<Review__c> ReviewList{get;set;}
    public List<Stage_Work_Element_Predecessor__c> PredecessorList{get;set;}
        
    public class  AttachmentAndLink{
        public string docId{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}
        public string lik{get;set;}         
    }
    public Attachment attachDoc{get;set;}
    public List<AttachmentAndLink> attachmentAndLinkList{get;set;}
    public LIST<Attachment> documents {get;set;}
    public LIST<Attachment> tempattach {get;set;}
    public LIST<Link__c> links {get;set;}
    public Link__c link {get;set;}
    
    public ODP_Extension_WorkElementDetail(ApexPages.StandardController controller) {
        IsBizEngaPartners = ODP_Class_CommonTools.IsBizEngaPartner();
        host = ApexPages.currentPage().getHeaders().get('Host');
        CurSweID = ApexPages.currentPage().getParameters().get('id');
        link = new Link__c();
        attachDoc = new Attachment();
        
        if(CurSweID != null){
            //get swe Inout
            documents = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid = :CurSweID ORDER By Name];
            links = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from Link__c where Stage_Work_Element_ID__c=:CurSweID];
            User tempUser = new User(); 
            attachmentAndLinkList = new List<AttachmentAndLink>();           
            for(Attachment attTemp : documents ){
                AttachmentAndLink tempObj = new AttachmentAndLink();
                tempObj.docId= string.valueOf(attTemp.id); 
                tempObj.name = attTemp.name;
                tempObj.fileType = 'Document';
                tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
                tempObj.addBY = tempUser.Name;
                tempObj.modifyDate = attTemp.lastmodifiedDate.date();
                tempObj.lik = null;               
                attachmentAndLinkList.add(tempObj);                               
            }
            for(Link__c attTemp : links ){
                AttachmentAndLink tempObj = new AttachmentAndLink();
                tempObj.docId = attTemp.id; 
                tempObj.name = attTemp.Name__c;
                tempObj.fileType = 'Link';
                tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
                tempObj.addBY = tempUser.Name;
                tempObj.modifyDate = attTemp.lastmodifiedDate.date();
                tempObj.lik = attTemp.Link__c;               
                attachmentAndLinkList.add(tempObj);                                
            }
        }
        
        swe = (Stage_Work_Element__c)controller.getRecord();
        swe = [select  id,
                       Name,
                       Name__c,
                       Accountable_Team_Member__r.User__r.email,
                       Accountable_Team_Member__r.User__r.SmallPhotourl,
                       Accountable_User__c,
                           Accountable_Process_Role_Name__c,
                       Optional__c,
                       Status__c,
                       Include__c,
                       Review_Required__c,
                       Work_Instructions__c,
                       Text__c,
                       Stage_Name__c,
                           Release_Stage_ID__r.Offering_Release_ID__c,
                       Release_Stage_ID__c,
                       Review_Due_Date__c,
                       Work_Element_Name__c,
                       Work_Element_ID__c,
                       Release_Name__c,
                       Help_Description__c,
                       Description_Text_Area__c,
                       Deliverable_Name__c,
                       Release_Deliverable_ID__c,
                           Release_Deliverable_ID__r.Release_Deliverable_Name__c,
                       Days_To_Review__c,
                       Contribute_Due_Date__c
               from    Stage_Work_Element__c
               where   id =: CurSweID];
        
        ContribList = [select id, Name, Completed__c, include__c,Team_member_name__c,Role_Name__c,Team_Members__r.User__r.Id,Team_Members__r.User__r.email, Team_Members__r.User__r.smallphotourl from Contributor__c where Stage_Work_Element__c =: CurSweID];
                ReviewList = [select id, Name, Complete__c, include__c, Rating__c, Team_Member_Name__c,Role_Name__c,Comment__c, Team_Member__r.User__r.email, Team_Member__r.User__r.smallphotourl from Review__c where Stage_Work_Element__c =: CurSweID];           
        PredecessorList = [select id, Name, Include__c, Work_Element__c, Predecessor_Stage_Work_Element_ID__c, Predecessor_Stage_Work_Element_Name__c, Stage_Work_Element_Name__c,  
                           Predecessor_Stage_Work_Element_ID__r.Accountable_Team_Member__r.User__r.email,
                           Predecessor_Stage_Work_Element_ID__r.Accountable_Team_Member__r.User__r.smallphotourl,
                           Predecessor_Stage_Work_Element_ID__r.Accountable_Team_Member__r.User__c
                           from Stage_Work_Element_Predecessor__c where Stage_Work_Element__c =:CurSweID];          
    }
    
    
    public PageReference FileUploadSave(){
        try{
            //contributor.completed__c = True;
            attachDoc.ParentId = CurSweID; 
            insert attachDoc;
            PageReference pageRef = new PageReference('/'+CurSweID);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: file upload exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }       
    }
    

  
  public string addtaLinkId{get;set;} 
  public string addtaLinkType{get;set;}       
  public PageReference deleteAttaLink(){
        try{
            //system.debug('documentId' + addtaLinkId);        
      
            if(addtaLinkType == 'Link'){
                system.debug(addtaLinkId);            
                Link__c linkDel = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from Link__c where id =: addtaLinkId];
                delete linkDel;                 
            }
            else if(addtaLinkType == 'Document'){
                Attachment  attachmentDel = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE id = :addtaLinkId];
                delete attachmentDel;                 
            } 
            PageReference pageRef = new PageReference('/' + CurSweID);
            pageRef.setRedirect(true); 
                        
            return pageRef;                     
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: deletion exception, Please contact IT Administrator if any assistance needed'));
            return null;            
        }
  }
    
    
    public PageReference saveLink(){
         try{
            if(string.IsEmpty(link.Name__c) || string.IsEmpty(link.Link__c))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'must provide the link name link url.'));
                return null;
            }
            //add by june.
            List<Link__c> links = [SELECT Link__c,Name,Name__c FROM Link__c WHERE Name__c =:link.Name__c];
            if(links.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Link name was already existed in current work element or in another,please use a unique name.'));
                return null;
            }
            //---end---
            link.Stage_Work_Element_ID__c = CurSweID;
            insert link;
            PageReference pageRef = new PageReference('/' + CurSweID);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: save link exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }
    }
   
    public Document document {
    get {
      if (document == null) document = new Document();
      return document;
    }
    set;
  }
    

}