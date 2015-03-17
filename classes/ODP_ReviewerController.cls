public class ODP_ReviewerController {

//  Contributor/Reviewer List - Ning Kang
    public List<Contributor__c> ContribList{get;set;}
    public List<Review__c> ReviewList{get;set;}  
    public integer compert{get;set;}
    public Release_Deliverable__c RelDel{get;set;}
    public LIST<Attachment> documents {get;set;}
    public LIST<Link__c> links {get;set;}
    public boolean ReadOnly{get;set;}
    public boolean reviewDueLessTwo{get;set;}
    public class  AttachmentAndLink{
        public string id{get;set;}
        public string name{get;set;}
        public string fileType{get;set;}
        public string addBY{get;set;}
        public Date  modifyDate{get;set;}
        public string lik{get;set;}
    }
    public List<AttachmentAndLink> attachmentAndLinkList{get;set;}
    public boolean IsReviewer {get;set;}
    public boolean IsOwner  {get;set;}
    public boolean IsPM  {get;set;}
    public boolean IsFacilitator  {get;set;}
    public boolean IsUnderReview  {get;set;}

    public Stage_Work_Element__c SWEobj{get;set;}
    public String SWEId{get;set;}
//      End
    //show Contributor/Review table or not - Tovid
    public boolean showContributorTable{get;set;}  
    public boolean showReviewTable{get;set;}
    public boolean showReviewDiv{get;set;}
    
    //Owner only does not see “I’m done”, Rating selection, “Save” button
    public boolean disableDoneRatingSave{get;set;}    
    
    public Review__c review {get;set;}
    public string reviewId {get;set;}
    public string CurrentUserId {get;set;}
    Private Integer cnt_flag;
    Private Integer rev_flag;
    
    public LIST<Review__c> otherReviews {get;set;}
    public LIST<Review__c> otherRev = new LIST<Review__c>();
    public LIST<Review__c> otherRev1 = new LIST<Review__c>();
    public LIST<Contributor__c> contributors {get;set;}
    public LIST<Contributor__c> contrs = new LIST<Contributor__c>();
    public LIST<Contributor__c> contrs1 = new LIST<Contributor__c>();

    public string rating;    
    public string approvalStatus;
    public string reviewDueDay{get;set;}
    public string reviewDue{get;set;} 
    public String Status{get;set;}
    
    public Boolean SaveDoneAbled{get;set;}
    public Boolean CurUserDoneFlag{get;set;}
    public String ErrorSaveDone{get;set;} 
    
    public Boolean CompleteAbled{get;set;}
    public Boolean AllIndependReviewerDone{get;set;}
    public String ErrorComplete{get;set;}
    public String ConfirmMsgComplete{get;set;}
    
    public Boolean ReworkAbled{get;set;}
    public String ErrorRework{get;set;}
    //public boolean reworkOrNot{get;set;}
    public ODP_ReviewerController (ApexPages.StandardController controller) {
        review = (Review__c)controller.getRecord();
        IsUnderReview = false;
        CurrentUserId = UserInfo.getUserId();
        reviewId = controller.getId();
        review = [SELECT Stage_Work_Element__c,
                    Stage_Work_Element__r.Work_Element_Name__c,
                        Stage_Work_Element__r.Stage_Name__c,
                        Stage_Work_Element__r.CreatedBy.Last_First_Name__c ,
                        Stage_Work_Element__r.CreatedBy.id,
                        Stage_Work_Element__r.Status__c,
                        Stage_Work_Element__r.Work_Instructions__c,
                        Stage_Work_Element__r.Help_Description__c,
                        Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,
                        Stage_Work_Element__r.Description_Text_Area__c,
                        Stage_Work_Element__r.Contribute_Due_Date__c,
                        Stage_Work_Element__r.Review_Due_Date__c,
                        Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_Name__c,
                        Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Name__c,
                        Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Group__c,
                        Stage_Work_Element__r.Release_Deliverable_ID__r.Deliverable_ID__r.Description__c,
                        Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.OwnerId,
                        Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c,
                        Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Id,
                        Stage_Work_Element_Name__c,
                        Stage_Work_Element__r.Days_To_Review__c,
                        Stage_Work_Element__r.text__c,
                        Rating__c, 
                        Team_Member_Name__c,
                        Stage_Work_Element__r.Release_Deliverable_ID__r.Review_Criteria__c,
                        Stage_Work_Element__r.Review_Required__c,                        
                        comment__c,
                        Complete__c,
                        Team_Member__r.User__r.Id,
                        Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id,
                        Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email,
                        Stage_Work_Element__r.Accountable_User__c
                        FROM Review__c 
                        WHERE id = :reviewId LIMIT 1];
        showReviewDiv =  review.Stage_Work_Element__r.Review_Required__c;
        IsUnderReview = review.Stage_Work_Element__r.Status__c == 'Under Review';
        Status = review.Stage_Work_Element__r.Status__c;
        SWEId = [select Stage_Work_Element__c from Review__c where id =:reviewId Limit 1].Stage_Work_Element__c;
        ContribList = [select Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c, Team_Members__r.User__r.email, Team_Members__r.User__r.smallphotourl from Contributor__c where Stage_Work_Element__c =: SWEId];
        if(ContribList.size() > 0){
            showContributorTable = true;
        }else{
            showContributorTable = false;
        }        
        ReviewList = [select Complete__c,Comment__c,Rating__c, Team_Member_Name__c,Team_Member__r.User__c,Role_Name__c, Team_Member__r.User__r.Id, Team_Member__r.Independent_Reviewer__c, Team_Member__r.User__r.email, Team_Member__r.User__r.smallphotourl from Review__c where Stage_Work_Element__c =: SWEId];
        SWEobj = [select Status__c from Stage_Work_Element__c where id =:SWEId];
        if(ReviewList.size() > 0){
                showReviewTable = true;
        }else{
                showReviewTable = false;
        }
        SWEobj.Status__c = 'Complete';
        //calculate the review due day 
        if(review.Stage_Work_Element__r.Review_Due_Date__c != null){            
           Date dueDate = review.Stage_Work_Element__r.Review_Due_Date__c;
           Datetime nowTime = datetime.now();
           Date nowDate = nowTime.date();
           reviewDue = string.valueOf(nowDate.daysBetween(dueDate));             
           reviewDueDay = string.valueOf(nowDate.daysBetween(dueDate)) + ' days';
           }
        else{
               reviewDueDay = '';
               reviewDue = '0';                
           }        
        
        //calculate the complete percent for the stage work element
        List<Review__c> reviewWithTMList = [select Complete__c, Rating__c, Team_Member_Name__c,Team_Member__r.User__c,Role_Name__c, Team_Member__r.User__r.Id,Comment__c 
            from Review__c where Stage_Work_Element__c =: SWEId and Team_Member__c != ''];
                
        integer cntcom = 0;
        for(Review__c rc : reviewWithTMList ){
            if(rc.Complete__c){
                cntcom = cntcom + 1;        
            }   
        }
        //compert = 10;
        if(reviewWithTMList.size() > 0){
            compert = integer.valueOf(((double)cntcom/(double)reviewWithTMList.size())*100); 
        }
        else{
            compert = 100;
        }
        
        //Ning Kang - Get the Contributor List loaded - Get the Review List
        //Tovid - WHEN the Work Element Status is ‘Review Complete’ and the Average Quality Score is less than 2.75 or an individual score of 1 exists and user chooses to Rework the Work Element
        
        IsReviewer = false;
        Double ratingSum =  0;
        Double ratingAverage = 0;
        Double reviewCompltedNum = 0;
        CurUserDoneFlag = false;
        AllIndependReviewerDone = true;
        Boolean hasIndependReviewer = false;
        Boolean hasReviewerScroeEqualsOne = false;
        for(Review__c rc : ReviewList){
            if(CurrentUserId.equals(rc.Team_Member__r.User__r.Id)){
                IsReviewer = true; 
                CurUserDoneFlag = review.Complete__c;
            }
            if(rc.Team_Member__r.Independent_Reviewer__c){
                hasIndependReviewer = true;
                if(!rc.Complete__c){
                    AllIndependReviewerDone = false;
                }
            }
//Ning Kang --------Rating == null hunter:move to complete brunch
            /*if(rc.Rating__c != null){
                if(Double.valueOf(rc.Rating__c) <= 1){
                    hasReviewerScroeEqualsOne;
                }
                ratingSum = ratingSum + Double.valueOf(rc.Rating__c);
            }*/
//Ning Kang --------Rating == null
            
            if(rc.Complete__c){
                reviewCompltedNum ++;
                if(Double.valueOf(rc.Rating__c) <= 1){
                    hasReviewerScroeEqualsOne = true;
                }
                ratingSum = ratingSum + Double.valueOf(rc.Rating__c);
            }
        }
        if(hasIndependReviewer == false){
            AllIndependReviewerDone = false;
        }
        if(reviewCompltedNum > 0){
            ratingAverage = ratingSum / reviewCompltedNum;
        }
        
        
        if(CurrentUserId.equals(review.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.Id)){
            IsOwner = true;             
        }
        else{
            IsOwner = false;
        }
        if(CurrentUserId.equals(review.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Id)){
            IsFacilitator  = true;             
        }
        else{
            IsFacilitator  = false;
        }
        if(CurrentUserId.equals(review.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__r.OwnerId)){
            IsPM = true;             
        }
        else{
            IsPM = false;
        }        
        if(IsReviewer == true && IsOwner == true){
            disableDoneRatingSave = false;
        }
        else if(IsOwner == true && IsReviewer == false){
            disableDoneRatingSave = true;
        }
        else if(IsOwner == false && IsReviewer == true){
            disableDoneRatingSave = false;
        }
        else{
            disableDoneRatingSave = true;
        }
        //end
        documents = [SELECT id,CreatedById, name,lastmodifiedDate,ownerid FROM Attachment WHERE parentid = :SWEId ORDER By Name];
        links = [select id, Link__c, CreatedById, Name__c , lastmodifiedDate from Link__c where Stage_Work_Element_ID__c=:SWEId];
        User tempUser = new User(); 
        attachmentAndLinkList = new List<AttachmentAndLink>();           
        for(Attachment attTemp : documents ){
            AttachmentAndLink tempObj = new AttachmentAndLink();
            tempObj.id = attTemp.id; 
            tempObj.name = attTemp.name;
            tempObj.fileType = 'Document';
            tempUser = [select  email, Name from User where id =: attTemp.CreatedById ];               
            //tempObj.addBY = tempUser;
            tempObj.lik = null; 
            tempObj.addBY = tempUser.Name;
            tempObj.modifyDate = attTemp.lastmodifiedDate.date();               
            attachmentAndLinkList.add(tempObj);                               
        }
        for(Link__c attTemp : links ){
            AttachmentAndLink tempObj = new AttachmentAndLink();
            tempObj.id = attTemp.id; 
            tempObj.name = attTemp.Name__c;
            tempObj.fileType = 'Link';
            tempObj.lik = attTemp.Link__c;
            tempUser = [select email, Name from User where id =: attTemp.CreatedById ];               
            tempObj.addBY = tempUser.Name;
            tempObj.modifyDate = attTemp.lastmodifiedDate.date();               
            attachmentAndLinkList.add(tempObj);                                
        } 
        
        otherRev = [SELECT id,name,Team_Member_Name__c,Complete__c,Rating__c FROM Review__c
                        where Stage_Work_Element__c = :review.Stage_Work_Element__c];
        
        for (Review__c rev : otherRev )
        {
                rev_flag = 0;              
                if(rev.Team_Member_Name__c != null){
                    for(Review__c rev1 : otherRev1){
                        if(rev.Team_Member_Name__c == null || rev.Team_Member_Name__c== rev1.Team_Member_Name__c){
                            rev_flag = 1;
                        }
                     }
                    if(rev_flag != 1){
                        otherRev1.add(rev);
                    }
                }
        }
        otherReviews = otherRev1;
        contrs = [select id,Team_Member_Name__c,Completed__c from contributor__c where Stage_Work_Element__c = :review.Stage_Work_Element__c ];
        for (Contributor__c ctr : contrs )
        {
                cnt_flag = 0;
                if(ctr.Team_Member_Name__c != null){              
                    for(Contributor__c c1 : contrs1){
                        if(ctr.Team_Member_Name__c== null || ctr.Team_Member_Name__c== c1.Team_Member_Name__c){
                            cnt_flag = 1;
                        }
                    }
                    if(cnt_flag != 1){
                        contrs1.add(ctr);
                    }
                }
        }
        contributors = contrs1;
        ReadOnly = ApexPages.currentPage().getParameters().get('mode') == 'View';
        //hunter begain button status judge logic
        ErrorSaveDone = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
        ErrorRework = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
        ErrorComplete = '<b>Notification </b>Please make sure the following conditions are validated.<br/>';
        if(IsReviewer)
        {
            SaveDoneAbled = true;
            if(Status!='Under Review'){
                SaveDoneAbled = false;
                ErrorSaveDone += '- Work element is not ready for your quality review.<br/>';
            }
            else if(CurUserDoneFlag){
                SaveDoneAbled = false;
                ErrorSaveDone += '- You have ever reviewed this work element. No action required<br/>';
            }
        }
        
        if(IsOwner || IsFacilitator  || IsPM)
        {
            ReworkAbled = true;
            CompleteAbled = true;
            if(Status!='Under Review' && Status !='Review Complete'){
                ReworkAbled = false;
                ErrorRework += '- You are only allowed to rework this work element when it is Under Review or Review Complete<br/>';
                CompleteAbled = false;
                ErrorComplete += '- You are only allowed to complete this work element when it is Under Review or Review Complete<br/>';
            }
            
            ConfirmMsgComplete = 'Confirm to complete this work element?<br/>';
            if(Status=='Under Review'){
                if(!AllIndependReviewerDone){
                    CompleteAbled = false;
                    ErrorComplete += '- All independent reviewers must complete review.<br/>';
                }
                
                if(review.Stage_Work_Element__r.Review_Due_Date__c == null || review.Stage_Work_Element__r.review_due_date__c <= Date.today()){
                    ErrorComplete += '- Review Due Date must be valid<br/>';
                    CompleteAbled = false;
                }
            }
            
            if(hasReviewerScroeEqualsOne){
                ConfirmMsgComplete += '- Quality review rating of score 1 existed.<br/>';
            }
            if(ratingAverage > 0 && ratingAverage < 2.75){
                ConfirmMsgComplete += '- The average rating scroce is '+String.valueOf(ratingAverage)+'.<br/>';
            }
        }
        //hunter: judge logic end
    }
    
    public List<SelectOption> getStatusItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('pending','Pending'));
        options.add(new SelectOption('Approved','Approved'));
        options.add(new SelectOption('Rejected','Rejected'));
        return options;
    }
    
    public List<SelectOption> getRatingItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('not','Not Rated'));
        options.add(new SelectOption('1','1 - Major re-work required'));
        options.add(new SelectOption('2','2 - Minor re-work required'));
        options.add(new SelectOption('3','3 - Meets stage exit criteria'));
        //options.add(new SelectOption('4','4 - Very Good'));
        //options.add(new SelectOption('5','5 - Perfect'));
        return options;
    }
    public string getRating(){ 
        Decimal r;
        if ( review.rating__c == null ) rating = 'not';
        if ( review.rating__c == '0' ) rating = 'not';
        if ( review.rating__c == '1' ) rating = '1';
        if ( review.rating__c == '2' ) rating = '2';
        if ( review.rating__c == '3' ) rating = '3';
        // if ( review.rating__c == '4' ) rating = '4';
        // if ( review.rating__c == '5' ) rating = '5';
        return rating;
    }
    public void setRating(string rating){
        Decimal r;
        if ( rating == 'not' ) r = 0;
        if ( rating == '1' ) r = 1;
        if ( rating == '2' ) r = 2;
        if ( rating == '3' ) r = 3;
        //if ( rating == '4' ) r = 4;
        //if ( rating == '5' ) r = 5;
        review.rating__c = '3'; //r.toPlainString();
    }
    
    public PageReference save(){
        /*WHEN Work Element Reviewer marks ‘I’m Done’ and the Rating is not 1 or 2 or 3 , 
        THEN the system displays an error message indicating that to mark ‘I’m Done’ a valid review has to be entered  -- Tovid
        */
        review.rating__c = '3'; 
        if(review.Complete__c == true && review.rating__c == '0'){
            review.Complete__c = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'To mark ‘I’m Done’, a valid review rating need to to be provided'));
            return null;
        }
        /*
        WHEN Work Element Reviewer marks ‘I’m Done’, the Rating is 1 or 2 and the Comments field is empty,
         THEN the system displays an error message indicating that to mark ‘I’m Done’ with a review of 1 or 2, Review Comments are mandatory -- Tovid
        */
        else if(review.Complete__c == true && (review.rating__c == '1'||review.rating__c == '2')&&review.Comment__c.length()==0 ){
            review.Complete__c = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'To mark ‘I’m Done’ with a review of 1 or 2, Review Comments is mandatory'));
            return null;
        }
        else{
            update review;
            
            // determine if all the reviewers complete their review           
            PageReference pageRef = new PageReference( '/apex/ODP_ReviewerPage?id=' + reviewId + '&mode=' + ApexPages.currentPage().getParameters().get('mode') );
            pageRef.setRedirect(true); 
            return pageRef;
        }
    }

    Public PageReference OwnerSubmitStgRew(){
        update SWEobj;
        PageReference pageRef = new PageReference( '/apex/ODP_ReviewerPage?id=' + reviewId + '&mode=' + ApexPages.currentPage().getParameters().get('mode'));
        pageRef.setRedirect(true); 
        return pageRef;
    }
    
    public PageReference rework(){
        try{
            //string SWEId = [select Stage_Work_Element__c from Review__c where id =:reviewId Limit 1].Stage_Work_Element__c;
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
            List<Review__c>  ReviewerTempList = [select id,Complete__c,Comment__c from Review__c where Stage_Work_Element__c =: SWEId];
            for(Review__c rewTemp : ReviewerTempList ){
                rewTemp.Complete__c = false;
                rewTemp.Rating__c = '0'; 
                rewTemp.Comment__c = '';
                update rewTemp ;
            }
            
            //send email to inform the reviewer and contributor
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
            
            List<Review__c> reviewers = [
              select Complete__c,Team_Member__r.User__c
                from Review__c
                where Stage_Work_Element__c=:SWEId
            ];
            
/*            
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
                              'Business Engagement Partner : <a href="mailto:' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email  + '">  ' + swe.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name + ' </a>');
                    informToSet.add(reviewer.Team_Member__r.User__c);
                }
            }//
            //send email to inform the reviewer and contributor end
*/            
            PageReference pageRef = new PageReference( '/apex/ODP_ReviewerPage?id=' + reviewId + '&mode=' + ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: rework exception, Please contact IT Administrator if assistance needed'));
            return null;
        }
    }
    public PageReference complete(){
        try{
            //string SWEId = [select Stage_Work_Element__c from Review__c where id =:reviewId Limit 1].Stage_Work_Element__c;
            Stage_Work_Element__c swe = [select id ,Status__c from Stage_Work_Element__c where id =: SWEId];
            swe.Status__c = 'Complete';
            update swe;
            List<Contributor__c>  ContribTempList = [select id,Completed__c, Team_member_name__c,Team_Members__r.User__c,Role_Name__c from Contributor__c where Stage_Work_Element__c =: SWEId];
            for(Contributor__c contribTemp : ContribTempList){
                contribTemp.Completed__c = true; 
                update contribTemp;
            }
            PageReference pageRef = new PageReference( '/apex/ODP_ReviewerPage?id=' + reviewId + '&mode=' + ApexPages.currentPage().getParameters().get('mode'));
            pageRef.setRedirect(true); 
            return pageRef;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: submit complete exception, Please contact IT Administrator if assistance needed'));
            return null;
        }
    }
    public Review__c  reviewerDetail{get;set;}
    public void findReviewerById(){
          try{
              reviewerDetail = new Review__c ();           
              string reviewerPra = Apexpages.currentPage().getParameters().get('reviewerIdPra');
              reviewerDetail= [select id,Team_Member_Name__c,Complete__c,Comment__c,Rating__c,Role_Name__c from Review__c where id =: reviewerPra];      
          }
          catch(exception e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: search reviewer exception, Please contact IT Administrator if assistance needed')); 
          }  
    }
}