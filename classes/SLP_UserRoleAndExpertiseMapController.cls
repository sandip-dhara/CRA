global class SLP_UserRoleAndExpertiseMapController {

    public User UserDetails {get;set;}

    public class CustomUserRolesExpertise {
        public Id UserId {get;set;}
        public string UserName {get;set;}
        public string RoleName {get;set;}
        public string ExpertName {get;set;}
    }

    public SLP_UserRoleAndExpertiseMapController() {
        UserDetails = GetLoggedinUserDtls();
    }


    Public User GetLoggedinUserDtls() {
        User u = [Select Name, FullPhotoUrl, AboutMe, Email From User where User.id = : UserInfo.getUserId()];
        return U;
    }

    Public boolean IsLearningBoardCreator {
        get {
            AthenaUserAccess usrAccs = new AthenaUserAccess();
            if (usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()))
                return true;
            else
                return false;
        }
    }

    Public String getSfInstance {
        get {
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

    Public Id HdnUserId {get;set;}

    public List < CustomUserRolesExpertise > GetUsers {
        get {
            List < CustomUserRolesExpertise > lstCutomRoles = new List < CustomUserRolesExpertise > ();
            List < CustomUserRolesExpertise > lstFinalData = new List < CustomUserRolesExpertise > ();
            String experts;
            List < Id > lstUserId = new List < Id > ();
            List < Id > lstEsUserId = new List < Id > ();
            List < SLP_Expert__c > lstExpert = new List < SLP_Expert__c > ();
            List < ES_User__c > lstRoles = new List < ES_User__c > ();
            Map < Id, string > mapUsr = new Map < Id, string > ();
            List<String> userId = new List<String>();
            profile prf = [select id from profile where name='ES Base Profile' Limit 1];
            List<user> usEr = [Select id from user where profileId =: prf.id and isActive = true order by lastlogindate Desc Limit 999];
            for(User us: usEr){
                userId.add(us.id);
            }
            List < AggregateResult > lstUsers = [select assignee.id, assignee.name from permissionsetassignment where assignee.id in : userId and permissionset.name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') and assignee.isactive=true group by assignee.id, assignee.name order by assignee.name asc];
            for (AggregateResult obj: lstUsers) {
                mapUsr.put((Id) obj.get('id'), (String) obj.get('name'));
            }
            lstRoles = [select id, user_id__c, user_id__r.name, role_id__r.id, role_id__r.role_name__c from ES_User__c where user_id__c in : mapUsr.keySet() order by user_id__c asc];
            Map<ID,String> rolesMap = new Map<ID,String>();
            for (ES_User__c esuserid: lstRoles) {
                lstEsUserId.add(esuserid.id);
                rolesMap.put(esuserid.user_id__c,esuserid.user_id__r.name);
            }
            system.debug('lstEsUserId:' + lstEsUserId.size());

            lstExpert = [select id, ES_User_Id__c, Is_Expert__c, ES_User_Id__r.User_Id__c, SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c, SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where ES_User_Id__c in : lstEsUserId and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];

            system.debug('Experts: ' + lstExpert.size());
            Map < Id, string > mapUserExperts = new Map < Id, string > ();
            for (SLP_Expert__c expertObj: lstExpert) {
                if (mapUserExperts.containsKey(expertObj.ES_User_Id__r.User_Id__c)) {
                    if (expertObj.Is_Expert__c) {
                        string strExperts = mapUserExperts.get(expertObj.ES_User_Id__r.User_Id__c) + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' {Expert}' + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    } else {
                        string strExperts = mapUserExperts.get(expertObj.ES_User_Id__r.User_Id__c) + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    }

                } else {
                    if (expertObj.Is_Expert__c) {
                        string strExperts = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' {Expert}' + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    } else {
                        string strExperts = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    }
                }
            }
            
            //Imran Start
            /*
            List < String > newList = new List < String > ();
            for (ES_User__c ess: lstRoles) {
                if(!mapUsr.Containskey(ess.user_id__c)){
                    newList.add(ess.user_id__c);
                }               
            }
            */
            List < String > newList = new List < String > ();
            for(AggregateResult agResult : lstUsers){
                if(!rolesMap.containsKey((Id) agResult.get('id'))){
                    newList.add((String) agResult.get('id'));
                }
            }
            system.debug('newList----------'+newList.size());
            Map < Id, string > mapUsr1 = new Map < Id, string > ();
            List < AggregateResult > lstAggUsers = [select assignee.id, assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') and assignee.id in : newList and assignee.isactive=true group by assignee.id, assignee.name order by assignee.name asc];
            system.debug('lstAggUsers-------------' + lstAggUsers.size());
            for (AggregateResult obj: lstAggUsers) {
                CustomUserRolesExpertise custRoleObj = new CustomUserRolesExpertise();
                custRoleObj.UserId = (Id) obj.get('id');
                custRoleObj.UserName = (String) obj.get('name');
                lstCutomRoles.add(custRoleObj);
                mapUsr1.put((Id) obj.get('id'), (String) obj.get('name'));
            }
            
            //End
            
            for (ES_User__c role: lstRoles) {
                CustomUserRolesExpertise custRoleObj = new CustomUserRolesExpertise();
                custRoleObj.UserId = role.user_id__c;
                custRoleObj.UserName = role.user_id__r.name;
                custRoleObj.RoleName = role.role_id__r.role_name__c;

                experts = '';
                if (mapUserExperts.containsKey(custRoleObj.UserId)) {
                    experts = mapUserExperts.get(custRoleObj.UserId);
                }

                if (experts != '') {
                    custRoleObj.ExpertName = experts.substring(0, (experts.length() - 2));
                } else {
                    custRoleObj.ExpertName = experts;
                }
                lstCutomRoles.add(custRoleObj);
            }



            system.debug('lstCutomRoles: ' + lstCutomRoles.size());
            //List<CustomUserRolesExpertise> lstFinalData=new List<CustomUserRolesExpertise>(); By Komala
            // for(CustomUserRolesExpertise obj:lstCutomRoles)
            // {
            // system.debug('Role Name:'+obj.RoleName);
            // //if(obj.RoleName!='' && obj.ExpertName!='') By Komala
            // if(obj.RoleName!=null)
            // {
            // lstFinalData.add(obj);
            // }
            // }
            // system.debug('lstFinalData: '+lstFinalData.size());
            return lstCutomRoles;
        }
        set;
    }
    @RemoteAction
    public static List <CustomUserRolesExpertise> listUserAction(){
        List < CustomUserRolesExpertise > lstCutomRoles = new List < CustomUserRolesExpertise > ();
            List < CustomUserRolesExpertise > lstFinalData = new List < CustomUserRolesExpertise > ();
            String experts;
            List < Id > lstUserId = new List < Id > ();
            List < Id > lstEsUserId = new List < Id > ();
            List < SLP_Expert__c > lstExpert = new List < SLP_Expert__c > ();
            List < ES_User__c > lstRoles = new List < ES_User__c > ();
            Map < Id, string > mapUsr = new Map < Id, string > ();
            List<String> userId = new List<String>();
            profile prf = [select id from profile where name='ES Base Profile' Limit 1];
            List<user> usEr = [Select id from user where isActive = true order by lastlogindate Desc Limit 20000];
            for(User us: usEr){
                userId.add(us.id);
            }
            system.debug('userId------------'+userId.size());
            List < AggregateResult > lstUsers = [select assignee.id, assignee.name from permissionsetassignment where assignee.id in : userId and permissionset.name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') and assignee.isactive=true group by assignee.id, assignee.name order by assignee.name asc];            
            for (AggregateResult obj: lstUsers) {
                mapUsr.put((Id) obj.get('id'), (String) obj.get('name'));
            }
            system.debug('lstUsers------------'+lstUsers.size());
            //lstRoles = [select id, user_id__c, user_id__r.name, role_id__r.id, role_id__r.role_name__c from ES_User__c where user_id__c in : mapUsr.keySet() order by user_id__c asc];
            lstRoles = [select id, user_id__c, user_id__r.name, role_id__r.id, role_id__r.role_name__c from ES_User__c order by user_id__c asc Limit 10000];
            Map<ID,String> rolesMap = new Map<ID,String>();
            for (ES_User__c esuserid: lstRoles) {
                lstEsUserId.add(esuserid.id);
                rolesMap.put(esuserid.user_id__c,esuserid.user_id__r.name);
            }
            system.debug('lstEsUserId:-----------' + lstEsUserId.size());

            //lstExpert = [select id, ES_User_Id__c, Is_Expert__c, ES_User_Id__r.User_Id__c, SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c, SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where ES_User_Id__c in : lstEsUserId and SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
            lstExpert = [select id, ES_User_Id__c, Is_Expert__c, ES_User_Id__r.User_Id__c, SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c, SLP_Secondary_Industry_Id__r.Industry_Name__c from SLP_Expert__c where SLP_Secondary_Industry_Id__r.Is_Active__c = : True order by ES_User_Id__r.User_id__c,SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c asc];
            system.debug('Experts: ----------------' + lstExpert.size());
            Map < Id, string > mapUserExperts = new Map < Id, string > ();
            for (SLP_Expert__c expertObj: lstExpert) {
                if (mapUserExperts.containsKey(expertObj.ES_User_Id__r.User_Id__c)) {
                    if (expertObj.Is_Expert__c) {
                        string strExperts = mapUserExperts.get(expertObj.ES_User_Id__r.User_Id__c) + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' {Expert}' + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    } else {
                        string strExperts = mapUserExperts.get(expertObj.ES_User_Id__r.User_Id__c) + expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    }

                } else {
                    if (expertObj.Is_Expert__c) {
                        string strExperts = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ' {Expert}' + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    } else {
                        string strExperts = expertObj.SLP_Secondary_Industry_Id__r.Secondary_Industry_Name__c + ', ';
                        mapUserExperts.put(expertObj.ES_User_Id__r.User_Id__c, strExperts);
                    }
                }
            }
            
            //Imran Start
            /*
            List < String > newList = new List < String > ();
            for (ES_User__c ess: lstRoles) {
                if(!mapUsr.Containskey(ess.user_id__c)){
                    newList.add(ess.user_id__c);
                }               
            }
            */
            List < String > newList = new List < String > ();
            for(AggregateResult agResult : lstUsers){
                if(!rolesMap.containsKey((Id) agResult.get('id'))){
                    newList.add((String) agResult.get('id'));
                }
            }
            system.debug('newList----------'+newList.size());
            Map < Id, string > mapUsr1 = new Map < Id, string > ();
            List < AggregateResult > lstAggUsers = [select assignee.id, assignee.name from permissionsetassignment where assignee.isactive=true group by assignee.id, assignee.name order by assignee.name asc Limit 3000];
            system.debug('lstAggUsers-------------' + lstAggUsers.size());
            for (AggregateResult obj: lstAggUsers) {
                CustomUserRolesExpertise custRoleObj = new CustomUserRolesExpertise();
                custRoleObj.UserId = (Id) obj.get('id');
                custRoleObj.UserName = (String) obj.get('name');
                lstCutomRoles.add(custRoleObj);
                mapUsr1.put((Id) obj.get('id'), (String) obj.get('name'));
            }
            
            //End
            
            for (ES_User__c role: lstRoles) {
                CustomUserRolesExpertise custRoleObj = new CustomUserRolesExpertise();
                custRoleObj.UserId = role.user_id__c;
                custRoleObj.UserName = role.user_id__r.name;
                custRoleObj.RoleName = role.role_id__r.role_name__c;

                experts = '';
                if (mapUserExperts.containsKey(custRoleObj.UserId)) {
                    experts = mapUserExperts.get(custRoleObj.UserId);
                }

                if (experts != '') {
                    custRoleObj.ExpertName = experts.substring(0, (experts.length() - 2));
                } else {
                    custRoleObj.ExpertName = experts;
                }
                lstCutomRoles.add(custRoleObj);
            }



            system.debug('lstCutomRoles:--------------' + lstCutomRoles.size());
            //List<CustomUserRolesExpertise> lstFinalData=new List<CustomUserRolesExpertise>(); By Komala
            // for(CustomUserRolesExpertise obj:lstCutomRoles)
            // {
            // system.debug('Role Name:'+obj.RoleName);
            // //if(obj.RoleName!='' && obj.ExpertName!='') By Komala
            // if(obj.RoleName!=null)
            // {
            // lstFinalData.add(obj);
            // }
            // }
            // system.debug('lstFinalData: '+lstFinalData.size());
            return lstCutomRoles;
    }
    
    public PageReference SubmitEdit() {
        system.debug('HdnUserId :' + HdnUserId);
        PageReference pRef = new PageReference('/apex/SLP_EditUserRoleMapping');
        pRef.getParameters().put('UserId', HdnUserId);
        pRef.setRedirect(true);
        return pRef;
    }
    @RemoteAction
    global static List<SLP_Process_Onboarding_User__c> GetCommunityMemberDetailsExcel()
    {
      List<SLP_Process_Onboarding_User__c> lstOnBoardingUsrs=new List<SLP_Process_Onboarding_User__c>();
      lstOnBoardingUsrs= [SELECT Id, Email__c, Role__c, Area_Of_Focus__c, Community_Contributor__c, Community_Member__c, Board_Contributor__c, Board_Member__c, SLP_BulkReg_Id__c, Status__c, FormatValid__c, Failure_Log__c, Success_Log__c, New_User__c FROM SLP_Process_Onboarding_User__c];
      return lstOnBoardingUsrs;

    }

}