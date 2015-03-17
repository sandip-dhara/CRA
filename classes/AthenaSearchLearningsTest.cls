@isTest
public class AthenaSearchLearningsTest{
     public static testMethod void SearchLearningsTest(){
         Test.startTest();
        
        //Inserting test profile and test user Standard User
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        User utest = new User(Alias = 'lbdetail', Email='lbdetail@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='lbdetail@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='lbdetail@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert utest;
        
        
        system.runas(utest)
        {
            
            //inserting 1st learning
            Learning__c l1= new Learning__c(Name__c='testll',Description__c='test description1',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.google.com');
            insert l1;
            //inserting Tag for learning 1
            Tag__c  lrngT1 = new Tag__c(Value__c='Learning');
            insert lrngT1;
            
            //inserting Tag Item for learning 1
            Tag_Item__c LrngTI1 = new Tag_Item__c(Item_Name__c='Learning',Tag_ID__c=lrngT1.Id,Item_Identifier__c=l1.id);
            insert LrngTI1;
            AthenaSearchLearnings ASL = new AthenaSearchLearnings(); 
            ApexPages.StandardsetController stc = ASL.MyLrngsCon;
            //inserting Learning 2
            Learning__c l2= new Learning__c(Name__c='testl2',Description__c='test description2',Is_Active__c=true,Type__c='Video',
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
            
            Blob bodyblobLB = Blob.valueOf('Unit Test Attachment Body Learning');
            Attachment atL=new Attachment(Body=bodyblobLB,ContentType='image/jpeg',name='test att',ParentId=l1.id);
            insert atL;
                
           
            ASL.GetLoggedinUserDtls();
            ASL.ShowSearchLrng=false;
            
            List <AthenaSearchLearnings.LearningDtlsCustomClass> LDtls= ASL.MyLearningsList;
            
            
            ASL.ShowSearchLrng=false;
            stc = ASL.MyLrngsCon;
            ASL.strSearchValue= 'Cloud';
            ASL.hdnfiltertype = 'ALL,DL';
            ASL.ShowSearchLrng=true;
            stc = ASL.MyLrngsCon;
            
            
            ASL.searchLearning();
            
            stc = ASL.MyLrngsCon;
            boolean b  =ASL.CheckAddLearning;
            
            ASL.LrngFilter();
            string str = ASL.getSfInstance;
            ASL.MyLrngsNext();
            ASL.MyLrngsPrevious();          
            ASL.LearningDetails();
            List<string> strlst = new List<string>();
            strlst=ASL.FetchAssociatedTags(l1.id);
            ASL.dosearch();
            ASL.strSearchValue ='';
            ASL.LrngFilter();
            ASL.searchLearning();
            
        }
        
        
        
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Customer Ops'];
        utest.ProfileId = p1.id;
        update utest;
        system.runas(utest){
            AthenaSearchLearnings ASL = new AthenaSearchLearnings();
            boolean b = ASL.CheckAddLearning;
        }
    }
}