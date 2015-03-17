/**********************************************************
* Class Name: OpportunityOwnerChangeControllerTest
* Author: HP 
* Modified date: 9-Jan-2013 
* Description: This class contains the test code coverage for the class "OpportunityOwnerChangeController" and "OpportunityOwnerChangeExtn"
***********************************************************/

@isTest(SeeAllData=true)
Private Class OpportunityOwnerChangeControllerTest{
/* define class variables */
    private static OpportunityTeamMember oppMem = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    private static OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    private static Opportunity newOpp;
    private static Opportunity opp2;
    private static User userTest;
    private static User newUser;
    private static User userForOwnerChange;
    private static Opportunity newOppty;
    private static User partnerUser;
    static String errorMessage;
    static List<User> userList = new List<User>();
    
    /* 
    * @description:create the data require for the coverage 
    */
    private static void setupData(){
  
        Profile p = [select id from profile where name='IT Administrator'];       
        userForOwnerChange= new user(Profileid=p.id,Username='OpptyOwner123@hp.com',LastName='OpOw',email='OpptyOwner124@hp.com'
                            ,Alias='OptyO',
                          CommunityNickname='testO',emailencodingkey='UTF-8', languagelocalekey='en_US',
                            localesidkey='en_US',timezonesidkey='America/Los_Angeles',
                            Email_Address__c='Opptygemail123@hp.com',EmployeeNumber='',Legacy_Employee_Ref__c='09876599',Partner_Collaboration_Participating_User__c=true);
        userForOwnerChange.Adoption_Role_Type__c='Account Executive';                   
        userList.add(userForOwnerChange);
        //insert userForOwnerChange;
        
        //generate Random String 
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
                       
        // Insert User
        userTest = TestingSetupDataUtil.createUser('DA_'+randomstr.substring(0,4),randomstr+'userTest@hp.com',randomstr+'userTest@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','55235615',Userinfo.getProfileId());
        //insert userTest ;
        userTest.Adoption_Role_Type__c='Account Executive';    
        userList.add( userTest);    
        newUser = TestingSetupDataUtil.createUser('DA_1'+randomstr.substring(0,4),randomstr+'userTest1@hp.com',randomstr+'userTestn@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestn@hp.com','55235616',Userinfo.getProfileId());
       // insert newUser ;
        newUser.Adoption_Role_Type__c='Account Executive';
        userList.add(newUser); 
        insert userList;
        //Create a test account
        Account acc = TestingSetupDataUtil.createAccount('testAccount','accountEmail@hp.com','Customer');
        insert acc;
                     
        //Insert Opportunity
        List<Opportunity> listOpportunity = new List<Opportunity>();
        newOpp = TestingSetupDataUtil.createOpportunity(acc.Id,'testOppty', system.today()+ 30);
        newOpp.stagename='02 - Validate Opportunity';
        //newOpp.SendEmailNotification__c=true;
        newOpp.ownerId=userTest.id;
        newOpp.Managed_By__c='HP';
        listOpportunity.add(newOpp);

        opp2 = TestingSetupDataUtil.createOpportunity(acc.Id, 'opp2', system.today()+ 30);
        opp2.Managed_By__c='HP';
        listOpportunity.add(opp2);
        insert listOpportunity;
               
        // Insert Opportunity Team Members    
        List<OpportunityTeamMember> listOpportunityTeamMember = new List<OpportunityTeamMember>();
     
        oppMem = TestingSetupDataUtil.createOpportunityTeamMember(userTest.Id ,'Inside Sales',newOpp.Id);
        listOpportunityTeamMember.add(oppMem);
        oppMem1 = TestingSetupDataUtil.createOpportunityTeamMember(userForOwnerChange.id ,'Inside Sales',newOpp.Id);
        listOpportunityTeamMember.add(oppMem1);
        insert listOpportunityTeamMember;        
        oppMem2 = TestingSetupDataUtil.createOpportunityTeamMember(userForOwnerChange.id ,'Inside Sales',Opp2.Id);
        
        //Test Account Insertion
        Recordtype recordId=[Select Id,Name from recordtype where Name='Partner'];
        Account newAccount=new Account(Name='TestAccountForTestClass',RecordTypeId=recordId.Id,ShippingCountry='India',ShippingPostalCode='2345645',ShippingState='Karnataka',ShippingStreet='Ecity');
        insert newAccount;
        newAccount.IsPartner=true;
        newAccount.Partner_Portal_Eligible__c=true;
        Update newAccount;
        
        //Test Contact Insertion 
        Contact contact1 = new Contact(FirstName = 'Test1',Lastname = 'Test1',AccountId = newAccount.Id,Email = System.now().millisecond() + 'test@hp.com');
        insert contact1;
                 
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr)
        {
        //Test Partner User Insertion
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Partner Sales Rep%' Limit 1]; 
        partnerUser = new User(Partner_Collaboration_Participating_User__c=true,ProfileId = portalProfile.id,ContactId=contact1.Id,LastName = 'pclmsavn', FirstName = 'pclmsavn', Username = 'pclmsavn@hp.com', Alias='pclms', CommunityNickname='pclmsavnApprove1', Email='pclmsavn@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='pclmsavn@hp.com',EmployeeNumber='65398661',Legacy_Employee_Ref__c='1587547');
        partnerUser.Adoption_Role_Type__c='Account Executive';
        Insert partnerUser;
        partnerUser.IsPortalEnabled=true;
        Update partnerUser;        
        }

        //Test Opportunity Insertion
         newOppty=new Opportunity(AccountId=acc.Id,ownerId=userTest.id,Name='Test Oppty',Managed_By__c='Hp',closedate=Date.today(),stagename='02 - Validate Opportunity',CurrencyIsoCode= 'USD');
        Insert newOppty;

        //Test Alliance and Channel Partner Insertion
        Channel_Partner__c newalliance=new Channel_Partner__c(Channel_Partner__c=newAccount.Id,Partner_Type__c='Alliance Partner',Partner_Account_Role__c='Implementer',Opportunity__c=newOppty.Id);
        Insert newalliance;
            
    }
    
    /**
    * @description: This method will does the code coverage for "OpportunityOwnerChangeController" class
    */

     private static testMethod void constructorTest(){
     
        Test.startTest();
        setupData();
        PageReference pref1 = Page.OpptyOwnerChange;
        pref1.getParameters().put('id',newOpp.id);
        Test.setCurrentPage(pref1);
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOpp);
        OpportunityOwnerChangeController ow=new OpportunityOwnerChangeController (stdController);
        ow.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
        ow.keepOptyTeamFlag=false;
        ow.sendEmailNotificationFlag=false;
        ow.save();
        
        OpportunityOwnerChangeController ow1=new OpportunityOwnerChangeController (stdController);
        ow1.opportunityTeamMemberList[0].teamMember.userId = newUSer.id;
        ow1.keepOptyTeamFlag=true;
        ow1.sendEmailNotificationFlag=true;
        ow1.save();
        
        pref1.getParameters().put('id',opp2.id);
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(opp2);
        OpportunityOwnerChangeController ow2=new OpportunityOwnerChangeController (stdController1);
        ow2.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
        ow2.keepOptyTeamFlag=false;
        
        OpportunityTeamMember oppTeamMember1 =new OpportunityTeamMember();
        oppTeamMember1.OpportunityId=opp2.Id;
        oppTeamMember1.TeamMemberRole='Inside Sales';
        oppTeamMember1.UserId=newUser.Id;
        insert oppTeamMember1 ;
        
       /* OpportunityShare newShareRec = new OpportunityShare();       
        newShareRec.opportunityId = opp2.Id;
        newShareRec.UserOrGroupId = userTest.Id;         
        newShareRec.OpportunityAccessLevel='Read';
        
        insert newShareRec;  
        
        ow2.sendEmailNotificationFlag=true;        
        ow2.save();*/
                   
        Test.stopTest();
    }

           
    /**
    * @description: This method does the code coverage for OpportunityOwnerChangeExtn class 
    *               when the keepOptyTeamFlag is true
    */
    
    private static testMethod void OpportunityOwnerChangeExtnTest3(){
     
        Test.startTest();
        setupData();
        PageReference pref1 = Page.OpptyOwnerChange;
        pref1.getParameters().put('id',newOppty.id);
        Test.setCurrentPage(pref1);
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOppty);
        OpportunityOwnerChangeController ow=new OpportunityOwnerChangeController (stdController);
        ow.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
        ow.keepOptyTeamFlag=false;
        ow.sendEmailNotificationFlag=false;
        ow.save();
        
        system.runas(userForOwnerChange){
        OpportunityOwnerChangeController ow1=new OpportunityOwnerChangeController (stdController);
        ow1.opportunityTeamMemberList[0].teamMember.userId = newUSer.id;
        ow1.keepOptyTeamFlag=true;
        ow1.sendEmailNotificationFlag=true;
        ow1.isOwnerSTMember= false; 
        newOppty.ownerId=partneruser.id;
        Update newOppty;
        ow1.opportunityTeamMemberList[0].teamMember.userId = partneruser.id;
        ow1.save();                       
        Test.stopTest();
        } 
    }   
        
    /**
    * @description: This method does the code coverage for OpportunityOwnerChangeExtn class 
    *               when the keepOptyTeamFlag is false
    */  
        
    private static testMethod void OpportunityOwnerChangeExtnTest1(){
     
        Test.startTest();
        setupData();
        PageReference pref1 = Page.OpptyOwnerChange;
        pref1.getParameters().put('id',newOppty.id);
        Test.setCurrentPage(pref1);
        ApexPages.StandardController stdController = new ApexPages.StandardController(newOppty);
        OpportunityOwnerChangeController ow=new OpportunityOwnerChangeController (stdController);
        ow.opportunityTeamMemberList[0].teamMember.userId = userTest.id;
        ow.keepOptyTeamFlag=false;
        ow.sendEmailNotificationFlag=false;
        ow.save();
        
        system.runas(userForOwnerChange){
        OpportunityOwnerChangeController ow1=new OpportunityOwnerChangeController (stdController);
        ow1.opportunityTeamMemberList[0].teamMember.userId = newUSer.id;
        ow1.keepOptyTeamFlag=false;
        ow1.sendEmailNotificationFlag=true;
        ow1.isOwnerSTMember= true; 
        newOppty.ownerId=partneruser.id;
        Update newOppty;
        ow1.opportunityTeamMemberList[0].teamMember.userId = partneruser.id;
        ow1.save();                           
        Test.stopTest();
        }
        }  
       
         
}