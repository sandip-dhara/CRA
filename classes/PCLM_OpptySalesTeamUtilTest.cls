/**********************************************************
* Class Name: PCLM_OpptySalesTeamUtilTest
* Author: HP
* Date: 10-Jan-2013
* Description: This class does the test coverage for PCLM_OpptySalesTeamUtil class.
***********************************************************/
@isTest(SeeAllData=true)
Private Class PCLM_OpptySalesTeamUtilTest{  
    static testMethod void testOpptySalesTeamUtil(){
        OpportunityTeamMember oppTeamMember=new OpportunityTeamMember();
        List<OpportunityTeamMember> oppTeamMember1=new List<OpportunityTeamMember>();
        Sales_Territory__c salesTerritory = new Sales_Territory__c();
        Sales_Territory_User_Assignment__c salesTerrUser = new Sales_Territory_User_Assignment__c ();
        Sales_Territory_Location_Assignment__c salesTerrLoc = new  Sales_Territory_Location_Assignment__c();
        
        Id RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account newAccount = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
        insert newAccount;
    
        Contact contact1  = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@test.com');
        insert contact1;
    
        Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = newAccount.id);
        insert loc1;
    

        //Partner User Insertion
        UserLicense usr =[Select id from UserLicense where name='Gold Partner'];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserLicenseId=:usr.Id ];
    User portalUser = new User(ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'Test1', FirstName = 'Test1', Username = 'testing45672@hp.com', Alias='test1', CommunityNickname='test Approve123', Email='test123@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test123@hp.com',EmployeeNumber='65348771',Legacy_Employee_Ref__c='1487888',Location_Record_Id__c = loc1.id,Adoption_Role_Type__c='Partner User');
        Insert portalUser ;
        
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Account') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id recrdId= RecordTypeInfo.get('Customer').getRecordTypeId();
        Account newAcc=new Account(Name='Test Account11',RecordTypeId= recrdId,ShippingCountry='India');
        Insert newAcc;

        //Test Opportunity Insertion
        Opportunity newOppty=new Opportunity(Name='Test',Managed_By__c='Hp',closedate=Date.today(),AccountId=newAcc.Id,stagename='02 - Validate Opportunity',CurrencyIsoCode= 'USD');
        Insert newOppty;

        //Channel Partner insertion
        Channel_Partner__c newalliance=new Channel_Partner__c(Channel_Partner__c=newAccount.Id,Partner_Type__c='Alliance Partner',Partner_Account_Role__c='Implementer',Opportunity__c=newOppty.Id,Location__c = loc1.id);
        Insert newalliance;

        //Test Opportunity Team Member insertion 
        oppTeamMember.OpportunityId=newOppty.Id;
        oppTeamMember.TeamMemberRole='Inside Sales';
        oppTeamMember.UserId=portalUser.Id;
        insert oppTeamMember;
        oppTeamMember1.add(oppTeamMember);

 
        // Test Group
        Group grp = new Group(Name = ('' + 'sterr-10')); 
        insert grp ;

        // Creating GroupMember     
        //GroupMember grpMem=new GroupMember(GroupId=grp.id,UserOrGroupId=portalUser.Id);     
        //insert grpMem;

        // Test salesTerritory insertion    
        salesTerritory.Name='TestSalesTerritory';
        salesTerritory.Account_Access__c='Edit';
        salesTerritory.Opportunity_Access__c='Read';
        salesTerritory.Case_Access__c='Read';
        salesTerritory.isExternal__c=true;
        salesTerritory.isActive__c= true;
        salesTerritory.IsPartner__c= true;
        salesTerritory.GroupID__c=grp.Id; 
        salesTerritory.MyComp_Sales_Territory_Name__c = 'ST-TestSterr';
        insert salesTerritory;

        //Test oppty share insert
        OpportunityShare newShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
        newShareRec.OpportunityId = newOppty.Id;
        newShareRec.UserOrGroupId = grp.Id;
        insert newShareRec;    

        //Sales Territory Account Assignment    
        salesTerrLoc.Location__c=loc1.Id;
        salesTerrLoc.CurrencyIsoCode='USD';
        salesTerrLoc.Sales_Territory__c=salesTerritory.Id;
        insert salesTerrLoc;

        //Sales Territory User Assignment
        salesTerrUser.Sales_Territory__c=salesTerritory.Id;
        salesTerrUser.User__c=portalUser.Id;
        insert salesTerrUser;

        //delete optty member
        //delete oppTeamMember;
        
        test.starttest();
        
        PCLM_OpptySalesTeamUtil.optySharesForSTMembersViaLocation(oppTeamMember1);
        PCLM_OpptySalesTeamUtil.shareOpptyWithSalesTerritoryUsersForLocation(oppTeamMember1);
        PCLM_OpptySalesTeamUtil.removeOpptyShareFromSalesTerritoryUsersForLocation(oppTeamMember1);
        test.stoptest();
    }  
}