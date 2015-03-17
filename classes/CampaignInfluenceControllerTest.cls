/**********************************************************
    * Class Name: CampaignInfluenceControllerTest
    * Author: HP
    * Date: 08-NOV-2012 
    * Description: This class does the test coverage for CampaignInfluenceController class. 
    ***********************************************************/
    
    @IsTest(SeeAllData=True)
    public Class CampaignInfluenceControllerTest{
        private static Account acc;
        private static Campaign_Influence__c CI;        
        private static Campaign_Influence__c CIEdit;
        private static Campaign_Influence__c CIEditRet;
        private static Campaign parentCamp;
        private static Campaign camp1 ;
        private static Campaign camp2 ;
        private static Opportunity opp;
        private static Opportunity oppRet;
        private static Opportunity opp1;

        /*
        * Method for creating test data.     
        */
        private static void setUpData(){
            
            // Karthik : Aug 07, 2013 : Creating Parent Campaign : Start
            parentCamp = TestingSetupDataUtil.createCampaign(True,5,7,'testParentCampCJ1',UserInfo.getUserId(),'newTestParentCampaign1',System.Today(),7,9,5,System.Today(),'In Progress','Banner Ads');
            insert parentCamp;
            System.debug('****************parentCamp.Id = ' + parentCamp.Id);
            // Karthik : Aug 07, 2013 : Creating Parent Campaign : End
            
            //Create Campaign Records
            camp1 = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ1',UserInfo.getUserId(),'newTest Campaign1',System.Today(),7,9,5,System.Today(),'Planned','Email');
            // Karthik : Aug 07, 2013 : Relating Child Campaign to a Parent Campaign : Start
            camp1.ParentId = parentCamp.Id;
            // Karthik : Aug 07, 2013 : Relating Child Campaign to a Parent Campaign : End
            insert camp1;
            System.debug('****************camp1.Id = ' + camp1.Id);
            
            camp2 = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ2',UserInfo.getUserId(),'newTest Campaign2',System.Today(),7,9,5,System.Today(),'Planned','Email');           
            // Karthik : Aug 07, 2013 : Relating Child Campaign to a Parent Campaign : Start
            camp2.ParentId = parentCamp.Id;
            // Karthik : Aug 07, 2013 : Relating Child Campaign to a Parent Campaign : End
            insert camp2;
            System.debug('****************camp2.Id = ' + camp2.Id);
            
            acc = TestingSetupDataUtil.createAccount('AddtoCampaignTestAcc_952PM', 'AddtoCampaign_9@mail.com','Customer'); 
            insert acc;
            System.debug('****************acc.Id = ' + acc.Id);
            
            //Insert Opportunity
            opp= TestingSetupDataUtil.createOpportunity(acc.Id,'rcjOppCI',System.Today()); 
            insert opp;
            System.debug('****************opp.Id = ' + opp.Id);
            
            oppRet =[Select Id from Opportunity where Id =:opp.Id];
            System.debug('****************oppRet.Id = ' + oppRet.Id);
            
            //Insert Campaign Influence Records
            CI = TestingSetupDataUtil.createCI(opp.Id,camp1.Id);
            CI.Primary_Campaign_Source__c = False;
            //CI.Primary_Campaign_Source__c = True;
            insert CI;
            System.debug('****************CI.Id = ' + CI.Id);
            
            CIEdit = TestingSetupDataUtil.createCI(opp.Id,camp2.Id);
            CIEdit.Primary_Campaign_Source__c = True;
            insert CIEdit;
            System.debug('****************CIEdit.Id = ' + CIEdit.Id);
            System.debug('****************CIEdit.Opportunity__c = ' + CIEdit.Opportunity__c);
            System.debug('****************CIEdit.Campaign__c = ' + CIEdit.Campaign__c);
            
            CIEditRet = [Select Id,Opportunity__c, Campaign__c from Campaign_Influence__c where Id=:CIEdit.Id];

            /*  R6 : Commented to handle validation rule on unchecking Primary flag - You cannot uncheck a primary.
             To change, set the primary of another CI record, and this will automatically uncheck. 
            CIEditRet.Primary_Campaign_Source__c = False;
            update CIEditRet;
             */   
        }
         
        /*
        * Test Method for AddtoCampaign and Cancel methods.     
        */
        static testmethod void CIControllerTestMethodSuccess(){
        
            Test.StartTest();
            setUpData();
            Test.StopTest();           
            
            PageReference pageRef = Page.CampaignInfluencePage;
            Test.setCurrentPageReference(pageRef);
            // Karthik : Aug 08, 2013 : Setting Ids of Campaign_Influence__c and Opportunity : Start
            //ApexPages.currentPage().getParameters().put('Id', CIEditRet.Id);
            //ApexPages.currentPage().getParameters().put('oppId', oppRet.Id);
            ApexPages.currentPage().getParameters().put('Id', CIEdit.Id);
            ApexPages.currentPage().getParameters().put('oppId', opp.Id);
            // Karthik : Aug 08, 2013 : Setting Ids of Campaign_Influence__c and Opportunity : End
            //ApexPages.StandardController ssc = new ApexPages.StandardController(CIEditRet);
            ApexPages.StandardController ssc = new ApexPages.StandardController(CIEdit);
            CampaignInfluenceController campController  = new CampaignInfluenceController(ssc);
            /*
            campController.CIRec = CIEditRet;
            campController.oppId= oppRet.Id;
            campController.saveOppCI();
            campController.Cancel();
            campController.checkOptyEditAccessCI();
            campController.OpportunityId();
            campController.cancelCI();
            campController.saveCI();
            */
            
            // Added in R6 - START
            campController.campaignInfluence = CIEdit; 
            // Added in R6 - END
            campController.CIRec = CIEdit;
            campController.oppId= opp.Id;
            campController.saveOppCI();
            campController.Cancel();
            campController.checkOptyEditAccessCI();
            campController.OpportunityId();
            campController.cancelCI();
            campController.saveCI();
            
            PageReference pageRef1 = Page.CampaignInfluencePage;
            Test.setCurrentPageReference(pageRef1);
            ApexPages.currentPage().getParameters().put('Id', CIEditRet.Id);
            ApexPages.currentPage().getParameters().put('oppId', oppRet.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(CIEditRet);  
            CampaignInfluenceController campController1  = new CampaignInfluenceController(sc);
                        // Added in R6 - START
            campController1.campaignInfluence = CIEditRet; 
                        // Added in R6 - END
            campController1.CIRec = CIEditRet;
            campController1.oppId= null;
            try{campController1.OpportunityId();}
            catch(Exception e){e.getMessage();}
            try{campController1.cancelCI();}
            catch(Exception e){e.getMessage();}
            
         }
         
                 
     }