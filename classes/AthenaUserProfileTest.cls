@isTest
Public class AthenaUserProfileTest
{   
    static testMethod void UserProfileTest() 
    {
        //Fetch the profile Id        
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Creating Logged in User
        User Userprofile = new User(Alias = 'usrpfl', Email='usrpfl@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='usrpfl@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, Title = 'Test Coder',
        TimeZoneSidKey='America/Los_Angeles', UserName='usrpfl@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='2014512');
        insert Userprofile;
        
        Profile CustOps = [SELECT Id From Profile WHERE Name='Customer Ops'];
        
        //creating Learning Board Contributor
        User LBCont = new User(Alias = 'LBCont', Email='LBCont@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LBCont@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = CustOps.Id, Title='Test Coder',
        TimeZoneSidKey='America/Los_Angeles', UserName='LBCont@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='2014513');
        insert LBCont;
        
        system.runas(Userprofile){
            
            //Insert Learning Board    
            Learning_board__C lb1= new Learning_board__C(Name__c='LB1',Is_Active__c=True,Description__c='test description',featured__c=false,Default_Image_Name__c='Not Image');
            insert lb1;
             
            //Insert Learning Board    
            Learning_board__C lb2= new Learning_board__C(Name__c='LB2 greater than 35 characters LB greater than',Is_Active__c=True,Description__c='LB2 greater than 35 characters LB greater than',featured__c=false,Default_Image_Name__c='Not Image');
            insert lb2;
            
            //Insert Learning Board    
            Learning_board__C lb4= new Learning_board__C(Name__c='LB4 greater than 35 characters LB greater than',Is_Active__c=True,Description__c='LB2 greater than 35 characters LB greater than LB2 greater than 35 characters LB greater than',featured__c=false,Default_Image_Name__c='Not Image');
            insert lb4;
            
            //Insert Learning Board    
            Learning_board__C lb3= new Learning_board__C(Name__c='LB3 greater than 75 characters LB greater than 75 characters LB greater than 75',Is_Active__c=True,Description__c='test description3',featured__c=false,Default_Image_Name__c='Not Image');
            insert lb3;
              
            //inserting comment for Learning Board
            FeedItem LBFI1 = new FeedItem(parentId = lb1.id,Body='This is comment through test code',type='TextPost');
            insert LBFI1;
            
            //inserting Comment for Learning Board
            FeedItem LBFI2 = new FeedItem(parentId = lb1.id,Body='This is comment through test code1',type='TextPost');
            insert LBFI2;
            
            //inserting a user who is contributor
            Learning_Board__share lbs = new Learning_board__Share(ParentId=lb1.id, UserOrGroupId=LBCont.id, AccessLevel='Edit');
            insert lbs;
                
            //Insert Attachments    
            /*Blob bodyblob = Blob.valueOf('Unit Test Attachment Body');        
            Attachment at=new Attachment(Body=bodyblob,ContentType='image/jpeg',name='test att',ParentId=lb1.id);
            insert at;*/
            
            EntitySubscription ES = new EntitySubscription(ParentId =lb1.id, SubscriberId=LBCont.id);
            insert ES;
            
            //Insert Notification Event
            Notification_Event__c ne = new Notification_Event__c(Description__c='This is used for Rating a Learning Board',IsActive__c=true,Name__c='Rate Learning Board');
            insert ne;
            
            //Insert User Notification Subscription
            User_Notification_Subscription__c uns = new User_Notification_Subscription__c(Notification_Event_ID__c=ne.id,IsActive__c=true,Subscriber_User_ID__c=Userprofile.id);
            insert uns;  
                      
            //Insert Skill
            Skill__c sk=new Skill__c(Name__c='SFDC',Is_Active__c=true);
            insert sk;
                
            //Insert User Skill
            User_Skill__c usk=new User_Skill__c(Skill_ID__c=sk.id,User_ID__c=Userprofile.ID);    
            insert usk;                     
               
            AthenaUserProfile AUP = new AthenaUserProfile();
            AUP.AthenaUserId = LBCont.id;
            AUP.HeaderShareEmail='murali-krishna.chejerla@hp.com';
            AUP.ShareProfile();
            AUP.closePopup();
            AUP.showPopup();
            Boolean b = AUP.isloggedUser;
            AUP.GetprofileUser();
            AUP.GetLoggedinUserDtls();            

            List<skill__C> expertise = AUP.getExpertise();   
            AUP.RedirectToSLP_GlobalSearch();
            //List<AthenaUserProfile.LearningBoardCustomClass> uOwnLBLst=AUP.UserOwnedLBList;
            AUP.UserOwnedNext();
            AUP.UserconNext();
            AUP.UserOwnedPrevious();
            AUP.UserconPrevious();
            
            AUP.location();
            AUP.avgconrating();
            AUP.Socialconnect();
            AUP.isLoggedUser();
            AUP.CalculateTotalRatings();
            List<learning_Board__c> lblist = [select id,Name__c, Default_Image_Name__c,description__c, Owner.name,Owner.Title, Owner.Id, Featured__c,Is_Active__c,CreatedDate from Learning_Board__c];
            AUP.GetUserContLbList(lblist);
            AUP.GetUserOwnedLBList(lblist); 
            AUP.GetFollowers();
            boolean a =AUP.IsFollowOwner;
            AUP.RefreshMyNotifications();
            AUP.GetLBFollowingList();
            List<User> usrlist = new List<User>();
            usrlist=AUP.followg;
            AUP.editProfile();
            AUP.followOwner();
            AUP.unfollowOwner();
            AUP.isFollow();
            AUP.recoruserid=Userprofile.id;
            
            /*List<Project__c> Prjlist = new List<Project__c>();
            Prjlist = AUP.project;
            Boolean c = AUP.IsLearningBoardCreator;
            AUP.userid=LBCont.id;
            AUP.Followme();
            AUP.UnFollowme();*/
            /*
            GetUserContLbList(LearningBoardsContributed); 
            GetUserOwnedLBList(LearningBoardsOwned);
            
            recoruserid=ApexPages.currentPage().getParameters().get('id');  
            userid = userinfo.getuserid(); */
            
        }
    }
}