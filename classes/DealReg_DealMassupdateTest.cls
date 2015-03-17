/**********************************************************
* Class Name: DealReg_DealMassupdateTest
* Author: HP
* Date: 15-OCT-2012 
* Description:This class contains the test code coverage for the class "DealReg_DealMassupdate"
***********************************************************/
@isTest(seeAllData = true)
Private class DealReg_DealMassupdateTest{
static testMethod void testDealReg_DealMassupdate(){

    Profile newProfile = [select id from Profile limit 1];
    
    User newUser=DealTestDataUtil.createUser('test','test02@hp.com','test02@hp.com','ISO-8859-1','Test','en_US','en_US','America/Chicago','testing4560@hp.com','6534866',newProfile.Id);
    Insert newUser;
    
    //Test Account Insertion 
    Account newAcc=DealTestDataUtil.createAccount('Test Account12');
    Insert newAcc;

    //Test campaign Insertion         
    Campaign newCamp=DealTestDataUtil.createCampaign('Test Campaign12');
    Insert newCamp;

    //Test opportunity Insertion              
    Opportunity newOppty=DealTestDataUtil.createOpportunity(newAcc.Id,'Test Opty12',Date.today());
    Insert newOppty;
    
    //Test Deal Registration Insertion              
    Deal_Registration__c newDeal=DealTestDataUtil.createDealRegistration('Test Deal Registration11',newCamp.Id,newOppty.Id,newAcc.Id);
    Insert newDeal;
    newDeal.Level_1_Approver_1__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_2__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_3__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_4__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_5__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_6__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_7__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_8__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_9__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_10__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_11__c=newUser.Id;
    Update newDeal;
    newDeal.Level_1_Approver_12__c=newUser.Id;
    Update newDeal;
    
    test.startTest();           
        DealReg_DealMassupdate massupdate= new DealReg_DealMassupdate();
        massupdate.getdealRegID();
        massupdate.setdealRegID(newDeal.id);
        massupdate.redirecDealRegPage();
        massupdate.getApproverList();
    test.stopTest();
 
} 
}