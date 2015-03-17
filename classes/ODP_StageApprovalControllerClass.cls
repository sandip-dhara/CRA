public with sharing class ODP_StageApprovalControllerClass {

    public Release_Stage__c relstg {get;set;}
    public Stage_Review__c stgrew {get;set;}
    public String relstgID {get;set;}
    public String StgViewId{get;set;}

    public string sssTest{get;set;} 
    public String UserId {get;set;}
    public List<Stage_Review__c> stgrewList{get;set;}
    public List<Risks__c> relriskList{get;set;}
    public List<Core_Team_Member__c> tmmList{get;set;}
    public List<Release_Stage__c> releaseStageList{get;set;} 
    public List<Customer_Commitment__c> commitmentList{get;set;}
    public List<Action_Item__c> actionList{get;set;}
    
    public List<Review__c> reviewListToSwe{get;set;}
    
    public String offeringManagerName{get;set;}
    public String projectManagerName{get;set;}
    public boolean ActionShow{get;set;}
    
    public boolean IsOwner{get;set;}
    public boolean IsDecisoner{get;set;} 
    public boolean IsInStageReview{get;set;} 
    public boolean ActionDisabled{get;set;}
    public boolean IsFacilitator{get;set;}
    public boolean PacDecisionDisabled{get;set;}
    public String PacDecisionError{get;set;}
    public String ReworkSWEId{get;set;}
    public string baseUrl{get;set;}
    public Class RiskAndOwner{
        public Risks__C risk{get;set;}
        public String MitigationAction{get;set;}        
    }
    public Class StageWorkElementAndRating{
        public Stage_Work_Element__c swe{get;set;}
        public string RatingCalculate{get;set;}
        public string reviewCalculate{get;set;}
        public string ratingColor{get;set;}
        public string documentHTML{get;set;}
        public string firstReviewerId{get;set;}
    }
    public class  AttachmentAndLink{
        public string docId{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}
        public string lik{get;set;}         
    } 
    
    public Action_Item__c NewActionItem{get;set;}
  
    public List<StageWorkElementAndRating> sweAndRatingList{get;set;}
    public List<StageWorkElementAndRating> sweMaterialsList{get;set;}
    public List<RiskAndOwner>  riskAndOwnerList{get;set;}
    public List<Mitigation_Action__c> mitigationList{get;set;}
    public ODP_StageApprovalControllerClass(ApexPages.StandardController controller) {
        ActionDisabled = false;
        PacDecisionDisabled = true;
        relstg = (Release_Stage__c)controller.getRecord();
        IsInStageReview = false;
        relstgID  = ApexPages.currentPage().getParameters().get('id');
        StgViewId = ApexPages.currentPage().getParameters().get('vid');
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        if(ApexPages.currentPage().getParameters().get('mode')== 'Open'){
            ActionShow = true;
        }
        else{
            ActionShow = false;
        }
        
        UserId = UserInfo.getUserId();
        IsFacilitator = false;
        IsOwner = false;
        if (relstgID!=null){
            relstg = [SELECT id, name,
                          Offering_Release_ID__c,   
                          Release_Name__c, 
                          Stage_Name__c, 
                          Status__c,
                          Meeting_Notes__c,
                          PAC_Decision__c,
                          //Assumptions__c,
                          //Assumptions_Date__c,
                          //Commitment_Dates__c,
                          //Commitment_Description__c,
                         // Customers__c,
                          //Review_Date__c,
                          CreatedBy.Last_First_Name__c,
                          Offering_Release_ID__r.OwnerId,
                          Offering_Release_ID__r.Assumptions__c,
                          Offering_Release_ID__r.Facilitator__c,
                          Offering_Release_ID__r.Facilitator__r.email,
                          Offering_Release_ID__r.Owner.Id,                           
                          Offering_Release_ID__r.Owner.email,
                          Offering_Release_ID__r.Owner.Name,
                          Offering_Release_ID__r.id,
                          Current_Baseline_End_Date__c,
                          PAC_Name__c
                          //Budget_Baseline__c,
                          //Budget_Proposed__c,
                          //Budget_Actual__c,
                         // Budget_Baseline_To_Actual__c,
                          //Budget_Baseline_To_Proposed__c,
                         // Budget_Proposed_To_Actual__c,
                         // Revenue_Actual__c,
                         // Revenue_Baseline__c,
                         // Revenue_Proposed__c,
                         // Revenue_Baseline_To_Actual__c,
                        //  Revenue_Baseline_To_Proposed__c,
                        //  Revenue_Proposed_To_Actual__c                           
                      FROM Release_Stage__c
                      WHERE id=: relstgID];
            //Tovid  -- 
            ctmList = [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: relstg.Release_Name__c ];    
            PACMemberList = [select id, PAC_Name__c, User__r.Last_First_Name__c, User__c from ODP_PAC_Member__c where PAC_Name__c =: relstg.PAC_Name__c];
            //          
            IsInStageReview =  relstg.Status__c == 'In Review';
            PacDecisionDisabled = (relstg.Status__c != 'In Review' && relstg.Status__c != 'Review Complete');
            IsFacilitator = String.valueOf(relstg.Offering_Release_ID__r.Facilitator__c) == UserId;
            IsOwner = String.valueOf(relstg.Offering_Release_ID__r.OwnerId) == UserId;
            tmmList = [SELECT id, Role_Name__c, User__r.Name FROM Core_Team_Member__c WHERE Release_Name__c =:relstg.Release_Name__c order by User__r.Name];
            List<Release_Role__c> releaseRoleProList = [select id from Release_Role__c where Offering_Release__c =: relstg.Offering_Release_ID__c and Role_Name__c = 'Project Manager'];
            if(releaseRoleProList.size() == 0 ){
                projectManagerName = 'None Assigned';
            }else{
                List<Core_Team_Member__c> ctmList = [select User__r.Name from Core_Team_Member__c where Release_Role__c =: releaseRoleProList[0].id and Role_Name__c = 'Project Manager'];
                if(ctmList.size() > 0 ){
                    projectManagerName = ctmList[0].User__r.Name; 
                }else{
                    projectManagerName = 'None Assigned';
                }
            }
            offeringManagerName = [select name from User where id =: relstg.Offering_Release_ID__r.OwnerId ].name;
                        
                stgrewList = [SELECT id, name,
                          Comment__c,
                          Complete__c,
                          Decision__c,
                          PAC_Member_Name__c,
                          PAC_Member_ID__r.User__r.id,
                          PAC_Member_ID__r.User__r.email,
                          PAC_Member_ID__r.User__r.smallphotourl,
                          PAC_Member_ID__r.User__r.Name                            
                          FROM Stage_Review__c
                          WHERE Release_Stage_ID__c =:relstgID];
                for(Stage_Review__c src : stgrewList){
                    if(String.IsEmpty(StgViewId)){
                        StgViewId = String.ValueOf(src.id);
                    }
                   if(StgViewId == String.ValueOf(src.id)){
                        stgrew = src;
                       if(UserId.equals(src.PAC_Member_ID__r.User__r.id)){
                          IsDecisoner = true; 
                       }
                   }
                   //break;  
                }
                if(stgrew == null)
                {
                    ActionDisabled = true;
                }
                else
                {
                    if(stgrew.Complete__c || !IsInStageReview)
                    {
                        ActionDisabled = true;
                    }
                }
                relriskList = [SELECT id, name,
                           Name__c,
                           Description__c,
                           Planned_Resolution_Date__c,
                           Status__c,
                           Risk_Priority_Number__c,
                           //Mitigation_Steps__c,
                           //CreatedBy.Last_First_Name__c,
                           //CreatedById
                           //Owner_Team_Member_ID__r.User__c,
                           //Owner_Team_Member_ID__c,
                           Owner.id,
                           Owner.Name,
                           Project_ID__c                            
                           FROM Risks__c
                           where Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c = :relstg.Offering_Release_ID__r.id
                           and Status__c = 'Active'
                           order by Risk_Priority_Number__c desc
                          ];
                
                set<Id> risksIdSet = new set<Id>();          
                for(Risks__c risksObj : relriskList ){
                    risksIdSet.add(risksObj.id);    
                }          
                riskAndOwnerList = new List<RiskAndOwner>();
                                 
                for(Risks__c riskTemp : relriskList){
                    //List<Risk_Accountable_User__c> rauList = [select User__r.name from Risk_Accountable_User__c where Risk_ID__c =: riskTemp.id];
                    RiskAndOwner riskOwnrTemp  = new RiskAndOwner();                                             
                    riskOwnrTemp.risk =  riskTemp;
                    
                    /*
                    for(Mitigation_Action__c mitiActionObj : mitigationList){
                        if(mitiActionObj.Risk_ID__c.equals(riskTemp.id) && mitiActionObj.Owner_Team_Member_ID__c.equals(riskTemp.Owner_Team_Member_ID__c)){
                            riskOwnrTemp.MitigationAction = mitiActionObj.Name__c; 
                            break;   
                        }
                    }
                    */
                    //riskOwnrTemp.OwnerName = riskTemp.CreatedBy.Last_First_Name__c;
                    /*
                    if(rauList.size() > 0 ){
                          riskOwnrTemp.risk =  riskTemp;
                          //riskOwnrTemp.OwnerName = rauList[0].User__r.name;
                          riskOwnrTemp.OwnerName = riskTemp.CreatedBy.Last_First_Name__c;
                          riskAndOwnerList.add(riskOwnrTemp);                             
                    }else{
                        riskOwnrTemp.risk  =  riskTemp;
                        //riskOwnrTemp.OwnerName = null;
                        riskOwnrTemp.OwnerName = riskTemp.CreatedBy.Last_First_Name__c;
                        riskAndOwnerList.add(riskOwnrTemp);                                                     
                    } 
                    */
                    riskAndOwnerList.add(riskOwnrTemp);
                } 
                List<Stage_Work_Element__c>  sweList = [select Name__c,id,Status__c,Text__c,Release_Deliverable_ID__r.Stage_Material__c,lastmodifiedDate from Stage_Work_Element__c where Release_Stage_ID__c =: relstgID];
                sweAndRatingList =  new List<StageWorkElementAndRating>();
                sweMaterialsList =  new List<StageWorkElementAndRating>();
                for(Stage_Work_Element__c sweTemp : sweList){
                    List<Review__c> reviewList = [select Id,Rating__c,Complete__c from Review__c  where Stage_Work_Element__c =: sweTemp.id ];
                    Integer reviewFinishCount = 0;
                    Double ratingTotal = 0;
                    Double ratingAverage = 0;
                    StageWorkElementAndRating sweRatingTemp = new StageWorkElementAndRating();
                    for(Review__c review : reviewList){
                        if(string.isEmpty(sweRatingTemp.firstReviewerId)){
                            sweRatingTemp.firstReviewerId = String.ValueOf(review.Id);
                        }
                        if(review.Complete__c){
                            reviewFinishCount ++;
                        }
                        if(review.Rating__c != null){
                            ratingTotal = ratingTotal + Double.valueOf(review.Rating__c);
                        }
                        else{
                            ratingTotal = ratingTotal + 0;
                        }
                    }
                    if(reviewFinishCount > 0){
                        ratingAverage = ratingTotal / reviewFinishCount;
                    }
                    
                    StageWorkElementAndRating sweMaterialsTemp = new StageWorkElementAndRating();
                    sweRatingTemp.swe = sweTemp;
                    sweMaterialsTemp.swe = sweTemp;
                    sweRatingTemp.RatingCalculate = String.valueOf(ratingAverage);
                    sweMaterialsTemp.RatingCalculate = String.valueOf(ratingAverage);
                    if(ratingAverage < 2){
                        sweRatingTemp.ratingColor = 'red';
                        sweMaterialsTemp.ratingColor = 'red';
                    }else if(ratingAverage < 3 && ratingAverage >=2 ){
                        sweRatingTemp.ratingColor = 'yellow';
                        sweMaterialsTemp.ratingColor = 'yellow';
                    }else{
                        sweRatingTemp.ratingColor = 'white';
                        sweMaterialsTemp.ratingColor = 'white';
                    }
                    sweRatingTemp.reviewCalculate =  String.valueOf(reviewFinishCount) + ' out of ' + String.valueOf(reviewList.size());
                    sweMaterialsTemp.reviewCalculate =  String.valueOf(reviewFinishCount) + ' out of ' + String.valueOf(reviewList.size());
                    
                    
                    //add  docHtml
                    LIST<AttachmentAndLink> attachmentAndLinkTempList = new LIST<AttachmentAndLink> ();
                    List<Attachment> documents = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid = :sweTemp.id ORDER By Name];
                    List<Link__c>    links = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from Link__c where Stage_Work_Element_ID__c = :sweTemp.id];
                    User tempUser = new User();           
                    for(Attachment attTemp : documents ){
                        AttachmentAndLink tempObj = new AttachmentAndLink();
                
                        tempObj.docId= string.valueOf(attTemp.id); 
                        tempObj.name = attTemp.name;
                        tempObj.fileType = 'Document';
                        tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
                        tempObj.addBY = tempUser.Name;
                        tempObj.modifyDate = attTemp.lastmodifiedDate.date();
                        tempObj.lik = null;               
                        attachmentAndLinkTempList.add(tempObj);                               
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
                        attachmentAndLinkTempList.add(tempObj);                                
                    }
                    //Tovid 4.16 - HTML for quality review 
                    string docHtml = '<tr id="Row' + sweTemp.id+ '" style="display:none"><td style="color:red" colspan="3">';
                    if(attachmentAndLinkTempList.size() > 0){
                        for(AttachmentAndLink attAndLinkTemp : attachmentAndLinkTempList){
                            if(attAndLinkTemp.fileType == 'Document'){
                                docHtml  = docHtml   + ' <span>• <a href="/servlet/servlet.FileDownload?file=' + attAndLinkTemp.docId + '" target="_blank">' + attAndLinkTemp.name + '</a></span><span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';
                            }else if(attAndLinkTemp.fileType == 'Link'){
                                docHtml  = docHtml   + ' <span>• <a href="' + attAndLinkTemp.lik  + '" target="_blank">' + attAndLinkTemp.name+ '</a></span><span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';                            
                            }
                        }
                    }
                    else{
                        docHtml  = docHtml   + ' <span>•No related content!</span></br>'; 
                    }
                    docHtml  = docHtml   + '<span>• <a href="javascript:showDocumentsSection(\'rowtext' + sweTemp.id + '\');">text</a></span></br>' ;                      
                    docHtml  += '</td></tr>';
                    //Tovid 4.16 - HTML for Stage Materials 
                    string docmaterialsHtml = '<tr id="Rowmaterials' + sweTemp.id+ '" style="display:none"><td style="color:red" colspan="3">';
                    if(attachmentAndLinkTempList.size() > 0){
                        for(AttachmentAndLink attAndLinkTemp : attachmentAndLinkTempList){
                            if(attAndLinkTemp.fileType == 'Document'){
                                docmaterialsHtml = docmaterialsHtml + ' <span>• <a href="/servlet/servlet.FileDownload?file=' + attAndLinkTemp.docId + '" target="_blank">' + attAndLinkTemp.name + '</a></span><span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';
                            }else if(attAndLinkTemp.fileType == 'Link'){
                                docmaterialsHtml = docmaterialsHtml + ' <span>• <a href="' + attAndLinkTemp.lik  + '" target="_blank">' + attAndLinkTemp.name+ '</a></span><span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';                            
                            }
                        }
                    }
                    else{
                        docmaterialsHtml = docmaterialsHtml + ' <span>•No related content!</span></br>'; 
                    }
                    docmaterialsHtml = docmaterialsHtml + '<span>• <a href="javascript:showDocumentsSection(\'rowtextmaterials' + sweTemp.id + '\');">text</a></span></br>' ;                      
                    docmaterialsHtml += '</td></tr>'; 
                    sweRatingTemp.documentHTML = docHtml ; 
                    sweAndRatingList.add(sweRatingTemp);
                    if(sweTemp.Release_Deliverable_ID__r.Stage_Material__c == true){
                        sweMaterialsTemp.documentHTML = docmaterialsHtml; 
                        sweMaterialsList.add(sweMaterialsTemp);    
                    }
                }
            
            //get the project datas
            releaseStageList =[  select id, Stage_Name__c, Initial_Baseline_End_Date__c,Current_Baseline_End_Date__c,Actual_Start_Date__c, Actual_End_Date__c     FROM Release_Stage__c
                      WHERE Offering_Release_ID__c =: relstg.Offering_Release_ID__c];
           
            //get commitments
            commitmentList = [select id,Customer_Name__c,Owner__c,Due_Date__c from Customer_Commitment__c where Project_ID__c=:relstg.Offering_Release_ID__c];
            
            //get action items
            actionList = [select id,Name__c,Status__c,Action_Owner__r.User__C from Action_Item__c where Stage_ID__c=:relstg.Id];
            
            NewActionItem = new Action_Item__c();
            NewActionItem.Stage_ID__c = relstg.id;
        }         
    }
    
    
    
       public PageReference ApprovalSave(){
            try{
                update stgrew;
                PageReference pageRef = new PageReference( '/apex/ODP_ReleaseStageApprovalDetail?id=' + relstgID+ '&vid=' + StgViewId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
                pageRef.setRedirect(true); 
                return pageRef;
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: PAC vote saving exception, Please try again later or contact IT Administrator'));
                return null;
            }          
      }
       public PageReference MeetingNotesSave(){
            try{
                update relstg;
                PageReference pageRef = new PageReference( '/apex/ODP_ReleaseStageApprovalDetail?id=' + relstgID + '&vid=' + StgViewId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
                pageRef.setRedirect(true); 
                return pageRef;
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: meeting notes saving, Please try again later or contact IT Administrator'));
                return null;
            }          
      }
      
      //Hunter Facilitator set PacDecision 
      public PageReference PACDecisionSave(){
            try{
                if(relstg.PAC_Decision__c == 'Go')
                {
                    for(Stage_Review__c src : stgrewList){
                        if(src.Decision__c != 'Go'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Not all PAC members vote for Go for this stage'));
                            PacDecisionError = 'Not all PAC members vote for Go for this stage';
                            return null;
                        }
                    }
                    for(Action_Item__c act:actionList){
                        if(act.Status__c != 'Complete' && act.Status__c != 'Canceled'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Some of the stage action items are still in progress'));
                            return null;
                        }
                    }
                    
                    Release_Stage__c  updateStage = [select id,PAC_Decision__c,Status__c from Release_Stage__c  where Id=:relstg.Id limit 1];
                    updateStage.PAC_Decision__c = 'Go';
                    updateStage.Status__c = 'Complete';
                    update updateStage;
                    notifyPacDecision('Go');
                }
                else if(relstg.PAC_Decision__c == 'Continue')
                {
                    for(Stage_Review__c src : stgrewList){
                        if(src.Decision__c != 'Continue'){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Not all PAC members vote for Continue for this stage'));
                            return null;
                        }
                    }
                    
                    
                    Release_Stage__c  updateStage = [select id,PAC_Decision__c,Status__c from Release_Stage__c  where Id=:relstg.Id limit 1];
                    updateStage.PAC_Decision__c = 'Continue';
                    updateStage.Status__c = 'In Progress';
                    update updateStage;
                    Offering_Release__c updateProject = [select id,Status__c from Offering_Release__c where Id=:relstg.Offering_Release_ID__c limit 1];
                    updateProject.Status__c = 'In Development';
                    update updateProject;
                    notifyPacDecision('Continue');
                }
                else if(relstg.PAC_Decision__c == 'No Go')
                {
                    boolean hasPacNotSetGo = false;
                    for(Stage_Review__c src : stgrewList){
                        if(src.Decision__c != 'Go'){
                            hasPacNotSetGo = true;
                            break;
                        }
                    }
                    if(hasPacNotSetGo == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'All PAC members voted for Go, Your PAC Decision should be Go'));
                        return null;
                    }
                    
                    Release_Stage__c  updateStage = [select id,PAC_Decision__c,Status__c from Release_Stage__c  where Id=:relstg.Id limit 1];
                    updateStage.PAC_Decision__c = 'No Go';
                    updateStage.Status__c = 'Cancelled';
                    update updateStage;
                    Offering_Release__c updateProject = [select id,Status__c from Offering_Release__c where Id=:relstg.Offering_Release_ID__c limit 1];
                    updateProject.Status__c = 'Cancelled';
                    update updateProject;
                    List<Release_Stage__c> updateStageList = [select id,PAC_Decision__c,Status__c from Release_Stage__c where Offering_Release_ID__c =:relstg.Offering_Release_ID__c and Status__c in ('Not Started','In Progress')];
                    for(Release_Stage__c stage:updateStageList){
                        stage.Status__c = 'Cancelled';
                    }
                    update updateStageList;
                    notifyPacDecision('No Go');
                }
                else if(relstg.PAC_Decision__c == 'Redirect')
                {
                    boolean onePacSetRed = false;
                    for(Stage_Review__c src : stgrewList){
                        if(src.Decision__c == 'Redirect'){
                            onePacSetRed = true;
                            break;
                        }
                    }
                    if(onePacSetRed == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'You are NOT allowed to redirect this stage unless at least one PAC member voted for Redirect.'));
                        return null;
                    }
                    
                    Release_Stage__c  updateStage = [select id,PAC_Decision__c,Status__c,Iteration_Count__c from Release_Stage__c  where Id=:relstg.Id limit 1];
                    updateStage.PAC_Decision__c = 'Redirect';
                    updateStage.Status__c = 'In Progress';
                    if(updateStage.Iteration_Count__c == null){
                        updateStage.Iteration_Count__c = 1;
                    }
                    else{
                        updateStage.Iteration_Count__c += 1;
                    }
                    update updateStage;
                    List<Stage_Review__c> SRObjList = [select id, Complete__c from Stage_Review__c where Release_Stage_ID__c =: relstg.Id];
                    for(Stage_Review__c SRObj : SRObjList ){
                        SRObj.Complete__c = false;
                    }
                    update SRObjList;
                     
                    notifyPacDecision('Redirect');
                }
                else if(relstg.PAC_Decision__c == 'Hold')
                {
                    boolean hasPacNotSetGo = false;
                    for(Stage_Review__c src : stgrewList){
                        if(src.Decision__c != 'Hold'){
                            hasPacNotSetGo = true;
                            break;
                        }
                    }
                    if(hasPacNotSetGo == false){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'You are NOT allowed to hold this stage unless at least one PAC member voted for On Hold.'));
                        return null;
                    }
                    
                    Release_Stage__c  updateStage = [select id,PAC_Decision__c,Status__c from Release_Stage__c  where Id=:relstg.Id limit 1];
                    updateStage.PAC_Decision__c = 'Hold';
                    updateStage.Status__c = 'On Hold';
                    update updateStage;
                    Offering_Release__c updateProject = [select id,Status__c from Offering_Release__c where Id=:relstg.Offering_Release_ID__c limit 1];
                    updateProject.Status__c = 'On Hold';
                    update updateProject;
                    List<Release_Stage__c> updateStageList = [select id,PAC_Decision__c,Status__c from Release_Stage__c where Offering_Release_ID__c =:relstg.Offering_Release_ID__c and Status__c in ('Not Started','In Progress')];
                    for(Release_Stage__c stage:updateStageList){
                        stage.Status__c = 'On Hold';
                    }
                    update updateStageList;
                    notifyPacDecision('Hold');
                }
                PageReference pageRef = new PageReference( '/apex/ODP_ReleaseStageApprovalDetail?id=' + relstgID + '&vid=' + StgViewId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
                pageRef.setRedirect(true); 
                return pageRef;
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: submit stage review result exception, Please contact IT Administrators'));
                return null;
            }          
      }

      //Hunter: before submit pacDecision, use apex:actionFunction validate the decision.
      public PageReference PACDecisionValidate()
      {
          if(relstg.PAC_Decision__c == 'Go')
          {
              for(Stage_Review__c src : stgrewList){
                  if(src.Decision__c != 'Go'){
                      PacDecisionError = 'Not all PAC members vote for Go for this stage. You cannot submit stage review result with GO';
                      return null;
                  }
              }
              for(Action_Item__c act:actionList){
                  if(act.Status__c != 'Complete' && act.Status__c != 'Canceled'){
                      PacDecisionError = 'Some of the stage action items are still in progress';
                      return null;
                  }
              }
          }
          else if(relstg.PAC_Decision__c == 'Continue')
          {
              for(Stage_Review__c src : stgrewList){
                  if(src.Decision__c != 'Continue'){
                      PacDecisionError = 'Not all PAC members vote for Continue for this stage.You cannot submit stage review result with Continue';
                      return null;
                  }
              }
          }
          else if(relstg.PAC_Decision__c == 'No Go')
          {
              boolean hasPacNotSetGo = false;
              for(Stage_Review__c src : stgrewList){
                  if(src.Decision__c != 'Go'){
                      hasPacNotSetGo = true;
                      break;
                  }
              }
              if(hasPacNotSetGo == false){
                  PacDecisionError = 'All PAC members voted for Go, Your PAC Decision should be Go';
                  return null;
              }
          }
          else if(relstg.PAC_Decision__c == 'Redirect')
          {
              boolean onePacSetRed = false;
              for(Stage_Review__c src : stgrewList){
                  if(src.Decision__c == 'Redirect'){
                      onePacSetRed = true;
                      break;
                  }
              }
              if(onePacSetRed == false){
                  PacDecisionError = 'You are NOT allowed to redirect this stage unless at least one PAC member voted for redirect.';
                  return null;
              }
          }
          else if(relstg.PAC_Decision__c == 'Hold')
          {
              boolean hasPacNotSetGo = false;
              for(Stage_Review__c src : stgrewList){
                  if(src.Decision__c != 'Hold'){
                      hasPacNotSetGo = true;
                      break;
                  }
              }
              if(hasPacNotSetGo == false){
                  PacDecisionError = 'You are NOT allowed to hold this stage unless at least one PAC member voted for On Hold.';
                  return null;
              }
          }
          else
          {
              PacDecisionError = 'Your must select a valid pac decision first.';
              return null;
          }
          PacDecisionError = 'success';
          return null;
      }
      
      private void notifyPacDecision(String decision)
      {
          Set<Id> notifyUsers = new Set<Id>();
          notifyUsers.add(relstg.Offering_Release_ID__r.OwnerId);
          for(Stage_Review__c pac:stgrewList){
              if(!notifyUsers.contains(pac.PAC_Member_ID__r.User__r.id)){
                  notifyUsers.add(pac.PAC_Member_ID__r.User__r.id);
              }
          }
          
        for(Id uId:notifyUsers)
        {
            if(uId == relstg.Offering_Release_ID__r.OwnerId){
                ODP_Class_EmailNotification.SendToPerson(String.valueOf(uid),
                  'The Stage "' + relstg.Stage_Name__c + '" has been set to ' + decision,
                  'The Stage "' + relstg.Stage_Name__c + '" has been set to ' + decision + '. by '+ userInfo.getName() + '. please review all the work element under this stage and choose to rework.',
                  '<a href="{base}/'+relstg.Offering_Release_ID__c+'"> ' + relstg.Release_Name__c + '</a>',
                  '<a href="{base}/apex/ODP_ReleaseStageApprovalDetail?id='+relstg.Id+'"> ' + relstg.Stage_Name__c + '</a>',
                                                     Null,
                  Null,
                  'Business Engagement Partner : <a href="mailto:' + relstg.Offering_Release_ID__r.Owner.email  + '">  ' + relstg.Offering_Release_ID__r.Owner.Name + ' </a>');
            }
            else{
            ODP_Class_EmailNotification.SendToPerson(String.valueOf(uid),
                  'The Stage "' + relstg.Stage_Name__c + '" has been set to ' + decision,
                  'The Stage "' + relstg.Stage_Name__c + '" has been set to ' + decision + '. by '+ userInfo.getName(),
                  '<a href="{base}/'+relstg.Offering_Release_ID__c+'"> ' + relstg.Release_Name__c + '</a>',
                  '<a href="{base}/'+relstg.Id+'"> ' + relstg.Stage_Name__c + '</a>',
                                                     Null,
                  Null,
                  'Business Engagement Partner : <a href="mailto:' + relstg.Offering_Release_ID__r.Owner.email  + '">  ' + relstg.Offering_Release_ID__r.Owner.Name + ' </a>');
            }
        }
                    
      }
    
    public PageReference Rework(){
        if(!IsOwner){
            PacDecisionError = 'only Business Engagement Partner can rework this work element.';
            return null;
        }
        Stage_Work_Element__c swe = [select id ,Status__c,Name__C,Release_Stage_ID__c,Stage_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__c,
                Release_Stage_ID__r.Release_Name__c,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.email,
                Release_Stage_ID__r.Offering_Release_ID__r.Owner.Name,
                Release_Stage_ID__r.PAC_Decision__c
                from Stage_Work_Element__c where id =: ReworkSWEId];
        if(swe.Status__c == 'Not Started' || swe.Status__c == 'In Progress'){
            PacDecisionError = 'You are NOT allowed to rework this work element when its status is ' + swe.Status__c;
            return null;
        }
        if(swe.Release_Stage_ID__r.PAC_Decision__c != 'Redirect'){
            PacDecisionError = 'You are only allowed to rework this work element when this stage is Redirect.';
            return null;
        }
        PacDecisionError = ODP_Class_CommonTools.ReworkWorkElment(ReworkSWEId);
        return null;
    }
      //Facilitator set PacDecision end
      
      public string stageWorkElementName{get;set;}
      public string stageworkelmentIdPra{get;set;}
      public void findStageWorkElementById(){
          try{
              reviewListToSwe = new List<Review__c>();           
              //string swePra = Apexpages.currentPage().getParameters().get('stageworkelmentIdPra');
              stageWorkElementName = [select Name__c
                  from Stage_Work_Element__c where id =: stageworkelmentIdPra].Name__c;
              reviewListToSwe = [select Team_Member_Name__c ,Rating__c,Complete__c,Comment__c,Role_Name__c from Review__c  where Stage_Work_Element__c =: stageworkelmentIdPra];  
                
          }
          catch(exception e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: Exception when getting work elements, Please contact IT Administrators for assistance')); 
          }  
      }
      
      // new action item
      public List<Core_team_member__c> ctmList{get;set;}
      public List<ODP_PAC_member__c> PACMemberList{get;set;} 
      public boolean IsPMorFac{get;set;}
      public string CurOffRelID{get;set;}    
                public List<SelectOption> CTMName{
          get{
                List<SelectOption> options = new List<SelectOption>();   
                for(core_team_member__c ctmobj : ctmList){
                  options.add(new SelectOption(ctmobj.id,ctmobj.User__r.Last_First_Name__c + ' | ' + ctmobj.Role_Name__c));                           
                }
                return options;
             }
          }
        public List<SelectOption> ApproverList{
          get{
                List<SelectOption> options = new List<SelectOption>();   
                for(Stage_Review__c reviewer : stgrewList){
                  options.add(new SelectOption(reviewer.id,reviewer.PAC_Member_Name__c));                           
                }
                return options;
             }
          }
    public void changeApproval(){
        stgrew = null;
        for(Stage_Review__c src : stgrewList){
            if(StgViewId == String.ValueOf(src.id)){
                stgrew = src;
            }
        }
        ActionDisabled = false;
        if(stgrew == null)
        {
            ActionDisabled = true;
        }
        else
        {
            if(stgrew.Complete__c || !IsInStageReview || !IsFacilitator)
            {
                ActionDisabled = true;
            }
        }
    }
        public List<SelectOption> PACRequestor{
            get{
                List<SelectOption> options = new List<SelectOption>();                  
                for(ODP_PAC_Member__c  pacmobj : PACMemberList){
                    options.add(new SelectOption(pacmobj.id , pacmobj.User__r.Last_First_Name__c));                           
                }
                return options;
            }
        }      
        public String  myEditStates {get;set;} 
        public void newActionItem(){
           myEditStates = 'Create';
           NewActionItem = new Action_Item__c();
            NewActionItem.Stage_ID__c = relstg.id;
           NewActionItem.Status__c = 'In Progress'; 
            //PM or Facilitator                                
           if(UserId.equals(relstg.Offering_Release_ID__r.Owner.Id) || UserId.equals(relstg.Offering_Release_ID__r.Facilitator__c)){
               IsPMorFac = true;
           }
           else{
               IsPMorFac = false;
           }                                  
           CurOffRelID = relstg.Offering_Release_ID__c;
                                   
      }  
         private string saveData(){
            try{
                if(NewActionItem.Name__c == null || NewActionItem.Name__c.trim().length() == 0){
                    return 'The Name is required.';
                }
                if(NewActionItem.Action_Owner__c == null){
                    return 'The Action Owner is required.';
                }
                if(NewActionItem.Due_Date__c == null){
                    return 'The Due Date is required.';
                }
                if(NewActionItem.PAC_Requestor__c == null){
                    return 'The PAC Requester is required.';
                }
                
                //if(relstg.status__c != 'In Review'){
                //    return 'Action Items are not allowed to be created and edit, for the current stage status is NOT In Progress. ';
                //}         
                return 'success';
            }
            catch(exception e){
                //return 'failed'; 
                return e.getMessage(); 
            }                 
        } 
        public PageReference SaveActionItem(){
            if(UserId.equals(relstg.Offering_Release_ID__r.Owner.Id) || UserId.equals(relstg.Offering_Release_ID__r.Facilitator__c)){
               IsPMorFac = true;
           }
           else{
               IsPMorFac = false;
           }
           
            string saveflag = saveData();
              
            if(saveflag == 'success')
            {
                if(myEditStates == 'Create'){
                    //When action item is added, notify owner 
                    Core_team_member__c ownerCTM =[select User__c,User__r.Id from Core_team_member__c where Id =: NewActionItem.Action_Owner__c];
                    Release_Stage__c stagTemp = [select id, Release_Name__c,Offering_Release_ID__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,Offering_Release_ID__r.Owner.email,
                                               Offering_Release_ID__r.Owner.Name,Status__c,
                                               Offering_Release_ID__r.Facilitator__c,Stage_Name__c from Release_Stage__c where id=: NewActionItem.Stage_ID__c];   
                    ODP_Class_EmailNotification.SendToPersonForActionItem(String.valueOf(ownerCTM.User__r.Id),
                                          'The Action Item "' + NewActionItem.Name__c + '" is added.',
                                          'The Action Item "' + NewActionItem.Name__c + '" is added, Please check the detail information as below.',
                                          '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                          '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                          null,
                                          null,
                                          'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Owner.email  + '"> ' + stagTemp.Offering_Release_ID__r.Owner.Name + ' </a>',
                                          '<a href="{base}/'+NewActionItem.Id+'">' + NewActionItem.Name__c + '</a>');
                    
                    insert NewActionItem;
                    PageReference pageRef = new PageReference( '/apex/ODP_ReleaseStageApprovalDetail?id=' + relstgID + '&vid=' + StgViewId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
                    pageRef.setRedirect(true);
                    return pageRef ;
                }else{
                    //When the user is the Project Manager or Facilitator and changes the status to Complete and the current Stage status is ‘In Progress’ or ‘Under Review’,
                    if(IsPMorFac == true){
                        Release_Stage__c stagTemp = [select id, Release_Name__c,Offering_Release_ID__c, PAC_Name__c,Offering_Release_ID__r.Owner.Id,Offering_Release_ID__r.Owner.email,
                                               Offering_Release_ID__r.Owner.Name, Status__c,
                                               Offering_Release_ID__r.Facilitator__c,Stage_Name__c from Release_Stage__c where id=: NewActionItem.Stage_ID__c];                      
                        if(NewActionItem.Status__c == 'Complete' && (stagTemp.Status__c.equals('In Progress') || stagTemp.Status__c.equals('In Review'))){
                            //notify the Facilitator and PM that the Action Item is Complete
                            Set<String> userIdSet = new Set<String>();
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                                }       
                            }
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                                }       
                            }
                            for(String userid: userIdSet){                                                            
                                ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                                  'The Action Item "' + NewActionItem.Name__c + '" is Complete.',
                                                  'The Action Item "' + NewActionItem.Name__c + '" is Complete, Please check the detail information as below.',
                                                  '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                                  '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                                  null,
                                                  null,
                                                  'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Owner.email  + '"> ' + stagTemp.Offering_Release_ID__r.Owner.Name + ' </a>',
                                                  '<a href="{base}/'+NewActionItem.Id+'">' + NewActionItem.Name__c + '</a>');  
                            }                                                                 
                        }
                        if(NewActionItem.Status__c == 'Canceled'){
                            //notify the Facilitator and PM that the Action Item is Canceled
                            Set<String> userIdSet = new Set<String>();
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                                }       
                            }
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                                }       
                            }
                            for(String userid: userIdSet){                        
                                ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                                  'The Action Item "' + NewActionItem.Name__c + '" is canceled.',
                                                  'The Action Item "' + NewActionItem.Name__c + '" is canceled, Please check the detail information as below.',
                                                  '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                                  '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                                  null,
                                                  null,
                                                  'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Owner.email  + '"> ' + stagTemp.Offering_Release_ID__r.Owner.Name + ' </a>',
                                                  '<a href="{base}/'+NewActionItem.Id+'">' + NewActionItem.Name__c + '</a>');
                            }
                        } 
                        
                        Action_Item__c acOld = [select Status__c from Action_Item__c where id =: NewActionItem.id ];
                        
                        if(NewActionItem.Status__c.equals('In Progress') && acOld.Status__c.equals('Complete')&& (stagTemp.Status__c.equals('In Progress') || stagTemp.Status__c.equals('In Review'))){
                            
                            Set<String> userIdSet = new Set<String>();
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Owner.Id)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Owner.Id)); 
                                }       
                            }
                            if(!userIdSet.contains(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c))){
                                if(!UserId.equals(stagTemp.Offering_Release_ID__r.Facilitator__c)){
                                    userIdSet.add(string.valueOf(stagTemp.Offering_Release_ID__r.Facilitator__c)); 
                                }       
                            }
                            
                            Core_team_member__c ownerCTM =[select User__c,User__r.Id from Core_team_member__c where ID =: NewActionItem.Action_Owner__c]; 
                            if(!userIdSet.contains(string.valueOf(ownerCTM.User__r.Id))){
                                if(!UserId.equals(ownerCTM.User__r.Id)){
                                    userIdSet.add(string.valueOf(ownerCTM.User__r.Id)); 
                                }       
                            }
                            for(String userid: userIdSet){                                                            
                                ODP_Class_EmailNotification.SendToPersonForActionItem(userid,
                                                  'The Action Item "' + NewActionItem.Name__c + '" is reopened and is in ‘In Progress’ status.',
                                                  'The Action Item "' + NewActionItem.Name__c + '" is reopened and is in ‘In Progress’ status, Please check the detail information as below.',
                                                  '<a href="{base}/'+stagTemp.Offering_Release_ID__c+'"> ' + stagTemp.Release_Name__c+ '</a>',
                                                  '<a href="{base}/'+stagTemp.id+'"> ' + stagTemp.Stage_Name__c+ '</a>',
                                                  null,
                                                  null,
                                                  'Business Engagement Partner : <a href="mailto:' + stagTemp.Offering_Release_ID__r.Owner.email  + '"> ' + stagTemp.Offering_Release_ID__r.Owner.Name + ' </a>',
                                                  '<a href="{base}/'+NewActionItem.Id+'">' + NewActionItem.Name__c + '</a>');  
                            }    
                            
                        }
                        
                       
                        if(NewActionItem.Status__c.equals('In Progress') && !acOld.Status__c.equals('In Progress') &&(stagTemp.Status__c.equals('Complete') || stagTemp.Status__c.equals('On Hold')|| stagTemp.Status__c.equals('Cancelled')||stagTemp.Status__c.equals('Not Started'))){
                            errorMsg = 'The Action Item could not be set to In Progress When stage status is ‘Complete’ or ‘Hold’ or ‘Cancelled’ or ‘Not Started’.';
                            return null;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The Action Item could not be In Progress When stage status is ‘Complete’ or ‘Hold’ or ‘Cancelled’ or ‘Not Started’.'));
                        }
                                  
                        //when the user attempts to change the status back to ‘In Progress’ from ‘Canceled’, display error          
                        if(NewActionItem.Status__c.equals('In Progress') &&  acOld.Status__c.equals('Canceled')){                    
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The Action Item has been canceled.'));
                            return null;
                        } 
                        
                        update NewActionItem;
                        PageReference pageRef = new PageReference( '/apex/ODP_ReleaseStageApprovalDetail?id=' + relstgID + '&vid=' + StgViewId +'&mode='+ApexPages.currentPage().getParameters().get('mode'));
                        pageRef.setRedirect(true);
                        return pageRef;                
                    } else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only Business Engagement Partner or Facilitator can update Action Item.'));
                        return null;
                    }
                }                              
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, saveflag));
                return null;
            }
        }
        public void findActionItemById(){                   
              try{  
                  myEditStates = 'Update';      
                  string actionItemId = Apexpages.currentPage().getParameters().get('actionItemIdPra');
                  NewActionItem  = [select id,Action_Owner__c,Description__c,Due_Date__c,Name__c,Notes__c,PAC_Requestor__c,Stage_ID__c,Stage_ID__r.Stage_Name__c,Status__c 
                      from Action_Item__c where id =: actionItemId];                       
              }
              catch(exception e){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: action item search exception, please contact the IT Administrator')); 
              }  
        }
        public string errorMsg{get;set;}
        public string delActionItemIdPra{get;set;}
        public void deleteActionItem(){
            try{                   
                  Action_Item__c delActionItem  = [select id,Action_Owner__c,Description__c,Due_Date__c,Name__c,Notes__c,PAC_Requestor__c,Stage_ID__c,Stage_ID__r.Stage_Name__c,Status__c 
                      from Action_Item__c where id =: delActionItemIdPra]; 
                  delete delActionItem; 
                  //get action items
                  actionList = [select id,Name__c,Status__c,Action_Owner__r.User__C from Action_Item__c where Stage_ID__c=:relstg.Id];                         
              }
              catch(exception e){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: action item delete exception, please contact the IT Administrator')); 
              }
        }
        public string mitiAcitonRiskName{get;set;}
        public void findMitiActionsById(){                   
              try{       
                  string mitiactionriskId = Apexpages.currentPage().getParameters().get('MitiActionRiskId');
                  mitigationList = [select Name__c,Owner_Team_Member_ID__r.User__c,Owner_Team_Member_ID__r.User__r.Name,Risk_ID__c,Risk_ID__r.Name__c,Due_Date__c,Status__c from Mitigation_Action__c where Risk_ID__c =: mitiactionriskId ];
                  mitiAcitonRiskName = [SELECT Name__c FROM Risks__c   where id =:mitiactionriskId ].Name__c;                     
              }
              catch(exception e){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: Mitigation Action search exception, please contact the IT Administrator')); 
              }  
        }

}