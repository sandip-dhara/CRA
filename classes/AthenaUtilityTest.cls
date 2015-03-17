@isTest
public class AthenaUtilityTest{
    static testMethod void UtilityTest(){
        
        //Fetch the profile Id        
        Profile ProfITAdm = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User UtilityUsr = new User(Alias = 'UtltyUsr', Email='UtilityUsr@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='UtilityUsr@hp.com',LastName='UtilityUsr', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfITAdm.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='UtilityUsr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881');
        insert UtilityUsr;
        
        System.runAs(UtilityUsr)
        {
            
            //Application_Setting__c Data
            Application_Setting__c appstng = new Application_Setting__c();
            appstng.name__c = 'DefaultImageName';
            appstng.value__c='DefaultImageName.jpg';
            appstng.Is_Active__c=true;
            insert appstng;
            string appStngVal = AthenaUtility.ApplicationSettingValue('DefaultImageName');
            string appStngValforEmpty = AthenaUtility.ApplicationSettingValue('AthenaUtility');
            // Tag__c data
            list<Tag__c> tags = new list<Tag__c>();
            Tag__c tag1 = new Tag__c();
            Tag__c tag2 = new Tag__c();
            tag1.value__c = 'Test Tag1';
            tags.add(tag1);
            tag2.value__c = 'Test Tag2';
            tags.add(tag2);
            insert tags;  
            
            string AvlbleTags = AthenaUtility.getAvailableTags();
            
            Learning_board__C lrngBrd= new Learning_board__C(Name__c='LB1',Is_Active__c=True,Description__c='test description',featured__c=false);
            insert lrngBrd;

            List<string> taglst=new List<string>();
            taglst.add('BMI');
            taglst.add('.Net');
            AthenaUtility.AssociateTags(taglst,AthenaUtility.LearningBoard,lrngBrd.id);
            taglst=AthenaUtility.getAssociatedTags(AthenaUtility.LearningBoard,lrngBrd.id); 
            taglst.clear();
            AthenaUtility.AssociateTags(taglst,AthenaUtility.LearningBoard,lrngBrd.id);
        
            List<string> taglst1=new List<string>(); 
            taglst1.add('BMI');         
            taglst1.add('HP Anywhere');
            AthenaUtility.AssociateTags(taglst1,AthenaUtility.LearningBoard,lrngBrd.id);    
                           
        }
    }
}