public class SLP_PostAndComment 
    {
    
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
        //public list<clsfeedcomment> lstFeedCmt {get;set;}
        public List<FeedComment> lstFCmt {get;set;}
    }
    public class ClsCommAndBoard
    {
      public string BoardOrCommId {get;set;}
      public string BoardOrCommNm {get;set;}
      public boolean IsCommunity {get;set;}
     public list<ClsFeedPost> ListFeedPost {get;set;}
    }

    public class MainData
    {
      public Id UserId {get;set;}
      public string UserName {get;set;}
     public List<ClsCommAndBoard> lstCommB {get;set;}
    }

    public class CommunityPostComment
    {
      
    }
    
    public User GetLoggedinUserDetails()
    {
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
    public List<ClsCommAndBoard> GenerateUserCommunityPostAndComments
    {
       get
       {
       List<ClsCommAndBoard> MapClsComm=new List<ClsCommAndBoard>();
        List<Community__Share> lstCommunityShare= [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where UserOrGroupId=:UserInfo.getUserId()];
        List<Community_Member__c> lstCommunityMember= [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c=:UserInfo.getUserId() and Status__c='Approved'];

        set<Id> setCommIds=new set<Id>();

        for(Community__Share comms:lstCommunityShare )
        {
          setCommIds.add(comms.ParentId);
        }
        
        for(Community_Member__c CommMem:lstCommunityMember )
        {
          setCommIds.add(CommMem.Community_Id__c);
        }
        
        List<Learning_Board__Share> lstLearningShare=[SELECT Id, ParentId, UserOrGroupId, AccessLevel, IsDeleted FROM Learning_Board__Share where UserOrGroupId=:UserInfo.getUserId() ];
        List<Learning_Board_Member__c> lstBrdMem= [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c ='Approved' and User_Id__c=:UserInfo.getUserId()];
        
        for(Learning_Board__Share ls:lstLearningShare)
        {
          setCommIds.add(ls.ParentId);
        }
        
        for(Learning_Board_Member__c  lbM:lstBrdMem)
        {
          setCommIds.add(lbM.Learning_Board_ID__c);
        }
        
        list<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedBy.name, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type='TextPost' AND ParentId=:setCommIds order by LastModifiedDate desc];
        List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where ParentId=:setCommIds order by CreatedDate desc];
        
        Map<ID,List<FeedItem>> MapFeedItm=new Map<ID,List<FeedItem>>();
        Map<ID,List<FeedComment>> MapFeedCmt=new Map<ID,List<FeedComment>>();
        set<Id> setParentIds=new set<Id>();
        set<Id> setCreateIds=new set<Id>();
        for(FeedItem FeedItm:lstFeedItem)
        {
          setParentIds.add(FeedItm.ParentId);
        }
        // List<PermissionSetAssignment> lstPermissionSetAssignment = [SELECT AssigneeId,Assignee.smallphotourl FROM PermissionSetAssignment WHERE AssigneeId IN (select id from user where isactive = true)
                                      // and (PermissionSet.name='ES_Social_Learning_Producer' or PermissionSet.name='ES_Social_Learning_Moderator' or PermissionSet.name='ES_Social_Learning_Consumer') ];

        // system.debug('lstPermissionSetAssignmentsize:'+lstPermissionSetAssignment.size());
        // system.debug('lstPermissionSetAssignment:'+lstPermissionSetAssignment);
        // //list<user> lstUsers=[select Id,smallphotourl from User];
        // Map<id,string> mapUsrPhoto=new Map<id,string>();
        // for(PermissionSetAssignment PSA: lstPermissionSetAssignment)
        // {
          // mapUsrPhoto.put(PSA.AssigneeId,PSA.Assignee.smallphotourl);
        // }
      
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
      
      for(FeedComment FeedCmt:lstFeedComment)
      {
            //setParentIds.add(FeedCmt.ParentId);
            setCreateIds.add(FeedCmt.CreatedById);
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
        
         for(FeedItem FeedItm:lstFeedItem)
          {
           ClsCommAndBoard clsComm=new ClsCommAndBoard();
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
                cFPs.PostName = FI.Body;
                cFPs.PostedUserId = FI.CreatedById;
                cFPs.PostedUserName = FI.CreatedBy.Name;
                cFPs.PostedDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                cFPs.UsrPhoto=MapUsr.get(FI.CreatedById);
                cFPs.PostLikes = FI.LikeCount;
                if(MapFeedCmt.containsKey(FI.Id))
                {
                  cFPs.lstFCmt = MapFeedCmt.get(FI.Id);
                }
                clsComm.ListFeedPost.add(cFPs);
              
             }
             
            MapClsComm.add(clsComm);
        }
        system.debug('MapClsComm:'+MapClsComm);
        return MapClsComm;
        }
        set;
        
    }
    }