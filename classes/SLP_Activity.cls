global class SLP_Activity 
        {
            public string ShareOperatingSystem {get;set;}
            public string ShareBrowser {get;set;}
            public string RedirectUrl{get;set;}
            public string ShareDeviceType {get;set;}
            public string selfRole{get;set;}
            public string selfTitle {get;set;}
            public string selfAreaofFocus {get;set;}
            public string selfAboutMe{get;set;}
            public string selfDepartment{get;set;}
            public static string SLPRegistrationUrl { get; set;}
            public static string SSOUrl { get; set;}
            public boolean isFirstLogin {get;set;}
            public boolean IsWizardComplete {get;set;}
            public string RoleName {get; set;}
            public string Availskill{get;set;}
            public string AvailsRoles{get;set;}
            public string AvailableExperts {get;set;}
            public string skilltags {get;set;}
            public string Roletags {get;set;}
            public String AthenaUserId {get;set;}
            public string hdnFeedItem {get;set;}
            public string SelectedUsrs {get;set;}
            public string hdnSharecmt {get;set;}
            public string hdnBoardComm {get;set;}
            public boolean IshdnComm {get;set;}
            public boolean IsPublic {get;set;}
            public static Integer TotalNumberOfCommunities{get;set;} 
            public string ActivitySequenceNo { get; set;}
            public static string staticpath{get;set;}
            public static Integer TotalNumberOfLB{get;set;} 
            public static string SLPDefaultBoardId { get; set;}
            public boolean DefaultBoardExist{get;set;}
            
            public static Integer CommentCounts(string id){
                //system.debug('####'+id);    
                List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
                return commCount.size();    
            }
            
            public boolean IsDisplayWizard{           
            
            get{List<ES_User__c> esUser= [select id,user_id__c,profile_wizard_complete__c from es_user__C where user_id__c= :UserInfo.getUserId()];
            if(esUser.size()>0)
            {
            return esUser[0].profile_wizard_complete__c;
            }
            else
            {
            return false;
            }
            }          

            set;}
            
        public static List<LearningBoardCustomclass> SortData(List<LearningBoardCustomclass> CustomerCollection, String sortingOrder){
        List<LearningBoardCustomclass> resultList = new List<LearningBoardCustomclass>();
        Map<integer,Map<Datetime,LearningBoardCustomclass>> objectMap = new Map<integer,Map<Datetime,LearningBoardCustomclass>>();
        Map<datetime,LearningBoardCustomclass> resultData=new Map<datetime,LearningBoardCustomclass>();
        Map<datetime,LearningBoardCustomclass> resultMapData=new Map<datetime,LearningBoardCustomclass>();
        integer index=0;
        List<datetime> datetimeresult=new List<datetime>();
         
        for(LearningBoardCustomclass ob : CustomerCollection){
        index=index+1;
        //ob.Name is the property name of customer object
        if(objectMap.get(index) == null){ 
        map<datetime,LearningBoardCustomclass> mapdata=new map<datetime,LearningBoardCustomclass>();
        mapdata.put(ob.LastModifiedDate, ob);
        objectMap.put(index,mapdata);
        }
        //objectMap.get(ob.LastModifiedDate).add(ob);
         
        //objectMap.put(ob.LastModifiedDate, ob);
        }
        List<integer> keys = new List<integer>(objectMap.keySet());
        keys.sort();
        //system.debug('Keys :'+keys);
        //system.debug('sortingorder: '+sortingorder);
        for(integer key : keys){
        resultData=objectMap.get(key);
        for(datetime datekey:resultData.keySet())
        resultMapData.put(datekey,resultData.get(datekey));
        }
        datetimeresult=new List<datetime>(resultMapData.keySet());
        datetimeresult.sort();
         
        //system.debug('Datetime Keys@@: '+datetimeresult);
         
        for(datetime datetimedata: datetimeresult){
        resultList.add(resultMapData.get(datetimedata));
        }
        CustomerCollection.clear();
         
        if(sortingOrder.toUpperCase()=='ASC'){
        for(LearningBoardCustomclass ob : resultList){
        CustomerCollection.add(ob);
        }
        }
        Else if(sortingOrder.toUpperCase()=='DESC'){
         
        for(integer i = resultList.size()-1; i >= 0; i--){
        CustomerCollection.add(resultList[i]); 
        }
        }
        return CustomerCollection;
        }
              
         public SLP_Activity()
         {
            Availskill=getAvailableskill();
            AvailsRoles=FetchRoles();
            AvailableExperts=FetchExperts();
           staticpath = getResourceURL('Img_Athena'); 
            SLPRegistrationUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SLPRegistrationUrl);
            SSOUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SSOUrl);
            SLPDefaultBoardId=AthenaUtility.ApplicationSettingValue(AthenaUtility.DefaultBoardId);
            DefaultBoardExist=false;

         }
          public String getAvailableskill()
            {
                List<skill__c> skil=[SELECT name__c FROM skill__c where is_active__c =true order by name__c];        
                string Avlbleskil='';
                for(skill__c ski:skil)
                {           
                     Avlbleskil+= '\'' + string.valueOf(ski.name__c.replace('\'','')) +  '\'' + ',';             
                }
                return  Avlbleskil;
            }   

             public string FetchRoles()
                {
                    
                    List<SLP_Role__c> userObj = new List<SLP_Role__c>();
                    userObj = [SELECT Id, Role_Name__c FROM SLP_Role__c where Is_Active__c=true order by Role_Name__c ];
                    string AvlbleRole='';
                    
                    if(userObj.size() > 0 &&(userObj!=null))
                    {
                     for(SLP_Role__c esUsr:userObj)
                        {  
                            if(esUsr.Role_name__c!=null && esUsr.Role_name__c!='')
                            {
                            AvlbleRole+= '\'' + string.valueOf(esUsr.Role_name__c.replace('\'','')) +  '\'' + ',';             
                            }
                        }
                    }
                    return AvlbleRole;
                }
            public string FetchExperts()
              {
               List<SLP_Secondary_Industry__c> lstSecInd= [SELECT Id, Secondary_Industry_Name__c FROM SLP_Secondary_Industry__c where Is_Active__c =true order by Secondary_Industry_Name__c ];
               string AvailExperts='';
                    if(lstSecInd.size() > 0)
                    {
                      for(SLP_Secondary_Industry__c SSI: lstSecInd)
                      {
                        if(SSI.Secondary_Industry_Name__c!=null && SSI.Secondary_Industry_Name__c!='')
                        {
                            AvailExperts+= '\'' + string.valueOf(SSI.Secondary_Industry_Name__c.replace('\'','')) +  '\'' + ',';   
                        }                       
                      }
                    }
                    return AvailExperts;
               
              }
            
        public static Integer NoOfTile {get;set;} 
            
                public static integer LikedItemCounts(string itemIdentifier){
                List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
                if(li.size()!=0)
                {
                    return Integer.ValueOf(li[0].like_count__c);
                }
                return 0;
            }   
             
        Public class LearningBoardCustomClass{
        public string FullOwnername {get;set;}
                public id AttachmentId{get;set;}        
                public String LBName{get;set;}
               public String LBDescription{get;set;}   
                public String LBid{get;set;}
                public String LBOwnerName{get;set;}
                public String LBOwnerTitle{get;set;} 
                public String LBOwnerURL{get;set;}
                public Datetime LBCrtDate{get;set;}
                public integer LBNoOfLikes{get;set;}
                public integer LBNoOfComments{get;set;} 
                public boolean StaticImage{get;set;} 
                public string LBOwnerID{get;set;}  
                public String LBImgURL{get;set;}
                public String ServerPath  {get;set;}
                public integer FeaIndex {get;set;}
                public string LikeIcon {get;set;}
                public string CommentIcon {get;set;}
                public String LBCreateDate{get;set;}
                public Integer TotalCount {get;set;}
                public boolean Active{get;set;}
                public boolean existing{get;set;}
                public string NavigationLink{get;set;}
                public Decimal AvgRating{get;set;}
                public boolean IsCommunity{get;set;}
                public Datetime LastModifiedDate{get;set;}
            }
            
         public String getSfInstance{
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
                public String contentfileType {get;set;}
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
                public string CommentBody {get;set;}
                public string CommentType {get;set;}
                public string LinkUrl {get;set;}
                public boolean IsLink {get;set;}
                public String postCommentFileType{get;set;}
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
                 if(clsBrd.id==SLPDefaultBoardId)
                {
                        //system.debug('DefaultBoardExist :true');
                        DefaultBoardExist=true;
                }

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
                List<Id> setRelatedRecordIds=new List<Id>();
                List<FeedComment> lstFollowerComment =[SELECT Id,RelatedRecordId, FeedItemId FROM FeedComment where CreatedById in:setFollowers order by CreatedDate desc limit 999];
                for(FeedComment  Cmnt:lstFollowerComment)
                {
                setFollowerCommentId.add(Cmnt.FeedItemId);
                   
                }
                
                
                list<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate,RelatedRecordId,Type , contentfilename, ParentId, CreatedById, CreatedBy.name,LinkUrl, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost','ContentPost') AND (ParentId=:UserInfo.getUserId() or ParentId=:setCommIds or CreatedById in:setFollowers or id in:setFollowerCommentId) AND (CreatedById !=: UserInfo.getUserId()) order by LastModifiedDate desc limit 999];
                //List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId,RelatedRecordId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where (ParentId=:UserInfo.getUserId() or ParentId=:setCommIds or CreatedById in:setFollowers) AND (CreatedById !=: UserInfo.getUserId()) order by CreatedDate desc limit 999];
                
                
                Map<ID,List<FeedItem>> MapFeedItm=new Map<ID,List<FeedItem>>();
                Map<ID,List<FeedComment>> MapFeedCmt=new Map<ID,List<FeedComment>>();
                set<Id> setParentIds=new set<Id>();
                set<Id> setCreateIds=new set<Id>();
                set<Id> setFeedItmIds=new set<Id>();
                for(FeedItem FeedItm:lstFeedItem)
                {
                  setParentIds.add(FeedItm.ParentId);
                }
                      
              for(FeedItem FItem:lstFeedItem)
              {
                setCreateIds.add(FItem.CreatedById);
                setFeedItmIds.add(FItem.Id);
              }
              
              List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where FeedItemId in :setFeedItmIds  order by CreatedDate desc limit 999];
               
              for(FeedComment FComment:lstFeedComment)
              {
                setCreateIds.add(FComment.CreatedById);
               setRelatedRecordIds.add(FComment.RelatedRecordId);
              }
              
              
              list<user> lstUsrs=[select Id,smallphotourl From User where Id=:setCreateIds];
              Map<id,string> MapUsr=new Map<id,string>(); 
              for(user usrs:lstUsrs)
              {
                MapUsr.put(usrs.Id,usrs.smallphotourl);
              }
              
              List<ContentVersion> lstContentVersion=new List<ContentVersion>();
              List<ContentDocumentLink> lstContentLink = new List<ContentDocumentLink>();
              Map<Id,string> mapRelatedRecord=new Map<Id,string>();
              Map<Id,STring> fileTypeMap = new Map<Id,String>();
              Map<Id,String> contentRecordLink = new Map<Id,String>();
              Map<Id,String> contentFile = new Map<Id,String>();
              system.debug('setRelatedRecordIds:'+setRelatedRecordIds);
              lstContentVersion=[SELECT Id, FileType, PublishStatus, Title, Description FROM ContentVersion where id in:setRelatedRecordIds limit 999];
              // lstContentLink = [SELECT ContentDocumentId,ContentDocument.title,ContentDocument.filetype, ContentDocument.FileExtension FROM ContentDocumentLink WHERE ContentDocumentId in :setRelatedRecordIds];
              //system.debug('lstContentVersion:'+lstContentVersion.size());
               for(ContentVersion CV:lstContentVersion)
               {
                 mapRelatedRecord.put(CV.Id,CV.Title);
                 fileTypeMap.put(CV.Id,CV.FileType);
               }
               // for(ContentDocumentLink conLink : lstContentLink){
                // contentRecordLink.put(conLink.ContentDocumentId,conLink.ContentDocument.title);
                // contentFile.put(conLink.ContentDocumentId,conLink.ContentDocument.filetype);
               // }
              //system.debug('mapRelatedRecord:'+mapRelatedRecord.size());
              String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/';
              
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
                  CPc.CommentType=FeedCmt.CommentType;
                  //---------imran--------start----------
                  if(fileTypeMap.get(FeedCmt.RelatedRecordId) != null){
                    if(fileTypeMap.get(FeedCmt.RelatedRecordId).contains('WORD_X') || fileTypeMap.get(FeedCmt.RelatedRecordId).contains('WORD'))
                        CPc.postCommentFileType = 'doc';
                    else if(fileTypeMap.get(FeedCmt.RelatedRecordId).contains('EXCEL_X') || fileTypeMap.get(FeedCmt.RelatedRecordId).contains('EXCEL'))
                        CPc.postCommentFileType = 'xls';
                    else if(fileTypeMap.get(FeedCmt.RelatedRecordId).contains('POWER_POINT_X') || fileTypeMap.get(FeedCmt.RelatedRecordId).contains('POWER_POINT'))
                        CPc.postCommentFileType = 'ppt';
                    else if(fileTypeMap.get(FeedCmt.RelatedRecordId).contains('PDF'))
                        CPc.postCommentFileType = 'pdf';
                    else if(fileTypeMap.get(FeedCmt.RelatedRecordId).contains('TEXT'))
                        CPc.postCommentFileType = 'txt';
                    else
                        CPc.postCommentFileType = 'other';
                  }
                  else{
                    CPc.postCommentFileType = 'other';
                  }
                if(CPc.CommentType=='ContentComment'){
                    CPc.IsLink=true;
                    CPc.LinkUrl=fullFileURL+FeedCmt.RelatedRecordId;                    
                    if(mapRelatedRecord.get(FeedCmt.RelatedRecordId) != null)
                        CPc.CommentBody = mapRelatedRecord.get(FeedCmt.RelatedRecordId);
                    else
                        CPc.CommentBody='View File'; 
                }
                  else
                  {
                    CPc.IsLink=false;
                  }
                  lstPc.add(CPC);
              }
              //------------imran---------stop------------
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
                //system.debug('lstComm:'+lstComm.size());
                for(Community__c commc: lstComm)
                {
                  MapCommNm.put(commc.Id,commc.Name__c);
                }
                
                Map<Id,string> MapBoardNm=new Map<Id,string>();
                List<Learning_Board__c> lstBoard=[select Id,Name__c From Learning_Board__c where Id in: setParentIds];
                //system.debug('lstBoard:'+lstBoard.size());
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
             if(strPost!='' && strPost!=null)
        {    
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
         }               
                        cFPs.PostedUserId = FI.CreatedById;
                        cFPs.PostedUserName = FI.CreatedBy.Name;
                        cFPs.PostedDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                        cFPs.UsrPhoto=MapUsr.get(FI.CreatedById);   
                            //--------imran-------start------------
                        if(FI.contentfilename != null ){
                            if(FI.contentfilename.contains('.doc'))
                                cFps.contentfileType = 'doc';
                            else if(FI.contentfilename.contains('.xls'))
                                cFps.contentfileType = 'xls';
                            else if(FI.contentfilename.contains('.ppt'))
                                cFps.contentfileType = 'ppt';
                            else if(FI.contentfilename.contains('.pdf'))
                                cFps.contentfileType = 'pdf';
                            else if(FI.contentfilename.contains('.txt'))
                                cFps.contentfileType = 'txt';
                            else
                                cFps.contentfileType = 'other';
                        }
                        else{
                            cFps.contentfileType = 'other';
                        }
                        //-----------imran---stop-------------------------
                        cFPs.PostLikes = FI.LikeCount;
                        if(FI.type =='ContentPost')
                        {
                         cFPs.LinkUrl=fullFileURL+FI.RelatedRecordId;
                        }
                        else
                        {
                         cFPs.LinkUrl=FI.LinkUrl;
                        }
                        cFPs.Title=FI.Title;
                        if((cFPs.LinkUrl!='' )&& (cFPs.LinkUrl!=null ))
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
                //system.debug('MapClsComm:'+MapClsComm);
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

        //system.debug('hdnBoardComm:' + hdnBoardComm);
        //system.debug('IshdnComm:' + IshdnComm);

              
              
              String[] splitInput = SelectedUsrs.split(',');
              List<String> UsrIds = new List<String>( splitInput );
              
              List<User> lstUsers = [Select id, Name From User  where id in : UsrIds];

              //Map<string, string> mapUser = new Map<string, string>();
              
              //for(User usr: lstUsers)
              //{
              //  mapUser.put(usr.id, usr.Name);
              //}

             List<FeedItem> lstFI=new List<FeedItem>();
             List<FeedItem> lstFeedItem= [SELECT Id, LastModifiedDate, ParentId, CreatedById, CreatedBy.name,LinkUrl, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost') and Id=:hdnFeedItem  limit 1];
             //system.debug('lstFeedItem:'+lstFeedItem);
             //system.debug('lstFeedItemLinkUrl:'+lstFeedItem.LinkUrl);
             
              String sBody = '';
              String feedLinkUrl = '';
              String feedTitle = '';
              //system.debug('lstFeedItemBody:'+lstFeedItem.Body);
              //system.debug('sBody:'+sBody);
            if(lstFeedItem.size()>0){
                sBody = lstFeedItem[0].Body;
                feedLinkUrl = lstFeedItem[0].LinkUrl;
                feedTitle = lstFeedItem[0].Title;
                if(lstFeedItem[0].Body.contains('#[Added Member]')){
                    sBody  =lstFeedItem[0].Body.replace('#[Added Member]','');
                }
                else if(lstFeedItem[0].Body.contains('#[Change Owner]')){
                    sBody =lstFeedItem[0].Body.replace('#[Change Owner]','');
                }
                else if(lstFeedItem[0].Body.contains('#[Added Content]')){
                    sBody =lstFeedItem[0].Body.replace('#[Added Content]','');
                }
                else if(lstFeedItem[0].Body.contains('#[Added Contributor]')){
                    sBody =lstFeedItem[0].Body.replace('#[Added Contributor]','');
                }
                else if(lstFeedItem[0].Body.contains('#Rating'))
                {
                sBody = lstFeedItem[0].Body.replace('#Rating','');
                }
                else if(lstFeedItem[0].Body.contains('#Follower'))
                {
                sBody = lstFeedItem[0].Body.replace('#Follower','');
                }
                else  if(lstFeedItem[0].Body.contains('#[Add Member]'))
                {
                sBody  =lstFeedItem[0].Body.replace('#[Add Member]','');
                }
                else
                {
                sBody =lstFeedItem[0].Body;
                }
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

             //if((lstFeedItem[0].LinkUrl!='') && (lstFeedItem[0].LinkUrl!=null))
             //{
                 
             // for(string strU: UsrIds)
             // {
             //   FeedItem FeedItm=new FeedItem();
               
             //   FeedItm.LinkUrl=lstFeedItem[0].LinkUrl;
             //   FeedItm.Title=lstFeedItem[0].Title;
                
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
                //system.debug('hdnBoardComm:' + hdnBoardComm);
                
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
           
           string userNames='';
           string ShareMetric='';
                for(User usr : lstUsers)
                {
                     string BodyContent='';   
                    //system.debug('User Name: '+usr.Name);
                     userNames=userNames+usr.Name+';';
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
               
                    if((feedLinkUrl!='') && (feedLinkUrl!=null))
                    {
                        FeedItm.LinkUrl = feedLinkUrl;
                        FeedItm.Title = feedTitle;
                        
                    }
                    FeedItm.ParentId = usr.id;
                    FeedItm.Body = BodyContent;
                            
                    lstFI.add(FeedItm);
                }
                insert lstFI;
                AthenaUtility athUtlObj=new AthenaUtility();
        string ObjectName='';
        string objectId='';
        string userId=UserInfo.getUserId(); 
        userNames=userNames.substring(0,(userNames.length())-1);           
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        if(feedLinkUrl == null){
            feedLinkUrl = '';
        }
        if(feedTitle==null){
            feedTitle = '';
        }
       metricsObj.Text__c= 'has Shared '+sBody+'; Comment:- '+ hdnSharecmt+'; '+PublicCmt+'; '+feedTitle+'; '+feedLinkUrl+ '; to these users '+userNames;
         
        
        metricsObj.ActionType__c='Share Button Click';
        //metricsObj.ObjectId__c=objectId;
        //metricsObj.ObjectName__c=ObjectName;
        metricsObj.TabSection__c='Activity Stream';
        //metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='Activity page';
        metricsObj.DeviceType__c=ShareDeviceType;
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=athUtlObj.GetOSName(ShareOperatingSystem);
        metricsObj.Browser__c=ShareBrowser;
        Insert(metricsObj);
            }
            
            @RemoteAction
            public static List<LearningBoardCustomClass> GetFeaturedLB(Integer Text,Integer Next,Integer Prev)
            {
                List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
                Learning_Board=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate,LastModifiedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True Order by LastModifiedDate Desc];
                string strSection='';
                List<Community__c> comm = new List<Community__c>();
                comm =[select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,  Owner.name,Owner.Id,Owner.title,CreatedDate,LastModifiedDate from Community__c where IsActive__c = True and Featured__c = True Order by LastModifiedDate Desc];
                List<LearningBoardCustomClass> lbcustomlist = new List<LearningBoardCustomClass>();
                string strStaticImg1=    GetResourceURL('img_athena');
                staticpath = strStaticImg1;
         
                Map<string,string> usrimgmap1 = new Map<string,string>();
                List<string> CommOwnerList = new List<string>();
                for(Community__c lb:comm){
                    CommOwnerList.add(lb.Owner.Id);
                }
                List<user> usrlist1 = [Select id,SmallPhotoUrl, FullPhotoUrl From User u where u.id =:CommOwnerList];
                for(user usr : usrlist1){
                    usrimgmap1.put(usr.id,usr.smallphotoUrl);
                }        
                  
                for(Community__c lb: comm){
                    LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
                    lbCustom.TotalCount = comm.size();
                    lbCustom.IsCommunity = true;
                    lbCustom.FullOwnername= lb.Name__c;
                    lbCustom.LBName = lb.Name__c; 
                    lbCustom.LBDescription=lb.description__c;
                    lbCustom.LBOwnerID=lb.Owner.Id;
                    lbcustom.FullOwnername=lb.Owner.Name;
                    lbCustom.LBOwnerName = lb.Owner.Name;
                    lbCustom.LBOwnerTitle= lb.Owner.title;
                    lbCustom.LBOwnerURL = usrimgmap1.get(lb.Owner.Id);   
                    lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd');
                    lbCustom.LBImgURL=lb.Default_Image_Name__c;
                    lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
                    lbCustom.LbId = lb.id;
                    lbCustom.StaticImage = true;
                    //lbCustom.AvgRating=RatedItemMap.get(lb.id);
                    lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
                    string strStaticImg = staticpath;
                    lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
                    lbCustom.LastModifiedDate = lb.LastModifiedDate;
                    lbcustomlist.add(lbCustom);
                }
                
                Map<string,string> usrimgmap = new Map<string,string>();
                List<string> LBOwnerList = new List<string>();
                for(Learning_Board__c lb:Learning_Board){
                    LBOwnerList.add(lb.Owner.Id);
                }
                List<user> usrlist = [Select id,SmallPhotoUrl, FullPhotoUrl From User u where u.id=:LBOwnerList];
                for(user usr : usrlist){                
                        usrimgmap.put(usr.id,usr.smallphotoUrl);                
                }        
                for(Learning_Board__c lb: Learning_Board){
                    LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
                    lbCustom.TotalCount =Learning_Board.size();
                    lbCustom.IsCommunity = false;
                    lbCustom.LBName = lb.Name__c; 
                    lbCustom.LBDescription=lb.description__c;
                    lbCustom.LBOwnerID=lb.Owner.Id;
                    lbCustom.FullOwnername=lb.Owner.Name;
                    lbCustom.LBOwnerName = lb.Owner.Name;
                    lbCustom.LBOwnerTitle= lb.Owner.title;
                    lbCustom.LBOwnerURL = usrimgmap.get(lb.Owner.Id);
                    lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd');
                    lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
                    lbCustom.LbId = lb.id;
                    lbcustom.LBImgURL=lb.Default_Image_Name__c;
                    lbCustom.StaticImage = true;
        //            lbCustom.AvgRating=RatedItemMap.get(lb.id);
                    lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
                    string strStaticImg= staticpath;
                    lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
                    lbCustom.LastModifiedDate = lb.LastModifiedDate;
                    lbcustomlist.add(lbCustom);
                }
                
                //system.debug('$$'+lbcustomlist);
                for(LearningBoardCustomclass LBCC : lbcustomlist){
                    //System.debug('%%'+LBCC.LBOwnerURL);
                    //system.debug('$$'+LBCC.LikeIcon);        
                }
                TotalNumberOfLB=Learning_Board.size();
                TotalNumberOfCommunities=comm.size();
               List<LearningBoardCustomclass> result=SortData(lbcustomlist,'DESC'); // By Komala
                return  GetLearningBoard_Community( Text, Next,Prev,result,strSection);
            }
            
            private static List<LearningBoardCustomClass> GetLearningBoard_Community(Integer Text,Integer Next,Integer Prev,List<LearningBoardCustomClass> Learning_Board,string Section)
            {
                NoOfTile=Text;
                list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
                list<Attachment> attachmentList = new List<Attachment>(); 
                list<id> learningBoardIds= new list<id>();
                List<LearningBoardCustomClass> NewLBCClist =new List<LearningBoardCustomClass>();                
                
                integer icnt=1;       
         
         
                for (LearningBoardCustomClass lb: Learning_Board){
                        learningBoardIds.add(lb.LBid);
                        NewLBCClist.add(lb);
                }       
                attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
                integer inx=1;
                
                //---------------
                
                string typeComm = '\'' + 'TextPost' + '\'';
         
                List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];
         
         
                Map<String,Integer> CmntCntMap = new Map<String,Integer>();
                //system.debug('FI##'+feeddItmlst);
                for (FeedItem feedItm : feeddItmlst){            
                      if(!CmntCntMap.containskey(feedItm.ParentId)){
                          CmntCntMap.put(feedItm.ParentId,1);
                      }
                      else{
                          integer i = CmntCntMap.get(feedItm.parentId);
                          CmntCntMap.put(feedItm.parentId,i+1);            
                      }
                }  
                //system.debug('CmntCntMap'+CmntCntMap.size());
                //system.debug('CmntCntMap'+CmntCntMap);
         
                //---------------
               List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
                map<id,decimal> RatedItemMap = new map<id,decimal>();        
                           
                
                for (Rated_Item__c rtdItm :RatedItemLst) {
                            RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
                }
                
                string strStaticImage = StaticPath;
                //system.debug('***'+staticPath);
                
                for(LearningBoardCustomClass lb: Learning_Board){
                 LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
                 lbCustom.TotalCount =NewLBCClist.size();
                      
                 lbCustom.LBName = lb.LBName ;  
                 
                 lbCustom.LBOwnerURL = lb.LBOwnerURL;          
                    if(lb.LBName != null)
                    {
                       if(lb.LBName.length() > 25)
                         {                            
                            lbCustom.LBName = lb.LBName.substring(0, 25) + '...';
                         }
                         else
                         {
                            lbCustom.LBName = lb.LBName;
                         }
                    }
                    if(lb.LBDescription!= null){
                        if(lb.LBDescription.length()>75){                    
                            lbCustom.LBDescription = lb.LBDescription.substring(0,75) + '...';
                        }
                        else{
                            lbCustom.LBDescription=lb.LBDescription;
                        }
                    }
         
                    If(RatedItemMap.containskey(lb.LBid))
                    {
                        lbCustom.AvgRating=RatedItemMap.get(lb.LBid);
                    }
                    else
                    {
                        lbCustom.AvgRating=0;
                    }
                    
                    lbCustom.existing=true;
                    lbCustom.LBOwnerID=lb.LBOwnerID;
                    lbcustom.FullOwnername=lb.LBOwnerName;
                    //Restricting Owner Name for specific characters
                    
                    if(lb.LBOwnerName != null)
                    {
                    lbCustom.LBOwnerName = lb.LBOwnerName;
                         if(lb.LBOwnerName.length() > 15)
                         {                            
                            lbCustom.LBOwnerName = lb.LBOwnerName.substring(0, 16) + '...';
                         }
                         else
                         {
                            lbCustom.LBOwnerName = lb.LBOwnerName;
                         }
                    }
                                                
                    lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
                    if(lb.LBOwnerTitle!= null)
                    {
                    lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
                         if(lb.LBOwnerTitle.length() > 25)
                         {                            
                            lbCustom.LBOwnerTitle = lb.LBOwnerTitle.substring(0, 25) + '...';
                         }
                         else
                         {
                            lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
                         }
                    }
                    
                    
                    //lbCustom.LBOwnerURL = getUserImages(lb.LBOwnerURL);   
                    //lbCustom.LBCreateDate=(lb.LBCreateDate).format('MMM dd ');
                    lbCustom.LBCreateDate=(lb.LBCreateDate);
                    lbCustom.IsCommunity = lb.IsCommunity;
                    lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.LBid;
                    lbCustom.LBNoOfComments =   CommentCounts(lb.LBid);  
                    if(CmntCntMap.containskey(lb.LBid))
                    {
                        lbCustom.LBNoOfComments =   CmntCntMap.get(lb.LBid);
                    }
                    else
                    {
                    lbCustom.LBNoOfComments=0;
                    }
                    
                    //lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
                    lbCustom.LbId = lb.Lbid;
                    lbCustom.Active=lb.Active;
                    lbCustom.StaticImage = true;
                    lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
                    //string strStaticImg = StaticPath;   
                    lbCustom.LikeIcon=lbCustom.ServerPath+StaticPath+'/img_athena/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+StaticPath+'/img_athena/hpit_athena_chatIcon.png';
                    for(Attachment att: attachmentList){
                        if(lb.LBid == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.StaticImage=false;
                        }  
                    }
         
                    if(lbCustom.StaticImage == true)
                    {
                    lbCustom.LBImgURL=lbCustom.ServerPath+StaticPath+'/img_athena/' + lb.LBImgURL;
                    }
                    else
                    {
                    lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
                    }
                    lbCustom.FeaIndex =inx;
                    
                   if(Prev==-1)
                    {
                        if(inx>next)
                            {
                                ListFeaturedLB.add(lbCustom);
                                //system.debug('No Of Tile'+NoOfTile);
                                //system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                                if(ListFeaturedLB.size()==NoOfTile)
                                    {
                                        break;
                                    }
                            }
                    }
                    if(next==-1 )
                      {
                    if(inx>=(prev-NoOfTile))
                        {
                           ListFeaturedLB.add(lbCustom);
                           //system.debug('No Of Tile'+NoOfTile);
                           //system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                           if(ListFeaturedLB.size()==NoOfTile)
                            {
                                break;
                            }
                        }
                    }
                    inx++;  
                    }  
                TotalNumberOfLB=ListFeaturedLB.size();  
            //    system.debug('@@@@@@@@@@@@ListFeaturedLB'+ListFeaturedLB);   
            
                return ListFeaturedLB;
         
             //       return Learning_Board;
                }
                
            @RemoteAction        
             public static string SaveCommunityData(UpdateProfile updateProfle)
                {
                try{ 
                        string userId=UserInfo.getUserId(); 
                        //system.debug('UpdateProfile communityIDs :'+updateProfle.communityIDs.size());  
                        //system.debug('PrivateCommunityIDs size :'+updateProfle.PrivateCommunityIDs.size());                 
                        if(updateProfle.communityIDs.size() > 0)
                        {   
                            Community_Member__c  CommunityMember;
                            List<Community_Member__c> lstCommunityMember=new List<Community_Member__c>();
                             for(string currentID:updateProfle.communityIDs){
                              //system.debug('lstCommunityMember :'+currentID);
                               lstCommunityMember= [SELECT Id, Community_Id__c FROM Community_Member__c where Community_Id__c=:currentID and Status__c=:'Approved' and User_Id__c=:userId  ];
                                if(lstCommunityMember.size()==0)
                                {
                                 //system.debug('lstCommunityMember :'+currentID);    
                                CommunityMember = new Community_Member__c();
                                CommunityMember.Community_Id__c=currentID;
                                CommunityMember.User_Id__c=userId;
                                CommunityMember.Status__c ='Approved';
                                insert CommunityMember;
                                }
                             }
                        }
                        if(updateProfle.PrivateCommunityIDs.size() > 0)
                        {   
                            Community_Member__c  CommunityMember;
                             for(string currntID:updateProfle.PrivateCommunityIDs){
                             List<Community_Member__c> lstpriCommunityMember= [SELECT Id, Community_Id__c FROM Community_Member__c where Community_Id__c=:currntID and Status__c=:'Requested Membership' and User_Id__c=:userId ];
                                if(lstpriCommunityMember.size()==0)
                                {
                                  //system.debug('lstpriCommunityMember :'+currntID); 
                                CommunityMember = new Community_Member__c();
                                CommunityMember.Community_Id__c=currntID;
                                CommunityMember.User_Id__c=userId;
                                CommunityMember.Status__c ='Requested Membership';
                                insert CommunityMember;
                                
                                //system.debug('PrivateCommunityID :'+currntID);
                                SendEmail(currntID,userId,updateProfle.SfInstance);
                                }
                             }
                        }
                }
                catch (SLP_Exception e){

                }
                catch (DMLException dmlex){

                }
                finally{}
                return 'Sucessfully updated';
            }
            
            public static void SendEmail(string CommunityID,string userId,string SfInstance)
            {
                //system.debug('userId :'+userId);
                //Send Mail to Owner and CC requestor
                string LoggedInUserName='';
                string LoggedInUseremail='';
                string CommunityName='';
                string CommunityDescription='';
                string OwnerName='';
                string OwnerID='';
                
                List<User> objUser = new List<User>();
                objUser =[SELECT Id, name, email FROM User  where Id =:userId];
                if(objUser.size() > 0)
                {
                LoggedInUserName=objUser[0].name;
                LoggedInUseremail=objUser[0].email;
                //system.debug('LoggedInUseremail :'+LoggedInUseremail);
                Community__c objCommunity = new Community__c();
                objCommunity =[SELECT Public__c, Id, OwnerId, Description__c , Name__c FROM Community__c  where Id =:CommunityID];
                CommunityName=objCommunity.Name__c;
                CommunityDescription=objCommunity.Description__c;
                string SlpRegistrationUrl1=AthenaUtility.ApplicationSettingValue(AthenaUtility.SLPRegistrationUrl);
                if(SfInstance==null || SfInstance=='')
                {
                    SfInstance=AthenaUtility.ApplicationSettingValue('HostName');
                }
                string SSOUrl1=AthenaUtility.ApplicationSettingValue(AthenaUtility.SSOUrl);
                User objOwnerUser = new User();
                objOwnerUser =[SELECT Id, name, email FROM User  where Id =:objCommunity.OwnerId];
                OwnerName=objOwnerUser.name;
                OwnerID=objOwnerUser.Id;
                        //system.debug('OwnerName :'+OwnerName);
               Messaging.SingleEmailMessage mail;  
                string bodyString = '';
                mail = new Messaging.SingleEmailMessage();
                 mail.setSaveAsActivity(false);  
                mail.setTargetObjectId(OwnerID);
                mail.setCCAddresses( new String[]{ LoggedInUseremail });    
                mail.setUseSignature(false);      
                mail.setSubject(LoggedInUserName + ' requesting to add as member to the Community'+ CommunityName );                 
                string stringURL1 = SSOUrl1 + 'SLP_ViewCommunity?id%3d{1}';
                string[] subjectArguments1 = new String[] { SfInstance, CommunityID};
                string formatURL1 = String.format(stringURL1, subjectArguments1);
                                                                                                        
                bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>insight<br /><small>Information – on your terms</small></strong></span></span></h3>';
                bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+OwnerName+',&nbsp;</span></span></p>';
                bodyString += '<p> <p><span style="font-size:16px;">Please add me as a member to the below Community.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Community Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityName +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Community Description</td><td style="';
                bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityDescription +'</td>';
                bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ LoggedInUseremail +'</td></tr></table></p><p><span>If you are new to the insight, please click <a href='+ SlpRegistrationUrl1 +'>here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Community. </span></p>';
                bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+LoggedInUserName+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString += '</body></html>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
             }
            }
            
            public static void BulkEmailSend(Map<Id,string> MapSendMails)
            {
                Integer mapSize = MapSendMails.size();            
                Messaging.SingleEmailMessage[] mails=new Messaging.SingleEmailMessage[mapSize]; 
                integer iCount=0;
                for(string UserId : MapSendMails.keyset()) 
                {
                string strHtml=MapSendMails.get(UserId);
                              
                mails[iCount]=SendUserMail(UserId,strHtml);
                iCount++;
                }
                Messaging.sendEmail(mails); 
            }
                public static Messaging.SingleEmailMessage SendUserMail( string id,string MailBody)
            {
              
                Messaging.SingleEmailMessage mail;    
                string[] toAddresses;
                mail = new Messaging.SingleEmailMessage();
                mail.setSaveAsActivity(false);       
                mail.setTargetObjectId(id.left(15)); 
                mail.setSubject('insight Daily Digest'); 
                
                mail.setHtmlBody(MailBody);
                return mail;
            }
            
            @RemoteAction        
             public static string SaveBuildNetworkData(UpdateProfile updateProfle)
                {
                try{ 
                        string userId=UserInfo.getUserId();     
                        //system.debug('updateProfle.userProfileIDs.size()  :'+updateProfle.userProfileIDs.size() );  
                        if(updateProfle.userProfileIDs.size() > 0)
                        {
                            List<EntitySubscription>  lstEntitysubscription=new List<EntitySubscription>();
                            EntitySubscription  entitysubscription;
                            for(string currentuserID:updateProfle.userProfileIDs){
                            //system.debug('currentuserID :'+currentuserID); 
                                entitysubscription = new EntitySubscription();
                                entitysubscription.ParentId=currentuserID;
                                entitysubscription.SubscriberId=userId;
                                lstEntitysubscription.add(entitysubscription);
                            }
                            insert lstEntitysubscription;
                        }
                        
                            ES_User__c objEsUser = new ES_User__c();
                            objEsUser =[SELECT Id, User_Id__c FROM ES_User__c where User_Id__c =: userId];
                            if(objEsUser!=null)
                            {
                                objEsUser.Profile_Wizard_Complete__c=true;
                                update objEsUser;  
                            }
                            else
                            {
                                ES_User__c  esUser = new ES_User__c();
                                esUser.User_Id__c=userId;
                                esUser.Profile_Wizard_Complete__c=true;
                                insert esUser;  
                            }
                            
                            List<User> objlstUser = new List<User>();
                            objlstUser =[SELECT Id, Name FROM User where ID IN :updateProfle.userProfileIDs];
                            
                            User objUser= [Select Name,id From User where User.id= :userId];
                            List<FeedItem> lstpost = new List<FeedItem>(); 
                            FeedItem post; 
                            string tag ='Follower';
                            for(User objCurrent:objlstUser){
                             post = new FeedItem(); 
                             post.ParentId = objCurrent.Id; 
                            string comment = objUser.Name +' is now following ' + objCurrent.Name; 
                            post.Body = '#[' + tag + ']' + ' ' + comment; 
                            lstpost.add(post);
                            }             
                            insert lstpost;      

                            
                }
                catch (SLP_Exception e){

                }
                catch (DMLException dmlex){

                }
                finally{}
                return 'Sucessfully updated';
            }
            
            @RemoteAction        
             public static string SaveProfileData(UpdateProfile updateProfle)
                {
                try{ 
                        string userId=UserInfo.getUserId();
                        string roleID=' ';
                        string esUserID='';
                        string businessGroup='';
                        string region='';
                        string userEmail='';
                        string businessGroupid='';
                        string regionid='';
                        string SecondaryIndustryId='';
                        
                        //Update User details
                        User  userObj = new User();
                        userObj.Id=userId;
                        userObj.AboutMe=updateProfle.AboutMe;
                        userObj.title=updateProfle.Title;
                        userObj.Department=updateProfle.Department;
                        update userObj;  
                        //system.debug('Updated User details  :'+userId);
                        //system.debug('DefaultBoardExis  :'+updateProfle.DefaultBoardExist);
                        if(!updateProfle.DefaultBoardExist)
                        {
                            //system.debug('inserting default board :'+updateProfle.DefaultBoardId);
                            Learning_Board_Member__c BrdMem= new Learning_Board_Member__c();
                            BrdMem.User_Id__c=UserInfo.getUserId();
                            BrdMem.Learning_Board_ID__c=updateProfle.DefaultBoardId;
                            BrdMem.Status__c='Approved'; 
                            insert BrdMem;  
                        }               
                        //inserting new Role if not exists

                        //system.debug('Role  :'+updateProfle.Role);
                        List<SLP_Role__c> lstRole = new List<SLP_Role__c>();
                        lstRole =[SELECT Id, Role_Name__c, Is_Active__c FROM SLP_Role__c  where Role_Name__c =: updateProfle.Role];
                        if(lstRole.size()==0 && updateProfle.Role!='')
                        {
                            SLP_Role__c  Role = new SLP_Role__c();
                            Role.Role_Name__c=updateProfle.Role;
                            Role.Is_Active__c=true;
                            insert Role; 
                            roleID=Role.Id;
                        }
                        else
                        {
                          for(SLP_Role__c  currentRole :lstRole)
                          {   
                            roleID=currentRole.Id;              
                          }
                        }
                            
                        List<User> lstUser = new List<User>();
                        lstUser =[SELECT email FROM User where Id =: userId];
                        
                        if(lstUser.size()>0)
                        {
                         for(User currentuser :lstUser)
                          {   
                            userEmail=currentuser.email;              
                          }
                        List<SLP_ES_Emp_HRDD_Feed__c> lstEmpHRDDFeed = new List<SLP_ES_Emp_HRDD_Feed__c>();
                        lstEmpHRDDFeed =[SELECT Id, Business_Group__c, Region__c FROM SLP_ES_Emp_HRDD_Feed__c  where Email__c =: userEmail];
                        
                        if(lstEmpHRDDFeed.size()>0)
                        {
                         for(SLP_ES_Emp_HRDD_Feed__c  currentEmpHRDDFeed :lstEmpHRDDFeed)
                          {   
                            businessGroup=currentEmpHRDDFeed.Business_Group__c; 
                            region=currentEmpHRDDFeed.Region__c;              
                          }
                        
                            
                        if(businessGroup!='')
                        {
                            
                            List<SLP_Business_Group__c> lstslpbusinessGroup = new List<SLP_Business_Group__c>();
                            lstslpbusinessGroup =[SELECT Id FROM SLP_Business_Group__c where Business_Group_Name__c =: businessGroup];
                            if(lstslpbusinessGroup.size()>0)
                            {
                                for(SLP_Business_Group__c  currentbusinessGroup :lstslpbusinessGroup)
                                { 
                                    businessGroupid=currentbusinessGroup.Id;
                                }
                            }
                            else
                            {       
                                SLP_Business_Group__c  objBusinessGroup = new SLP_Business_Group__c();
                                objBusinessGroup.Business_Group_Name__c=businessGroup;
                                objBusinessGroup.Is_Active__c=true;
                                insert objBusinessGroup;
                                businessGroupid=objBusinessGroup.Id;
                            }
                        }
                        if(region!='')
                        {
                            List<SLP_Region__c> lstslpRegion = new List<SLP_Region__c>();
                            lstslpRegion =[SELECT Id FROM SLP_Region__c where Region_Name__c =: region];
                            if(lstslpRegion.size()>0)
                            {
                                for(SLP_Region__c  currentslpRegion :lstslpRegion)
                                { 
                                    regionid=currentslpRegion.Id;
                                }
                            }
                            else
                            {                   
                                SLP_Region__c  SLPRegion = new SLP_Region__c();
                                SLPRegion.Region_Name__c=region;
                                SLPRegion.Is_Active__c=true;
                                insert SLPRegion;
                                regionid=SLPRegion.Id;
                            }
                        }
                        }
                            //insert / updating the es user table information
                            List<ES_User__c> lstEsUser = new List<ES_User__c>();
                            lstEsUser =[SELECT Id, User_Id__c FROM ES_User__c where User_Id__c =: userId];

                            ES_User__c  esUser = new ES_User__c();
                            if(roleID !='')
                            {
                            esUser.Role_ID__c=roleID;
                            }
                            if(regionid !='')
                            {
                                esUser.Region_Id__c=regionid;
                            }
                            if(businessGroupid!='')
                            {
                                esUser.Business_Group_Id__c=businessGroupid;
                            }
                            esUser.User_Id__c=userId;
                            if(lstEsUser.size()>0)
                            {
                                esUser.id=lstEsUser[0].id;
                                update esUser;  
                                esUserID=lstEsUser[0].id;
                            }
                            else
                            {
                               insert esUser; 
                               esUserID=esUser.Id;
                            }
                            
                            //system.debug('esUserID :'+esUserID);
                        }
                            //system.debug('updateProfle.AreaofFocus :'+updateProfle.AreaofFocus.size());
                            List<SLP_Expert__c> lstSLPExpert = new List<SLP_Expert__c>();
                            lstSLPExpert=[SELECT Id FROM SLP_Expert__c where ES_User_ID__c =: esUserID];
                                
                            if(lstSLPExpert.size() > 0)
                            {
                                Delete lstSLPExpert;
                            }
                            //system.debug('lstSLPExpert :'+lstSLPExpert.size());
                            //system.debug('updateProfle.AreaofFocus :'+updateProfle.AreaofFocus.size());
                            //Inserting area of interest if not exists
                            SLP_Secondary_Industry__c  SecondaryIndustry;
                            for(string crntAreaofFocus:updateProfle.AreaofFocus){
                            if(crntAreaofFocus!=null && crntAreaofFocus!='')
                            {
                                List<SLP_Secondary_Industry__c> lstAreaofFocus = new List<SLP_Secondary_Industry__c>();
                                lstAreaofFocus =[SELECT Id FROM SLP_Secondary_Industry__c where Secondary_Industry_Name__c =: crntAreaofFocus];
                                //system.debug('crntAreaofFocus :'+crntAreaofFocus);
                                //system.debug('lstAreaofFocus :'+lstAreaofFocus.size());
                                if(lstAreaofFocus.size()==0)
                                {
                                    SecondaryIndustry = new SLP_Secondary_Industry__c();
                                    SecondaryIndustry.Secondary_Industry_Name__c=crntAreaofFocus;
                                    SecondaryIndustry.Is_Active__c=true;
                                    insert SecondaryIndustry; 
                                    SecondaryIndustryId=SecondaryIndustry.Id;
                                }   
                                else
                                {
                                        SecondaryIndustryId=lstAreaofFocus[0].Id;
                                }
                                 //system.debug('SecondaryIndustryId :'+SecondaryIndustryId);
                                if(SecondaryIndustryId!='')
                                {
                                    //Mappping area of focus
                                    SLP_Expert__c  Expert = new SLP_Expert__c();
                                    Expert.ES_User_ID__c=esUserID;
                                    Expert.SLP_Secondary_Industry_ID__c=SecondaryIndustryId;
                                    Expert.Is_Expert__c=false;
                                    insert Expert; 
                                }
                            }
                                
                            }    
                }
                catch (SLP_Exception e){

                }
                catch (DMLException dmlex){

                }
                finally{}
                return 'Sucessfully updated';
            }
            
             @RemoteAction
            public static List<CommunityInfo> GetFeaturedCommunity()
            {
                string userId=UserInfo.getUserId();
                Set<id> setAvailableCommunityIDs = new Set<id>();
                 Set<id> setSelectedCommunityIDs = new Set<id>();
                List<Community__c> comm = new List<Community__c>();
                
                List<Community_Member__c> lstCommunityMember = new List<Community_Member__c>();
                lstCommunityMember =[SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c =: userId ];
                
                for(Community_Member__c currentCommunityMember: lstCommunityMember){
                setAvailableCommunityIDs.add(currentCommunityMember.Community_Id__c);
                }
                
                List<Community__Share> lstCommunityshare = new List<Community__Share>();
                lstCommunityshare =[SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where UserOrGroupId =: userId ];
                
                for(Community__Share currentCommunityShare: lstCommunityshare){
                    setAvailableCommunityIDs.add(currentCommunityShare.ParentId);
                }
                //system.debug('setAvailableCommunityIDs'+setAvailableCommunityIDs.size());
                comm =[select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Public__c,  Owner.name,Owner.Id,Owner.title,CreatedDate,LastModifiedDate from Community__c where IsActive__c =: True and id NOT IN:setAvailableCommunityIDs Order by LastModifiedDate Desc];
                //system.debug('communities'+comm.size());
                
                 Map<String, Community__c> mapCommunity = new Map<String, Community__c>(); 
                for(Community__c objCommunity : comm)
                {
                    setSelectedCommunityIDs.add(objCommunity.id);
                    mapCommunity.put(objCommunity.id, objCommunity); 
                    
                }
                
                List<AggregateResult> lstsortedCommunityMember = new List<AggregateResult>();
                lstsortedCommunityMember =[SELECT Community_Id__c,Count(Id) FROM Community_Member__c GROUP BY Community_Id__c HAVING Community_Id__c IN :setSelectedCommunityIDs Order by Count(id) Desc];
                
               
                //system.debug('Community__c'+comm.size());
                //system.debug('mapCommunity'+mapCommunity.size());
                //system.debug('lstsortedCommunityMember'+lstsortedCommunityMember.size());
                List<CommunityInfo> lbcustomlist = new List<CommunityInfo>();                       
                CommunityInfo lbCustom;
                Community__c currentCommunity;
                 //Set<id> setAddedCommunityIDs = new Set<id>();
                for(AggregateResult objCommunityMember : lstsortedCommunityMember)
                {
                    string communityID=(string)objCommunityMember.get('Community_Id__c');
                    //system.debug('communityID'+communityID);
                    currentCommunity=new Community__c();
                     currentCommunity=mapCommunity.get(communityID);
                    if(currentCommunity!=null)
                    {
                    setAvailableCommunityIDs.add(communityID);
                    //system.debug('Added to List'+communityID);
                    lbCustom= new CommunityInfo(); 
                    lbCustom.Name = currentCommunity.Name__c; 
                    lbCustom.Description=currentCommunity.description__c;
                    lbCustom.OwnerID=currentCommunity.Owner.Id;
                    //lbCustom.FullOwnername=currentCommunity.Owner.Name;
                    lbCustom.OwnerName = currentCommunity.Owner.Name;
                    lbCustom.OwnerTitle= currentCommunity.Owner.title; 
                    lbCustom.CreateDate=(currentCommunity.CreatedDate).format('MMM dd');
                    lbCustom.isPublic= currentCommunity.Public__c;
                    lbCustom.Id = currentCommunity.id;
                    lbCustom.LastModifiedDate = currentCommunity.LastModifiedDate;
                    lbcustomlist.add(lbCustom);
                    }
                }
                
                comm =[select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Public__c,  Owner.name,Owner.Id,Owner.title,CreatedDate,LastModifiedDate from Community__c where IsActive__c =: True and id NOT IN:setAvailableCommunityIDs Order by LastModifiedDate Desc limit 50];
                for(Community__c objCommuty : comm)
                {
                      //system.debug('No Group Added to List'+objCommuty.id);
                    lbCustom= new CommunityInfo(); 
                    lbCustom.Name = objCommuty.Name__c; 
                    lbCustom.Description=objCommuty.description__c;
                    lbCustom.OwnerID=objCommuty.Owner.Id;
                    
                    lbCustom.OwnerName = objCommuty.Owner.Name;
                    lbCustom.OwnerTitle= objCommuty.Owner.title; 
                    lbCustom.CreateDate=(objCommuty.CreatedDate).format('MMM dd');
                    lbCustom.isPublic= objCommuty.Public__c;
                    lbCustom.Id = objCommuty.id;
                    lbCustom.LastModifiedDate = objCommuty.LastModifiedDate;
                    lbcustomlist.add(lbCustom);
                    
                }
                
                //system.debug('lbcustomlist'+lbcustomlist.size());
                return  lbcustomlist;
            }
            
            @RemoteAction
            public static List<UserProfile> GetUserToFollow()
            {
            //Get User Details
                string userId=UserInfo.getUserId();
                boolean found=false;
                List<ES_User__c> obiResultSets = new List<ES_User__c>();
                Map<String, ES_User__c> mapESUser = new Map<String, ES_User__c>(); 
                List<ES_User__c> loggedInEsUser = new List<ES_User__c>();
                Set<id> setParentIDs = new Set<id>();
                List<UserProfile> lstUserProfile = new List<UserProfile>(); 
                string BusinessGroupId='';
                string RoleID='';
                
                //Set<UserProfile> AllResults = new Set<UserProfile>();
                loggedInEsUser =[SELECT Id, User_Id__c,Role_ID__c,Business_Group_Id__c,Region_Id__c FROM ES_User__c where User_Id__c =:userId];
                
                if(loggedInEsUser.size()>0)
                {
                    BusinessGroupId=loggedInEsUser[0].Business_Group_Id__c;
                    RoleID=loggedInEsUser[0].Role_ID__c;
                 //system.debug('loggedInEsUser Business_Group_Id__c :'+BusinessGroupId);
                 //system.debug('loggedInEsUser Role_ID__c :'+RoleID);
                 }
                List<EntitySubscription> lstEntitySubscription = new List<EntitySubscription>();
                lstEntitySubscription =[SELECT Id, ParentId, SubscriberId FROM EntitySubscription where SubscriberId =: userId ];
                
                for(EntitySubscription objEntitySubscription: lstEntitySubscription){
                setParentIDs.add(objEntitySubscription.ParentId);
                }
                //system.debug('lstEntitySubscription Count :'+lstEntitySubscription.size());
                
                List<AggregateResult> lstEntitySubscriptionOrder = new List<AggregateResult>();
                lstEntitySubscriptionOrder =[SELECT ParentId,Count(SubscriberId) FROM EntitySubscription GROUP BY ParentId having ParentId NOT IN :setParentIDs Order by Count(SubscriberId) Desc];

                //system.debug('lstEntitySubscriptionOrder Count :'+lstEntitySubscriptionOrder.size());
                List<ES_User__c> lstEsUser = new List<ES_User__c>();
                if(BusinessGroupId!='' && RoleID!='')
                {
                lstEsUser =[SELECT Id, User_Id__c,User_Id__r.SmallPhotoUrl,User_Id__r.name,Role_ID__r.Role_Name__c,Role_ID__c,Business_Group_Id__c,Business_Group_Id__r.Business_Group_Name__c,Region_Id__c,Region_Id__r.Region_Name__c FROM ES_User__c where Role_ID__c=:RoleID and Business_Group_Id__c=:BusinessGroupId and User_Id__c!=:userId and User_Id__c NOT IN :setParentIDs];
                }

                for(ES_User__c objEsUser : lstEsUser)
                {
                    setParentIDs.add(objEsUser.User_Id__c);
                    mapESUser.put(objEsUser.User_Id__c, objEsUser); 
                    
                }
                //system.debug('lstEsUser Count :'+lstEsUser.size());
                lstUserProfile=AddUserToList(lstEntitySubscriptionOrder,mapESUser);
                //system.debug('lstUserProfile'+lstUserProfile.size());
                List<ES_User__c> lstEsUser1 = new List<ES_User__c>();
                if(BusinessGroupId!='')
                {
                lstEsUser1 =[SELECT Id, User_Id__c,User_Id__r.SmallPhotoUrl,User_Id__r.name,Role_ID__r.Role_Name__c,Role_ID__c,Business_Group_Id__c,Business_Group_Id__r.Business_Group_Name__c,Region_Id__c,Region_Id__r.Region_Name__c FROM ES_User__c where Business_Group_Id__c=:BusinessGroupId and User_Id__c!=:userId and User_Id__c NOT IN :setParentIDs];
                }
                //system.debug('lstEsUser1 Count :'+lstEsUser1.size());
                mapESUser = new Map<String, ES_User__c>();
                for(ES_User__c objEsUser1 : lstEsUser1)
                {
                    setParentIDs.add(objEsUser1.User_Id__c);
                    mapESUser.put(objEsUser1.User_Id__c, objEsUser1); 
                    
                }
                    List<UserProfile> lstUserProfile12 = new List<UserProfile>(); 
                    lstUserProfile12=AddUserToList(lstEntitySubscriptionOrder,mapESUser);
                    for(UserProfile objUserProfile: lstUserProfile12){
                    lstUserProfile.add(objUserProfile);
                    }
                //system.debug('lstUserProfile12 '+lstUserProfile.size());
                
                List<ES_User__c> lstEsUser2 = new List<ES_User__c>();
                lstEsUser2 =[SELECT Id, User_Id__c,User_Id__r.SmallPhotoUrl,User_Id__r.name,Role_ID__r.Role_Name__c,Role_ID__c,Business_Group_Id__c,Business_Group_Id__r.Business_Group_Name__c,Region_Id__c,Region_Id__r.Region_Name__c FROM ES_User__c where User_Id__c!=:userId and User_Id__c NOT IN :setParentIDs limit 50];
                //system.debug('lstEsUser2 Count  :'+lstEsUser2.size());
                  

                  if(lstUserProfile.size() < 50)
                   {
                    //No filter with top 100
                    UserProfile objUserProfile1;
                    for(ES_User__c currentEsUser : lstEsUser2)
                        {
                           objUserProfile1= new UserProfile();            
                        objUserProfile1.Name = currentEsUser.User_Id__r.name; 
                        objUserProfile1.ImageURL=currentEsUser.User_Id__r.SmallPhotoUrl;
                        objUserProfile1.Role=currentEsUser.Role_ID__r.Role_Name__c;
                        objUserProfile1.Region = currentEsUser.Region_Id__r.Region_Name__c;
                        objUserProfile1.BusinessGroup= currentEsUser.Business_Group_Id__r.Business_Group_Name__c;
                        objUserProfile1.userID=currentEsUser.User_Id__c;
                        objUserProfile1.esUserID=currentEsUser.Id;
                        lstUserProfile.add(objUserProfile1);
                        }
                       /* mapESUser = new Map<String, ES_User__c>();
                        for(ES_User__c objEsUser2 : lstEsUser2)
                        {
                            mapESUser.put(objEsUser2.User_Id__c, objEsUser2); 
                        }
                        //system.debug('mapESUser '+mapESUser.size());
                        
                            List<UserProfile> lstUserProfile1 = new List<UserProfile>(); 
                            lstUserProfile1=AddUserToList(lstEntitySubscriptionOrder,mapESUser);
                            for(UserProfile objUserProfile: lstUserProfile1){
                                lstUserProfile.add(objUserProfile);
                            }*/

                    }
                    
                    
                    //system.debug('lstUserProfile3'+lstUserProfile.size());
    
                
                return  lstUserProfile;
            }
            public static List<UserProfile> AddUserToList(List<AggregateResult> lstEntitySubscriptionOrder,Map<String, ES_User__c> mapESUser)
            {
                List<UserProfile> lstUserProfile = new List<UserProfile>(); 
                UserProfile objUserProfile;
                //system.debug('mapESUser'+mapESUser.size());
                //system.debug('lstEntitySubscriptionOrder'+lstEntitySubscriptionOrder.size());
                 for(AggregateResult objEntitySubscriptionOrder : lstEntitySubscriptionOrder)
                {
                    string UserID=(string)objEntitySubscriptionOrder.get('ParentId');
                    //system.debug('UserID'+UserID);
                    ES_User__c currentEsUser=new ES_User__c();
                     currentEsUser=mapESUser.get(UserID);
                    if(currentEsUser!=null)
                    {
                        //system.debug('Added to List'+UserID);
                        objUserProfile= new UserProfile();            
                        objUserProfile.Name = currentEsUser.User_Id__r.name; 
                        objUserProfile.ImageURL=currentEsUser.User_Id__r.SmallPhotoUrl;
                        objUserProfile.Role=currentEsUser.Role_ID__r.Role_Name__c;
                        objUserProfile.Region = currentEsUser.Region_Id__r.Region_Name__c;
                        objUserProfile.BusinessGroup= currentEsUser.Business_Group_Id__r.Business_Group_Name__c;
                        objUserProfile.userID=currentEsUser.User_Id__c;
                        objUserProfile.esUserID=currentEsUser.Id;
                        lstUserProfile.add(objUserProfile);
                    }
                }
                return  lstUserProfile;
            }
            
            public string GetUserRoleName
            {
             get
             {
               List<es_user__c> userObj = new List<es_user__c>();

                userObj = [select id, Role_ID__r.Role_name__c, User_ID__c from es_user__c where User_ID__c =: UserInfo.getUserId()];

                if(userObj.size() > 0)
                {
                    RoleName = userObj[0].Role_ID__r.Role_name__c;
                }

                return RoleName;
             }
             set;
            }
            
            public string GetAboutMe
            {
             get
             {
               List<User> userObj = new List<User>();

                userObj = [select id, AboutMe,title from User where id =: UserInfo.getUserId()];

                if(userObj.size() > 0)
                {
                    selfAboutMe = userObj[0].AboutMe;
                }

                return selfAboutMe;
             }
             set;
            }
            
            public boolean FirstLogin
            {
             get
             {
               List<LoginHistory> objLoginHistory = new List<LoginHistory>();

                objLoginHistory = [SELECT Id, UserId, LoginTime FROM LoginHistory where userid=: UserInfo.getUserId()];

                if(objLoginHistory.size() <=1)
                {
                    isFirstLogin = true;
                }
                else
                {
                    isFirstLogin = false;
                }

                return isFirstLogin;
             }
             set;   
            }
            public boolean WizardComplete
            {
             get
             {
               List<ES_User__c> objESUser = new List<ES_User__c>();

                objESUser = [SELECT Profile_Wizard_Complete__c, User_Id__c FROM ES_User__c where User_Id__c=: UserInfo.getUserId()];

                if(objESUser.size()>0)
                {
                    IsWizardComplete = objESUser[0].Profile_Wizard_Complete__c;
                }
                else
                {
                    IsWizardComplete=false;
                }

                return IsWizardComplete;
             }
             set;
            }
            
            public string GetTitle
            {
             get
             {
              List<User> userObj = new List<User>();

                userObj = [select id, AboutMe,title from User where id =: UserInfo.getUserId()];

                if(userObj.size() > 0)
                {
                    selfTitle = userObj[0].title;
                }

                return selfTitle;
             }
             set;
            }
            
            public string GetDepartment
            {
             get
             {
              List<User> userObj = new List<User>();

                userObj = [select id, Department from User where id =: UserInfo.getUserId()];

                if(userObj.size() > 0)
                {
                    selfDepartment = userObj[0].Department;
                }

                return selfDepartment;
             }
             set;
            }
             public string AssociatedSkills
            {
                get
                {    
                    string userSkil='';

                    List<SLP_Expert__c> listSlpExpert =new List<SLP_Expert__c>();
                
                    listSlpExpert = [select id, Es_User_ID__c, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__r.Industry_Name__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c from SLP_Expert__c where ES_User_ID__r.User_ID__c =: UserInfo.getUserId() and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];

                    for(SLP_Expert__c usk: listSlpExpert)
                    {
                    if(usk.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c!=null && usk.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c!='')
                    {
                        userSkil= userSkil + usk.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c + ',';
                        }
                    }
                    if(userSkil.endsWith(','))
                    {
                        userSkil = userSkil.removeEnd(',');
                    }

                    //system.debug('userSkil:' + userSkil);

                    return userSkil;
                }
                set
                {
                    AssociatedSkills = value;
                }
            }
               public class UpdateProfile
              {
                 public string Role{get;set;}
                 public string Title {get;set;}
                  public string Department {get;set;}
                 public List<string> AreaofFocus {get;set;}
                 public string AboutMe{get;set;}
                public string UserEmail{get;set;}
                public string SfInstance{get;set;}
                public boolean DefaultBoardExist{get;set;}
                public string DefaultBoardId{get;set;}
                public List<string> communityIDs{get;set;}
                 public List<string> PrivateCommunityIDs{get;set;}
                  
                  public List<string> userProfileIDs{get;set;}
              }
             public class UserProfile
              {
                 public string Name{get;set;}
                 public string ImageURL {get;set;}
                 public string Role {get;set;}
                 public string Region{get;set;}
                 public string BusinessGroup{get;set;}
                 public string userID{get;set;}
                 public string esUserID{get;set;}
              }
             public class CommunityInfo
              {
                 public string Name{get;set;}
                 public string Id {get;set;}
                 public string Description {get;set;}
                 public string OwnerID{get;set;}
                 public boolean isPublic{get;set;}
                 public string OwnerName{get;set;}
                 public string CreateDate{get;set;}
                public string OwnerTitle{get;set;}
                public Datetime LastModifiedDate{get;set;}
              }
              
               @RemoteAction
    public static string LibraryLogMetrics(string boardId,string boardName,string operatingSystem,string browserVersion,string DeviceType,string section,string GenerateUrl,string ObjNm,string actionTyp,string redirectUrl)
    {  
        
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        metricsObj.ActionType__c=actionTyp;
        metricsObj.ObjectId__c=boardId;
        metricsObj.ObjectName__c=ObjNm;
        if(boardName!='' && boardName!=null)
        {
          metricsObj.Text__c=boardName.trim(); 
        }
        metricsObj.PageName__c='Activity page';
        metricsObj.DeviceType__c=DeviceType;
        metricsObj.TabSection__c=section;
        metricsObj.ActionPath__c=GenerateUrl;
        metricsObj.SessionId__c=UserInfo.getSessionId();
        Insert(metricsObj);
        return redirectUrl;
    }
    public PageReference RedirectToPage()
    {
    PageReference pRef = new PageReference(RedirectUrl);
       
        pRef.setRedirect(true);
        return pRef;
    }
    
        }