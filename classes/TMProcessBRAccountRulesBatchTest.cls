/**********************************************************
* Class Name: TMProcessBRAccountRulesBatchTest 
* Author: HP
* Date: 20-Aug-2013
* Description: This class does the test coverage
*              for TMProcessAccountRulesBatch class. 
***********************************************************/
@isTest(seeAllData=true)
private class TMProcessBRAccountRulesBatchTest {

    static testMethod void AccountRulesBatchTest() {
           
    
        test.startTest();
        /*World Region insert*/
        World_Region__c wrSReg1 = new World_Region__c(Name = 'North America', ParentName__c = 'Americas');
        insert wrSReg1;
        World_Region__c wrSReg2 = new World_Region__c(Name = 'United States Extended', ParentName__c = 'North America', ParentId__c = wrSReg1.Id);
        insert wrSReg2;
        World_Region__c wrSReg3 = new World_Region__c(Name = 'US', ParentName__c = 'United States Extended', ParentId__c = wrSReg2.Id, Country_Name__c = 'United States');
        insert wrSReg3;
        
        
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        Robj2.AccountRecordType__c = 'None';
        update Robj2;
        
        TMEngineAccountRecordType__c AccTypeObj = TMEngineAccountRecordType__c.getValues('AccRecTypeVal');
        AccTypeObj.AccountRecordType__c = 'Partner';
        update AccTypeObj;
        
        /* Account inset*/ 
        List<Account> accList = new List<Account>();
        String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
        for(Integer i=0;i<5;i++){
            Account acc  = new Account(Name = 'testAccount'+ i, Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = RecordTypeId,
                                    CurrencyIsoCode='USD',MDCP_Business_Relationship__c='BR' +i,MDCP_Organization_ID__c='MDCP0'+i, EvaluateTerritory__c = true,Alliance_Partner_Flag__c=true);
            accList.add(acc);
        }
        insert accList;
        
        String CusRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        Account cusAcc  = new Account(Name = 'testCusAccount', Account_E_mail__c = 'accountEmail@email.com',RecordTypeId = CusRecordTypeId,
                                    CurrencyIsoCode='USD',Source_System_Account_ID__c = '1234599' );
        insert cusAcc;
        
        String OpptyStdRecordTypeId = RecordTypeIdHelper.getRecordTypeId('Opportunity','Standard');
        
        Date clsDate = date.newinstance(2015,12,1);
        
        Opportunity opty1 = new Opportunity(name='TestOpty1',AccountId=cusAcc.Id,CloseDate = clsDate,StageName='01 - Understand Customer',CurrencyIsoCode='USD');
        insert opty1;
        Opportunity opty2 = new Opportunity(name='TestOpty2',AccountId=cusAcc.Id,CloseDate = clsDate,StageName='01 - Understand Customer',CurrencyIsoCode='USD');
        insert opty2;
        
        
        List<Location__c> locList = new List<Location__c>();
        for(Integer i=0;i<5;i++){
            Location__c loc  = new Location__c(Account__c=accList[i].id, Name = 'testLocation'+ i, Location_Name__c = '12345'+ i, EvaluateTerritory__c = true);
            locList.add(loc) ;
        }
        insert locList;
        
        Channel_Partner__c acp1 = new Channel_Partner__c(Partner_Type__c ='Alliance Partner',Location__c=locList[0].id,Channel_Partner__c=accList[0].id, Opportunity__c =opty1.Id);
        insert acp1;
        Channel_Partner__c acp2 = new Channel_Partner__c(Partner_Type__c ='Alliance Partner',Location__c=locList[0].id,Channel_Partner__c=accList[0].id, Opportunity__c =opty2.Id);
        insert acp2;
        
        
        Group grp = new Group(Name='STerr-505799',Type='Regular');
        insert grp;
        
        Sales_Territory__c sterr = new Sales_Territory__c(Name ='Sterr-test',MyComp_Sales_Territory_Name__c='Sterr-test', Account_Access__c='Read',Case_Access__c='Read',Opportunity_Access__c='Read',
        IsPartner__c = true,GroupID__c = grp.Id);        
        insert sterr;
        
        Sales_Territory_Definition__c std = new Sales_Territory_Definition__c(Sales_Territory__c = sterr.Id,MDCP_ID__c='MDCP00',Business_Relationship__c='BR0');
        insert std;
        
         //TM location Rules Test
         Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Profile batch size').Batch_Size__c);
                
         Id batchId = Database.executeBatch(new TMProcessAccountProfRulesBatch(), batchSize);
        test.stopTest();
    }
}