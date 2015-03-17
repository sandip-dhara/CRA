@isTest
Public class SLP_EditUserProfileControllerTest{
    Static TestMethod Void SLP_EditUserProfileControllerTest(){
    	//Fetch the profile Id        
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Creating Logged in User
        User Userprofile = new User(Alias = 'usrpfl', Email='usrpfl@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='usrpfl@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, Title = 'Test Coder',
        TimeZoneSidKey='America/Los_Angeles', UserName='usrpfl@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='2014512');
        insert Userprofile;
        
        Profile CustOps = [SELECT Id From Profile WHERE Name='Customer Ops'];
        
        //creating Learning Board Contributor
        User LBCont = new User(Alias = 'LBCont', Email='LBCont@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LBCont@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = CustOps.Id, Title='Test Coder',
        TimeZoneSidKey='America/Los_Angeles', UserName='LBCont@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='2014513');
        insert LBCont;
        
        system.runas(Userprofile){
        	//SLP_EditUserProfileController.AthenaUserId = Userprofile.id;
        	SLP_EditUserProfileController SLPEUserprofile = new SLP_EditUserProfileController();
    	}
        
        
    }

}