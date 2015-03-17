Public class AthenaUserProfileForEndorsement{

    Private Integer userOwnedIndex;
    Public String AthenaUserId{get;set;}
    Public String strSearchValue{get;set;}
    public string AvailTags{get;set;}
    public String linkedinurl{get;set;}
    public String twitterurl{get;set;}
    public String  locationcom{get;set;}
    public boolean isuser{get;set;}
    public boolean displayPopup {get; set;} 
    public integer BoardsCount{get;set;} 
    public integer PeopleFollowingCount{get;set;} 
    public integer BoardFollowingCount{get;set;}
    public integer FollowersCount{get;set;}
    public integer BoardsContributedCount{get;set;}
    public boolean IsLoggedInUser{get;set;}
    
    public class LearningBoardCustomClass
    {
        public String LBOwnerURL{get;set;}
        Public id AttachmentId{get;set;}
        public string LBOwnerID{get;set;}
        Public String LBName{get;set;}
        Public String LBDescription{get;set;}   
        Public String LBid{get;set;}
        Public String id{get;set;}
        Public String LBOwnerName{get;set;} 
        Public datetime LBCrtDate{get;set;}
        Public Integer LBNoOfLikes{get;set;}
        Public Integer LBNoOfComments{get;set;}  
        Public boolean StaticImage{get;set;}
        Public String DefaultImageName{get;set;}   
        Public boolean IsActive{get;set;}           
    }
    
      public PageReference  RedirectToSLP_GlobalSearch()
      {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
      }

    Public List<LearningBoardCustomClass> UserContLbList{get;set;}
    public List<LearningBoardCustomClass> UserOwnedLBList{get;set;}
    Public List<LearningBoardCustomClass> boardfollowg{get;set;}

    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
   
    Public boolean isloggedUser{
    get{
            id lgdusrid=UserInfo.getUserId();
            user usrid=getUserDtls();
            if(lgdusrid==usrid.id){
                return true;
            }
            else{
                return false;
            }
        }set;
    }
    
    Public User getUserDtls(){
        User u = [Select u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:this.AthenaUserId];
        system.debug('############'+u.id);
        return U;
        
    }
        
    Public User GetLoggedinUserDtls(){
        User u = new User();
        u = [Select SmallPhotoUrl,Name From User where User.id= :UserInfo.getUserId()];
        system.debug('############ GetLoggedinUserDtls'+ u.Name);
        return u;         
    }
    Public User GetprofileUser()
    {
        User u = new User();
        u = [Select id,Name From User where User.id=:this.AthenaUserId];
        system.debug('############ GetprofileUser'+ u.Name);
        return u;         
    }
    
    Public List<skill__C> getExpertise(){
        List<skill__c> Lskill=new List<skill__c>();
         Lskill=[select Name__C from Skill__C where id In (select skill_id__C from user_skill__c where user_id__c=:AthenaUserId) and Is_Active__c=True];
         return Lskill;
    }
     

    
    //Learning Board Comment Count
    Private integer getLBCommentCount(string lbID){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
        return commCount.size();
    }
    
    Public ApexPages.standardSetController UserOwnedCon{    
        get{
            if(UserOwnedCon == null && this.AthenaUserId==userinfo.getuserid())
            {  
                UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:AthenaUserId]));                           
                //UserOwnedCon.setPageSize(4);
            } 
            else if(UserOwnedCon == null && this.AthenaUserId!=userinfo.getuserid()) 
            { 
            UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:AthenaUserId]));                           
            }
            return UserOwnedCon;
        }    
        set;
    }   
    Public ApexPages.standardSetController UserCon{    
        get{
            if(UserCon == null){  
                List<Learning_Board__Share> lbs=new List<Learning_Board__Share>();
                List<Id> lbsid=new List<Id>();
                lbs=[SELECT ParentId FROM Learning_Board__Share where AccessLevel='Edit' and UserOrGroupId=:AthenaUserId];
                if(lbs!=null)
                {
                    for(Learning_Board__Share lbsloop:lbs)
                    {
                        lbsid.add(lbsloop.ParentId);
                    }
                }
                if(this.AthenaUserId==userinfo.getuserid())
                {
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where id In:lbsid]));                           
                //UserCon.setPageSize(4);
                }
                else
                {
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and id In:lbsid]));                           
                }
            }        
            return UserCon;   
        }    
        set;
    } 
    
    Public void GetUserContLbList(List<Learning_Board__c> LearningBoards)
    {
            UserContLbList= new List<LearningBoardCustomClass>();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            string resourceURL= GetResourceURL('img_athena');
            //List<Learning_Board__c> LearningBoards=(List<Learning_Board__c>)UserCon.getRecords();  
            string userImageUrl='';      
            List<User> userImagesLst=GetLBUserImagesLst();    

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
            /*List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :learningBoardIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        

            for (Id LBId :learningBoardIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            } */
                List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];
                Map<String,Integer> CmntCntMap = new Map<String,Integer>();
                system.debug('FI##'+feeddItmlst);
                for (FeedItem feedItm : feeddItmlst){            
                      if(!CmntCntMap.containskey(feedItm.ParentId)){
                          CmntCntMap.put(feedItm.ParentId,1);
                      }
                      else{
                          integer i = CmntCntMap.get(feedItm.parentId);
                          CmntCntMap.put(feedItm.parentId,i+1);            
                      }
                } 
            for(Learning_Board__c lb: LearningBoards){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                lbCustom.LBName = lb.Name__c; 
                if(lb.Name__c!=null){
                    if(lb.Name__c.length()>35){                    
                        lbCustom.LBName = lb.Name__c.substring(0,35) + '...';
                    }
                    else{
                        lbCustom.LBName =lb.Name__c;
                    }
                }
                if(lb.description__c!=null){
                    if(lb.description__c.length()>53){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                for(User userData:userImagesLst)
                {
                if(userData.Id==lb.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                lbCustom.LBOwnerURL =  userImageUrl;
                lbCustom.id=lb.id;
                lbCustom.LBOwnerID=lb.Owner.Id;
                if(lb.Owner.Name!=null){
                    if(lb.Owner.Name.length()>20){                    
                        lbCustom.LBOwnerName = lb.Owner.Name.substring(0,15) + '...';
                    }
                    else{
                        lbCustom.LBOwnerName =lb.Owner.Name;
                    }
                }  
 
                lbCustom.LBCrtDate = lb.CreatedDate;  
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id);
                //lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lb.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;          
                   }
                
                lbCustom.StaticImage = true;
                for(Attachment att: attachmentList){
                    if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                        lbCustom.AttachmentId = att.Id;
                        lbCustom.LbId = att.ParentId;
                        lbCustom.StaticImage=false;
                    }  
                }
                UserContLbList.add(lbCustom);
            }
            BoardsContributedCount=UserContLbList.size();
            //return UserContLbList;
    }  

    Public void GetUserOwnedLBList(List<Learning_Board__c> LearningBoards)
    {
            //UserOwnedLBList.clear();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            //List<Learning_Board__c> LearningBoards=(List<Learning_Board__c>)UserOwnedCon.getRecords(); 
            string resourceURL= GetResourceURL('img_athena');  
            string userImageUrl='';      
            List<User> userImagesLst=GetLBUserImagesLst();             

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
            /*List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :learningBoardIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        

            for (Id LBId :learningBoardIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            } */
                List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];
                Map<String,Integer> CmntCntMap = new Map<String,Integer>();
                system.debug('FI##'+feeddItmlst);
                for (FeedItem feedItm : feeddItmlst){            
                      if(!CmntCntMap.containskey(feedItm.ParentId)){
                          CmntCntMap.put(feedItm.ParentId,1);
                      }
                      else{
                          integer i = CmntCntMap.get(feedItm.parentId);
                          CmntCntMap.put(feedItm.parentId,i+1);            
                      }
                }

            for(Learning_Board__c lb: LearningBoards){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                lbCustom.LBName = lb.Name__c; 
                if(lb.Name__c!=null){
                    if(lb.Name__c.length()>35){                    
                        lbCustom.LBName = lb.Name__c.substring(0,35) + '...';
                    }
                    else{
                        lbCustom.LBName =lb.Name__c;
                    }
                }
                if(lb.description__c!=null){
                    if(lb.description__c.length()>53){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                lbCustom.IsActive=lb.Is_Active__c;
                for(User userData:userImagesLst)
                {
                if(userData.Id==lb.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                
                lbCustom.LBOwnerURL =  userImageUrl;
                lbCustom.id=lb.id;
                if(lb.Owner.Name!=null){
                    if(lb.Owner.Name.length()>20){                    
                        lbCustom.LBOwnerName = lb.Owner.Name.substring(0,15) + '...';
                    }
                    else{
                        lbCustom.LBOwnerName =lb.Owner.Name;
                    }
                }  
                lbCustom.LBCrtDate = lb.CreatedDate;  
                lbCustom.LBOwnerID=lb.Owner.Id;
                //lbCustom.LBNoOfComments =   getLBCommentCount(lb.id);
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id);  
                //lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lb.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;          
                   }
                
                lbCustom.StaticImage = true;
                for(Attachment att: attachmentList){
                    if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                        lbCustom.AttachmentId = att.Id;
                        lbCustom.LbId = att.ParentId;
                        lbCustom.StaticImage=false;
                    }  
                }
                UserOwnedLBList.add(lbCustom);
            }           
            BoardsCount=UserOwnedLBList.size();      
            //return UserOwnedLBList;
    }
      
            Public void GetLBFollowingList()
            {
            //UserOwnedLBList.clear();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            List<Learning_Board__c> LearningBoards=new List<Learning_Board__c>();
            string resourceURL= GetResourceURL('img_athena');
            if(this.AthenaUserId==userinfo.getuserid())
            {
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId]);
            }
            else
            {
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Is_Active__c=:true AND Id !=:AthenaUserId]);
            }
            boardfollowg=new List<LearningBoardCustomClass>();
            string userImageUrl='';      
            List<User> userImagesLst=GetLBUserImagesLst();             

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
            /*List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :learningBoardIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        

            for (Id LBId :learningBoardIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            } */
                List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];
                Map<String,Integer> CmntCntMap = new Map<String,Integer>();
                system.debug('FI##'+feeddItmlst);
                for (FeedItem feedItm : feeddItmlst){            
                      if(!CmntCntMap.containskey(feedItm.ParentId)){
                          CmntCntMap.put(feedItm.ParentId,1);
                      }
                      else{
                          integer i = CmntCntMap.get(feedItm.parentId);
                          CmntCntMap.put(feedItm.parentId,i+1);            
                      }
                }

            for(Learning_Board__c lb: LearningBoards){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                lbCustom.LBName = lb.Name__c; 
                if(lb.Name__c!=null){
                    if(lb.Name__c.length()>35){                    
                        lbCustom.LBName = lb.Name__c.substring(0,35) + '...';
                    }
                    else{
                        lbCustom.LBName =lb.Name__c;
                    }
                }
                if(lb.description__c!=null){
                    if(lb.description__c.length()>53){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                
                for(User userData:userImagesLst)
                {
                if(userData.Id==lb.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                
                lbCustom.LBOwnerURL =  userImageUrl;
                lbCustom.id=lb.id;
                if(lb.Owner.Name!=null){
                    if(lb.Owner.Name.length()>20){                    
                        lbCustom.LBOwnerName = lb.Owner.Name.substring(0,15) + '...';
                    }
                    else{
                        lbCustom.LBOwnerName =lb.Owner.Name;
                    }
                }
                //lbCustom.LBOwnerName = lb.Owner.Name; 
                 
                lbCustom.LBCrtDate = lb.CreatedDate;  
                lbCustom.LBOwnerID=lb.Owner.Id;
                //lbCustom.LBNoOfComments =   getLBCommentCount(lb.id);  
                //lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id); 
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lb.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;          
                   }
                
                lbCustom.StaticImage = true;
                for(Attachment att: attachmentList){
                    if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                        lbCustom.AttachmentId = att.Id;
                        lbCustom.LbId = att.ParentId;
                        lbCustom.StaticImage=false;
                    }  
                }
                boardfollowg.add(lbCustom);

    }
        BoardFollowingCount=boardfollowg.size();
    }

  
    Public AthenaUserProfileForEndorsement()
    {
        
        AvailTags=AthenaUtility.getAvailableTags(); 
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords(); 
        userOwnedIndex=0;
        Socialconnect();
        location();
        avgconrating();
        isLoggedUser(); 
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        GetLBFollowingList();
        recoruserid=ApexPages.currentPage().getParameters().get('id');  
        userid = userinfo.getuserid();         
        if(this.AthenaUserId==userinfo.getuserid())
        {
        system.debug('IsLoggedInUser:'+IsLoggedInUser);
        IsLoggedInUser=true;
        }
        else
        {      
        System.debug('IsLoggedInUser:'+IsLoggedInUser);
        IsLoggedInUser=false;
        }
        System.debug('AthenaUserId:'+this.AthenaUserId+',userid:'+userid);
        followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:recoruserid and SubscriberId=:userid)];
    }

    Public void UserconNext(){
        UserCon.next();
        UserOwnedIndex=0;
    }       

    Public void UserconPrevious(){
        UserCon.previous();
        UserOwnedIndex=0;       
    }

    
    Public void UserOwnedNext(){
        UserOwnedCon.next();
        UserOwnedIndex=0;
    }       

    Public void UserOwnedPrevious(){
        UserOwnedCon.previous();
        UserOwnedIndex=0;       
    }

     private String GetResourceURL(String resourceName)  
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
       
       Public String editProfile()
       {
           return null;
       }

       Public List<User> followg{
       get{
               followg=[SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId];
               system.debug('+++++followg'+followg);
               PeopleFollowingCount=followg.size();
               return followg;
           }
           set;
       }

        public List<User> GetFollowers() 
        { 
                List<User> Followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUserId AND SubscriberId !=:AthenaUserId) ]; 
                
                FollowersCount = Followers.size(); 
                return Followers; 
        }

        Public boolean isFollowUn { get; set; } 
        Public string recoruserid{get;set;} 
        Public string userid{get;set;} 
        List<User> followers = new List<User>(); 
        
        Public boolean IsFollowOwner
        {
            get 
            {
                                                                
            List<EntitySubscription> entsub=[select SubscriberID from EntitySubscription where ParentId =:AthenaUserId and SubscriberID =:UserInfo.getUserId()];                                        
            //List<User> Followers = [SELECT Id, Name,FullPhotoUrl, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:LBOwnerId AND SubscriberId !=:loggedInUserId) ]; 

            if(entsub.size() >0 ) 
            {   
                            return true;
            } 
            else
            {
                            return false;
            }
            }
        } 

        public void followOwner() 
        { 
                                
            if(!IsFollowOwner)
            {
                EntitySubscription follow = new EntitySubscription (); 
                follow.parentId = AthenaUserId;
                follow.subscriberid = UserInfo.getUserId();
                insert follow; 
            }            
        } 

        public void unfollowOwner() 
        { 
          
                EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : AthenaUserId AND SubscriberId = :UserInfo.getUserId() Limit 1]; 
                Delete subscription; 
           
        }



        Public boolean isFollow() 
        { 
            if(followers.size() >0 ) 
            {   
                for(User ufol:followers)
                {
                    if (ufol.id != UserInfo.getUserId()) 
                    { 
                        isFollowUn = true; 
                    } 
                    else 
                    { 
                        isFollowUn = false; 
                    } 
                }
            } 
            return isFollowUn ;
        } 

        public void followme() 
        { 
            if(followers.size() == 0) 
            {
                EntitySubscription follow = new EntitySubscription (); 

                follow.parentId = recoruserid;
                follow.subscriberid = userid;

         //parentId =:recoruserid subscriberid =:userid

                insert follow; 
            }
        } 

        public void unfollowme() 
        { 
            if(followers.size() > 0) 
            {
                EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : recoruserid AND SubscriberId = :userid Limit 1]; 
                Delete subscription; 
            } 
        }




       Public void Socialconnect()
       {
            List<ES_User__c> Socialconnecturl=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c =:AthenaUserId];
            if(Socialconnecturl.size()>0)
            {
            linkedinurl=String.ValueOf(Socialconnecturl[0].Linked_In__c);
            twitterurl=String.ValueOf(Socialconnecturl[0].Twitter__c);
            system.debug('+++++linkedinurl'+linkedinurl);
            }
            

       }
        Public List<Project__c> project{
        get{
           project=[SELECT Id, Name__c,Display_Sequence_Nbr__c,Description__c, Timeframe__c,User_Id__c FROM Project__c where User_Id__c =:AthenaUserId order by Display_Sequence_Nbr__c];
           system.debug('+++++project'+project);
           return project;
           }
           set;
       }
        Public void location()
        {
           List<User> location=new List<User>();
           location=[select id,state,city,country from user where id=:AthenaUserId];
           //String.ValueOf(Socialconnecturl[0].Linked_In__c);
           locationcom=String.ValueOf(location[0].city)+',' +String.ValueOf(location[0].state)+','+String.ValueOf(location[0].country) ;
           system.debug('+++++locationcom'+locationcom);
           system.debug('+++++locationcom'+locationcom);    
        }
        Public void avgconrating()
        {
            Set<id> lbandlid=new set<id>();
            List<Learning_Board__c> lbrate=new List<Learning_Board__c>();
            List<Learning__c> lrate=new List<Learning__c>();
            //List<user_Rated_Item__c> rateditem1=new List<user_Rated_Item__c>();
            List<Rated_Item__c> rateditem=new List<Rated_Item__c>();
            lbrate=[select id,owner.id from Learning_Board__c where owner.id=:UserInfo.getUserId()];
            lrate=[select id,owner.id from Learning__c where owner.id=:UserInfo.getUserId()];
            for(Learning_Board__c lbite:lbrate){                
                lbandlid.add(lbite.id) ;                
            }
            for(Learning__c lite:lrate){
               lbandlid.add(lite.id) ;               
            }
            system.debug('!@##@!size'+lbandlid.size());
            system.debug('!@##@!List'+lbandlid);
            rateditem=[select Item_Identifier__c,Rating_Average__c from Rated_Item__c where Item_Identifier__c IN:lbandlid];
            
            
            /*rateditem1 = [SELECT Rated_Item_Id__r.Item_Identifier__c FROM User_Rated_Item__c];
            rateditem = [SELECT Id, Rated_Item_Id__c, User_Id__c, Rating_Nbr__c FROM User_Rated_Item__c where Rated_Item_Id__r.Item_Identifier__c IN:lbandlid];
            
            System.debug('**********rating sum'+rateditem );
            System.debug('**********rating sum'+rateditem1 );
            decimal count=0;
            decimal avg;
            for(User_Rated_Item__c uri : rateditem){
                count += uri.Rating_Nbr__c;                
            }
            avg = count/rateditem.size();
            system.debug('****murali******average'+avg);*/
            //System.debug('**********rating sum'+rateditem[0].get('ratave') );
        }
        Public void isLoggedUser()
        {
            if(AthenaUserId==UserInfo.getUserId())
            {
                isuser=true;
            }
            else
            { 
                isuser=false;
            }
        }
        
        private List<User> GetLBUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from learning_board__c)];
        return userImgLst;
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
     Public boolean endorsedOrNot{
    get{
            boolean isLiked=false;    
            List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:AthenaUserId];
            for(Liked_Item__c LikdItm:LikdItms)
            {            
                list<User_Liked_Item__c> UsrlikdItms=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c=:UserInfo.getUserId()and Liked_Item_ID__c=:LikdItm.Id];

                for(User_Liked_Item__c UsrlikdItm:UsrlikdItms)
                {                       
                     isLiked=true;                                                    
                }
                return isLiked;
            }  
            return isLiked;   
    }    
    set;}
    
    Public void endorseSkill()
    {
        List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:AthenaUserId];
        boolean isLikedItem=false;
        Liked_Item__c litm=new Liked_Item__c();           
        for(Liked_Item__c lb:lbdtls)
        {
            isLikedItem=true;  
            litm.id=lb.id;  
        }
        
        if(!isLikedItem)
        {
            litm.Item_Identifier__c=AthenaUserId;
            litm.Item_Name__c='Endorse User';
            insert litm;                        
        }
        
        List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
        if(UsrlikdItms.size()==0)
        {
            User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
            UsrlikdItm.Liked_Item_ID__C=litm.ID;
            UsrlikdItm.User_ID__C=UserInfo.getUserId();                
            insert UsrlikdItm;            
        }
 
 
        
    }    
    
    Public void unEndorseSkill()
    {        
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:AthenaUserId ];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where 
            Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C UsrlikdItm:UsrlikdItms)
                {
                    delete UsrlikdItm;            
                }
            }
        }
    } 
    
    Private integer LikedItemCount(string itemIdentifier)
    {
        List<Liked_Item__C> LikdItms= [select like_count__c from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(LikdItms.size()!=0)
        {
            return Integer.ValueOf(LikdItms[0].like_count__c);
        }
        return 0;
    }  
    Public integer LBLikeCount
    {
        get
        {     
            LBLIkeCount=LikedItemCount(this.AthenaUserId);
            return LBLIkeCount;
        }
        set;
    }
           
}