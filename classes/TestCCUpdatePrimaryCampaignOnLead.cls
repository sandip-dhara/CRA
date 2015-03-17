/**********************************************************
    * Class Name: TestCCUpdatePrimaryCampaignOnLead
    * Author: HP(Sreedhar Jagannath)
    * Date: 18-07-2013
    * Description: This class does the test coverage for UpdateLeadCampaign Trigger. 
***********************************************************/
@IsTest
    public Class TestCCUpdatePrimaryCampaignOnLead{
        private static Lead newLead;
        public static Campaign camp;
        private static Lead newLead1;
        public static Campaign camp1;
        //public static Account newAccount;
        public static CampaignMember cmpMember;
        public static CampaignMember cmpMember1;
       
        /*
        * Method for creating test data.     
        */
        private static void setUpData(){  
            //Fetch a Campaign Record
            Id CampaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales Initiatives').getRecordTypeId();  
            camp = new Campaign(RecordTypeid = CampaignRecordTypeId,IsActive = true,Name = 'testCampCJ12ab',Ownerid = UserInfo.getUserId(),Description = 'newTest Campaign12',StartDate =System.Today(),Status ='Planned',Type='Email' );
            //camp1 = new Campaign(RecordTypeid = CampaignRecordTypeId,IsActive = true,Name = 'testCampCJ12',Ownerid = UserInfo.getUserId(),Description = 'newTest Campaign12',Parentid = camp.id,StartDate =System.Today(),Status ='Planned',Type='Email' );
           
            System.debug('***************camp********'+camp);
              insert camp;
              //insert camp1;          
            /* Insert Account */
            //newAccount = new Account();
            //newAccount = TestingSetupDataUtil.createAccount('HP', 'test@test.com', 'Customer');        
            //insert newAccount; 
            //System.debug('***************newAccount********'+newAccount);
   
            /* Inserting Leads */      
            newLead = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Open', 'Accepted', '123', 'test@test.com');
            newLead.Budget__c = '121' ;
            newLead.Authorized_Buyer__c = 'No';
            newLead.Timeframe_to_Buy_1__c = '< 1 Week';
            newLead.Estimated_Budget__c = 123.0;
            insert newLead;
            System.debug('***************newLead********'+newLead);
            
            //newLead1 = TestingSetupDataUtil.createLead('TestLead2', 'qqq123', 'Open', 'Accepted', '123', 'test@test.com');
            //newLead1.Account_Name__c = newAccount.Id;
            //newLead1.Budget__c = '121' ;
            //newLead1.Authorized_Buyer__c = 'No';
            //newLead1.Timeframe_to_Buy_1__c = '< 1 Week';
            //newLead1.Estimated_Budget__c = 123.0;
            //insert newLead1;
           // System.debug('***************newLead********'+newLead);
            
            cmpMember = new CampaignMember(Leadid=newLead.id,Campaignid=camp.id,Primary__C = true );
            insert cmpMember;
            //cmpMember1 = new CampaignMember(Leadid=newLead1.id,Campaignid=camp1.id,Primary__C = true );
            //insert cmpMember1;
            
            delete cmpMember;
        }
        
        public static testmethod void TestCCUpdatePrimaryCampaignOnLead(){
            Test.StartTest();
            setUpData();
            Test.StopTest();
       }
}