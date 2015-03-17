public class Suman_SLP_DailyDigest {

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
        //public list<ClsFeedComment> lstFeedCmt {get;set;}
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
     
    
public Map<Id,string> getDailyDiggest()
{
    Map<Id,string> lstDailyDiggest=new Map<Id,string>();
    list<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type='TextPost' and LastModifiedDate>=N_DAYS_AGO:0 order by LastModifiedDate desc];
    List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where CreatedDate>=N_DAYS_AGO:0 order by CreatedDate desc];
    set<ID> setParentIds=new set<ID>();
    set<ID> setCreateIds=new set<ID>();
    Map<ID,List<FeedItem>> MapFeedItm=new Map<ID,List<FeedItem>>();
    Map<ID,List<FeedComment>> MapFeedCmt=new Map<ID,List<FeedComment>>();
    system.debug('lstFeedItem:'+lstFeedItem);
    system.debug('lstFeedComment:'+lstFeedComment);
    for(FeedItem FeedItm:lstFeedItem)
    {
        setParentIds.add(FeedItm.ParentId);
        setCreateIds.add(FeedItm.CreatedById);

        if(MapFeedItm.ContainsKey(FeedItm.ParentId))
        {
            List<FeedItem> lstFIs=MapFeedItm.get(FeedItm.ParentId);
            lstFIs.add(FeedItm);
            MapFeedItm.put(FeedItm.ParentId,lstFIs);
        }
        else
        {
            List<FeedItem> lstFI=new List<FeedItem>();
            lstFI.add(FeedItm);
            MapFeedItm.put(FeedItm.ParentId,lstFI);
        }
        
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
        system.debug('MapFeedCmt:'+MapFeedCmt.size());
        system.debug('setParentIds:'+setParentIds);
    system.debug('setCreateIds:'+setCreateIds);
        Map<Id,string> MapCommNm=new Map<Id,string>();
        Map<Id,string> MapBoardNm=new Map<Id,string>();
        
        List<Community__c> lstComm=[select Id,Name__c From Community__c where Id in: setParentIds];
        system.debug('lstComm:'+lstComm.size());
        for(Community__c commc: lstComm)
        {
          MapCommNm.put(commc.Id,commc.Name__c);
        }
        
        List<Learning_Board__c> lstLB= [SELECT Id, Name__c FROM Learning_Board__c where Id in: setParentIds];
        for(Learning_Board__c LBC: lstLB)
        {
          MapBoardNm.put(LBC.Id,LBC.Name__c);
        }
        system.debug('lstLB:'+lstLB.size());
        List<User> lstUsers= [SELECT Id, Name FROM User where Id in : setCreateIds];
        Map<Id,string> MapUsers=new Map<Id,string>();
        
        for(User users:lstUsers)
        {
          MapUsers.put(users.Id,users.Name);
        }
        
        // List<User> lstUsersT= [SELECT Id, Name FROM User];
        // Map<Id,string> MapLstUser=new Map<Id,string>();
        
        // for(User users:lstUsersT)
        // {
          // MapLstUser.put(users.Id,users.Name);
        // }
        
        List<Community__Share> lstCommunityShare=  [SELECT Id, ParentId, UserOrGroupId FROM Community__Share where ParentId in:setParentIds ];
        list<Community_Member__c> lstCommunityMem =[SELECT Id, Community_Id__c, User_Id__c FROM Community_Member__c where Community_Id__c in: setParentIds and Status__c='Approved'];
        List<Learning__Share> lstLearningShare =[SELECT Id, ParentId, UserOrGroupId FROM Learning__Share where ParentId in: setParentIds];
        List<Learning_Board_Member__c> lstBoardMem=[SELECT Id, Learning_Board_ID__c, User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c in:setParentIds and Status__c='Approved' ];
        system.debug('lstCommunityShare:'+lstCommunityShare.size());
        system.debug('lstCommunityMem:'+lstCommunityMem.size());
        system.debug('lstLearningShare:'+lstLearningShare.size());
        system.debug('lstBoardMem:'+lstBoardMem.size());
        Map<Id,List<Id>> MapUserCB=new Map<Id,List<Id>>();  
        set<Id> setUsersId=new set<Id>();
        for(Community__Share CShare:lstCommunityShare)
        {
        setCreateIds.add(CShare.UserOrGroupId);
        setUsersId.add(CShare.UserOrGroupId);
         if(MapUserCB.containsKey(CShare.UserOrGroupId))
         {
            List<Id> listIDs= MapUserCB.get(CShare.UserOrGroupId);
            listIDs.add(CShare.ParentId);
            MapUserCB.put(CShare.UserOrGroupId,listIDs);
         }
         else
         {
         List<Id> lstId=new  List<Id>();
         lstId.add(CShare.ParentId);
           MapUserCB.put(CShare.UserOrGroupId,lstId);
         }
         
         
        }
        
        for(Community_Member__c CMember:lstCommunityMem)
        {
        setCreateIds.add(CMember.User_Id__c);
        setUsersId.add(CMember.User_Id__c);
         if(MapUserCB.containsKey(CMember.User_Id__c))
         {
            List<Id> listIDs= MapUserCB.get(CMember.User_Id__c);
            listIDs.add(CMember.Community_Id__c);
            MapUserCB.put(CMember.User_Id__c,listIDs);
         }
         else
         {
          List<Id> lstId=new  List<Id>();
         lstId.add(CMember.Community_Id__c);
           MapUserCB.put(CMember.User_Id__c,lstId);
         }
         
        }
        
        
        for(Learning__Share CShare:lstLearningShare)
        {
        setCreateIds.add(CShare.UserOrGroupId);
        setUsersId.add(CShare.UserOrGroupId);
         if(MapUserCB.containsKey(CShare.UserOrGroupId))
         {
            List<Id> listIDs= MapUserCB.get(CShare.UserOrGroupId);
            listIDs.add(CShare.ParentId);
            MapUserCB.put(CShare.UserOrGroupId,listIDs);
         }
         else
         {
         List<Id> lstId=new  List<Id>();
         lstId.add(CShare.ParentId);
           MapUserCB.put(CShare.UserOrGroupId,lstId);
         }
         
        }
        
        for(Learning_Board_Member__c CMember:lstBoardMem)
        {
        setCreateIds.add(CMember.User_Id__c);
        setUsersId.add(CMember.User_Id__c);
         if(MapUserCB.containsKey(CMember.User_Id__c))
         {
            List<Id> listIDs= MapUserCB.get(CMember.User_Id__c);
            listIDs.add(CMember.Learning_Board_ID__c);
            MapUserCB.put(CMember.User_Id__c,listIDs);
         }
         else
         {
          List<Id> lstId=new  List<Id>();
         lstId.add(CMember.Learning_Board_ID__c);
           MapUserCB.put(CMember.User_Id__c,lstId);
         }
         
        }
        
        list<user> lstuserst= [select id, name from user where id in: setcreateids ];
         map<id,string> maplstuser=new map<id,string>();
        
         for(user users:lstuserst)
         {
         maplstuser.put(users.id,users.name);
         }
        
        Map<Id,ClsCommAndBoard> MapClsComm=new Map<Id,ClsCommAndBoard>();
    
        for(Id pId : setParentIds)
        {
             ClsCommAndBoard clsComm=new ClsCommAndBoard();
             clsComm.BoardOrCommId=pId;
             if(MapCommNm.containsKey(pId))
             {
                  clsComm.BoardOrCommNm=MapCommNm.get(pId);
                  clsComm.IsCommunity=true;
             }
             else
             {
                 clsComm.BoardOrCommNm=MapBoardNm.get(pId);
                 clsComm.IsCommunity=false;
             }
             clsComm.ListFeedPost=new list<ClsFeedPost> ();
             
             list<FeedItem> lstFI= MapFeedItm.get(pId);

             for(FeedItem FI: lstFI)
             {
                ClsFeedPost cFPs=new ClsFeedPost();
                DateTime d = FI.CreatedDate;

                cFPs.PostId = FI.Id;
                cFPs.PostName = FI.Body;
                cFPs.PostedUserId = FI.CreatedById;
                cFPs.PostedUserName = MapLstUser.get(FI.CreatedById);
                cFPs.PostedDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                 
                cFPs.PostLikes = FI.LikeCount;
                if(MapFeedCmt.containsKey(FI.Id))
                {
                  cFPs.lstFCmt = MapFeedCmt.get(FI.Id);
                }
                clsComm.ListFeedPost.add(cFPs);
              
             }
             
            MapClsComm.put(pId,clsComm);
        }
    
    List<MainData> lstClsComm=new List<MainData>();
    for( Id UIds:setUsersId)
    {
        MainData mData=new MainData();
        mData.UserId=UIds;
        mData.lstCommB=new List<ClsCommAndBoard>();
        List<ClsCommAndBoard> lstBords=new List<ClsCommAndBoard>();
        //mData.UserName='';
        mData.UserName = MapLstUser.get(UIds);
    //List<ClsCommAndBoard> LstclsComm=new List<ClsCommAndBoard>();
     List<Id> lstCBId=MapUserCB.get(UIds);
     system.debug('lstCBId:'+lstCBId);
         for(Id CBIds: lstCBId)
         {
             ClsCommAndBoard clsComm=new ClsCommAndBoard();

             clsComm= MapClsComm.get(CBIds);
             system.debug('clsComm:'+clsComm);
             lstBords.add(clsComm);
         }
         mData.lstCommB=lstBords;
     lstClsComm.add(mData);
    }
        system.debug('lstClsComm:'+lstClsComm.size());
        system.debug('lstClsComm:'+lstClsComm);
        
        string hostName = AthenaUtility.ApplicationSettingValue('HostName');

        //string hostName = 'https://hp--esit--c.cs11.visual.force.com/apex/';

        for(MainData MDD:lstClsComm)
        {
           string bodyString = '';
           
           bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important; background: #fbf9f7;" width: 99%;><p>&nbsp;</p>';
           bodyString += '<div style="width: 80%; margin: 0 auto; height: auto;"><div style=" width: 98%; border: 1px solid #dedede; padding: 2%; font-size: 17px; margin-top: 30px;">';
           bodyString += '<h1 style="font-size: 25px; font-weight: normal; margin: 0;">Social Learning Platform</h1>';
           bodyString += '<h2 style="font-size: 25px; font-weight: normal; margin: 0; font-size: 20px">HP Enterprise Services</h2>';
           bodyString += '<div style="margin-top: 10px;"> Hi <span style="color: #F51666;"><a href="'+ hostName +'AthenaUserProfile?id='+ MDD.UserId +'">'+ MDD.UserName +'</a></span> your Daily Digest </div></div>';
         
         if(MDD.lstCommB!=null)
         {
             for(ClsCommAndBoard clsCBAdd:MDD.lstCommB)
             {
                 if(clsCBAdd.IsCommunity == true)
                     bodyString += '<span style="border: 1px solid #dedede; border-bottom: none !important; background: #fbf9f7; padding: 10px; margin-top: 20px; font-size: 16px; color: #4A8BC2; -moz-border-radius-topleft: 4px;   border-top-left-radius: 4px; -moz-border-radius-topright: 4px; border-top-right-radius: 4px; clear: both; display: inline-block;"><a href="'+ hostName +'SLP_ViewCommunity?id='+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+' </a></span>';     
                 else
                     bodyString += '<span style="border: 1px solid #dedede; border-bottom: none !important; background: #fbf9f7; padding: 10px; margin-top: 20px; font-size: 16px; color: #4A8BC2; -moz-border-radius-topleft: 4px;   border-top-left-radius: 4px; -moz-border-radius-topright: 4px; border-top-right-radius: 4px; clear: both; display: inline-block;"><a href="'+ hostName +'AthenaLearningBoardDtls?id='+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+' </a></span>';     
            
                if(clsCBAdd.ListFeedPost!=null)
                {
                    for(ClsFeedPost clsFP: clsCBAdd.ListFeedPost)
                    {
                        bodyString += '<div style="background: #fff; border: 1px solid #dedede; font-size: 14px; width: 100%; padding: 1%; display: inline-block;">'; //PostCommentBg clearfix
                        bodyString += '<div style=" background: #f6f5f3; padding: 1%; width: 98.5%; float: right;">'; //postDiv
                        bodyString += '<div style="display: inline-block;"> '+clsFP.PostName+' </div>';
                        bodyString += '<div style="clear: both;">';
                        bodyString += '<span style="color: #4a8bc2; font-size: 13px;"> '+clsFP.PostedUserName+' </span>';
                        bodyString += '<span style="font-size: 13px; color: #929293; padding-left: 5px;"> '+clsFP.PostedDate+' </span>';
                        bodyString += '<span style="font-size: 13px; color: #929293; padding-left: 5px; color: #B8B8B9;">';
                        //bodyString +=' <span>Persons Likes '+clsFP.PostLikes'</span></span>';
                        bodyString +='</div></div>';

                      if(clsFP.lstFCmt!=null)
                      {
                          for(FeedComment FCmt:clsFP.lstFCmt)
                          { 
                                DateTime d = FCmt.CreatedDate;
                                string createdDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');

                                bodyString +='<div style=" width: 90%; float: right; background: #f6f5f3; padding: 10px; margin-top: 2px; clear: both; display: inline-block;">';
                                bodyString +='<div style=" display: inline-block;" > '+FCmt.CommentBody+' </div>';
                                bodyString +='<div style="clear: both;" > <span style="color: #4a8bc2;font-size: 13px;clear: both;" > '+FCmt.CreatedBy.name+' </span> <span style="font-size: 13px;color: #929293;  padding-left: 5px;" > '+ createdDate +' </span> </div>';
                                bodyString +='</div>';
                          }
                      }
                    }
                }
                bodyString += ' </div>';
              }
          }
          bodyString += '</div></body></html>';
          lstDailyDiggest.put(MDD.UserId,bodyString);
        }
        
        return lstDailyDiggest;
    }
    
    public void GenerateDailyDiggest()
    {
        Map<Id,string> MapBulkDiggest=new Map<Id,string>();
        MapBulkDiggest = getDailyDiggest();
        BulkEmailSend(MapBulkDiggest);
    }
    
    public void BulkEmailSend(Map<Id,string> MapSendMails)
   {
     Integer mapSize = MapSendMails.size();            
       system.debug('mapSize---------------'+mapSize);
       Messaging.SingleEmailMessage[] mails=new Messaging.SingleEmailMessage[mapSize]; 
        integer iCount=0;
       for(string UserId : MapSendMails.keyset()) 
       {
        mails[iCount]=SendMail(UserId,MapSendMails.get(UserId));
        iCount++;
       }
       
       

       Messaging.sendEmail(mails); 
   }
   
    public Messaging.SingleEmailMessage SendMail( string id,string MailBody)
    {
       Messaging.SingleEmailMessage mail;  
       
        String instance = 'https://hp--esit--c.cs11.visual.force.com';        
        string[] toAddresses;
        mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);       
        mail.setTargetObjectId(id.left(15)); 
        mail.setSubject('Your Daily Digest for Chatter' ); 
            
        mail.setHtmlBody(MailBody);
        return mail;
        
    }
    
    
}