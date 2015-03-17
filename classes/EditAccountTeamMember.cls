/**********************************************************
* Class Name: EditAccountTeamMember
* Author: Accenture
* Date: 10-APR-2012 
* Requirement # Request Id:
* Description: Controller to edit Account Team Member
***********************************************************/
public class EditAccountTeamMember {
    public AccountTeamMember accountTeamMember {get; set;}
    public AccountShare accountShare {get; set;}
    public String accountAccessLevel {get; set;}
    public String contactAccessLevel {get; set;}
    public String opportunityAccessLevel {get; set;}
    public String caseAccessLevel {get; set;}
    public String errorMessage {get; set;}
    public String accountId;
    public String teamMemberId, isTeamMember;
    
    /**
    * @description: Constructor of a class
    */
    public EditAccountTeamMember() {
        /* To get parameters from URL */
        accountId = ApexPages.currentPage().getParameters().get('id');
        teamMemberId = ApexPages.currentPage().getParameters().get('memberId');
        isTeamMember = ApexPages.currentPage().getParameters().get('teamMember');
        /* To initialize public properties of a class */
        accountShare = new AccountShare();
        accountTeamMember = new AccountTeamMember();
        if (accountId != null && teamMemberId != null) {
            
            /* To get Account Team Member details */
            accountTeamMember = [Select Id, UserId, TeamMemberRole, User.Name,AccountId, AccountAccessLevel 
                                    From AccountTeamMember 
                                    Where Id =: teamMemberId];
                                
            /* To get sharing access for Account Team Member */
            accountShare = [Select UserOrGroupId, OpportunityAccessLevel,CaseAccessLevel, AccountId, RowCause,  
                                    ContactAccessLevel, AccountAccessLevel 
                                From AccountShare
                                Where AccountId =: accountId
                                And UserOrGroupId =: accountTeamMember.UserId]; 
        }
    }
    
    /**
    * @description: To get Account Access Level selection options
    * @return: List of options to select access level 
    */
    public List<SelectOption> getAccountAccessOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Read','Read Only'));
        options.add(new SelectOption('Edit','Read/Write'));
        return options;
    }
    
    /**
    * @description: To get Access Level selection options
    * @return: List of options to select access level 
    */
    public List<SelectOption> getAccessLevelOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','Private'));
        options.add(new SelectOption('Read','Read Only'));
        options.add(new SelectOption('Edit','Read/Write'));
        return options;
    }
    
    /**
    * @description: Save menthod to add Account Team Member
    * @return: Redirects to Account Page after save
    */
    public Pagereference save(){
        Pagereference pageRef = new PageReference('/' + accountId);
        try {
            update accountTeamMember;
            update accountShare;
        } 
        catch (Exception ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'AccountTeamMember', 'EditAccountTeamMember', '');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
        pageRef.setRedirect(true);        
        return pageRef;
    }
    
    /**
    * @description: Return to Account Page
    * @return: Redirects to Account Page 
    */
    public Pagereference cancel(){
        Pagereference pageRef = new PageReference('/' + accountId);
        pageRef.setRedirect(true);        
        return pageRef;
    }
}