/**********************************************************
* Class Name: LocationUtilTest    
* Author: HP 
* Date: 12-may-2013
* Description: This class contains the test code coverage for the class "LocationUtil"
***********************************************************/
@isTest(seeAllData = true)
Private class LocationUtilTest{  

    static Account account1;
    static Account newAcc;
    static contact newCon;
    static Location__c newLoc;
    static Location__c newLoc1;
    static Opportunity opty;
    static  Channel_Partner__c channelPartner1;
    static OpportunityTeamMember oppMem;
    static User partUser1;

    private  static void setupData(){
    
    Id record=RecordTypeIdHelper.getRecordTypeId('Account','Partner'); 
    
    account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
    Insert account1;
   
    //Test Account Insertion     
     newAcc=new Account(Name='Test Account11',ShippingCountry='India',RecordTypeId=record);
    Insert newAcc;

    //Test Contact Creation
    newCon=new Contact(LastName='Test Con',AccountId=newAcc.Id,Email='anh@hp.com');
    Insert newCon;
    
    //Test Location Insertion
    newLoc=new Location__c(Name='33586574',Account__c=newAcc.Id);
    Insert newLoc;  
       
    newAcc.IsPartner=true;
    Update newAcc; 
    
    newLoc1=new Location__c(Name='33586574',Account__c=newAcc.Id);
    Insert newLoc1; 
        
    opty = TestingSetupDataUtil.createOpportunity(account1.Id,'testOppty',System.today().addMonths(1));
    insert opty;
    
    channelPartner1 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',newAcc.Id);
    channelPartner1.Location__c=newLoc1.Id;
    insert channelPartner1;
    

     Profile  partnerProfiles = [Select UserType,UserLicenseId,Name,Id From Profile where Name like '%Partner%' limit 1 ];
    // Create a partner user
    partUser1 = TestingSetupDataUtil.createUser('pruser12','partnerUser167@hp.com','5_1_partnerUser145@hp.com','UTF-8','parTneruser145','en_US','en_US','America/Los_Angeles','partnerUser145@testing.com','551456153',partnerProfiles.Id );
    //partUser1.ManagerId = userInfo.getUserId(); 
    partUser1.ContactId = newCon.Id;
    partUser1.Adoption_Role_Type__c='Account Executive';
    partUser1.Location_Record_Id__c = newLoc1.Id;
    insert partUser1;
    //usersList.add(partUser1);
    
    oppMem = TestingSetupDataUtil.createOpportunityTeamMember(partUser1.Id ,'Sales Rep',opty.Id);
    Insert oppMem;
    
    }
    
    static testMethod void positiveTest() {
    
        test.startTest();
            setupData();
            //Test Location Partner Users Insertion
            Location_Partner_Users__c newLocUser=new Location_Partner_Users__c(Contact__c= newCon.Id,Location__c=newLoc.Id,Userkey__c='374856');
            Insert newLocUser;
            newLocUser.Location__c=newLoc1.Id;
            update newLocUser;
        test.stopTest();
        
    }
    
     static testMethod void negativeTest() {
    
        test.startTest();
            setupData();
            //Test Location Partner Users Insertion
            channel_Partner__c  channelPartner2 = TestingSetupDataUtil.createChannelPartner(opty.id,'Channel Partner',newAcc.Id);
            channelPartner2.Location__c=newLoc.Id;
            insert channelPartner2;
    
            Location_Partner_Users__c newLocUser1=new Location_Partner_Users__c(Contact__c= newCon.Id,Location__c=newLoc1.Id,Userkey__c='3748563');
            Insert newLocUser1;
            newLocUser1.Location__c=newLoc.Id;
            update newLocUser1;
        test.stopTest();
    
    }
}