/**********************************************************
* Class Name: AccountTeamListControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage for AccountTeamListController class. 
***********************************************************/
@isTest
private class AccountTeamListControllerTest {
    
    static PageReference pref;
    static AccountTeamListController accountTeamListController;
    static Account account;
    static String errorMessage;
    static Opportunity newOpp;
    static OpportunityTeamMember oppMem;
    static AccountTeamMember accMem, accMem1,accMem2,accMem3,accMem4,accMem5,accMem6 ;
    static Boolean flagValue;
    static PageReference pageRef;
    static User internalUser;
    
    /**
    * @description: Setting Test Data
    */
    private static void setupData() {
                
        /* Account */ 
        account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
        System.assertEquals(account.Name,'testAccount1');
        /* Opportunity */
        newOpp = TestingSetupDataUtil.createOpportunity(account.id,'testOppty', system.today()+ 30);
        insert newOpp;
        System.assertEquals(newOpp.Name,'testOppty');
        /* Opportunity Team Member */
        oppMem = TestingSetupDataUtil.createOpportunityTeamMember(Userinfo.getUserId() , 'Sales Rep',newOpp.Id );
        insert oppMem;
        System.assertEquals(oppMem.OpportunityId,newOpp.Id );
        /* User */
        internalUser = TestingSetupDataUtil.createUser('sabaTest','abc@hp.com','5_1_PMabc@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','55235615',Userinfo.getProfileId());
        insert internalUser;
        System.assertEquals(internalUser.alias, 'sabaTest');
        /* Account Team Member */
        List<AccountTeamMember> listAccTeamMembers = new List<AccountTeamMember>();
        accMem  = TestingSetupDataUtil.createAccTeamMembers( internalUser.Id, 'Sales Rep',account.Id);
        accMem1 = TestingSetupDataUtil.createAccTeamMembers(Userinfo.getUserId(),'Sales Manager',account.Id);
        accMem2 = TestingSetupDataUtil.createAccTeamMembers(Userinfo.getUserId(),'Cross-BG',account.Id);
        accMem3 = TestingSetupDataUtil.createAccTeamMembers(Userinfo.getUserId(),'Executive Sponsor',account.Id);
        accMem4 = TestingSetupDataUtil.createAccTeamMembers(Userinfo.getUserId(),'Account Manager',account.Id);
        accMem5 = TestingSetupDataUtil.createAccTeamMembers(internalUser.Id,null,account.Id);
        accMem6 = TestingSetupDataUtil.createAccTeamMembers(internalUser.Id,'Account Manager',account.Id);
        
        listAccTeamMembers.add(accMem);
        listAccTeamMembers.add(accMem1);
        listAccTeamMembers.add(accMem2);
        listAccTeamMembers.add(accMem3);
        listAccTeamMembers.add(accMem4);
        listAccTeamMembers.add(accMem5);
        listAccTeamMembers.add(accMem6);
        System.debug('--listAccTeamMembers--'+listAccTeamMembers);
        insert listAccTeamMembers;
        System.assertEquals(listAccTeamMembers.size(), 7);
    }
    
    static testMethod void accountTeamListPositiveTest() {
        /* Initializing test data */
        setupData();
        
        test.startTest();
        /* Testing Constructor */
        ApexPages.StandardController stdController = new ApexPages.StandardController(account);
        accountTeamListController = new AccountTeamListController(stdController);
        /* Testing  AccountTeamMembersListEmpty flag */
        flagValue = accountTeamListController.getIsAccountTeamMembersListEmpty();
        System.assertNotEquals(null, flagValue);
        /* Testing  addDefaultTeam method */
        pageRef = accountTeamListController.addDefaultTeam();
        System.assertEquals(null, pageRef);
        /* Testing  deleteMembers method */
        accountTeamListController.deleteMembers();
        accountTeamListController.selectedMemberId = accMem.Id;
        accountTeamListController.deleteMembers();
        /* Testing SortDirection */
        accountTeamListController.setSortDirection('ASC');
        String direction = accountTeamListController.getSortDirection();
        System.assertEquals('ASC', direction);
        /* Testing Business Groups values */
        accountTeamListController.getBusinessGroups();
        accountTeamListController.checkForOpenOptys();
        AddDefaultTeamController addDefaultTeamController = new AddDefaultTeamController();
        addDefaultTeamController.addDefaultTeamforSalesTeam(newOpp.id);
        test.stopTest();
    }
    
    static testMethod void deleteAllAccountTeamControllerTest() {
        /* Initializing test data */
        setupData();
        /* Testing deleteAllTeamMembers */
        test.startTest();
        pageRef = Page.DeleteAllAccountTeam;      
        ApexPages.currentPage().getParameters().put('id',account.Id);
        //Test.setCurrentPageReference(pageRef);
        DeleteAllAccountTeamController deleteAllAccountTeamController = new DeleteAllAccountTeamController();
        deleteAllAccountTeamController.removeMembersFromOpt = false;
        deleteAllAccountTeamController.deleteAllTeamMembers();
                                    
        deleteAllAccountTeamController.removeMembersFromOpt = true;
        deleteAllAccountTeamController.deleteAllTeamMembers();
        deleteAllAccountTeamController.cancel();
        test.stopTest();
    }
    
    static testMethod void editAccountTeamMemberTest() {
        /* Initializing test data */
        setupData();
        /* Testing deleteAllTeamMembers */
        test.startTest();    

        PageReference pageRef2 = Page.EditAccountTeamMember;      
        ApexPages.currentPage().getParameters().put('id',account.Id);
        ApexPages.currentPage().getParameters().put('teamMemberId',accMem3.Id);
        EditAccountTeamMember editAccountTeamMember = new EditAccountTeamMember();
        EditAccountTeamMember.getAccessLevelOptions();
        EditAccountTeamMember.getAccountAccessOptions();
        EditAccountTeamMember.save();
        EditAccountTeamMember.cancel();
        test.stopTest();
    }
    static testMethod void newAccountTeamMembersTest() {
        /* Initializing test data */
        setupData();
        /* Testing deleteAllTeamMembers */
        test.startTest();

        PageReference pageRef3 = Page.NewAccountTeamMembers;
        ApexPages.currentPage().getParameters().put('id',account.Id);
        ApexPages.currentPage().getParameters().put('name',account.Name);
        NewAccountTeamMembers newAccountTeamMembers = new NewAccountTeamMembers();
        newAccountTeamMembers.getUserTypeOptions();
        newAccountTeamMembers.newAccountTeamMembers=new List<NewAccountTeamMembers.accountTeamMembers>{new newAccountTeamMembers.accountTeamMembers(TestingSetupDataUtil.createAccTeamMembers( internalUser.Id, 'Sales Rep',account.Id))        
        };
        newAccountTeamMembers.getAccessLevelOptions();
        newAccountTeamMembers.getAccountAccessOptions();
        newAccountTeamMembers.save();
        newAccountTeamMembers.saveAndMore();
        newAccountTeamMembers.cancel();
        test.stopTest();
        
    }
}