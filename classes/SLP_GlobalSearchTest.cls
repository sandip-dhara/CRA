@isTest
public class SLP_GlobalSearchTest{
    static testMethod void SLP_GlobalSearchTest(){
        //Fetch the profile Id        
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User LBUser = new User(Alias = 'LBUserAL', Email='LBUserAL@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LBUserAL@hp.com',LastName='LBUserAL', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='LBUserAL@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='77778840');        
        insert LBUser; 
        
        system.runas(LBUser){
            Learning_board__C LB= new Learning_board__C(Name__c='test name',Description__c='test',Sub_Title__c='test description', is_Active__c=true);
            insert LB;

            Tag__c T = new Tag__c();
            T.Value__c = 'Oil and gas';
            insert T;

            Tag_Item__c TI = new Tag_Item__c();
            TI.Item_Name__c= 'Learning_Board';
            TI.Tag_ID__c = T.id;
            TI.Item_Identifier__c = LB.id;
            insert TI;

            Learning__c L =new Learning__c(Name__c='testll',Description__c='test description',is_Active__c=true,url__c='abc.docx');
            insert L;

            Tag__c TL = new Tag__c();
            TL.Value__c = 'Test Class';
            insert TL;
            
            Tag_Item__c TIL = new Tag_Item__c();
            TIL.Item_Name__c= 'Learning';
            TIL.Tag_ID__c = TL.id;
            TIL.Item_Identifier__c = L.id;
            insert TIL;
                   
            Learning_Board_Learning__c LBL =new Learning_Board_Learning__c(Learning_Board_ID__c=LB.id,Learning_ID__c=L.id,Display_Sequence_Nbr__c=1);
            insert LBL;
            
            Community__c C = new Community__c(Name__c='test',Short_Description__c='test', IsActive__c=true);
            insert C;         
           
            Community_Category__c CC = new Community_Category__c(IsActive__c=true,Community_Id__c=C.Id);
            insert CC;
            
            Collateral__c CL = new Collateral__c(Name__c='test',Short_Description__c='test', IsActive__c=true,Community_Category_ID__c=CC.Id,URL__c='abc.pdf');
            insert CL;
            
            
            //
            // run test
            // 

            SLP_GlobalSearch search = new SLP_GlobalSearch();
            search.strSearchValue = 'test';
            search.doSearch();       
            
        
        }
    }
   
}