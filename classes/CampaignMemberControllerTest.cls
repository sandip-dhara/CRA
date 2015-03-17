/**********************************************************
    * Class Name: CampaignMemberControllerTest
    * Author: HP
    * Date: 08-NOV-2012 
    * Description: This class does the test coverage for CampaignMemberController class. 
    ***********************************************************/
    
    @IsTest
    public Class CampaignMemberControllerTest{
        private static Account acc;
        private static Lead newLead;
        public static Account newAccount;
        public static Campaign camp;

        
        /*
        * Method for creating test data.     
        */
        private static void setUpData(){  
            //Fetch a Campaign Record
            camp = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ1',UserInfo.getUserId(),'newTest Campaign1',System.Today(),7,9,5,System.Today(),'Planned','Email');
            System.debug('***************camp********'+camp);
              insert camp;          
            /* Insert Account */
            newAccount = new Account();
            newAccount = TestingSetupDataUtil.createAccount('HP', 'test@test.com', 'Customer');        
            insert newAccount; 
            System.debug('***************newAccount********'+newAccount);
   
            /* Inserting Leads */      
            newLead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Open', 'Accepted', '123', 'test@test.com');
            newLead.Account_Name__c = newAccount.Id;
            newLead.Budget__c = '121' ;
            newLead.Authorized_Buyer__c = 'No';
            newLead.Timeframe_to_Buy_1__c = '< 1 Week';
            newLead.Estimated_Budget__c = 123.0;
            newLead.Campaign__c = camp.Id;
            insert newLead;
            System.debug('***************newLead********'+newLead);
        }
        
        /*
        * Test Method for AddtoCampaign and Cancel methods.     
        */
        static testmethod void CampaignInfluenceTriggerUtilTestMethod(){
            Test.StartTest();
            setUpData();
            Test.StopTest();
                       
            PageReference pageRef = Page.CampaignMemberPage;
            Test.setCurrentPageReference(pageRef);
            System.currentPageReference().getParameters().put('leadId', newLead.Id);
            System.debug('***************newLead********'+newLead);
            ApexPages.StandardController sc = new ApexPages.StandardController(camp);  
            System.debug('***************sc ********'+sc );
            CampaignMemberController campMlookup = new CampaignMemberController(sc);
            System.debug('***************campMlookup********'+campMlookup);
            
            //catch(Exception e){e.getMessage();}
            System.debug('***************newLead********'+newLead);
            campMlookup.primary = False;
            campMlookup.Cancel();
            campMlookup.save();
                                                          
        }
        
        
    }