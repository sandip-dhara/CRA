/**********************************************************
* Class Name: AccountTeamListController
* Author: Accenture
* Date: 30-MAR-2012 
* Requirement # Request Id: 317/304/307 
* Description: Controller to display Account Team Members with Business Group
***********************************************************/
public class AccountTeamListController {
    public Account account; 
    public string groupName {get;set;}
    public List<AccountTeamMember> accountTeamMembers {get;set;}
    public List<AccountTeamMember> fetchAccountTeamMembers; 
    public String message {get;set;}
    public String errormessage {get ;set;}
    public String accountId {get;set;}
    public String accountName {get;set;}
    public Boolean isAccountTeamExists {get; set;}
    public Boolean isOwner {get; set;}
    public Boolean isOpenOpty {get; set;}
    public Boolean addAccess {get; set;}
    public Boolean editAccess {get; set;}
    public String selectedMemberId {get; set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'user.Name';
    private String currentUserId;
    public String isTeamMember {get; set;}
    private Set<id> setAdminProfiles;
    private Id currentProfileId;
    /**
    * @description: Constructor for Account standard controller  
    * @param: parameter - ApexPages.StandardController controller
    */              
    public AccountTeamListController(ApexPages.StandardController controller) {
        Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
        setAdminProfiles = new Set<Id>();
        for (Admin_Profiles__c prof : adminProfilesMap.values()) {
            if (prof.Module__c != null) {
                if (prof.Module__c.equalsIgnoreCase('AccountTeam')) {
                    if (prof.Profile_ID__c != null) {
                    system.debug('SFDC TEST' + prof.Profile_ID__c);
                        setAdminProfiles.add(convertTo15Digit(prof.Profile_ID__c));
                        system.debug('SFDC TEST' + convertTo15Digit(prof.Profile_ID__c));
                        system.debug('SFDC TEST' + setAdminProfiles);
                    }
                }
            }
        }
        account = (Account)controller.getRecord();
        currentUserId = Userinfo.getUserId();
        currentProfileId = Userinfo.getProfileId();
        currentProfileId = convertTo15Digit(currentProfileId);
        accountId = account.Id;
        message = '';
        errormessage = '';
        isTeamMember = 'false';
        groupName = 'all';
        isAccountTeamExists = true;
        isOwner = true;
        isOpenOpty = false;
        /* Permissions for actions on Account Team Members */
        addAccess = false;
        editAccess = false;
        /* Check for Account Owner and Account Team */
        fetchAccountTeamMembers = new List<AccountTeamMember>();
        fetchAccountInfo();
        if (!isOwner) {
            isAccountTeamExists = false;    
        }
        filterTeamList();
    }
    /**
    * @description: To get 15 digit Id 
    */
    private String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception ex){
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'AccountTeamMember', 'AccountTeamListController', 'Class');
        }
        return paramID;
    }
    /**
    * @description: Returns Business Group options from User object Business Group picklist field
    * @return: parameter - List<SelectOption> List of Business Group options  
    */           
    public List<SelectOption> getBusinessGroups() {
      List<SelectOption> options = new List<SelectOption>();
      Schema.DescribeFieldResult fieldResult = User.Business_Group__c.getDescribe();
      List<Schema.PicklistEntry> businessGroups = fieldResult.getPicklistValues();
      options.add(new SelectOption(Label.All, Label.All));
      for (Schema.PicklistEntry businessGroup : businessGroups) {
          options.add(new SelectOption(businessGroup.getLabel(), businessGroup.getValue()));
      }       
      return options;
  }
    
    /**
    * @description: To filter Account Team Members depending on selected Business Group 
    */           
    public void filterTeamList() {
        message = '';
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        String qry = 'Select User.Name, User.Business_Group__c, UserId,User.Employee_Country__c,User.Proudct_speciality__c, TeamMemberRole, Id,' +
                 'Account.Id, Account.Name, AccountId, AccountAccessLevel, Account.OwnerId ' +
                            'From AccountTeamMember where AccountId = \'' + accountId + '\'';
        if (!groupName.equalsIgnoreCase('all')) {
            qry += ' And User.Business_Group__c Like \'' + groupName + '\'';
        }
        qry += 'order by '+sortFullExp;
        accountTeamMembers = Database.query(qry);
        for (AccountTeamMember teamMember : accountTeamMembers) {
            if (currentUserId.equalsIgnoreCase(teamMember.UserId)) {
                isOwner = true;
                isTeamMember = 'true';
                /* Permissions for actions on Account Team Members */
                if (teamMember.AccountAccessLevel == 'Edit') {
                    addAccess = true;
                      system.debug('SFDC TEST Add Excess Internal ' + addAccess);
                }
            } 
        }
         system.debug('SFDC TEST1' + setAdminProfiles);
          system.debug('SFDC TEST1' + currentProfileId);
            system.debug('SFDC TEST Add Excess' + addAccess);
              system.debug('SFDC TEST Add Excess' + setAdminProfiles.contains(currentProfileId));
        if(setAdminProfiles.contains(currentProfileId)){
            isOwner = true;
            isTeamMember = 'true';
            /* Permissions for actions on Account Team Members */
            addAccess = true;
            editAccess = true;
            system.debug('SFDC TEST Add Excess Internal 1 ' + addAccess);
        }
        if (accountTeamMembers.size() < 1) {
            message = Label.Error_Team_Members;
        } else {
            message = '';
        } 
    }
    
    /**
    * @description: Return true if Account team members list is empty   
    */
    public boolean getIsAccountTeamMembersListEmpty(){
        boolean retValue = false;
        if (accountTeamMembers == null || accountTeamMembers.size() < 1) {
            retValue = true;
        }
        return retvalue;
    }
    /**
    * @description: sortExpression property 
    */
    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp) {
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            } else {
                sortDirection = 'ASC';
            }
            sortExp = value;
        }
    }
    
    /**
    * @description: get method for sortDirection property 
    */
    public String getSortDirection() {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '') {
            return 'ASC';
        } else {
            return sortDirection;
        }
    }
  
    /**
    * @description: set method for sortDirection property 
    */
    public void setSortDirection(String value) {  
        sortDirection = value;
    }
    
    /**
    * @description: Redirect to VF Page to Add Default Team Members in Account Team 
    */
    public PageReference addDefaultTeam() {
        AddDefaultTeamController addDefaultTeamController = new AddDefaultTeamController();           
        errormessage = addDefaultTeamController.addDefaultTeamforAM(account.Id);
        return null;  
    } 
    
    /**
    * @description - Checks for Open oppportunities which are associated to current account
    */        
    public void checkForOpenOptys() {
        List<String> labels = new List<String>();
        labels.add(Label.Won_Deploy_Expand);
        labels.add(Label.Closed_Lost);
        labels.add(Label.Not_Pursued);
        labels.add(Label.Error);

        Map<Id, Opportunity> optys = new Map<Id, Opportunity>([Select id, Name
                                                                From Opportunity
                                                                Where AccountId = :accountId
                                                                AND StageName Not IN :labels]);
        List<OpportunityTeamMember> chekOptysTeam = new List<OpportunityTeamMember>(); 
        Set<String> optyUserId = new Set<String>(); 
        if (optys.size() > 0) {
            // Fecth Opty Sales Team
            chekOptysTeam = [Select id, UserId
                                From OpportunityTeamMember
                                Where OpportunityId IN :optys.keySet()];
        }
        
        // Collect UserId from opty team member
        for (OpportunityTeamMember user: chekOptysTeam) {
            optyUserId.add(user.UserId);    
        }   
        for (AccountTeamMember accountTeamMember : fetchAccountTeamMembers) {
            if (optyUserId.contains(accountTeamMember.UserId)) {
                isOpenOpty = true;
                break;  
            }
        }
    }

    /**
    * @description - Give call to deleteMembers() method to delete selected team member 
    */        
    public void deleteMembers() {
        
        if (selectedMemberId != null ) {
            DeleteAllAccountTeamController deleteAccountTeam = new DeleteAllAccountTeamController(selectedMemberId);
            deleteAccountTeam.deleteMembers(accountId, selectedMemberId);
        }  else {
            DeleteAllAccountTeamController deleteAccountTeams = new DeleteAllAccountTeamController();
            deleteAccountTeams.deleteMembers(accountId, selectedMemberId);
        }
    }
    /**
    * @description - Fetch Acount information for the current account  
    */
    public void fetchAccountInfo() {
        if (accountId != null) {
            fetchAccountTeamMembers = [Select UserId, Id, AccountId, Account.OwnerId
                                            From AccountTeamMember
                                            Where AccountId =: account.Id];
            // Check for account owner
            if (fetchAccountTeamMembers.size() <= 0) {
                isAccountTeamExists = false;    
            } 
            Account accountInfo = new Account();
            accountInfo = [Select Id, Name, OwnerId
                            From Account
                            Where Id = :accountId ];
            accountName = accountInfo.Name;
            if (!Userinfo.getUserId().contains(accountInfo.OwnerId)) {
                isOwner = false;
            }
        }                                                           
    }        
}