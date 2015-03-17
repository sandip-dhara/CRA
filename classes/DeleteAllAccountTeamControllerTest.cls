/**********************************************************
* Class Name: DeleteAllAccountTeamControllerTest
* Author: Accenture
* Date: 12-APR-2012 
* Description: This class does the test coverage for DeleteAllAccountTeamController class.
***********************************************************/
@isTest
private class DeleteAllAccountTeamControllerTest {
   
    private static testMethod void deleteTeamMembers() {
        
        // Create account record
        List<Account> accounts  = new List<Account>();
        Account account = TestingSetupDataUtil.createAccount('Acccoutn1', 'account1@test.com','Customer');
        Account account2 = TestingSetupDataUtil.createAccount('Acccoutn2', 'account2@test.com','Customer');
        accounts.add(account);
        accounts.add(account2);
        
        //Getting user Profile
        Profile userProfile = [select id,name from Profile where name = 'System Administrator' Limit 1];
        
        //Create user record
        List<User> users = new List<User>();
        User user = TestingSetupDataUtil.createUser('test','testUser@test.com','testUser@test.com','UTF-8','TestName','en_US','en_US','America/Los_Angeles','testUser@testname.com','123',userProfile.id);
        users.add(user);

        //Create Opportunity
        List<Opportunity> opportunities = new List<Opportunity>();
        
        //Create AccountTeamMember record
        List<AccountTeamMember> accTeamMembers = new List<AccountTeamMember>();     
        
        //Create OpportunityTeamMember record
        List<OpportunityTeamMember> oppTeamMembers = new List<OpportunityTeamMember>(); 
        
        //Start test
        Test.startTest();
        try{
            insert accounts;
            insert users;
            
            Opportunity opportunity = TestingSetupDataUtil.createOpportunity(accounts[1].Id,'testOpp',system.today()+10);
            opportunities.add(opportunity);
            insert opportunities;
                        
            //Insert AccountTeamMember record
            
            AccountTeamMember accountTeamMember = TestingSetupDataUtil.createAccTeamMembers(users[0].Id,'testRole',accounts[0].Id);
            accTeamMembers.add(accountTeamMember);
            AccountTeamMember accountTeamMember2 = TestingSetupDataUtil.createAccTeamMembers(users[0].Id,'testRole',accounts[1].Id);
            accTeamMembers.add(accountTeamMember2);
            insert accTeamMembers;
            
            //Insert OpportunityTeamMember record
            OpportunityTeamMember opportunityTeamMember = TestingSetupDataUtil.createOpportunityTeamMember(users[0].Id,'testRole',opportunities[0].Id);
            oppTeamMembers.add(opportunityTeamMember);
            insert oppTeamMembers;
            
        } catch (DMLException e){}
        
        //Covering else part of not null AccountId in deleteAllTeamMembers() method
        DeleteAllAccountTeamController deleteTeamMembers = new DeleteAllAccountTeamController();
        deleteTeamMembers.accountId = accounts[0].Id;
        deleteTeamMembers.selectedMemberId = users[0].Id;
        System.assertEquals(account.id!=null,true);
        deleteTeamMembers.deleteMembers(deleteTeamMembers.accountId,deleteTeamMembers.selectedMemberId);
        
        //Covering part of not null AccountId in deleteAllTeamMembers() method
        DeleteAllAccountTeamController deleteTeamMembers2 = new DeleteAllAccountTeamController(deleteTeamMembers.selectedMemberId); 
        deleteTeamMembers2.accountId = accounts[0].Id;
        deleteTeamMembers2.selectedMemberId = users[0].Id;
        System.currentPageReference().getParameters().put('id',deleteTeamMembers2.accountId);
        System.assertEquals(accountTeamMember.id!=null,true);
        deleteTeamMembers2.deleteMembers(deleteTeamMembers2.accountId,deleteTeamMembers2.selectedMemberId);
        
        deleteTeamMembers2.accountId = accounts[1].Id;
        deleteTeamMembers2.fetchOpportunitiesWithSalesTeam(deleteTeamMembers2.accountId);
        deleteTeamMembers2.cancel();
        deleteTeamMembers2.removeMembersFromOpt = true;
        deleteTeamMembers2.deleteAllTeamMembers();
        
        //Covering part of not null AccountId in deleteAllTeamMembers() method and else part of fetchAccountTeamMembers() method
        DeleteAllAccountTeamController deleteTeamMembers3 = new DeleteAllAccountTeamController();   
        deleteTeamMembers3.accountId = accounts[0].Id;
        deleteTeamMembers3.selectedMemberId = users[0].Id;
        System.currentPageReference().getParameters().put('memberId',deleteTeamMembers3.selectedMemberId);
        deleteTeamMembers3.deleteMembers(deleteTeamMembers3.accountId,deleteTeamMembers3.selectedMemberId);
        
        //Covering part of deleteAllTeamMembers() method after deleting AccountTeamMember records
        DeleteAllAccountTeamController deleteTeamMembers4 = new DeleteAllAccountTeamController(deleteTeamMembers.selectedMemberId); 
        deleteTeamMembers4.accountId = accounts[1].Id;
        System.currentPageReference().getParameters().put('id',deleteTeamMembers4.accountId);
        System.assertEquals(accountTeamMember.id!=null,true);
        deleteTeamMembers4.removeMembersFromOpt = true;
        deleteTeamMembers4.deleteAllTeamMembers();
        
        Test.stopTest();
    }
}