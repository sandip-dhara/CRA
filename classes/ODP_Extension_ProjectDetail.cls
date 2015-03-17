//global virtual class ODP_Extension_ProjectDetail {
public class ODP_Extension_ProjectDetail {
    
    //Added By Ning for Permission Sets check
    public boolean IsBizEngaPartners{get;set;}
    
    // Added By Ning for Opp Input
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
    public LIST<OPPLink__c> links {get;set;}
    public OPPLink__c link {get;set;}
    
    
    public String flightPlanChanged{get;set;}
    
    public integer followerCount{get;set;}
    public List<EntitySubscription> followers{get;set;}
    
    public string currentStageStatus{get;set;}
    public Offering_Release__c project{get;set;}
    public List<Release_Stage__c> stages{get;set;}
    public List<String> stagesHTML{get;set;}
    
    public string host{get;set;}
    public List<Core_Team_Member__c> teamMembers{get;set;}
    public List<Potential_Risk__c> potentialRisks{get;set;}
    public List<Release_Deliverable__c> deliverables{get;set;}
    public List<Customer_Commitment__c> customerCommits{get;set;}
    public List<PPM__C> risks{get;set;}
    public Boolean delFlag{get;set;}
    
    public PPM__c ppm{get;set;}
    
    public ShowStage showStage{get;set;}
    public List<ShowStage> showStageList{get;set;}
    
    public Release_Stage__c startUpStage{get;set;}
    public Release_Stage__c conceptStage{get;set;}
    public Release_Stage__c definitionStage{get;set;}
    public Release_Stage__c validationBetaReadyStage{get;set;}
    public Release_Stage__c validationBetaCompleteStage{get;set;}
    public Release_Stage__c rollOutStage{get;set;}
    
    public string startUpStageFlag{get;set;}
    public string conceptStageFlag{get;set;}
    public string definitionStageFlag{get;set;}
    public string validationBetaReadyStageFlag{get;set;}
    public string validationBetaCompleteStageFlag{get;set;}
    public string rollOutStageFlag{get;set;}
    
    public Stage_Work_Element__c workElement{get;set;}
    public List<Stage_Work_Element__c> workElements{get;set;}
   
   
   
   
    //public List<String> workElementsStatus{get;set;}
    public Integer Total{get;set;}
    public Integer notStarted{get;set;}
    public Integer inProgress{get;set;}
    public Integer inReview{get;set;}
    public Integer reviewComplete{get;set;}
    public Integer failed{get;set;}
    public Integer onHold{get;set;}
    public Integer cancelled{get;set;}
    public Integer complete{get;set;}
    
    
    public ODP_Extension_ProjectDetail(ApexPages.StandardController controller) {
        IsBizEngaPartners = ODP_Class_CommonTools.IsBizEngaPartner();
        project = (Offering_Release__c)controller.getRecord();
        host = ApexPages.currentPage().getHeaders().get('Host');
        project.id = Apexpages.currentPage().getParameters().get('id');
        //project.id = 'a6yZ0000000DGCy';
        //-----------------------Link
        link = new OPPLink__c();
        attachDoc = new Attachment();
        
        
        delFlag = false;
        flightPlanChanged = 'block';
        if(project.id != null){
            
            //get Opp Inout
            documents = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid = :project.id ORDER By Name];
            links = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from OPPLink__c where Opportunity__c=:project.id];
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
            for(OPPLink__c attTemp : links ){
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
            
            
            
            //Get the Followers Count
            followers = [select id, subscriberid, subscriber.name, subscriber.SmallPhotoUrl,CreatedDate from EntitySubscription where parentid =: project.id];
            //End
            
            //All stages
            ppm = new PPM__C();
            stages = [select id,Name,Stage_Name__c,Status__c,PAC_Name__c,Include__c,Release_Name__c  from Release_Stage__c where Offering_Release_ID__c =: project.id order by Name];
            if(stages.size() < 1){
                flightPlanChanged = 'none';
            }
            stagesHTML = new List<String>();
            string currentStage = '';
            for(Release_Stage__c stage:stages ){
                if(currentStage == ''){
                    currentStage = stage.Stage_Name__c;
                }
                if(stage.Status__c != 'Not Started'){
                    currentStage = stage.Stage_Name__c;
                }
            }
            string stageStyle = 'c_h_ppl';
            integer i = 0;

            showStageList = new List<ShowStage>();
            for(Release_Stage__c stage:stages ){
                showStage sStage = new showStage();
                sStage.Name = stage.Stage_Name__c;
                sStage.Status = stage.Status__c;
                sStage.Id = stage.id;
                List<AggregateResult>  weList = [select Status__c,COUNT(id) statusCount from Stage_Work_Element__c where Release_Stage_ID__c=:stage.id group by Status__c];
                for(AggregateResult ar:weList ){
                    if(ar.get('Status__c') == 'Not Started'){
                        sStage.NotStarted = integer.valueof(ar.get('statusCount'));
                    }
                    else if(ar.get('Status__c') == 'In Progress'){
                        sStage.InProgress= integer.valueof(ar.get('statusCount'));
                    }
                    else if(ar.get('Status__c') == 'Ready for Review'){
                        sStage.ReadyforReview= integer.valueof(ar.get('statusCount'));
                    }
                    else if(ar.get('Status__c') == 'Under Review'){
                        sStage.UnderReview= integer.valueof(ar.get('statusCount'));
                    }
                    else if(ar.get('Status__c') == 'Review Complete'){
                        sStage.ReviewComplete= integer.valueof(ar.get('statusCount'));
                    }
                    else if(ar.get('Status__c') == 'Complete'){
                        sStage.Complete= integer.valueof(ar.get('statusCount'));
                    }
                }
                
                showStageList.add(sStage);
                if(stage.Stage_Name__c == currentStage )
                {
                    stageStyle = 'c_h_mail';

                    showStage = sStage; //stage.id
                }

                //string stgEditPage = host+ '/apex/ODP_Page_Stage?retURL=%2F'+project.id+'&id='+stage.id; //URLFOR($Action.ODP_Page_ProjectDetail.Eidt, stage.id, [retURL=project.id], true);
                string stgEditPage = host+ '/'+stage.id;
                string stageHTML = '<a id="'+ stageStyle +'" href="https://'+stgEditPage +'" onmouseover="stageMouseOver('+i+')"><span class="is_c" dir="ltr"><i class="white icon-repeat icon-4x '+getImgStyleForStage(stage.Stage_Name__c)+'"></i></span><span>'
                    +stage.Stage_Name__c+'</span></a>';
                i = i+1;
                stagesHTML.add(stageHTML);  
                if(stage.Stage_Name__c == currentStage )
                {
                    stageStyle = 'c_h_cal';
                }
            }
            project = [select id,Name,name__c,bvp__c, Offering_Version__c,Offering_Category__c,Release_Type__c,Release_Description__c,
            Flight_Plan_ID__c,Flight_Plan_Name__c,Status__c,Practice__c,Facilitator__c,Primary_Business_Contacts__c,PPMC_Project_ID__c,Assumptions__c ,CreatedByID,LastModifiedByID,OwnerID from offering_release__c where id=: project.id];
            
            teamMembers = [SELECT id,Name,Release_Name__c, Release_Role__c,Role_Name__c,User__c,Contributor__c,Reviewer__c,Accountable__c ,User__r.SmallPhotourl FROM Core_Team_Member__c WHERE Release_Name__c=:project.name__c ];
            potentialRisks = [SELECT id,Name, Project_ID__c ,Description__c,Potential_Risk_Owner__c,CreatedDate FROM Potential_Risk__c WHERE Project_ID__c =: project.id];
            deliverables = [SELECT id,Name,Release_Deliverable_Name__c,Include__c  FROM Release_Deliverable__c WHERE Offering_Release__c=: project.id];
            customerCommits = [SELECT id,Name, Project_ID__c,Customer_Name__c,Commitment_Owner__c,Due_Date__c FROM Customer_Commitment__c WHERE Project_ID__c =: project.id];
            //risks = [SELECT id,Name, Name__c,Status__c,Planned_Resolution_Date__c,Risk_Priority_Number__c FROM Risks__c WHERE id =: project.id];
            risks = [SELECT id,PPM_ID__c, PPM_Name__c, PPM_Link__c, PPM_Description__c FROM PPM__c WHERE Opportunity_ID__c =: project.id];
            //Check stage status and fill them in individual stage list

          
            
            //Show all of Work Elements of current stage.
            workElements = [SELECT Id,Name__c,Review_Due_Date__c,Stage_Name__c,Status__c ,Release_Deliverable_ID__c,Contribute_Due_Date__c,Release_Deliverable_ID__r.Release_Deliverable_Name__c FROM Stage_Work_Element__c WHERE Release_Stage_ID__r.Offering_Release_ID__c=:project.id];
            //How many Work Elements in Process step, also in Review,Complete and so on.            
            Total= [SELECT count() From Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: project.id];
            //division total
            if(Total > 0){
             Double x = double.valueOf(Total);
             notStarted =Integer.valueOf( [SELECT count() From Stage_Work_Element__c where Status__c ='Not Started'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100);
             inProgress =Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='In Progress'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100)  ;
             inReview   =Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='In Review'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100 )   ;
             reviewComplete =Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='Review Complete'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100) ;
             failed=Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='Failed'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100);
             onHold=Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='On Hold'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100)  ;
             cancelled=Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='Cancelled'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100) ;
             complete=Integer.valueOf(  [SELECT count() From Stage_Work_Element__c where Status__c ='Complete'and Release_Stage_ID__r.Offering_Release_ID__c =: project.id]/x *100) ;
            }
            else{
                notStarted =0;
                inProgress = 0;
                inReview   = 0;
                reviewComplete = 0;
                failed=0;
                onHold=0;
                cancelled=0;
                complete=0;
            }

           
            
            
            currentStageStatus = String.valueOf(notStarted);
        }
    }
    public string errorMsg{get;set;}
    public string projectId{get;set;}

    public PageReference deleteProject(){
        try{
            //Offering_Release__c delproject = [SELECT id FROM Offering_Release__c WHERE id= :projectId];
            //Delete project;
            delFlag= true;
            return null;
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Exception encountered when delete project. Please contact IT administrators if any assistance needed'));
            errorMsg = 'Delete risk exception, please contact the IT Administrator' + e.getMessage();
            return null;
        } 
    }
    
    public string potenitalRiskId{get;set;}
    public PageReference deletePotenitalRisk(){
        try{
            Potential_Risk__c potenitalRisk= [SELECT id FROM Potential_Risk__c WHERE id = :potenitalRiskId];
            delete potenitalRisk;                
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);            
            pageRef.setRedirect(true); 
            return pageRef;                     
        }
        catch(exception e){
            errorMsg = 'Delete risk exception, please contact the IT Administrator';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }
    
    public string stageId{get;set;}
    public PageReference deleteStage(){
        try{
            Release_Stage__c stage= [SELECT id FROM Release_Stage__c WHERE id = :stageId];
            delete stage;                
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id3=' + project.id);            
            pageRef.setRedirect(true); 
            return pageRef;                     
        }
        catch(exception e){
            errorMsg = 'Delete risk exception, please contact the IT Administrator';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }
    
    public string deliverableId{get;set;}
    public PageReference deleteDeliverable(){
        try{
            Release_Deliverable__c deliverable= [SELECT id FROM Release_Deliverable__c WHERE id = :deliverableId];
            delete deliverable;                
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);            
            pageRef.setRedirect(true); 
            return pageRef;
            //errorMsg = 'ok';
            //return null;     
        }
        catch(exception e){
            errorMsg = 'Delete risk exception, please contact the IT Administrator';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }

    
    public string customerCommitId{get;set;}
    public PageReference deleteCustomerCommit(){
        try{
            Customer_Commitment__c customerCommit= [SELECT id FROM Customer_Commitment__c WHERE id = :customerCommitId];
            delete customerCommit;                
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);            
            pageRef.setRedirect(true); 
            return pageRef;                     
        }
        catch(exception e){
            errorMsg = 'Delete risk exception, please contact the IT Administrator';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }
    
    
    public string ppmId{get;set;}
    
    public PageReference deletePPM(){
        try{
            PPM__c ppm  = [SELECT id FROM PPM__c WHERE id = :ppmId];
            delete ppm;
            risks = [SELECT id,PPM_ID__c, PPM_Name__c, PPM_Link__c, PPM_Description__c FROM PPM__c WHERE Opportunity_ID__c =: project.id];                
            return null;
            /*PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);            
            pageRef.setRedirect(true); 
            return pageRef;                     */
        }
        catch(exception e){
            errorMsg = 'Delete PPM Records exception, please contact the IT Administrator';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Delete team member exception, please contact the IT Administrator'));
            return null;            
        }
    }

    public PageReference save(){
        try{
            upsert project;
            //PageReference OFPage = new PageReference('/apex/ODP_Page_ProjectDetail?id='+project.id);
            //OFPage.setRedirect(true);
            //return OFPage;
            return null;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'exception:' + e.getMessage()));
            return null;   
        }  
    }
    public PageReference cancel(){
        PageReference OFPage = new PageReference('/'+project.id);
        OFPage.setRedirect(true);
        return OFPage;
    }

    public string getImgStyleForStage(string name ){
        string returnStyle='icon-hp-control-zone';
        if(name=='Validate Requests'){
            returnStyle='icon-hp-events';
        }
        else if(name=='Qualify Requests'){
            returnStyle='icon-certificate';
        }
        else if(name=='Incubation Activities'){
            returnStyle='icon-software-sw-architecture';
        }
        else if(name=='Delivery'){
            returnStyle='icon-product-lifecycle-management';
        }
        return returnStyle;
    }
    
    public class ShowStage
    {
        public ShowStage(){
            NotStarted = 0;
            InProgress = 0;
            ReadyforReview = 0;
            UnderReview = 0;
            ReviewComplete = 0;
            Complete = 0;
        }
    
        public String Name {get;set;}
        public String Status {get;set;}
        public String Id {get;set;}
        public Integer NotStarted{get;set;}
        public Integer InProgress{get;set;}
        public Integer ReadyforReview{get;set;}
        public Integer UnderReview{get;set;}
        public Integer ReviewComplete{get;set;}
        public Integer Complete{get;set;}
    }
    
    public PageReference savePPM(){
         try{
            ppm.Opportunity_ID__c = project.id;
            insert ppm;
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: save ppm exception, ex:'+e.getMessage()+' Please contact IT Administrator if any assistance needed'));
            return null;
        }
    }
    
    
    
    
     public PageReference FileUploadSave(){
        try{
            //contributor.completed__c = True;
            attachDoc.ParentId = project.id; 
            insert attachDoc;
            GEFDataSend(attachDoc.Id,project.id,UserInfo.getUserId());
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id + '&f=t');
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
                OPPLink__c linkDel = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from OPPLink__c where id =: addtaLinkId];
                delete linkDel;                 
            }
            else if(addtaLinkType == 'Document'){
                Attachment  attachmentDel = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE id = :addtaLinkId];
                delete attachmentDel;                 
            } 
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);
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
            List<OPPLink__c> links = [SELECT Link__c,Name,Name__c FROM OPPLink__c WHERE Name__c =:link.Name__c];
            if(links.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Link name was already existed in current work element or in another,please use a unique name.'));
                return null;
            }
            //---end---
            link.Opportunity__c = project.id;
            insert link;
            PageReference pageRef = new PageReference('/apex/ODP_Page_ProjectDetail?id=' + project.id);
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
  
    @future (callout=true)
    public static void GEFDataSend(String fileId,string parentId,string userId) {

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