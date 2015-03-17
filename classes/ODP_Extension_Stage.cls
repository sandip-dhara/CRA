public class ODP_Extension_Stage {
    public Release_Stage__c RelStg{get;set;}
    public String myEditStates{get;set;}
    public Boolean IsReadyForStgBegin{get;set;}
    public Boolean IsReadyForStgRew{get;set;}
    public Boolean IsStartUpStg {get;set;}
    public Boolean IsFacilitator{get;set;}
    public Boolean changeIncludeAbled {get;set;}
    public string UserID{get;set;}
    public List<Release_Stage__c> startupStages{get;set;}
    public string ErrorCategoryBeginStage{get;set;}
    public string ErrorCategorySubmitReview{get;set;}
    public Class StageWorkElementAndRating{
        public Stage_Work_Element__c swe{get;set;}
        public string RatingCalculate{get;set;}
        public string reviewCalculate{get;set;}
        public string ratingColor{get;set;}
        public string documentHTML{get;set;}
    }
    public class  AttachmentAndLink{
        public string docId{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}
        public string lik{get;set;}         
    } 
    public List<StageWorkElementAndRating> sweMaterialsList{get;set;}
    
    public static string ValidateStageName='Validate Requests';
    public boolean IsValidateStage{get;set;}
    public Stage_extend_Validate__c StageValidate{get;set;}
    
    public static string QuantifyStageName='Qualify Requests';
    public boolean IsQuantifyStage{get;set;}
    public Stage_extend_Quantify__c StageQuantify{get;set;}
    
    public String SelectPacGroups{get;set;} 
    public List <SelectOption> PacGroups{
        get{           
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('',''));                    
            for(ODP_PAC__c pc: [select id , Name from ODP_PAC__c order by Name]){
                options.add(new SelectOption(pc.Id,pc.Name));        
            }        
            return options;        
         }        
    }
    
    public ODP_Extension_Stage(ApexPages.StandardController controller) {
        RelStg = (Release_Stage__c )controller.getRecord();
        IsReadyForStgBegin = true;
        IsReadyForStgRew = true;
        IsFacilitator = false;
        UserID = UserInfo.getUserId();

        if(RelStg.Id==null)
        {
            myEditStates = 'Create';
        }
        else
        {
            RelStg = [select id, Actual_End_Date__c,
                        PAC_Decision__c,
                        Current_Baseline_End_Date__c,
                        Duplicate_Release_Stage__c,
                        Include__c,
                        Initial_Baseline_End_Date__c,
                        Meeting_Notes__c,
                        PAC_Name__c,
                        Iteration_Count__c,
                        Predecessor_Release_Stage_ID__c,
                        Predecessor_Release_Stage_Name__c,
                        Stage_ID__c,
                        Stage_Name__c,
                        Offering_Release_ID__c,
                        Release_Name__c,
                        Actual_Start_Date__c,
                        Stage_Contract_Approved__c,
                        Status__c,
                        Tailoring_Justification__c,
                        Offering_Release_ID__r.Status__c,
                        Offering_Release_ID__r.Facilitator__r.Id, 
                        Offering_Release_ID__r.OwnerId,
                        Offering_Release_ID__r.Facilitator__c
                      from Release_Stage__c
                      where Id=:RelStg.Id];
            IsValidateStage = RelStg.Stage_Name__c == ValidateStageName;
            IsQuantifyStage = RelStg.Stage_Name__c == QuantifyStageName;
            SelectPacGroups = RelStg.PAC_Name__c;
            if(IsValidateStage){
                List<Stage_extend_Validate__c> validateStages = [select Key_Driver__c,Direct_Benefits__c,Indirect_Benefits__c from Stage_extend_Validate__c where Release_Stage_ID__c=:RelStg.Id];
                if(validateStages .size() < 1){
                    StageValidate = new Stage_extend_Validate__c();
                    StageValidate.Release_Stage_ID__c=RelStg.Id;
                }
                else{
                    StageValidate = validateStages[0];
                }
            }
            if(IsQuantifyStage ){
                List<Stage_extend_Quantify__c> qualifyStages = [
                        select Date_of_Initial_Cost_Estimate__c,Date_of_Revised_Estimate__c,first_year_recurring_cost__c,Initial_Cost_Estimate__c,IT_Risk__c,New_license_required__c,
                               New_Technology_Required__c,Primary_Asset__c,Product_Strategic_Alignment__c,Revised_Cost_Estimate__c,Risk_Mitigation_Proposal__c,Secondary_Asset__c,
                               skills_needed__c,Special_Skills_Mitigation__c,Special_Skills_Required__c,Release_Stage_ID__c,technology_needed__c
                        from Stage_extend_Quantify__c where Release_Stage_ID__c=:RelStg.Id];
                if(qualifyStages.size() < 1){
                    StageQuantify = new Stage_extend_Quantify__c();
                    StageQuantify.Release_Stage_ID__c=RelStg.Id;
                }
                else{
                    StageQuantify = qualifyStages[0];
                }
            }
            myEditStates = 'Update';
            IsStartUpStg = RelStg.Stage_Name__c.contains('Start-up');
            IsFacilitator = RelStg.Offering_Release_ID__r.Facilitator__c == UserID;
            changeIncludeAbled = RelStg.Offering_Release_ID__r.Facilitator__c == UserID && !IsStartUpStg;
            //Ning Kang:  Do Validations Before Activate Stage
            ErrorCategoryBeginStage = '<b>Notification</b> - In order to begin stage, the following conditions should be validated.</br>';
            //Hunter: the starup stage is complete
            if(!IsStartUpStg)
            {
                startupStages = [select id,Stage_Name__c, Status__c from Release_Stage__c where Stage_Name__c like: '%Start-up%' and Offering_Release_ID__c =: RelStg.Offering_Release_ID__c];
                if(startupStages.size() == 1){
                    if(startupStages[0].Status__c != 'Complete'){
                        IsReadyForStgBegin = false;
                        ErrorCategoryBeginStage += '- You are NOT allowed to start any stage subsequent to Start-up until the Start-up stage Completed.</br>';
                    }
                }
                // If the project is on hold. begin stage is not allowed
                if(RelStg.Offering_Release_ID__r.Status__c == 'On Hold'){
                    IsReadyForStgBegin = false;
                    ErrorCategoryBeginStage += '- You are NOT allowed to start any stage for On Hold Opportunity</br>';                        
                }
                
                //If work element accountable/cont/review role is not assigned team members
                List <Stage_Work_Element__c> sweObjList = [select id, Release_Stage_ID__c, Accountable_Team_Member__c from stage_work_element__c where Release_Stage_ID__c=: RelStg.Id];
                if(sweObjList.size() > 0){
                    for(Stage_Work_Element__c sweobj : sweObjList ){
                        if(sweobj.Accountable_Team_Member__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned accountable roles for work elements</br>'; 
                }
                List <Contributor__c> contList = [select id, Team_Members__c, Stage_Work_Element__r.Release_Stage_ID__c from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__c =: RelStg.Id];
                if(contList.size() > 0){
                    for(Contributor__c ccobj : contList ){
                        if(ccobj.Team_Members__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Contribution roles for work elements</br>'; 
                }
                List <Review__c> rewList = [select id, Team_Member__c,  Stage_Work_Element__r.Release_Stage_ID__c from Review__c where Stage_Work_Element__r.Release_Stage_ID__c =: RelStg.Id];
                if(rewList.size() > 0){
                    for(Review__c rewobj : rewList ){
                        if(rewobj.Team_Member__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Review roles for work elements</br>'; 
                }
            }
            else
            {
                //If work element accountable/cont/review role is not assigned team members
                List <Stage_Work_Element__c> sweObjList = [select id, Release_Stage_ID__c, Accountable_Team_Member__c from stage_work_element__c where Release_Stage_ID__c=: RelStg.Id];
                if(sweObjList.size() > 0){
                    for(Stage_Work_Element__c sweobj : sweObjList ){
                        if(sweobj.Accountable_Team_Member__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned accountable roles for work elements</br>'; 
                }
                List <Contributor__c> contList = [select id, Team_Members__c, Stage_Work_Element__r.Release_Stage_ID__c from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__c =: RelStg.Id];
                if(contList.size() > 0){
                    for(Contributor__c ccobj : contList ){
                        if(ccobj.Team_Members__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Contribution roles for work elements</br>'; 
                }
                List <Review__c> rewList = [select id, Team_Member__c,  Stage_Work_Element__r.Release_Stage_ID__c from Review__c where Stage_Work_Element__r.Release_Stage_ID__c =: RelStg.Id];
                if(rewList.size() > 0){
                    for(Review__c rewobj : rewList ){
                        if(rewobj.Team_Member__c == null){
                            IsReadyForStgBegin = false;
                        }
                    }
                    ErrorCategoryBeginStage += '- You are NOT allowed to start current stage due to unassigned Review roles for work elements</br>'; 
                }
            }
            //Hunter: The user is a PM or Facilitator
            if(UserID != RelStg.Offering_Release_ID__r.OwnerId && UserID != RelStg.Offering_Release_ID__r.Facilitator__c)
            {
                IsReadyForStgBegin = false;
                ErrorCategoryBeginStage += '- Only BEP are allowed to begin stage.</br>';
            }
            //Hunter:Offering release is in Development
            if(!IsStartUpStg)
            {
                if(RelStg.Offering_Release_ID__r.Status__c != 'In Development'){                
                    IsReadyForStgBegin = false;
                    ErrorCategoryBeginStage += '- You are Not allowed to start current stage because opportunity is not approved or on hold.</br>';
                }
                else if(RelStg.Status__c != 'Not Started'){   //Hunter: this stage must be not started              
                    IsReadyForStgBegin = false;
                    ErrorCategoryBeginStage += '- You are Not allowed to start current stage because current stage already started</br>';
                }
                else if(RelStg.Predecessor_Release_Stage_ID__c != null)
                {
                    Release_Stage__c predecessorStage = [select Status__c,Stage_Name__c from Release_Stage__c where Id=:RelStg.Predecessor_Release_Stage_ID__c limit 1];
                    if(predecessorStage.Status__c != 'Complete')
                    {
                         IsReadyForStgBegin = false;
                         ErrorCategoryBeginStage = ErrorCategoryBeginStage  + '- The predecessor stage[' + predecessorStage.Stage_Name__c + '] is not completed, please complete it before begin this stage</br>';
                    }
                }
            }
            else{
                if(RelStg.Offering_Release_ID__r.Status__c != 'Not Started'){                
                    IsReadyForStgBegin = false;
                    ErrorCategoryBeginStage += '- You are Not allowed to start current start up stage because of already started startup stage.</br>';
                }       
                else if(RelStg.Status__c != 'Not Started'){   //Hunter: this stage must be not started              
                    IsReadyForStgBegin = false;
                    ErrorCategoryBeginStage += '- You are Not allowed to start current stage because of already started start up stage.</br>';
                }
            }

            //Hunter: prodecessor stage must be complete

            //Do Validations Before Activate Stage end
            
            //Ning Kang:  Do Validations Before Stage Review
            //1, VF - when the user is a PAC Facilitator and the Offering Release is in ‘Start-Up’ or ‘In Development’ status and Stage is in ‘In Progress’ status and all the constituent Work Elements are in ‘Complete’ status, then provide the option to Submit Stage for Review
            ErrorCategorySubmitReview = '<b>Notification</b> - In order to submit stage review , the following conditions should be validated.</br>';
            if(UserID != RelStg.Offering_Release_ID__r.Facilitator__r.Id && UserID != RelStg.Offering_Release_ID__r.OwnerId){
                IsReadyForStgRew = false;
                ErrorCategorySubmitReview += '- Only BEP are allowed to submit stage to review.</br>';
            }
            if(!IsStartUpStg)
            {
                if(RelStg.Predecessor_Release_Stage_ID__c != null)
                {
                    Release_Stage__c predecessorStage = [select Status__c,Stage_Name__c from Release_Stage__c where Id=:RelStg.Predecessor_Release_Stage_ID__c limit 1];
                    if(predecessorStage.Status__c != 'Complete')
                    {
                         IsReadyForStgRew = false;
                         ErrorCategorySubmitReview = ErrorCategorySubmitReview + '- The predecessor stage[' + predecessorStage.Stage_Name__c + '] is not completed, It must be completed before submit current stage review.</br>';
                    }
                }
            }
            if(IsStartUpStg)
            {
                //if(RelStg.Offering_Release_ID__r.Status__c != 'Start Up')
                //{
                //    IsReadyForStgRew = false;
                //    ErrorCategorySubmitReview += '- You are Not allowed to submit start up stage review because opportunity status is not Start Up.</br>';
                //}
            }
            else
            {
                if(RelStg.Offering_Release_ID__r.Status__c != 'In Development')
                {
                    IsReadyForStgRew = false;
                    ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because opportunity is not approved (In Development) or on hold.</br>';
                }
            }

            List<Stage_Review__c> reviewerList = [Select Id from Stage_Review__c where Release_Stage_ID__c=:RelStg.Id];
            List<Stage_Work_Element__c>  sweList = [select Name__c,id,Status__c,Text__c,Release_Deliverable_ID__r.Stage_Material__c,lastmodifiedDate from Stage_Work_Element__c where Release_Stage_ID__c =: RelStg.Id];
            List <Action_Item__c> AIList = [select id, Stage_ID__c, Name__c, Status__c from Action_Item__c where Stage_ID__c =:RelStg.Id];
                      
            
            if(RelStg.Status__c != 'In Progress'){
                IsReadyForStgRew = false;
                ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because stage is not In Progress.</br>';
            }
            else{
                //Hunter can't use else if brunch, this will cause this condition did not run.
                if(RelStg.PAC_Name__c == null){
                    IsReadyForStgRew = false;
                    ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because None PAC Name Defined.</br>';
                }         
                //Hunter can't use else if brunch, this will cause this condition did not run.   
                if(reviewerList.size() < 1)
                {
                    IsReadyForStgRew = false;
                    ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because none stage review</br>';
                }     
                //Hunter can't use else if brunch, this will cause this condition did not run.
                if(sweList.size() > 0){
                    for(Stage_Work_Element__c sweobj : sweList){
                        if(sweobj.status__c != 'Complete'){
                            IsReadyForStgRew = false;
                            ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because the work element[' + sweobj.Name__c + '] has not been completed yet.</br>';
                        }    
                    }
                }
                //Hunter can't use else if brunch, this will cause this condition did not run.
                if(AIList.size() > 0){
                    for(Action_Item__c AIObj : AIList ){
                        if(AIObj.Status__c == 'In Progress'){
                            IsReadyForStgRew = false;
                            ErrorCategorySubmitReview += '- You are Not allowed to submit the stage to review because the action item[' + AIObj.Name__c + '] has not completed yet.</br>';
                        }
                    }
                }
            }
            //Tovid -  add Stage Materials           
                sweMaterialsList =  new List<StageWorkElementAndRating>();
                Set<Id> sweIdSet = new Set<Id>();
                for(Stage_Work_Element__c sweTemp : sweList){
                     if(!sweIdSet.contains(sweTemp.id)){
                         sweIdSet.add(sweTemp.id);    
                     }   
                }              
                List<Review__c> reviewListSet = [select Rating__c,Complete__c,Stage_Work_Element__c from Review__c  where Stage_Work_Element__c in: sweIdSet ];
                List<Attachment> documentsSet = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid,parentid FROM Attachment WHERE parentid in :sweIdSet  ORDER By Name];
                List<Link__c>    linksSet = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate,Stage_Work_Element_ID__c from Link__c where Stage_Work_Element_ID__c in :sweIdSet];
                Set<Id> userIdSet = new Set<Id>();
                for(Attachment attObjForUser : documentsSet){
                    if(!userIdSet.contains(attObjForUser.CreatedById)){
                        userIdSet.add(attObjForUser.CreatedById);
                    }
                }
                for(Link__c linkObj : linksSet){
                    if(!userIdSet.contains(linkObj.CreatedById)){
                        userIdSet.add(linkObj.CreatedById);
                    }
                }
                List<User> userlist = [select email, Name,id from User where id in : userIdSet ];
                
                Map<Id,User> userIdMap= new Map<Id,User>();
                for(User userObj : userlist){
                    userIdMap.put(userObj.id,userObj);   
                } 
                
                
                for(Stage_Work_Element__c sweTemp : sweList){
                    List<Review__c> reviewList = new List<Review__c>();
                    for(Review__c reviewObj : reviewListSet){
                        if(reviewObj.Stage_Work_Element__c.equals(sweTemp.id)){
                            reviewList.add(reviewObj);    
                        }
                    }
                    Integer reviewFinishCount = 0;
                    Double ratingTotal = 0;
                    Double ratingAverage = 0;
                    for(Review__c review : reviewList){
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
                    sweMaterialsTemp.swe = sweTemp;
                    sweMaterialsTemp.RatingCalculate = String.valueOf(ratingAverage);
                    if(ratingAverage < 2){
                        sweMaterialsTemp.ratingColor = 'red';
                    }else if(ratingAverage < 3 && ratingAverage >=2 ){
                        sweMaterialsTemp.ratingColor = 'yellow';
                    }else{
                        sweMaterialsTemp.ratingColor = 'white';
                    }
                    sweMaterialsTemp.reviewCalculate =  String.valueOf(reviewFinishCount) + ' out of ' + String.valueOf(reviewList.size());                    
                    LIST<AttachmentAndLink> attachmentAndLinkTempList = new LIST<AttachmentAndLink> ();
                    
                    
                    List<Attachment> documents =  new List<Attachment>();
                    for(Attachment attObj : documentsSet){
                        if(attObj.parentid.equals(sweTemp.id)){
                            documents.add(attObj);
                        }
                    }
                    List<Link__c>    links =  new List<Link__c>();
                    for(Link__c linkObj : linksSet){
                        if(linkObj.Stage_Work_Element_ID__c.equals(sweTemp.id)){
                            links.add(linkObj);
                        }
                    }
                    
                    
                    User tempUser = new User();           
                    for(Attachment attTemp : documents ){
                        AttachmentAndLink tempObj = new AttachmentAndLink();
                
                        tempObj.docId= string.valueOf(attTemp.id); 
                        tempObj.name = attTemp.name;
                        tempObj.fileType = 'Document';
                        tempUser = userIdMap.get(attTemp.CreatedById);               
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
                        tempUser = userIdMap.get(attTemp.CreatedById);                
                        tempObj.addBY = tempUser.Name;
                        tempObj.modifyDate = attTemp.lastmodifiedDate.date();
                        tempObj.lik = attTemp.Link__c;               
                        attachmentAndLinkTempList.add(tempObj);                                
                    }                    
                    
                    //Tovid 4.16 - HTML for Stage Materials 
                    string docmaterialsHtml = '<tr id="Rowmaterials' + sweTemp.id+ '" style="display:none"><td style="color:red" colspan="3">';
                    if(attachmentAndLinkTempList.size() > 0){
                        for(AttachmentAndLink attAndLinkTemp : attachmentAndLinkTempList){
                            if(attAndLinkTemp.fileType == 'Document'){
                                docmaterialsHtml = docmaterialsHtml + ' <span>• <a href="/servlet/servlet.FileDownload?file=' + attAndLinkTemp.docId + '" target="_blank">' + attAndLinkTemp.name + '</a></span> &nbsp;&nbsp;<span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';
                            }else if(attAndLinkTemp.fileType == 'Link'){
                                docmaterialsHtml = docmaterialsHtml + ' <span>• <a href="' + attAndLinkTemp.lik  + '" target="_blank">' + attAndLinkTemp.name+ '</a></span> &nbsp;&nbsp;<span class="dmDetail">  ' + attAndLinkTemp.fileType + '</span></br>';                            
                            }
                        }
                    }
                    else{
                        docmaterialsHtml = docmaterialsHtml + ' <span>•No related content!</span></br>'; 
                    }
                    docmaterialsHtml = docmaterialsHtml + '<span>• <a href="javascript:showDocumentsSection(\'rowtextmaterials' + sweTemp.id + '\');"  >text</a></span></br>' ;                      
                    docmaterialsHtml += '</td></tr>'; 
                    if(sweTemp.Release_Deliverable_ID__r.Stage_Material__c == true){
                        sweMaterialsTemp.documentHTML = docmaterialsHtml; 
                        sweMaterialsList.add(sweMaterialsTemp);    
                    }
               }         
        }
    }
    private string saveData(){
        try{
            RelStg.PAC_Name__c = SelectPacGroups;    
            upsert RelStg;
            if(IsValidateStage){
                upsert StageValidate;
            }
            if(IsQuantifyStage){
                upsert StageQuantify;
            }
            return 'success';
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: saving stage exception. Please contact IT administrators if any assistance needed'));
            return 'failed';   
        }                 
    }
    public PageReference Save(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            PageReference STGPage = new PageReference('/'+RelStg.Id);
            STGPage.setRedirect(true);
            return STGPage;
        }
        else
        {
            return null;
        }
    }
    public PageReference BeginStage(){
        try{
            if(IsReadyForStgBegin){
                RelStg.Status__c = 'In Progress';
                update RelStg;
                if(IsStartUpStg){
                    Offering_Release__c orc = [select Id,Status__c from Offering_Release__c where Id=:RelStg.Offering_Release_ID__c];
                    orc.Status__c = 'Start Up';
                    update orc ;
                    PageReference STGPage = new PageReference('/'+RelStg.Offering_Release_ID__c);
                    STGPage.setRedirect(true);
                    return STGPage;
                }
                else{
                    
                    PageReference STGPage = new PageReference('/'+RelStg.Id);
                    STGPage.setRedirect(true);
                    return STGPage;
                }
            }
            else
            {
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Operation Failed: begin stage exception, Please contact IT administrators if any assistance needed'));
            return null;
        } 
    }
    public PageReference StartStageReview(){
        //2, VF - when user submits Stage for Stage Review, --- the system requests confirmation from the user to proceed with the stage review submittal--- system performs the following:1. changes the Stage status from ‘In Progress’ to ‘Under Review’2. ‘locks’ stage data3. sends notifications to PAC members4. notifies PM that their project request for Stage Review was approved.
        try{
            if(IsReadyForStgRew){
                RelStg.Status__c = 'In Review';
                update RelStg;
                PageReference STGPage = new PageReference('/'+RelStg.Id);
                STGPage.setRedirect(true);
                return STGPage;
            }
            else
            {
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'Operation Failed: submit stage review exception. Please contact IT administrators if any assistance needed'));
            return null;
        } 
    }


    
}