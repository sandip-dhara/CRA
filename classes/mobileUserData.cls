global with sharing class mobileUserData {
     public String UserId { get; set; }
     public Integer followersCount{get;set;}
     public User user{get;set;}
     public integer myBoardsCount{get;set;} 
     public integer myBoardsContributedCount{get;set;}
     
    
     public mobileUserData(SLP_Activity controller) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
    }

    public mobileUserData (AthenaUserProfile controller) {
        UserId = controller.AthenaUserId;
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
    }
    
    public mobileUserData (MarkTestApex controller) {
        UserId = controller.AthenaUserId;
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
    }

    
    public mobileUserData (AthenaSocialLearning controller) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
    }
    
     public mobileUserData (AthenaLearningBoardDtls controller) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
    }
    
    public mobileUserData (SLP_GlobalSearch stdController) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        
    }
    
    public mobileUserData (SLPM_ExpertSearchController stdController) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        
    }
    
    
    public mobileUserData (ApexPages.StandardController stdController) {
        UserId = UserInfo.getUserId();
        GetUserProfileDetails();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        
    }
   
    public void GetUserProfileDetails() {
        User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone From User u where u.id =:UserId];
        List<EntitySubscription> entsub1=[SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:u.id LIMIT 900];
        List<EntitySubscription> entsub2=[SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id LIMIT 900];
        set<ID> subsetid = new set<id>();
        set<ID> parentsetid = new set<id>();
        for (entitysubscription etsb1 :entsub2){
            subsetid.add(etsb1.subscriberId);            
        }
        for(entitysubscription etsb2 :entsub1){
            parentsetid.add(etsb2.ParentId);
        }
        List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id =:subsetid order by Name ];     

        List<User> following = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id =:parentsetid AND Id !=:u.id order by name];  
        followersCount = followers.size();
        //followingCount = following.size();
        
         system.debug('followersCount = '+ followersCount );
         system.debug('followingCount = '+ followingCount );
    }
   
   public Integer followingCount{
    get {
         User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone From User u where u.id =:UserId];
        List<EntitySubscription> entsub1=[SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:u.id LIMIT 900];
        List<EntitySubscription> entsub2=[SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id LIMIT 900];
        set<ID> subsetid = new set<id>();
        set<ID> parentsetid = new set<id>();
        for (entitysubscription etsb1 :entsub2){
            subsetid.add(etsb1.subscriberId);            
        }
        for(entitysubscription etsb2 :entsub1){
            parentsetid.add(etsb2.ParentId);
        }
        List<User> following = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id =:parentsetid AND Id !=:u.id order by name LIMIT 900];
        return following.size();
    }
}
    
    Public void GetUserOwnedLBList(List<Learning_Board__c> LearningBoards)
{
            //UserOwnedLBList.clear();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            
            myBoardsCount=learningBoardIds.size();      
            //return UserOwnedLBList;
        }
        
     Public void GetUserContLbList(List<Learning_Board__c> LearningBoards)
    {
             
            list<id> learningBoardIds= new list<id>();  

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            
            myBoardsContributedCount=learningBoardIds.size();
            //return UserContLbList;
    }   
        
        
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
    
    Public ApexPages.standardSetController UserOwnedCon{    
        get{
            
            if(UserOwnedCon == null && UserId==userinfo.getuserid())
            {  
                UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:UserId]));                           
                //UserOwnedCon.setPageSize(4);
            } 
            else if(UserOwnedCon == null && UserId!=userinfo.getuserid()) 
            { 
            UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:UserId]));                           
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
                lbs=[SELECT ParentId FROM Learning_Board__Share where AccessLevel='Edit' and UserOrGroupId=:UserId];

                if(lbs!=null)
                {
                    for(Learning_Board__Share lbsloop:lbs)
                    {
                        lbsid.add(lbsloop.ParentId);
                    }
                }
                if(UserId==userinfo.getuserid())
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
    
    
/** Code for a users Activity Feed **/

/*    
    public String getUserCommunityPostAndCommentsJSON {
        get
        {
            return JSON.serializePretty(GenerateUserCommunityPostAndComments);
        }
    }

    
    public List<ClsCommAndBoard> GenerateUserCommunityPostAndComments
    {
       get
       {
       
     List<User> lstFollowers= [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:UserInfo.getUserId()) AND Id !=:UserInfo.getUserId() LIMIT 900];
     set<Id> setFollowers=new set<Id>();
       for(User usr:lstFollowers)
       {
         setFollowers.add(usr.Id);
       }
       
       List<ClsCommAndBoard> MapClsComm=new List<ClsCommAndBoard>();
        List<Community__Share> lstCommunityShare= [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where UserOrGroupId=:UserInfo.getUserId()];
        List<Community_Member__c> lstCommunityMember= [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where (User_Id__c=:UserInfo.getUserId()) and (Status__c='Approved') ];

        List<Community__Share> lstCommunityShareFlw= [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where  UserOrGroupId in: setFollowers];
        List<Community_Member__c> lstCommunityMemberFlw= [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where  (Status__c='Approved') and (User_Id__c in: setFollowers)];
        set<Id> setCommIds=new set<Id>();

        for(Community__Share comms:lstCommunityShare )
        {
          setCommIds.add(comms.ParentId);
        }
        
        for(Community_Member__c CommMem:lstCommunityMember )
        {
          setCommIds.add(CommMem.Community_Id__c);
        }
*/        
/*        for(Community__Share comms:lstCommunityShareFlw )
        {
          setCommIds.add(comms.ParentId);
        }
        
        for(Community_Member__c CommMem:lstCommunityMemberFlw )
        {
          setCommIds.add(CommMem.Community_Id__c);
        }
  */      
/*        
        List<Learning_Board__Share> lstLearningShare=[SELECT Id, ParentId, UserOrGroupId, AccessLevel, IsDeleted FROM Learning_Board__Share where UserOrGroupId=:UserInfo.getUserId()];
        List<Learning_Board_Member__c> lstBrdMem= [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c ='Approved' and User_Id__c=:UserInfo.getUserId() ];
        
        List<Learning_Board__Share> lstLearningShareFlw=[SELECT Id, ParentId, UserOrGroupId, AccessLevel, IsDeleted FROM Learning_Board__Share where  UserOrGroupId in:setFollowers ];
        List<Learning_Board_Member__c> lstBrdMemFlw= [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c ='Approved' and  User_Id__c in:setFollowers];
           set<Id> setCommUsrIds=new set<Id>();
        for(Learning_Board__Share ls:lstLearningShare)
        {
          setCommIds.add(ls.ParentId);
        }
        
        for(Learning_Board_Member__c  lbM:lstBrdMem)
        {
          setCommIds.add(lbM.Learning_Board_ID__c);
        }
  */      
    /*    for(Learning_Board__Share ls:lstLearningShareFlw)
        {
        setCommUsrIds.add(ls.UserOrGroupId);
          setCommIds.add(ls.ParentId);
        }
        
        for(Learning_Board_Member__c  lbM:lstBrdMemFlw)
        {
        setCommUsrIds.add(lbM.User_Id__c);
          setCommIds.add(lbM.Learning_Board_ID__c);
        }
      */  
        //list<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedBy.name,LinkUrl, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost') AND (CreatedById=:setCommUsrIds or ParentId=:UserInfo.getUserId() or ParentId=:setCommIds or ParentId in:setFollowers) order by LastModifiedDate desc limit 999];
        //List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where (CreatedById=:setCommUsrIds or ParentId=:UserInfo.getUserId() or ParentId=:setCommIds) order by CreatedDate desc limit 999];
/*        
        set<Id> setFollowerCommentId=new set<Id>();
        List<FeedComment> lstFollowerComment =[SELECT Id, FeedItemId FROM FeedComment where CreatedById in:setFollowers order by CreatedDate desc limit 999];
        for(FeedComment  Cmnt:lstFollowerComment)
        {
        setFollowerCommentId.add(Cmnt.FeedItemId);
          
        }
        
        
        list<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedBy.name,LinkUrl, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost') AND (ParentId=:UserInfo.getUserId() or ParentId=:setCommIds or CreatedById in:setFollowers or id in:setFollowerCommentId) AND (CreatedById !=: UserInfo.getUserId()) order by LastModifiedDate desc limit 999];
        List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where (ParentId=:UserInfo.getUserId() or ParentId=:setCommIds or CreatedById in:setFollowers) AND (CreatedById !=: UserInfo.getUserId()) order by CreatedDate desc limit 999];
        
        Map<ID,List<FeedItem>> MapFeedItm=new Map<ID,List<FeedItem>>();
        Map<ID,List<FeedComment>> MapFeedCmt=new Map<ID,List<FeedComment>>();
        set<Id> setParentIds=new set<Id>();
        set<Id> setCreateIds=new set<Id>();
        for(FeedItem FeedItm:lstFeedItem)
        {
          setParentIds.add(FeedItm.ParentId);
        }
              
      for(FeedItem FItem:lstFeedItem)
      {
        setCreateIds.add(FItem.CreatedById);
      }
      
       
      for(FeedComment FComment:lstFeedComment)
      {
        setCreateIds.add(FComment.CreatedById);
      }
      
      list<user> lstUsrs=[select Id,smallphotourl From User where Id=:setCreateIds];
      Map<id,string> MapUsr=new Map<id,string>(); 
      for(user usrs:lstUsrs)
      {
        MapUsr.put(usrs.Id,usrs.smallphotourl);
      }
      List<CommunityPostComment> lstPc=new List<CommunityPostComment>();
      for(FeedComment FeedCmt:lstFeedComment)
      {
      setCreateIds.add(FeedCmt.CreatedById);
        CommunityPostComment CPC=new CommunityPostComment();
          CPC.FeedItemId=FeedCmt.FeedItemId;
          CPC.CommentId=FeedCmt.Id;
          CPC.CommentName=FeedCmt.CommentBody;
          CPC.CommentedUserId=FeedCmt.CreatedById;
          CPC.CommentedDate=FeedCmt.CreatedDate;
          //CPC.CommentedLikes=FeedCmt.Id;
          CPC.CmtUsrPhoto=MapUsr.get(FeedCmt.CreatedById);
          CPc.CmtUserNm=FeedCmt.CreatedBy.name;  
          lstPc.add(CPC);
      }
      Map<ID,List<CommunityPostComment>> MapCustomFeedCmt=new Map<ID,List<CommunityPostComment>>();
      
      for(CommunityPostComment CPComm: lstPc)
      {
        if(MapCustomFeedCmt.containsKey(CPComm.FeedItemId))
        {
          List<CommunityPostComment> lstCPost=new List<CommunityPostComment>();
          lstCPost=MapCustomFeedCmt.get(CPComm.FeedItemId);
          lstCPost.add(CPComm);
          MapCustomFeedCmt.put(CPComm.FeedItemId,lstCPost);
          
        }
        else
        {
          List<CommunityPostComment> lstCPost=new List<CommunityPostComment>();
          lstCPost.add(CPComm);
          MapCustomFeedCmt.put(CPComm.FeedItemId,lstCPost);
        }
      }
      
      for(FeedComment FeedCmt:lstFeedComment)
      {
            //setParentIds.add(FeedCmt.ParentId);
           // setCreateIds.add(FeedCmt.CreatedById);
            if(MapFeedCmt.ContainsKey(FeedCmt.FeedItemId))
            {
                List<FeedComment> lstFCs=MapFeedCmt.get(FeedCmt.FeedItemId);
                lstFCs.add(FeedCmt);
                MapFeedCmt.put(FeedCmt.FeedItemId,lstFCs);
            }
            else
            {
                List<FeedComment> lstFC=new List<FeedComment>();
                lstFC.add(FeedCmt);
                MapFeedCmt.put(FeedCmt.FeedItemId,lstFC);
            }
            
        }
        
        Map<Id,string> MapCommNm=new Map<Id,string>();
        List<Community__c> lstComm=[select Id,Name__c From Community__c where Id in: setParentIds];
        system.debug('lstComm:'+lstComm.size());
        for(Community__c commc: lstComm)
        {
          MapCommNm.put(commc.Id,commc.Name__c);
        }
        
        Map<Id,string> MapBoardNm=new Map<Id,string>();
        List<Learning_Board__c> lstBoard=[select Id,Name__c From Learning_Board__c where Id in: setParentIds];
        system.debug('lstBoard:'+lstBoard.size());
        for(Learning_Board__c Brdc: lstBoard)
        {
          MapBoardNm.put(Brdc.Id,Brdc.Name__c);
        }
         
        integer sequnceNumber = 1;

         for(FeedItem FeedItm:lstFeedItem)
          {
           ClsCommAndBoard clsComm=new ClsCommAndBoard();

            clsComm.SequenceNo ='Activity_'+ sequnceNumber;

             clsComm.BoardOrCommId=FeedItm.ParentId;
             if(MapCommNm.containsKey(FeedItm.ParentId))
             {
                  clsComm.BoardOrCommNm='Community:'+MapCommNm.get(FeedItm.ParentId);
                  clsComm.IsCommunity=true;
             }
             if(MapBoardNm.containsKey(FeedItm.ParentId))
             {
               clsComm.BoardOrCommNm='Board:'+MapBoardNm.get(FeedItm.ParentId);
               clsComm.IsCommunity=false;
             }
             clsComm.ListFeedPost=new list<ClsFeedPost> ();
             
             //list<FeedItem> lstFI= MapFeedItm.get(FeedItm.ParentId);
             list<FeedItem> lstFI=new list<FeedItem>();
             lstFI.add(FeedItm);
             for(FeedItem FI: lstFI)
             {
                ClsFeedPost cFPs=new ClsFeedPost();
                DateTime d = FI.CreatedDate;

                cFPs.PostId = FI.Id;
                string strPost=FI.Body;
                                
    if(strPost.contains('#[Added Member]'))
    {
     cFPs.PostName  =strPost.replace('#[Added Member]','');
    }
    else if(strPost.contains('#[Change Owner]'))
    {
     cFPs.PostName  =strPost.replace('#[Change Owner]','');
    }
    else if(strPost.contains('#[Added Content]'))
    {
     cFPs.PostName  =strPost.replace('#[Added Content]','');
    }
    else if(strPost.contains('#[Added Contributor]'))
    {
      cFPs.PostName =strPost.replace('#[Added Contributor]','');
    }
    else if(strPost.contains('#Rating'))
    {
      cFPs.PostName = strPost.replace('#Rating','');
    }
    else if(strPost.contains('#Follower'))
    {
      cFPs.PostName = strPost.replace('#Follower','');
    }
    else if(strPost.contains('#[Add Member]'))
    {
     cFPs.PostName  =strPost.replace('#[Add Member]','');
    }
    else
    {
      cFPs.PostName = strPost;
    }
                
                cFPs.PostedUserId = FI.CreatedById;
                cFPs.PostedUserName = FI.CreatedBy.Name;
                cFPs.PostedDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                cFPs.UsrPhoto=MapUsr.get(FI.CreatedById);
                cFPs.PostLikes = FI.LikeCount;
                cFPs.LinkUrl=FI.LinkUrl;
                cFPs.Title=FI.Title;
                if((FI.LinkUrl!='' )&& (FI.LinkUrl!=null ))
                {
                
                cFPs.IsLink=true;
                }
                else
                {
                 cFPs.IsLink=false;
                
                }
                
                if(MapCustomFeedCmt.containsKey(FI.Id))
                {
                  cFPs.lstPostComment = MapCustomFeedCmt.get(FI.Id);
                }
                clsComm.ListFeedPost.add(cFPs);
              
             }
             
            MapClsComm.add(clsComm);

            sequnceNumber = sequnceNumber + 1;
        }
        system.debug('MapClsComm:'+MapClsComm);
        return MapClsComm;
        }
        set;
        
    }
    
  public class ClsCommAndBoard
    {
      public string SequenceNo { get; set; }
      public string BoardOrCommId {get;set;}
      public string BoardOrCommNm {get;set;}
      public boolean IsCommunity {get;set;}
     public list<ClsFeedPost> ListFeedPost {get;set;}
    }

    public class clsCommunity
    {
    Public id AttachmentId{get;set;}
      public string Id {get;set;}
      Public boolean StaticImage{get;set;}
      Public String DefaultImageName{get;set;}
      public string Name {get;set;}
    }
    
    public class clsBoard
    {
    Public id AttachmentId{get;set;}
      public string Id {get;set;}
      Public boolean StaticImage{get;set;}
      Public String DefaultImageName{get;set;}
      public string Name {get;set;}
    }
    
    public class MainData
    {
      public Id UserId {get;set;}
      public string UserName {get;set;}
     public List<ClsCommAndBoard> lstCommB {get;set;}
    }

    public class CommunityPostComment
    {
        public string FeedItemId {get;set;}
        public Id CommentId {get;set;}
        public string CommentName {get;set;}
        public string CommentedUserId {get;set;}
        public string CommentedUserName {get;set;}
        public DateTime CommentedDate {get;set;}
        public integer  CommentedLikes {get;set;}
        public string CmtUsrPhoto {get;set;}
        public string CmtUserNm {get;set;}
    }
 
 public class ClsFeedComment
    {
        //public string ParentId {get;set;}
        public string FeedItemId {get;set;}
        public string Comment {get;set;}
        public string  CommentedUserId {get;set;}
        public string CommentedUserName {get;set;}
        public Datetime CommentedDate {get;set;}
    }

    public class ClsFeedPost
    {
        //public string ParentId {get;set;}
        //public string ParentName {get;set;}
        public string PostId {get;set;}
        public string PostName {get;set;}
        public string PostedUserId {get;set;}
        public string PostedUserName {get;set;}
        public string PostedDate {get;set;}
        public integer  PostLikes {get;set;}
        public string UsrPhoto {get;set;}
        public string LinkUrl {get;set;}
        public string Title {get;set;}
        public boolean IsLink {get;set;}
        //public list<clsfeedcomment> lstFeedCmt {get;set;}
        public List<FeedComment> lstFCmt {get;set;}
        public List<CommunityPostComment> lstPostComment {get;set;}
    }   
    */
    public List<String> getListExpertise {
        get
        {
            List<String> l = new List<String>();

            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[
                SELECT 
                    SLP_Expert__c.ES_User_ID__r.User_Id__c, 
                    SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
                    SLP_Expert__c.SLP_Secondary_Industry_Id__r.Industry_Name__c,
                    SLP_Expert__c.Is_Expert__c
                FROM 
                    SLP_Expert__c
                WHERE
                    SLP_Expert__c.ES_User_ID__r.User_Id__c =: UserId
                ];

            for (SLP_Expert__c ex : lstExpert) {
                l.add(ex.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C);
            }
            return l;
        }
    }
    
        public static String getListExpertise(String param) {
            List<String> l = new List<String>();
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[
                SELECT 
                    SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
                    SLP_Expert__c.Is_Expert__c
                FROM 
                    SLP_Expert__c
                WHERE
                    SLP_Expert__c.ES_User_ID__r.User_Id__c =: param 
                ];
    
            for (SLP_Expert__c ex : lstExpert) {
                l.add(ex.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C);
                //l.add(JSON.serialize({"area":" + ex.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C + ","isExpert":" + ex.Is_Expert__c + "}));
            }
            return JSON.serialize(lstExpert);//JSON.serialize(l);
        }
   
    @remoteAction
    global static List<String> getListExpertiseJSON2(String aa){
        return new List<String>();        
        //return getListExpertise(aa);
    }
    
    @RemoteAction
    global static String getUserInfo(String param) {
        //String j = '{"expertise":["Automation","SF"],"name": "Veeresh"}';
        
        User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone From User u where u.id =:param];
        List<EntitySubscription> entsub1=[SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:u.id LIMIT 900];
        List<EntitySubscription> entsub2=[SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id LIMIT 900];
        set<ID> subsetid = new set<id>();
        set<ID> parentsetid = new set<id>();
        for (entitysubscription etsb1 :entsub2){
            subsetid.add(etsb1.subscriberId);            
        }
        for(entitysubscription etsb2 :entsub1){
            parentsetid.add(etsb2.ParentId);
        }
        List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id =:subsetid order by Name LIMIT 900];     

        List<User> following = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id =:parentsetid AND Id !=:u.id order by name LIMIT 900];  
        Integer followersCount = followers.size();
        Integer followingCount = following.size();

        ApexPages.standardSetController UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:u.id]));                           

        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords();
        //List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();

            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            

            for (Learning_Board__c lb: LearningBoardsOwned)
            {
                learningBoardIds.add(lb.id);
            }
            
            Integer myBoardsCount=learningBoardIds.size();      

        
        
            List<Learning_Board__Share> lbs=new List<Learning_Board__Share>();
                List<Id> lbsid=new List<Id>();
                lbs=[SELECT ParentId FROM Learning_Board__Share where AccessLevel='Edit' and UserOrGroupId=:param];

                if(lbs!=null)
                {
                    for(Learning_Board__Share lbsloop:lbs)
                    {
                        lbsid.add(lbsloop.ParentId);
                    }
                }
        
            ApexPages.standardSetController UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Is_Active__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and id In:lbsid]));                           
            list<id> learningBoardIds2= new list<id>();  
            List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();

            for (Learning_Board__c lb: LearningBoardsContributed)
            {
                learningBoardIds2.add(lb.id);
            }
            
            Integer myBoardsContributedCount=learningBoardIds2.size();

        
        
        String j = '{"expertise":' + getListExpertise(param) + ',"name": "' + u.name + '","followers":"'+ followersCount +'", "following":"' + followingCount+ '", "authoredBoards":"'+ myBoardsCount +'", "contributedBoards":"'+ myBoardsContributedCount +'", "img":"'+ u.FullPhotoUrl +'"}';
        return j;
    }
}