@isTest
private class  ABPOwnerChangeControllerTest{

    static testMethod void myTest() 
    {
        Account acc = new Account(Name='testacc1',Source_System_Account_ID__c='56544565');
        insert acc ;  
        Account_Plan__c newAP = new Account_Plan__c(Name='Sample Account plan',Primary_AccountAccount__c=acc.id);
        insert newAP;
        
       Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
       Profile p1 = [SELECT Id FROM Profile WHERE Name='Sales Rep']; 
       User u = new User(Alias = 'standt', Email='standarduser@hp.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id,Legacy_Employee_Ref__c='********',Email_Address__c ='qwert@hp.com',Business_Group__c ='IPG',
       TimeZoneSidKey='America/Los_Angeles', UserName='standarduser01a@testorg.com',Adoption_Role_Type__c='Account Executive'); 
       insert u;      
       
        List<Account_Plan__Share> shareList = new List<Account_Plan__Share>(); 
        Account_Plan__Share share = new Account_Plan__Share(); 
        share.AccessLevel = 'Read/Write';
        share.ParentId = newAp.id;
        share.RowCause = 'Manual';
        share.UserOrGroupId = u.id ;
        Account_Plan__Share share1 = new Account_Plan__Share(); 
        share1.AccessLevel = 'Read/Write';
        share1.ParentId = newAp.id;
        share1.RowCause = 'Manual';
        share1.UserOrGroupId = u.id ;
        shareList.add(share);
        shareList.add(share1);
        database.insert(shareList,false); 
        
        ABPOwnerChangeController abpOwner1 =  new ABPOwnerChangeController();
        abpOwner1.abpId=newAP.id;
        abpOwner1.accountPlanTeamMemberList = new List<ABPOwnerChangeController.AccountPlanTeamMemberClass>();
        abpOwner1.accountPlanTeamMemberList.add(new ABPOwnerChangeController.AccountPlanTeamMemberClass(newAP.id));
        abpOwner1.AcctPlanToUpdate = newAp;
        abpOwner1.oldOwnerID = u.id;
        for(Integer i=0;i<1;i++){        
         abpOwner1.accountPlanTeamMemberList.add(new ABPOwnerChangeController.AccountPlanTeamMemberClass(newAP.id));
        }
        abpOwner1.accShrs=shareList;
        abpOwner1.insertShareRecordsToNewOwner();
        abpOwner1.save();
        ApexPages.StandardController sc = new ApexPages.StandardController(newAP);
        ABPOwnerChangeController abpOwner = new ABPOwnerChangeController(sc);
    }
}