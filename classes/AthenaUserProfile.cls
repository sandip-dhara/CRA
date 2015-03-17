Public class AthenaUserProfile {

    public AthenaUserProfile(AthenaSocialLearning controller) {

    }
    
    // Added By Komala
    public string RedirectUrl{get;set;}
    Public String UserName{get;set;}
    Public String OperatingSystem{get;set;}
    Public String Browser{get;set;}
    Public String DeviceType{get;set;}  
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
    public integer BoardsTotalCount { get; set; }
    public integer PeopleFollowingCount{get;set;} 
    public integer BoardFollowingCount{get;set;}
    public integer FollowersCount{get;set;}
    public integer communityCount{get;set;}
    public integer communityContributeCount{get;set;}
    public integer communityViewTotalCount{get;set;}    
    public integer UserContLbListCount;
    public integer UserOwnedLBListCount;    
    public integer UserContCmListCount;
    public integer UserOwnedCmListCount;
    public integer CommunityMemberCount{get;set;}
    public integer LearningBoardsCount{get;set;}
    public string SLPRegistrationUrl { get; set;}
    public string SSOUrl { get; set;}
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
    public integer BoardsContributedCount{get;set;}
    public boolean IsLoggedInUser{get;set;}
    public string HeaderShareEmail { get; set;} //Sree
    public string ShareProfileId { get; set;} //Sree
    public Boolean LBShare{get;set;}
    public Boolean LBRate{get;set;}
    public Boolean TShare{get;set;}
    public Boolean TRate{get;set;}
    public Boolean UFollow{get;set;}
    public Decimal TotalRating{get;set;} // Komala
    public string RoleName { get; set; }
    
    /*public class People
    {
       Public String Id{get;set;}
       Public String Name{get;set;}
       Public String SmallPhotoUrl{get;set;}
       Public String title {get;set;}
    }*/
    public class LearningBoardCustomClass
    {
        public String LBOwnerURL{get;set;}
        Public id AttachmentId{get;set;}
        public string LBOwnerID{get;set;}
        Public String LBName{get;set;}
        public String LBOwnerTitle{get;set;} //Sree
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
        Public Decimal AvgRating{get;set;}          
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
    public List<LearningBoardCustomClass> UserMembers { get; set; }
    public List<LearningBoardCustomClass> myBoardMembers {get;set;}

   // Public List<People> followg{get;set;}
    
    
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
        User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:this.AthenaUserId];
        system.debug('############'+u.id);
        UserName=u.name;
        return U;
        
    }
        
    Public User GetLoggedinUserDtls(){
        User u = new User();
        u = [Select SmallPhotoUrl,FullPhotoUrl,Name From User where User.id= :UserInfo.getUserId()];
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
         Lskill=[select Name__C from Skill__C where id In (select skill_id__C from user_skill__c where user_id__c=:AthenaUserId) and Is_Active__c=True order by Name__C];
         return Lskill;
    }
     
    public List<Community__c> GetExpertiseDetails()
    {
        List<string> communityIds = new List<string> ();
        List<Community__Share> communityShare = new List<Community__Share>();
        List<Community__c> lstCommunity = new List<Community__c>();

        communityShare = [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where UserOrGroupId =: this.AthenaUserId];

        for(Community__Share communityItem : communityShare)
        {
            communityIds.add(communityItem.ParentId);
        }
        
        lstCommunity = [SELECT Id, Name__c FROM Community__c where id in : communityIds];

        return lstCommunity;
    }

    public List<SLP_Expert__c> GetExpert()
    {
        
        List<SLP_Expert__c> listSlpExpert =new List<SLP_Expert__c>();
        
        listSlpExpert = [select id,Es_User_ID__c,ES_User_ID__r.User_ID__c,SLP_Secondary_Industry_ID__r.Industry_Name__c,SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c,Is_Expert__c from SLP_Expert__c where ES_User_ID__r.User_ID__c =: this.AthenaUserId and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
        
        return listSlpExpert;
    }

    //Learning Board Like Count
   /* Private integer getLBLikeCount(string itemIdentifier){
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
        return Integer.ValueOf(li[0].like_count__c);
        }
        return 0;
    }*/
    
    //Learning Board Comment Count
    /*Private integer getLBCommentCount(string lbID){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
        return commCount.size();
    }*/
    
    Public ApexPages.standardSetController UserOwnedCon{    
        get{
            system.debug('!!!'+this.AthenaUserId);
            system.debug('^^^'+userinfo.getuserid());
            system.debug('^^^'+UserOwnedCon);
            if(UserOwnedCon == null && this.AthenaUserId==userinfo.getuserid())
            {  
                UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:AthenaUserId]));                           
                //UserOwnedCon.setPageSize(4);
            } 
            else if(UserOwnedCon == null && this.AthenaUserId!=userinfo.getuserid()) 
            { 
            UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:AthenaUserId]));                           
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
                system.debug('AthenaUserId :'+AthenaUserId);
                lbs=[SELECT ParentId FROM Learning_Board__Share where AccessLevel='Edit' and UserOrGroupId=:AthenaUserId];
                system.debug('LBS :'+lbs);
                if(lbs!=null)
                {
                    for(Learning_Board__Share lbsloop:lbs)
                    {
                        lbsid.add(lbsloop.ParentId);
                    }
                }
                if(this.AthenaUserId==userinfo.getuserid())
                {
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Is_Active__c, Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where id In:lbsid]));                           
                //UserCon.setPageSize(4);
                }
                else
                {
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Is_Active__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and id In:lbsid]));                           
                }
            }        
            return UserCon;   
        }    
        set;
    } 
    
    Public void GetUserContLbList(List<Learning_Board__c> LearningBoards)
    {
            UserContLbListCount = LearningBoards.size();
            UserContLbList= new List<LearningBoardCustomClass>();
            //UserMembers = new List<LearningBoardCustomClass>();

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
                system.debug('LBIds##'+learningBoardIds);
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
            Map<id,decimal> RatedItemMap=GetRatedItemData(learningBoardIds);
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
                    if(lb.description__c.length()>75){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,75) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                If(RatedItemMap.containskey(lb.id))
                {
                    lbCustom.AvgRating=RatedItemMap.get(lb.id);
                }
                else
                {
                lbCustom.AvgRating=0;
                }

                lbCustom.IsActive=lb.Is_Active__c;
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
                if(lb.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 if(lb.Owner.title.length() > 25)
                 {                            
                    lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
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
                UserMembers.add(lbCustom);
            }
            BoardsContributedCount=UserContLbList.size();
            //return UserContLbList;
    }  

Public void GetUserOwnedLBList(List<Learning_Board__c> LearningBoards)
{
            UserOwnedLBListCount = LearningBoards.size();
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
                
            Map<id,decimal> RatedItemMap=GetRatedItemData(learningBoardIds);

            for(Learning_Board__c lb: LearningBoards){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                lbCustom.LBName = lb.Name__c;
                If(RatedItemMap.containskey(lb.id))
                {
                    lbCustom.AvgRating=RatedItemMap.get(lb.id);
                }
                else
                {
                lbCustom.AvgRating=0;
                }
 
                if(lb.Name__c!=null){
                    if(lb.Name__c.length()>35){                    
                        lbCustom.LBName = lb.Name__c.substring(0,35) + '...';
                    }
                    else{
                        lbCustom.LBName =lb.Name__c;
                    }
                }
                if(lb.description__c!=null){
                    if(lb.description__c.length()>75){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,75) + '...';
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
                if(lb.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 if(lb.Owner.title.length() > 25)
                 {                            
                    lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
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
                UserMembers.add(lbCustom);
            }           
            BoardsCount=UserOwnedLBList.size();      
            //return UserOwnedLBList;
}

            public void GetAllBoards()
            {

                List<Learning_Board_Member__c> LearningBoards = [SELECT Id, Status__c, User_Id__c, Learning_Board_ID__c, Learning_Board_ID__r.Owner.title, Learning_Board_ID__r.Id, Learning_Board_ID__r.Is_Active__c, Learning_Board_ID__r.Name__c, Learning_Board_ID__r.Default_Image_Name__c, Learning_Board_ID__r.description__c, Learning_Board_ID__r.Featured__c, Learning_Board_ID__r.CreatedDate, Learning_Board_ID__r.Owner.name, Learning_Board_ID__r.Owner.Id FROM Learning_Board_Member__c where Status__c = 'Approved' and User_Id__c =: AthenaUserId];

                LearningBoardsCount = LearningBoards.size();
                system.debug('GetAllBoards:' + AthenaUserId);
                system.debug('GetAllBoards size:' + LearningBoards.size());

                list<Attachment> attachmentList = new List<Attachment>(); 
                list<id> learningBoardIds= new list<id>();
                string resourceURL = GetResourceURL('img_athena');
                string userImageUrl ='';      
                List<User> userImagesLst = GetLBUserImagesLst();    

                for (Learning_Board_Member__c lb: LearningBoards)
                {
                    learningBoardIds.add(lb.Learning_Board_ID__r.Id);
                }

                attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
            
                List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];

                Map<String,Integer> CmntCntMap = new Map<String,Integer>();
                
                for (FeedItem feedItm : feeddItmlst)
                {            
                        if(!CmntCntMap.containskey(feedItm.ParentId))
                        {
                            CmntCntMap.put(feedItm.ParentId,1);
                        }
                        else
                        {
                            integer i = CmntCntMap.get(feedItm.parentId);
                            CmntCntMap.put(feedItm.parentId,i+1);            
                        }
                } 

                Map<id,decimal> RatedItemMap = GetRatedItemData(learningBoardIds);

                for(Learning_Board_Member__c lb: LearningBoards)
                {
                    LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                    lbCustom.LBName = lb.Learning_Board_ID__r.Name__c; 
                    
                    if(lb.Learning_Board_ID__r.Name__c!=null)
                    {
                        if(lb.Learning_Board_ID__r.Name__c.length() > 35)
                        {                    
                            lbCustom.LBName = lb.Learning_Board_ID__r.Name__c.substring(0,35) + '...';
                        }
                        else
                        {
                            lbCustom.LBName = lb.Learning_Board_ID__r.Name__c;
                        }
                    }
                    if(lb.Learning_Board_ID__r.description__c != null)
                    {
                        if(lb.Learning_Board_ID__r.description__c.length() > 75)
                        {                    
                            lbCustom.LBDescription = lb.Learning_Board_ID__r.Description__c.substring(0,75) + '...';
                        }
                        else
                        {
                            lbCustom.LBDescription=lb.Learning_Board_ID__r.description__c;
                        }
                    }
                    If(RatedItemMap.containskey(lb.Learning_Board_ID__r.Id))
                    {
                        lbCustom.AvgRating = RatedItemMap.get(lb.Learning_Board_ID__r.Id);
                    }
                    else
                    {
                        lbCustom.AvgRating = 0;
                    }

                    lbCustom.IsActive = lb.Learning_Board_ID__r.Is_Active__c;
                    for(User userData:userImagesLst)
                    {
                        if(userData.Id == lb.Learning_Board_ID__r.Owner.Id)
                        userImageUrl = userData.SmallPhotoUrl;
                    }
                    
                    lbCustom.LBOwnerURL =  userImageUrl;
                    lbCustom.id = lb.Learning_Board_ID__r.id;
                    lbCustom.LBOwnerID = lb.Learning_Board_ID__r.Owner.Id;

                    if(lb.Learning_Board_ID__r.Owner.Name != null)
                    {
                        if(lb.Learning_Board_ID__r.Owner.Name.length() > 20)
                        {                    
                            lbCustom.LBOwnerName = lb.Learning_Board_ID__r.Owner.Name.substring(0,15) + '...';
                        }
                        else{
                            lbCustom.LBOwnerName =lb.Learning_Board_ID__r.Owner.Name;
                        }
                    }  
                    if(lb.Learning_Board_ID__r.Owner.title != null)
                    {
                        lbCustom.LBOwnerTitle = lb.Learning_Board_ID__r.Owner.title;

                         if(lb.Learning_Board_ID__r.Owner.title.length() > 25)
                         {                            
                            lbCustom.LBOwnerTitle = lb.Learning_Board_ID__r.Owner.title.substring(0, 25) + '...';
                         }
                         else
                         {
                            lbCustom.LBOwnerTitle = lb.Learning_Board_ID__r.Owner.title;
                         }
                    }
                    lbCustom.LBCrtDate = lb.Learning_Board_ID__r.CreatedDate;  
                    lbCustom.LBNoOfComments =   CmntCntMap.get(lb.Learning_Board_ID__r.Id);
                
                      if(lb.Learning_Board_ID__r.Default_Image_Name__c!='')
                      {                        
                            lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Learning_Board_ID__r.Default_Image_Name__c;          
                      }
                
                    lbCustom.StaticImage = true;
                    for(Attachment att: attachmentList)
                    {
                        if(lb.Learning_Board_ID__r.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif'))
                        {
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.LbId = att.ParentId;
                            lbCustom.StaticImage = false;
                        }  
                    }
                    //UserContLbListCount.add(lbCustom);
                    UserMembers.add(lbCustom);
                    myBoardMembers.add(lbCustom);
                }
                
                //integer contributor = UserContLbList.size()
                //integer contributor = UserOwnedLBList.size()
                BoardsTotalCount = (LearningBoards.size() + UserContLbListCount + UserOwnedLBListCount);              
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
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c,Is_Active__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId]);
            }
            else
            {
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c,Is_Active__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Is_Active__c=:true AND Id !=:AthenaUserId]);
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
                
            Map<id,decimal> RatedItemMap=GetRatedItemData(learningBoardIds);

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
                    if(lb.description__c.length()>75){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,75) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                If(RatedItemMap.containskey(lb.id))
                        {
                            lbCustom.AvgRating=RatedItemMap.get(lb.id);
                        }
                        else
                        {
                            lbCustom.AvgRating=0;
                        }
                if(lb.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 if(lb.Owner.title.length() > 25)
                 {                            
                    lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
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
                //lbCustom.LBOwnerName = lb.Owner.Name; 
                if(lb.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 if(lb.Owner.title.length() > 25)
                 {                            
                    lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 }
                } 
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

  
    Public AthenaUserProfile () 
    {
        
        AvailTags=AthenaUtility.getAvailableTags(); 
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        UserMembers = new List<LearningBoardCustomClass>();
        myBoardMembers = new List<LearningBoardCustomClass>();
        communityMembers = new List<CommunityCustomClass>();
        myCommunityMembers = new List<CommunityCustomClass>();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();     
        List<Community__c> COmmunityContributed = (List<Community__c>)UserConCm.getRecords();
        List<Community__c> COmmunityOwned = (List<Community__c>)UserOwnedCominites.getRecords();
        
        userOwnedIndex=0;
        Socialconnect();
        location();
        avgconrating();
        isLoggedUser(); 
        RefreshMyNotifications(); // By Komala
        CalculateTotalRatings(); // By Komala
        
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        GetAllBoards();
        
        
        GetUserContCmList(COmmunityContributed);
        GetUserOwnedCmList(COmmunityOwned);
        GetAllCommunity();

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
        followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:recoruserid and SubscriberId=:userid) order by Name];
        FetchUserProfileRole();

        SLPRegistrationUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SLPRegistrationUrl);
        SSOUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SSOUrl);
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
               followg=[SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId order by name];
               system.debug('+++++followg'+followg);
               PeopleFollowingCount=followg.size();
               return followg;
           }
           set;
       }
          /*    Public List<People> followg{
       get{
               List<User> followng=[SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId order by name];
               system.debug('+++++followg'+followng);
               PeopleFollowingCount=followng.size();
               for(User u: followng){
                    People p = new People();
                    p.Id = u.Id;
                    p.Name = u.Name;
                    p.SmallPhotoUrl = u.SmallPhotoUrl;
                    p.title = u.title;
                    followg.add(p);
                } 
               return followg;
           }
           set;
       }*/


        public List<User> GetFollowers() 
        { 
                List<User> Followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUserId AND SubscriberId !=:AthenaUserId) order by Name]; 
                
                FollowersCount = Followers.size(); 
                return Followers; 
        }

        Public boolean isFollowUn { get; set; } 
        Public string recoruserid{get;set;} 
        Public string userid{get;set;} 
        List<User> followers = new List<User>(); 
        
Public boolean IsFollowOwner {
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

public void RefreshMyNotifications()
    {
            //murali code
        List<user_Notification_Subscription__c> UN = [select id,Notification_Event_ID__r.name__c,isActive__c from User_Notification_subscription__c where Notification_Event_ID__r.isactive__c=:true and Subscriber_User_ID__c =:this.AthenaUserID];
        List<user> usr = [select id, UserPreferencesDisableFollowersEmail from user where id =:this.AthenaUserID limit 1];
        if(UN.size()>0)
        {
        for(user_Notification_Subscription__c n:UN){
            if(n.Notification_Event_ID__r.name__c==athenautility.RateLearningBoard){
                LBRate=n.isActive__c;
            }
            if(n.Notification_Event_ID__r.name__c==athenautility.ShareTopic){
                TShare=n.isActive__c;
            }
            if(n.Notification_Event_ID__r.name__c==athenautility.ShareLearningBoard){
                LBShare=n.isactive__c;
            }
            if(n.Notification_Event_ID__r.name__c==athenautility.RateTopic){
                TRate=n.isactive__c;
            }   
        }
        } 
        //UFollow = usr.UserPreferencesDisableFollowersEmail;
        if(usr.size()>0)
        {
                if(usr[0].UserPreferencesDisableFollowersEmail==true){
            UFollow =false;
        }
        else if(usr[0].UserPreferencesDisableFollowersEmail==false){
            UFollow =true;
        }
        system.debug('%%'+usr[0].UserPreferencesDisableFollowersEmail);
        }
                //murali code

    }

    public void followOwner() 
    { 
        if(!IsFollowOwner)
        {
        
            User userDetails = GetLoggedinUserDtls();
            User profileUser = getUserDtls();

            EntitySubscription follow = new EntitySubscription (); 
            follow.parentId = AthenaUserId;
            follow.subscriberid = UserInfo.getUserId();
            insert follow; 
        
            FeedItem post = new FeedItem(); 
            post.ParentId = AthenaUserId; 
            string tag ='Follower'; 
            string comment = userDetails.Name +' is now following ' + profileUser.name; 
            post.Body = '#[' + tag + ']' + ' ' + comment; 

            insert post;       
        FollowMetrics('Follow User ');
        }            
    } 
    
    public void FollowMetrics(string ActionTyp)
    {
     
        AthenaUtility athUtlObj=new AthenaUtility();
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=UserInfo.getUserId();
        metricsObj.ObjectName__c='User Profile';
        metricsObj.ObjectId__c=ApexPages.currentPage().getParameters().get('id');        
        metricsObj.Text__c=UserName;
        metricsObj.ActionType__c=actionTyp + ' Button Click';
        //metricsObj.ActionPath__c=getSfInstance+'/apex/SLP_GlobalSearch'+'?SearchOptions='+strSelectedOptions+'&SearchVal='+strSearchValue;
        metricsObj.PageName__c='User Profile';
        metricsObj.DeviceType__c=DeviceType;
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=athUtlObj.GetOSName(OperatingSystem);
        metricsObj.Browser__c=Browser;
        Insert(metricsObj);
    }

        public void unfollowOwner() 
        { 
          
                EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : AthenaUserId AND SubscriberId = :UserInfo.getUserId() Limit 1]; 
                Delete subscription; 
                FollowMetrics('UnFollow User ');
           
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


//public List<EntitySubscription> getFollowers(userid,recoruserid) 
//{ 
//List<EntitySubscription> followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUserId AND SubscriberId!=:AthenaUserId)];

//followerCount = followers.size(); 
//return followers; 
//}




       Public void Socialconnect()
       {
            List<ES_User__c> Socialconnecturl=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c =:AthenaUserId limit 1];
            if(Socialconnecturl.size() > 0)
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
           if(location.size()>0)
           {
           locationcom=String.ValueOf(location[0].city)+',' +String.ValueOf(location[0].state)+','+String.ValueOf(location[0].country) ;
           }
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
       private List<User> GetCMUserImagesLst(){
            List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from Community__c)];
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
   //Sree Start for email
   
   public void ShareProfile()
    {
        User usr=[Select Name,email,title,aboutme,Department from User where id =:AthenaUserId];
         String title = '';if(usr.title == null){title ='';}else{title=usr.title;}
         String dept = '';if(usr.Department == null){dept ='';}else{dept =usr.Department ;}
         String combine = '';if(usr.title != null && usr.Department != null){combine =',';} else{combine ='';}
         String bio = '';if(usr.aboutme == null){bio ='';} else{bio = usr.aboutme;}
         List<skill__c> Lskill=new List<skill__c>();
         Lskill=[select Name__C from Skill__C where id In (select skill_id__C from user_skill__c where user_id__c=:AthenaUserId) and Is_Active__c=True];
            Integer i;
            String expert= '';
            for(i=0; i<Lskill.size();i++)
            {
                if (i == 0){
                    expert = Lskill[i].Name__c;
                }
                else{
                    expert = expert + ',' + Lskill[i].Name__c;
                }
            }
        User logged_usr=[Select Name,email,title,aboutme from User where id = :UserInfo.getUserId()];
        List<User> Shareusr=[Select id,title,department,Name,email from User where email =:HeaderShareEmail Limit 1];
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
        mail.setSubject(logged_usr.Name + ' thought you might be interested be in the Profile'); 

        string stringURL1 = SSOUrl + 'AthenaUserProfile?id%3d{1}';
        string[] subjectArguments1 = new String[] { getSfInstance, ShareProfileId};
        string formatURL1 = String.format(stringURL1, subjectArguments1);
        
        bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
        bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>insight<br /><small>Information – on your terms</small></strong></span></span></h3>';
        bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+ShareUserName+',&nbsp;</span></span></p>';
        bodyString += '<p> <p><span style="font-size:16px;">I thought that you might be interested in this profile! . You should take a look.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ usr.Name +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Title</td><td style="';
        bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ title +combine + dept+'</td>';
        bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Bio</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ bio +'</td></tr>';
        
        bodyString += '<tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Expertise</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ expert +' </td></tr>';
        
        bodyString += '</table></p><p><span>If you are new to the insight, please click <a href='+ SLPRegistrationUrl +'>here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Profile. </span></p>';
        bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+logged_usr.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
        bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        bodyString += '</body></html>';
        
        mail.setHtmlBody(bodyString);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
   //Sree end for email  
   
   
   // START By Komala
   
   Public void CalculateTotalRatings()
    {
        List<id> learningBoardIds=new List<id>();
        system.debug('This.athenaUserid :'+This.athenaUserid);        
        List<Learning_Board__c> LearningBoards=[select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:this.AthenaUserId and Is_Active__c=True];
        
        if(LearningBoards.size()>0)
        {
            for (Learning_Board__c lb: LearningBoards)
            {
            learningBoardIds.add(lb.id);
            }
                                
            List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
            map<id,decimal> RatedItemMap = new map<id,decimal>();        
                       
            
            for (Rated_Item__c rtdItm :RatedItemLst) {
                        RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
            }

            TotalRating=0.0;
            for(Learning_Board__c lb: LearningBoards){
            If(RatedItemMap.containskey(lb.id))
            {
                //lbCustom.AvgRating=RatedItemMap.get(lb.id);
                TotalRating=TotalRating+RatedItemMap.get(lb.id);
            }
            }
            TotalRating=(TotalRating/(decimal.valueof(string.valueof(LearningBoards.size())))).setScale(2);

        }
        else
        {
                TotalRating=0;
        }
    }
    
    // END By Komala  
    
        //START By Komala
    
    // This function returns the ratings for the learning board ids passed in the parameter.
    Public Map<id,decimal> GetRatedItemData(List<id> learningBoardIds)
    {
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);                      
        }
        
        return RatedItemMap;
    }
    
    //END By Komala  

    public void FetchUserProfileRole()
    {
        List<es_user__c> userObj = new List<es_user__c>();

        userObj = [select id, Role_ID__r.Role_name__c, User_ID__c from es_user__c where User_ID__c =: this.AthenaUserId];

        if(userObj.size() > 0)
        {
            RoleName = userObj[0].Role_ID__r.Role_name__c;
        }
    }
    
    //--------------------------------------------------------------
    public class CommunityCustomClass{
        public String CMOwnerURL{get;set;}
        Public id AttachmentId{get;set;}
        public string CMOwnerID{get;set;}
        Public String CMName{get;set;}
        public String CMOwnerTitle{get;set;} //Sree
        Public String CMDescription{get;set;}   
        Public String CMid{get;set;}
        Public String id{get;set;}
        Public String CMOwnerName{get;set;} 
        Public datetime CMCrtDate{get;set;}
        Public Integer CMNoOfLikes{get;set;}
        Public Integer CMNoOfComments{get;set;}  
        Public boolean StaticImage{get;set;}
        Public String DefaultImageName{get;set;}   
        Public boolean IsActive{get;set;} 
        Public Decimal AvgRating{get;set;}          
    }

    Public List<CommunityCustomClass> UserContCmList{get;set;}
    public List<CommunityCustomClass> UserOwnedCmList{get;set;}
    public List<CommunityCustomClass> communityMembers{get; set;}
    public List<CommunityCustomClass> myCommunityMembers{get;set;}
    
    Public ApexPages.standardSetController UserOwnedCominites{    
        get{
            system.debug('!!!'+this.AthenaUserId);
            system.debug('^^^'+userinfo.getuserid());
            system.debug('^^^'+UserOwnedCominites);
            if(UserOwnedCominites == null && this.AthenaUserId==userinfo.getuserid())
            {  
                UserOwnedCominites= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,IsActive__c,CreatedDate from Community__c where owner.id=:AthenaUserId]));                           
                //UserOwnedCon.setPageSize(4);
            } 
            else if(UserOwnedCominites == null && this.AthenaUserId!=userinfo.getuserid()) 
            { 
            UserOwnedCominites = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,IsActive__c,CreatedDate from Community__c where IsActive__c = True and owner.id=:AthenaUserId]));                           
            }
            return UserOwnedCominites;
        }    
        set;
    }  

    Public ApexPages.standardSetController UserConCm{    
        get{
            if(UserConCm == null){  
                List<Community__Share> lbs = new List<Community__Share>();
                List<Id> lbsid = new List<Id>();
                system.debug('AthenaUserId :'+AthenaUserId);
                lbs=[SELECT ParentId FROM Community__Share where AccessLevel='Edit' and UserOrGroupId=:AthenaUserId];
                system.debug('LBS :'+lbs);
                if(lbs!=null)
                {
                    for(Community__Share lbsloop:lbs)
                    {
                        lbsid.add(lbsloop.ParentId);
                    }
                }
                if(this.AthenaUserId==userinfo.getuserid())
                {
                UserConCm = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,IsActive__c, Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Community__c where id In:lbsid]));                           
                
                }
                else
                {
                UserConCm = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,IsActive__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Community__c where IsActive__c = True and id In:lbsid]));                           
                }
            }        
            return UserConCm;   
        }    
        set;
    } 




    Public void GetUserContCmList(List<Community__c> Comminites){
        UserContCmListCount = Comminites.size();
        UserContCmList= new List<CommunityCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> commuintyIds = new list<id>();
        string resourceURL= GetResourceURL('img_athena');  
        string userImageUrl='';      
        List<User> userImagesLst=GetCMUserImagesLst();    

        for (Community__c lb: Comminites)
        {
            commuintyIds.add(lb.id);
        }
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :commuintyIds]; 
            List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :commuintyIds];
            system.debug('CMids##'+commuintyIds);
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
        Map<id,decimal> RatedItemMap=GetRatedItemData(commuintyIds);
        for(Community__c lb: Comminites){
            CommunityCustomClass lbCustom= new CommunityCustomClass();

            lbCustom.CMName = lb.Name__c; 
            if(lb.Name__c!=null){
                if(lb.Name__c.length()>35){                    
                    lbCustom.CMName = lb.Name__c.substring(0,35) + '...';
                }
                else{
                    lbCustom.CMName =lb.Name__c;
                }
            }
            if(lb.description__c!=null){
                if(lb.description__c.length()>75){                    
                    lbCustom.CMDescription = lb.Description__c.substring(0,75) + '...';
                }
                else{
                    lbCustom.CMDescription=lb.description__c;
                }
            }
            If(RatedItemMap.containskey(lb.id))
            {
                lbCustom.AvgRating=RatedItemMap.get(lb.id);
            }
            else
            {
            lbCustom.AvgRating=0;
            }

            lbCustom.IsActive=lb.IsActive__c;
            for(User userData:userImagesLst)
            {
            if(userData.Id==lb.Owner.Id)
            userImageUrl=userData.SmallPhotoUrl;
            }
            lbCustom.CMOwnerURL =  userImageUrl;
            lbCustom.id=lb.id;
            lbCustom.CMOwnerID=lb.Owner.Id;
            if(lb.Owner.Name!=null){
                if(lb.Owner.Name.length()>20){                    
                    lbCustom.CMOwnerName = lb.Owner.Name.substring(0,15) + '...';
                }
                else{
                    lbCustom.CMOwnerName =lb.Owner.Name;
                }
            }  
            if(lb.Owner.title!= null)
            {
                lbCustom.CMOwnerTitle = lb.Owner.title;
             if(lb.Owner.title.length() > 25)
             {                            
                lbCustom.CMOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
             }
             else
             {
                lbCustom.CMOwnerTitle = lb.Owner.title;
             }
            }
            lbCustom.CMCrtDate = lb.CreatedDate;  
            lbCustom.CMNoOfComments =   CmntCntMap.get(lb.id);
            //lbCustom.CMNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
            //lbCustom.CMNoOfLikes = getLBLikeCount(lb.id); 
            system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
            //lbCustom.DefaultImageName = get
              if(lb.Default_Image_Name__c!=''){                        
                    lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;          
               }
            
            lbCustom.StaticImage = true;
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.CMid = att.ParentId;
                    lbCustom.StaticImage=false;
                }  
            }
            UserContCmList.add(lbCustom);
            communityMembers.add(lbCustom);
        }
        communityContributeCount=UserContCmList.size();   
    }  

    Public void GetUserOwnedCmList(List<Community__c> Comminites)
    {    
        UserOwnedCmListCount = Comminites.size();
        UserOwnedCmList = new List<CommunityCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> communityIds= new list<id>();
        string resourceURL = GetResourceURL('img_athena');  
        string userImageUrl='';      
        List<User> userImagesLst = GetCMUserImagesLst();             

        system.debug('Comminites Owner:' + Comminites);

        for (Community__c lb: Comminites)
        {
            communityIds.add(lb.id);
        }
        system.debug('communityIds:' + communityIds.size());

        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :communityIds];
            List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :communityIds];
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
            
        Map<id,decimal> RatedItemMap=GetRatedItemData(communityIds);

        for(Community__c lb: Comminites){
            CommunityCustomClass lbCustom= new CommunityCustomClass();

            lbCustom.CMName = lb.Name__c;
            If(RatedItemMap.containskey(lb.id))
            {
                lbCustom.AvgRating=RatedItemMap.get(lb.id);
            }
            else
            {
            lbCustom.AvgRating=0;
            }

            if(lb.Name__c!=null){
                if(lb.Name__c.length()>35){                    
                    lbCustom.CMName = lb.Name__c.substring(0,35) + '...';
                }
                else{
                    lbCustom.CMName =lb.Name__c;
                }
            }
            if(lb.description__c!=null){
                if(lb.description__c.length()>75){                    
                    lbCustom.CMDescription = lb.Description__c.substring(0,75) + '...';
                }
                else{
                    lbCustom.CMDescription=lb.description__c;
                }
            }
            lbCustom.IsActive=lb.IsActive__c;
            for(User userData:userImagesLst)
            {
            if(userData.Id==lb.Owner.Id)
            userImageUrl=userData.SmallPhotoUrl;
            }
            
            lbCustom.CMOwnerURL =  userImageUrl;
            lbCustom.id=lb.id;
            if(lb.Owner.Name!=null){
                if(lb.Owner.Name.length()>20){                    
                    lbCustom.CMOwnerName = lb.Owner.Name.substring(0,15) + '...';
                }
                else{
                    lbCustom.CMOwnerName =lb.Owner.Name;
                }
            }  
            if(lb.Owner.title!= null)
            {
                lbCustom.CMOwnerTitle = lb.Owner.title;
             if(lb.Owner.title.length() > 25)
             {                            
                lbCustom.CMOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
             }
             else
             {
                lbCustom.CMOwnerTitle = lb.Owner.title;
             }
            }
            lbCustom.CMCrtDate = lb.CreatedDate;  
            lbCustom.CMOwnerID=lb.Owner.Id;               
            lbCustom.CMNoOfComments =   CmntCntMap.get(lb.id);                  
                         
              if(lb.Default_Image_Name__c!=''){                        
                    lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;          
               }
            
            lbCustom.StaticImage = true;
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.CMid = att.ParentId;
                    lbCustom.StaticImage=false;
                }  
            }
            UserOwnedCmList.add(lbCustom);
            communityMembers.add(lbCustom);
        }           
        communityCount=UserOwnedCmList.size();                 
    } 
    public void GetAllCommunity()
    {

        //communityMembers = new List<CommunityCustomClass>();

        List<Community_Member__c> CommunityMember = [SELECT Id, Status__c, User_Id__c, Community_Id__c, Community_Id__r.Owner.title, Community_Id__r.Id, Community_Id__r.IsActive__c, Community_Id__r.Name__c, Community_Id__r.Default_Image_Name__c, Community_Id__r.description__c, Community_Id__r.Featured__c, Community_Id__r.CreatedDate, Community_Id__r.Owner.name, Community_Id__r.Owner.Id FROM Community_Member__c where Status__c = 'Approved' and User_Id__c =: AthenaUserId];
        CommunityMemberCount = CommunityMember.size(); 
        list<Attachment> attachmentList = new List<Attachment>();
        list<id> communityIds = new list<id>();
        string resourceURL = GetResourceURL('img_athena');
        string userImageUrl ='';      
        List<User> userImagesLst = GetCMUserImagesLst();
        for (Community_Member__c lb: CommunityMember){
            communityIds.add(lb.Community_Id__r.Id);
        }
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :communityIds];
        List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :communityIds];
        Map<String,Integer> CmntCntMap = new Map<String,Integer>();
        for (FeedItem feedItm : feeddItmlst)
        {            
                if(!CmntCntMap.containskey(feedItm.ParentId))
                {
                    CmntCntMap.put(feedItm.ParentId,1);
                }
                else
                {
                    integer i = CmntCntMap.get(feedItm.parentId);
                    CmntCntMap.put(feedItm.parentId,i+1);            
                }
        } 
        Map<id,decimal> RatedItemMap = GetRatedItemData(communityIds);
        for(Community_Member__c lb: CommunityMember){
            CommunityCustomClass lbCustom= new CommunityCustomClass();
            lbCustom.CMName = lb.Community_Id__r.Name__c; 
            if(lb.Community_Id__r.Name__c!=null)
            {
                if(lb.Community_Id__r.Name__c.length() > 35)
                {                    
                    lbCustom.CMName = lb.Community_Id__r.Name__c.substring(0,35) + '...';
                }
                else
                {
                    lbCustom.CMName = lb.Community_Id__r.Name__c;
                }
            }
            if(lb.Community_Id__r.description__c != null)
            {
                if(lb.Community_Id__r.description__c.length() > 75)
                {                    
                    lbCustom.CMDescription = lb.Community_Id__r.Description__c.substring(0,75) + '...';
                }
                else
                {
                    lbCustom.CMDescription=lb.Community_Id__r.description__c;
                }
            }
            If(RatedItemMap.containskey(lb.Community_Id__r.Id))
            {
                lbCustom.AvgRating = RatedItemMap.get(lb.Community_Id__r.Id);
            }
            else
            {
                lbCustom.AvgRating = 0;
            }
            lbCustom.IsActive = lb.Community_Id__r.IsActive__c;
            for(User userData:userImagesLst)
            {
                if(userData.Id == lb.Community_Id__r.Owner.Id)
                userImageUrl = userData.SmallPhotoUrl;
            }
            lbCustom.CMOwnerURL =  userImageUrl;
            lbCustom.id = lb.Community_Id__r.id;
            lbCustom.CMOwnerID = lb.Community_Id__r.Owner.Id;
            if(lb.Community_Id__r.Owner.Name != null)
            {
                if(lb.Community_Id__r.Owner.Name.length() > 20)
                {                    
                    lbCustom.CMOwnerName = lb.Community_Id__r.Owner.Name.substring(0,15) + '...';
                }
                else{
                    lbCustom.CMOwnerName =lb.Community_Id__r.Owner.Name;
                }
            } 
            if(lb.Community_Id__r.Owner.title != null)
            {
                lbCustom.CMOwnerTitle = lb.Community_Id__r.Owner.title;

                 if(lb.Community_Id__r.Owner.title.length() > 25)
                 {                            
                    lbCustom.CMOwnerTitle = lb.Community_Id__r.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.CMOwnerTitle = lb.Community_Id__r.Owner.title;
                 }
            }
            lbCustom.CMCrtDate = lb.Community_Id__r.CreatedDate;  
            lbCustom.CMNoOfComments =   CmntCntMap.get(lb.Community_Id__r.Id);
            if(lb.Community_Id__r.Default_Image_Name__c!='')
              {                        
                    lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lb.Community_Id__r.Default_Image_Name__c;          
              }
              lbCustom.StaticImage = true;
            for(Attachment att: attachmentList)
            {
                if(lb.Community_Id__r.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif'))
                {
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.CMId = att.ParentId;
                    lbCustom.StaticImage = false;
                }  
            }
            //UserContCMList.add(lbCustom);
            communityMembers.add(lbCustom);
            myCommunityMembers.add(lbCustom);
            system.debug('lbCustom------------------'+lbCustom);
        }
        system.debug('UserOwnedCmList:' + UserOwnedCmList.size());
        system.debug('communityMembers:' + communityMembers.size());
        system.debug('UserContCmList:' + UserContCmList.size());

         communityViewTotalCount = (CommunityMemberCount + UserContCmListCount + UserOwnedCmListCount);                
    }
        
    // START By Komala
    
    @RemoteAction
    public static String LogMetrics(string boardId,string boardName,string link,string tabSection,string operatingSystem,string browserVersion,string DeviceType)
    {  
        
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        //metricsObj.Text__c=strSearchValue;
        if(link.contains('AthenaUserProfile'))
        {
         //metricsObj.ActionType__c='People Hyperlink Click';
         metricsObj.ActionType__c='User Name Click';
        }
        else
        {
        metricsObj.ActionType__c='Hyperlink Click';
        }
        metricsObj.ObjectId__c=boardId;
        //metricsObj.ObjectName__c=boardName;        
        metricsObj.Text__c=boardName;
        metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='User Profile Page';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        if(link.contains('SLP_ViewCommunity') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Community Topic';
        }
        else if(link.contains('SLP_ViewCommunity'))
        {
        metricsObj.ObjectName__c='Community';
        metricsObj.ActionType__c='Community Name Click';
        }
        else if(link.contains('AthenaLearningBoardDtls') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Learning Board Topic';
        }  
        else if(link.contains('AthenaLearningBoardDtls'))
        {
        metricsObj.ObjectName__c='Learning Board';
        metricsObj.ActionType__c='Board Name Click';
        }        
        else if(link.contains('AthenaUserProfile'))
        {
        metricsObj.ObjectName__c='User Profile';
        }
        
        if(tabSection=='All Communities Image Click')
        {
        tabSection='All Communities Tab';
        //metricsObj.ActionType__c='All Communities Image Click';
        metricsObj.ActionType__c='Community Image Click';
        }
        if(tabSection == 'Communities Member Of Image Click'){
            tabSection = 'Communities Member Of Tab';
            metricsObj.ActionType__c = 'Community Image Click';
        }
        if(tabSection=='Communities Created Image Click')
        {
        tabSection='Communities Created Tab';
        //metricsObj.ActionType__c='Communities Created Image Click';
        metricsObj.ActionType__c='Community Image Click';
        }
        
        if(tabSection=='Communities Contributed Image Click')
        {
        tabSection='Communities Contributed Tab';
        //metricsObj.ActionType__c='Communities Contributed Image Click';
        metricsObj.ActionType__c='Community Image Click';
        }
        
        if(tabSection=='All Learning Boards Image Click')
        {
        tabSection='All Learning Boards Tab';
        //metricsObj.ActionType__c='All Learning Boards Image Click';
        metricsObj.ActionType__c='Board Image Click';
        }
        
        if(tabSection=='Learning Board Created Image Click')
        {
        tabSection='Learning Board Created Tab';
        //metricsObj.ActionType__c='Learning Board Created Image Click';
        metricsObj.ActionType__c='Board Image Click';
        }
        if(tabSection == 'Learning Boards Member Of Image Click'){
            tabSection='Learning Boards Member Of Tab';
            metricsObj.ActionType__c='Board Image Click';
        }
        if(tabSection=='Learning Board Contributed Image Click')
        {
        tabSection='Learning Board Contributed Tab';
        //metricsObj.ActionType__c='Learning Board Contributed Image Click';
        metricsObj.ActionType__c='Board Image Click';
        }
       
        metricsObj.DeviceType__c=DeviceType;
        metricsObj.TabSection__c=tabSection;
        Insert(metricsObj);
        //PageReference pRef = new PageReference('/apex/AthenaLearningBoardDtls');
        //pRef.getParameters().put('id',boardId);
        //pRef.setRedirect(true);
        //return pRef;        
        return link;
    }
    
    @RemoteAction
    public static void LogTabMetrics(string tabName,string operatingSystem,string browserVersion,string DeviceType)
    {
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        //metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Tab Click';
        //metricsObj.ObjectId__c=boardId;
        metricsObj.TabSection__c=tabName+' '+'Tab';
        //metricsObj.ActionPath__c=tabName+' '+'Tab';
        metricsObj.PageName__c='User Profile Page';
        metricsObj.DeviceType__c=DeviceType;
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        Insert(metricsObj);
    }    
   
    public PageReference RedirectToPage()
    {
    string url='';  
    string boardid='';    
     
    if(RedirectUrl.contains('id='))
    {
    url=RedirectUrl.substring(RedirectUrl.lastIndexOf('/')+1,RedirectUrl.indexOf('?'));
    boardid=RedirectUrl.substring(RedirectUrl.indexOf('=')+1,RedirectUrl.length());    
    } 

    if(RedirectUrl.contains('SLP_GlobalSearch'))
    {
     PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
     pRef.getParameters().put('SearchOptions','multiselect-all,Boards,Topics,Community,People');
     pRef.getParameters().put('SearchVal',RedirectUrl.substring(RedirectUrl.lastIndexOf('=')+1,RedirectUrl.length()));
     pRef.setRedirect(true);
     return pRef;
    }
    else if (RedirectUrl.contains('topicid'))
    {
     PageReference pRef = new PageReference('/apex/'+url);
     pRef.getParameters().put('id',RedirectUrl.substring(RedirectUrl.indexOf('=')+1,RedirectUrl.indexOf('&')));
     pRef.getParameters().put('topicid',RedirectUrl.substring(RedirectUrl.lastIndexOf('=')+1,RedirectUrl.length()));
     pRef.setRedirect(true);
     return pRef;
    }    
    else
    {
        PageReference pRef = new PageReference('/apex/'+url);
        pRef.getParameters().put('id',boardId);
        pRef.setRedirect(true);
        return pRef;
        }

    }
    
    // END By Komala
    
}