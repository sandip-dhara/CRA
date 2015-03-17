/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class TriggerClassForBGAccountDataTest {
    static testMethod void TestBGAccountdatainsertUpdatepositive() {
        
        Profile p=[Select Id from Profile where Name='IT Administrator'];
        //User u=[Select Id from User where ProfileId =: p.Id  AND isActive =True AND Id != :UserInfo.getUserId() AND Global_Business_Unit__c!='' limit 1];
        RecordType recType=[Select Id from RecordType where Name='Customer' limit 1];
        Account acc=new Account(Name='ABC Servicces Ltd',Source_System_Account_ID__c='ABF23XS',RecordTypeId = recType.Id);
        insert acc;
        BG_Account_Data__c bgAccData=new BG_Account_Data__c (BG__c='ES',RAD__c='R1',Account__c=acc.Id);
        BG_Account_Data__c bgAccData1=new BG_Account_Data__c (BG__c='ESSN',Coverage_Segment__c='Seg1',Account__c=acc.Id);
        BG_Account_Data__c bgAccData2=new BG_Account_Data__c (RAD__c='R1',Coverage_Segment__c='Seg1',Named_Account__c='Y',Account__c=acc.Id);
         insert bgAccData;
         insert bgAccData1;
         insert bgAccData2;
         bgAccData.BG__c = 'ESSN ';
         bgAccData.RAD__c = 'R0 ';
         update bgAccData;
         delete bgAccData; 
         Contact contact=new Contact(FirstName='Test',LastName='Contact',OwnerId=UserInfo.getUserId(),Phone='222');
         contact.email='test@hp.com';
         insert  contact;
         contact.OwnerId=UserInfo.getUserId();
         
         update contact;
         
         //ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
        //TerritoryDisplayExtensionController = new TerritoryDisplayExtensionController(stdController); 
    }
        
    
     static testMethod void TestBGAccountdatainsertUpdatenegative(){
                RecordType recType=[Select Id from RecordType where Name='Customer' limit 1];
                Account acc=new Account(Name='ABC Servicces Ltd',Source_System_Account_ID__c='ABF23XS',RecordTypeId = recType.Id);
                insert acc;
                BG_Account_Data__c bgAccData=new BG_Account_Data__c (BG__c='ES',RAD__c='R1');
                try{
                    insert bgAccData;
                }
                catch(DmlException e){
                    //Assert Error Message
                    System.assert( e.getMessage().contains('Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [Account__c]: [Account__c]'),e.getMessage());
                    //Assert Field
                    System.assertEquals(BG_Account_Data__c.Account__c, e.getDmlFields(0)[0]);
                    //Assert Status Code 
                    System.assertEquals('REQUIRED_FIELD_MISSING' , e.getDmlStatusCode(0) );
                }
                Contact contact=new Contact(FirstName='Test',OwnerId=UserInfo.getUserId(),Phone='22222');
                try{
                    contact.Email='test@hp.com';
                    insert contact;
                }
                catch(DmlException e){
                    //Assert Error Message
                    System.assert( e.getMessage().contains('Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]'),e.getMessage());
                    //Assert Field
                 //  System.assertEquals(Contact.LastName , e.getDmlFields(0)[0]);
                    //Assert Status Code 
                    System.assertEquals('REQUIRED_FIELD_MISSING' , 
                                         e.getDmlStatusCode(0) );
                }
     }
}