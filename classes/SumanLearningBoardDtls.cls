global class SumanLearningBoardDtls  {
 
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
    Public string NavCommunityId{get;set;}
    public boolean IsBoardPublic { get; set; }
    public boolean IsRequested { get; set;}
    public boolean IsMember { get; set;}
    public string hdnTopicCatName { get; set;}
    public static List<CustomContributorAndMember> lstContributorMember {get;set;}
    public integer ContributorMemCount {get;set;}
    
    public class CustomContributorAndMember
    {
        public Id UserId {get;set;}
        public string UserName {get;set;}
        public string RoleName {get;set;}
        public string Userphoto {get;set;}
        public boolean IsContributor {get;set;}
        public string Region {get;set;}
        public string BusinessGroup {get;set;}
        public boolean IsExperts {get;set;}
    }

//public string CategoryType { get; set; }
    Public string NavCommunityName{get    
    {
    string commid=ApexPages.currentPage().getParameters().get('CommunityId');
    string commname;
    List<community__c > name=[select name__c from community__c where id=:commid limit 1];
    if(name.size()>0)
    commname=name[0].name__c;
    return commname;
    }    
    set;}

    public boolean IsUserRoleMappingVisible
    {
    get
    {
    
    string userId=UserInfo.getUserId();
    
    AthenaUserAccess UsrAcc=new AthenaUserAccess();
       
                   if (UsrAcc.IsModerator(userId))
                return true;
            else
                return false;        
    }
    } 
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
    
    global class RelatedBoardOwner
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
        public string SmallPhotoUrl { get; set; }
        public string Email { get; set; }
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
        public DateTime LBCrtDate { get; set; }
        public string LBOwnerID { get; set; }
        public string LBOwnerTitle { get; set;}
        public string OwnerPhotoUrl { get; set;}

    }
    
    Public class RelatedCommunityCustomClass{
    public id CommunityId{get;set;}
    public string CommunityName{get;set;}
    public string ShortDescription{get;set;}
    public string Description{get;set;}
    public string DefaultImageName{get;set;}
    public id OwnerId{get;set;}
    public string OwnerName{get;set;}   
    public boolean StaticImage{get;set;} 
    public id AttachmentId{get;set;}
    }  
    
    // START By Komala
    public List<RelatedCommunityCustomClass> GetRelatedCommunities{
    get{
    List<RelatedCommunityCustomClass> result=new List<RelatedCommunityCustomClass>();
    List<id> communitiesownerid=new List<id>();
    List<id> communitiesid=new List<id>();
    string ownername='';
    ImageStaticPath='https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
    List<community_learning_board__c> lstRelatedCommunities=[select community_ID__r.id,community_ID__r.name__c,community_ID__r.Description__c,community_ID__r.Default_Image_Name__c,community_ID__r.short_description__c,community_ID__r.OwnerId from community_learning_board__c where community_ID__r.Isactive__c=:true and learning_board_id__c=:this.LearningBoardId];
    
    // Assign Owner Ids to the list
    for(community_learning_board__c ownerid:lstRelatedCommunities)
    {
    communitiesownerid.add(ownerid.community_ID__r.OwnerId);
    }
    
    // Assign community ids to the list
    for(community_learning_board__c cids:lstRelatedCommunities)
    {
    communitiesid.add(cids.community_ID__r.Id);
    }    
    
    List<Attachment> attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :communitiesid];
    
    List<User> communityUsers=GetRelatedCommunityOwners(communitiesownerid);
    for(community_learning_board__c clb:lstRelatedCommunities)
    {
    RelatedCommunityCustomClass commObj=new RelatedCommunityCustomClass();
    commObj.CommunityId=clb.community_ID__r.id;
    commObj.CommunityName=clb.community_ID__r.name__c;
    commObj.ShortDescription=clb.community_ID__r.short_Description__c;
    commObj.Description=clb.community_ID__r.Description__c;
    commObj.StaticImage = true;
    commObj.DefaultImageName=clb.community_ID__r.Default_Image_Name__c;
    if(clb.community_ID__r.Default_Image_Name__c!='')
    {                        
     commObj.DefaultImageName=ImageStaticPath + clb.community_ID__r.Default_Image_Name__c;          
    }
    //commObj.DefaultImageName=clb.community_ID__r.Default_Image_Name__c;
    commObj.OwnerId=clb.community_ID__r.OwnerId;
    for(User userObj:communityUsers)
    {
    if(userObj.id==clb.community_ID__r.OwnerId)
    {
    ownername=userObj.Name;
    }
    }
    for(Attachment att: attachmentList){
    if(clb.community_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif')){
    commObj.AttachmentId = att.Id;
    commObj.StaticImage = false;
    }  
    }
    commObj.OwnerName=ownername;
    result.add(commObj);
    }
    return result;
    }
    set;
    }

// END By Komala

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
        system.debug('UserInfo.getUserId():'+ UserInfo.getUserId());
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
        
        string stringURL1 = 'https://{0}/apex/SumanLearningBoardDtls?id={1}';
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
        
        string stringURL1 = 'https://{0}/apex/SumanLearningBoardDtls?id={1}&topicid={2}';
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

     public SumanLearningBoardDtls()
     {
         this.LearningBoardId = ApexPages.currentPage().getParameters().get('id');
         this.TopicId=ApexPages.currentPage().getParameters().get('TopicId');
         NavCommunityId=ApexPages.currentPage().getParameters().get('CommunityId');
         NavCommunityName=ApexPages.currentPage().getParameters().get('CommunityName');
         RelatedLearningBoards = new list<RelatedLearningBoardCustomClass>();
         lstRatingHistory = new list<UserRatingHistory>();
         User u = getLearningBoardOwnerDtls();
         UserOwnerDetails = getLearningBoardOwnerDtls();
         LBOwnerId = u.id;
         loggedInUserId = UserInfo.getUserId();
         FeedButtonPath = getStaticImagePath+ 'contact_tab.png';
         system.debug('FeedButtonPath:'+FeedButtonPath);
         hdnTopicCatName='';
         system.debug('SumanLearningBoardDtls loggedInUserId:' + loggedInUserId);

        //Get average Rating of user 
        GetAverageRating();
        
        CheckIfLoggedInUserAndOwner();

        UserDetails = GetLoggedinUserDtls();

         if (loggedInUserId == LBOwnerId)
            isloggedUser = true;
         else
            isloggedUser = false;

        // Get access status of Learning Board
        GetLearningBoardAccessStatus();

        CheckIsMember();

        CheckIsRequested();
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
            //List<User> FollowersUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (select SubscriberID from EntitySubscription where ParentId =:LearningBoardId)];
            List<User> FollowersUsers =[Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c=:LearningBoardId and Status__c='Approved')];
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

                FeedItem post = new FeedItem(); 
                post.ParentId = LBOwnerId; 
                string tag ='Follower'; 
                string comment = UserDetails.Name +' is now following ' + UserOwnerDetails.Name; 
                post.Body = '#[' + tag + ']' + ' ' + comment; 

                insert post;
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
            lbCustom.LBDescription = lb.description__c;           
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
        public string PreviewRequired { get; set; } 
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
List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Name__c, Display_Sequence_Nbr__c FROM User_Learning_Category__c where Learning_Board_ID__c =: LrngBrdId ];

        if(strLBTemplate==null)
        {
             //If Learning Board Doesn't have Template
                List<Learning_category__c> lrngCatlst= [select Name__c,id from Learning_category__c order by Display_Sequence_Nbr__C];

                for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
                    {
                        LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();

                        dtlsWithCats.CategoryId = userLrngCtgry.Id;
                        dtlsWithCats.CategoryName = userLrngCtgry.Name__c;
                       // dtlsWithCats.CategoryType = 'Custom';
                        lsWithCat.add(dtlsWithCats);
                    }

                //for(Learning_category__c lcc :lrngCatlst)
                //{
                //   LrngDtlsWithCategory dtlsWithCat=new LrngDtlsWithCategory();
                //   dtlsWithCat.CategoryId=lcc.id;
                //   dtlsWithCat.CategoryName=lcc.Name__c;
                //   lsWithCat.add(dtlsWithCat);
                //}
                
        }
        else
        {
        List<Required_Learning_Category__c> lstRequiredLCat =[SELECT Learning_Category_Id__c, Id, Name, Is_Active__c, Learning_Board_Template_ID__c,Learning_Category_Id__r.Name__C FROM Required_Learning_Category__c where Learning_Board_Template_ID__c =:strLBTemplate];
        for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
            {
                LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();

                dtlsWithCats.CategoryId = userLrngCtgry.Id;
                dtlsWithCats.CategoryName = userLrngCtgry.Name__c;
                //dtlsWithCats.CategoryType = 'Custom';
                lsWithCat.add(dtlsWithCats);
            }

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
        string resurl=GetResourceURL('img_athena');
        string FileURLUpload= 'https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/fileURLUpload.png';
        string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/hpsharedIcon.png';
        string  filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/filePDFUpload.png';
        string filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/filePPTUpload.png';
        string fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/fileWordUpload.png';
        string fileExcelUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/fileExcelUpload.png';
        string fileTextUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/fileTextUpload.png';
        string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/hpCertificateIcon.png';
        string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/hpPublishIcon.png';
    
        string previewRequiredVal = AthenaUtility.ApplicationSettingValue(AthenaUtility.PreviewRequired);

        list<id> lstLearningIds= new list<id>();
        List<LrngDtlsWithCategory> lstContainer=new List<LrngDtlsWithCategory>();
        
        List<Learning_Board_Learning__c> lstBoardLearning = [select Learning_ID__c,Learning_ID__r.Name__c, User_Learning_Category_ID__c,
                                                            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.Default_Image_Name__c ,Learning_ID__r.ClientFacing__c,Learning_ID__r.Practice_Approved__c,Learning_ID__r.Is_Active__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name, Learning_Category_Id__c
                                                            from Learning_Board_Learning__c where Learning_Board_ID__c =:LrngBoardId order by Display_Sequence_Nbr__c asc];

        
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
                    if(learningB.Learning_Category_Id__c==LCL.CategoryId || learningB.User_Learning_Category_ID__c == LCL.CategoryId)
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
                        //List<string> strlst = AthenaUtility.getAssociatedTags(AthenaUtility.Learning,learningB.Learning_ID__r.id);
                        lrng.PreviewRequired = previewRequiredVal;
                        //lrng.PreviewRequired = 'NO';

                        List<string> strlst = new List<string>();

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
                              //lrng.LURL=lrng.LURL;
                              
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
                //boolean IsmapLrngEdit = mapLrngEdit.get(learningB.Learning_ID__r.id);
                //if(IsmapLrngEdit)
                //{
                //    lrng.BtnshowHideEdit = true;
                //}
                //else
                //{
                //    // If logged in user and Topic owner are the same - Rating should be disabled
                //    // Else Rating should be enabled 
                //    if (lrng.TopicOwnerId == UserInfo.getUserId())
                //    {
                //        lrng.BtnshowHideEdit = true;
                //    }
                //    else
                //    {
                //        lrng.BtnshowHideEdit = false;
                //    }
                //}

                    //If logged in user and Topic owner are the same - Rating should be disabled
                    // Else Rating should be enabled 
                    if (lrng.TopicOwnerId == UserInfo.getUserId())
                    {
                        lrng.BtnshowHideEdit = true;
                    }
                    else
                    {
                        lrng.BtnshowHideEdit = false;
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
                                lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resurl + '/img_athena/' + learningB.Learning_ID__r.Default_Image_Name__c;
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

            List<Related_Learning_Board__c>  rLBs =[SELECT Display_Sequence_Nbr__c,Learning_Board_ID__c,Related_Learning_Board_ID__c , CreatedDate 
                ,Related_Learning_Board_ID__r.name__c,Related_Learning_Board_ID__r.Owner.Name,Related_Learning_Board_ID__r.Default_Image_Name__c,Related_Learning_Board_ID__r.description__c,Related_Learning_Board_ID__r.ID,Related_Learning_Board_ID__r.OwnerId
                FROM Related_Learning_Board__c where Learning_Board_ID__c=: this.LearningBoardId and Related_Learning_Board_ID__r.Is_Active__c = True order by 
                Display_Sequence_Nbr__c ];

            List<string> lstOwnerIds=new List<String>();

            for (Related_Learning_Board__c rLB:rLBs)
            {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
                lstOwnerIds.add(rLB.Related_Learning_Board_ID__r.OwnerId);
            }
            
            List<User> lstBoardOwner=[Select Id, Name, Title, SmallPhotoUrl from User where id in: lstOwnerIds];
            Map<id, RelatedBoardOwner> MapOwnerDetails =new Map<id, RelatedBoardOwner>();
            
            for(User userDtls :lstBoardOwner)
            {
                if(!MapOwnerDetails.containskey(userDtls.id))
                {
                    RelatedBoardOwner ownerDetails = new RelatedBoardOwner();
                    ownerDetails.Id = userDtls.Id;
                    ownerDetails.Name = userDtls.Name;
                    ownerDetails.SmallPhotoUrl = userDtls.SmallPhotoUrl;
                    ownerDetails.Title = userDtls.Title;

                    MapOwnerDetails.put(userDtls.id, ownerDetails);
                }
            }

           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');
                
            
           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :lstRLBIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           } 

            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            FetchStaticPathImage();

            for(Related_Learning_Board__c lb: rLBs)
            {
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.LBOwnerID = lb.Related_Learning_Board_ID__r.OwnerId;
                lbCustom.LBCrtDate = lb.CreatedDate;
                lbCustom.DefaultImageName = ImageStaticPath + lb.Related_Learning_Board_ID__r.Default_Image_Name__c;
                lbCustom.StaticImage = true;
                
                 if(lb.Related_Learning_Board_ID__r.Default_Image_Name__c!='')
                 {                        
                    lbCustom.DefaultImageName=ImageStaticPath + lb.Related_Learning_Board_ID__r.Default_Image_Name__c;          
                 }
                lbCustom.LBOwnerName=lb.Related_Learning_Board_ID__r.Owner.Name; 

                if(lb.Related_Learning_Board_ID__r.name__c != null) 
                { 
                    if(lb.Related_Learning_Board_ID__r.name__c.length() > 35) 
                    { 
                        lbCustom.LBName = lb.Related_Learning_Board_ID__r.name__c.substring(0, 35) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBName = lb.Related_Learning_Board_ID__r.name__c; 
                    } 
                }

                if(lb.Related_Learning_Board_ID__r.description__c != null)
                { 
                    if(lb.Related_Learning_Board_ID__r.description__c.length() > 75)
                    { 
                        lbCustom.LBDescription = lb.Related_Learning_Board_ID__r.description__c.substring(0,75) + '...'; 
                    } 
                    else
                    { 
                        lbCustom.LBDescription=lb.Related_Learning_Board_ID__r.description__c; 
                    } 
                }

                
                if (MapOwnerDetails.containskey(lb.Related_Learning_Board_ID__r.id))
                {
                    RelatedBoardOwner relatedBoardOwner = new RelatedBoardOwner();
                    
                    relatedBoardOwner = MapOwnerDetails.get(lb.Related_Learning_Board_ID__r.id);
                    lbCustom.LBOwnerName = relatedBoardOwner.Name;
                    lbCustom.LBOwnerTitle = relatedBoardOwner.Title;
                    lbCustom.OwnerPhotoUrl = relatedBoardOwner.SmallPhotoUrl;
                }
                
                if(lbCustom.LBOwnerName != null) 
                { 
                    lbCustom.LBOwnerName = lbCustom.LBOwnerName; 
                    if(lbCustom.LBOwnerName.length() > 15) 
                    { 
                        lbCustom.LBOwnerName = lbCustom.LBOwnerName.substring(0, 16) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBOwnerName = lbCustom.LBOwnerName; 
                    } 
                }

                if(lbCustom.LBOwnerTitle != null) 
                { 
                    lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle; 
                    if(lbCustom.LBOwnerTitle.length() > 25) 
                    { 
                        lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle.substring(0, 25) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle; 
                    } 
                }
                
                
                lbCustom.StaticImage = true;
                
               if(AttMap.containsKey(lbCustom.LbId))
               {
                    lbCustom.AttachmentId = AttMap.get(lbCustom.LbId);
                   lbCustom.StaticImage = false;
               }     

                //for(Attachment att: attachmentList)
                //{
                //    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif')){
                //    lbCustom.AttachmentId = att.Id;
                //    lbCustom.StaticImage = false;
                //    }  
                //}
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
        system.debug('AthenaUtility.LearningBoard:' + AthenaUtility.LearningBoard);
        system.debug('this.LearningBoardId:' + this.LearningBoardId);
        system.debug('UserRating:' + UserRating);
        system.debug('loggedInUserId:' + loggedInUserId);
        system.debug('userRatingComment:' + userRatingComment);
        system.debug('this.LearningBoardId:' + this.LearningBoardId);

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
                string stringURL1 = 'https://{0}/apex/SumanLearningBoardDtls?id={1}';
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
                string stringURL1 = 'https://{0}/apex/SumanLearningBoardDtls?id={1}&topicid={2}';
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
    global static List<UserRatingHistory> GetBoardRatingHistory(string BoardId)
    {
        system.debug('GetTopicRatingHistory:'+ BoardId);

        List<UserRatingHistory> lstRatingHistory1 = new List<UserRatingHistory>();
        //and Item_Name__c= 'Learning'
        List<User_Rated_Item__c> userRatedItems = [SELECT id, User_Id__r.Name, User_Id__r.smallphotourl, Rated_Item_Id__c, Rating_Nbr__c, comment__C, LastModifiedDate FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=: BoardId ) order by LastModifiedDate desc];

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
    
    public List<User> GetRelatedCommunityOwners(List<id> communityownerids)
    {
    List<User> u=[select id,name,fullphotourl,smallphotourl from User where id in:communityownerids];
    return u;
    }

    public void GetLearningBoardAccessStatus()
    {
        Learning_Board__c learningBoardObj = [SELECT Id, OwnerId, Name__c, Description__c, Featured__c, Is_Active__c, Short_Description__c, Sub_Title__c, Default_Image_Name__c, Public__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: this.LearningBoardId limit 1];

        IsBoardPublic = learningBoardObj.Public__c;
    }

    public void CheckIsRequested()
    {
       //Status we need to check whether Approved or Not 
        List<Learning_Board_Member__c> lstContr = [SELECT User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c =: this.LearningBoardId and User_Id__C=: UserInfo.getUserId() and Status__c =: AthenaUtility.Requested];

        if(lstContr.size() == 0)
        {
            IsRequested = false;
        }
        else
        {
            IsRequested = true;
        }                           
    }
    
    public void CheckIsMember()
    {
       //Status we need to check whether Approved or Not 
        List<Learning_Board_Member__c> lstContr = [SELECT User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c =: this.LearningBoardId and User_Id__C=: UserInfo.getUserId() and Status__c =: AthenaUtility.Approved];
        
        if(lstContr.size() == 0)
        {
            IsMember = false;
        }
        else
        {
            IsMember = true;
        }                           
    }

    public void JoinBoard() 
    { 
        system.debug('JoinBoard IsMember:' + IsMember);
        system.debug('JoinBoard IsBoardPublic:' + IsBoardPublic);
        system.debug('JoinBoard loggedInUserId:' + loggedInUserId);

        if(!IsMember)
        {   
            if(IsBoardPublic)
            {
                List<Learning_Board_Member__c> lstLearningBoardMember = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where User_Id__c=: loggedInUserId and Learning_Board_ID__c =: this.LearningBoardId];                      

                system.debug('JoinBoard lstLearningBoardMember:' + lstLearningBoardMember.size());
                if (lstLearningBoardMember.size() == 0)
                {
                    Learning_Board_Member__c boardMember = new Learning_Board_Member__c();
         
                    boardMember.Learning_Board_ID__c = this.LearningBoardId;
                    boardMember.User_Id__c = UserInfo.getUserId();
                    boardMember.Status__c = AthenaUtility.Approved;
                    
                    insert boardMember;
                }                                                                            

                EntitySubscription follow = new EntitySubscription (); 
                
                List<EntitySubscription> lstEntitySubscription = [SELECT Id, ParentId, SubscriberId, IsDeleted FROM EntitySubscription where parentId =: this.LearningBoardId and SubscriberId =: loggedInUserId];

                if (lstEntitySubscription.size() == 0 )
                {
                    follow.parentId = this.LearningBoardId;
                    follow.subscriberid = loggedInUserId;
                    insert follow; 
                }
                
                CheckIsMember();
                CheckIfLoggedInUserAndOwner();
                //GetMembers();
                CheckIsRequested();
                AthenaUtility.AddToChatterComment(this.LearningBoardId,'Add Member','I joined as a Member');
                
            }
            else
            {
                List<Learning_Board_Member__c> lstLearningBoardMember = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where User_Id__c=: loggedInUserId and Learning_Board_ID__c =: this.LearningBoardId];                      

                if (lstLearningBoardMember.size() == 0)
                {
                    Learning_Board_Member__c boardMember = new Learning_Board_Member__c();
                    boardMember.Learning_Board_ID__c = this.LearningBoardId;
                    boardMember.User_Id__c = UserInfo.getUserId();
                    boardMember.Status__c = AthenaUtility.Requested;
                    
                    insert boardMember;

                    Learning_Board__c learningBoard = [select id, Sub_Title__c, Name__c,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c, CreatedDate from Learning_Board__c where ID =: this.LearningBoardId limit 1];

                    //Send Mail to Owner and CC requestor
                    Messaging.SingleEmailMessage mail;  
                    string bodyString = '';
                    string[] toAddresses;
                    mail = new Messaging.SingleEmailMessage();
                    toAddresses = new String[] { UserOwnerDetails.Email };
                    mail.setToAddresses(toAddresses); 
                    mail.setCCAddresses( new String[]{ UserDetails.email });    
                    mail.setUseSignature(false);      
                    mail.setSubject(UserDetails.Name + ' requesting to add as member to the board '+ learningBoard.Name__c ); 
                                                                                                                                                                                                                                                                                                
                                                                                                
                    string stringURL1 = 'https://{0}/apex/SumanLearningBoardDtls?id={1}';
                    string[] subjectArguments1 = new String[] { getSfInstance, this.LearningBoardId};
                    string formatURL1 = String.format(stringURL1, subjectArguments1);
                                                                                                
                    bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                    bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                    bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+UserOwnerDetails.Name+',&nbsp;</span></span></p>';
                    bodyString += '<p> <p><span style="font-size:16px;">Please add me as a member to the below Board.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                    bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Board Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ learningBoard.Name__c +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Board Description</td><td style="';
                    bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ learningBoard.description__c +'</td>';
                    bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                    bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ UserDetails.email +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Board. </span></p>';
                    bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                    bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                    bodyString += '</body></html>';

                    mail.setHtmlBody(bodyString);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                }     
                else
                {

                    Learning_Board_Member__c learningBoardMemberObject = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where User_Id__c=: loggedInUserId and Learning_Board_ID__c =: this.LearningBoardId Limit 1];                      
                    learningBoardMemberObject.Status__c = AthenaUtility.Requested;

                    update learningBoardMemberObject;

                }                                                                       
           }   

                CheckIsMember();
                CheckIfLoggedInUserAndOwner();
                //GetMembers();
                CheckIsRequested();         
        }
    }

    public void LeaveCommunity() 
    { 
        if(IsMember)
        {
            //Delete from new Object
            List<Learning_Board_Member__c> lstLearningBoardMember = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where User_Id__c=: UserInfo.getUserId() and Learning_Board_ID__c =: this.LearningBoardId];                      

            system.debug('LeaveCommunity Community_Member__c:' + lstLearningBoardMember.size());

            if (lstLearningBoardMember.size() != 0)
            {
                delete lstLearningBoardMember[0];
            }
            
            List<EntitySubscription> lstSubscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : this.LearningBoardId AND SubscriberId = : UserInfo.getUserId() ]; 

            system.debug('LeaveCommunity EntitySubscription:' + lstSubscription.size());

            if (lstSubscription.size() != 0)
            {
                Delete lstSubscription[0];
            }

            CheckIsMember();
            CheckIfLoggedInUserAndOwner();
            //GetMembers();
            GetLearningBoardAccessStatus();
        }
    }

    public void InserSession()
    {
     // AthenaUtility.InsertUserSession(UserInfo.getSessionId(),UserInfo.getUserId());
    }
    
    public string ContributorMember
    {
       get
       {
            lstContributorMember = GetCommunityContributorAndMember();
     
            string jsonString = JSON.serialize(lstContributorMember);
            return jsonString;
       }
    }

    public List<CustomContributorAndMember> GetCommunityContributorAndMember()
    {
        List<CustomContributorAndMember> lstContributorMem = new List<CustomContributorAndMember>();

        List<Learning_Board__Share> lstBoardShare = [SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId =: LearningBoardId];
        List<Learning_Board_Member__c> lstBoardMember = [SELECT User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c =: LearningBoardId and Status__c = 'Approved'];

        Map<Id,boolean> MapUser = new Map<Id,boolean>();
        set<Id> setUserIds = new set<Id>();

        for(Learning_Board__Share CommContrib: lstBoardShare)
        {
            MapUser.put(CommContrib.UserOrGroupId, true);
            setUserIds.add(CommContrib.UserOrGroupId);
        }

        for(Learning_Board_Member__c CommMem: lstBoardMember)
        {
            if(!MapUser.ContainsKey(CommMem.User_Id__c))
            {
                MapUser.put(CommMem.User_Id__c, false);
                setUserIds.add(CommMem.User_Id__c);
            }
        }

        list<ES_User__c> lstEsuser= [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c,Region_Id__r.Region_Name__c,Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in :setUserIds ];
        Map<Id,string> MapExpertUserRole = new Map<Id,string>();
        Map<Id,string> MapBusinessGrp=new Map<Id,string>();
        Map<Id,string> MapRegion=new Map<Id,string>();

        for(ES_User__c esUser:lstEsuser )
        {
             string RoleName = esUser.Role_ID__r.Role_Name__c;
             string RegionName = esUser.Region_Id__r.Region_Name__c;
             string BsnGrp = esUser.Business_Group_Id__r.Business_Group_Name__c;

             MapExpertUserRole.put(esUser.User_Id__c,RoleName);
             MapBusinessGrp.put(esUser.User_Id__c,BsnGrp);
             MapRegion.put(esUser.User_Id__c,RegionName);
        }
    
        set<Id> SetExperts=new set<Id>();

        List<SLP_Expert__c> lstExperts= [SELECT Id, ES_User_ID__r.User_ID__c FROM SLP_Expert__c where ES_User_ID__r.User_ID__c in:setUserIds ];

        for(SLP_Expert__c slp:lstExperts)
        {
            SetExperts.add(slp.ES_User_ID__r.User_ID__c); 
        }
    
        List<User> ListUsers = [Select id, Name, Title, SmallPhotoUrl, FullPhotoUrl From User where id IN : setUserIds order by FirstName];
    
        for(User usr:ListUsers )
        {
            CustomContributorAndMember contributorMem = new CustomContributorAndMember();
            contributorMem.UserId = usr.id;

            if(usr.Name!='' &&(usr.Name!=null))
            {
                string strNm = usr.Name;
                contributorMem.UserName = strNm.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
            }
            //contributorMem.UserName = usr.Name;

            contributorMem.UserName = usr.Name;
            contributorMem.Userphoto = usr.SmallPhotoUrl;
        
            if(MapUser.containsKey(usr.id))
            {
                contributorMem.IsContributor = MapUser.get(usr.id);
            }

            if(SetExperts.contains(usr.id))
            {
                contributorMem.IsExperts = true;
            }

            if(MapExpertUserRole.containsKey(usr.id))
            {
                contributorMem.RoleName = MapExpertUserRole.get(usr.id);
            }
            
            if(MapRegion.containsKey(usr.id))
            {
                contributorMem.Region=MapRegion.get(usr.id);
            }
            
            if(MapBusinessGrp.containsKey(usr.id))
            {
                contributorMem.BusinessGroup=MapBusinessGrp.get(usr.id);
            }
        
            lstContributorMem.add(contributorMem);
        }
        return lstContributorMem;
    }   
}