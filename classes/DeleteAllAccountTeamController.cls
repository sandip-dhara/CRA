/**********************************************************
* Class Name: DeleteAllAccountTeamController
* Author: Accenture
* Date: 10-APR-2012 
* Requirement # Request Id :
* Description: Controller to delete selected or all account team members.
***********************************************************/
public class DeleteAllAccountTeamController {

    public Boolean removeMembersFromOpt {get; set;}
    public String accountId ;
    public List<AccountTeamMember> accountTeamMembers ;
    public List<Opportunity> associatedOptys ;
    public List<Opportunity> associatedOptysId ;
    public List<OpportunityTeamMember> optyTeamMembers ;
    public List<String> userIdOfTeamMembers;
    public String selectedMemberId ;
    
    /**
    *	@description - Fetch Account Id and Accont Team Member user id from the parameters. 
    */
    public DeleteAllAccountTeamController() {
        if (ApexPages.currentPage().getParameters() != null) {
                accountId = ApexPages.currentPage().getParameters().get('id');
                selectedMemberId = ApexPages.currentPage().getParameters().get('memberId'); 
        }
    } 
    
    /**
    * 	@description - 	Set select account team member user id
    *	@param - 		String selectedMemberId - User id of the team memeber	
    */      
    public DeleteAllAccountTeamController(String selectedMemberId) {
       selectedMemberId = selectedMemberId;
    }
    
    /**
    *	@description -	This method is used to delete all team members from the specified account and also the Sales Team from the open opportunity.
    * 					This method gets called on click of "Delete All" button from the related list "Account Team"
    * 	@returns- PageReference to the account record 
    */
    public PageReference deleteAllTeamMembers() {
        /* To get Account Id */
        if (ApexPages.currentPage().getParameters() != null) {
	        accountId = ApexPages.currentPage().getParameters().get('id');
	        selectedMemberId = ApexPages.currentPage().getParameters().get('memberId'); 
        }
        if (accountId != null ) {
            accountTeamMembers = new List<AccountTeamMember>();
            accountTeamMembers = fetchAccountTeamMembers(accountId);               
            userIdOfTeamMembers = new List<String>();
            for (AccountTeamMember teamMember : accountTeamMembers) {
                userIdOfTeamMembers.add(teamMember.UserID);
            }
            if (!removeMembersFromOpt) {
                // delete only account team members associated to the current account
                if (accountTeamMembers.size() > 0) {
                    try {
                        delete accountTeamMembers; 
                    } 
                    catch(DMLException e) {
                        CreateApexErrorLog.insertHandledExceptions(e, null, 'AccountTeamMember', 'DeleteAllAccountTeamController', 'Class');
                    }
                }
            } else {
                // Delete sales team of associated optys which are account team memebers
                fetchOpportunitiesWithSalesTeam(accountId);
                if (accountTeamMembers.size() > 0) {
                    try {
                    	delete accountTeamMembers; 
                    } 
                    catch(DMLException e) {
                        CreateApexErrorLog.insertHandledExceptions(e, null, 'AccountTeamMember', 'DeleteAllAccountTeamController', 'Class');
                    }
                }
                if (optyTeamMembers.size() > 0) {
                    try {
                        delete optyTeamMembers;
                    } 
                    catch(DMLException e) {
                        CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'DeleteAllAccountTeamController', 'Class');
                    }
                }
            }
        }
        PageReference pageRef = new PageReference('/'+accountId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    * @description - Fetch Account Team Members for the given account id
    * @param - String accountId - Selected account id
    * @returns - List of Account Team Members 
    */
    public List<AccountTeamMember> fetchAccountTeamMembers (String accountId) {
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        if ((selectedMemberId == null || selectedMemberId == '') && accountId != null) {
            accountTeamMembers = [Select UserId, Id, AccountId 
                                    From AccountTeamMember
                                    Where AccountId = :accountId];
        } else {
            accountTeamMembers = [Select UserId, Id, AccountId 
                                    From AccountTeamMember
                                    Where AccountId = :accountId
                                    AND UserID = :selectedMemberId];                
        }  
        selectedMemberId = null;
        return accountTeamMembers;                                              
    }

    /**
    * @description - Fetch Opportunities associated to the given account id
    * @param - String accountId - Selected account id
    * @returns - List of Opportunities by Opty Id
    */
    public void fetchOpportunitiesWithSalesTeam (String accountId) {
        associatedOptysId = new List<Opportunity>();
        optyTeamMembers = new List<OpportunityTeamMember>();
        for(Opportunity opty: [Select id, AccountId,
                                    (Select Id, OpportunityId, userId
                                            From OpportunityTeamMembers
                                            Where userId IN :userIdOfTeamMembers) 
                            	From Opportunity 
                            	Where AccountId = :accountId]) {
                                    if (opty.OpportunityTeamMembers.size() > 0) {
                                            optyTeamMembers.add(opty.OpportunityTeamMembers);
                                    }
		}
    }
    
    /**
    *	@description - This method gets called on click of "Cancel" button from the related list "Account Team".
    */ 
    public PageReference cancel() {
        PageReference pageRef = new PageReference('/'+accountId);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    /**
    *	@description - This method is used to set selectd memeber user id and to give call to deleteAllTeamMembers() method.
    * 	@param - String accountId - current account Id , String selectedMemberId - selected member user id
    */
    public void deleteMembers(String accountId, String selectedMemberId) {
        accountId = accountId;
        selectedMemberId = selectedMemberId;
        removeMembersFromOpt = false;
        deleteAllTeamMembers();
    }
}