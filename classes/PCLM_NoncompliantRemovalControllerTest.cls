/**********************************************************
* Class Name: PCLM_NoncompliantRemovalControllerTest    
* Author: HP 
* Date: 10-May-2013
* Description: This class contains the test code coverage for the class "LocationTriggerController"
***********************************************************/
@isTest(seeAllData = true)
Private class PCLM_NoncompliantRemovalControllerTest {  
public static testMethod void testProbationRemoval(){
    Recordtype recordId=[Select Id,Name from recordtype where Name='Partner'];
   
    //Test Account Insertion     
    Account newAcc=new Account(Name='Test Account11',ShippingCountry='India',RecordTypeId=recordId.Id,MDCP_Organization_ID__c='2343478',MDCP_Business_Relationship_ID__c='485345786');
    Insert newAcc;
    
    Account newCustAcc=new Account(Name='Test Customer Account',ShippingCountry='India');
    Insert newCustAcc;
    
    
    World_Region__c newWorld=new World_Region__c(Name='Test',Country_Name__c='India');
    Insert newWorld;
    
    World_Region__c newWorld1=new World_Region__c(Name='Test1',Country_Name__c='US');
    Insert newWorld1;
    
    Contact newCon=new Contact(LastName='test',AccountId=newAcc.Id,Email='anh1@hp.com');
    Insert newCon;
    
    Location__c newLoc=new Location__c(Name='33586574',Account__c=newAcc.Id,HP_Lead_Status__c='Non compliant',Country__c='India',Location_Name__c='test1',State__c='Karnataka',World_Region1__c=newWorld.Id,Postal_Code__c='1283983');
    Insert newLoc;  

    newAcc.MDCP_Organization_ID__c='23434785';
    newAcc.MDCP_Business_Relationship_ID__c='4853457869';
    Update newAcc;
    
    newLoc.HP_Lead_Status__c='Inactive';
    newLoc.Country__c='US';
    newLoc.Location_Name__c='test12';
    newLoc.State__c='UP';
    newLoc.World_Region1__c=newWorld1.Id;
    newLoc.Postal_Code__c='12839831';
    Update newLoc;
               
    Location__c newLoc1=new Location__c(Name='33586574',Account__c=newAcc.Id,HP_Lead_Status__c='Inactive');
    Insert newLoc1; 
    try{   
    newLoc1.HP_Lead_Status__c='Non compliant';
    Update newLoc1;
    }catch(exception e){}
    
     //Test opportunity Insertion              
    Opportunity newOppty=new Opportunity(AccountId=newCustAcc.Id,Name='Test Opty111',CloseDate=Date.today(),StageName='01 - Understand Customer');
    Insert newOppty;
    
    Test.startTest();
    PCLM_FutureInsertACP.insertACP(newAcc.Id,newOppty.Id,newLoc.Id);
        PCLM_NoncompliantRemovalController x = new PCLM_NoncompliantRemovalController();

    Test.stopTest();
    
    }

}