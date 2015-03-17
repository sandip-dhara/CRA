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

// TM: Nasir:Test method for "TMAllianceChannedPartnerTerritoryBatch": Start

@isTest(SeeAllData=true)
private class TMAllianceChannedPartnerTerrBatchTest {

   static testMethod void TMAllianceChannedPartnerTerritoryBatch() {
        test.startTest();
        TMEngineAccountRecordType__c lastRun = TMEngineAccountRecordType__c.getValues('Allianc/ChanPartTimeStamp');
        lastRun.AccountRecordType__c='2013-01-21 12:14:05';
        update lastRun ;
        
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc1 = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc1;
        Account acc2 = new Account(Name='PrevLocTestAcc2',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='112',MDCP_Organization_ID__c='112',Channel_Partner_Flag__c=true);
        insert acc2;
        Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc1.id);
        insert loc1;
        Location__c loc2 = new Location__c(Name='1600',Location_Name__c='Mys',Account__c = acc2.id,Country__c='India');
        insert loc2;
        Sales_Territory__c salesTerr1 = new Sales_Territory__c (Name='TestPreview1',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true,MyComp_Sales_Territory_Name__c = 'ST-TestTerrACP');
        insert salesTerr1;
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=loc1.id,Sales_Territory__c=salesTerr1.id);
        insert stla;
        Sales_Territory_Location_Assignment__c stla1= new Sales_Territory_Location_Assignment__c(Location__c=loc2.id,Sales_Territory__c=salesTerr1.id);
        insert stla1; 
        
        Account accCust = TestingSetupDataUtil.createAccount('custAcc', 'custAcc@custTest.com', 'Customer');
        Insert accCust;
        
        opportunity opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(accCust.id),'opptyTest', system.today()+ 30);
        insert opptyTest;  

        
        Channel_Partner__c chhPart = new Channel_Partner__c();
        chhPart.Channel_Partner__c = acc1.Id;
        chhPart.Opportunity__c = opptyTest.Id;
        chhPart.Location__c=loc1.Id;
        insert chhPart;     
        
        List<Sales_Territory_Location_Assignment__c> lstla= new List<Sales_Territory_Location_Assignment__c>();
        lstla.add(stla1);
        lstla.add(stla);
        
        delete stla;
        
        system.debug('in first method>>>> stla.isdeleted'+ stla.IsDeleted);
        
         if(stla1!=null && lastRun.AccountRecordType__c!=null){
            Datetime newTimeStamp = datetime.now();
            lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
            update lastRun;
        }
        
/*        set<id> deletedId= new set<id>();
        if(stla.IsDeleted==true){       
            deletedId.add(stla.Location__c);
        }    
*/         
        /*Database.BatchableContext ctx;
        TMAllianceChannedPartnerTerritoryBatch tm= new TMAllianceChannedPartnerTerritoryBatch();
        
        tm.start(ctx);
        tm.execute(ctx,lstla);
       
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Alliance and Channel Partner').Batch_Size__c);
        
        Id batchId = Database.executeBatch(new TMAllianceChannedPartnerTerritoryBatch(), batchSize);*/
        
        TMAllianceChanlPrtnrTerrSchedular tm= new TMAllianceChanlPrtnrTerrSchedular();
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute()),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM Allaince Partner'+datetime.now(), schExp, tm);
        
        test.stopTest();
    }
    static testMethod void TMAllianceChannedPartnerTerritoryBatch1() {
        test.startTest();
        TMEngineAccountRecordType__c lastRun = TMEngineAccountRecordType__c.getValues('Allianc/ChanPartTimeStamp');
        lastRun.AccountRecordType__c='';
        update lastRun ;
        
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        Account acc1 = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert acc1;
        Account acc2 = new Account(Name='PrevLocTestAcc2',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='112',MDCP_Organization_ID__c='112',Channel_Partner_Flag__c=true);
        insert acc2;
        Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = acc1.id);
        insert loc1;
        Location__c loc2 = new Location__c(Name='1600',Location_Name__c='Mys',Account__c = acc2.id,Country__c='India');
        insert loc2;
        Sales_Territory__c salesTerr1 = new Sales_Territory__c (Name='TestPreview1',Account_Access__c='Edit',Case_Access__c='Edit',Opportunity_Access__c='Edit',IsConfidential__c=False,IsPartner__c=true,IsExternal__c = False,MyComp_Sales_Territory_Name__c = 'ST-TestTerrACP1');
        insert salesTerr1;
        Sales_Territory_Location_Assignment__c stla= new Sales_Territory_Location_Assignment__c(Location__c=loc1.id,Sales_Territory__c=salesTerr1.id);
        insert stla;
        Sales_Territory_Location_Assignment__c stla1= new Sales_Territory_Location_Assignment__c(Location__c=loc2.id,Sales_Territory__c=salesTerr1.id);
        insert stla1; 
        
        Account accCust = TestingSetupDataUtil.createAccount('custAcc', 'custAcc@custTest.com', 'Customer');
        Insert accCust;
        
        opportunity opptyTest = TestingSetupDataUtil.createOpportunity(string.valueOf(accCust.id),'opptyTest', system.today()+ 30);
        insert opptyTest;  

        
        Channel_Partner__c chhPart = new Channel_Partner__c();
        chhPart.Channel_Partner__c = acc1.Id;
        chhPart.Opportunity__c = opptyTest.Id;
        chhPart.Location__c=loc1.Id;
        insert chhPart;
        
        
        List<Sales_Territory_Location_Assignment__c > lstla= new List<Sales_Territory_Location_Assignment__c >();
        lstla.add(stla1);
        lstla.add(stla);
        delete stla; 
        
        
        system.debug('stla.isdeleted>>>'+stla.isdeleted);
        
        if( lastRun.AccountRecordType__c==null){
            Datetime newTimeStamp = datetime.now();
            lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
            update lastRun;
        }
/*        set<id> deletedId= new set<id>();
        if(stla.IsDeleted==true){
            deletedId.add(stla.Location__c);
        } 
*/             
        Database.BatchableContext ctx;
        TMAllianceChannedPartnerTerritoryBatch tm= new TMAllianceChannedPartnerTerritoryBatch();
        
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Alliance and Channel Partner').Batch_Size__c);
        
        
        Id batchId = Database.executeBatch(new TMAllianceChannedPartnerTerritoryBatch(), batchSize);
        test.stopTest();
    }
    
    static testMethod void UpdateOpportunitySharingTriggerUtilTest(){
        user testUser1 = new User(Profileid=userInfo.getProfileId(),Username='OpptyOwner12345@gmail.com',
                                 LastName='OpOw1',email='OpptyOwner124test1234@hp.com' ,Alias='OptyO1', 
                                 CommunityNickname='testO1',emailencodingkey='UTF-8', 
                                 languagelocalekey='en_US', localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 Partner_Collaboration_Participating_User__c=true, Email_Address__c='Opptygemail1234@gmail.com',EmployeeNumber='',
                                 Legacy_Employee_Ref__c='09876510',Adoption_Role_Type__c = 'Account Executive');
     insert testUser1;
    
     user testUser2 = new User(Profileid=userInfo.getProfileId(),Username='OpptyOwner123457@gmail.com',
                                 LastName='OpOw2',email='OpptyOwner124test12345@hp.com' ,Alias='OptyO2', 
                                 CommunityNickname='testO2',emailencodingkey='UTF-8', 
                                 languagelocalekey='en_US', localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 Partner_Collaboration_Participating_User__c=true, Email_Address__c='Opptygemail1235@gmail.com',EmployeeNumber='',
                                 Legacy_Employee_Ref__c='09876511',Adoption_Role_Type__c = 'Account Executive');
    insert testUser2;
    
    Account acc = TestingSetupDataUtil.createAccount('testAccount11','accountEmail11@test.com','Customer');
    insert acc;
    
    opportunity newOpp1 = new opportunity();
            newOpp1.name= 'test Oppty12';
            newOpp1.Accountid= acc.id;
            date closeDate = system.today();
            newOpp1.closeDate = closeDate.addDays(30);
            newOpp1.stagename='01 - Understand Customer';
            newOpp1.ownerId=testUser1.id;
            newOpp1.Managed_By__c='HP';
            insert newOpp1;
            Map<Id,Opportunity> oldOptyMap = new Map<Id,Opportunity>();
            oldOptyMap.put(newOpp1.Id,newOpp1);
            newOpp1.ownerId=testUser2.id;
            update newOpp1;
            Map<Id,Opportunity> newOptyMap = new Map<Id,Opportunity>();
            newOptyMap.put(newOpp1.Id,newOpp1);
    UpdateOpportunitySharingTriggerUtil.UpdateOpportunitySharing(newOptyMap,oldOptyMap);
    }
    
}