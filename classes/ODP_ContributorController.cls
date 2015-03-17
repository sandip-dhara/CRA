public with sharing class ODP_ContributorController {

    public Contributor__c contributor {get;set;}
    public string conId {get;set;}
    public LIST<Attachment> documents {get;set;}
    public LIST<Link__c> links {get;set;}
    public string UserId {get;set;}
    public Link__c link {get;set;}
    public string stageworkdOwner{get;set;} 
    public String contributionDue{get;set;}
    public String completePer{get;set;}
    public String templateLinks{get;set;} 
          
    public class WorkElement{
        public string workElementName{get;set;}
        public string deliverableName{get;set;}
        public string completed{get;set;}
        public string review{get;set;}
        public Date lastModifyDate{get;set;}        
    }
    public class  AttachmentAndLink{
        public string ID{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}         
    }
    public List<WorkElement> workElementList{get;set;}
    public List<AttachmentAndLink> attachmentAndLinkList{get;set;}    
    public LIST<Review__c> deliverableReviews {get;set;}
//    public LIST<Stage_Approval__c> approvers {get;set;}
    
    public ODP_ContributorController(){
        link = new Link__c();
        conId = ApexPages.currentPage().getParameters().get('id');
        UserId = UserInfo.getUserId();
        contributor = null;
       
        if (conId!=null){
             
           // System.debug('-------------------2---------------------------'+conId);    
           contributor = [SELECT id,name,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,
                           Team_Members__r.User__r.Id,Stage_Work_Element__r.Work_Element_Name__c,Stage_Work_Element__r.Stage_Name__c,
                           Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,
                           Stage_Work_Element__r.Contribute_Due_Date__c,comment__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Name__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Group__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Description__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.id,
                           Stage_Work_Element__r.id,
                           Stage_Work_Element__r.Status__c,
                           Stage_Work_Element__r.review_due_date__c,
                           Stage_Work_Element__r.Work_Instructions__c,
                           Stage_Work_Element__r.Help_Description__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_Name__c                           
                           from Contributor__c
                           WHERE id =:conId
                           LIMIT 1];
           Offering_Release__c orc = [select OwnerId from Offering_Release__c where id =: contributor.Stage_Work_Element__r.Release_Deliverable_ID__r.Offering_Release__r.id]; 
           User tempUser = [select email, Name from User where id =: orc.OwnerId ];
           stageworkdOwner= tempUser.Name;
           if(contributor.Stage_Work_Element__r.review_due_date__c != null){            
           Date dueDate = contributor.Stage_Work_Element__r.review_due_date__c;
           Datetime nowTime = datetime.now();
           Date nowDate = nowTime.date();
           contributionDue = string.valueOf(nowDate.daysBetween(dueDate));
           }else{
               contributionDue  = 'Unkown';
           }           
           Double contributorNum = [select COUNT() from Contributor__c where Stage_Work_Element__c =: contributor.Stage_Work_Element__c ];
           Double contributorComNum = [select COUNT() from Contributor__c where Stage_Work_Element__c =: contributor.Stage_Work_Element__c and Stage_Work_Element__r.Status__c =: 'Complete']; 
           Double completePerDouble = contributorComNum/contributorNum ;
           completePer =  string.valueOf(contributorComNum / contributorNum) + '%';
           templateLinks = '<a>www.baidu.com</a></br><a>www.google.com</a>'; 
           Stage_Work_Element__c swePra = [select id,Work_Element_Name__c from Stage_Work_Element__c where id =: contributor.Stage_Work_Element__c ]; 
           workElementList = new List<WorkElement>();
           workElementList  = getAllWorkElement(swePra);  
            
           LIST<Attachment> documents = [SELECT id,name,ownerid,CreatedById,lastmodifiedDate FROM Attachment WHERE parentid = :swePra.id ORDER By Name];
           attachmentAndLinkList = new List<AttachmentAndLink>();           
           for(Attachment attTemp : documents ){
               AttachmentAndLink tempObj = new AttachmentAndLink();
               tempObj.ID = attTemp.id; 
               tempObj.name = attTemp.name;
               tempObj.fileType = 'Attachment';
               tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
               tempObj.addBY = tempUser.Name;
               tempObj.modifyDate = attTemp.lastmodifiedDate.date();               
               attachmentAndLinkList.add(tempObj);                               
           }            
           LIST<Link__c> links = [select id, Link__c, Name__c,CreatedById,lastmodifiedDate  from Link__c where Stage_Work_Element_ID__c=: swePra.id];          
           for(Link__c attTemp : links ){
               AttachmentAndLink tempObj = new AttachmentAndLink();
               tempObj.ID = attTemp.id; 
               tempObj.name = attTemp.Name__c;
               tempObj.fileType = 'Link';
               tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
               tempObj.addBY = tempUser.Name;
               tempObj.modifyDate = attTemp.lastmodifiedDate.date();               
               attachmentAndLinkList.add(tempObj);                                
           }
           /*  
                
           // System.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  doc '+contributor.Contributor__c);                 
        
           documents = [SELECT d.View_URL__c, d.Offering_Deliverable__c, d.Name, d.Id, d.File_Id__c, d.CreatedDate, 
                                d.Contributor__c, d.Contributor__r.Contributor__c
                         FROM Document__c d
                         WHERE Contributor__c =:conId
                         ORDER By Name];
                         
           // System.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa  doc '+documents );    
            
           links = [SELECT l.URL__c, l.Offering_Deliverable__c, l.Name, l.Id, l.CreatedDate, 
                            l.Contributor__c, l.Contributor__r.Contributor__c
                       FROM Link__c l
                       WHERE Contributor__c = :conId
                       ORDER By Name];*/
            } else {
                // display an error message
            }
            
/*            deliverableReviews = [SELECT id, Reviewer__r.Name
                                  FROM Deliverable_Review__c dr
                                  WHERE dr.Offering_Deliverable__c = :contributor.Offering_Deliverable__c
                                 ];*/
    }
    public List<WorkElement> getAllWorkElement(Stage_Work_Element__c swe){
        List<Stage_Work_Element__c>  swetTempList = [select Work_Element_Name__c,Deliverable_Name__c,id,Status__c,LastModifiedDate from Stage_Work_Element__c where id !=: swe.id and Work_Element_Name__c =: swe.Work_Element_Name__c order by CreatedDate];
        List<WorkElement> workElementTempList = new List<WorkElement>(); 
        for(Stage_Work_Element__c swetTemp : swetTempList){                        
            Double contributorNum = [select COUNT() from Contributor__c where Stage_Work_Element__c =: swetTemp.id];
            Double contributorComNum = [select COUNT() from Contributor__c where Stage_Work_Element__c =: swetTemp.id and Stage_Work_Element__r.Status__c =: 'Complete']; 
            Double completePerDouble = contributorComNum/contributorNum ;
            String completePer =  string.valueOf(contributorComNum / contributorNum) + '%'; 
        
            WorkElement workElementAdd = new WorkElement();
            workElementAdd.workElementName = swetTemp.Work_Element_Name__c;
            workElementAdd.deliverableName = swetTemp.Deliverable_Name__c;
            workElementAdd.completed = completePer;
            workElementAdd.review = swetTemp.Status__c;
            workElementAdd.lastModifyDate  = swetTemp.LastModifiedDate.date();       
            
            workElementTempList.add(workElementAdd);        
        }
        return workElementTempList;       
    }
    public boolean getRenderIfOwner(){
        boolean render = false;
        if ( contributor.Team_Members__r.User__r.Id!= null && contributor.Team_Members__r.User__r.Id==UserId ) render = true;
        return render;
    }
    //public PageReference NewDocument(){
    //    return null;
    //}
    public PageReference NewLink(){
        return null;
    }
    
    public PageReference saveLink(){
       /* if ( link.name!=null && link.name!='' && link.URL__c!=null && link.URL__c!='' ){
            link.Contributor__c = contributor.id;
            link.Offering_Deliverable__c = contributor.Offering_Deliverable__c;
            insert link;
        }*/
        PageReference p = ApexPages.currentPage();
        p.setRedirect(true);
        return p;
    }
    
    public PageReference save(){
        
         update contributor;

         // add my code
         document.AuthorId = UserInfo.getUserId();
         document.FolderId = UserInfo.getUserId(); // put it in running user's folder
         
         // create file object
 
         ContentVersion v;
         try {
               insert document;
      
               v = new ContentVersion();
               v.versionData =document.body;
               v.title =document.name;
               v.FirstPublishLocationId='058i0000000aYvF';
           //  v.PublishStatus='';
           //  v.OwnerId=UserInfo.getUserId();
               
                
               if((document.name).contains('.')){ 
               String[] doctype1=(document.name).split('\\.',2);
             
               v.pathOnClient =doctype1[0]+'.'+doctype1[1];
               }
               else{
                v.pathOnClient =document.name;
               }
               insert v;
              // v.PublishStatus='p';
              //post the file in chatter
               
            /*   FeedItem post = new FeedItem();
            post.ParentId =;
            post.Body =String.valueOf(v.versionData);
           // post.ContentData = decodedbody;
            post.ContentFileName = 'my file';
           
             insert post;*/
               
               
          }
          catch (DMLException e) {
   
             return null;
          }
          finally {
               document.body = null; // clears the viewstate
               document = new Document();
          }
 
 
         // add file information to Document__c                                                                                                                                                                                                                         
         /*
         Contributor__c cont=[SELECT Comments__c,Contributor__c,CreatedDate,Deliverable_Name__c,
                                     Department__c,Due_Date__c,Id,Im_Done__c,Name,Offering_Deliverable__c,
                                     Offering_Deliverable__r.name,Offering_Name__c,Offering__c,Stage_Type__c,Stage__c 
                              FROM Contributor__c where Contributor__c=:contributor.Contributor__c];
         
       
         Document__c cobj=new Document__c();
      
         cobj.name=v.title;
         cobj.Contributor__c=contributor.id; // cont.id;
         cobj.Offering_Deliverable__c=contributor.Offering_Deliverable__c;   // cont.Offering_Deliverable__c;           
         cobj.File_Id__c=v.id;
      
         insert cobj;
    
    
         documents = [SELECT d.View_URL__c, d.Offering_Deliverable__c, d.Name, d.Id, d.File_Id__c, d.CreatedDate, 
                                d.Contributor__c, d.Contributor__r.Contributor__c
                         FROM Document__c d
                         WHERE Contributor__c = :conId
                         ORDER By Name];
      */                   
    
                         
        
         return new PageReference('/apex/Contributor?id='+conId);
    }
   
    public Document document {
    get {
      if (document == null) document = new Document();
      return document;
    }
    set;
  }
  
  // public Blob img{set;get;}
 
  public PageReference cancel(){
     return null;
  }

  
   
      
}