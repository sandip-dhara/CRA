/**********************************************************
* Class Name: OpportunitySalesTeamControllerTest
* Author: Accenture
* Date: 5-MAY-2012 
* Description: This class does the test coverage for OpportunitySalesTeamController class. 
***********************************************************/

@isTest(SeeAllData=true)
private class OpportunitySalesTeamControllerTest{
    
    /* define class variables */
    private static OpportunityTeamMember oppMem = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    private static Opportunity newOpp;
    private static Opportunity opp2;
    private static User userTest;
    static String errorMessage;
    
    /* create the data require for the coverage */
    private  static void setupData(){
  
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount','accountEmail@test.com','Customer');
        insert acc;
        
        //Insert Opportunity
        List<Opportunity> listOpportunity = new List<Opportunity>();
        newOpp = TestingSetupDataUtil.createOpportunity(acc.Id,'testOppty', system.today()+ 30);
        newOpp.stagename='02 - Validate Opportunity';
        listOpportunity.add(newOpp);

        opp2 = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp2', system.today()+ 30);
        opp2.stagename='02 - Validate Opportunity';
        listOpportunity.add(opp2);
        insert listOpportunity;
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        
        // Insert User
        userTest = TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','55235615',Userinfo.getProfileId());
        insert userTest ;
        
        // Insert Opportunity Team Members    
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
     
        oppMem = TestingSetupDataUtil.createOpportunityTeamMember(userTest.Id ,'Sales Rep',newOpp.Id);
        //new OpportunityTeamMember(UserId = userTest.Id,TeamMemberRole = 'Sales Rep', OpportunityId = newOpp.Id);
        listOpportunityTeamMember.add(oppMem);
        oppMem1 = TestingSetupDataUtil.createOpportunityTeamMember(userTest.Id ,'',opp2.Id);
        //new OpportunityTeamMember(UserId = userTest.Id, TeamMemberRole = '', OpportunityId = opp2.Id);
        listOpportunityTeamMember.add(oppMem1);
        insert listOpportunityTeamMember;
     
     }
    
     
     private static testMethod void constructorTest(){
        Test.startTest(); 
        setupData();
        ApexPages.Standardcontroller stdcontroller = new ApexPages.StandardController(oppMem); 
        OpportunitySalesTeamController oppSTC = new OpportunitySalesTeamController(stdcontroller);
        OpportunitySalesTeamController opportunitySalesTeamController = new OpportunitySalesTeamController();

        opportunitySalesTeamController.SelectedOpportunityAccessLevel = oppMem.OpportunityAccessLevel;
        
        PageReference pref1 = Page.AddOpportunitySalesTeam;
        pref1.getParameters().put('optyid',newOpp.id);
        pref1.getParameters().put('retURL','/'+newOpp.id);
        pref1.getParameters().put('teamMemberID', oppMem.Id);
        Test.setCurrentPage(pref1);
        opportunitySalesTeamController = new OpportunitySalesTeamController();
        for(Integer i=0;i<1;i++){
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.TeamMemberRole = 'Sales Rep';
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.OpportunityId = newOpp.Id;      
            opportunitySalesTeamController.opportunityTeamMemberList[0].SelectedOpportunityAccessLevel = 'Read';
        } 
        
        opportunitySalesTeamController.getOpportunityAccessLevel();
        opportunitySalesTeamController.Save();
        
        
        PageReference pref2 = Page.OpportunityTeamMemberEdit;
        pref2.getParameters().put('optyid',newOpp.id);
        pref2.getParameters().put('retURL','/'+newOpp.id);
        Test.setCurrentPage(pref2);
        
        PageReference pref3 = Page.OpportunityTeamMemberDelete;
        pref3.getParameters().put('optyid',newOpp.id);
        pref3.getParameters().put('retURL','/'+newOpp.id);
        Test.setCurrentPage(pref3);
                                                                                                      
        opportunitySalesTeamController.Save_New();        
        opportunitySalesTeamController.cancel();
        oppSTC.SaveTeamEdit();
        opportunitySalesTeamController.deleteTeamMember();
        
        
        
        
        
        ApexPages.Standardcontroller catchstdcontroller = new ApexPages.StandardController(oppMem1); 
        OpportunitySalesTeamController catchoppSTC = new OpportunitySalesTeamController(catchstdcontroller);
        OpportunitySalesTeamController catchopportunitySalesTeamController = new OpportunitySalesTeamController();

        catchopportunitySalesTeamController.SelectedOpportunityAccessLevel = '';
        
        delete oppmem1;
        
        
        PageReference cpref1 = Page.AddOpportunitySalesTeam;
        cpref1.getParameters().put('optyid',opp2.id);
        cpref1.getParameters().put('retURL','/'+opp2.id);
        cpref1.getParameters().put('', null);
        Test.setCurrentPage(cpref1);
        opportunitySalesTeamController = new OpportunitySalesTeamController();
        for(Integer i=0;i<1;i++){
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.TeamMemberRole = '';
            opportunitySalesTeamController.opportunityTeamMemberList[0].teamMember.OpportunityId = null;      
            opportunitySalesTeamController.opportunityTeamMemberList[0].SelectedOpportunityAccessLevel = 'Read only';
        } 
        
        opportunitySalesTeamController.getOpportunityAccessLevel();
        opportunitySalesTeamController.Save();
        
        
        PageReference cpref2 = Page.OpportunityTeamMemberEdit;
        cpref2.getParameters().put('optyid',opp2.id);
        cpref2.getParameters().put('retURL','/'+opp2.id);
        Test.setCurrentPage(cpref2);
        
        PageReference cpref3 = Page.OpportunityTeamMemberDelete;
        cpref3.getParameters().put('optyid',opp2.id);
        cpref3.getParameters().put('retURL','/'+opp2.id);
        Test.setCurrentPage(cpref3);
         
        try{         
        opportunitySalesTeamController.Save_New();        
        opportunitySalesTeamController.cancel();
        catchoppSTC.SaveTeamEdit();
    
        opportunitySalesTeamController.deleteTeamMember();
        }catch(Exception ex) { 
       errorMessage = ex.getMessage();
     }
     /* If errorMessage is not null, then test method will PASS */
     System.assertNotEquals('', errorMessage);
         
        Test.stopTest();
     }
}