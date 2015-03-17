/**********************************************************
* Class Name: DealReg_DealAutoApproveTest
* Author: HP 
* Date: 16-Oct-2012 
* Description: This class contains the test code coverage for the class "DealReg_DealAutoApprove"
***********************************************************/
@isTest(seeAllData = true)
Private class DealReg_DealAutoApproveTest{ 
static testMethod void testAutoApproval(){
       
    Profile newProfile = [select id from Profile limit 1];
     
    //Test User creation
    User newUser=DealTestDataUtil.createUser('test1','test00@hp.com','test00@hp.com','ISO-8859-1','Test1','en_US','en_US','America/Chicago','testing4567@hp.com','6534867',newProfile.Id);
    Insert newUser;
     
    User testUser =DealTestDataUtil.createUser('test','test01@hp.com','test01@hp.com','ISO-8859-1','Test','en_US','en_US','America/Chicago','testing456@hp.com','6534866',newProfile.Id);
    Insert testUser ;
    testUser.ManagerId =newUser.Id;
    Update testUser ;

    //Test Account Insertion 
    Account newAcc=DealTestDataUtil.createAccount('Test Account111');
    Insert newAcc;
    newAcc.MDCP_Organization_ID__c='63542364';
    Update newAcc;

    //Test campaign Insertion         
    Campaign newCamp=DealTestDataUtil.createCampaign('Test Campaign111');
    Insert newCamp;

    //Test opportunity Insertion              
    Opportunity newOppty=DealTestDataUtil.createOpportunity(newAcc.Id,'Test Opty111',Date.today());
    Insert newOppty;
    
    try{
    //Test Deal Registration Insertion              
    Deal_Registration__c newDeal=DealTestDataUtil.createDealRegistration('Test Deal Registration111',newCamp.Id,newOppty.Id,newAcc.Id);
    Insert newDeal;
    Product_Registration__c newProdReg = DealTestDataUtil.createProductRegistration(newDeal.Id,'Technology Support PL',newOppty.Id);
    newProdReg.Status__c = 'Approved';
    Insert newProdReg;
    system.debug('b1b'+newDeal);
    newDeal.Level_1_Approver_1__c=testUser.id;
    update newDeal;
    system.debug('b1c'+newDeal.Level_1_Approver_1__c);
 
    Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
    request.setObjectId(newDeal.Id);
    Approval.ProcessResult result = Approval.process(request);
    system.debug('b1d'+result);
  
     newDeal.Level_2_Approval_Deadline__c=Date.today(); 
     newDeal.Hidden_Auto_Approve__c=True;
     newDeal.Status__c='Review Initiated';
     update newDeal;
     }catch(exception e){}
     
}
}