public class SLPM_ExpertSearchController {

    public string searchText{get;set;}
    public User cUser{get; set;}
     
    public SLPM_ExpertSearchController() {
        searchText= ApexPages.currentPage().getParameters().get('SearchVal');
        cUser = GetLoggedinUserDtls();
    }
    
    public class CustomUserRolesExpertise
    {
        public Id UserId{get;set;}
        public string UserName{get;set;}
        public string RoleName{get;set;}
        public string ExpertName{get;set;}
        public Integer boardsCount{get;set;}
    }
    
    public class CustomExpertObject
    {
        public User user{get;set;}
        public string expertField{get;set;}
        public string parentExpertField{get;set;}
        public string roleName{get;set;}
        public Integer followersCount{get;set;}
    }
    
    
    Public static User GetLoggedinUserDtls(){
        User u = [Select Name,Email,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
    public List<CustomExpertObject> GetAllExpertsTest {
        get
        {
            Set<ID> s = new Set<ID>();
            
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();

            String myVar = '%' + searchtext + '%';
            lstExpert=[
                SELECT 
                    SLP_Expert__c.ES_User_ID__r.User_Id__c, 
                    SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
                    SLP_Expert__c.SLP_Secondary_Industry_Id__r.Industry_Name__c,
                    SLP_Expert__c.Is_Expert__c
                FROM 
                    SLP_Expert__c
                WHERE
                    SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C 
                LIKE: 
                    myVar
                AND
                    SLP_Expert__c.Is_Expert__c = TRUE
                ];
               
            List <User> all = [SELECT id FROM User WHERE name LIKE: myVar];   
            List<SLP_Expert__c> lstExpertByName=new List<SLP_Expert__c>();
            lstExpertByName=[
                SELECT 
                    SLP_Expert__c.ES_User_ID__r.User_Id__c, 
                    SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
                    SLP_Expert__c.SLP_Secondary_Industry_Id__r.Industry_Name__c,
                    SLP_Expert__c.Is_Expert__c
                FROM 
                    SLP_Expert__c
                WHERE
                    SLP_Expert__c.ES_User_ID__r.User_Id__c
                IN:
                  all  
                AND
                    SLP_Expert__c.Is_Expert__c = TRUE

                ];           
                        
            lstExpert.addAll(lstExpertByName);
            for(SLP_Expert__c e : lstExpert) {
                if (e.Is_Expert__c) {
                    s.add(e.ES_User_ID__r.User_Id__c);
                }
            }

            List<User> aa = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id in: s];             
            Map<Id, User> userMap = new Map<Id, User>(aa);

            List<ES_User__c> lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c in:s];
            Map<Id, ES_User__c> roleMap = new Map<Id, ES_User__c>(lstRoles);

            List<CustomExpertObject> lstObj = new List<CustomExpertObject>();
            for (Integer x = 0; x < aa.size(); x++) {
                CustomExpertObject c = new CustomExpertObject();
                c.user = userMap.get(aa[x].id);
                
                for (ES_User__c bb : lstRoles) {
                    if (bb.user_id__c.equals(aa[x].id)) {
                        c.roleName = bb.role_id__r.role_name__c;
                        break;
                    }
                }
                
                for (SLP_Expert__c ex : lstExpert) {
                    if (ex.ES_User_ID__r.User_Id__c.equals(aa[x].id)) {
                        //System.debug('OUT > ' + ex);
                        if (aa[x].name.contains(searchText)) {
                            // Search was for a name. Loop through all expert roles and concat
                            if (c.expertField == null) {
                                c.expertField = ex.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c;
                            }
                            else {
                                c.expertField = c.expertField + ', ' + ex.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c;
                            }
                        }
                        else {
                            // Search was for expertise
                            c.expertField = ex.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c;
                            break;
                        }
                    }
                }
                lstObj.add(c);            
            }
            return lstObj;        
        }
    }    
    
    /**********************************************************************
    ***********************************************************************
    **************** ALL BELOW METHODS ARE FOR TESTING ********************
    ***********************************************************************
    ***********************************************************************/
    
    
    @RemoteAction
    public static List<CustomExpertObject> GetMyList(String searchTerm){
            Set<ID> s = new Set<ID>();
            
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();

String myVar = '%' + searchTerm + '%';
lstExpert=[
    SELECT 
        SLP_Expert__c.ES_User_ID__r.User_Id__c, 
        SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
        SLP_Expert__c.SLP_Secondary_Industry_Id__r.Industry_Name__c
    FROM 
        SLP_Expert__c
    WHERE
        SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C
    LIKE: 
        myVar
    ];
   
   
List <User> all = [SELECT id FROM User WHERE name LIKE: myVar];   
List<SLP_Expert__c> lstExpertByName=new List<SLP_Expert__c>();
lstExpertByName=[
    SELECT 
        SLP_Expert__c.ES_User_ID__r.User_Id__c, 
        SLP_Expert__c.SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,
        SLP_Expert__c.SLP_Secondary_Industry_Id__r.Industry_Name__c
    FROM 
        SLP_Expert__c
    WHERE
        SLP_Expert__c.ES_User_ID__r.User_Id__c
    IN:
      all  
    ];           
            
            lstExpert.addAll(lstExpertByName);
            for(SLP_Expert__c e : lstExpert) {
                s.add(e.ES_User_ID__r.User_Id__c);
            }

            List<User> aa = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id in: s];             
            Map<Id, User> userMap = new Map<Id, User>(aa);

            List<ES_User__c> lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c in:s];
            Map<Id, ES_User__c> roleMap = new Map<Id, ES_User__c>(lstRoles);

            List<CustomExpertObject> lstObj = new List<CustomExpertObject>();
            for (Integer x = 0; x < aa.size(); x++) {
                CustomExpertObject c = new CustomExpertObject();
                c.user = userMap.get(aa[x].id);
                
                for (ES_User__c bb : lstRoles) {
                    if (bb.user_id__c.equals(aa[x].id)) {
                        c.roleName = bb.role_id__r.role_name__c;
                        break;
                    }
                }
                
                for (SLP_Expert__c ex : lstExpert) {
                    if (ex.ES_User_ID__r.User_Id__c.equals(aa[x].id)) {
                        System.debug('haha > ' + ex.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c);
                        c.expertField = ex.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c;
                        break;
                    }
                }
                
                lstObj.add(c);            
            }
            
            return lstObj;
    }

    
    
    
    
    
    @RemoteAction
    public static List<CustomExpertObject> GetTest(String strText) {
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[SELECT ES_User_ID__r.User_Id__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,SLP_Secondary_Industry_Id__r.Industry_Name__c FROM SLP_Expert__c];
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            String experts;
            for(SLP_Expert__c expertObj:lstExpert)
            {
                CustomExpertObject expObj = new CustomExpertObject(); 
                
                // Add User to Expert Object
                User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:expertObj.ES_User_Id__r.User_Id__c];
                
                if (u.name.toLowerCase().contains( strText.toLowerCase() )) {
                    expObj.user = u;
    
                    // Add user role to expert object
                    ES_User__c lstRoles=new ES_User__c();
                    lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c =:expertObj.ES_User_Id__r.User_Id__c];
                    expObj.roleName = lstRoles.role_id__r.role_name__c;
                    
                    // Add expert industry names to expert object
                    expObj.expertField = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c + ')';
                    
                    boolean match = false;
                    for (CustomExpertObject a:lstUsr) {
                        if (a.user.id == u.id) {
                            a.expertField = a.expertField + ', ' + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c +')';
                            match = true;
                            break;
                        }
                    }
                                  
                    List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id) order by Name]; 
                    expObj.followersCount = followers .size();
  
                    if (!match) {lstUsr.add(expObj);}
                }                
            }
            return lstUsr;
    }
    
    public List<CustomExpertObject> GetExpertsByName {
        get
        {
        if(searchtext != null) {
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[SELECT ES_User_ID__r.User_Id__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,SLP_Secondary_Industry_Id__r.Industry_Name__c FROM SLP_Expert__c];
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            String experts;
            for(SLP_Expert__c expertObj:lstExpert)
            {
                CustomExpertObject expObj = new CustomExpertObject(); 
                
                // Add User to Expert Object
                User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:expertObj.ES_User_Id__r.User_Id__c];
                
                if (u.name.toLowerCase().contains( searchtext.toLowerCase() )) {
                    expObj.user = u;
    
                    // Add user role to expert object
                    ES_User__c lstRoles=new ES_User__c();
                    lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c =:expertObj.ES_User_Id__r.User_Id__c];
                    expObj.roleName = lstRoles.role_id__r.role_name__c;
                    
                    // Add expert industry names to expert object
                    expObj.expertField = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c + ')';
                    
                    boolean match = false;
                    for (CustomExpertObject a:lstUsr) {
                        if (a.user.id == u.id) {
                            a.expertField = a.expertField + ', ' + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c +')';
                            match = true;
                            break;
                        }
                    }
                    
                    List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id) order by Name]; 
                    expObj.followersCount = followers .size();
                    
                                    
                    if (!match) {lstUsr.add(expObj);}
                }                
            }
            return lstUsr;
        }
        else {
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            return lstUsr;
        }
        }
   }
   
   public List<CustomExpertObject> GetAllExpertsByName {
        get
        {
        if(searchText != null || searchText != '') {

            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[SELECT ES_User_ID__r.User_Id__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,SLP_Secondary_Industry_Id__r.Industry_Name__c FROM SLP_Expert__c];
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            String experts;
            for(SLP_Expert__c expertObj:lstExpert)
            {
                CustomExpertObject expObj = new CustomExpertObject(); 
                
                // Add User to Expert Object
                User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.name like '%donal%'];
                expObj.user = u;

                // Add user role to expert object
                ES_User__c lstRoles=new ES_User__c();
                lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c =:expertObj.ES_User_Id__r.User_Id__c];
                expObj.roleName = lstRoles.role_id__r.role_name__c;
                
                // Add expert industry names to expert object
                expObj.expertField = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c + ')';
                
                boolean match = false;
                for (CustomExpertObject a:lstUsr) {
                    if (a.user.id == u.id) {
                        a.expertField = a.expertField + ', ' + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c +')';
                        match = true;
                        break;
                    }
                }
                                
                if (!match) {lstUsr.add(expObj);}
            }
            return lstUsr;
            }
            else {
                List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
                return lstUsr;
            }
        }
    }

    
    public List<CustomExpertObject> GetExpertsByIndustry {
        get
        {
            String myVar = '%' + searchtext + '%';
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[SELECT ES_User_ID__r.User_Id__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,SLP_Secondary_Industry_Id__r.Industry_Name__c FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C Like: myVar];
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            String experts;
            for(SLP_Expert__c expertObj:lstExpert)
            {
                CustomExpertObject expObj = new CustomExpertObject(); 
                
                // Add User to Expert Object
                User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:expertObj.ES_User_Id__r.User_Id__c];
                expObj.user = u;

                // Add user role to expert object
                ES_User__c lstRoles=new ES_User__c();
                lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c =:expertObj.ES_User_Id__r.User_Id__c];
                expObj.roleName = lstRoles.role_id__r.role_name__c;
                
                // Add expert industry names to expert object
                expObj.expertField = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c + ')';
                
                boolean match = false;
                for (CustomExpertObject a:lstUsr) {
                    if (a.user.id == u.id) {
                        a.expertField = a.expertField + ', ' + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c +')';
                        match = true;
                        break;
                    }
                }
                    List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id) order by Name]; 
                    expObj.followersCount = followers .size();

                                
                if (!match) {lstUsr.add(expObj);}
            }
            return lstUsr;
        }
    }
    public List<CustomExpertObject> GetAllExperts {
        get
        {
            List<SLP_Expert__c> lstExpert=new List<SLP_Expert__c>();
            lstExpert=[SELECT ES_User_ID__r.User_Id__c, SLP_Secondary_Industry_ID__r.Secondary_Industry_Name__C,SLP_Secondary_Industry_Id__r.Industry_Name__c FROM SLP_Expert__c];
            List<CustomExpertObject> lstUsr=new List<CustomExpertObject>();
            String experts;
            for(SLP_Expert__c expertObj:lstExpert)
            {
                CustomExpertObject expObj = new CustomExpertObject(); 
                
                // Add User to Expert Object
                User u = [Select u.id,u.name,u.title,u.department,u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:expertObj.ES_User_Id__r.User_Id__c];
                expObj.user = u;

                // Add user role to expert object
                ES_User__c lstRoles=new ES_User__c();
                lstRoles=[select id,user_id__c,role_id__r.id,role_id__r.role_name__c from ES_User__c where user_id__c =:expertObj.ES_User_Id__r.User_Id__c];
                expObj.roleName = lstRoles.role_id__r.role_name__c;
                
                // Add expert industry names to expert object
                expObj.expertField = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c + ')';
                
                boolean match = false;
                for (CustomExpertObject a:lstUsr) {
                    if (a.user.id == u.id) {
                        a.expertField = a.expertField + ', ' + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' (' + expertObj.SLP_Secondary_Industry_Id__r.Industry_Name__c +')';
                        match = true;
                        break;
                    }
                }
                
                List<User> followers = [SELECT Id, Name,title, SmallPhotoUrl FROM User WHERE Id IN (SELECT SubscriberId FROM EntitySubscription WHERE ParentId=:u.id AND SubscriberId !=:u.id) order by Name]; 
                expObj.followersCount = followers .size();
                               
                if (!match) {lstUsr.add(expObj);}
            }
            return lstUsr;
        }
    }    
    
    @RemoteAction
    public static String LogMetrics(string boardId,string boardName,string link,string tabSection,string operatingSystem,string browserVersion)
    {  
        
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        //metricsObj.Text__c=strSearchValue;
        if(link.contains('AthenaUserProfile'))
        {
         metricsObj.ActionType__c='People Hyperlink Click';
        }
        else
        {
        metricsObj.ActionType__c='Hyperlink Click';
        }
        metricsObj.ObjectId__c=boardId;
        //metricsObj.ObjectName__c=boardName;       
        metricsObj.Text__c=boardName;
        metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='Search Page';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        if(link.contains('SLP_ViewCommunity') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Community Topic';
        }
        else if(link.contains('SLP_ViewCommunity'))
        {
        metricsObj.ObjectName__c='Community';
        }
        else if(link.contains('AthenaLearningBoardDtls') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Learning Board Topic';
        }  
        else if(link.contains('AthenaLearningBoardDtls'))
        {
        metricsObj.ObjectName__c='Learning Board';
        }        
        else if(link.contains('AthenaUserProfile'))
        {
        metricsObj.ObjectName__c='User Profile';
        }
        
        if(tabSection=='Communities Image Click')
        {
        tabSection='Communities Tab';
        metricsObj.ActionType__c='Communities Image Click';
        }
        
        if(tabSection=='Learning Board Image Click')
        {
        tabSection='Learning Board Tab';
        metricsObj.ActionType__c='Learning Board Image Click';
        }
        
        metricsObj.DeviceType__c='Mobile';
        metricsObj.TabSection__c=tabSection;
        Insert(metricsObj);
        //PageReference pRef = new PageReference('/apex/AthenaLearningBoardDtls');
        //pRef.getParameters().put('id',boardId);
        //pRef.setRedirect(true);
        //return pRef;        
        return link;
    }

    
}