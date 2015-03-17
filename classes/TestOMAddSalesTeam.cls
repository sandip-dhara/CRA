/**********************************************************
    * Class Name: TestOMAddSalesTeam
    * Author: Chintapalli Sudhakara Reddy
    * Capability:OM Enhancements 
    * Description: This Test class has written for checking the test coverage for the class OMAddSalesTeam
    ***********************************************************/




@isTest(seeAllData=true)
private class TestOMAddSalesTeam{

   
     static testMethod void myUnitTest() {
     Test.startTest();
     List<String> idList = new List<String>();
     Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
     insert newAcc;
     opportunity opp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
     opp.stageName=  '01 - Understand Customer';
     insert opp;
   
      User testUser= new User();
      testUser= TestingSetupDataUtil.createUser('stTest4','abc@hp.com','email13@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
      testUser.Business_Group__c='ES';
      insert testuser;
      
      Product_Specialty__c ps=new Product_Specialty__c();
      ps.name='TestSpecaility';
      insert ps;
      
     Product_Specialty_User_Assignment__c psua=new Product_Specialty_User_Assignment__c();
     psua.User__c=testuser.id;
     psua.Product_Specialty__c=ps.id;
     insert psua;
     
     Product_Specialty_Oppty_Assignment__c psobj = new Product_Specialty_Oppty_Assignment__c();     
     psobj.Opportunity__c=opp.id;
     psobj.Product_Specialty_User_Assignment__c=psua.id;
     insert psobj;
     idList.add(psobj.id);
     
        OMAddSalesTeam.Som(idList,opp.id); 
        //SystemSystem.assertEquals(OMAddSalesTeam.Som(idList,teamobject2.Id) != NULL);
         OMAddSalesTeam.Som(idList,opp.id);
     Test.stopTest();
     }
}