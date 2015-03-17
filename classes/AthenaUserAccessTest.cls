@isTest
Public class AthenaUserAccessTest
{   
    static testMethod void UserAccessTest() 
    {
        //Fetch the profile Id        
        Profile ITADMPR= [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User ATURACS= new User(Alias = 'ATURACS', Email='ATURACS@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='ATURACS@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ITADMPR.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ATURACS@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881');
        insert ATURACS;
        
        system.runas(ATURACS){
            AthenaUserAccess userAccess=new AthenaUserAccess();
            userAccess.IsModerator(ATURACS.id);   
            userAccess.IsProducer(ATURACS.id);
        }
        
        
    }
}