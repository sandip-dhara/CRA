public with sharing class PavithraEditUserProfilePageController
{
    public User useredit { get; set; }
    public User changeUserImage{get;set;}
    Public String strSearchValue{get;set;}
    Public String AthenaUserId{get;set;}
    public ES_User__c esuser{get;set;}
    public String linkedinurl{get;set;}
    public String twitterurl{get;set;}
    public List<User_Skill__c> userskilledit{get;set;}
    public List<Project__c> proedit{get;set;}
    public boolean IsLoggedInUser{get;set;}
    public boolean displayPopup {get; set;} 
    Public string recoruserid{get;set;}
    public string Location{get;set;}
    public string Expertise{get{return UserExpertise();}set;}
    public integer BoardsCount{get;set;} 
    public integer PeopleFollowingCount{get;set;} 
    public integer BoardFollowingCount{get;set;}
    public integer FollowersCount{get;set;}
    public integer BoardsContributedCount{get;set;}
    
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
    List<User> followers = new List<User>(); 


    public PavithraEditUserProfilePageController()
    {
        system.debug('@@@@esuser'+esuser);
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        useredit = [select id, name,title,aboutme,Department,SmallPhotoUrl,fullphotourl from user where id=:this.AthenaUserId];
        esuser=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c=:this.AthenaUserId];
        userskilledit=[select Skill_ID__c,User_ID__c,Skill_ID__r.Name__c from User_Skill__c where User_ID__c=:this.AthenaUserId];
        proedit=[select Name__c,Timeframe__c,Description__c,User_Id__c from Project__c where User_Id__c=:this.AthenaUserId];
        system.debug('@@@@esuser'+esuser);
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords(); 
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        GetLBFollowingList();

        followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:recoruserid and SubscriberId=:userinfo.getuserid())];
        
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
    }
    
        Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    public string UserExpertise()
    {
     string expertiseName='';
      for (User_Skill__c us:userskilledit)
      {
       expertiseName=expertiseName+us.Skill_ID__r.Name__c+',';
      } 
      return expertiseName;     
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
    
    Public User GetLoggedinUserDtls(){
        User u = new User();
        u = [Select SmallPhotoUrl,Name,id From User where User.id= :UserInfo.getUserId()];
        system.debug('############ GetLoggedinUserDtls'+ u.Name);
        return u;         
    }
    Public User getUserDtls()
    {
        User u = [Select u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone,u.city,u.state,u.country  From User u where u.id =:this.AthenaUserId];
        Location=String.ValueOf(u.city)+',' +String.ValueOf(u.state)+','+String.ValueOf(u.country);
        system.debug('############'+u.id);
        return U;
        
    }
    public List<User> GetFollowers() 
    { 
                List<User> Followers = [SELECT Id, Name, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUserId AND SubscriberId !=:AthenaUserId) ]; 
                
                FollowersCount = Followers.size(); 
                return Followers; 
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
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void saveChangeProfileImage() {
        changeUserImage = [select id,SmallPhotoUrl,fullphotourl from user where id=:UserInfo.getUserId()];
        insert changeUserImage;
    }
       
    Public void saveUserProfile()
    {
      List<User> ulist=new List<User>();
      List<ES_User__c> esuserlist=new List<ES_User__c>();
      List<User_Skill__c> userskilllist=new List<User_Skill__c>();
      List<Project__c> prolist=new List<Project__c>();
      system.debug('!!!!!!!!!!ulist'+ulist);
      system.debug('!!!!!!!!!!useredit'+useredit.Name);
     
      ulist.add(useredit);
      system.debug('!!!!!!!!!!ulist'+ulist);
      //update ulist;
      update useredit;
      
      esuserlist.add(esuser);// By Komala
      system.debug('!!!!!!!!!!esuserlist'+esuserlist);
      upsert esuserlist;
      
      for (User_Skill__c us:userskilledit)
      {
        userskilllist.add(us);
      }
      system.debug('!!!!!!!!!!userskilllist'+userskilllist);
      upsert userskilllist;
      for (Project__c pro:proedit)
      {
        prolist.add(pro);
      }
      system.debug('!!!!!!!!!!prolist'+prolist);
      upsert prolist;      
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
       private List<User> GetLBUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from learning_board__c)];
        return userImgLst;
    }
}