@isTest
public class AthenaEditLearningBoardDtlsTest{  
    public static testMethod void EditLearningBoardDtlsTest(){
        Test.startTest();
        //Inserting test profile and test user Standard User
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        User utest = new User(Alias = 'elbdtl', Email='elbdtl@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='elbdtl@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='elbdtl@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert utest;
        
        system.runas(utest)
        {
            //Inserting a new learning board
            Learning_board__C lb= new Learning_board__C(Name__c='test name3',Is_Active__c=true,Description__c='test description1');
            insert lb;
            ApexPages.StandardController stc = new ApexPages.StandardController(lb);
            AthenaEditLearningBoardDtls AELBD = new AthenaEditLearningBoardDtls(stc);
            List <AthenaEditLearningBoardDtls.LearningDtlsCustomClass> ELDtls = AELBD.LearningDtls;
        }
        
        //system.runas(
        
    }
}