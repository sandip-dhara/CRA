/**********************************************************
* Class Name: DealReg_UpdateTriggerTestClass
* Author: HP
* Date: 15-OCT-2012 
* Description:This class contains the test code coverage for the Triggers "DealRegDealStatusUpdate" and "DealRegApprovalStatusCheck"
***********************************************************/
@isTest(seeAllData = true)
Private class DealReg_UpdateTriggerTestClass{ 
static testMethod void testDealReg_UpdateTriggerTest(){

    //Test Account Insertion 
    Account newAcc=DealTestDataUtil.createAccount('Test Account11');
    Insert newAcc;
    //newAcc.MDCP_Organization_ID__c='5434653';
    //Update newAcc;

    //Test campaign Insertion         
    Campaign newCamp=DealTestDataUtil.createCampaign('Test Campaign11');
    Insert newCamp;

    //Test opportunity Insertion              
    Opportunity newOppty=DealTestDataUtil.createOpportunity(newAcc.Id,'Test Opty11',Date.today());
    Insert newOppty;
            
 /*
 *@description: The below lines of code does the code coverage for the Trigger "DealRegDealStatusUpdate" 
 */ 

    //Test Deal Registration Insertion              
    Deal_Registration__c newDeal=DealTestDataUtil.createDealRegistration('Test Deal Registration11',newCamp.Id,newOppty.Id,newAcc.Id);
    Insert newDeal;
    newDeal.Status__c='Submitted';
    Update newDeal;
  
    try{
    newDeal.Status__c='Review Initiated';
    Update newDeal;
    }catch(Exception e){}
 
    try{
    newDeal.Status__c='Approved';
    Update newDeal;
    }catch(Exception e){}
    
    newDeal.Status__c='Rejected';
    newDeal.Rejection_Reason__c='11 - Registration is closed';
    Update newDeal;
    
    Deal_Registration__c newDeal1=DealTestDataUtil.createDealRegistration('Test Deal Registration1',newCamp.Id,newOppty.Id,newAcc.Id);
    Insert newDeal1;
    try{
    newDeal1.Status__c='Approved';
    Update newDeal1;
    }catch(Exception e){}   
      
 /*
 *@description: The below lines of code does the code coverage for the Trigger "ProductRegApprovalStatusCheck" 
 */   
   
   try{
    Product_Registration__c newProdReg=DealTestDataUtil.createProductRegistration(newDeal1.Id,'Technology Support PL',newOppty.Id);
    Insert newProdReg;
    newProdReg.Status__c='';
    Update newProdReg;
    }catch(Exception e){}
    
    try{
    newDeal.Rejection_Reason__c='';
    Update newDeal;
    }catch(Exception e){}
    
 }
}