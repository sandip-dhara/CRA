public class SLP_EditUserProfile_saveprofile
{
    public User useredit { get; set; }
    Public String AthenaUserId{get;set;}
    public ES_User__c esuser{get;set;}
    public String linkedinurl{get;set;}
    public String twitterurl{get;set;}
    public integer PeopleFollowingCount{get;set;} 
    public List<User_Skill__c> userskilledit{get;set;}
    public List<Project__c> proedit{get;set;}
    public boolean IsLoggedInUser{get;set;}
    public integer FollowersCount{get;set;}
    public boolean displayPopup {get; set;}
    public string Location{get;set;}  

    public SLP_EditUserProfile_saveprofile()
    {
        system.debug('@@@@esuser'+esuser);
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        useredit = [select id, name,title,aboutme,Department from user where id=:userinfo.getuserid()];
        esuser=[select Linked_In__c,Twitter__c,User_Id__c from ES_User__c where User_Id__c=:userinfo.getuserid()];
        userskilledit=[select Skill_ID__c,User_ID__c,Skill_ID__r.Name__c from User_Skill__c where User_ID__c=:userinfo.getuserid()];
        proedit=[select Name__c,Timeframe__c,Description__c,User_Id__c from Project__c where User_Id__c=:userinfo.getuserid()];
        system.debug('@@@@esuser'+esuser);
        
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
    Public User GetLoggedinUserDtls(){
        User u = new User();
        u = [Select SmallPhotoUrl,Name,id From User where User.id= :UserInfo.getUserId()];
        system.debug('############ GetLoggedinUserDtls'+ u.Name);
        return u;         
    }
    
        Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
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
      List<User> ulist=new List<User>();
      List<ES_User__c> esuserlist=new List<ES_User__c>();
      List<User_Skill__c> userskilllist=new List<User_Skill__c>();
      List<Project__c> prolist=new List<Project__c>();
      system.debug('!!!!!!!!!!ulist'+ulist);
   
     
      ulist.add(useredit);
     
      system.debug('!!!!!!!!!!ulist'+ulist);
      //update ulist;
      update useredit;
      
      esuserlist.add(esuser);
      
      upsert esuserlist;
      for (User_Skill__c us:userskilledit)
      {
        userskilllist.add(us);
      }
      upsert userskilllist;
      for (Project__c pro:proedit)
      {
        prolist.add(pro);
      }
      upsert prolist;

      
    }
}