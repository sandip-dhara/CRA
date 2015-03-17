/**********************************************************
* Class Name: DealRegOpptyBeforeInsertManagedByFieldTest
* Author: HP
* Date: 05-OCT-2012 
* Description: This class does the test coverage for the trigger "Oppty_InsertManagedByField". 
***********************************************************/

@isTest(SeeAllData=true)
private class DealRegOpptyBeforeInsertManagedByTest{
    /*
     * @Description: Test Method to test the trigger "Oppty_InsertManagedByField"
     * 
     */      
    
     public static testMethod void Oppty_InsertManagedByFieldTest(){
      //Inserting account
            Account acc=new Account();
            acc.name='TestAcc';
            Id recordId=RecordTypeIdHelper.getRecordTypeId('Account','Customer');
            acc.recordtypeId=recordId;
            insert acc;                                  
            User partnerUser= [select id,isActive from user where isPortalEnabled = true and isActive=true limit 1];
            System.RunAs(partnerUser){
                   Opportunity oppty=new Opportunity();
                   oppty.name='TestOppty';
                   oppty.AccountId=acc.id;
                   oppty.closedate=date.today();
                   oppty.StageName='01 - Understand Customer';
                   Id recordId1=RecordTypeIdHelper.getRecordTypeId('Opportunity','Standard');
                    oppty.recordtypeId=recordId1;
                   try{
                       insert oppty;
                   }catch(DmlException e){
                          System.debug('Dml Exception has been catched.......');
                    }
             }
            
          Opportunity oppty1=new Opportunity (Name='TestOppty',AccountId=acc.id,closedate=date.today(),StageName='01 - Understand Customer',Managed_By__c='Partner');
          Insert oppty1;
      }
}