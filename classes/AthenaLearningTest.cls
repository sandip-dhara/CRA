@isTest
public class AthenaLearningTest{
     public static testMethod void LearningTest(){
         Test.startTest();
        
        //Inserting test profile and test user Standard User
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        User utest = new User(Alias = 'lbdetail', Email='lbdetail@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='lbdetail@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='lbdetail@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998877');
        insert utest;
        
        system.runas(utest)
        {
            
            //inserting 1st learning
            Learning__c l1= new Learning__c(Name__c='Cloud Data',Description__c='test description1',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.google.com');
            insert l1;
            Learning__c l2= new Learning__c(Name__c='Cloud Data1',Description__c='test description2',Is_Active__c=true,Type__c='Video',
                                       URL__c='http://www.youtube.com/watch?v=8XqO-wWUwNk');
            insert l2;
            Learning__c l3= new Learning__c(Name__c='testl3',Description__c='test description3',Is_Active__c=true,Type__c='other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/ww2/wg/gse/Documents/PAT/Portfolio_Alignment_Guide_ECS_VPC_v5.6.docx');
            insert l3;
            Learning__c l4= new Learning__c(Name__c='testl4',Description__c='test description4',Is_Active__c=true,Type__c='other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/7/c04025987.pptx');
            insert l4;
            Learning__c l5 = new Learning__c(Name__c='testl5',Description__c='test description5',Is_Active__c=true,Type__c='other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/4/c04030034.pdf');
            insert l5;
            
            //inserting Learning Board
            
             Learning_board__C lb= new Learning_board__C(Name__c='test name',Is_Active__c=true,Description__c='test description');
            
            //inserting 1st Learning Board Learning
            //Learning_Board_Learning__c lbl1=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l1.id,Display_Sequence_Nbr__c=1);
            //insert lbl1;
            
            Blob bodyblobLB = Blob.valueOf('Unit Test Attachment Body Learning');
            Attachment atL=new Attachment(Body=bodyblobLB,ContentType='image/jpeg',name='test att',ParentId=l1.id);
            insert atL;
                
            AThenaLearning AL = new AThenaLearning();
            AL.MyLearnings();
            AL.LUID=utest.id;
            AL.MyLearnings();
            
            AL.SearchLearning('cloud');
            
        }
    }
}