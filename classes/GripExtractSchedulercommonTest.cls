/**********************************************************************************
Name:  GripExtractSchedulerAmericasRegionTest
Copyright © 2012  HP
===================================================================================
Purpose:
-------
Test class for GripExtractSchedulerAmericasRegion
===================================================================================
**********************************************************************************/
@IsTest(seealldata=true)
public Class GripExtractSchedulercommonTest{


    public static List<Task> setupdata(String Region){
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User testuser=new User();   
        testuser.FirstName = 'firstName';
        testuser.LastName = 'lastName';
        testuser.Email = 'Test@hp.com';
        testuser.Username = 'userName@hp.com';
        testuser.ProfileId = p.Id;
        testuser.Alias = 'aliasno';
        testuser.CommunityNickname ='nickmame';
        testuser.TimeZoneSidKey='America/Los_Angeles';
        testuser.LocaleSidKey='en_US';
        testuser.EmailEncodingKey='UTF-8';
        testuser.LanguageLocaleKey='en_US';
        testuser.Email_Address__c='Test@hp.com';    
        testuser.EmployeeNumber='0011223344';
        testuser.Legacy_Employee_Ref__c='0011223344';
        testuser.Business_Group__c='ES';
        testuser.Adoption_Role_Type__c='Account Executive';
        insert testuser;
        
        List<Task> tasklist=new List<Task>();
         Account accamericas=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
            accamericas.Shippingcountry=Region;            
            Insert accamericas;
     //System.runAs(testuser) {
            Map<id,Opportunity> opptymap=new Map<id,Opportunity>();
            
            
           
            Opportunity oppamericas = new Opportunity(AccountId = accamericas.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD',Route_To_Market__c='Direct',Amount=100);              
            Insert oppamericas;         
            Task taskamericas=new Task();
            taskamericas.WhatId=oppamericas.Id;
            taskamericas.Subject='Call';
            Insert taskamericas;
            tasklist.add(taskamericas);
             opptymap.put(oppamericas.id,oppamericas);
           //}
             return tasklist;
             
            
    }

    static testmethod void Americastestmethod(){
                                               
            GripExtractSchedulerAmericasRegion oppscheduleramericas=new GripExtractSchedulerAmericasRegion();
            oppscheduleramericas.tasklist=GripExtractSchedulercommonTest.setupdata('United States');
            system.debug('&&'+(oppscheduleramericas.tasklist));
            GripExtractSchedulerAmericasRegion.isTestrun=true;
            
            Test.startTest();           
            String schamericas = '0 20 9 * * ?';
            system.schedule('oppscheduleramericas',schamericas, oppscheduleramericas);                                 
            Test.stopTest();
                        
         }
         
       static testmethod void AsiaPacifictestmethod(){
                                               
            GripExtractSchedulerAsiaPacificRegion oppschedulerasia=new GripExtractSchedulerAsiaPacificRegion();
            oppschedulerasia.tasklist=GripExtractSchedulercommonTest.setupdata('India');
            GripExtractSchedulerAsiaPacificRegion.isTestrun=true;
            
            Test.startTest();           
            String schasia = '0 20 9 * * ?';
            system.schedule('oppscheduleramericas',schasia, oppschedulerasia);                                 
            Test.stopTest();
                        
         }
         
         static testmethod void EMEAtestmethod(){
                                               
            GripExtractSchedulerEMEARegion  oppscheduleremea=new GripExtractSchedulerEMEARegion ();
            oppscheduleremea.tasklist=GripExtractSchedulercommonTest.setupdata('France');
            GripExtractSchedulerEMEARegion.isTestrun=true;
            
            Test.startTest();           
            String schemea = '0 20 9 * * ?';
            system.schedule('oppscheduleramericas',schemea, oppscheduleremea);                                 
            Test.stopTest();
                        
         }
}