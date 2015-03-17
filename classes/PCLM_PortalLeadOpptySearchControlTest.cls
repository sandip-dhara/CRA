/**********************************************************
* Class Name: PCLM_PortalLeadOpptySearch_ControllerTest
* Author: HP 
* Date: 21-Dec-2012 
* Description: This class contains the test code coverage for the class "PCLM_PortalLeadOpptySearch_Controller"
***********************************************************/
@isTest(seeAllData = true)
Private class PCLM_PortalLeadOpptySearchControlTest{ 
    static testMethod void testPartnerPortalLeadOpptySearch(){
    OpportunityShare newShareRec=new OpportunityShare();
    OpportunityTeamMember oppTeamMember=new OpportunityTeamMember();
    Account newAccount=null;
    Contact contact1 = null;

     //Partner Account Insertion
    Recordtype recordId=[Select Id,Name from recordtype where Name='Partner'];
    newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId.Id,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
    insert newAccount;
    newAccount.IsPartner=true;
    update newAccount;
    
    //Test Contact Insertion 
    contact1 = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@test.com');
    insert contact1;
        
    //Partner User Insertion
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' Limit 1];
    User portalUser = new User(ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test124', FirstName = 'Test1', Username = 'testing4569@hp.com', Alias='test124', CommunityNickname='test 1231', Email='test2351@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test1254@hp.com',EmployeeNumber='65348661',Legacy_Employee_Ref__c='1487595');
    Insert portalUser ;
    system.debug('++++'+portalUser.isportalEnabled);    
    
    system.runAs(portalUser){
        //Test Account Insertion
        Recordtype recrdId=[Select Id,Name from recordtype where Name='Customer']; 
        Account newAcc=new Account(Name='Test Account11',RecordTypeId= recrdId.Id,ShippingCountry='India');
        Insert newAcc;
    
        //Test Opportunity Insertion    
        Opportunity newOppty=new Opportunity(Name='Test',Managed_By__c='Hp',closedate=Date.today(),AccountId=newAcc.Id,stagename='02 - Validate Opportunity',CurrencyIsoCode= 'USD');
        Insert newOppty;
     
        //Test Opportunity Team Member insertion 
        oppTeamMember.OpportunityId=newOppty.Id;
        oppTeamMember.TeamMemberRole='Inside Sales';
        oppTeamMember.UserId=portalUser.Id;
        insert oppTeamMember ;
    } 
               
    try{ 
    Lead newLead=new Lead(LastName='Test Lead',Company='HP',Status='Open',Phone='36427565');
    Insert newLead; 
    }
    catch(exception e){}
    
        system.runAs(portalUser){
                string searchText;
                PageReference pageRef = new PageReference('/apex/PCLM_PortalLeadOpptySearchPage?searchText=test');
                Test.setCurrentPage(pageRef);
                PCLM_PortalLeadOpptySearchController stdController = new PCLM_PortalLeadOpptySearchController();
                stdController.userInputValue='Test';
                String userInputValue= ApexPages.currentPage().getParameters().get(searchText);
                userInputValue='Test';
                stdController.toggleSortLead();
                stdController.toggleSortOppty();
                stdController.getOpptyList();
                stdController.nextLeadPage();
                stdController.previousLeadPage();
                stdController.firstLeadPage();
                stdController.lastLeadPage();
                stdController.gethasLeadNext();
                stdController.gethasLeadPrevious();
                stdController.getleadResultSize();
                stdController.getleadResultSize();
                stdController.nextOpptyPage();
                stdController.previousOpptyPage();
                stdController.firstOpptyPage();
                stdController.lastOpptyPage();
                stdController.getopptyResultSize();
               // stdController.insufficientCharLen=true;
               
            
        }

       
}
}