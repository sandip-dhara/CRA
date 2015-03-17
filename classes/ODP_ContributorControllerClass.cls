public class ODP_ContributorControllerClass{

//  Contributor/Reviewer List - Ning Kang
    public List<Contributor__c> ContribList{get;set;}
    public boolean ActionDIVShow {get;set;}     
    public List<Review__c> ReviewList{get;set;}  
    public Release_Deliverable__c RelDel{get;set;}
    public List<Stage_Work_Element_Predecessor__c> Predecessors{get;set;}
    public integer compert{get;set;}
    public class  AttachmentAndLink{
        public string docId{get;set;}
        public string name{get;set;}

 
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}
        public string lik{get;set;}         
    }
    
    public class WETemplate
    {
            public Attachment attach {get;set;}
            public String attType{get;set;}
    }
    
    public Attachment attachDoc{get;set;}
    public List<AttachmentAndLink> attachmentAndLinkList{get;set;}
    public string showFileDelete{get;set;}
    public string SWEId{get;set;}
    public string Text{get;set;}
    public boolean IsOwner {get;set;}
    public boolean IsPMorFac {get;set;}
    public boolean IsReadyForReview{get;set;}
    public boolean IsInProgress{get;set;}
    public boolean IsNotStarted{get;set;}
    public boolean IsContributor{get;set;}
    public boolean CanUpdate{get;set;}
    public String Status{get;set;}
//  End 
    //show Contributor/Review table or not - Tovid
    public boolean showContributorTable{get;set;}  
    public boolean showReviewTable{get;set;} 
    public boolean showReviewDiv{get;set;}   
    // Owner only does not see “I’m Done” or Submit button 
    public boolean disableDoneSubmit{get;set;} 
    public Contributor__c contributor {get;set;}
    public string conId {get;set;}
    public LIST<Attachment> documents {get;set;}
    public LIST<Attachment> tempattach {get;set;}
    public LIST<Link__c> links {get;set;}
    public string UserId {get;set;}
    public Link__c link {get;set;}
    
    public LIST<Review__c> deliverableReviews {get;set;}
    public Boolean ReviewAbled {get;set;}
    public string ErrorReviewAbled {get;set;}
    public string ConfirmMsgReview {get;set;}
    public Boolean CompleteAbled {get;set;}
    public string ErrorCompleteAbled {get;set;}
    public Boolean ReworkAbled {get;set;}
    public string ErrorReworkAbled {get;set;}
    public Boolean AllCompeleted {get;set;}
    public Boolean SubmitAbled {get;set;}
    public string ErrorSubmitAbled {get;set;}

    public ODP_ContributorControllerClass(ApexPages.StandardController controller){
        contributor = (Contributor__c)controller.getRecord();
        link = new Link__c();
        conId = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('mode') ==  'Open'){
            ActionDIVShow = true;
        }
        else{
            ActionDIVShow = false;
        }
        UserId = UserInfo.getUserId();
        contributor = null;
        attachDoc = new Attachment();
        if (conId!=null){
             
           // System.debug('-------------------2---------------------------'+conId);    
           contributor = [SELECT id,name,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,
                           Team_Members__r.User__r.Id,comment__c,
                           Stage_Work_Element__r.Work_Element_Name__c,
                           Stage_Work_Element__r.Stage_Name__c,
                           Stage_Work_Element__r.CreatedBy.Last_First_Name__c ,
                           Stage_Work_Element__r.CreatedBy.FirstName ,
                           Stage_Work_Element__r.CreatedBy.LastName ,
                           Stage_Work_Element__r.CreatedByid,
                           Stage_Work_Element__r.Status__c,
                           Stage_Work_Element__r.Work_Instructions__c,
                           Stage_Work_Element__r.Help_Description__c,
                           Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,
                           Stage_Work_Element__r.Description_Text_Area__c,
                           Stage_Work_Element__r.Contribute_Due_Date__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_Name__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Name__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Group__c,
                           Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Description__c,
                           Stage_Work_Element__r.Review_Required__c,
                           Stage_Work_Element__r.Review_Due_Date__c,
                           Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,
                           Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email,
                           Stage_Work_Element__r.Accountable_User__c,
                           Stage_Work_Element__r.Accountable_Process_Role_Name__c,
                           Stage_Work_Element__r.Release_Stage_ID__c,
                           Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Owner.Id,
                           Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c,
                           Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c,
                           Stage_Work_Element__r.Release_Stage_ID__r.Current_Baseline_End_Date__c,
                           Stage_Work_Element__r.work_element_ID__c 
                           //Stage_Work_Element__r.Release_Stage_ID__r.Review_Date__c
                           from Contributor__c
                           WHERE id =:conId
                           LIMIT 1];
//onblur="LookupHoverDetail.getHover('{!ro.risk.id}').hide();" onfocus="LookupHoverDetail.getHover('{!ro.risk.id}', '/{!ro.risk.id}/m?retURL=%2F{!ro.risk.id}&isAjaxRequest=1').show();" onmouseout="LookupHoverDetail.getHover('{!ro.risk.id}').hide();" onmouseover="LookupHoverDetail.getHover('{!ro.risk.id}', '/{!ro.risk.id}/m?retURL=%2F{!ro.risk.id}&isAjaxRequest=1').show();"
            } else {

            }
            IsReadyForReview = contributor.Stage_Work_Element__r.Status__c == 'Ready for Review';
            IsNotStarted= contributor.Stage_Work_Element__r.Status__c == 'Not Started';
            IsInProgress= contributor.Stage_Work_Element__r.Status__c == 'In Progress';
            Status = contributor.Stage_Work_Element__r.Status__c;
            showReviewDiv =  contributor.Stage_Work_Element__r.Review_Required__c;
            //Ning Kang - Get the Contributor List loaded - Get the Review List
            
            SWEId = [select Stage_Work_Element__c from Contributor__c where id =:conId Limit 1].Stage_Work_Element__c;
            Text = [select Text__c from Stage_Work_Element__c where Id=:SWEId].Text__c;
            ContribList = [select Completed__c, Team_member_name__c,Role_Name__c,Team_Members__r.User__r.Id,Team_Members__r.User__r.email, Team_Members__r.User__r.smallphotourl from Contributor__c where Stage_Work_Element__c =: SWEId];
            if(ContribList.size() > 0){
                showContributorTable = true;
            }else{
                showContributorTable = false;
            }
            ReviewList = [select Complete__c, Rating__c, Team_Member_Name__c,Role_Name__c,Comment__c, Team_Member__r.User__r.email, Team_Member__r.User__r.smallphotourl from Review__c where Stage_Work_Element__c =: SWEId];           
            if(ReviewList.size() > 0){
                showReviewTable = true;
            }else{
                showReviewTable = false;
            }
            IsContributor = false;
            for(Contributor__c cc : ContribList){
                if(UserId.equals(cc.Team_Members__r.User__r.Id)){
                    IsContributor = true; 
                    break;
                }
            }
            if(UserId.equals(contributor.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id)){
                IsOwner = true;
            }
            else{
                IsOwner = false;
            }
            
            if(UserId.equals(contributor.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Owner.Id) || UserId.equals(contributor.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c)){
                IsPMorFac = true;
            }
            else{
                IsPMorFac = false;
            }
            
            disableDoneSubmit = !(UserId == contributor.Team_Members__r.User__r.Id);
            
            Predecessors = [select Predecessor_Stage_Work_Element_ID__c,Predecessor_Stage_Work_Element_Name__c,
                Predecessor_Stage_Work_Element_ID__r.Deliverable_Name__c,
                Predecessor_Stage_Work_Element_ID__r.Status__c,
                Predecessor_Stage_Work_Element_ID__r.LastModifiedDate
                from Stage_Work_Element_Predecessor__c where Stage_Work_Element__c = :SWEId];
            
            //compert = 10;
            List<Contributor__c> conWithTMList = [select Completed__c, Team_member_name__c,Role_Name__c,Team_Members__r.User__r.Id 
                from Contributor__c where Stage_Work_Element__c =: SWEId and Team_Members__c != ''];
            //calculate the complete percent for the stage work element
            integer cntcom = 0;
                AllCompeleted = true;
            for(Contributor__c cc : conWithTMList){
                if(cc.Completed__c){
                    cntcom = cntcom + 1;        
                }   
                else{
                    AllCompeleted = false;
                }
            }           
                   
            if(conWithTMList.size() > 0){
                compert = integer.valueOf(((double)cntcom/(double)conWithTMList.size())*100); 
            }
            else{
                compert = 100;
            }
            
            string WEID;
            string DID;
            if(contributor.Stage_Work_Element__r.work_element_ID__c != null){
                WEID = [select work_element_ID__c from stage_work_element__c where id =:SWEId].work_element_ID__c; 
                DID = [select Deliverable_ID__c from Work_Element__c where id =: WEID].Deliverable_ID__c;
                tempattach = [SELECT id,CreatedById, name FROM Attachment WHERE parentid =:WEID OR parentid =: DID];
            }

            
            documents = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid = :SWEId ORDER By Name];
            links = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from Link__c where Stage_Work_Element_ID__c=:SWEId];
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
            // disable file delete when status is in progress
            if(contributor.Stage_Work_Element__r.Status__c != null && contributor.Stage_Work_Element__r.Status__c.equals('In Progress')){
                showFileDelete = 'inline';    
            }else{
                showFileDelete = 'none'; 
            }
            
            ErrorReworkAbled = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
            ErrorReviewAbled = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
            ErrorCompleteAbled = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
            ErrorSubmitAbled  = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
            SubmitAbled = true;
            if(!IsContributor){
                SubmitAbled = false;
                ErrorSubmitAbled += '- Only contributor himself/herself are able to mark their contribution as done.<br/>';
            }
            else{
                if(!IsInProgress){
                    SubmitAbled = false;
                    ErrorSubmitAbled += '- Contributors are only allowed to submit contributions when work element is In Progress.<br/>';
                }
                if(contributor.Completed__c){
                    SubmitAbled = false;
                    ErrorSubmitAbled += '- Contributors are NOT allowed to submit Completed contributions (Already Submitted?).<br/>';
                }
            }
            
            if(IsOwner || IsPMorFac)
            {
                ReviewAbled = true;
                ReworkAbled = true;
                CompleteAbled = true;
                ConfirmMsgReview = 'Confirm to start  review for this work element?<br/>';
                
                if(contributor.Stage_Work_Element__r.Review_Required__c)
                {
                    CompleteAbled = false;
                    ErrorCompleteAbled += '- You are NOT allowed to complete this work element which requires  review.<br/>';
                }
                else
                {
                    ErrorReviewAbled += '- This work element does not need  review<br/>';
                    ReviewAbled = false;
                    if(Status=='Complete'){
                        CompleteAbled = false;
                        ErrorCompleteAbled += '- This work element has already been completed. No more action required.<br/>';
                    }
                }
                
                if(!IsReadyForReview ){
                    ErrorReworkAbled += '- Rework is only allowed when all the contributors complete their work (Ready for Review)<br/>';
                    ReworkAbled = false;
                }
                
                if(contributor.Stage_Work_Element__r.review_due_date__c == null || contributor.Stage_Work_Element__r.review_due_date__c <= Date.today()){
                    ErrorReviewAbled += '- Review Due Date must be valid<br/>';
                    ReviewAbled = false;
                }
                
                if(!IsPMorFac){ //cur user only is owner
                    if(!ODP_Class_CommonTools.CheckAllPreSWEIsCompleted(SWEId, 1)){
                        ErrorReviewAbled += '- All Predecessor work elements must be completed.<br/>';
                        ReviewAbled = false;
                    }
                    
                    if(Status != 'Ready for Review' && Status!='In Progress'){
                        ErrorReviewAbled += '- Work element status must be (Ready for Review) or (In Progress).<br/>';
                        ReviewAbled = false;
                    }
                    else if(Status=='In Progress'){
                        ConfirmMsgReview += '- Not all the contributors complete their work<br/>';
                    }
                }
                else{//cur user is PM or fac
                    if(Status != 'Ready for Review' && Status!='In Progress'){
                        ErrorReviewAbled += '- Work element status must be (Ready for Review) or (In Progress).<br/>';
                        ReviewAbled = false;
                    }
                    else if(Status=='In Progress'){
                        ConfirmMsgReview += '- Not all the contributors complete their work<br/>';
                    }
                    
                    if(!ODP_Class_CommonTools.CheckAllPreSWEIsCompleted(SWEId, 1)){
                        ConfirmMsgReview += '- There are predecessor work elements which are not completed. Make sure they are completed first<br/>';
                    }
                }
            }
            else
            {
                ReviewAbled = false;
                ErrorReviewAbled += '- Only work element owner\\BEP can request  review.<br/>';
                
                ReworkAbled  = false;
                ErrorReworkAbled += '- Only work element owner\\BEP can rework work element.<br/>';
                
                CompleteAbled = false;
                ErrorCompleteAbled += '- Only work element owner\\BEP complete work element.<br/>';
            }
            
            CanUpdate = false;
            if(IsOwner || IsPMorFac){
                CanUpdate = contributor.Stage_Work_Element__r.Status__c != 'Complete';
            }
            else if(IsContributor){
                CanUpdate = IsInProgress && contributor.Completed__c == false;
            }
    }
    
    public boolean getRenderIfOwner(){
        boolean render = false;
        if ( contributor.Team_Members__r.User__r.Id!= null && contributor.Team_Members__r.User__r.Id==UserId ) render = true;
        return render;
    }

    public PageReference NewLink(){
        return null;
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
               if((document.name).contains('.')){ 
               String[] doctype1=(document.name).split('\\.',2);
             
               v.pathOnClient =doctype1[0]+'.'+doctype1[1];
               }
               else{
                v.pathOnClient =document.name;
               }
               insert v;             
          }
          catch (DMLException e) {
   
             return null;
          }
          finally {
               document.body = null; // clears the viewstate
               document = new Document();
          }

         return new PageReference('/apex/ODP_ContributorPage?id='+conId);
    }
    
    
    public PageReference saveLink(){
         try{
            if(string.IsEmpty(link.Name__c) || string.IsEmpty(link.Link__c))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'must provide the link name link url.'));
                return null;
            }
            //add by june.
            List<Link__c> links = [SELECT Link__c,Name,Name__c,Stage_Work_Element_ID__c FROM Link__c WHERE Name__c =:link.Name__c];
            if(links.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Link name was already existed in current work element or in another,please use a unique name.'));
                return null;
            }
            //---end---
            link.Stage_Work_Element_ID__c = SWEId;
            insert link;
            PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
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
  
  // public Blob img{set;get;}
 
  public PageReference cancel(){
     return null;
  }
    
  public PageReference SubmitStatus(){
        try{
            //contributor.completed__c = True;
            upsert contributor;           
            PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId+'&mode='+ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'operation Failed: submit exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }       
  }
    
    public PageReference FileUploadSave(){
        try{
            //contributor.completed__c = True;
            attachDoc.ParentId = SWEId; 
            insert attachDoc;
            GEFDataSend(attachDoc.Id, SWEId,UserId, contributor.Stage_Work_Element__r.Release_Stage_ID__c, contributor.Stage_Work_Element__r.Stage_Name__c);
            PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId +'&f=t&mode='+ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: file upload exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }       
  }
  
  public PageReference SaveText(){
        try{
            Stage_Work_Element__c swe = [select Text__c from Stage_Work_Element__c where Id=:SWEId];
            swe.Text__c = Text;
            update swe;
            PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: save text exception, Please contact IT Administrator if any assistance needed'));
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
            PageReference pageRef = new PageReference('/apex/ODP_ContributorPage?id=' + conId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
                        
            return pageRef;                     
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: deletion exception, Please contact IT Administrator if any assistance needed'));
            return null;            
        }
  }
  ////////////
   public List<Contributor__c> getUsers()  
    {  
        List<Contributor__c> accounttList = new List<Contributor__c>();  
        accounttList = [Select Id, Team_Member_Name__c ,Role_Name__c  from Contributor__c LIMIT 10];  
        return accounttList ;  
    }
  public PageReference complete(){
        try{
            //string SWEId = [select Stage_Work_Element__c from Contributor__c  where id =:conId Limit 1].Stage_Work_Element__c;
            Stage_Work_Element__c swe = [select id ,Status__c from Stage_Work_Element__c where id =: SWEId];
            swe.Status__c = 'Complete';
            upsert swe;
            
            List<Contributor__c>  ContribTempList = [select id,Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c from Contributor__c where Stage_Work_Element__c =: SWEId];
            for(Contributor__c contribTemp : ContribTempList){
                contribTemp.Completed__c = true; 
                update contribTemp;
            }
            
            PageReference pageRef = new PageReference( '/apex/ODP_ContributorPage?id=' + conId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: submit complete exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }      
  }

  public PageReference ReadyForReview(){
        try{

            Stage_Work_Element__c swe = [select id ,Status__c,Contribute_Due_Date__c from Stage_Work_Element__c where id =: SWEId];
            /*if(!ODP_Class_CommonTools.CheckAllPreSWEIsCompleted(SWEId, 1)) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are prodecessor work element is not competed, So can not Start Review.'));
                return null;
            }
            
            if(!AllCompeleted && swe.Contribute_Due_Date__c != null && swe.Contribute_Due_Date__c > Date.today())
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'the contribute date is not end, So can not Start Review.'));
                return null;
            }*/
            
            
            swe.Status__c = 'Under Review';
            update swe;
            
            List<Contributor__c>  ContribTempList = [select id,Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c from Contributor__c where Stage_Work_Element__c =: SWEId];
            for(Contributor__c contribTemp : ContribTempList){
                contribTemp.Completed__c = true; 
                update contribTemp;
            }
            
            PageReference pageRef = new PageReference( '/apex/ODP_ContributorPage?id=' + conId+'&mode='+ApexPages.currentPage().getParameters().get('mode') );
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: submit review exception, Please contact IT Administrator if any assistance needed'));
            return null;
        } 
  }
  
  public PageReference rework(){
        try{
            Stage_Work_Element__c swe = [select id ,Status__c,Name__C,Release_Stage_ID__c,Stage_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__c,
                Release_Stage_ID__r.Release_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.email,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.Name,
                Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email,
                Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name
                from Stage_Work_Element__c where id =: SWEId];
            swe.Status__c = 'In Progress';
            update swe;
            List<Contributor__c>  ContribTempList = [select id,Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c from Contributor__c where Stage_Work_Element__c =: SWEId];
            for(Contributor__c contribTemp : ContribTempList){
                contribTemp.Completed__c = false; 
                update contribTemp;
            }
            /*List<Review__c>  ReviewerTempList = [select id,Complete__c from Review__c where Stage_Work_Element__c =: SWEId];
            for(Review__c rewTemp : ReviewerTempList ){
                rewTemp.Complete__c = false;
                rewTemp.Rating__c = null; 
                update rewTemp ;
            }*/
            
            //send email to inform contributors
             Set<Id> informToSet = new Set<Id>();
            List<Contributor__c> contributors = [
              select Completed__c,Team_Members__r.User__c
                from Contributor__c
                where Stage_Work_Element__c=:SWEId
            ];
            for(Contributor__c contributor:contributors)
            {
                if(!informToSet.contains(contributor.Team_Members__r.User__c))
                {
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(contributor.Team_Members__r.User__c),
                              'The work element "' + swe.Name__C + '" has been set to rework.',
                              'The work element "' + swe.Name__C + '" has been set to rework by the owner, Please check the detail information as below and start to rework.',  
                              '<a href="{base}/'+swe.Release_Stage_ID__r.Offering_Release_ID__c+'"> ' + swe.Release_Stage_ID__r.Release_Name__c + '</a>',
                              '<a href="{base}/'+swe.Release_Stage_ID__c+'"> ' + swe.Stage_Name__c + '</a>',
                                                             null,
                              '<a href="{base}/'+swe.Id+'"> ' + swe.Name__C + '</a>',
                              'Business Engagement Partner : <a href="mailto:' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                    informToSet.add(contributor.Team_Members__r.User__c);
                }
            }
            //send email to inform the contributor end
            
            /* List<Review__c> reviewers = [
              select Complete__c,Team_Member__r.User__c
                from Review__c
                where Stage_Work_Element__c=:SWEId
            ];
            
           
            for(Review__c reviewer:reviewers)
            {
                if(!informToSet.contains(reviewer.Team_Member__r.User__c))
                {
                    ODP_Class_EmailNotification.SendToPerson(String.valueOf(reviewer.Team_Member__r.User__c),
                              'The Stage work element "' + swe.Name + '" has been set to rework.',
                              'The Stage work element "' + swe.Name + '" has been set to rework, Please check the detail information as below.',
                              '<a href="{base}/'+swe.Release_Stage_ID__r.Offering_Release_ID__c+'"> ' + swe.Release_Stage_ID__r.Release_Name__c + '</a>',
                              '<a href="{base}/'+swe.Release_Stage_ID__c+'"> ' + swe.Stage_Name__c + '</a>',
                                                             null,
                              '<a href="{base}/'+swe.Id+'"> ' + swe.Name__C + '</a>',
                              'Offering Manager : <a href="mailto:' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Owner.email  + '">  ' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Owner.Name + ' </a>');
                    informToSet.add(reviewer.Team_Member__r.User__c);
                }
            }//
            */  
            
            PageReference pageRef = new PageReference( '/apex/ODP_ContributorPage?id=' + conId + '&mode=' + ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: rework exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }
    }
    //Tovid - Save review due date
    //public Date reviewDueDate{get;set;}
    public PageReference saveDueDate(){
        try{
            Date reviewDate = contributor.Stage_Work_Element__r.Review_Due_Date__c;
            Date stageReviewDate = contributor.Stage_Work_Element__r.Release_Stage_ID__r.Current_Baseline_End_Date__c;
            Datetime nowTime = datetime.now();
            Date nowDate = nowTime.date();
            
            Integer reviewDateToToday = nowDate.daysBetween(reviewDate);
            Integer dueTostageReviewDate = 0; 
            if(stageReviewDate != null){
                dueTostageReviewDate = reviewDate.daysBetween(stageReviewDate);    
            }
                        
            if(reviewDateToToday < 0 || dueTostageReviewDate < 4){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, ' Review Due Date must be valid (4 days before stage review date). Or please contact Project Manager to provide the Current Baseline End Date for this Stage'));
                return null;
            }else{
                   
                Stage_Work_Element__c swe = [select Review_Due_Date__c
                    from Stage_Work_Element__c where id =: SWEId];
                   
                swe.Review_Due_Date__c = contributor.Stage_Work_Element__r.Review_Due_Date__c;
                update swe;
                PageReference pageRef = new PageReference( '/apex/ODP_ContributorPage?id=' + conId + '&mode=' + ApexPages.currentPage().getParameters().get('mode'));
                pageRef.setRedirect(true); 
                return pageRef;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: save due date exception, Please contact IT Administrator if any assistance needed'));
            return null;
        }    
    }
    
    public PageReference TestSubmit(){
        
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'submit scuccess'));
            return null;
    
    }
    
    @future (callout=true)
    public static void GEFDataSend(String fileId,string parentId,string userId, string stgId, string stgName) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://import.gameffectiveapplication.com:8443/pushservice/json/auqerwfhos1nnl4/oracle');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        string body = '[{"type": "ODPDoc",'+
        '"operation": "add",'+  
        '"data": {'+
                    '"attributes": {'+
                    '"type": "ODPDoc",'+
                    '"url": "https://hp--esit--c.cs11.visual.force.com/servlet/servlet.FileDownload?file='+fileId+'"},'+
                  '"RawBody": "To download this document click on this link:https://hp--esit--c.cs11.visual.force.com/servlet/servlet.FileDownload?file='+fileId+'",'+
                  '"Body": "To download this document click on this link:https://hp--esit--c.cs11.visual.force.com/servlet/servlet.FileDownload?file='+fileId+'",'+
                  '"FeedPostId": "",'+
                  '"LikeCount": 0,'+
                  '"ParentId": "'+parentId+'",'+
                  '"StageId": "'+stgId+'",'+
                  '"StageName": "'+stgName+'",'+
                  '"SystemModstamp": "'+system.now()+'",'+
                  '"Type": "ODPDoc",'+
                  '"UserId": "'+userId+'",'+
                  '"CreatedById": "'+userId+'",'+
                  '"CreatedDate": "'+system.now()+'",'+
                  '"IsDeleted": false,'+
                  '"LastModifiedDate": "'+system.now()+'",'+
                  '"Id": "'+fileId+'",'+
                  '"CommentCount": 0},'+
           '"additionalData": {}'+
        '}]';
        req.setBody(body);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        System.debug(body);
        try {
            res = http.send(req);
            System.debug('response:' + res.getBody());
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
   }
}