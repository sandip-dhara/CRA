/**********************************************************
* Class Name: DealReg_ProdDetailsForDealApprEmailTest
* Author: HP
* Date: 15-OCT-2012 
* Description:This class contains the test code coverage for the class "ProductDetailsForDealApprovalEmail"
***********************************************************/
@isTest(seeAllData = true)
Private class DealReg_ProdDetailsForDealApprEmailTest{ 
static testMethod void testDealReg_ProdDetailsForDealApprEmail(){

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
    newDeal.Status__c='Rejected';
    newDeal.Rejection_Reason__c='11 - Registration is closed';
    Update newDeal;
    
    //Test Product Registration Insertion              
    Product_Registration__c newProdReg=DealTestDataUtil.createProductRegistration(newDeal.Id,'Technology Support PL',newOppty.Id);
    Insert newProdReg;   
    
    Deal_Registration__c newDeal1=DealTestDataUtil.createDealRegistration('Test Deal Registration11',newCamp.Id,newOppty.Id,newAcc.Id);
    Insert newDeal1;
       
    Product_Registration__c newProdReg1=DealTestDataUtil.createProductRegistration(newDeal1.Id,'Technology Support PL',newOppty.Id);
    Insert newProdReg1;
    newProdReg1.Status__c='';
    Update newProdReg1;
    
    Product_Registration__c newProdReg2=DealTestDataUtil.createProductRegistration(newDeal1.Id,'',newOppty.Id);
    Insert newProdReg2;
    newProdReg2.Status__c='';
    Update newProdReg2;        
   
    test.startTest();
        DealReg_ProdDetailsForDealApprEmail prodDetail=new DealReg_ProdDetailsForDealApprEmail();
        prodDetail.getDealOpptyID();
        prodDetail.setDealOpptyID(newOppty.Id);
        prodDetail.DealReg_ProdDetailsForDealApprEmail();
    test.stopTest();
 }
 }