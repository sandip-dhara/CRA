/**********************************************************
    * Class Name: AddtoCampaignControllerTest
    * Author: HP
    * Date: 08-NOV-2012 
    * Description: This class does the test coverage for AddtoCampaignController class. 
    ***********************************************************/
    
    @IsTest
    public Class AddtoCampaignControllerTest{
        private static Account acc;
        private static Campaign camp ;
        private static List<Lead> newLeads;
        
        /*
        * Method for creating test data.     
        */
        private static void setUpData(){  
            //Fetch a Campaign Record
            camp = TestingSetupDataUtil.createCampaign(True,5,7,'testCampCJ1',UserInfo.getUserId(),'newTest Campaign1',System.Today(),7,9,5,System.Today(),'Planned','Email');
            insert camp;
            acc = TestingSetupDataUtil.createAccount('AddtoCampaignTestAcc_952PM', 'AddtoCampaign_9@mail.com','Customer'); 
            insert acc;
            //Insert Lead       
            newLeads = new List<Lead>();             
            Lead newLead1 = TestingSetupDataUtil.createLead('AddtoCampaignTestLead1', 'rcj123', 'Open', 'Accepted', '123', 'addtocampaign@hp.com'); 
            newLead1.Account_Name__c = acc.Id;     
            newLead1.Budget__c = '1212' ;      
            newLead1.Authorized_Buyer__c = 'No';      
            newLead1.Timeframe_to_Buy_1__c = '< 1 Week';      
            newLead1.Estimated_Budget__c = 123.0;  
            newLead1.Campaign__c = camp.Id;
            insert newLead1;
             
             //Insert Lead       
            Lead newLead2 = TestingSetupDataUtil.createLead('AddtoCampaignTestLead2', 'rcj1243', 'Open', 'Accepted', '1243', 'addtocampaign1@hp.com'); 
            newLead2.Account_Name__c = acc.Id;     
            newLead2.Budget__c = '112' ;      
            newLead2.Authorized_Buyer__c = 'Yes';      
            newLead2.Timeframe_to_Buy_1__c = '< 1 Week';      
            newLead2.Estimated_Budget__c = 1243.0;      
            newLead2.Campaign__c = camp.Id;
            insert newLead2;
            newLeads.add(newLead1);
            newLeads.add(newLead2);
        }
         
        /*
        * Test Method for AddtoCampaign and Cancel methods.     
        */

        static testmethod void addtoCampaignTestMethod(){
            Test.StartTest();
            setUpData();
            Test.StopTest();
    
            PageReference pageRef = Page.AddToCampaignPage;
            System.debug('*************pageRef'+pageRef);
            Test.setCurrentPageReference(pageRef);
            System.debug('*************pageRef'+pageRef);
            ApexPages.Standardsetcontroller ssc = new ApexPages.Standardsetcontroller(newLeads);
            System.debug('*************ssc'+ssc);  
            AddtoCampaignController addtoCamp = new AddtoCampaignController(ssc);
            System.debug('*************addtoCamp '+addtoCamp);
    
            addtoCamp.leads = newLeads;
            addtoCamp.AddToCampaign();
            addtoCamp.Cancel();
        }
    }