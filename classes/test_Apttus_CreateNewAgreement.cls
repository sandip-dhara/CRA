@isTest
public with sharing class test_Apttus_CreateNewAgreement {
    private static Account acc;
    private static Opportunity opp;
    private static Support_Request__c supReq;
    private static Apttus__APTS_Agreement__c agmt1;
    private static Apttus__APTS_Agreement__c agmt2;
    static user userTest;
    
    private static ID record1 = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeId();
    private static ID record2 = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Letter Agreement').getRecordTypeId();
    //private static Profile profile1 = [Select Id,Name from Profile where Name = 'Apttus Legal' LIMIT 1];
    
    /*
    * Method for creating test data.     
    */
    
    private static void setUpData(){ 
       // userTest = TestingSetupDataUtil.createUser('userTest','userTest@hp.com','userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','55235615',profile1.Id);
       // insert userTest ;
        acc = TestingSetupDataUtil.createAccount('AddtoCampaignTestAcc_952PM', 'AddtoCampaign_9@mail.com','Customer'); 
        insert acc;
        
        //agreement request
        agmt1 = new Apttus__APTS_Agreement__c();
        agmt1.RecordTypeId = record1;
        agmt1.Apttus__Account__c = acc.id;
        //insert agmt1;
        //agreement 
        agmt2 = new Apttus__APTS_Agreement__c();
        agmt2.RecordTypeId = record2;
        agmt2.Apttus__Account__c = acc.id;
        //insert agmt2;
    }
    static testmethod void updateAgmtTestMethod(){
        Test.StartTest();
        
            setUpData();
         // system.runas(userTest){
            insert agmt1;
            insert agmt2;
            
            Attachment attachment1 =new Attachment();
        attachment1.Name='Unit Test Attachment1';
        Blob bodyBlob1=Blob.valueOf('Test Agreement Attachment Body 1');
        attachment1.body=bodyBlob1;
        attachment1.parentId=agmt1.id;
        insert attachment1 ;
        
        Attachment attachment2 =new Attachment();
        attachment2.Name='Unit Test Attachment2';
        Blob bodyBlob2=Blob.valueOf('Test Agreement Attachment Body 2');
        attachment2.body=bodyBlob2;
        attachment2.parentId=agmt2.id;
        insert attachment2 ;
            
            agmt1.External_Agreement_Id__c=agmt2.id;
            agmt1.Axiom_Refresh__c = true;
            agmt1.Axiom_Record_Type__c = 'Letter Agreement';
            agmt1.Apttus__Status_Category__c = 'Abandoned';
            agmt1.Apttus__Status__c = 'Abandoned';
            update agmt1;
            
            agmt1.External_Agreement_Id__c=agmt2.id;
            agmt1.Axiom_Refresh__c = true;
            agmt1.Axiom_Record_Type__c = 'Letter Agreement';
            agmt1.Apttus__Status_Category__c = 'Completed';
            agmt1.Apttus__Status__c = 'Completed';
            update agmt1;
            
            agmt1.External_Agreement_Id__c=agmt2.id;
            agmt1.Axiom_Refresh__c = true;
            agmt1.Axiom_Record_Type__c = 'Letter Agreement';
            agmt1.Apttus__Status_Category__c = 'In Signatures';
            agmt1.Apttus__Status__c = 'Fully Signed';
            agmt1.Apttus__Contract_End_Date__c = System.today()+30;
            update agmt1;
            
            agmt2.External_Agreement_Id__c=agmt1.id;
            agmt2.Axiom_Refresh__c = true;
            agmt2.Axiom_Record_Type__c = 'Letter Agreement';
            agmt2.Apttus__Status_Category__c = 'Abandoned';
            agmt2.Apttus__Status__c = 'Abandoned';
            update agmt2;
            
            agmt2.External_Agreement_Id__c=agmt1.id;
            agmt2.Axiom_Refresh__c = true;
            agmt2.Axiom_Record_Type__c = 'Letter Agreement';
            agmt2.Apttus__Status_Category__c = 'Completed';
            agmt2.Apttus__Status__c = 'Completed';
            update agmt2;
            
            agmt2.External_Agreement_Id__c=agmt1.id;
            agmt2.Axiom_Refresh__c = true;
            agmt2.Axiom_Record_Type__c = 'Letter Agreement';
            agmt2.Apttus__Status_Category__c = 'In Signatures';
            agmt2.Apttus__Status__c = 'Fully Signed';
            agmt2.Apttus__Contract_End_Date__c = System.today()+30;
            update agmt2;
         // }
        Test.StopTest();
    }
    
}