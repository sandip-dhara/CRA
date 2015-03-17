/**********************************************************
    * Class Name: CampaignInfluenceTriggerUtilTest
    * Author: HP
    * Date: 08-NOV-2012 
    * Description: This class does the test coverage for CampaignInfluenceController class. 
    ***********************************************************/
    
    @IsTest(seealldata=true)
    public Class CampaignInfluenceTriggerUtilTest{
        private static Account acc;
        private static Campaign_Influence__c CI;        
        private static Campaign_Influence__c CI1;  
        private static Campaign_Influence__c CIret;        
        private static Campaign_Influence__c CI1ret;
        private static Campaign_Influence__c CIdel;
        private static Campaign parentCamp;
        private static Campaign camp1 ;
        private static Campaign camp2 ;
        private static Campaign campdel ;
        private static List<Campaign_Influence__c> CIList = new List<Campaign_Influence__c>();
        private static List<Campaign_Influence__c> CIListret = new List<Campaign_Influence__c>();
        private static Map<Id,Campaign_Influence__c> CIMapOld = new Map<Id,Campaign_Influence__c>();
        

        private static Opportunity oppCreate;         
        
        /*
        * Method for creating test data.     
        */
        private static void setUpData(){
            // R6 : Karthik : Aug 07, 2013 : Creating Parent Campaign : Start
            parentCamp = TestingSetupDataUtil.createCampaign(True,5,7,'testParentCampCJ1',UserInfo.getUserId(),'newTestParentCampaign1',System.Today(),7,9,5,System.Today(),'In Progress','Banner Ads');
            insert parentCamp;
            // R6 : Karthik : Aug 07, 2013 : Creating Parent Campaign : End
            
            //Create Campaign Records
            camp1 = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ1',UserInfo.getUserId(),'newTest Campaign1',System.Today(),7,9,5,System.Today(),'Planned','Email');
            // R6 : Karthik : Aug 07, 2013 : Relating Campaign to a Parent Campaign : Start
            camp1.ParentId = parentCamp.Id;
            // R6 : Karthik : Aug 07, 2013 : Relating Campaign to a Parent Campaign : End
            insert camp1;
            
            camp2 = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ2',UserInfo.getUserId(),'newTest Campaign2',System.Today(),7,9,5,System.Today(),'Planned','Email');           
            // R6 : Karthik : Aug 07, 2013 : Relating Campaign to a Parent Campaign : Start
            camp2.ParentId = parentCamp.Id;
            // R6 : Karthik : Aug 07, 2013 : Relating Campaign to a Parent Campaign : End
           
            insert camp2;
            
            campdel = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ3',UserInfo.getUserId(),'newTest Campaign3',System.Today(),7,9,5,System.Today(),'Planned','Email');           
            campdel.ParentId = parentCamp.Id;
            campdel.Marketing_Campaign_flag__c = True;  
            insert campdel;
            
            
            //Create test Account
            acc = TestingSetupDataUtil.createAccount('AddtoCampaignTestAcc_952PM', 'AddtoCampaign_9@mail.com','Customer'); 
            insert acc;
            //Insert Opportunity
            Opportunity opp= TestingSetupDataUtil.createOpportunity(acc.Id,'rcjOppCI',System.Today()); 
            insert opp;

            Opportunity oppDel = TestingSetupDataUtil.createOpportunity(acc.Id,'rcjOppCIDel',System.Today()); 
            insert oppDel;
            
            oppCreate = TestingSetupDataUtil.createOpportunity(acc.Id,'rcjOppCICreate',System.Today()); 
            oppCreate.CampaignId = camp1.Id; 
            insert oppCreate; 
                
            //Insert Campaign Influence Records
            CI = TestingSetupDataUtil.createCI(opp.Id,camp1.Id);
            CI.Primary_Campaign_Source__c = True; 
            insert CI;
            CI1 = TestingSetupDataUtil.createCI(opp.Id,camp2.Id); 
            insert CI1;
            
            CIdel = TestingSetupDataUtil.createCI(opp.Id,campdel.Id); 
            CIdel.Primary_Campaign_Source__c = True; 
            insert CIdel;
            
            CIList.add(CI);
            CIList.add(CI1);
            
            CIret = [Select Id, Name from Campaign_Influence__c where Id =:CI.Id];
            CIret.Primary_Campaign_Source__c =False;
            update CIret;
            CI1ret = [Select Id, Name from Campaign_Influence__c where Id =:CI1.Id];
            CI1ret.Primary_Campaign_Source__c =True;
            update CI1ret;
            
            CIMapOld.put(CIret.Id,CIret);
            CIMapOld.put(CI1ret.Id,CI1ret);
            
            CIListret.add(CIret); 
            CIListret.add(CI1ret);
        }
        
        /*
        * Test Method for AddtoCampaign and Cancel methods.     
        */
        static testmethod void CampaignInfluenceTriggerUtilTestMethod(){
            Test.StartTest();
            setUpData();
            Test.StopTest();
            
            Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
            
            User usr = new User(Alias = 'standt', Email='standarduser@hp.com', Email_Address__c = 'standarduserCJ@hp.com',
                        Legacy_Employee_Ref__c = '764378534',EmailEncodingKey='UTF-8', LastName='Testing',
                        LanguageLocaleKey='en_US',  LocaleSidKey='en_US',
                        ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduserCJ@hp.com');

            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : Start
            usr.Adoption_Role_Type__c = 'IT';
            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : End

            System.Runas(usr){
                Global_Config__c globalConfig = new Global_Config__c(); 
                globalConfig.Mute_Triggers__c = True ;
                globalConfig.Mute_Validation_Rule__c = False;
                globalConfig.Mute_Workflow_Rule__c = False;
                globalConfig.SetupOwnerId = usr.Id;
                System.debug('*********globalConfig***'+globalConfig);
                insert globalConfig;
                

                CampaignInfluenceTriggerUtil campTriggerUtil = new CampaignInfluenceTriggerUtil();
                campTriggerUtil.checkPrimaryFlagAfterInsert(CIList);            
                campTriggerUtil.checkDuplicateCampaignBeforeInsert(CIList);
                campTriggerUtil.checkPrimaryFlagAfterUpdate(CIList,CIMapOld);            
                campTriggerUtil.checkPrimaryFlagBeforeUpdate(CIList,CIMapOld);
                campTriggerUtil.removeOpptyAssociationAfterDelete(CIList);

                
            }            
            CampaignInfluenceTriggerUtil campTriggerUtil = new CampaignInfluenceTriggerUtil();
            campTriggerUtil.checkPrimaryFlagAfterInsert(CIList);            
            campTriggerUtil.checkDuplicateCampaignBeforeInsert(CIList);
            campTriggerUtil.checkPrimaryFlagAfterUpdate(CIList,CIMapOld);            
            campTriggerUtil.checkPrimaryFlagBeforeUpdate(CIList,CIMapOld);     
            campTriggerUtil.removeOpptyAssociationAfterDelete(CIList);
            //CampaignInfluenceTriggerUtil.checkPrimaryCampaignBeforeDelete();

            CIret = [Select Id, Name from Campaign_Influence__c where Id =:CI.Id];
            CIret.Primary_Campaign_Source__c =False;
            delete CIret;   
            
            CI1ret = [Select Id, Name from Campaign_Influence__c where Id =:CI1.Id];
            CI1ret.Primary_Campaign_Source__c =True;
           // update CI1ret; 
            delete CI1ret; 
           // delete CIdel;       
        }
        
        
        static testmethod void CampaignInfluenceTriggerUtilTestDelete(){
        
            Test.StartTest();
            setUpData();
            Test.StopTest();
            
            Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
            
            User usr = new User(Alias = 'standt', Email='standarduser@hp.com', Email_Address__c = 'standarduserCJ@hp.com',
                        Legacy_Employee_Ref__c = '764378534',EmailEncodingKey='UTF-8', LastName='Testing',
                        LanguageLocaleKey='en_US',  LocaleSidKey='en_US',
                        ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduserCJ@hp.com');

            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : Start
            usr.Adoption_Role_Type__c = 'IT';
            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : End

            System.Runas(usr){
            
                CI1ret = [Select Id, Name from Campaign_Influence__c where Id =:CI1.Id];
                CI1ret.Primary_Campaign_Source__c =True;
                
                delete CI1ret; 
                
                CIret  = [Select Id, Name from Campaign_Influence__c where Id =:CIdel.Id];
                CIret.Primary_Campaign_Source__c =True;
                
                delete CIret; 
            }
        
        
        }
        
        static testmethod void CampaignInfluenceCreateTriggerUtilTest(){
        

            Test.StartTest();
            setUpData();
            Test.StopTest();
            
            Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
            
            User usr = new User(Alias = 'standt', Email='standarduser@hp.com', Email_Address__c = 'standarduserCJ@hp.com',
                        Legacy_Employee_Ref__c = '764378534',EmailEncodingKey='UTF-8', LastName='Testing',
                        LanguageLocaleKey='en_US',  LocaleSidKey='en_US',
                        ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduserCJ@hp.com');

            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : Start
            usr.Adoption_Role_Type__c = 'IT';
            // R6 : Karthik : Aug 07, 2013 : Providing User Role Type Data which is Mandatory : End
            
            Map<Id,Id> mapOpportunityWithCampaignId = new Map<Id,Id>();
            mapOpportunityWithCampaignId.put(oppCreate.Id, camp1.Id);
            mapOpportunityWithCampaignId.put(oppCreate.Id, camp2.Id);

            System.Runas(usr){
                                CampaignInfluenceCreateTriggerUtil.resetExistingPrimaryAndInsertOrUpdateCIPrimary(mapOpportunityWithCampaignId,'Insert');
                                
                                CampaignInfluenceCreateTriggerUtil.resetExistingPrimaryAndInsertOrUpdateCIPrimary(mapOpportunityWithCampaignId,'Update');

            }


            }
            

            



    }