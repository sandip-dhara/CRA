@isTest
public class AthenaSearchLearningsPriya
{
     static testMethod void SearchLearningTest() 
     {
        Profile Profsys = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User ESsys = new User(Alias = 'ESsys', Email='ESsys@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='ESsys@hp.com',LastName='ESsys', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = Profsys.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ESsys@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998883');
        insert ESsys ;
        
        System.runAs(ESsys)
        { 
            AthenaSearchLearnings atser=new AthenaSearchLearnings();
            atser.GetLoggedinUserDtls();
            string str = atser.getSfInstance ;
            boolean bool = atser.CheckAddLearning;
            
        }
      }
}