public without sharing class SLP_EditUserProfileController
{
    public User useredit { get; set; }
    Public String strSearchValue{get;set;}
    Public String AthenaUserId{get;set;}
    public List<ES_User__c> esuser{get;set;}
    public String linkedinurl{get;set;}
    public String twitterurl{get;set;}
    public List<User_Skill__c> userskilledit{get;set;}
    public List<Project__c> proedit{get;set;}
    public boolean IsLoggedInUser{get;set;}
    public boolean displayPopup {get; set;} 
    Public string recoruserid{get;set;}
    public String Location{get;set;}
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
    public string Roletags {get;set;}
    public string AboutMe{get;set;}
    public string Title{get;set;}
    public Decimal TotalRating{get;set;}    
    public string RoleName {get; set;}
    public string AvailsRoles{get;set;}
    public string AvailableExperts {get;set;}
    public integer communityCount{get;set;}
    public integer communityContributeCount{get;set;}
    public integer BoardsTotalCount { get; set; }
    public integer communityTotalCount{get;set;}
    public integer UserContCmListCount;
    public integer UserOwnedCmListCount;    
    public integer UserOwnedLBListCount;
    public integer UserContLbListCount;
    public integer learningBoardsCount{get;set;}
    public integer communitymemberCount{get;set;}
    public String userEmailId{get;set;}
    public string nameFile{get;set;}
    public Transient Blob contentFile{get;set;}
    
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
    List<string> strlst=new List<string>();
    
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
    public List<LearningBoardCustomClass> UserMembers { get; set; }
    public List<LearningBoardCustomClass> myBoardMembers{get;set;}
    List<User> followers = new List<User>(); 


    public SLP_EditUserProfileController()
    {
        userEmailId = UserInfo.getUserEmail();
        string emptyLocation;
        string city,state,country;
        system.debug('@@@@esuser'+esuser);
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        useredit = [select id, name,title,aboutme,Department,SmallPhotoUrl,fullphotourl,city,state,country from user where id=:this.AthenaUserId Limit 1];
        AboutMe=useredit.aboutme;
        
        Title=(useredit.title==null?'':useredit.title)+(useredit.department==null?'':', '+useredit.department);
        system.debug('City: '+useredit.city+' State: '+useredit.state+' Country: '+useredit.country);
        city=useredit.city;state=useredit.state;country=useredit.country;
        Location=(city==null?'':city)+(state==null?'':', '+state)+(country==null?'':', '+country);
        system.debug('Location: '+Location);
        if(Location=='null, null, null')
        Location=emptyLocation;        
        
        system.debug('Location: '+Location);
        esuser=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c=:this.AthenaUserId limit 1];
        if(esuser.size()>0)
        {
        for(ES_USER__c esUserObj:esuser)
        {
        twitterurl=esUserObj.Twitter__c;
        system.debug('Twitter URL: '+twitterurl);
        linkedinurl=esUserObj.Linked_In__c;
        }
        }        
        userskilledit=[select Skill_ID__c,User_ID__c,Skill_ID__r.Name__c from User_Skill__c where User_ID__c=:this.AthenaUserId order by Skill_ID__r.Name__c asc];
        proedit=[select Name__c,Timeframe__c,Description__c,User_Id__c from Project__c where User_Id__c=:this.AthenaUserId];
        //strlst=[select id,name__c from skill__c where is_active__c=true];
        system.debug('@@@@esuser'+esuser);
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        UserMembers = new List<LearningBoardCustomClass>();
        myBoardMembers = new List<LearningBoardCustomClass>();
        communityMembers = new List<CommunityCustomClass>();
        myCommuniteMembers = new List<CommunityCustomClass>();
        List<Learning_Board__c> LearningBoardsContributed=(List<Learning_Board__c>)UserCon.getRecords();
        List<Learning_Board__c> LearningBoardsOwned=(List<Learning_Board__c>)UserOwnedCon.getRecords(); 
        List<Community__c> COmmunityContributed = (List<Community__c>)UserConCm.getRecords();
        List<Community__c> COmmunityOwned = (List<Community__c>)UserOwnedCominites.getRecords();        
        GetUserContLbList(LearningBoardsContributed); 
        GetUserOwnedLBList(LearningBoardsOwned);
        GetUserContCmList(COmmunityContributed);
        GetUserOwnedCmList(COmmunityOwned);
        GetLBFollowingList();
        GetAllBoards();
        GetAllCommunity();
        Availskill=getAvailableskill();
        AvailsRoles=FetchRoles();
        AvailableExperts=FetchExperts();
        RefreshMyNotifications();
        CalculateTotalRatings();

        followers = [SELECT Id, Name, SmallPhotoUrl,title FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:recoruserid and SubscriberId=:userinfo.getuserid())];
        
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
        
        FetchUserProfileRole();
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
             Avlbleskil+= '\'' + string.valueOf(ski.name__c.replace('\'','')) +  '\'' + ',';             
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
    
     public List<SLP_Expert__c> GetExpert()
     {
        
        List<SLP_Expert__c> listSlpExpert =new List<SLP_Expert__c>();
        
        listSlpExpert = [select id,Es_User_ID__c,ES_User_ID__r.User_ID__c,SLP_Secondary_Industry_ID__r.Industry_Name__c,SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c from SLP_Expert__c where ES_User_ID__r.User_ID__c =: this.AthenaUserId and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
        
        return listSlpExpert;
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
        //Location=String.ValueOf(u.city)+',' +String.ValueOf(u.state)+','+String.ValueOf(u.country); By Komala
        system.debug('############'+u.id);
        return U;
        
    }
    public List<User> GetFollowers() 
    { 
                List<User> Followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:AthenaUserId AND SubscriberId !=:AthenaUserId) ]; 
                
                FollowersCount = Followers.size(); 
                return Followers; 
    }
    Public List<User> followg{
       get{
               followg=[SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId];
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
                        
      system.debug('GetUserRoleName:'+skilltags);
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
     // SaveMyNotifications();     

      
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
      
      //AssociateSkills();
      //if(esuser.size()>0)
      //{
      //esuserlist.addAll(esuser);
      //system.debug('!!!!!!!!!!esuserlist'+esuserlist);
      //}
      //upsert esuserlist;
      system.debug('Roletags:'+Roletags);
      string RoleId='';
     List<SLP_Role__c> lstSlpRole= [SELECT Id, Role_Name__c FROM SLP_Role__c where Is_Active__c =true  and Role_Name__c =:Roletags ];
      if(lstSlpRole.size()>0)
      {
        RoleId=lstSlpRole[0].Id;
      }
      else
      {
       if((Roletags!='') &&(Roletags!=null))
       {
        SLP_Role__c src=new SLP_Role__c();
        src.Role_Name__c=Roletags;
        src.Is_Active__c=true;
         insert src;
         RoleId=src.Id;
       }
      }
      system.debug('RoleId:'+RoleId);
      
      List<ES_User__c> eu=[select id from ES_User__c where User_Id__c=:this.AthenaUserId limit 1];
      system.debug('eu:'+eu);
      if(eu.size()>0)
       {
           eu[0].Twitter__c=twitterurl;
           eu[0].Linked_In__c=linkedinurl;
           if(RoleId!='')
           {
             eu[0].Role_ID__c =RoleId;
           }
           system.debug('Update:');
            update eu[0];
       }
       else
       {
        ES_User__c insertESUser=new ES_User__c();
        insertESUser.User_Id__c=this.AthenaUserId;
            if(linkedinurl!=null)
            {
              insertESUser.Linked_In__c=linkedinurl;
            }
            if(twitterurl!=null)
            {
            insertESUser.Twitter__c=twitterurl;
            }
           if(RoleId!='')
           {
             insertESUser.Role_ID__c =RoleId;
           }
           system.debug('Insert:');
           
           
         insert insertESUser;
       }
      
      for (Project__c pro:proedit)
      {
        prolist.add(pro);
      }
      system.debug('!!!!!!!!!!prolist'+prolist);
      upsert prolist;  
        List<string> skills = new List<string>();
        system.debug('skilltags: '+ skilltags);

        if(skilltags !='') 
        {
            if(!skilltags.contains(','))  
                skills.Add(skilltags); 
            else
                skills=skilltags.split(',');
        }     
        system.debug('skilltags: '+ skills);
      AssociateExperts(skills,this.AthenaUserId);
       //system.debug('@@@@@@@@@@@@@@@'+AssociatedSkills);
    }
    
        //It will Associate tags to perticualr object's record  
    public void AssociateSkills()
    {   
        List<string> skills = new List<string>();
        system.debug('skilltags: '+ skilltags);

        if(skilltags !='') 
        {
            if(!skilltags.contains(','))  
                skills.Add(skilltags); 
            else
                skills=skilltags.split(',');
        }      

        string userId = this.AthenaUserId;
        system.debug('skills: '+ skills);
        //If(userskilledit==null || userskilledit.size()==0)
        
        if(skills.size() == 0)
        {
            //List<SLP_Expert__c> listSlpExpert = [select id, Es_User_ID__c, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__r.Industry_Name__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c from SLP_Expert__c where ES_User_ID__r.User_ID__c =: this.AthenaUserId];

            //delete listSlpExpert;

            List<User_Skill__c> usrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:this.AthenaUserId];          
            delete usrSkills;   
        }
        else
        {

            List<User_Skill__c> remUsrSkills = [SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:this.AthenaUserId and Skill_ID__r.Name__c not In:skills];          
            delete remUsrSkills;
            
            List<Skill__c> lstSkill=[SELECT Id, Name__c, Is_Active__c FROM Skill__c];
            List<User_Skill__c> UsrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:userId];          
            
            for (string strtag:skills)
            {                                               
                //List<Skill__c> lstSkill=[SELECT Id, Name__c, Is_Active__c FROM Skill__c Where Name__c=:strtag];   
                boolean isSkillxst=false;
                Skill__c skil=new Skill__c(); 
    
                for(Skill__c sk:lstSkill)
                {
                    if(sk.Name__c==strtag)
                    {
                        isSkillxst=true;  
                        skil.id=sk.id; 
                    } 
                }
    
                if(!isSkillxst)
                {
                    skil.Name__c=strtag;
                    skil.Is_Active__c=true;
                    insert skil;                        
                }
    
                boolean isUserSkillExists=false;
                //List<User_Skill__c> UsrSkills=[SELECT User_ID__c, Skill_ID__c, Id FROM User_Skill__c where User_ID__c=:userId and Skill_ID__c=:skil.id]; By Komala
                if(UsrSkills.size()>0)
                {
                for(User_Skill__c usrSkill: UsrSkills)
                {
                isUserSkillExists=false;
                if(usrSkill.Skill_ID__c==skil.id)
                {
                isUserSkillExists=true;
                }           
                
                }
                //if(UsrSkills.size()==0) By Komala
                if(!isUserSkillExists)
                {
                    User_Skill__c uskil= new User_Skill__c();
                    uskil.Skill_ID__c=skil.id;
                    uskil.User_ID__c=userId;
                    insert uskil;
                }    
                }
                else
                {
                    User_Skill__c uskil= new User_Skill__c();
                    uskil.Skill_ID__c=skil.id;
                    uskil.User_ID__c=userId;
                    insert uskil; 
                }  
                
            }        
        }
    }

    public string AssociatedSkills
    {
        get
        {    
            string userSkil='';

            List<SLP_Expert__c> listSlpExpert =new List<SLP_Expert__c>();
        
            listSlpExpert = [select id, Es_User_ID__c, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__r.Industry_Name__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c from SLP_Expert__c where ES_User_ID__r.User_ID__c =: this.AthenaUserId and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];

            for(SLP_Expert__c usk: listSlpExpert)
            {
                userSkil= userSkil + usk.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__c + ',';
            }
            if(userSkil.endsWith(','))
            {
                userSkil = userSkil.removeEnd(',');
            }

            system.debug('userSkil:' + userSkil);

            return userSkil;
        }
        set
        {
            AssociatedSkills = value;
        }
    }
     
    Public ApexPages.standardSetController UserOwnedCon{    
        get{
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
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where id In:lbsid]));                           
                //UserCon.setPageSize(4);
                }
                else
                {
                UserCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title,Is_Active__c, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and id In:lbsid]));                           
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
                lbCustom.IsActive=lb.Is_Active__c;
                for(User userData:userImagesLst)
                {
                if(userData.Id==lb.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                lbCustom.LBOwnerURL =  userImageUrl;
                lbCustom.id=lb.id;
                lbCustom.LBId=lb.id;
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
                
                If(RatedItemMap.containskey(lb.id))
                {
                    lbCustom.AvgRating=RatedItemMap.get(lb.id);
                }
                else
                {
                lbCustom.AvgRating=0;
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
                lbCustom.LBId=lb.id;
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
      
            Public void GetLBFollowingList()
            {
            //UserOwnedLBList.clear();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            List<Learning_Board__c> LearningBoards=new List<Learning_Board__c>();
            string resourceURL= GetResourceURL('img_athena');
            if(this.AthenaUserId==userinfo.getuserid())
            {
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Id !=:AthenaUserId]);
            }
            else
            {
            LearningBoards=([SELECT id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate FROM Learning_Board__c WHERE Id IN (SELECT ParentId FROM EntitySubscription WHERE SubscriberId =:AthenaUserId) AND Is_Active__c=:true AND Id !=:AthenaUserId]);
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
                lbCustom.LBId=lb.id;
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


    Public void CalculateTotalRatings()
    {
        List<id> learningBoardIds=new List<id>();

        List<Learning_Board__c> LearningBoards=[select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c where owner.id=:this.AthenaUserId and Is_Active__c=True];
        
        if(LearningBoards.size()>0)
        {
            for (Learning_Board__c lb: LearningBoards)
            {
            learningBoardIds.add(lb.id);
            }

            Map<id,decimal> RatedItemMap=GetRatedItemData(learningBoardIds);

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
        private List<User> GetCMUserImagesLst(){
            List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from Community__c)];
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
    
    public string GetUserRoleName
    {
     get
     {
       List<es_user__c> userObj = new List<es_user__c>();

        userObj = [select id, Role_ID__r.Role_name__c, User_ID__c from es_user__c where User_ID__c =: this.AthenaUserId];

        if(userObj.size() > 0)
        {
            RoleName = userObj[0].Role_ID__r.Role_name__c;
        }

        return RoleName;
     }
     set;
    }
    
      public string FetchExperts()
      {
       List<SLP_Secondary_Industry__c> lstSecInd= [SELECT Id, Secondary_Industry_Name__c FROM SLP_Secondary_Industry__c where Is_Active__c =true order by Secondary_Industry_Name__c ];
       string AvailExperts='';
            if(lstSecInd.size() > 0)
            {
              for(SLP_Secondary_Industry__c SSI: lstSecInd)
              {
                AvailExperts+= '\'' + string.valueOf(SSI.Secondary_Industry_Name__c.replace('\'','')) +  '\'' + ',';             
              }
            }
            return AvailExperts;
       
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
    
    public class CommunityCustomClass{
        public String CMOwnerURL{get;set;}
        Public id AttachmentId{get;set;}
        public string CMOwnerID{get;set;}
        Public String CMName{get;set;}
        public String CMOwnerTitle{get;set;} 
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
    public List<CommunityCustomClass> communityMembers{ get; set; }
    public List<CommunityCustomClass> myCommuniteMembers{get;set;}

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
        system.debug('UserContCmList---------'+Comminites.size());
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
            system.debug('userImageUrl---------'+userImageUrl);
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
        system.debug('UserOwnedCmList---------'+Comminites.size());
        UserOwnedCmList = new List<CommunityCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> communityIds= new list<id>();
        string resourceURL = GetResourceURL('img_athena');  
        string userImageUrl='';      
        List<User> userImagesLst = GetCMUserImagesLst();             

        for (Community__c lb: Comminites)
        {
            communityIds.add(lb.id);
        }
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
    public void GetAllBoards()
            {

                List<Learning_Board_Member__c> LearningBoards = [SELECT Id, Status__c, User_Id__c, Learning_Board_ID__c, Learning_Board_ID__r.Owner.title, Learning_Board_ID__r.Id, Learning_Board_ID__r.Is_Active__c, Learning_Board_ID__r.Name__c, Learning_Board_ID__r.Default_Image_Name__c, Learning_Board_ID__r.description__c, Learning_Board_ID__r.Featured__c, Learning_Board_ID__r.CreatedDate, Learning_Board_ID__r.Owner.name, Learning_Board_ID__r.Owner.Id FROM Learning_Board_Member__c where Status__c = 'Approved' and User_Id__c =: AthenaUserId];

                learningBoardsCount = LearningBoards.size();
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
                        system.debug('att.ParentId---------'+att.ParentId);
                        system.debug('lb.id---------'+lb.id);                       
                        if(lb.Learning_Board_ID__r.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif'))
                        {
                            lbCustom.AttachmentId = att.Id;
                            system.debug('AttachmentId:------------'+lbCustom.AttachmentId);
                            lbCustom.LbId = att.ParentId;
                            lbCustom.StaticImage = false;
                        }
                        else{
                            system.debug('inside else------------------ ');
                        }                          
                    }                    
                    //UserContLbList.add(lbCustom);
                    UserMembers.add(lbCustom);
                    myBoardMembers.add(lbCustom);
                }
                
                //integer contributor = UserContLbList.size()
                //integer contributor = UserOwnedLBList.size()
                BoardsTotalCount = (LearningBoards.size() + UserOwnedLBListCount + UserContLbListCount);
            }
            
            public void GetAllCommunity(){
                List<Community_Member__c> CommunityMember = [SELECT Id, Status__c, User_Id__c, Community_Id__c, Community_Id__r.Owner.title, Community_Id__r.Id, Community_Id__r.IsActive__c, Community_Id__r.Name__c, Community_Id__r.Default_Image_Name__c, Community_Id__r.description__c, Community_Id__r.Featured__c, Community_Id__r.CreatedDate, Community_Id__r.Owner.name, Community_Id__r.Owner.Id FROM Community_Member__c where Status__c = 'Approved' and User_Id__c =: AthenaUserId];
                communitymemberCount = 0;
                communitymemberCount=CommunityMember.size();
                system.debug('CommunityMember-----------'+CommunityMember.size());
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
                    //UserContCmList.add(lbCustom);
                    communityMembers.add(lbCustom); 
                    myCommuniteMembers.add(lbCustom);
                } 
                system.debug('communitymemberCount------------------'+communitymemberCount);
                communityTotalCount = (communitymemberCount + UserContCmListCount + UserOwnedCmListCount);                                             
            }            
    
    public void AssociateExperts(List<string> strExperts , string UserId)
    {
     system.debug('strExperts:'+strExperts);
      system.debug('strExpertssize:'+strExperts.size());
     List<ES_User__c> lstEsUsr= [SELECT Id, User_Id__c FROM ES_User__c where User_Id__c=:UserId];
      if(strExperts.size()==0)
      {
       List<SLP_Expert__c> lstSLPExperts= [SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where ES_User_ID__c=:lstEsUsr[0].Id ];
       delete lstSLPExperts;
      }
      else
      {
            
            List<SLP_Secondary_Industry__c> lstSLPSecI= [SELECT Id, Industry_Name__c, Secondary_Industry_Name__c, Is_Active__c FROM SLP_Secondary_Industry__c where Is_Active__c =true];
            Map<string,string> mapExperts=new Map<string,string>();
            List<string> lstslpsExist=new List<string>();
            
            for(SLP_Secondary_Industry__c slpSI:lstSLPSecI)
            {
              mapExperts.put(slpSI.Secondary_Industry_Name__c,slpSI.Id);
              lstslpsExist.add(slpSI.Secondary_Industry_Name__c);
            }
            set<Id> setExistExpertsId=new set<Id>();
        List<SLP_Secondary_Industry__c> lstSLPExist=[SELECT Id, Industry_Name__c, Secondary_Industry_Name__c, Is_Active__c FROM SLP_Secondary_Industry__c where Is_Active__c =true and Secondary_Industry_Name__c in:strExperts];
            for(SLP_Secondary_Industry__c SlpSecI:lstSLPExist)
            {
              setExistExpertsId.add(SlpSecI.Id);
            }
            
                system.debug('mapExperts:'+mapExperts);
                List<SLP_Expert__c> lstExp=[SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where ES_User_ID__c=:lstEsUsr[0].Id  and SLP_Secondary_Industry_ID__c not in:setExistExpertsId];
                delete lstExp;
                
                List<SLP_Expert__c> lstSLPExp=[SELECT Id, ES_User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where ES_User_ID__c=:lstEsUsr[0].Id ];
                Map<string,string> mapSLPExperts=new Map<string,string>();
                for(SLP_Expert__c slpExp:lstSLPExp)
                {
                  mapSLPExperts.put(slpExp.SLP_Secondary_Industry_ID__c,'');
                }
                system.debug('mapSLPExperts:'+mapSLPExperts);
            for (string strExt:strExperts)
            {
              string strExp='';
              if(!mapExperts.containsKey(strExt))
              {
                SLP_Secondary_Industry__c slpInd=new SLP_Secondary_Industry__c();
                slpInd.Secondary_Industry_Name__c=strExt;
                slpInd.Is_Active__c=true;
                insert slpInd;
                strExp=slpInd.Id;
              }
              else
              {
                strExp= mapExperts.get(strExt);
              }
              system.debug('strExp:'+strExp);
              if(!mapSLPExperts.containskey(strExp))
              {
                SLP_Expert__c slpExperts=new SLP_Expert__c();
                slpExperts.ES_User_ID__c=lstEsUsr[0].Id;
                slpExperts.SLP_Secondary_Industry_ID__c =strExp;
                system.debug('##'+UserId+'$$'+strExp+'ESS'+lstEsUsr[0].Id);
                insert slpExperts;
                system.debug('insert');
              }
            }
      }
    }
     public Pagereference PhotoReadFile(){ 
        system.debug('contentFile------------'+contentFile);
        try{
            if(contentFile.size() > 4313161){                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Image size should not exceed 4MB'); 
                ApexPages.addMessage(myMsg);
                system.debug('inside if ----------'+myMsg);
            }else{
                system.debug('inside else ----1------');
                Integer imgLength = contentFile.size();
                Boolean isPublicalyVisible = true;
                String communityId = null;  
                String userId= UserInfo.getUserId();   
                system.debug('inside else -----2-----');
                ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(contentFile,'image/jpg','userImage.jpg'));
                system.debug('inside else -----3-----');
                User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
                currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
                system.debug('currentUser-----------'+currentUser);
            update currentUser; 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Image uploaded successfully'); 
            ApexPages.addMessage(myMsg);      
            }
        }
        catch(Exception e){
            String strException = string.valueof(e);
            system.debug('strException-----------'+strException);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,strException); 
            ApexPages.addMessage(myMsg);
        }
        //String uri = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+ApexPages.currentPage().getUrl(); 

       // Pagereference peg = new Pagereference('https://hp--esit--c.cs11.visual.force.com/apex/SLP_EditUserProfile?id=005Z00000025ZU5IAM');
                Pagereference peg = new Pagereference('https://hp--esit--c.cs11.visual.force.com/apex/SLP_EditUserProfile?id='+ AthenaUserId );
        peg.setRedirect(true);
        return peg;
   }
   @Remoteaction
   public static String ldapImageChange(String mailId){
        CertificateLdapApex.LdapSoap ldap = new CertificateLdapApex.LdapSoap();
        ldap.clientCertName_x = 'SFDC_Certificate';
        ldap.timeout_x = 60000;
        String before = ldap.GetLDAPPtofilePictureUrl(mailId);
        return before;
   }
   
   @Remoteaction
   public static void ldapImageUpdate(String before){
        Blob beforeblob = EncodingUtil.base64Decode(before.remove('data:image/png;base64,'));
        system.debug('beforeblob-------'+beforeblob);
        Boolean isPublicalyVisible = true;
        String communityId = null;  
        String userId= UserInfo.getUserId();   
        ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(beforeblob,'image/jpg','userImage.jpg'));
        User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
        currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
        system.debug('currentUser-----------'+currentUser);
        update currentUser;
   }
    public void ldapImageUpdate(){
        String before = Apexpages.currentPage().getParameters().get('node');
        system.debug('before--------'+before);
        Blob beforeblob = EncodingUtil.base64Decode(before.remove('data:image/png;base64,'));
        system.debug('beforeblob-------'+beforeblob);
        Boolean isPublicalyVisible = true;
        String communityId = null;  
        String userId= UserInfo.getUserId();   
        ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(beforeblob,'image/jpg','userImage.jpg'));
        User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
        currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
        system.debug('currentUser-----------'+currentUser);
        update currentUser;
        //Pagereference peg = new Pagereference('https://hp--esit--c.cs11.visual.force.com/apex/SLP_EditUserProfile?id='+ AthenaUserId );
        //peg.setRedirect(true);
        //return peg;
   }
}