/**********************************************************
* Class Name: NewAccountTeamMembers
* Author: Accenture
* Date: 06-APR-2012 
* Requirement # Request Id:
* Description: Controller to add Account Team Mebers
***********************************************************/
public class NewAccountTeamMembers {
    public List<accountTeamMembers> newAccountTeamMembers {get;set;}
    public String accountId;
    public String accountName {get;set;}
    public String isTeamMember ;
    private Set<id> setAdminProfiles;
    private Id currentProfileId;
    
    /**
    * @description: Constructor of a class null '
    */ 
    public NewAccountTeamMembers(){
        /* To get Account Id */
        accountId = ApexPages.currentPage().getParameters().get('id');
        accountName = ApexPages.currentPage().getParameters().get('name');
        isTeamMember = ApexPages.currentPage().getParameters().get('teamMember');
        newAccountTeamMembers = new List<accountTeamMembers>();
        /* Default 5 rows will be disaplyed on page to add team members */
        for (Integer i=0; i<5; i++) {
            AccountTeamMember member = new AccountTeamMember();
            member.accountId = accountId;
            accountTeamMembers accountMember = new accountTeamMembers(member);
            newAccountTeamMembers.add(accountMember);
        }
        /* Checking for admin profiles */
        currentProfileId = Userinfo.getProfileId();
        currentProfileId = AccountTriggerController.convertTo15Digit(currentProfileId);
        
        Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
        setAdminProfiles = new Set<Id>();
        for (Admin_Profiles__c prof : adminProfilesMap.values()) {
            if (prof.Module__c != null) {
                if (prof.Module__c.equalsIgnoreCase('AccountTeam')) {
                    if (prof.Profile_ID__c != null) {
                        setAdminProfiles.add(AccountTriggerController.convertTo15Digit(prof.Profile_ID__c));
                    }
                }
            }
        }
    }
    /**
    * @description: To get User Type selection options
    */
    public List<SelectOption> getUserTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('TeamEligibleUserLookup','User'));
        options.add(new SelectOption('PartnerUserLookup','Partner User'));
        return options;
    }
    /**
    * @description: To get Account Access Level selection options
    */
    public List<SelectOption> getAccountAccessOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read','Read Only'));
        if (setAdminProfiles.contains(currentProfileId)) {
            options.add(new SelectOption('Edit','Read/Write'));
        }
        return options;
    }
    
    /**
    * @description: To get Access Level selection options
    */
    public List<SelectOption> getAccessLevelOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read','Read Only'));
        if (setAdminProfiles.contains(currentProfileId)) { 
            options.add(new SelectOption('None','Private'));
            options.add(new SelectOption('Edit','Read/Write'));
        }
        return options;
    }
    
    /**
    * @description: Save menthod to add Account Team Member
    * @return: Redirects to Account page after save
    */
    public Pagereference save(){
        System.Savepoint sp=null;
        Pagereference pageRef = new PageReference('/' + accountId);
        List<String> newMemberIds = new List<String>();
        Map<String, accountTeamMembers> accountTeamMap = new Map<String, accountTeamMembers>();  
        try {
            List<AccountTeamMember> newTeamMembers = new List<AccountTeamMember>(); 
            for (accountTeamMembers accTeamRecord : newAccountTeamMembers) {
                if (accTeamRecord.accountTeamMember.UserId != null) {
                        if(accTeamRecord.accountTeamMember.TeamMemberRole==null ||accTeamRecord.accountTeamMember.TeamMemberRole==''){
                        accTeamRecord.accountTeamMember.TeamMemberRole.addError('You must enter a value');
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must enter a value'));
                        return null;
                    }
                    if(accountTeamMap.containsKey(accTeamRecord.accountTeamMember.UserId)){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Duplicate User Found in the list'));
                        return null;
                    } else {
                            newTeamMembers.add(accTeamRecord.accountTeamMember);
                            newMemberIds.add(accTeamRecord.accountTeamMember.UserId);
                            accountTeamMap.put(accTeamRecord.accountTeamMember.UserId, accTeamRecord);
                    }
                }
            }
            //Database save point
            sp = Database.setSavepoint();
            insert newTeamMembers;
            List<AccountShare> accountShares = new List<AccountShare>();
            
            for (AccountShare accountShare : [Select UserOrGroupId, OpportunityAccessLevel, 
                                                        CaseAccessLevel, AccountId, RowCause,  
                                                        ContactAccessLevel, AccountAccessLevel 
                                                From AccountShare
                                                Where AccountId =:accountId
                                                And UserOrGroupId IN : newMemberIds] ) {
                
                accountTeamMembers member = accountTeamMap.get(accountShare.UserOrGroupId);
                if (member != null){
                    accountShare.AccountAccessLevel = member.accountAccessLevel;
                    //accountShare.ContactAccessLevel = member.contactAccessLevel;
                    accountShare.OpportunityAccessLevel = member.opportunityAccessLevel;
                    accountShare.CaseAccessLevel = member.caseAccessLevel;
                    accountShares.add(accountShare);
                }
            }
            if (accountShares.size() > 0){
                update accountShares;
            }  
        } catch(DmlException dmlEx){
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            CreateApexErrorLog.insertHandledExceptionsForLeadConversion(dmlEx, null, 'AccountTeamMember', 'NewAccountTeamMembers', 'Class');
            Database.rollback(sp);
            return null;
        }
        catch (Exception e) {
                CreateApexErrorLog.insertHandledExceptions(e, null, 'AccountTeamMember', 'NewAccountTeamMembers', 'Class');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                        Database.rollback(sp);
                        return null;
        }
        pageRef.setRedirect(true);        
        return pageRef;
    }
    /**
    * @description: Save menthod to add Account Team Member
    * @return: Returns on same page to add more members
    */
    public Pagereference saveAndMore(){
        Pagereference returnPage = save();
        returnPage = new Pagereference('/apex/NewAccountTeamMembers?id='+accountId);
        returnPage.setRedirect(true);        
        return returnPage;
    }
    /**
    * @description: Return to Account Page 
    */
    public Pagereference cancel(){
        Pagereference pageRef = new PageReference('/' + accountId);
        pageRef.setRedirect(true);        
        return pageRef;
    }
    
    /**
    * @description: Inner class to store properties of every record 
    */
    public class accountTeamMembers {
        public AccountTeamMember accountTeamMember {get; set;}
        public String accountAccessLevel {get; set;}
        public String contactAccessLevel {get; set;}
        public String opportunityAccessLevel {get; set;}
        public String caseAccessLevel {get; set;}
        public String errorMessage {get; set;}
        public String userType {get; set;}
        
        public accountTeamMembers(AccountTeamMember  teamMember) {
            accountTeamMember = teamMember;
            errorMessage = 'Error: Please Select Team Role';
        }
    }
}