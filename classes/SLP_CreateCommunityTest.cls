@isTest
public class SLP_CreateCommunityTest
{
    static testMethod void CreateCommunityTest(){
        
        //Fetch the profile Id        
        Profile ProfITAdm = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User CrtLBUsr = new User(Alias = 'CrtLBUsr', Email='CrtLBUsr@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='CrtLBUsr@hp.com',LastName='CrtLBUsr', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfITAdm.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='CrtLBUsr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881');
        insert CrtLBUsr;
        
        system.runas (CrtLBUsr){
           
            SLP_CreateCommunity CrtCommunity=new SLP_CreateCommunity();
            string strsfIns=CrtCommunity.getSfInstance;
            String StrStimgpath = CrtCommunity.getStaticImagePath;
            User usr=CrtCommunity.GetLoggedinUserDtls();            
            List<SelectOption> lstslctOpt=CrtCommunity.DefaultImagefilename;
            CrtCommunity.ImageSelectionOption=Null;
            CrtCommunity.CommunityName='CrtCommTestName';
            CrtCommunity.CommunityDescription='CrtCommTestDesc';            
            PageReference pRef=CrtCommunity.CreateCommunity();   
            
            CrtCommunity.ImageSelectionOption='DI';
            CrtCommunity.CommunityName='CrtCommTestName1';
            CrtCommunity.CommunityDescription='CrtCommTestDesc1';            
            PageReference pRef1=CrtCommunity.CreateCommunity();   
            
            CrtCommunity.ImageSelectionOption='DI';
            CrtCommunity.CommunityName='CrtCommTestName2';
            CrtCommunity.CommunityDescription='CrtCommTestDesc2';            
            CrtCommunity.dropSelectedval='selectImage';
            PageReference pRef2=CrtCommunity.CreateCommunity();               
            
            CrtCommunity.ImageSelectionOption='UFC';
            CrtCommunity.CommunityName='CrtCommTestName3';
            CrtCommunity.CommunityDescription='CrtCommTestDesc3';            
            PageReference pRef3=CrtCommunity.CreateCommunity();
            
            CrtCommunity.ImageSelectionOption='UFC';
            CrtCommunity.CommunityName='CrtCommTestName4';
            CrtCommunity.CommunityDescription='CrtCommTestDesc4';                        
            Blob bodyblob = Blob.valueOf('Unit Test Attachment Body');        
            CrtCommunity.Communityattach =new Attachment(Body=bodyblob,ContentType='image/jpeg',name='test att');                     
            PageReference pRef4=CrtCommunity.CreateCommunity();
            
            CrtCommunity.ImageSelectionOption='DI';
            CrtCommunity.CommunityName='CrtCommTestName2';
            CrtCommunity.CommunityDescription='CrtCommTestDesc2';            
            CrtCommunity.dropSelectedval='selectImage';
            PageReference pRef5=CrtCommunity.CreateCommunity();
            
            Community__c c = new Community__c();
            c.name__c='CrtCommTestName1';
            insert c;
            PageReference pRef6=CrtCommunity.CreateCommunity();
            
            List<SelectOption> crimopt= CrtCommunity.getImageOptions();            
            CrtCommunity.strSearchValue = 'test';            
            CrtCommunity.RedirectToSLP_GlobalSearch();          
                      
        }
    }
}