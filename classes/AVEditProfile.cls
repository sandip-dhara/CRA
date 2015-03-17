public without sharing class AVEditProfile
{
    public User useredit { get; set; }
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
    public string Availskill{get;set;}
    public Boolean LBShare{get;set;}
    public Boolean LBRate{get;set;}
    public Boolean TShare{get;set;}
    public Boolean TRate{get;set;}
    public Boolean UFollow{get;set;}
    public string skilltags {get;set;}
    public string AboutMe{get;set;}
    public string Title{get;set;}
    public Decimal TotalRating{get;set;}    
    public string Tw {get;set;}
    public string Tch {get;set;}
    
    
    
    
    List<string> strlst=new List<string>();
    
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
        public Decimal AvgRating{get;set;}            
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


    public AVEditProfile()
    {
        system.debug('@@@@esuser'+esuser);
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        useredit = [select id, name,title,aboutme,Department,SmallPhotoUrl,fullphotourl,city,state,country from user where id=:this.AthenaUserId];
        AboutMe=useredit.aboutme;
        
        Title=(useredit.title==null?'':useredit.title)+(useredit.department==null?'':', '+useredit.department);
        Location=(useredit.city==null?'':useredit.city)+(useredit.state==null?'':', '+useredit.state)+(useredit.country==null?'':', '+useredit.country);
        esuser=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c=:this.AthenaUserId Limit 1];
        system.debug('@@@@esuser'+esuser);
        if(esuser!=null)
        {
        Tw=esuser.Twitter__c;
        Tch=esuser.Linked_In__c;
        }
        
        
        //list<ES_User__c> lstEs=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c=:this.AthenaUserId ];
        
        
        
        userskilledit=[select Skill_ID__c,User_ID__c,Skill_ID__r.Name__c from User_Skill__c where User_ID__c=:this.AthenaUserId order by Skill_ID__r.Name__c asc];
        proedit=[select Name__c,Timeframe__c,Description__c,User_Id__c from Project__c where User_Id__c=:this.AthenaUserId];
        //strlst=[select id,name__c from skill__c where is_active__c=true];
        
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords(); 
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        GetLBFollowingList();
        Availskill=getAvailableskill();
        RefreshMyNotifications();

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
    
    public void RefreshMyNotifications()
    {
            //murali code
        List<user_Notification_Subscription__c> UN = [select id,Notification_Event_ID__r.name__c,isActive__c from User_Notification_subscription__c where Notification_Event_ID__r.isactive__c=:true and Subscriber_User_ID__c =:this.AthenaUserID];
        user usr = [select id, UserPreferencesDisableFollowersEmail from user where id =:this.AthenaUserID limit 1];
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
        //UFollow = usr.UserPreferencesDisableFollowersEmail;
        system.debug('%%'+usr.UserPreferencesDisableFollowersEmail);
        if(usr.UserPreferencesDisableFollowersEmail==true){
            UFollow =false;
        }
        else if(usr.UserPreferencesDisableFollowersEmail==false){
            UFollow =true;
        }
        system.debug('%%'+usr.UserPreferencesDisableFollowersEmail);

                //murali code             
         

    }
    
        Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    public String getAvailableskill()
    {
        List<skill__c> skil=[SELECT name__c FROM skill__c where is_active__c =true order by name__c];        
        string Avlbleskil='';
        for(skill__c ski:skil)
        {           
             Avlbleskil+= '\'' + string.valueOf(ski.name__c) +  '\'' + ',';             
        }
        return  Avlbleskil;
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
       
    Public void saveUserProfile()
    {
      system.debug('skilltags:'+skilltags);
      system.debug('Location:'+Location);
      List<User> ulist=new List<User>();
      List<ES_User__c> esuserlist=new List<ES_User__c>();
      List<User_Skill__c> userskilllist=new List<User_Skill__c>();
      List<Project__c> prolist=new List<Project__c>();
      string[] splitData;
      string[] splitloc;
      
      system.debug('!!!!!!!!!!ulist'+ulist);
      system.debug('!!!!!!!!!!useredit'+useredit.Name);
      
      // to save My Notifications
      SaveMyNotifications();     

      
      User u=[select id from user where id=:this.AthenaUserId];
      
      if(Title==null)
      {
      splitData=new string[2];
      splitData[0]='';
      splitData[1]='';
      }
      if(Title!=null && !Title.contains(','))
      {
      splitData=new string[2];
      splitData[0]=Title;
      splitData[1]='';
      }
      else
      {
      splitData=Title.split(',');
      }
      
      if(Location==null)
      {
      splitloc=new string[3];
      splitloc[0]='';
      splitloc[1]='';
      splitloc[2]='';
      }
      
      if(Location!=null && !Location.contains(','))
      {
      splitloc=new string[3];
      splitloc[0]=Location;
      splitloc[1]='';
      splitloc[2]='';
      }
      else
      {
      splitloc=Location.split(',');
      }
      
      u.Title=splitData[0];
      u.Department=splitData[1];
      
      u.aboutme=AboutMe;
      if(splitloc.size()>1)
      u.city=splitloc[0];
      if(splitloc.size()>=2)
      u.state=splitloc[1];
      if(splitloc.size()==3)
      u.country=splitloc[2];
            system.debug('U id: '+u.id);
      update u;
      
            //system.debug('Title: '+splitData[0]+'Department: '+splitData[1]+'AboutMe: '+AboutMe+'City: '+splitloc[0]+'State: '+splitloc[1]+'Country: '+splitloc[2]);
      
      //ulist.add(useredit);
      system.debug('!!!!!!!!!!ulist'+ulist);
      system.debug('Athena User Id: '+this.AthenaUserId);

      //update ulist;
      //update useredit;
      
      AssociateSkills();
      //if(esuser.size()>0)
      //{
      //esuserlist.addAll(esuser);
      system.debug('!!!!!!!!!!esuserlist'+esuserlist);
      //}
      upsert esuser;
      
      /*for (User_Skill__c us:skilltags)
      {
       userskilllist.add(us);
      }
      system.debug('!!!!!!!!!!userskilllist'+userskilllist);
      upsert userskilllist;*/

      
      for (Project__c pro:proedit)
      {
        prolist.add(pro);
      }
      system.debug('!!!!!!!!!!prolist'+prolist);
      upsert prolist;      
      
       //system.debug('@@@@@@@@@@@@@@@'+AssociatedSkills);
    }
    
        //It will Associate tags to perticualr object's record  
    public void AssociateSkills()
    {         
        List<string> skills=skilltags.split(',');
        If(userskilledit==null || userskilledit.size()==0)
        {
            List<User_Skill__c> usrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:this.AthenaUserId];          
            delete usrSkills;   
        }
        else
        {
            for (string strtag:skills)
            {
                                                   
                List<User_Skill__c> remUsrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:this.AthenaUserId and Skill_ID__r.Name__c not In:skills];          
                delete remUsrSkills;
                
                List<Skill__c> lstSkill=[SELECT Id, Name__c, Is_Active__c FROM Skill__c Where Name__c=:strtag];   
                boolean isSkillxst=false;
                Skill__c skil=new Skill__c();     
                for(Skill__c sk:lstSkill)
                {
                    isSkillxst=true;  
                    skil.id=sk.id;  
                }
    
                if(!isSkillxst)
                {
                    skil.Name__c=strtag;
                    skil.Is_Active__c=true;
                    insert skil;                        
                }
    
                List<User_Skill__c> UsrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:AthenaUserId and Skill_ID__c=:skil.id];          
   
                if(UsrSkills.size()==0)
                {
                    User_Skill__c uskil= new User_Skill__c();
                    uskil.Skill_ID__c=skil.id;
                    uskil.User_ID__c=AthenaUserId;
                    insert uskil;
                }    
            }        
        }
    }

    
    public string AssociatedSkills
    {
                   
           get{    
                    string userSkil='';
                    List<User_Skill__c> lstusrSkills=[SELECT Skill_ID__r.Name__C FROM User_Skill__c where User_ID__c=:AthenaUserId order by Skill_ID__r.Name__C];
                    for(User_Skill__c usk:lstusrSkills)
                    {
                       userSkil= userSkil + usk.Skill_ID__r.Name__C + ',';
                    }
                    if(userSkil.endsWith(','))
                    {
                       userSkil = userSkil.removeEnd(',');
                    }
                    return userSkil;
                }
                set {AssociatedSkills = value;}
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


    Public void CalculateTotalRatings()
    {
        List<id> learningBoardIds=new List<id>();

        List<Learning_Board__c> LearningBoards=[select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:this.AthenaUserId and Is_Active__c=True];
        
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
    
    // START - Notification Events 
    
public class CustomNotificationEvent
{
public string NotificationEventName{get;set;}
public boolean Value{get;set;}
}

        public void SaveMyNotifications()
        {
            List<CustomNotificationEvent> events=new List<CustomNotificationEvent>();
            system.debug('Share Topic: '+TShare);
            system.debug('share Learning Board: '+LBShare);
            CustomNotificationEvent obj=new CustomNotificationEvent();
            obj.NotificationEventName='Share Topic';
            obj.Value=TShare;
            events.add(obj);
           obj=new CustomNotificationEvent();
            obj.NotificationEventName='share Learning Board';
            obj.Value=LBShare;
            events.add(obj);
            obj=new CustomNotificationEvent();
            obj.NotificationEventName='Rate Learning Board';
            obj.Value=LBRate;
            events.add(obj);
            obj=new CustomNotificationEvent();
            obj.NotificationEventName='Rate Topic';
            obj.Value=TRate;
            events.add(obj);
            boolean exists=false;
            string notificationName='';
            boolean checked=false;
            
            List<User_Notification_Subscription__c> UNS =[select id,Subscriber_User_ID__c,isactive__c,Notification_Event_ID__r.name__c,Notification_Event_ID__r.id,Notification_Event_ID__r.isactive__c from User_Notification_Subscription__c where Subscriber_User_ID__c=:this.AthenaUserID];
            system.debug('UNS: '+UNS);
            if(UNS.size()>0){
                system.debug('Inside IF');
                for(CustomNotificationEvent evts:events){                
                    notificationName='';
                    checked=evts.Value;
                    notificationName=evts.NotificationEventName;
                    exists=false;
                    for(User_Notification_Subscription__c temp: UNS ){
                        if(evts.NotificationEventName==temp.Notification_Event_ID__r.name__c){                    
                            exists=true;
                        }
                    }
                    if(exists)
                    {
                        User_Notification_Subscription__c usnObj=[select id from User_Notification_Subscription__c where Notification_Event_ID__r.name__c=:notificationName and Subscriber_User_ID__c=:this.AthenaUserId limit 1];         
                        usnObj.IsActive__c=checked;
                        update usnObj;
                    }
                    else
                    {
                        Notification_Event__c NE = [select id,name__c from notification_Event__c where name__c=:notificationName limit 1];
                        //insert
                        User_Notification_Subscription__c usnObj=new User_Notification_Subscription__c();                                                                         
                        usnObj.IsActive__c=checked;
                        usnObj.Notification_Event_ID__c=NE.id;
                        usnObj.Subscriber_User_ID__c=this.athenaUserID;
                        //system.debug('usnobj: '+usnObj);                    
                        insert usnObj;
                        //system.debug('insert usnObj****'+usnObj.id);
                    }
                }                               
            }
            else
            {
                List<Notification_Event__c> NE = [select id,name__c from notification_Event__c];
                for(Notification_Event__c temp:NE ){
                    for(CustomNotificationEvent evts:events){
                        if(evts.NotificationEventName==temp.name__c){
                            //insert
                            User_Notification_Subscription__c usnObj=new User_Notification_Subscription__c();                                                                         
                            usnObj.IsActive__c=evts.Value;
                            usnObj.Notification_Event_ID__c=temp.id;
                            usnObj.Subscriber_User_ID__c=this.athenaUserID;
                            system.debug('usnobj: '+usnObj);
                            
                            insert usnObj;
                           system.debug('insert usnObj****'+usnObj.id);
                        }
                    }
                }
            }
            User u = [SELECT Id, UserPreferencesDisableFollowersEmail FROM User where id =:this.AthenaUserID];
            //boolean ufollow=true;            
            system.debug('**'+u.id);
            system.debug('in if'+u.UserPreferencesDisableFollowersEmail);
            if (UFollow==true){
              system.debug('#@!'+u.UserPreferencesDisableFollowersEmail);
              u.UserPreferencesDisableFollowersEmail=false;
            }
            else{
              system.debug('else if'+u.UserPreferencesDisableFollowersEmail);
              u.UserPreferencesDisableFollowersEmail=true;
            }
            system.debug('^^'+u.UserPreferencesDisableFollowersEmail);
            update u;
            system.debug('&&'+u.UserPreferencesDisableFollowersEmail);
            
        }
        

    
    // END - Notification Events  
    

    
}