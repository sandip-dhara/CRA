global class AthenaLearningBoardDtlsrichtextareaview 
{
 public string LearningBoardId {get;set;}
    public string ChatterLike {get;set;}
    public string ChatterImprovement {get;set;}
    public string ChatterTags  {get;set;}
    public string ChatterComment {get;set;}
    public string TopicId {get;set;}
    Public String strSearchValue{get;set;}
    public integer FollowersCount {get;set;}
    public string LBOwnerId {get;set;} 
    public string loggedInUserId {get;set;}
    public string FeedButtonPath {get;set;}
    public static string ImageStaticPath {get;set;}
    public boolean DescriptionLimit;
    public boolean isloggedUser {get;set;}

    public string HeaderShareEmail { get; set;}
    public string ShareHeaderBoardId { get; set;}
    public string ShareTopicId { get; set;}
    public User UserDetails {get;set;}
    public User UserOwnerDetails { get; set; }

    //Rating
    public integer UserRating { get; set;}
    public decimal UserBoardRating { get; set; }
    public string BoardRatersCount { get; set; }
    public string userRatingComment { get; set; }

    public List<UserRatingHistory> lstRatingHistory { get; set; }
    
    public integer UserTopicRating { get; set; }
    public string userTopicRatingComment { get; set;}

    public string LearningBoardTopicID { get; set;}
    public boolean IsOwnerOrContributor { get; set; }   


    global  class  TopicUserDtls
    {
        public string TopicUserId { get; set; }
        public string TopicUserName { get; set; }
        public string TopicUserPhotoUrl { get; set; }
    }

    global class UserRatingHistory
    {
        public string UserHistoryId { get; set; }
        public string UserHistoryName { get; set; }
        public string UserHistoryPhotoUrl { get; set; }
        public decimal UserHistoryRating { get; set; }
        public string UserHistoryComment { get; set; }
        public DateTime UserHistoryDateTime { get; set; }
        public string UserDate { get; set;}
    }

    public static void FetchStaticPathImage()
    {
        ImageStaticPath = 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
    }

   Public String getStaticImagePath
   {
     get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
    }

    public void ShareLearningBoard()
    {
        Learning_Board__c learningBoard = [SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c, Short_Description__c, Sub_Title__c, Default_Image_Name__c, Learning_Board_Template_ID__c , Owner.id, Owner.name, Owner.email FROM Learning_Board__c where id =:ShareHeaderBoardId limit 1];
        User usr=[Select Name,email from User where id =:UserInfo.getUserId()];

        List<User> Shareusr=[Select Name,email from User where email =:HeaderShareEmail Limit 1];

        boolean isBoardOwner = AthenaUtility.NotifyMyStatus(AthenaUtility.ShareBoardEvent, learningBoard.Owner.id);
        
        system.debug('ShareLearningBoard'+ isBoardOwner);
        system.debug('ShareLearningBoard Owner'+ learningBoard.Owner.email);

        string ShareUserName='';
        if(Shareusr.size() == 0)
        {
            ShareUserName='';
        }
        else
        {
            ShareUserName=Shareusr[0].Name;
        }

        Messaging.SingleEmailMessage mail;  
        string bodyString = '';
        string[] toAddresses;
        mail = new Messaging.SingleEmailMessage();
        toAddresses = new String[] { HeaderShareEmail };
        mail.setToAddresses(toAddresses); 
        mail.setUseSignature(false);      
        mail.setSubject(usr.Name + ' thought you might be interested be in the '+ learningBoard.Name__c + ' board.'); 
        
        if (isBoardOwner)
        {
            mail.setCCAddresses( new String[]{ learningBoard.Owner.email });    
        }
        
        string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
        string[] subjectArguments1 = new String[] { getSfInstance, ShareHeaderBoardId};
        string formatURL1 = String.format(stringURL1, subjectArguments1);
        
        bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
        bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
        bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+ShareUserName+',&nbsp;</span></span></p>';
        bodyString += '<p> <p><span style="font-size:16px;">I found an interesting Learning Board on ES Social learning Platform. You should take a look.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Board Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ learningBoard.Name__c +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Board Description</td><td style="';
        bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ learningBoard.Description__c +'</td>';
        bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Board Owner</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ learningBoard.Owner.name +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the learning board. </span></p>';
        bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
        bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        bodyString += '</body></html>';

        mail.setHtmlBody(bodyString);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

    public void ShareTopicLearningBoard()
    {

        Learning__c learningObj = [SELECT Id, Name__c, Description__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Doc_Id__c, Owner.name, Owner.id,owner.email, Practice_Approved__c FROM Learning__c where id =:ShareTopicId limit 1];

        User usr = [Select Name,email from User where id =:UserInfo.getUserId()];

        List<User> Shareusr=[Select Name,email from User where email =:HeaderShareEmail];

        boolean isTopicOwner = AthenaUtility.NotifyMyStatus(AthenaUtility.ShareTopicEvent, learningObj.Owner.id);

        system.debug('ShareTopicLearningBoard:' + isTopicOwner);
        system.debug('ShareTopicLearningBoard Owner Id:' + learningObj.Owner.id);

        string ShareUserName='';
        if(Shareusr.size()==0)
        {
            ShareUserName='';
        }
        else
        {
            ShareUserName=Shareusr[0].Name;
        }
        
        Messaging.SingleEmailMessage mail;  
        string bodyString = '';
        string[] toAddresses;
        mail = new Messaging.SingleEmailMessage();
        toAddresses = new String[] { HeaderShareEmail };
        mail.setToAddresses(toAddresses);       
        mail.setUseSignature(false);
        mail.setSubject(usr.Name + ' thought you might be interested be in the '+ learningObj.Name__c + ' topic.'); 
        
        if (isTopicOwner)
        {
            mail.setCCAddresses( new String[]{ learningObj.Owner.email }); 
        }
        
        string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}&topicid={2}';
        string[] subjectArguments1 = new String[] { getSfInstance, LearningBoardId, ShareTopicId};
        string formatURL1 = String.format(stringURL1, subjectArguments1);
        
        bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
        bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
        bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody><tr><td><p><span style="font-size:16px;"><span>Hi '+ ShareUserName +',&nbsp;</span></span></p>';
        bodyString += '<p> <p><span style="font-size:16px;">I found an interesting Topic on ES Social learning Platform. You should take a look.</span></p><table style="border:1px solid black;"><tr><td style="background-color:#a9a9a9; padding-left:10px;';
        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal; border:1px solid black;">Topic Name</td><td style="border:1px solid black; color:black; font-family:Trebuchet MS; font-weight:normal;">'+ learningObj.Name__c +' </td></tr><tr><td style="background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap; border:1px solid black;">Topic Description</td><td style="';
        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal; border:1px solid black;">'+ learningObj.Description__c +'</td>';
        bodyString +=  '</tr><tr><td style="background-color:#a9a9a9; border:1px solid black; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Topic Owner</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal; border:1px solid black;">'+ learningObj.Owner.name +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the learning board. </span></p>';
        bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
        bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        bodyString += '</body></html>';

        mail.setHtmlBody(bodyString);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }

     public AthenaLearningBoardDtlsrichtextareaview()
     {
         this.LearningBoardId = ApexPages.currentPage().getParameters().get('id');
         this.TopicId=ApexPages.currentPage().getParameters().get('TopicId');
         RelatedLearningBoards = new list<RelatedLearningBoardCustomClass>();
         lstRatingHistory = new list<UserRatingHistory>();
         User u = getLearningBoardOwnerDtls();
         UserOwnerDetails = getLearningBoardOwnerDtls();
         LBOwnerId = u.id;
         loggedInUserId = UserInfo.getUserId();
         FeedButtonPath = getStaticImagePath+ 'contact_tab.png';
         system.debug('FeedButtonPath:'+FeedButtonPath);
         
        //Get average Rating of user 
        GetAverageRating();
        
        CheckIfLoggedInUserAndOwner();

        UserDetails = GetLoggedinUserDtls();

         if (loggedInUserId == LBOwnerId)
            isloggedUser = true;
         else
            isloggedUser = false;

     }

      public List<string> LBAssociatedTags
      {
        get
        {
            List<string> str = AthenaUtility.getAssociatedTags(AthenaUtility.LearningBoard, this.LearningBoardId);
            
            if (str.size() == 0)
                str.add('No Tags Associated');   

            return str;
        }
      }

  Public boolean IsBoardEditor{
        get{
            AthenaUserAccess usrAccs=new AthenaUserAccess();
            if(usrAccs.IsModerator(UserInfo.getUserId())){
                return true;
            }
            else if(usrAccs.IsProducer(UserInfo.getUserId())){
                system.debug('this.LearningBoardsid'+this.LearningBoardId );
                 learning_board__c lb=[select ownerid from learning_board__c where id = :this.LearningBoardId ];    
                 if(lb.Ownerid==UserInfo.getUserId()){
                     return true;
                 }
else
{
   List<Learning_Board__Share> lstContr = [SELECT ParentId FROM Learning_Board__Share where parentId=:this.LearningBoardId  and AccessLevel='Edit' and UserOrGroupId=:UserInfo.getUserId()];
   If(lstContr.size()>0)
   {
  return true;
   }                                   
 }
                 return false;  
            }
            else{return false;}
 
            }
        }

     Public User getLearningBoardOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl,u.Name, u.FullPhotoUrl,u.AboutMe, u.Email  From User u where u.id in 
        (select ownerid from learning_board__c where id = :LearningBoardId) ];
        return U;
    }
 
       public PageReference  NavigateToGlobalSearch()
      {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
      }

        Public List<User> GetFollowers()
        {
            List<User> FollowersUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (select SubscriberID from EntitySubscription where ParentId =:LearningBoardId)];
            return  FollowersUsers;
        }
    

        Public boolean isFollowUn { get; set; } 
        Public string recoruserid{get;set;} 
        Public string userid{get;set;} 
        List<User> followers = new List<User>(); 

        Public boolean IsFollowOwner
        {
            get 
            {
                List<EntitySubscription> entsub=[select SubscriberID from EntitySubscription where ParentId =:LBOwnerId and SubscriberID =:loggedInUserId];         
                //List<User> Followers = [SELECT Id, Name,FullPhotoUrl, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:LBOwnerId AND SubscriberId !=:loggedInUserId) ]; 

                if(entsub.size() >0 ) 
                    return true;
                else
                    return false;
            }
        }

        Public boolean IsFollowBoard
        {
            get 
            {
                List<EntitySubscription> entsub=[select SubscriberID from EntitySubscription where ParentId =:LearningBoardId and SubscriberID =:loggedInUserId];           
                //List<User> Followers = [SELECT Id, Name,FullPhotoUrl, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:LBOwnerId AND SubscriberId !=:loggedInUserId) ]; 

                if(entsub.size() > 0 ) 
                    return true;
                else
                    return false;
            }
        }       

        public void followBoard() 
        { 
           if(!IsFollowBoard)
           {
                EntitySubscription follow = new EntitySubscription (); 
                follow.parentId = LearningBoardId;
                follow.subscriberid = loggedInUserId;
                insert follow; 
           }            
        } 

        public void unfollowBoard() 
        { 
            EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : LearningBoardId AND SubscriberId = :loggedInUserId Limit 1]; 
            Delete subscription; 
        }

        public void followOwner() 
        { 
           if(!IsFollowOwner)
           {
                EntitySubscription follow = new EntitySubscription (); 
                follow.parentId = LBOwnerId;
                follow.subscriberid = loggedInUserId;
                insert follow; 
           }            
        } 
        
        public void unfollowOwner() 
        { 
            EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : LBOwnerId AND SubscriberId = :loggedInUserId Limit 1]; 
            Delete subscription; 
        }

        Public boolean IsLearningBoardCreator
        { 
            get
           { 
                AthenaUserAccess usrAccs=new AthenaUserAccess(); 
                if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                    return true; 
                else
                    return false;
           } 
        }

       Public User GetLoggedinUserDtls()
       {
            User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
            return U;
       }

       Public String getSfInstance
       {
            get
            {
                return ApexPages.currentPage().getHeaders().get('Host');
            }
       }

 Public class RelatedLearningBoardCustomClass{
        public id AttachmentId{get;set;}
        public string LBSubTitle {get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
        public String DefaultImageName{get;set;}
        public String LBShortDescription{get;set;}  

    }
     private String GetInstanceResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       }

 
 Public RelatedLearningBoardCustomClass LearningBoardDtls{
        get {
    
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :LearningBoardId];
        
        List<Learning_Board__c>  lrngbrds= [select id, Sub_Title__c, Name__c,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c,
        CreatedDate from Learning_Board__c where ID =:LearningBoardId ];
        //Is_Active__c = True and                            
         
        for(Learning_Board__c lb: lrngbrds){
            RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
        
            lbCustom.LBName = lb.Name__c;
            
                        if(lb.Name__c != null)
            {
               if(lb.Name__c.length() > 75)
                 {                            
                    lbCustom.LBName = lb.Name__c.substring(0, 75) + '...';
                 }
                 else
                 {
                    lbCustom.LBName = lb.Name__c;
                 }
            } 
            lbCustom.LBSubTitle=lb.Sub_Title__c;
            lbCustom.LBDescription=lb.description__c;           
            lbCustom.LbId = lb.Id;            
            lbCustom.StaticImage = true;
            
            if(lbCustom.LBDescription != null)
            {
                if(lbCustom.LBDescription.length() > 700)
                {
                    lbCustom.LBShortDescription = lbCustom.LBDescription.substring(0, 700) + '...';
                    DescriptionLimit = true;
                }
                else
                {
                    lbCustom.LBShortDescription=lbCustom.LBDescription;
                    DescriptionLimit = false;
                }
            }

             if(lb.Default_Image_Name__c!=''){                        
                lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetInstanceResourceURL('img_athena')+ '/img_athena/' + lb.Default_Image_Name__c;          
            }
            
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;                
                    lbCustom.StaticImage = false;
                }  
            }
            LearningBoardDtls=lbCustom;
        }                
        return LearningBoardDtls;                
    }   
    set;    
    }

    public boolean IsReadMore
    {
        get
        {
            return DescriptionLimit;
        }
    }
 
 
   Public  class LearningDtlsCustomClass{
        public string TopicOwnerId {get;set;}
        public string OwnerPhoto {get;set;}
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public String LShortDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public boolean StaticImage{get;set;}   
        public integer LikeCount{get;set;}   
        public boolean LikedOrNot{get;set;}  
        public boolean DocLnkXst{get;set;}
        public boolean IsActive{get;set;}  
        public List<string> Tags{get;set;}   
        public string DefaultImageName{get;set;}  
        public boolean ClientFacing{get;set;}     
        public string hpsharedIcon {get;set;}       
        public string fileURLUpload  {get;set;}
        public string filePDFUpload {get;set;} 
        public string filePPTUpload {get;set;} 
        public string fileWordUpload {get;set;} 
        public string fileExcelUpload { get; set; }
        public string fileTextUpload { get; set; }
        public string HPCertification {get;set;} 
        public string Subject {get; set;}
        public string topicURL {get; set;}
        public string Body {get;set;}
        public boolean PracticeApproved {get; set;}
        public Decimal AvgRating {get;set;}
        public string RatersCount {get;set;}
        public boolean BtnshowHideEdit { get; set; }
    } 
    
    global  Class LrngDtlsWithCategory{
       public string CategoryId{get;set;}  
       public string CategoryName{get;set;}  
       public List<LearningDtlsCustomClass> lstlrngs{get;set;}  
    }
    
     @RemoteAction
    global static List<LrngDtlsWithCategory> getLrngWithCat(string LrngBrdId)
    {
        //a6tZ00000008RI0IAM
        List<LrngDtlsWithCategory> lsWithCat=new List<LrngDtlsWithCategory>();
        Learning_Board__c  lngBoard= [SELECT Id, Name__c, Is_Active__c, Featured__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: LrngBrdId];
        system.debug('Learninglb:'+lngBoard.Learning_Board_Template_ID__c);
        string strLBTemplate=lngBoard.Learning_Board_Template_ID__c;
        if(strLBTemplate==null)
        {
             //If Learning Board Doesn't have Template
                List<Learning_category__c> lrngCatlst= [select Name__c,id from Learning_category__c order by Display_Sequence_Nbr__C];
                
                for(Learning_category__c lcc :lrngCatlst)
                {
                   LrngDtlsWithCategory dtlsWithCat=new LrngDtlsWithCategory();
                   dtlsWithCat.CategoryId=lcc.id;
                   dtlsWithCat.CategoryName=lcc.Name__c;
                   lsWithCat.add(dtlsWithCat);
                }
                
        }
        else
        {
        List<Required_Learning_Category__c> lstRequiredLCat =[SELECT Learning_Category_Id__c, Id, Name, Is_Active__c, Learning_Board_Template_ID__c,Learning_Category_Id__r.Name__C FROM Required_Learning_Category__c where Learning_Board_Template_ID__c =:strLBTemplate];
            for(Required_Learning_Category__c RqrdL :lstRequiredLCat)
                {
                   LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();
                   dtlsWithCats.CategoryId=RqrdL.Learning_Category_Id__c;
                   dtlsWithCats.CategoryName=RqrdL.Learning_Category_Id__r.Name__C;
                   lsWithCat.add(dtlsWithCats);
                }
        }
        
        
        //If Learning Board have Template
            List<LrngDtlsWithCategory> lstLearningBrdCat=GenerateLearningCtgry(lsWithCat,LrngBrdId);
            system.debug('lstLearningBrdCat:'+lstLearningBrdCat.size());
            return lstLearningBrdCat;
        
        
    }
    
       private static String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       } 

   public static List<LrngDtlsWithCategory> GenerateLearningCtgry(List<LrngDtlsWithCategory> LrngDetails, string LrngBoardId)
   {
   
        string FileURLUpload= 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
        string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
        string  filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
        string filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
        string fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';
        string fileExcelUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileExcelUpload.png';
        string fileTextUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileTextUpload.png';
        string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
        string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';
    
        list<id> lstLearningIds= new list<id>();
        List<LrngDtlsWithCategory> lstContainer=new List<LrngDtlsWithCategory>();
        List<Learning_Board_Learning__c> lstBoardLearning=[select Learning_ID__c,Learning_ID__r.Name__c,
            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.Default_Image_Name__c ,Learning_ID__r.ClientFacing__c,Learning_ID__r.Practice_Approved__c,Learning_ID__r.Is_Active__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name,Learning_ID__r.Owner.id, Learning_Category_Id__c
            from Learning_Board_Learning__c where 
            Learning_Board_ID__c =:LrngBoardId  order by Display_Sequence_Nbr__c asc];
        
        system.debug('lstContainer:'+lstContainer.size());
        
        for (Learning_Board_Learning__c l:lstBoardLearning ) {
                lstLearningIds.add(l.Learning_ID__c);
            }
            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds];

        // Topic Owner Code - Start

        List<User> lstTopicUsers=[Select id,Name,SmallPhotourl from user where id in (Select ownerid from learning__c where id in : lstLearningIds)];
        Map<id,TopicUserDtls> MapUserDetails =new Map<id,TopicUserDtls>();

        for( User userDtls :lstTopicUsers)
        {
          if(!MapUserDetails.containskey(userDtls.id))
                {
        
                TopicUserDtls topicUserDetails=new TopicUserDtls();
                topicUserDetails.TopicUserId=userDtls.id;
                topicUserDetails.TopicUserName=userDtls.Name;
                topicUserDetails.TopicUserPhotoUrl=userDtls.SmallPhotourl;        
                MapUserDetails.put(userDtls.id,topicUserDetails);
                }
        }

        // Topic Owner Code - End

        //Before Loop
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id,Nbr_of_Users_Rated__c  FROM Rated_Item__c where Item_Identifier__c in :lstLearningIds];
        map<id,string> RatedItemMap = new map<id,string>();        

        for (Rated_Item__c rtdItm :RatedItemLst) {
                        string AvgRatingAndCnt;
                        AvgRatingAndCnt=rtdItm.Rating_Average__c + ',' + rtdItm.Nbr_of_Users_Rated__c;
                        RatedItemMap.put(rtdItm.Item_identifier__C,AvgRatingAndCnt);  
        }

                // Suman Topic Rating Enable or Disable - Start

        List<Learning_Board__Share> lstlbshare=[SELECT UserOrGroupId FROM Learning_Board__Share where parentId=:LrngBoardId];
        Map<string,boolean> mapBrdOwner=new Map<string,boolean>();
        for(Learning_Board__Share lbshare:lstlbshare)
        {
             mapBrdOwner.put(lbshare.UserOrGroupId,true);
        }

        List<Learning__Share> lstlrngShare=[SELECT UserOrGroupId,parentId FROM Learning__Share where parentId IN (Select learning_Id__c from learning_Board_learning__c where learning_Board_Id__c=:LrngBoardId) and AccessLevel='All'];
        Map<string,boolean> mapLrngEdit=new Map<string,boolean>();

        for(Learning__Share lrngShare:lstlrngShare)
        {
            if(mapBrdOwner.containskey(lrngShare.UserOrGroupId))
            {
                mapLrngEdit.put(lrngShare.parentId,true);
            }
            else
            {
                mapLrngEdit.put(lrngShare.parentId,false);
            }
        }
                // Suman Topic Rating Enable or Disable - End
        
        for(LrngDtlsWithCategory LCL:LrngDetails)
        {
                LrngDtlsWithCategory lngCat=new LrngDtlsWithCategory();
                lngCat.CategoryId=LCL.CategoryId;
                lngCat.CategoryName=LCL.CategoryName;
                lngCat.lstlrngs=new List<LearningDtlsCustomClass>();
            
                for(Learning_Board_Learning__c learningB:lstBoardLearning)
                {
                    if(learningB.Learning_Category_Id__c==LCL.CategoryId)
                    {
                        LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                        lrng.LName=learningB.Learning_ID__r.Name__c;
                        lrng.LDescription = learningB.Learning_ID__r.Description__c;
                        
                        if(lrng.LDescription.length()>500){
                    
                            lrng.LShortDescription = lrng.LDescription.substring(0,500) + '...';
                        }
                        else{
                            lrng.LShortDescription=lrng.LDescription;
                        }

                        lrng.LOwnerName = learningB.Learning_ID__r.Owner.name; 
                        lrng.LType= learningB.Learning_ID__r.type__c;   
                        lrng.LURL= learningB.Learning_ID__r.URL__C; 
                        lrng.fileURLUpload=FileURLUpload;
                        lrng.hpsharedIcon=hpsharedIcon;

                        lrng.filePDFUpload=filePDFUpload;
                        lrng.filePPTUpload=filePPTUpload;
                        lrng.fileWordUpload=fileWordUpload;
                        lrng.fileExcelUpload=fileExcelUpload;
                        lrng.fileTextUpload=fileTextUpload;

                        lrng.HPCertification=HPCertification;

                        lrng.LId = learningB.Learning_ID__c;
                        lrng.ClientFacing=learningB.Learning_ID__r.ClientFacing__c;
                        lrng.PracticeApproved = learningB.Learning_ID__r.Practice_Approved__c;                       
                        lrng.TopicOwnerId = learningB.Learning_ID__r.Owner.id;            

                        lrng.DocLnkXst=false; 
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        List<string> strlst = AthenaUtility.getAssociatedTags(AthenaUtility.Learning,learningB.Learning_ID__r.id);
                        
                        if(strlst.size() == 0)
                              strlst.add('No Tags Associated');        
                        
                        integer strSize = strlst.size();
                    
                        lrng.Tags = strlst;    
                        
                        if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                              lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                              lrng.LURL=lrng.LURL.replace('http:', 'https:');
                        }
                        else if(lrng.LType=='Video' && lrng.LURL.contains('www.brainshark.com')){
                              lrng.LURL=lrng.LURL+'&dm=5&pause=1&nrs=1';
                              
                        }
                        
                If(RatedItemMap.containskey(learningB.Learning_ID__r.id))
                {
                                string ratingAvgCount=RatedItemMap.get(learningB.Learning_ID__r.id);
                                list<string> lstrtngAvg =  ratingAvgCount.split(',');
                                String myNumber = lstrtngAvg[0];
                                String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+2);
                                Decimal AvgRtng = Decimal.valueOf(myTruncatedNumber);
                                lrng.AvgRating=AvgRtng;
                                lrng.RatersCount=lstrtngAvg[1];                               
                }
                else
                {
                                lrng.AvgRating=0;
                                lrng.RatersCount= '0';
                }


                // Topic Owner Code - Start

                if(MapUserDetails.containskey(learningB.Learning_ID__r.Owner.Id))
                {
                            TopicUserDtls topicUserDetails=new TopicUserDtls();
                            topicUserDetails=MapUserDetails.get(learningB.Learning_ID__r.Owner.Id);
                            
                            lrng.TopicOwnerId=topicUserDetails.TopicUserId;
                            lrng.LOwnerName=topicUserDetails.TopicUserName;
                            lrng.OwnerPhoto=topicUserDetails.TopicUserPhotoUrl;
                 }

                // Topic Owner Code - End

                // Suman Topic Rating Enable or Disable - Start
                system.debug('Test Suman Topic:');
                boolean IsmapLrngEdit = mapLrngEdit.get(learningB.Learning_ID__r.id);

                system.debug('IsmapLrngEdit:' + IsmapLrngEdit);
                if(IsmapLrngEdit)
                {
                    system.debug('check  Topic Rating Enable or Disable' + IsmapLrngEdit);
                    lrng.BtnshowHideEdit = true;
                }
                else
                {
                    // If logged in user and Topic owner are the same - Rating should be disabled
                    // Else Rating should be enabled 
                    if (lrng.TopicOwnerId == UserInfo.getUserId())
                    {
                        system.debug('TopicOwnerId == UserInfo.getUserId()' + IsmapLrngEdit);
                        lrng.BtnshowHideEdit = true;
                    }
                    else
                    {
                        system.debug('TopicOwnerId != UserInfo.getUserId()' + IsmapLrngEdit);
                        lrng.BtnshowHideEdit = false;
                    }
                }

                        
                        //lrng.LType=='Link Or Document' &&
                        if( lrng.LURL!=null)
                        {   
                            lrng.DocLnkXst=true;
                            if(lrng.LURL.contains('.pdf'))
                            {
                              lrng.DocType='PDF';
                            }
                            else if(lrng.LURL.contains('.ppt'))
                            {
                              lrng.DocType='PPT';
                            }                    
                            else if(lrng.LURL.contains('.doc'))
                            {
                              lrng.DocType='DOC';
                            }
                            else if(lrng.LURL.contains('.xls'))
                            {
                              lrng.DocType='XLS';
                            }
                            else if(lrng.LURL.contains('.txt'))
                            {
                              lrng.DocType='TXT';
                            }
                            else
                            {
                              lrng.DocType='OTHER';
                            }
                        }
                        lrng.StaticImage=true;
                     
                        if(learningB.Learning_ID__r.type__c!='Video')
                        {        
                            for(Attachment a: Att)
                            { 
                                if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg' || a.ContentType == 'image/gif') )
                                {
                                    lrng.AttachmentId = a.Id;
                                    lrng.StaticImage=false;
                                }                 
                            }
                        } 
                        else
                        {
                            lrng.StaticImage=false;
                        }
                        
                        if(learningB.Learning_ID__r.Default_Image_Name__c!='')
                        {                        
                                lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + learningB.Learning_ID__r.Default_Image_Name__c;
                                //lrng.DefaultImageName='';
                        }
                        if(!lrng.StaticImage)
                        {
                            lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +'/servlet/servlet.FileDownload?file='+lrng.AttachmentId;
                        }

                        

                        lngCat.lstlrngs.add(lrng);
                    }
                }
            lstContainer.add(lngCat);
        
        }
        system.debug('Container:'+lstContainer.size());
        return lstContainer;
        
   }

  //Insert FeedBackLike,FeedBackImprovement and Rating Comment
    public  Void AddToChatterComment()
    {
        system.debug('ChatterImprovement:'+ChatterImprovement);
        system.debug('ChatterLike:'+ChatterLike);
        if (ChatterLike!=null || ChatterLike!='')
        {
             AthenaUtility.AddToChatterComment(LearningBoardId,AthenaUtility.FeedBackLike,ChatterLike);
        }
         if (ChatterImprovement!=null || ChatterImprovement!='')
        {
             AthenaUtility.AddToChatterComment(LearningBoardId,AthenaUtility.FeedBackImprovement,ChatterImprovement);
        }

        //FeedItem post = new FeedItem();     
        //post.ParentId = LearningBoardId; 
        //post.Body = '#[' + ChatterTags + ']' + ChatterComment;
        //insert post;
        //system.debug('$$$$'+post.id);
        //system.debug('$$$$'+post.Body);
        //system.debug('$$$$'+post.ParentId);
    }

    Public List<User> GetContributors()
    {
        List<User> ContributorsUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:LearningBoardId)];
        return  ContributorsUsers;
    }
  

    

public List <RelatedLearningBoardCustomClass> RelatedLearningBoards{
        get {
            RelatedLearningBoards.clear();  
            
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 
                       List<Related_Learning_Board__c>  rLBs =[SELECT Display_Sequence_Nbr__c,Learning_Board_ID__c,Related_Learning_Board_ID__c 
,Related_Learning_Board_ID__r.name__c,Related_Learning_Board_ID__r.Owner.Name,Related_Learning_Board_ID__r.Default_Image_Name__c,Related_Learning_Board_ID__r.description__c,Related_Learning_Board_ID__r.ID,Related_Learning_Board_ID__r.OwnerId
FROM Related_Learning_Board__c where Learning_Board_ID__c=: this.LearningBoardId and Related_Learning_Board_ID__r.Is_Active__c = True order by 
            Display_Sequence_Nbr__c ];

           
              
            for (Related_Learning_Board__c rLB:rLBs) {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Related_Learning_Board__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                
                 if(lb.Related_Learning_Board_ID__r.Default_Image_Name__c!=''){                        
                    lbCustom.DefaultImageName=ImageStaticPath + lb.Related_Learning_Board_ID__r.Default_Image_Name__c;          
                  }
                lbCustom.LBOwnerName=lb.Related_Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage = false;
                    }  
                }
                RelatedLearningBoards.add(lbCustom);
            }                
        return RelatedLearningBoards;                
        }   
        set;    
    }
    
    public void SaveUserRating()
    {
        string loggedInUserId = UserInfo.getUserId();
        string comment = '';

        if(userRatingComment == null)
        {
            userRatingComment = '';
        }

        system.debug('SaveUserRating:' + userRatingComment);

        string ratingAvgCount = AthenaUtility.RateObject(AthenaUtility.LearningBoard, this.LearningBoardId, UserRating, loggedInUserId, userRatingComment, this.LearningBoardId);
                                
        if(ratingAvgCount != '')
        {
            list<string> lstrtngAvg =  ratingAvgCount.split(',');

            String myNumber = lstrtngAvg[0];
            String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+2);
            Decimal d = Decimal.valueOf(myTruncatedNumber);
            System.debug(d);

            UserBoardRating = d;
            BoardRatersCount = lstrtngAvg[1];

            boolean isNotificationRequired = AthenaUtility.NotifyMyStatus(AthenaUtility.RateBoardEvent, UserOwnerDetails.id);

            system.debug('SaveUserRating isNotificationRequired:' + isNotificationRequired);

            string ratingNumber = '';

            if(UserRating == 1)
                ratingNumber = '* (1 Star)';
            else if(UserRating == 2)
                ratingNumber = '** (2 Stars)';
            else if(UserRating == 3)
                ratingNumber = '*** (3 Stars)';
            else if(UserRating == 4)
                ratingNumber = '**** (4 Stars)';
            else if(UserRating == 5)
                ratingNumber = '***** (5 Stars)';

            if (isNotificationRequired)
            {
                learning_board__c lb = [select name__c, ownerid from learning_board__c where id = :this.LearningBoardId ];    

                Messaging.SingleEmailMessage mail;  
                string bodyString = '';
                string[] toAddresses;
                mail = new Messaging.SingleEmailMessage();

                toAddresses = new String[] { UserOwnerDetails.email };
                mail.setToAddresses(toAddresses);       
                mail.setSubject(UserDetails.Name + ' Board Rating Notification For '+ lb.Name__c + ' board.'); 
                mail.setUseSignature(false);
                string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
                string[] subjectArguments1 = new String[] { getSfInstance, this.LearningBoardId};
                string formatURL1 = String.format(stringURL1, subjectArguments1);
        
                bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+UserOwnerDetails.Name+',&nbsp;</span></span></p>';
                bodyString += '<p> <p><span style="font-size:16px;">Please find the rating details for your Board.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Rating</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ ratingNumber +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Comment</td><td style="';
                bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ userRatingComment +'</td>';
                bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Rated By</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ UserDetails.Name +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the learning board. </span></p>';
                bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString += '</body></html>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  

            }
        }
    }

    public void GetAverageRating()
    {
        string ratingAvgCount = AthenaUtility.getRatingAvg(AthenaUtility.LearningBoard, this.LearningBoardId);
        if(ratingAvgCount != '')
        {
            list<string> lstrtngAvg =  ratingAvgCount.split(',');

            String myNumber = lstrtngAvg[0];
            String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+2);
            Decimal d = Decimal.valueOf(myTruncatedNumber);
            System.debug(d);

            UserBoardRating = d;
            BoardRatersCount = lstrtngAvg[1];
        }
    }

    public List<UserRatingHistory> GetRatingHistory()
    {
        lstRatingHistory = new List<UserRatingHistory>();
        List<User_Rated_Item__c> userRatedItems = [SELECT id, User_Id__r.Name, User_Id__r.smallphotourl, Rated_Item_Id__c, Rating_Nbr__c, comment__C, LastModifiedDate FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=: this.LearningBoardId and Item_Name__c='Learning_Board') order by LastModifiedDate desc];

        for(User_Rated_Item__c rItem: userRatedItems)
        {
            UserRatingHistory userRatingHistory = new UserRatingHistory();

            userRatingHistory.UserHistoryId = rItem.id;
            userRatingHistory.UserHistoryName = rItem.User_Id__r.Name;
            userRatingHistory.UserHistoryPhotoUrl = rItem.User_Id__r.smallphotourl;
            userRatingHistory.UserHistoryRating = rItem.Rating_Nbr__c;
            userRatingHistory.UserHistoryComment = rItem.comment__C;
            userRatingHistory.UserHistoryDateTime = rItem.LastModifiedDate;
            userRatingHistory.UserDate = rItem.LastModifiedDate.format('dd-MMM-yyyy hh:mm');

            lstRatingHistory.add(userRatingHistory);
        }
        return  lstRatingHistory;
    }

    public void SaveTopicUserRating()
    {
        system.debug('SaveTopicUserRating:'+ LearningBoardTopicID);
        system.debug('userTopicRatingComment:'+ userTopicRatingComment);

        string loggedInUserId = UserInfo.getUserId();
        string comment = '';

        if(userTopicRatingComment == null)
            comment = '';
        else
            comment = userTopicRatingComment;

        string ratingAvgCount = AthenaUtility.RateObject(AthenaUtility.Learning, LearningBoardTopicID, UserTopicRating, loggedInUserId, comment ,this.LearningBoardId );

        if(ratingAvgCount != '')
        {
            Learning__c learningObj = [SELECT Id, Name__c, Description__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Doc_Id__c, Owner.name, Owner.id,owner.email, Practice_Approved__c FROM Learning__c where id =: LearningBoardTopicID limit 1];

            boolean isNotificationRequired = AthenaUtility.NotifyMyStatus(AthenaUtility.RateTopicEvent, learningObj.Owner.id);

            system.debug('SaveUserRating isNotificationRequired:' + isNotificationRequired);

            string ratingNumber = '';

            if(UserTopicRating == 1)
                ratingNumber = '* (1 Star)';
            else if(UserTopicRating == 2)
                ratingNumber = '** (2 Stars)';
            else if(UserTopicRating == 3)
                ratingNumber = '*** (3 Stars)';
            else if(UserTopicRating == 4)
                ratingNumber = '**** (4 Stars)';
            else if(UserTopicRating == 5)
                ratingNumber = '***** (5 Stars)';

            if (isNotificationRequired)
            {
                Messaging.SingleEmailMessage mail;  
                string bodyString = '';
                string[] toAddresses;
                mail = new Messaging.SingleEmailMessage();

                toAddresses = new String[] { learningObj.owner.email };
                mail.setToAddresses(toAddresses);       
                mail.setSubject(UserDetails.Name + ' Topic Rating Notification For '+ learningObj.Name__c + ' topic.'); 
                mail.setUseSignature(false);
                string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}&topicid={2}';
                string[] subjectArguments1 = new String[] { getSfInstance, LearningBoardId, LearningBoardTopicID};
                string formatURL1 = String.format(stringURL1, subjectArguments1);
        
                bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+learningObj.Owner.name+',&nbsp;</span></span></p>';
                bodyString += '<p> <p><span style="font-size:16px;">Please find the rating details for your Topic.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Rating</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ ratingNumber +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Comment</td><td style="';
                bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ comment +'</td>';
                bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Rated By</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ UserDetails.Name +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the learning board. </span></p>';
                bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString += '</body></html>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            }
        }
    }
    
    @RemoteAction
    global static List<UserRatingHistory> GetTopicRatingHistory(string BoardTopicId)
    {
        system.debug('GetTopicRatingHistory:'+ BoardTopicId);

        List<UserRatingHistory> lstRatingHistory1 = new List<UserRatingHistory>();
        //and Item_Name__c= 'Learning'
        List<User_Rated_Item__c> userRatedItems = [SELECT id, User_Id__r.Name, User_Id__r.smallphotourl, Rated_Item_Id__c, Rating_Nbr__c, comment__C, LastModifiedDate FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=: BoardTopicId ) order by LastModifiedDate desc];

        for(User_Rated_Item__c rItem: userRatedItems)
        {
            UserRatingHistory userRatingHistory = new UserRatingHistory();

            userRatingHistory.UserHistoryId = rItem.id;
            userRatingHistory.UserHistoryName = rItem.User_Id__r.Name;
            userRatingHistory.UserHistoryPhotoUrl = rItem.User_Id__r.smallphotourl;
            userRatingHistory.UserHistoryRating = rItem.Rating_Nbr__c;
            userRatingHistory.UserHistoryComment = rItem.comment__C;
            userRatingHistory.UserHistoryDateTime = rItem.LastModifiedDate;
            userRatingHistory.UserDate = rItem.LastModifiedDate.format('dd-MMM-yyyy hh:mm');

            lstRatingHistory1.add(userRatingHistory);
        }
        return  lstRatingHistory1;
    }

    public void CheckIfLoggedInUserAndOwner()
    {
                   List<Learning_Board__Share> lstContr = [SELECT ParentId FROM Learning_Board__Share where parentId=:this.LearningBoardId and UserOrGroupId=:UserInfo.getUserId()];
                   if(lstContr.size()==0)
                   {
                       IsOwnerOrContributor = false;
                   }
                   else
                   {
                       IsOwnerOrContributor = true;
                   }              
        
    }
}