global class SLP_AddCommunityContributor
{

    public Id UserId{get;set;}
    public Id SLPRoleId{get;set;}
    public Id CommunityId { get; set; }
    public List<SelectOption> LstRolesOption{get;set;}
    public List<SelectOption> communityItemsList{get;set;}
    public string UserMemberId { get; set; }
    
    public class Members
    {
        public string Id { get; set; }
        public string Name { get; set; }
    }

    public SLP_AddCommunityContributor()
    {
        GetLoggedinUserDtls();
        LstRolesOption = GetRoles();
        communityItemsList = GetCommunityDetails();
    }

    Public String getSfInstance
    {
        get
        {
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

    Public User GetLoggedinUserDtls()
    {    
        User u = [Select Name,FullPhotoUrl,id From User where User.id= :UserInfo.getUserId()];
        return U;
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
    
    public List<SelectOption> GetRoles()
    {
        List<SelectOption> lstRolesOptions= new List<SelectOption>();       
        List<SLP_Role__c> lstRols=[select id,name,role_name__c from SLP_Role__c where Is_Active__c=:True order by role_name__c asc];
        lstRolesOptions.add(new SelectOption('','--Select Role--'));
        
        
            for(SLP_Role__c role:lstRols){
                lstRolesOptions.add(new SelectOption(role.id,role.role_name__c));    
            }

            //lstRolesOptions.add(new SelectOption('NO','No Roles'));

            return lstRolesOptions;
    }

    public List<SelectOption> GetCommunityDetails()
    {
        List<SelectOption> lstCommunityDetails = new List<SelectOption>();       
        List<Community__c> lstCommunity = [SELECT Id, Name__c, Description__c, IsActive__c FROM Community__c where IsActive__c=:True order by Name__c asc];
        lstCommunityDetails.add(new SelectOption('','--Select Community--'));

        for(Community__c comItem: lstCommunity)
        {
            lstCommunityDetails.add(new SelectOption(comItem.Id, comItem.Name__c));    
        }

        return lstCommunityDetails;
    }

    @RemoteAction
    global static List<User> GetSLPUsersByCommunity(string communityID)
    {
        List<PermissionSetAssignment> lstPermissionSetAssignment = new List<PermissionSetAssignment>();

        lstPermissionSetAssignment = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN (select id from user where isactive = true)
                                      and (PermissionSet.name='ES_Social_Learning_Producer' or PermissionSet.name='ES_Social_Learning_Moderator') and AssigneeId not in
                                      (SELECT UserOrGroupId FROM Community__Share where ParentId =: communityID) ];
        
        List<Community__Share> listBoardShare = [SELECT UserOrGroupId FROM Community__Share where ParentId =: communityID];

        Map<string, boolean> mapBoardShareids = new Map<string, boolean>();
            
        for(Community__Share boardItem : listBoardShare)
        {
            mapBoardShareids.put(boardItem.UserOrGroupId, true);
        }

        SET<ID> lstUserIds = new SET<ID>();

        for(PermissionSetAssignment permissionItem : lstPermissionSetAssignment)
        {
            string value = permissionItem.AssigneeId;
            if(!mapBoardShareids.containskey(value))
            {
                lstUserIds.add(permissionItem.AssigneeId);
            }
        }

        List<User> lstUser = [Select id, Name from User where id in : lstUserIds order by Name asc];

        return lstUser;
    }

    @RemoteAction
    global static List<User> GetSLPContributorsByCommunity(string communityID)
    {
        List<User> ContributorsUsers =  [Select id, Name From User where id IN (SELECT UserOrGroupId FROM Community__Share where AccessLevel = 'Edit' and ParentId=: communityID)];
        return  ContributorsUsers;
    }
    
    public void SaveOrUpdateMembers()
    {
        string[] memberIds = UserMemberId.split(',');
        List<string> lstMembers = new List<string>( memberIds );
        List<EntitySubscription> listEntitySubscription = new List <EntitySubscription>();
        List<Community__Share> lstCommunityMember = new List<Community__Share>();
        List<Community__Share> listCommunityShare = new List<Community__Share>();

        if(lstMembers.size() > 0 )
        {
            lstCommunityMember = [SELECT id, UserOrGroupId FROM Community__Share where AccessLevel='Edit' and ParentId =: CommunityId and UserOrGroupId not in : lstMembers];
            
            if(lstCommunityMember.size() > 0 )
            {
                delete lstCommunityMember;
            }

            List<EntitySubscription> lstEntitySubscription = [select Id, SubscriberId from EntitySubscription where ParentId =: CommunityId and SubscriberId  in : lstMembers ];                         


            Map<string, boolean> mapSubscribeMembers = new Map<string, boolean>();
            
            for(EntitySubscription subItem : lstEntitySubscription)
            {
                mapSubscribeMembers.put(subItem.SubscriberId, true);
            }
           

            if(lstEntitySubscription.size() > 0 )
            {
                delete lstEntitySubscription;
            }

            List<Community__Share> listCommunityMembers =  [SELECT UserOrGroupId FROM Community__Share where AccessLevel = 'Edit' and ParentId=: CommunityId];

            Map<string, boolean> mapCommunityMembers = new Map<string, boolean>();
            
            for(Community__Share communityItem : listCommunityMembers)
            {
                mapCommunityMembers.put(communityItem.UserOrGroupId, true);
            }
            
            for(string userDtls : lstMembers)
            {
                if(userDtls != '')
                {
                    if(!mapCommunityMembers.containskey(userDtls))
                    {
                        Community__Share communityShare = new Community__Share();
                        communityShare.UserOrGroupId = userDtls;
                        communityShare.ParentId = CommunityId;
                        communityShare.AccessLevel = 'Edit';
                        listCommunityShare.add(communityShare);

                        //When we are adding contributor, we need to add those users as Followers for the Community
                        if(!mapSubscribeMembers.containskey(userDtls))
                        {
                            EntitySubscription entitySubscription = new EntitySubscription();
                            entitySubscription.SubscriberId = userDtls;
                            entitySubscription.ParentId = CommunityId;
                            listEntitySubscription.add(entitySubscription);
                        }
                    }
                }   
            }
            upsert listCommunityShare;
            insert listEntitySubscription;
        }
    }
    
    public class Community
    {
        public id CommunityId { get; set; }
        public string CommunityName { get; set; }
    }

    /*public void SendMail()
    {
        List<SLP_CommunityContributor__c> lst= [SELECT Id, Community_Id__c, User_Id__c, Community_Id__r.name__c,Is_MailSent__c FROM SLP_CommunityContributor__c where Is_MailSent__C = false ]; 

        List<Community> lstCommunity =new List<Community>(); 

        Map<Id,List<Community>> mapLst=new Map<Id,List<Community>>(); 

        string isUserSame = ''; 

        for(SLP_CommunityContributor__c ccc:lst)
        { 
            Community communityObj = new Community();

            communityObj.CommunityId = ccc.Community_Id__c; 
            communityObj.CommunityName = ccc.Community_Id__c; 

            lstCommunity.add(communityObj); 
           
            if(isUserSame != ccc.User_Id__c && isUserSame != '')
            { 
                mapLst.put(isUserSame, lstCommunity); 
            } 

            isUserSame = ccc.User_Id__c; 
        }

            system.debug('SendMail mapLst:' + mapLst.size());
    }
    */
}