global class MarkTestExtension 
{

public String AthenaUserId {get;set;}
public string hdnFeedItem {get;set;}
public string SelectedUsrs {get;set;}
public string hdnSharecmt {get;set;}
public string hdnBoardComm {get;set;}
public boolean IshdnComm {get;set;}
public boolean IsPublic {get;set;}
public string ActivitySequenceNo { get; set;}

 Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name,FullPhotoUrl,id From User where User.id= :UserInfo.getUserId()];
        return U;
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
    
    public User GetLoggedinUserDetails()
    {
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
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
       
        public List<clsBoard> DisplayBoards
    {
     get
       {
         List<clsBoard> lstBoard=new List<clsBoard>();
         string resourceURL= GetResourceURL('img_athena');
          set<id> setBoardIds=new set<id>();
          List<Learning_Board__Share> lstLearningShare=[SELECT Id, ParentId, UserOrGroupId, AccessLevel, IsDeleted FROM Learning_Board__Share where UserOrGroupId=:UserInfo.getUserId() ];
        List<Learning_Board_Member__c> lstBrdMem= [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c ='Approved' and User_Id__c=:UserInfo.getUserId()];
        
        for(Learning_Board__Share ls:lstLearningShare)
        {
          setBoardIds.add(ls.ParentId);
        }
        
        for(Learning_Board_Member__c  lbM:lstBrdMem)
        {
          setBoardIds.add(lbM.Learning_Board_ID__c);
        }
         
          List<Learning_Board__c> BoardResult = [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Featured__c,Owner.name,Owner.Id,Owner.title,CreatedDate from Learning_Board__c where id IN:setBoardIds];
           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :setBoardIds and ContentType in:AthenaUtility.ContentType()];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           } 
         
         for(Learning_Board__c Brd:BoardResult)
         {
         clsBoard clsBrd=new clsBoard();
         clsBrd.Id=Brd.id;
         if(Brd.Default_Image_Name__c!=''){                        
                        clsBrd.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +resourceURL+ '/img_athena/' + Brd.Default_Image_Name__c;         
                }
                
                clsBrd.StaticImage = true;

                if(AttMap.containskey(Brd.id))
                {
                    clsBrd.AttachmentId = AttMap.get(Brd.id);
                    clsBrd.StaticImage=false;
                }
                clsBrd.Name=Brd.Name__c;
         lstBoard.add(clsBrd);
         }
        return lstBoard;
       }
       set;
    }

       
       
    public List<clsCommunity> DisplayCommunity
    {
     get
       {
         List<clsCommunity> lstCommunity=new List<clsCommunity>();
         string resourceURL= GetResourceURL('img_athena');
         List<Community__Share> lstCommunityShare= [SELECT Id, ParentId,parent.name__c, UserOrGroupId, AccessLevel FROM Community__Share where UserOrGroupId=:UserInfo.getUserId()];
         List<Community_Member__c> lstCommunityMember= [SELECT Id, Community_Id__c,Community_Id__r.Name__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c=:UserInfo.getUserId() and Status__c='Approved'];
         set<id> setCommunityIds=new set<id>();
         for(Community__Share commshare:lstCommunityShare)
         {
           setCommunityIds.add(commshare.ParentId);
         }
         for(Community_Member__c commMem:lstCommunityMember)
         {
           setCommunityIds.add(commMem.Community_Id__c);
         }
         
         List<Community__c> commResult = [select Id,Name__c,description__c,Default_Image_Name__c,IsActive__c, Owner.name,Owner.Id,Owner.title,CreatedDate from Community__c where Id in:setCommunityIds];
         
           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :setCommunityIds and ContentType in:AthenaUtility.ContentType()];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           } 
         
         for(Community__c comm:commResult)
         {
         clsCommunity clscomm=new clsCommunity();
         clscomm.Id=comm.id;
         
         if(comm.Default_Image_Name__c!=''){                        
                        clscomm.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +resourceURL+ '/img_athena/' + comm.Default_Image_Name__c;         
                }
                
                clscomm.StaticImage = true;

                if(AttMap.containskey(comm.id))
                {
                    clscomm.AttachmentId = AttMap.get(comm.id);
                    clscomm.StaticImage=false;
                }
                clscomm.Name=comm.Name__c;
         lstCommunity.add(clscomm);
         }
        return lstCommunity;
       }
       set;
    }
    
    public String getMyJSON {
    get
    {
        return JSON.serializePretty(GenerateUserCommunityPostAndComments);
    }
    }
    
    public List<ClsCommAndBoard> GenerateUserCommunityPostAndComments
    {
       get
       {
       
     List<User> lstFollowers= [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:UserInfo.getUserId()) AND Id !=:UserInfo.getUserId()];
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
/*        for(Community__Share comms:lstCommunityShareFlw )
        {
          setCommIds.add(comms.ParentId);
        }
        
        for(Community_Member__c CommMem:lstCommunityMemberFlw )
        {
          setCommIds.add(CommMem.Community_Id__c);
        }
  */      
        
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
    
    
    
    @RemoteAction
    public static List<User> UserFollwerShare(string UserId)
    {
        string AthenaUsrId = UserInfo.getUserId();
        List<User> lstFollowersAndFollowing = new List<User>();
        set<Id> setmyNetworkUserIds = new set<Id>();

        List<user> followers = [SELECT Id FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUsrId) AND Id !=:UserId order by Name];
        List<user>  lstFollowing= [SELECT Id FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUsrId) AND Id !=:AthenaUsrId AND Id !=:UserId  order by name];

        for(user user : followers)
        {
            setmyNetworkUserIds.add(user.Id);
        }

        for(user user : lstFollowing)
        {
            setmyNetworkUserIds.add(user.Id);
        }
        
        List<user> lstFollowers = [SELECT Id, Name,Email, SmallPhotoUrl FROM User WHERE Id IN : setmyNetworkUserIds order by Name];

        return lstFollowers;
    }
    
   
    
    public void SharedComment()
    {
     // system.debug('hdnFeedItem:'+hdnFeedItem);
      // system.debug('SelectedUsrs:'+SelectedUsrs);
      // system.debug('hdnSharecmt:'+hdnSharecmt);

system.debug('hdnBoardComm:' + hdnBoardComm);
system.debug('IshdnComm:' + IshdnComm);

      
      
      String[] splitInput = SelectedUsrs.split(',');
      List<String> UsrIds = new List<String>( splitInput );
      
      List<User> lstUsers = [Select id, Name From User  where id in : UsrIds];

      //Map<string, string> mapUser = new Map<string, string>();
      
      //for(User usr: lstUsers)
      //{
      //  mapUser.put(usr.id, usr.Name);
      //}

     List<FeedItem> lstFI=new List<FeedItem>();
     FeedItem lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedBy.name,LinkUrl, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost') and Id=:hdnFeedItem  limit 1];
     system.debug('lstFeedItem:'+lstFeedItem);
     system.debug('lstFeedItemLinkUrl:'+lstFeedItem.LinkUrl);
     string sBody =lstFeedItem.Body;
      
      system.debug('lstFeedItemBody:'+lstFeedItem.Body);
      system.debug('sBody:'+sBody);
      
      if(lstFeedItem.Body.contains('#[Added Member]'))
    {
     sBody  =lstFeedItem.Body.replace('#[Added Member]','');
    }
    else if(lstFeedItem.Body.contains('#[Change Owner]'))
    {
    sBody =lstFeedItem.Body.replace('#[Change Owner]','');
    }
    else if(lstFeedItem.Body.contains('#[Added Content]'))
    {
     sBody =lstFeedItem.Body.replace('#[Added Content]','');
    }
    else if(lstFeedItem.Body.contains('#[Added Contributor]'))
    {
      sBody =lstFeedItem.Body.replace('#[Added Contributor]','');
    }
    else if(lstFeedItem.Body.contains('#Rating'))
    {
      sBody = lstFeedItem.Body.replace('#Rating','');
    }
    else if(lstFeedItem.Body.contains('#Follower'))
    {
      sBody = lstFeedItem.Body.replace('#Follower','');
    }
    else  if(lstFeedItem.Body.contains('#[Add Member]'))
    {
     sBody  =lstFeedItem.Body.replace('#[Add Member]','');
    }
    else
    {
      sBody =lstFeedItem.Body;
    }
    
    //         string BodyContent='';   
    // if(hdnSharecmt!='' && hdnSharecmt!=null)
    //{    
    //      BodyContent = UserInfo.getName()+' has shared to you ' + ' ' + '<br />' + + ' Comment:- ' + hdnSharecmt;
    //      if(PublicCmt!='')
    //      {
    //        BodyContent = BodyContent + '<br />' + PublicCmt;
    //      }
    //      BodyContent = BodyContent + '<br />' + sBody ;
    //}
    //else
    //{
    //    //BodyContent=UserInfo.getName()+' has shared to you' + ' '  + '<br />' + hdnSharecmt + '<br />' + PublicCmt + '<br />'+ sBody ;
    //    BodyContent=UserInfo.getName()+' has shared to you' + ' ' ;
    //    if(PublicCmt!='')
    //      {
    //        BodyContent = BodyContent + '<br />' + PublicCmt;
    //      }
    //      BodyContent = BodyContent + '<br />' + sBody ;    
        
    //}     
      //BodyContent=BodyContent.replaceAll('<br />','\n');

     //if((lstFeedItem.LinkUrl!='') && (lstFeedItem.LinkUrl!=null))
     //{
         
     // for(string strU: UsrIds)
     // {
     //   FeedItem FeedItm=new FeedItem();
       
     //   FeedItm.LinkUrl=lstFeedItem.LinkUrl;
     //   FeedItm.Title=lstFeedItem.Title;
        
     //   FeedItm.ParentId=strU;
        
     //   FeedItm.Body= BodyContent;
     //   lstFI.add(FeedItm);
     // }
     // insert lstFI;
     //}
     //else
     //{
     //for(string strU: UsrIds)
     // {
     //   FeedItem FeedItm=new FeedItem();
     //   FeedItm.ParentId=strU;
     //   FeedItm.Body= BodyContent;
     //   lstFI.add(FeedItm);
     // }
     // insert lstFI;
     //}
      boolean isPost = false;
      IsPublic = false;
      string PublicCmt='';
      if(IshdnComm)
      {
        List<community__c> communityC = [SELECT Public__c, Id, IsActive__c, Name__c, Featured__c FROM Community__c where Id=:hdnBoardComm limit 1 ];
        
        if(communityC.size () > 0)
        {
            IsPublic = communityC[0].Public__c;

            PublicCmt= 'Note:- If you are not a member of this Community: '+communityC[0].Name__c +', you will need to join in order to view the content';
        }
      }
      else
      {
        system.debug('hdnBoardComm:' + hdnBoardComm);
        
        List<Learning_Board__c> Board= [SELECT Id, Featured__c, Is_Active__c, Public__c, Name__c FROM Learning_Board__c where Id=:hdnBoardComm limit 1];
       
        if(Board.size() > 0)
        {
            IsPublic = Board[0].Public__c;

            if(!IsPublic)
            {
                PublicCmt= 'Note:- If you are not a member of this Board: '+Board[0].Name__c +', you will need to join in order to view the content';
            }
        }
        else
        {
            isPost = true;
        }
      }
   
   
        for(User usr : lstUsers)
        {
             string BodyContent='';   
    
             if(hdnSharecmt!='' && hdnSharecmt!=null)
             {    
                  BodyContent = UserInfo.getName() +' has shared to ' + usr.Name + ' ' + '<br />' + ' Comment:- ' + hdnSharecmt;

                if(isPost)
                    BodyContent = BodyContent + '<br /> <br />' + sBody;
                else
                    BodyContent = BodyContent + '<br />' + sBody ;

                if(PublicCmt!='')
                {
                    BodyContent = BodyContent + '<br />' + PublicCmt;
                }
                
             }
             else
             {
                BodyContent=UserInfo.getName()+' has shared to '+ usr.Name + ' ' ;

                if(isPost)
                    BodyContent = BodyContent + '<br /> <br />' + sBody;
                else
                    BodyContent = BodyContent + '<br />' + sBody ;


                if(PublicCmt!='')
                {
                    BodyContent = BodyContent + '<br />' + PublicCmt;
                }
             }  
   
             BodyContent=BodyContent.replaceAll('<br />','\n');

            
            FeedItem FeedItm=new FeedItem();
       
            if((lstFeedItem.LinkUrl!='') && (lstFeedItem.LinkUrl!=null))
            {
                FeedItm.LinkUrl = lstFeedItem.LinkUrl;
                FeedItm.Title = lstFeedItem.Title;
                
            }
            FeedItm.ParentId = usr.id;
            FeedItm.Body = BodyContent;
                    
            lstFI.add(FeedItm);
        }
        insert lstFI;
    }
}