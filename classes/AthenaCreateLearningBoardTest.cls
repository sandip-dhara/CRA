@isTest
public class AthenaCreateLearningBoardTest
{
    static testMethod void CreateLearningBoardTest(){
        
        //Fetch the profile Id        
        Profile ProfITAdm = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User CrtLBUsr = new User(Alias = 'CrtLBUsr', Email='CrtLBUsr@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='CrtLBUsr@hp.com',LastName='CrtLBUsr', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfITAdm.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CrtLBUsr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881');
        insert CrtLBUsr;
        
        /*Profile p1 = [SELECT Id FROM Profile WHERE Name='Customer Ops']; 
        
        User utest1 = new User(Alias = 'lbdetail', Email='lbdetail@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='lbdetail@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='lbdetail@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert utest1;
        
        system.runas (utest1){
            AthenaCreateLearningBoard CrtLrngBrd1=new AthenaCreateLearningBoard();
            string strsfIns1=CrtLrngBrd1.getSfInstance;
            User usr1=CrtLrngBrd1.GetLoggedinUserDtls();
            boolean b1 = CrtLrngBrd1.IsLearningBoardCreator;
            SLP_Exception SLP = new SLP_Exception();
            SLP.main();
        }*/
        
        System.runAs(CrtLBUsr)
        {
            list<Tag__c> tags = new list<Tag__c>();
            Tag__c tag1 = new Tag__c();
            Tag__c tag2 = new Tag__c();
            tag1.value__c = 'Test Tag1';
            tags.add(tag1);
            tag2.value__c = 'Test Tag2';
            tags.add(tag2);
            insert tags;  
            
            //Application_Setting__c Data
            Application_Setting__c appstng = new Application_Setting__c();
            appstng.name__c = AthenaUtility.LearningBoardDefaultImages;
            appstng.value__c='DefaultImageName1.jpg,DefaultImageName2.jpg';
            appstng.Is_Active__c=true;
            insert appstng;
            
            AthenaCreateLearningBoard CrtLrngBrd=new AthenaCreateLearningBoard();
            string strsfIns=CrtLrngBrd.getSfInstance;
            String StrStimgpath = CrtLrngBrd.getStaticImagePath;
            User usr=CrtLrngBrd.GetLoggedinUserDtls();
            boolean b = CrtLrngBrd.IsLearningBoardCreator;
            List<SelectOption> lstslctOpt=CrtLrngBrd.DefaultImagefilename;
            
            CrtLrngBrd.LBName='CrtLBTestName';
            CrtLrngBrd.LBDescription='CrtLBTestDesc';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='option2';
            crtLrngBrd.dropSelectedval='DefaultImageName2.jpg';
            PageReference pRef=CrtLrngBrd.CreateLrngBrd();            
            
            CrtLrngBrd.LBName='CrtLBTestName4Att';
            CrtLrngBrd.LBDescription='CrtLBTestName4AtttDesc';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='option1';
            crtLrngBrd.dropSelectedval='';
            Blob bodyblob = Blob.valueOf('Unit Test Attachment Body');        
            CrtLrngBrd.LBattach =new Attachment(Body=bodyblob,ContentType='image/jpeg',name='test att');
            PageReference pRef1=CrtLrngBrd.CreateLrngBrd(); 
             
                        
            CrtLrngBrd.LBName='CrtLBTestName4defaultimg';
            CrtLrngBrd.LBDescription='CrtLBTestDesc4defaultimg';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optDefaultImage';
            crtLrngBrd.dropSelectedval='';
            PageReference pRef2=CrtLrngBrd.CreateLrngBrd();
            
            CrtLrngBrd.LBName='CrtLBTestName4defaultimg1';
            CrtLrngBrd.LBDescription='CrtLBTestDesc4defaultimg1';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optDefaultImage';
            crtLrngBrd.dropSelectedval='test';
            PageReference pRef3=CrtLrngBrd.CreateLrngBrd();
            
            CrtLrngBrd.LBName='CrtLBTestName4Browseimg';
            CrtLrngBrd.LBDescription='CrtLBTestDesc4Browseimg';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optBrowseImage';
            crtLrngBrd.dropSelectedval='';
            PageReference pRef4=CrtLrngBrd.CreateLrngBrd();
            
            CrtLrngBrd.LBName='CrtLBTestName4Browseimg1';
            CrtLrngBrd.LBDescription='CrtLBTestDesc4Browseimg1';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optBrowseImage';
            crtLrngBrd.dropSelectedval='';
            Blob bodyblob1 = Blob.valueOf('Unit Test Attachment Body');        
            CrtLrngBrd.LBattach =new Attachment(Body=bodyblob,ContentType='image/jpeg',name='Dummy Attachment');
            PageReference pRef5=CrtLrngBrd.CreateLrngBrd();
            
            //started by murali
            CrtLrngBrd.LBName='CrtLBTest4noimg';
            CrtLrngBrd.LBDescription='CrtLBTestDesc';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optDefaultImage';            
            PageReference pRef6=CrtLrngBrd.CreateLrngBrd();
            
            CrtLrngBrd.LBName='CrtLBTestName';
            CrtLrngBrd.LBDescription='CrtLBTestDesc';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='optDefaultImage'; 
            crtLrngBrd.dropSelectedval='DefaultImageName2.jpg';           
            PageReference pRef7=CrtLrngBrd.CreateLrngBrd();   
            
            CrtLrngBrd.LBName='CrtLBTest4noimg';
            CrtLrngBrd.LBDescription='CrtLBTestDesc';
            CrtLrngBrd.hdnCheckActive=true;
            CrtLrngBrd.hdnCheckFeatured=false;
            CrtLrngBrd.hdnAddTag='\'av\'' + ',' + '\'asdas\'' + ',';
            crtLrngBrd.optSelected='option2';            
            PageReference pRef8=CrtLrngBrd.CreateLrngBrd();
                     
            AthenaCreateLearningBoard search = new AthenaCreateLearningBoard();
            search.strSearchValue = 'test';
            search.doSearch();            
            search.RedirectToSLP_GlobalSearch();
            
            List<learning_Board_template__c> LCategory=new List<learning_Board_template__c>();
            Learning_Board_Template__c lbt = new Learning_Board_Template__c();
            lbt.Description__c='murali test desc';
            lbt.Is_Active__c=true;
            lbt.Name__c='murali test name';
            insert lbt;
            search.getLBcategories(); 
            Lcategory=[select name__c from learning_Board_template__c];
            for(learning_Board_template__c lc : Lcategory){
                AthenaCreateLearningBoard.GetLearningBoardCategories(lc.name__c);
            }
            //ended by murali            
        }
    }
}