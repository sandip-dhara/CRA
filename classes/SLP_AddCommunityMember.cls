global class SLP_AddCommunityMember
{

    public Id UserId{get;set;}
    public Id SLPRoleId{get;set;}
    public Id CommunityId { get; set; }
    public List<SelectOption> LstRolesOption{get;set;}
    public List<SelectOption> communityItemsList{get;set;}
    public string UserMemberId { get; set; }
    
    public SLP_AddCommunityMember()
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
                                      and (PermissionSet.name='ES_Social_Learning_Producer' or PermissionSet.name='ES_Social_Learning_Moderator' or PermissionSet.name='ES_Social_Learning_Consumer') and AssigneeId not in
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
        List<Community_Member__c> communityMembers =  [SELECT Id, Community_Id__c, User_Id__c, Status__c, Community_Id__r.name__c FROM Community_Member__c where Status__c =: AthenaUtility.Approved and Community_Id__c =: communityID];

        SET<ID> lstUserIds = new SET<ID>();

        for(Community_Member__c boardItem : communityMembers)
        {
            lstUserIds.add(boardItem.User_Id__c);
        }
        
        List<User> lstUser = [Select id, Name from User where id in : lstUserIds order by Name asc];

        return lstUser;
    }
    
    public void SaveOrUpdateMembers()
    {
        string[] memberIds = UserMemberId.split(',');
        List<string> lstMembers = new List<string>( memberIds );

        if(lstMembers.size() > 0 )
        {
            List<Community_Member__c> lstCommunityMember =  [SELECT User_Id__c FROM Community_Member__c where Community_Id__c=: CommunityId and User_Id__c not in : lstMembers];

            List<EntitySubscription> lstEntitySubscription = [select Id from EntitySubscription where ParentId =: CommunityId and SubscriberId not in : lstMembers ];         

            if(lstCommunityMember.size() > 0 && lstEntitySubscription.size() > 0 )
            {
                delete lstCommunityMember; 
                delete lstEntitySubscription;
            }

            List<Community_Member__c> listCommunityMembers =  [SELECT User_Id__c FROM Community_Member__c where Community_Id__c=: CommunityId and status__c =: AthenaUtility.Approved];

            Map<string, boolean> mapCommunityMembers = new Map<string, boolean>();
            
            for(Community_Member__c communityItem : listCommunityMembers)
            {
                mapCommunityMembers.put(communityItem.User_Id__c, true);
            }

            List<Community_Member__c> listCommunityMember = new List<Community_Member__c>();
            List<EntitySubscription> listEntitySubscription = new List <EntitySubscription>();

            for(string userDtls : lstMembers)
            {
                if(userDtls != '')
                {
                    if(!mapCommunityMembers.containskey(userDtls))
                    {
                        Community_Member__c communityMember = new Community_Member__c();
                        communityMember.User_Id__c = userDtls;
                        communityMember.Community_Id__c = CommunityId;
                        communityMember.Status__c = AthenaUtility.Approved;

                        EntitySubscription entitySubscription = new EntitySubscription();
                        entitySubscription.SubscriberId = userDtls;
                        entitySubscription.ParentId = CommunityId;

                        listCommunityMember.add(communityMember);
                        listEntitySubscription.add(entitySubscription);

                    }
                }   
            }
            insert listEntitySubscription;
            upsert listCommunityMember;
        }
    }
    
    public class Community
    {
        public id CommunityId { get; set; }
        public string CommunityName { get; set; }
    }
    
}