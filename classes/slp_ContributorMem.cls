public class slp_ContributorMem {
  public class CustomContributorAndMember
  {
    public Id UserId {get;set;}
    public string UserName {get;set;}
    public string RoleName {get;set;}
    public string Userphoto {get;set;}
    public boolean IsContributor {get;set;}
    public string Region {get;set;}
    public string BusinessUnit {get;set;}
    public boolean IsExperts {get;set;}
  }
  
  public static List<CustomContributorAndMember> lstContributorMember {get;set;}
 public User GetLoggedinUserDetails()
    {
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }
   public slp_ContributorMem()
   {
   
   }
   
   public string ContributorMember{
   get
   {
       lstContributorMember=GetCommunityContributorAndMember();
     system.debug('lstsize:'+lstContributorMember.size());
     system.debug('lst:'+lstContributorMember);
     
     string jsonString=JSON.serialize(lstContributorMember);
      return jsonString;
   }
   set;
   }
  
  public List<CustomContributorAndMember> GetCommunityContributorAndMember()
  {
    List<CustomContributorAndMember> lstContributorMem=new List<CustomContributorAndMember>();
    List<Community__Share > lstCommunityShare= [SELECT UserOrGroupId FROM Community__Share where ParentId=:'a8AZ00000008OcKMAU'];

    system.debug('s:'+lstCommunityShare.size());
    List<Community_Member__c> lstCommMember= [SELECT  User_Id__c FROM Community_Member__c where Community_Id__c='a8AZ00000008OcKMAU' and Status__c ='Approved'];
    system.debug('c:'+lstCommMember.size());
    system.debug('d:'+lstCommMember);

    Map<Id,boolean> MapUser=new Map<Id,boolean>();
    set<Id> setUserIds=new set<Id>();

    for(Community__Share CommContrib: lstCommunityShare)
    {
      MapUser.put(CommContrib.UserOrGroupId,true);
      setUserIds.add(CommContrib.UserOrGroupId);
    }

    for(Community_Member__c CommMem: lstCommMember)
    {
     MapUser.put(CommMem.User_Id__c,false);
     setUserIds.add(CommMem.User_Id__c);
    }


    list<ES_User__c> lstEsuser= [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where User_Id__c in :setUserIds ];
     Map<Id,string> MapExpertUserRole=new Map<Id,string>();
    for(ES_User__c esUser:lstEsuser )
    {
         string RoleName=esUser.Role_ID__r.Role_Name__c;
         MapExpertUserRole.put(esUser.User_Id__c,RoleName);
    }
    
    set<Id> SetExperts=new set<Id>();

    List<SLP_Expert__c> lstExperts= [SELECT Id, ES_User_ID__r.User_ID__c FROM SLP_Expert__c where ES_User_ID__r.User_ID__c in:setUserIds ];

    for(SLP_Expert__c slp:lstExperts)
    {
     SetExperts.add(slp.ES_User_ID__r.User_ID__c); 
    }
    
    List<User> ListUsers = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl from User u where u.id in : setUserIds order by u.name];
    
    for(User usr:ListUsers )
    {
        CustomContributorAndMember contributorMem=new CustomContributorAndMember();
        contributorMem.UserId=usr.id;
        contributorMem.UserName=usr.name;
        contributorMem.Userphoto=usr.SmallPhotoUrl;
        
        if(MapUser.containsKey(usr.id))
        {
         contributorMem.IsContributor=MapUser.get(usr.id);
     
        }
        if(SetExperts.contains(usr.id))
        {
        contributorMem.IsExperts=true;
        }
        if(MapExpertUserRole.containsKey(usr.id))
        {
          contributorMem.RoleName=MapExpertUserRole.get(usr.id);
        }
        
        
        lstContributorMem.add(contributorMem);
    }
    return lstContributorMem;
    
    }   




}