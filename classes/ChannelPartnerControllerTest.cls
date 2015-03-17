/**********************************************************
* Class Name: ChannelPartnerControllerTest
* Author: Accenture
* Date: 24-APR-2012 
* Description: This class does the test coverage
*              for ChannelPartnerController class. 
***********************************************************/
@isTest
private class ChannelPartnerControllerTest {

    static testMethod void testChannelPartnerController() {
        
        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United Kingdom'];
        //Create Partner Account
        Account PartnerAccount1 = TestingSetupDataUtil.createAccount('Test Test Account2', 'Test@test2.com', 'Partner');
        PartnerAccount1.Channel_Partner_Flag__c = true;
        PartnerAccount1.World_Region1__c=wr.id;
        PartnerAccount1.Active_Flag__c=true;
        listAccount.add(PartnerAccount1);
        
        //Create Partner Account without Alliance/Channel partner flag checked
        Account PartnerAccount2 = TestingSetupDataUtil.createAccount('Test Test Account3', 'Test@test3.com', 'Partner');
        listAccount.add(PartnerAccount2);
        
       //Create Alliance Partner Account
        Account AlliancePartnerAccount = TestingSetupDataUtil.createAccount('Test Test Account4', 'Test@test4.com', 'Partner');
        AlliancePartnerAccount.Alliance_Partner_Flag__c = true;
        AlliancePartnerAccount.Active_Flag__c=true;
        listAccount.add(AlliancePartnerAccount);
        
        //Create Channel Partner Account
        Account ChannelPartnerAccount = TestingSetupDataUtil.createAccount('Test Test Account5', 'Test@test5.com', 'Partner');
        ChannelPartnerAccount.Channel_Partner_Flag__c = true;
        ChannelPartnerAccount.Active_Flag__c=true;
        listAccount.add(ChannelPartnerAccount);
        
        insert listAccount;
        System.assertEquals(listAccount.size(),5);
        
        //Test Contact Creation
        Contact newCon=new Contact(LastName='Test Con',AccountId=listAccount[1].Id,Email='anh@hp.com');
        Insert newCon;
        
        //Test Location Insertion
        Location__c newLoc=new Location__c(Name='33586574',Account__c=listAccount[1].Id);
        Insert newLoc;  
        
        //Test Location Partner Users Insertion
        Location_Partner_Users__c newLocUser=new Location_Partner_Users__c(Contact__c= newCon.Id,Location__c=newLoc.Id,Userkey__c='374856');
        Insert newLocUser;  
            
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty',System.today().addMonths(1));
        insert opty;
        System.assertEquals(opty.Name,'testOppty');

     
        //Create Channel Partner 
        Channel_Partner__c channelPartner1 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',PartnerAccount1.Id);
        channelPartner1 .Location__c=newLoc.id;
        insert channelPartner1;
        System.assertEquals(channelPartner1.Partner_Type__c,'Channel Partner');
        
        Channel_Partner__c nullOptyChannelPartner = new Channel_Partner__c(); 

        system.runAs(TestingSetupDataUtil.testUser) {
            PageReference pageRef = Page.ChannelPartner;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('oppId', opty.Id);
            ApexPages.currentPage().getParameters().put('retURL', '/' + opty.Id);
            
            Test.startTest();
            
            //Setting channel partner record with null opty reference in standard controller
            ApexPages.StandardController nullOptyStdController = new ApexPages.StandardController(nullOptyChannelPartner);
            ChannelPartnerController nulloptyChanPartController = new ChannelPartnerController(nullOptyStdController);
            ChannelPartnerController.convertTo15Digit(opty.Id);
            ApexPages.StandardController stdController = new ApexPages.StandardController(channelPartner1);
            ChannelPartnerController chanPartController = new ChannelPartnerController(stdController);
            
            if(chanPartController.channelPartnerList != null && 
                chanPartController.channelPartnerList.size() > 0) {
                
                //keeping partner type null
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = PartnerAccount1.Id;
                chanPartController.save();
                
                //setting already linked partner Account
                chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Channel Partner';
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = PartnerAccount1.Id;
                chanPartController.save();
                
                //setting same account twice
                if(chanPartController.channelPartnerList.size() > 1) {
                    chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Channel Partner';
                    chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = PartnerAccount2.Id;
                    chanPartController.channelPartnerList[0].channelPartner.primary__c = true;
                    chanPartController.channelPartnerList[1].channelPartner.Partner_Type__c = 'Channel Partner';
                    chanPartController.channelPartnerList[1].channelPartner.Channel_Partner__c = PartnerAccount2.Id;
                    chanPartController.save();
                }
                
                //setting partner Account with Channel_Partner_Flag__c = false as 'Channel Partner' 
                chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Channel Partner';
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = PartnerAccount2.Id;
                chanPartController.channelPartnerList[1].channelPartner.Channel_Partner__c = null;
                chanPartController.save();
                
                //setting partner Account with Alliance_Partner_Flag__c = false as 'Alliance Partner' 
                chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Alliance Partner';
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = PartnerAccount2.Id;
                chanPartController.save();
                
                //setting valid 'Alliance Partner'
                chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Alliance Partner';
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = AlliancePartnerAccount.Id;
                chanPartController.save();
                
                //setting valid 'Channel Partner'
                chanPartController.channelPartnerList[0].channelPartner = new Channel_Partner__c();
                chanPartController.channelPartnerList[0].channelPartner.Opportunity__c = opty.Id;
                chanPartController.channelPartnerList[0].channelPartner.Partner_Type__c = 'Channel Partner';
                chanPartController.channelPartnerList[0].channelPartner.Channel_Partner__c = ChannelPartnerAccount.Id;
                chanPartController.save();
                
            }
            //calling other methods
            chanPartController.cancel();
            chanPartController.getFormTag();
            chanPartController.getIsResultEmpty();
            chanPartController.getTextBox();
            
            //Calling methods for ChannelPartnerLookup page
            PageReference pageRefLkp = Page.ChannelPartnerLookup;
            Test.setCurrentPageReference(pageRefLkp);
            ApexPages.currentPage().getParameters().put('lksrch', 'Test*');
            ApexPages.currentPage().getParameters().put('partnerType', 'Channel Partner');
            ChannelPartnerController channPartContForLkp1 = new ChannelPartnerController();
            system.assert(channPartContForLkp1.searchString != null, true); 
            
            ApexPages.currentPage().getParameters().put('partnerType', 'Alliance Partner');
            ChannelPartnerController channPartContForLkp2 = new ChannelPartnerController();
            channPartContForLkp2.search();
            //channPartContForLkp2.searchByKeyWord = 'Source_System_Account_ID__c';
            channPartContForLkp2.search(); 
            //channPartContForLkp2.checkOptyEditAccess();
            
            ApexPages.currentPage().getParameters().put('oppId', null);
            ChannelPartnerController nulloptyChanPartCont = new ChannelPartnerController(nullOptyStdController);
            nulloptyChanPartCont.oppId = opty.Id;
            //nulloptyChanPartCont.checkOptyEditAccess(); 
            
            Test.stopTest();
        }
    }
}