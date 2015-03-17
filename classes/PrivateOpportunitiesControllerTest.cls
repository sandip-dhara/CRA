@isTest(SeeAllData=true)
private class PrivateOpportunitiesControllerTest{

    public static testmethod void testMethod1(){
    //Create a test account
        Account acc =TestingSetupDataUtil.createAccount('Master Private Account','accountEmail@hp.com','Customer');
        acc.ShippingCountry ='India';
        insert acc;
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        User userTest =TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@ca.com',randomstr,Userinfo.getProfileId());
        userTest.Business_Group__c = 'PSG';
        userTest.Global_Business_Unit__c = 'BI';
        insert userTest ;
        
        profile pf=[select id,name from Profile where name like '%Admin%' limit 1];
        User userTest1 =TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest1@hp.com',randomstr+'userTest1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest1@ca.com','56545236',Userinfo.getProfileId());
        userTest1.Business_Group__c = 'PSG';
        userTest1.Global_Business_Unit__c = 'BI';
        insert userTest1 ;
        
        Opportunity newOpp1 = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp3', system.today()+ 30);
         newOpp1.OwnerId = usertest1.id;
         newOpp1.Owner__c = usertest1.id;
         newOpp1.stagename='02 - Validate Opportunity';
       
         insert newOpp1;
         
         Opportunity newOpp2 = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp4', system.today()+ 30);
         newOpp2.OwnerId = usertest1.id;
         newOpp2.Owner__c = usertest1.id;
         newOpp2.stagename='02 - Validate Opportunity';
         newOpp2.Account_Private_Opportunity__c=acc.id;
         insert newOpp2;
         Test.startTest();
              PrivateOpportunitiesController poc=new  PrivateOpportunitiesController();
              PrivateOpportunitiesController.createPrivateOppty((String)newopp1.id);
              PrivateOpportunitiesController.createPublicOppty((String)newopp1.id);
              PrivateOpportunitiesController.createPrivateOppty((String)newopp2.id);
         Test.stopTest();
      }   
}