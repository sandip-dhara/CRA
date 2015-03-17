global class AddorUpdateUser
{

    public Id UserId{get;set;}
    public Id SLPRoleId{get;set;}
    public Id CommunityId { get; set; }
    public List<SelectOption> LstRolesOption{get;set;}
    public List<SelectOption> communityItemsList{get;set;}
    public string UserMemberId { get; set; }
    public List<ESUserDetails> UserList { get; set;}

    public string AUTOMOTIVE = 'a8AZ00000008Oi3MAE';
    public string BANKING = 'a8AZ00000008Oi8MAE';
    public string CONSUMERGOODS = 'a8AZ00000008OiDMAU';
    public string ENERGYMINING = 'a8AZ00000008OiIMAU';
    public string INSURANCE = 'a8AZ00000008OiNMAU';
    public string RETAIL = 'a8AZ00000008OiEMAU';
    public string UTILITIES = 'a8AZ00000008OiSMAU';

    public class ESUserDetails
    {
        public string Id { get; set; }
        public string UserId { get; set; }
        public string UserIdEmail { get; set; }
        public string RegionId { get; set; }
        public string RegionName { get; set; }
        public string BusinessGroupId { get; set; }
        public string BusinessGroupName { get; set; }
    }

    public AddorUpdateUser()
    {
        GetLoggedinUserDtls();
        //LstRolesOption = GetRoles();
        //communityItemsList = GetCommunityDetails();

        UserList = new List<ESUserDetails>();
        GetUserDetails();
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
    
    public void GetUserDetails()
    {
        UserList = new List<ESUserDetails>();

        List<ES_User__c> lstESUsers = [SELECT Id, User_Id__c,User_Id__r.email, Region_Id__c,Region_Id__r.Region_Name__C ,Business_Group_Id__c,Business_Group_Id__r.Business_Group_Name__C FROM ES_User__c];

        for(ES_User__c userItem : lstESUsers)
        {
            ESUserDetails userDetails = new  ESUserDetails();

             userDetails.Id = userItem.Id;
             userDetails.UserId = userItem.User_Id__c;
             userDetails.UserIdEmail = userItem.User_Id__r.email;
             userDetails.RegionId = userItem.Region_Id__c;
             userDetails.RegionName = userItem.Region_Id__r.Region_Name__C;
             userDetails.BusinessGroupId = userItem.Business_Group_Id__c;
             userDetails.BusinessGroupName = userItem.Business_Group_Id__r.Business_Group_Name__C;
            
            UserList.add(userDetails);
        }
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

    public void AddOrUpdateMembers()
    {
        List<User> lstUser = [SELECT Id, email FROM User where IsActive=true and email like '%@hp.com'];
        
        Map<string,string> mapUsr = new Map<string,string>();
        List<string> lstUserEmail = new List<string>();
        
        for(User usr:lstUser)
        {
            mapUsr.Put(usr.email, usr.Id);
            lstUserEmail.add(usr.email);
        }

        List<SLP_Region__c> lstRegion = [SELECT Id, Region_Name__c, Is_Active__c FROM SLP_Region__c];
        Map<string,string> mapRegion = new Map<string,string>();
        
        for(SLP_Region__c rgn:lstRegion)
        {
            mapRegion.Put(rgn.Region_Name__c, rgn.Id);
        }

        List<SLP_Business_Group__c> lstBusGrp = [SELECT Id, Business_Group_Name__c, Is_Active__c FROM SLP_Business_Group__c];
        Map<string,string> mapBG = new Map<string,string>();
        
        for(SLP_Business_Group__c bg:lstBusGrp)
        {
            mapBG.Put(bg.Business_Group_Name__c, bg.Id);
        }

        List<SLP_ES_Emp_HRDD_Feed__c> lstESEmp = [SELECT Id, First_Name__c, Last_Name__c, Emp_Name__c, Email__c, Emp_Number__c, Region__c, Business_Group__c, Region_ID__c, Business_Group_Id__c, User_Id__c 
                                                  FROM SLP_ES_Emp_HRDD_Feed__c where Email__C in :lstUserEmail];

        List<SLP_ES_Emp_HRDD_Feed__c> updtdEmpLst = new List<SLP_ES_Emp_HRDD_Feed__c>();
        
        for(SLP_ES_Emp_HRDD_Feed__c emp:lstESEmp)
        {
            if(mapRegion.containskey(emp.Region__c))
            {
                emp.Region_ID__c = mapRegion.get(emp.Region__c);
            }
  
            if(mapBG.containskey(emp.Business_Group__c))
            {
                emp.Business_Group_Id__c = mapBG.get(emp.Business_Group__c);
            }
            updtdEmpLst.add(emp);
        }

        update updtdEmpLst;


        List<SLP_ES_Emp_HRDD_Feed__c> lstESEmpFeed = [SELECT Id, First_Name__c, Last_Name__c, Emp_Name__c, Email__c, Emp_Number__c, Region__c, Business_Group__c, Region_ID__c, Business_Group_Id__c, User_Id__c FROM SLP_ES_Emp_HRDD_Feed__c where Email__C in :lstUserEmail];

        Map<string, SLP_ES_Emp_HRDD_Feed__c> mapSLPESEmpHRDDFeed = new Map<string, SLP_ES_Emp_HRDD_Feed__c>();
        
        for(SLP_ES_Emp_HRDD_Feed__c slpItem : lstESEmpFeed)
        {
            mapSLPESEmpHRDDFeed.put(slpItem.Email__c, slpItem);
        }

        List<ES_User__c> lstUserESObject = [SELECT Id, OwnerId, User_Id__c, Twitter__c, Linked_In__c, Role_ID__c, Region_Id__c, Business_Group_Id__c FROM ES_User__c];
        Map<string, ES_User__c> mapESUser = new Map<string, ES_User__c>();

        for(ES_User__c esuserItem : lstUserESObject)
        {
            mapESUser.put(esuserItem.User_Id__c, esuserItem);
        }

        List<ES_User__c> lstUpdateESUser = new List<ES_User__c>();
        List<ES_User__c> lstInsertESUser = new List<ES_User__c>();

        for(User usr: lstUser)
        {
            SLP_ES_Emp_HRDD_Feed__c slpEmpHrdFeed = new SLP_ES_Emp_HRDD_Feed__c();
            ES_User__c userES = new ES_User__c();

            if(mapESUser.containskey(usr.Id))
            {
                userES = mapESUser.get(usr.Id);
                
                slpEmpHrdFeed = mapSLPESEmpHRDDFeed.get(usr.email);

                if(slpEmpHrdFeed != null)
                {
                    userES.Region_Id__c = slpEmpHrdFeed.Region_ID__c;
                    userES.Business_Group_Id__c = slpEmpHrdFeed.Business_Group_Id__c;
                
                    lstUpdateESUser.add(userES);
                }
            }
            else
            {

                slpEmpHrdFeed = mapSLPESEmpHRDDFeed.get(usr.email);

                if(slpEmpHrdFeed != null)
                {
                    userES.User_Id__c = usr.Id;
                    userES.Region_Id__c = slpEmpHrdFeed.Region_ID__c;
                    userES.Business_Group_Id__c = slpEmpHrdFeed.Business_Group_Id__c;
                
                    lstInsertESUser.add(userES);
                }
            }
        }
        update lstUpdateESUser;
        insert lstInsertESUser;

        /*List<User> userList = [SELECT Id, Username, FirstName, LastName, Email, DigestFrequency,UserPreferencesDisableAllFeedsEmail FROM User where email like '%@hp.com' and IsActive=true and (DigestFrequency !='N' OR UserPreferencesDisableAllFeedsEmail=false)];

        List<User> lstUsr = new List<User>();
        for (User u: userList)
        {
           //u.DigestFrequency = 'N';
           u.UserPreferencesDisableAllFeedsEmail = true;
           lstUsr.add(u);
        }
 
        update lstUsr;*/

        //We need to update to ES_User => If the user Id not present we need to insert

        //Added members and contributors for Communities
        AddorUpdateRoles();
        
        //Added Members for Boards
        AddOrUpdateBoardMembers();
    }

    public void AddorUpdateRoles()
    {
        
        List<Community__Share> lstCommunityShare = new List<Community__Share>();
        List<Community_Member__c> lstCommunityMember = new List<Community_Member__c>();
        List<ES_User__c> lstESInsertUser = new List<ES_User__c>();
        List<ES_User__c> lstESUpdateUser = new List<ES_User__c>();
        Map<string, string> chatPostMembers = new Map<string, string>();
        Map<string, string> chatPostContributors = new Map<string, string>();
        List<FeedItem> lstCommunityFeedItm = new List<FeedItem>();
        List<FeedItem> lstContributorFeedItm = new List<FeedItem>();
        List<string> boardUserMailIds = new List<string>();

        Map<string, SLP_OnBoardingUsers__c> mapBoardUser = new Map<string, SLP_OnBoardingUsers__c>();       
        Map<string,string> lstEmailIds = new Map<string,string>();
        Map<string,string> mapRoleList = new Map<string,string>();
        Map<string, Map<string, Boolean>> mapCommunityUsers = new Map<string, Map<string, Boolean>>();
        Map<string, Map<string, Boolean>> mapContributeUsers = new Map<string, Map<string, Boolean>>();
        Map<string, string> mapCommNUserIds = new Map<string, string>();
        Map<string, string> mapContrNUserIds = new Map<string, string>();

        
        List<string> lstCommunityIds = new List<string>();
        lstCommunityIds.add('a8AZ00000008Oi3MAE');
        lstCommunityIds.add('a8AZ00000008Oi8MAE');
        lstCommunityIds.add('a8AZ00000008OiDMAU');
        lstCommunityIds.add('a8AZ00000008OiIMAU');
        lstCommunityIds.add('a8AZ00000008OiNMAU');
        lstCommunityIds.add('a8AZ00000008OiEMAU');
        lstCommunityIds.add('a8AZ00000008OiSMAU');
        

        List<SLP_OnBoardingUsers__c> lstOnboardUsers = [SELECT Id, Email__c, Role__c, Community_1__c, Community_2__c, Community_4__c, Community_3__c, Community_5__c, Community_6__c, Community_7__c FROM SLP_OnBoardingUsers__c];

        for(SLP_OnBoardingUsers__c userEmail : lstOnboardUsers)
        {
            boardUserMailIds.add(userEmail.Email__c);
        }

        List<User> userList = [SELECT Id, Email FROM User where Email in: boardUserMailIds and IsActive =: true];        
        
        List<SLP_Role__c> roleList = [SELECT Id, Role_Name__c, Is_Active__c, OwnerId FROM SLP_Role__c];
        
        List<ES_User__c> lstESUser = [SELECT OwnerId, Id, User_Id__c, Role_ID__c, Region_Id__c, Business_Group_Id__c, SLP_Bussiness_User__c FROM ES_User__c];

        Map<string, ES_User__c> mapESUser = new Map<string, ES_User__c>();
        
        for(ES_User__c userItem : lstESUser)
        {
            mapESUser.put(userItem.User_Id__c, userItem);
        }

        List<SLP_ES_Emp_HRDD_Feed__c> lstESEmpFeed = [SELECT Id, First_Name__c, Last_Name__c, Emp_Name__c, Email__c, Emp_Number__c, Region__c, Business_Group__c, Region_ID__c, Business_Group_Id__c, User_Id__c FROM SLP_ES_Emp_HRDD_Feed__c where Email__C in : boardUserMailIds];

        Map<string, SLP_ES_Emp_HRDD_Feed__c> mapSLPESEmpHRDDFeed = new Map<string, SLP_ES_Emp_HRDD_Feed__c>();
        
        for(SLP_ES_Emp_HRDD_Feed__c slpItem : lstESEmpFeed)
        {
            mapSLPESEmpHRDDFeed.put(slpItem.Email__c, slpItem);
        }


        // START - Get the members of a particular community 

        List<Community_Member__c> lstCommunityMembers = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Status__c = 'Approved' and Community_Id__c in: lstCommunityIds];

        set<ID> MemberIds = new set<ID>();

        for(Community_Member__c commItem : lstCommunityMembers)
        {
            MemberIds.add(commItem.User_Id__c);

            if(mapCommunityUsers.ContainsKey(commItem.User_Id__c))
            {
                Map<string, boolean> mapBoardOrCommunity = mapCommunityUsers.get(commItem.User_Id__c);
                mapBoardOrCommunity.put(commItem.Community_Id__c, true);

                system.debug('commItem.Community_Id__c:' +commItem.Community_Id__c);
                mapCommunityUsers.put(commItem.User_Id__c, mapBoardOrCommunity);
            }
            else
            {
                Map<string, boolean> mapBoardCommunity = new Map<string, boolean>();
                mapBoardCommunity.put(commItem.Community_Id__c, true);

                system.debug('commItem.Community_Id__c:' +commItem.Community_Id__c);
                mapCommunityUsers.put(commItem.User_Id__c, mapBoardCommunity);
            }
        }

        //END - Get the members of a particular community 
        
        //START - Get the contributors of a particular community 
        
        List<Community__Share> lstCommunityShareCtrbtrs = [SELECT Id, ParentId, UserOrGroupId, AccessLevel FROM Community__Share where AccessLevel = 'Edit' and ParentId in: lstCommunityIds];
        
        set<ID> contributorIds = new set<ID>();
        for(Community__Share commItem : lstCommunityShareCtrbtrs)
        {
            contributorIds.add(commItem.UserOrGroupId);

            if(mapContributeUsers.ContainsKey(commItem.UserOrGroupId))
            {
                Map<string, boolean> mapBoardOrCommunity = mapContributeUsers.get(commItem.UserOrGroupId);
                mapBoardOrCommunity.put(commItem.ParentId, true);
                mapContributeUsers.put(commItem.UserOrGroupId, mapBoardOrCommunity);
            }
            else
            {
                Map<string, boolean> mapBoardCommunity = new Map<string, boolean>();
                mapBoardCommunity.put(commItem.ParentId, true);
                mapContributeUsers.put(commItem.UserOrGroupId, mapBoardCommunity);
            }
        }
        
        //END - Get the contributors of a particular community 

        for(SLP_OnBoardingUsers__c boardUser: lstOnboardUsers)
        {
            mapBoardUser.Put(boardUser.Email__c, boardUser);
            //mapEmailIds.put(boardUser.Email__c, true);
        }

        for(User usr: userList)
        {
            lstEmailIds.Put(usr.Email, usr.Id);
        }

        for(SLP_Role__c usrRole: roleList)
        {
            mapRoleList.Put(usrRole.Role_Name__c, usrRole.Id);
        }


        for(SLP_OnBoardingUsers__c boardUserItem : lstOnboardUsers)
        {
            //Community_Member__c communityMember = new Community_Member__c();
            //Community__Share lbContr = new Community__Share();
            
            if(boardUserItem.Community_1__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember = new Community_Member__c();

                        communityMember.User_Id__c = userId;
                        communityMember.Status__c = 'APPROVED';
                        communityMember.Community_Id__c = AUTOMOTIVE;
                         
                        lstCommunityMember.add(communityMember);
                        
                        //Add User ID & Parent ID for Chat Post
                        chatPostMembers.put(userId, AUTOMOTIVE);
                    }
                    else if(mapCommunityUsers.containsKey(userId))
                    {   
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(AUTOMOTIVE))
                        {
                            Community_Member__c communityMember = new Community_Member__c();

                            communityMember.User_Id__c = userId;
                            communityMember.Status__c = 'APPROVED';
                            communityMember.Community_Id__c = AUTOMOTIVE;
                         
                            lstCommunityMember.add(communityMember);

                            //Add User ID & Parent ID for Chat Post
                            chatPostMembers.put(userId, AUTOMOTIVE);
                        } 
                    }                            
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember = new Community_Member__c();

                    communityMember.User_Id__c = userId;
                    communityMember.Status__c = 'APPROVED';
                    communityMember.Community_Id__c = AUTOMOTIVE;
                         
                    lstCommunityMember.add(communityMember);
            
                    //Add User ID & Parent ID for Chat Post
                    chatPostMembers.put(userId, AUTOMOTIVE);
                }

                AddExpertToCommunity('Automotive', userId);
            }
            else if (boardUserItem.Community_1__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr1 = new Community__Share();

                        lbContr1.UserOrGroupId = userID;
                        lbContr1.ParentId = AUTOMOTIVE;
                        lbContr1.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr1);
                        
                        //Add User ID & Parent ID for Chat Post
                        chatPostContributors.put(userID, AUTOMOTIVE);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {   
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userId);
                    
                        if(!mapIsContributor.containsKey(AUTOMOTIVE))
                        {
                            Community__Share lbContr1 = new Community__Share();

                            lbContr1.UserOrGroupId = userID;
                            lbContr1.ParentId = AUTOMOTIVE;
                            lbContr1.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr1);

                            //Add User ID & Parent ID for Chat Post
                            chatPostContributors.put(userID, AUTOMOTIVE);
                        }
                    } 
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr1 = new Community__Share();

                    lbContr1.UserOrGroupId = userID;
                    lbContr1.ParentId = AUTOMOTIVE;
                    lbContr1.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr1);
                    
                    //Add User ID & Parent ID for Chat Post
                    chatPostContributors.put(userID, AUTOMOTIVE);
                }
            
                AddExpertToCommunity('Automotive', userID);
            }
                
            if(boardUserItem.Community_2__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember = new Community_Member__c();

                        communityMember.User_Id__c = userId;
                        communityMember.Status__c = 'APPROVED';
                        communityMember.Community_Id__c = BANKING;
                         
                        //Add User ID & Parent ID for Chat Post
                        chatPostMembers.put(userId, BANKING);
                        lstCommunityMember.add(communityMember);
                    } 
                    else if (mapCommunityUsers.containsKey(userId))
                    {
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(BANKING))
                        {
                            Community_Member__c communityMember = new Community_Member__c();

                            communityMember.User_Id__c = userId;
                            communityMember.Status__c = 'APPROVED';
                            communityMember.Community_Id__c = BANKING;
                         
                            lstCommunityMember.add(communityMember);

                            //Add User ID & Parent ID for Chat Post
                            chatPostMembers.put(userId, BANKING);
                        } 
                    }
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember = new Community_Member__c();

                    communityMember.User_Id__c = userId;
                    communityMember.Status__c = 'APPROVED';
                    communityMember.Community_Id__c = BANKING;
                         
                    lstCommunityMember.add(communityMember);

                    //Add User ID & Parent ID for Chat Post
                    chatPostMembers.put(userId, BANKING);
                }
    
                AddExpertToCommunity('Banking', userID);
            }
            else if (boardUserItem.Community_2__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr2 = new Community__Share();

                        lbContr2.UserOrGroupId = userID;
                        lbContr2.ParentId = BANKING;
                        lbContr2.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr2);

                        chatPostContributors.put(userID, BANKING);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userId);
                    
                        if(!mapIsContributor.containsKey(BANKING))
                        {
                            Community__Share lbContr2 = new Community__Share();

                            lbContr2.UserOrGroupId = userID;
                            lbContr2.ParentId = BANKING;
                            lbContr2.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr2);

                            chatPostContributors.put(userID, BANKING);
                        }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr2 = new Community__Share();

                    lbContr2.UserOrGroupId = userID;
                    lbContr2.ParentId = BANKING;
                    lbContr2.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr2);

                    chatPostContributors.put(userID, BANKING);
                }

                AddExpertToCommunity('Banking', userID);
            }

            if(boardUserItem.Community_3__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember1 = new Community_Member__c();

                        communityMember1.User_Id__c = userId;
                        communityMember1.Status__c = 'APPROVED';
                        communityMember1.Community_Id__c = CONSUMERGOODS;
                         
                        lstCommunityMember.add(communityMember1);

                        chatPostMembers.put(userId, CONSUMERGOODS);
                    }                            
                    else if(mapCommunityUsers.containsKey(userId))
                    {
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(CONSUMERGOODS))
                        {
                            Community_Member__c communityMember1 = new Community_Member__c();

                            communityMember1.User_Id__c = userId;
                            communityMember1.Status__c = 'APPROVED';
                            communityMember1.Community_Id__c = CONSUMERGOODS;
                         
                            lstCommunityMember.add(communityMember1);

                            chatPostMembers.put(userId, CONSUMERGOODS);
                        } 
                    } 
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember1 = new Community_Member__c();

                    communityMember1.User_Id__c = userId;
                    communityMember1.Status__c = 'APPROVED';
                    communityMember1.Community_Id__c = CONSUMERGOODS;
                         
                    lstCommunityMember.add(communityMember1);

                    chatPostMembers.put(userId, CONSUMERGOODS);
                }

                AddExpertToCommunity('Consumer Packaged Goods', userId);
            }
            else if (boardUserItem.Community_3__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr3 = new Community__Share();

                        lbContr3.UserOrGroupId = userID;
                        lbContr3.ParentId = CONSUMERGOODS;
                        lbContr3.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr3);

                        chatPostContributors.put(userID, CONSUMERGOODS);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userID);
                    
                          if(!mapIsContributor.containsKey(CONSUMERGOODS))
                          {
                            Community__Share lbContr3 = new Community__Share();

                            lbContr3.UserOrGroupId = userID;
                            lbContr3.ParentId = CONSUMERGOODS;
                            lbContr3.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr3);

                            chatPostContributors.put(userID, CONSUMERGOODS);
                          }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr3 = new Community__Share();

                    lbContr3.UserOrGroupId = userID;
                    lbContr3.ParentId = CONSUMERGOODS;
                    lbContr3.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr3);

                    chatPostContributors.put(userID, CONSUMERGOODS);
                }
                AddExpertToCommunity('Consumer Packaged Goods', userID);
            }
            
            if(boardUserItem.Community_4__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember2 = new Community_Member__c();

                        communityMember2.User_Id__c = userId;
                        communityMember2.Status__c = 'APPROVED';
                        communityMember2.Community_Id__c = ENERGYMINING;
                         
                        lstCommunityMember.add(communityMember2);

                        chatPostMembers.put(userId, ENERGYMINING);
                    }                            
                    else if(mapCommunityUsers.containsKey(userId))
                    {
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(ENERGYMINING))
                        {
                            Community_Member__c communityMember2 = new Community_Member__c();

                            communityMember2.User_Id__c = userId;
                            communityMember2.Status__c = 'APPROVED';
                            communityMember2.Community_Id__c = ENERGYMINING;
                         
                            lstCommunityMember.add(communityMember2);

                            chatPostMembers.put(userId, ENERGYMINING);
                        } 
                    }
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember2 = new Community_Member__c();

                    communityMember2.User_Id__c = userId;
                    communityMember2.Status__c = 'APPROVED';
                    communityMember2.Community_Id__c = ENERGYMINING;
                         
                    lstCommunityMember.add(communityMember2);

                    chatPostMembers.put(userId, ENERGYMINING);
                }
                AddExpertToCommunity('Hydrocarbons (Oil & Gas)', userId);
            }
            else if (boardUserItem.Community_4__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr4 = new Community__Share();

                        lbContr4.UserOrGroupId = userID;
                        lbContr4.ParentId = ENERGYMINING ;
                        lbContr4.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr4);

                        chatPostContributors.put(userID, ENERGYMINING);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userID);
                    
                        if(!mapIsContributor.containsKey(ENERGYMINING))
                        {
                            Community__Share lbContr4 = new Community__Share();

                            lbContr4.UserOrGroupId = userID;
                            lbContr4.ParentId = ENERGYMINING ;
                            lbContr4.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr4);
                            
                            chatPostContributors.put(userID, ENERGYMINING);
                        }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr4 = new Community__Share();

                    lbContr4.UserOrGroupId = userID;
                    lbContr4.ParentId = ENERGYMINING ;
                    lbContr4.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr4);

                    chatPostContributors.put(userID, ENERGYMINING);
                }
                AddExpertToCommunity('Hydrocarbons (Oil & Gas)', userID);
            }

            if(boardUserItem.Community_5__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember3 = new Community_Member__c();

                        communityMember3.User_Id__c = userId;
                        communityMember3.Status__c = 'APPROVED';
                        communityMember3.Community_Id__c = INSURANCE;
                         
                        lstCommunityMember.add(communityMember3);

                        chatPostMembers.put(userId, INSURANCE);
                    }                            
                    else if(mapCommunityUsers.containsKey(userId))
                    {

                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(INSURANCE))
                        {
                            Community_Member__c communityMember3 = new Community_Member__c();

                            communityMember3.User_Id__c = userId;
                            communityMember3.Status__c = 'APPROVED';
                            communityMember3.Community_Id__c = INSURANCE;
                         
                            lstCommunityMember.add(communityMember3);

                            chatPostMembers.put(userId, INSURANCE);
                        } 
                    }                            
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember3 = new Community_Member__c();

                    communityMember3.User_Id__c = userId;
                    communityMember3.Status__c = 'APPROVED';
                    communityMember3.Community_Id__c = INSURANCE ;
                         
                    lstCommunityMember.add(communityMember3);

                    chatPostMembers.put(userId, INSURANCE);
                }
                AddExpertToCommunity('Insurance', userId);
            }
            else if (boardUserItem.Community_5__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr5 = new Community__Share();

                        lbContr5.UserOrGroupId = userID;
                        lbContr5.ParentId = INSURANCE;
                        lbContr5.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr5);

                        chatPostContributors.put(userId, INSURANCE);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userID);
                    
                        if(!mapIsContributor.containsKey(INSURANCE))
                        {
                            Community__Share lbContr5 = new Community__Share();

                            lbContr5.UserOrGroupId = userID;
                            lbContr5.ParentId = INSURANCE;
                            lbContr5.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr5);

                            chatPostContributors.put(userID, INSURANCE);
                        }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr5 = new Community__Share();

                    lbContr5.UserOrGroupId = userID;
                    lbContr5.ParentId = INSURANCE;
                    lbContr5.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr5);

                    chatPostContributors.put(userID, INSURANCE);
                }
                AddExpertToCommunity('Insurance', userID);
            }

            if(boardUserItem.Community_6__c == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember4 = new Community_Member__c();

                        communityMember4.User_Id__c = userId;
                        communityMember4.Status__c = 'APPROVED';
                        communityMember4.Community_Id__c = RETAIL;
                         
                        lstCommunityMember.add(communityMember4);

                        chatPostMembers.put(userId, RETAIL);
                    }                            
                    else if(mapCommunityUsers.containsKey(userId))
                    {
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(RETAIL))
                        {
                            Community_Member__c communityMember4 = new Community_Member__c();

                            communityMember4.User_Id__c = userId;
                            communityMember4.Status__c = 'APPROVED';
                            communityMember4.Community_Id__c = RETAIL;
                         
                            lstCommunityMember.add(communityMember4);

                            chatPostMembers.put(userId, RETAIL);
                        } 
                    }                            
                }
                else if(mapCommunityUsers.size() == 0)
                {
                    Community_Member__c communityMember4 = new Community_Member__c();

                    communityMember4.User_Id__c = userId;
                    communityMember4.Status__c = 'APPROVED';
                    communityMember4.Community_Id__c = RETAIL;
                         
                    lstCommunityMember.add(communityMember4);

                    chatPostMembers.put(userId, RETAIL);
                }
                AddExpertToCommunity('Retail', userId);
            }
            else if (boardUserItem.Community_6__c == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr6 = new Community__Share();

                        lbContr6.UserOrGroupId = userID;
                        lbContr6.ParentId = RETAIL;
                        lbContr6.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr6);

                        chatPostContributors.put(userID, RETAIL);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userID);
                    
                        if(!mapIsContributor.containsKey(RETAIL))
                        {
                            Community__Share lbContr6 = new Community__Share();

                            lbContr6.UserOrGroupId = userID;
                            lbContr6.ParentId = RETAIL;
                            lbContr6.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr6);

                            chatPostContributors.put(userID, RETAIL);
                        }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr6 = new Community__Share();

                    lbContr6.UserOrGroupId = userID;
                    lbContr6.ParentId = RETAIL ;
                    lbContr6.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr6);
                    
                    chatPostContributors.put(userID, RETAIL);
                }
                AddExpertToCommunity('Retail', userID);
            }

            if(boardUserItem.Community_7__c  == 'Member')
            {
                string userId = lstEmailIds.get(boardUserItem.Email__c);
                system.debug('userId:'+ userId);

                // Check if the member already exists for the community. If not add to list
                if(mapCommunityUsers.size() > 0)
                {
                    if(!mapCommunityUsers.containsKey(userId))
                    {
                        Community_Member__c communityMember5 = new Community_Member__c();

                        communityMember5.User_Id__c = userId;
                        communityMember5.Status__c = 'APPROVED';
                        communityMember5.Community_Id__c = UTILITIES;
                         
                        lstCommunityMember.add(communityMember5);

                        chatPostMembers.put(userId, UTILITIES);
                    }                            
                    else if(mapCommunityUsers.containsKey(userId))
                    {
                        Map<string, boolean> mapIsMember = mapCommunityUsers.get(userId);
                        
                        if(!mapIsMember.containsKey(UTILITIES))
                        {
                            Community_Member__c communityMember5 = new Community_Member__c();

                            communityMember5.User_Id__c = userId;
                            communityMember5.Status__c = 'APPROVED';
                            communityMember5.Community_Id__c = UTILITIES;
                         
                            lstCommunityMember.add(communityMember5);

                            chatPostMembers.put(userId, UTILITIES);
                        } 
                    }                            
                }
                else if(mapCommunityUsers.size() == 0)
                {

                    Community_Member__c communityMember5 = new Community_Member__c();

                    communityMember5.User_Id__c = userId;
                    communityMember5.Status__c = 'APPROVED';
                    communityMember5.Community_Id__c = UTILITIES;
                         
                    lstCommunityMember.add(communityMember5);

                    chatPostMembers.put(userId, UTILITIES);
                }
                AddExpertToCommunity('Utilities', userId);
            }
            else if (boardUserItem.Community_7__c  == 'Contributor')
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                // Check if the contributor already exists for the community. If not add to list
                
                if(mapContributeUsers.size() > 0)
                {
                    if(!mapContributeUsers.containsKey(userID))
                    {
                        Community__Share lbContr7 = new Community__Share();

                        lbContr7.UserOrGroupId = userID;
                        lbContr7.ParentId = UTILITIES;
                        lbContr7.AccessLevel = 'Edit';
                        
                        lstCommunityShare.add(lbContr7);

                        chatPostContributors.put(userID, UTILITIES);
                    }
                    else if(mapContributeUsers.containsKey(userID))
                    {
                        Map<string, boolean> mapIsContributor = mapContributeUsers.get(userID);
                    
                        if(!mapIsContributor.containsKey(UTILITIES))
                        {
                           Community__Share lbContr7 = new Community__Share();

                            lbContr7.UserOrGroupId = userID;
                            lbContr7.ParentId = UTILITIES;
                            lbContr7.AccessLevel = 'Edit';
                        
                            lstCommunityShare.add(lbContr7);

                            chatPostContributors.put(userID, UTILITIES);
                        }
                    }
                }
                else if(mapContributeUsers.size() == 0)
                {
                    Community__Share lbContr7 = new Community__Share();

                    lbContr7.UserOrGroupId = userID;
                    lbContr7.ParentId = UTILITIES;
                    lbContr7.AccessLevel = 'Edit';
                        
                    lstCommunityShare.add(lbContr7);

                    chatPostContributors.put(userID, UTILITIES);
                }
                AddExpertToCommunity('Utilities', userID);
            }

            ES_User__c esUser = new ES_User__c();
            SLP_ES_Emp_HRDD_Feed__c slpEmpHrdFeed = new SLP_ES_Emp_HRDD_Feed__c();

            //Adding Role
            if(boardUserItem.Role__c != '' || boardUserItem.Role__c != null)
            {
                string userID = lstEmailIds.get(boardUserItem.Email__c);
                
                //check is user already exists in ESUser Object
                if(mapESUser.containsKey(userID))
                {
                    esUser = mapESUser.get(userID);
                    esUser.Role_ID__c = mapRoleList.get(boardUserItem.Role__c);
                    esUser.SLP_Bussiness_User__c = true;
                    
                    slpEmpHrdFeed = mapSLPESEmpHRDDFeed.get(boardUserItem.Email__c);

                    if(slpEmpHrdFeed != null)
                    {
                        esUser.Region_Id__c = slpEmpHrdFeed.Region_ID__c;
                        esUser.Business_Group_Id__c = slpEmpHrdFeed.Business_Group_Id__c;
                    }

                    lstESUpdateUser.add(esUser);
                }
                else
                {
                    slpEmpHrdFeed = mapSLPESEmpHRDDFeed.get(boardUserItem.Email__c);
                
                    if(slpEmpHrdFeed != null)
                    {
                        esUser.Region_Id__c = slpEmpHrdFeed.Region_ID__c;
                        esUser.Business_Group_Id__c = slpEmpHrdFeed.Business_Group_Id__c;
                    }

                    esUser.Role_ID__c = mapRoleList.get(boardUserItem.Role__c);
                    esUser.User_Id__c = lstEmailIds.get(boardUserItem.Email__c);
                    esUser.SLP_Bussiness_User__c = true;

                    lstESInsertUser.add(esUser);
                }
            }
        }

        
        //Add Code here for Chat
        //lstCommunityMember
        //lstCommunityShare
        List<string> userMemberIds = new List<string>();
        List<string> userContributorIds = new List<string>();
        Map<string, string> mapCommunityMemberIds = new Map<string, string>();
        Map<string, string> mapContributorIds = new Map<string, string>();

        for(Community_Member__c member : lstCommunityMember)
        {
            userMemberIds.add(member.User_Id__c);
        }

        List<User> UserMembers = [select Id, Name From User where Id in: userMemberIds and IsActive =: true]; 
            
        for(User usr: UserMembers) 
        { 
            mapCommunityMemberIds.put(usr.Id, usr.Name); 
        } 

        for(Community_Member__c member : lstCommunityMember)
        {
            if(chatPostMembers.containsKey(member.User_Id__c))
            {
                string parentID = chatPostMembers.get(member.User_Id__c);

                FeedItem post = new FeedItem(); 
                post.ParentId = parentID; 
                string tag='Added Member'; 
                string UserName = mapCommunityMemberIds.get(member.User_Id__c); 
                string comment = UserName +' is Added as a Member'; 
                post.Body = '#[' + tag + ']' + ' ' + comment; 
                lstCommunityFeedItm.add(post);
            }
        }

        for(Community__Share member : lstCommunityShare)
        {
            userContributorIds.add(member.UserOrGroupId);
        }

        List<User> UserContributors = [select Id, Name From User where Id in: userContributorIds and IsActive =: true]; 
            
        for(User usr: UserContributors) 
        { 
            mapContributorIds.put(usr.Id, usr.Name); 
        } 

        for(Community__Share member : lstCommunityShare)
        {
            if(chatPostContributors.containsKey(member.UserOrGroupId))
            {
                string parentID = chatPostContributors.get(member.UserOrGroupId);

                FeedItem post = new FeedItem(); 
                post.ParentId = parentID; 
                string tag='Added Member'; 
                string UserName = mapContributorIds.get(member.UserOrGroupId); 
                string comment = UserName +' is Added as a Member'; 
                post.Body = '#[' + tag + ']' + ' ' + comment; 
                lstContributorFeedItm.add(post);
            }
        }

        //Insert or Update
        if(lstCommunityMember.size() > 0)
        {
            insert lstCommunityMember;
        }
        
        if(lstCommunityShare.size() > 0)
        {
            insert lstCommunityShare;
        }
        
        if(lstESInsertUser.size() > 0)
        {
            insert lstESInsertUser;
        }
        
        if(lstESUpdateUser.size() > 0)
        {
            update lstESUpdateUser;
        }
        
        if(lstCommunityFeedItm.size() > 0)
        {
            insert lstCommunityFeedItm;
        }
        
        if(lstContributorFeedItm.size() > 0)
        {
            insert lstContributorFeedItm;
        }
    }

    public void AddExpertToCommunity(string industryName, string userID)
    {
        /*system.debug('userID AddExpertToCommunity:'+ userID);
        SLP_Secondary_Industry__c slpIndustry = [SELECT Id, Industry_Name__c, Secondary_Industry_Name__c, Is_Active__c FROM SLP_Secondary_Industry__c where Secondary_Industry_Name__c =: industryName];
        ES_User__c esUser = new ES_User__c();
        
        esUser = [SELECT Id, User_Id__c, Role_ID__c, Region_Id__c, Business_Group_Id__c, SLP_Bussiness_User__c FROM ES_User__c where User_Id__c =: userID Limit 1];
        if(esUser!= Null){
            SLP_Expert__c expert = new SLP_Expert__c();
            expert.SLP_Secondary_Industry_ID__c  = slpIndustry.Id;
            expert.ES_User_ID__c = esUser.Id;
        
            insert expert;
        }*/
    }

    public void AddOrUpdateBoardMembers()
    {
        List<Learning_Board_Member__c> lstBoardMember = new List<Learning_Board_Member__c>();
        List<string> boardUserMailIds = new List<string>();
        List<string> lstBoardIds = new List<string>();
        List<string> lstUserIds = new List<String>();
        Map<string, string> mapUser = new Map<string, string>();
        List<EntitySubscription> lstEntitySubc = new  List<EntitySubscription>();
        Map<string, Map<string, Boolean>> mapBoardUsers = new Map<string, Map<string, Boolean>>();
        Map<string, Map<string, Boolean>> mapEntityUsers = new Map<string, Map<string, Boolean>>();
        Map<string, string> chatPostMembers = new Map<string, string>();
        Map<string, boolean> mapEntitySubUserIds = new Map<string, boolean>();

        //Board Ids
        lstBoardIds.add('a6tZ00000008TMnIAM');
        lstBoardIds.add('a6tZ00000008TMsIAM');
        lstBoardIds.add('a6tZ00000008TMxIAM');
        
        //Fetch user email ids from SLP_OnBoardingUsers__c object
        List<SLP_OnBoardingUsers__c> lstOnboardUsers = [SELECT Id, Email__c, Role__c, Community_1__c, Community_2__c, Community_4__c, Community_3__c, Community_5__c,
                                                        Community_6__c, Community_7__c FROM SLP_OnBoardingUsers__c];

        for(SLP_OnBoardingUsers__c userEmail : lstOnboardUsers)
        {
            boardUserMailIds.add(userEmail.Email__c);
        }

        List<User> userList = [SELECT Id, Email FROM User where Email in: boardUserMailIds and IsActive =: true];        
        
        for(User user : userList)
        {
            mapUser.put(user.Email, user.Id);
            lstUserIds.add(user.Id);
        }
        
        // START - Get the members of a particular community 
        List<Learning_Board_Member__c> lstBoardMembers = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Status__c = 'Approved' and
                                                          Learning_Board_ID__c in: lstBoardIds and User_Id__c in: lstUserIds];

        for(Learning_Board_Member__c boardItem : lstBoardMembers)
        {
            if(mapBoardUsers.ContainsKey(boardItem.User_Id__c))
            {
                Map<string, boolean> mapBoardMembers = mapBoardUsers.get(boardItem.User_Id__c);
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, true);

                mapBoardUsers.put(boardItem.User_Id__c, mapBoardMembers);
            }
            else
            {
                Map<string, boolean> mapBoardMembers = new Map<string, boolean>();
                mapBoardMembers.put(boardItem.Learning_Board_ID__c, true);

                mapBoardUsers.put(boardItem.User_Id__c, mapBoardMembers);
            }
        }

        //END - Get the members of a particular community 

        List<EntitySubscription> entityMembers = [select ParentId, SubscriberID from EntitySubscription where ParentId in: lstBoardIds and SubscriberID in: lstUserIds];

        for(EntitySubscription entityItem : entityMembers)
        {
            if(mapEntityUsers.ContainsKey(entityItem.SubscriberID))
            {
                Map<string, boolean> mapEntityMembers = mapEntityUsers.get(entityItem.SubscriberID);
                mapEntityMembers.put(entityItem.ParentId, true);

                mapEntityUsers.put(entityItem.SubscriberID, mapEntityMembers);
            }
            else
            {
                Map<string, boolean> mapEntityMembers = new Map<string, boolean>();
                mapEntityMembers.put(entityItem.ParentId, true);

                mapEntityUsers.put(entityItem.SubscriberID, mapEntityMembers);
            }
        }

        for(string boardId : lstBoardIds)
        {
            for(SLP_OnBoardingUsers__c userItem : lstOnboardUsers)
            {
                system.debug('mapEntityUsers size:'+ mapEntityUsers.size());
                system.debug('mapBoardUsers size:'+ mapBoardUsers.size());

                Learning_Board_Member__c boardMember = new Learning_Board_Member__c();
                EntitySubscription entitySub = new EntitySubscription();
                
                system.debug('out mapUser size:'+ mapUser.size());

                if(mapUser.containsKey(userItem.Email__c))
                {
                    system.debug('mapUser size:'+ mapUser.size());
                    string userID = mapUser.get(userItem.Email__c);
                    
                    mapEntitySubUserIds.put(userID, true);

                    if(mapBoardUsers.size() > 0)
                    {
                        if(!mapBoardUsers.containsKey(userID))
                        {
                            boardMember.User_Id__c = userID;
                            boardMember.Status__c = 'APPROVED';
                            boardMember.Learning_Board_ID__c = boardId;

                            lstBoardMember.add(boardMember);
                        
                            chatPostMembers.put(userID, boardId);
                        }
                        else if(mapBoardUsers.containsKey(userID))
                        {   
                            Map<string, boolean> mapIsMember = mapBoardUsers.get(userID);
                        
                            if(!mapIsMember.containsKey(boardId))
                            {
                                boardMember.User_Id__c = userID;
                                boardMember.Status__c = 'APPROVED';
                                boardMember.Learning_Board_ID__c = boardId;
                         
                                lstBoardMember.add(boardMember);

                                chatPostMembers.put(userID, boardId);
                            }
                        }

                        
                        
                        //if(!mapEntityUsers.containsKey(userID))
                        //{
                        //    entitySub.ParentId = boardId; 
                        //    entitySub.SubscriberID = userID;
                            
                        //    lstEntitySubc.add(entitySub);
                        //}
                        //else if(mapEntityUsers.containsKey(userID))
                        //{
                        //    Map<string, boolean> mapIsEntityMember = mapEntityUsers.get(userID);
                        
                        //    if(!mapIsEntityMember.containsKey(boardId))
                        //    {
                        //        entitySub.ParentId = boardId; 
                        //        entitySub.SubscriberID = userID;
                            
                        //        lstEntitySubc.add(entitySub);
                        //    }
                        //}
                    }
                    else if(mapBoardUsers.size() == 0)
                    {
                        boardMember.User_Id__c = userID;
                        boardMember.Status__c = 'APPROVED';
                        boardMember.Learning_Board_ID__c = boardId;
                         
                        lstBoardMember.add(boardMember);

                        chatPostMembers.put(userID, boardId);
                    }

                    
                }                
            }   
        }

        Set<string> lstUserEntitySubIds = new Set<string>();
        //lstUserEntitySubIds.add(mapEntitySubUserIds.keySet());

//for(SLP_OnBoardingUsers__c userItem : lstOnboardUsers)
// {
//}
        for(string board : lstBoardIds)
        {
            for(string strUserId : mapEntitySubUserIds.keySet())
            {
                EntitySubscription entitySub = new EntitySubscription();
                entitySub.ParentId = board; 
                entitySub.SubscriberID = strUserId;
                            
                lstEntitySubc.add(entitySub);
            }
        }

        List<string> userMemberIds = new List<string>();
        Map<string, string> mapBoardMemberIds = new Map<string, string>();
        List<FeedItem> lstBoardFeedItm = new List<FeedItem>();

        for(Learning_Board_Member__c member : lstBoardMember)
        {
            userMemberIds.add(member.User_Id__c);
        }

        List<User> UserMembers = [select Id, Name From User where Id in: userMemberIds and IsActive =: true]; 
            
        for(User usr: UserMembers) 
        { 
            mapBoardMemberIds.put(usr.Id, usr.Name); 
        } 

        for(Learning_Board_Member__c member : lstBoardMember)
        {
            if(chatPostMembers.containsKey(member.User_Id__c))
            {
                string parentID = chatPostMembers.get(member.User_Id__c);

                FeedItem post = new FeedItem(); 
                post.ParentId = parentID; 
                string tag ='Added Member'; 
                string UserName = mapBoardMemberIds.get(member.User_Id__c); 
                string comment = UserName +' is Added as a Member'; 
                post.Body = '#[' + tag + ']' + ' ' + comment; 
                
                lstBoardFeedItm.add(post);
            }
        }

        if(lstBoardMember.size() > 0)
        {
            insert lstBoardMember;
        }

        if(lstEntitySubc.size() > 0)
        {
            insert lstEntitySubc;
        }
        
        if(lstBoardFeedItm.size() > 0)
        {
            insert lstBoardFeedItm;
        }
    }
}