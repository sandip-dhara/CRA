/**********************************************************
* Class Name: AddDefaultTeamController
* Author: Accenture
* Date: 10-APR-2012 
* Requirement # Request Id :
* Description: Controller to add logged in user's default account team members and default sales team to oppportunity.
***********************************************************/
public class AddDefaultTeamController {
    
    /**
    * @description - Add Default Team to account for which logged in user is the owner.
    * @parameter: Id accountId - Selected account id
    * @returns- String - Error message to be shown on UI if any
    */
    public String addDefaultTeamforAM(Id accountId) {   
        String errorMessage = '';   
        Account account = new Account();
        List<UserAccountTeamMember> userAccountTeamMembers = new List<UserAccountTeamMember>();
        List<AccountTeamMember> accountTeamMembers = new List<AccountTeamMember>();
        List<AccountShare> accountShareOfMembers = new List<AccountShare>(); 
        if (accountId != null) {
            account = [Select Id, OwnerId
                        From Account
                        Where Id = :accountId]; 
        }
        if (UserInfo.getUserId() == account.OwnerId) {
            userAccountTeamMembers = [Select UserId, TeamMemberRole, OwnerId, OpportunityAccessLevel, 
                                            Id, CaseAccessLevel, AccountAccessLevel 
                                         From UserAccountTeamMember
                                         Where OwnerId = :UserInfo.getUserId()]; 
        
            if (userAccountTeamMembers.isEmpty()) {
                errorMessage = Label.Default_Account_Team;  
            }
            /*Set<String> accountTeamMembersIds = new Set<String>();
            
            for(AccountTeamMember teamMember :accountTeamMembers) {
                accountTeamMembersIds.add(teamMember.UserId);   
            }*/
            
            Map<String, UserAccountTeamMember> userAccessByUserId = new Map<String, UserAccountTeamMember>();
            Set<String> membersId = new Set<String>(); 
            for (UserAccountTeamMember teamMember : userAccountTeamMembers) {
                userAccessByUserId.put(teamMember.UserId, teamMember);
                AccountTeamMember accountTeamMember = new AccountTeamMember();
                accountTeamMember.UserId = teamMember.UserId;
                accountTeamMember.AccountId = accountId;
                accountTeamMember.TeamMemberRole = teamMember.TeamMemberRole;
                accountTeamMembers.add(accountTeamMember);
                membersId.add(teamMember.UserId);
            }
            try {
                upsert accountTeamMembers;
            } 
            catch (DMLException e) {
            	CreateApexErrorLog.insertHandledExceptions(e, null, 'AccountTeamMember', 'AddDefaultTeamController', 'Class');
            }
            List<AccountShare> accountShares = new List<AccountShare>();
            
            for (AccountShare accountShare : [Select UserOrGroupId, OpportunityAccessLevel, 
                                                        CaseAccessLevel, AccountId, RowCause,  
                                                        AccountAccessLevel 
                                                From AccountShare
                                                Where AccountId =:accountId
                                                And UserOrGroupId IN : membersId] ) {
                
                UserAccountTeamMember member = userAccessByUserId.get(accountShare.UserOrGroupId);
                if (member != null){
                    accountShare.AccountAccessLevel = member.accountAccessLevel;
                    //accountShare.ContactAccessLevel = member.contactAccessLevel;
                    accountShare.OpportunityAccessLevel = member.opportunityAccessLevel;
                    accountShare.CaseAccessLevel = member.caseAccessLevel;
                    accountShares.add(accountShare);
                }
            }
            if (accountShares.size() > 0){
                try {
                	update accountShares;
                } 
                catch(DMLEXception e){
                	CreateApexErrorLog.insertHandledExceptions(e, null, 'AccountShare', 'AddDefaultTeamController', 'Class');
                }
            } 
        }
        return errorMessage;
    }
    
    /**
    * @description - Add Default Sales Team to Opportunity for which logged in user is the owner.
    * @parameter: Id opportunityId - O pportunity id of the converted lead
    */
    public String addDefaultTeamforSalesTeam(Id opportunityId) {    
        String errorMessage = '';       
        Opportunity opportunity = new Opportunity();
        List<UserTeamMember> userTeamMembers = new List<UserTeamMember>();
        List<OpportunityTeamMember> optyTeamMembers = new List<OpportunityTeamMember>();
        List<OpportunityShare> optyShareOfMembers = new List<OpportunityShare>(); 
        if (opportunityId != null) {
            opportunity = [Select Id, OwnerId
                            From Opportunity
                            Where Id = :opportunityId]; 
        }
        if (UserInfo.getUserId() == opportunity.OwnerId) {
            userTeamMembers = [Select UserId, TeamMemberRole, OwnerId, OpportunityAccessLevel, Id 
                                         From UserTeamMember
                                         Where OwnerId = :UserInfo.getUserId()]; 
        
            if (userTeamMembers.isEmpty()) { 
                errorMessage = Label.Default_Sales_Team;
            }
            Set<String> optyTeamMembersIds = new Set<String>();
            
            for(OpportunityTeamMember teamMember :optyTeamMembers) {
                optyTeamMembersIds.add(teamMember.UserId);  
            }
            
            Map<String, UserTeamMember> userAccessByUserId = new Map<String, UserTeamMember>();
            Set<String> membersId = new Set<String>(); 
            for (UserTeamMember teamMember : userTeamMembers) {
                userAccessByUserId.put(teamMember.UserId, teamMember);
                OpportunityTeamMember optyTeamMember = new OpportunityTeamMember();
                optyTeamMember.UserId = teamMember.UserId;
                optyTeamMember.OpportunityId = opportunityId;
                optyTeamMember.TeamMemberRole = teamMember.TeamMemberRole;
                optyTeamMembers.add(optyTeamMember);
                membersId.add(teamMember.UserId);
            }
            try {
                upsert optyTeamMembers;
            } 
            catch (DMLException e) {
            	CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityTeamMember', 'AddDefaultTeamController', 'Class');
            }
            
            List<OpportunityShare> optyShares = new List<OpportunityShare>();
            
            for (OpportunityShare optyShare : [Select Id, UserOrGroupId, OpportunityId, OpportunityAccessLevel, RowCause 
                                                From OpportunityShare
                                                Where OpportunityId =:opportunityId
                                                And UserOrGroupId IN : membersId
                                                AND rowCause = 'Team'] ) {
                
                UserTeamMember member = userAccessByUserId.get(optyShare.UserOrGroupId);
               
                if (member != null){
                    optyShare.OpportunityAccessLevel = member.OpportunityAccessLevel;
                    optyShares.add(optyShare);
                }
            }
            if (optyShares.size() > 0){
                try {
                    update optyShares;
                } 
                catch(DMLException e){
                	CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityShare', 'AddDefaultTeamController', 'Class');
                }
            } 
        }
        return errorMessage;
    }    
}