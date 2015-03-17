@isTest(seeAllData=true)
private class PCLM_OppOwnerChngTerrUpdateControlTest{
    static testMethod void OppOwnerChngTerritoryUpdate_controllerTest(){ 
    
    user testUser = new User(Profileid=userInfo.getProfileId(),Username='OpptyOwner123@gmail.com',
                                 LastName='OpOw',email='OpptyOwner124test12@hp.com' ,Alias='OptyO', 
                                 CommunityNickname='testO',emailencodingkey='UTF-8', 
                                 languagelocalekey='en_US', localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                                 Partner_Collaboration_Participating_User__c=true, Email_Address__c='Opptygemail123@gmail.com',EmployeeNumber='',
                                 Legacy_Employee_Ref__c='09876599',Adoption_Role_Type__c='Account Executive');
    insert testUser;
    
    Id RecordTypeId= Schema.SObjectType.account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
    Account newAccount = new Account(Name='PrevLocTestAcc1',RecordTypeId=RecordTypeId,Partner_Portal_Eligible__c=true,MDCP_Business_Relationship__c='Reseller',MDCP_Business_Relationship_ID__c='111',MDCP_Organization_ID__c='111',Channel_Partner_Flag__c=true);
    insert newAccount;
    
    Contact contact1  = new Contact(FirstName = 'Test',Lastname = 'McTesty',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@test.com');
    insert contact1;
    
    Location__c loc1 = new Location__c(Name='1500',Location_Name__c='Blr',Account__c = newAccount.id);
    insert loc1;
    
    Location_Partner_Users__c lpu1 = new Location_Partner_Users__c(Contact__c = contact1.id,Location__c = loc1.id,Userkey__c =  'a2bc3');
    insert lpu1;
    
    UserLicense usr =[Select id from UserLicense where name='Gold Partner'];
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' and UserLicenseId=:usr.Id ];
        
    User portalUser = new User(ProfileId = portalProfile.id,ContactId=contact1.Id,
                                    LastName = 'Test1', FirstName = 'Test1', Username = 'testing452567@test.com',
                                    Alias='test1',CommunityNickname='test12 Approve1', Email='testingoppty12323@hp.com',TimeZoneSidKey='America/Chicago',
                                    EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='test234y1@hp.com',
                                    Partner_Collaboration_Participating_User__c=true,EmployeeNumber='6534548661',
                                    Legacy_Employee_Ref__c='142587547',Adoption_Role_Type__c='Partner User');
    Insert portalUser;
    Sales_Territory__c salesTerritory = new Sales_Territory__c();
    Sales_Territory_User_Assignment__c salesTerrUser = new Sales_Territory_User_Assignment__c ();
    Sales_Territory_Location_Assignment__c salesTerrLoc = new  Sales_Territory_Location_Assignment__c();
    system.runAs(testUser){
             test.startTest();
                 portalUser.isPortalEnabled = true;
                 update portalUser;
             test.stopTest();
         }
    
        //Create a sales territory
        sales_territory__c st = new sales_territory__c();
        st.name = 'Test Sales territory';
        st.isPartner__c = true;
        st.isExternal__c = true;
        st.isActive__c = true;
        st.MyComp_Sales_Territory_Name__c ='St-Test';
        insert st;
        
        //Create a sales Territory User Assignment.
        Sales_Territory_User_Assignment__c salesUserAssign = new Sales_Territory_User_Assignment__c();
        salesUserAssign.User__c = testUser.id;
        salesUserAssign.sales_territory__c = st.id;
        insert salesUserAssign;
        
        //Create a sales territory Location assignment.
        Sales_Territory_Location_Assignment__c salesLocationAssign = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign.Sales_Territory__c = st.id;
        salesLocationAssign.Location__c = loc1.id;
        insert salesLocationAssign;
        
        //Create a sales territory
        sales_territory__c st1 = new sales_territory__c();
        st1.name = 'Test Sales territory';
        st1.isPartner__c = true;
        st1.isExternal__c = true;
        st1.isActive__c = true;
        st1.MyComp_Sales_Territory_Name__c = 'St-Test1';
        insert st1;
        
        //Create a sales Territory User Assignment.
        Sales_Territory_User_Assignment__c salesUserAssign1 = new Sales_Territory_User_Assignment__c();
        salesUserAssign1.User__c = testUser.id;
        salesUserAssign1.sales_territory__c = st1.id;
        insert salesUserAssign1;
        
        //Create a sales territory Account assignment.
        Sales_Territory_Location_Assignment__c salesLocationAssign1 = new Sales_Territory_Location_Assignment__c();
        salesLocationAssign1.Sales_Territory__c = st1.id;
        salesLocationAssign1.Location__c = loc1.id;
        insert salesLocationAssign1;
        
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount','accountEmail@test.com','Customer');
        insert acc;
        
        //Create Account share for the portal user
        AccountShare accShare = new accountShare();
        accShare.accountId = acc.Id;
        accShare.userOrGroupId = portalUser.id;
        //acc.rowCause = 'Manual Sharing';
        accShare.accountAccessLevel = 'Read';
        accShare.OpportunityAccessLevel = 'Edit';
        insert accShare;
        
        //Insert Opportunity.
             opportunity newOpp = new Opportunity();
        system.runAs(portalUser){
            
            newOpp.Name = 'OpportunityName';
            newOpp.CloseDate = system.today()+30;      
            newOpp.AccountId = acc.Id;
            newOpp.StageName = '01 - Understand Customer';
            newOpp.CurrencyIsoCode= 'USD';
            //newOpp.ownerId=portalUser.id;
            newOpp.Managed_By__c='Partner';
            insert newOpp;
        }
        
        system.runAs(testUser){
            newOpp.ownerId = testUser.id;
            update newOpp;
            opportunity newOpp1 = new opportunity();
            newOpp1.name= 'test Oppty1';
            newOpp1.Accountid= acc.id;
            date closeDate = system.today();
            newOpp1.closeDate = closeDate.addDays(30);
           // TestingSetupDataUtil.createOpportunity(newAcc.Id,'testOppty1', system.today()+ 30);
            newOpp1.stagename='01 - Understand Customer';
            newOpp1.ownerId=userInfo.getUserId();
            newOpp1.Managed_By__c='HP';
            insert newOpp1;
            
            Opportunity newOppty2=new Opportunity(Name='Test',Managed_By__c='Hp',closedate=Date.today()+30,AccountId=acc.Id,stagename='02 - Validate Opportunity',CurrencyIsoCode= 'USD',ownerId=portalUser.Id);
            Insert newOppty2;
            
            
            
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
        salesTerritory.MyComp_Sales_Territory_Name__c = 'ST-Sterr';
        insert salesTerritory;

        //Test oppty share insert
        OpportunityShare newShareRec = new OpportunityShare(OpportunityAccessLevel = 'Read');
        newShareRec.OpportunityId = newOppty2.Id;
        newShareRec.UserOrGroupId = grp.Id;
        insert newShareRec;    

        //Sales Territory Location Assignment    
        salesTerrLoc.Location__c=loc1.Id;
        salesTerrLoc.CurrencyIsoCode='USD';
        salesTerrLoc.Sales_Territory__c=salesTerritory.Id;
        insert salesTerrLoc;

        //Sales Territory User Assignment
        salesTerrUser.Sales_Territory__c=salesTerritory.Id;
        salesTerrUser.User__c=portalUser.Id;
        insert salesTerrUser;
        
        map<id, opportunity> passOppty = new map<id, opportunity>();
        //passOppty.put(newOpp1.id, newOpp1);
        passOppty.put(newOppty2.id,newOppty2);
        list<user> passUser = new list<user>();
        passUser.add(portalUser);
            
        PCLM_OppOwnerChngTerrUpdateController.removeOpptyShareToPartnersForLocation(passOppty,passUser);
            
            
            
            channel_partner__c ACP = new Channel_partner__c();
            ACP.Opportunity__c= newOpp1.id;
            ACP.Channel_Partner__c = newAccount.id;
            ACP.Partner_Account_Role__c='Distributor';
            ACP.Partner_Type__c = 'Channel Partner';
            insert ACP;
            
            newOpp1.ownerId = portalUser.id;
            update newOpp1;
            
            newOpp1.ownerId = testuser.Id;
            update newOpp1;
          }
        
        
    }
}