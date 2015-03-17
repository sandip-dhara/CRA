@isTest
Public class ASLTest
{   
    static testMethod void SocialLearningTest() 
    {
        //Fetch the profile Id
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User LogInUser = new User(Alias = 'LogdUser', Email='LoggedInUser@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LoggedInUser@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='LoggedInUser@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert LogInUser;
        
        //Create Learning Board User
    	User LBOwner = new User(Alias = 'LBOwner', Email='LBOwner@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LBOwner@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='LBOwner@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998890');
        insert LBOwner;
        
        System.runAs(LBOwner)
        {
        //Insert Learning Board    
      	Learning_board__C lb= new Learning_board__C(Name__c='LB1',Is_Active__c=True,Description__c='test description',featured__c=false);
        insert lb;
            
        //Insert Attachments    
        Blob bodyblob = Blob.valueOf('Unit Test Attachment Body');        
        Attachment at=new Attachment(Body=bodyblob,ContentType='image/jpeg',name='test att',ParentId=lb.id);
        insert at;            
            
        //Insert Learning Board        
        lb= new Learning_board__C(Name__c='LongDesc',Is_Active__c=True,Description__c='test description test descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest descriptiontest description',featured__c=true);
        insert lb;       
       
        //Insert Liked Item for Learning Board    
        Liked_Item__c litem= new Liked_Item__c(Item_Identifier__c=lb.id,Item_Name__c='Learning Board');
        insert litem;
            
        //Insert User Liked Item for Learning Board        
        User_Liked_Item__c ulitem= new User_Liked_Item__c(Liked_Item_ID__c=litem.id,User_ID__c=LBOwner.ID);
        insert ulitem;
        
		
        //Instantiate AthenaUserProfile      
        AthenaSocialLearning sclLrng=new AthenaSocialLearning();        
        string sfins=sclLrng.getSfInstance;    
        User lgdinUsr=sclLrng.GetLoggedinUserDtls();          
          
         List<AthenaSocialLearning.LearningBoardCustomClass> lbcc= sclLrng.FeaturedLBList;             
         sclLrng.featuredNext();
         sclLrng.featuredPrevious();
         lbcc= sclLrng.PersonalizedLBList;
         sclLrng.perNext();
         sclLrng.perPrevious(); 
            
         sclLrng.ShowSearch=true;
         sclLrng.strSearchValue='LB1';
         lbcc=sclLrng.SearchResultLBList;
         sclLrng.searchNext();
         sclLrng.searchPrevious();  
            
        }
        
        
        System.runAs(LogInUser)
        { 
          PageReference pageRef = page.AthenaSocialLearning;
        	pageRef.getParameters().put('SearchVal','Cloud');  
            Test.setCurrentPage(pageRef);

          AthenaSocialLearning sclLrng=new AthenaSocialLearning();  
          sclLrng.ShowSearch=true;
          sclLrng.strSearchValue='Cloud';
          sclLrng.dosearch();  
            
        }        
    }
        
     
}