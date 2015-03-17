@isTest
public class AthenaSocialLearningTest {
    
    static testMethod void SocialLearningTest() 
    {
        Test.startTest();
        //Fetch the profile Id
        Profile ITADM= [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User SLUser1 = new User(Alias = 'SLUser1', Email='SLUser1@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='SLUser1@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ITADM.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='SLUser1@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert SLUser1;
        
        Profile CustOps = [SELECT Id FROM Profile WHERE Name='Customer Ops'];
        
        User SLUser2 = new User(Alias = 'SLUser2', Email='SLUser2@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='SLUser2@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = CustOps.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='SLUser2@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998885');
        insert SLUser2;
        
        system.runas(SLUser1){
            //inserting Learning 1
            Learning__c l1=new Learning__c(Name__c='LB1',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                           URL__c='www.google.com');
            insert l1;
            
            //inserting Attachment for Learning 1
            Blob bodyblobLrng1 = Blob.valueOf('Unit Test Attachment Body Lrng1');
            
            Attachment atlrng1=new Attachment(Body=bodyblobLrng1,ContentType='image/jpeg',name='test att lrng',ParentId=l1.id);
            insert atlrng1;
            
            //inserting Liked Item for Learning 1
            Liked_Item__c lrnglitem1= new Liked_Item__c(Name='Learning Borad liked item',Item_Identifier__c=l1.id,Item_Name__c=l1.Name__c);
            insert lrnglitem1;
            
            //Insert User Liked Item for Learning 1
            User_Liked_Item__c l1ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrnglitem1.id,User_ID__c=SLUser1.ID);
            insert l1ulitem;
            
            //inserting Tag for learning 1
            Tag__c  lrngT1 = new Tag__c(Value__c='LB1');
            insert lrngT1;
            
            //inserting Tag Item for learning 1
            Tag_Item__c LrngTI1 = new Tag_Item__c(Item_Name__c='Learning',Tag_ID__c=lrngT1.Id,Item_Identifier__c=l1.id);
            insert LrngTI1;
            
            /*//inserting Learning 2       
            Learning__c l2=new Learning__c(Name__c='pdf',Description__c='pdf test description',Is_Active__c=true,Type__c='Other',
                                           URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/4/c04030034.pdf');
            insert l2;
            
            //inserting attachment for learning 2
            Blob bodyblobLrng2 = Blob.valueOf('Unit Test Attachment Body Lrng2');
            
            Attachment atlrng2=new Attachment(Body=bodyblobLrng2,ContentType='image/jpeg',name='test att lrng2',ParentId=l2.id);
            insert atlrng2;
            
            //inserting Liked Item for Learning 2
            Liked_Item__c lrnglitem2= new Liked_Item__c(Name='Learning Borad liked item',Item_Identifier__c=l2.id,Item_Name__c=l2.Name__c);
            insert lrnglitem2;
            
            //Insert User Liked Item for Learning 2
            User_Liked_Item__c l2ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrnglitem2.id,User_ID__c=SLUser2.ID);
            insert l2ulitem;
            
            //inserting Tag for learning 2
            Tag__c  LrngT2 = new Tag__c(Value__c='tagedforLearning2');
            insert LrngT2;
            
            //inserting Tag Item for learning 2
            Tag_Item__c LrngTI2 = new Tag_Item__c(Item_Name__c='LB1',Tag_ID__c=LrngT2.Id,Item_Identifier__c=l2.id);
            insert LrngTI2; */
            
            //inserting learning Board 1                     
            Learning_Board__c lb1 = new Learning_Board__c(Name__c='LB1',Is_Active__c=True,Description__c='test description1',featured__c=false);
            insert lb1;
            
            Blob bodyblobLrngBrd1 = Blob.valueOf('Unit Test Attachment Body Lrng1');
            
            Attachment atlrngBrd1=new Attachment(Body=bodyblobLrngBrd1 ,ContentType='image/jpeg',name='test att lrng',ParentId=lb1.id);
            insert atlrngBrd1;
            
            //inserting like Item for Learning Board 1
            Liked_Item__c lrngBrdlitem1= new Liked_Item__c(Name='Learning Borad liked item1',Item_Identifier__c=lb1.id,Item_Name__c='Learning Board');
            insert lrngBrdlitem1;
            
            //Insert User Liked Item for Learning Board 1
            User_Liked_Item__c lb1ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrngBrdlitem1.id,User_ID__c=SLUser1.ID);
            insert lb1ulitem;
            
            //inserting comment for Learning Board 1
            FeedItem LBFI1 = new FeedItem(parentId = lb1.id,Body='This is comment through test code1');
            insert LBFI1;
            
            //inserting tag for Learning Board 1
            Tag__c  LBT1 = new Tag__c(Value__c='tagedforLearningBoard1');
            insert LBT1;
            
            //inserting Tag Item for Learning Board 1
            Tag_Item__c LBTI1 = new Tag_Item__c(Item_Name__c='Learning_Board',Tag_ID__c=lrngT1.Id,Item_Identifier__c=lb1.id);
            insert LBTI1;
            
            //inserting learning Board 2                     
            Learning_Board__c lb2 = new Learning_Board__c(Name__c='LB2',Is_Active__c=false,Description__c='test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2',featured__c=false);
            insert lb2;
            
            //inserting like Item for Learning Board 2
            Liked_Item__c lrngBrdlitem2= new Liked_Item__c(Name='Learning Borad liked item2',Item_Identifier__c=lb2.id,Item_Name__c=lb2.Name__c);
            insert lrngBrdlitem2;
            
            //Insert User Liked Item for Learning Board 2
            User_Liked_Item__c lb2ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrngBrdlitem2.id,User_ID__c=SLUser2.ID);
            insert lb2ulitem;
            
            //inserting comment for Learning Board 2
            FeedItem LBFI2 = new FeedItem(parentId = lb2.id,Body='This is comment through test code2');
            insert LBFI2;
            
            //inserting tag for Learning Board 2
            Tag__c  LBT2 = new Tag__c(Value__c='tagedforLearningBoard2');
            insert LBT2;
            
            //inserting Tag Item for Learning Board 2
            Tag_Item__c LBTI2 = new Tag_Item__c(Item_Name__c='Learning_Board',Tag_ID__c=LBT2.Id,Item_Identifier__c=lb2.id);
            insert LBTI2;
            
             //inserting learning Board 3                     
            Learning_Board__c lb3 = new Learning_Board__c(Name__c='LB3',Is_Active__c=True,Description__c='test description3 test description3 test description3 test description3 test description3 test description3 test description3 test description3 test description3 test description3',featured__c=true);
            insert lb3;
            
            /*//inserting like Item for Learning Board 3
            Liked_Item__c lrngBrdlitem3= new Liked_Item__c(Name='Learning Borad liked item3',Item_Identifier__c=lb3.id,Item_Name__c=lb3.Name__c);
            insert lrngBrdlitem3;
            
            //Insert User Liked Item for Learning Board 3
            User_Liked_Item__c lb3ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrngBrdlitem3.id,User_ID__c=SLUser2.ID);
            insert lb3ulitem;
            
                        
            //inserting comment for Learning Board 3
            FeedItem LBFI3 = new FeedItem(parentId = lb3.id,Body='This is comment through test code3');
            insert LBFI3;
            
            //inserting tag for Learning Board 3
            Tag__c  LBT3 = new Tag__c(Value__c='tagedforLearningBoard3');
            insert LBT3;
            
            //inserting Tag Item for Learning Board 3
            Tag_Item__c LBTI3 = new Tag_Item__c(Item_Name__c='Learning_Board',Tag_ID__c=LBT3.Id,Item_Identifier__c=lb3.id);
            insert LBTI3;*/
            
            //inserting Learning Board Learning to map learning 1 and learning board 1
            Learning_Board_Learning__c LBL1 = new Learning_Board_Learning__c(Learning_Board_ID__c=lb1.id,Learning_ID__c=l1.id,Display_Sequence_Nbr__c=1);
            insert LBL1;
                        
            /*//inserting Learning Board Learning to map learning 2 and learning board 2
            Learning_Board_Learning__c LBL2 = new Learning_Board_Learning__c(Learning_Board_ID__c=lb2.id,Learning_ID__c=l2.id,Display_Sequence_Nbr__c=2);
            insert LBL2;*/
            
            //inserting Related Learning Board to Map Learning Board 1 and Learning Board 2
            Related_Learning_Board__c RLB1 = new Related_Learning_Board__c(Learning_Board_ID__c=lb1.id,Related_Learning_Board_ID__c=lb2.id,Display_Sequence_Nbr__c=1);
            Insert RLB1;
            
            application_setting__c ASV1 = new application_setting__c();
            ASV1.Value__c = '30';
            ASV1.Name__C = AthenaUtility.MostLikedTrendDays;
            ASV1.Is_Active__c = true;
            insert ASV1;
            
            application_setting__c ASV2 = new application_setting__c();
            ASV2.Value__c = '30';
            ASV2.Name__C = AthenaUtility.MostCommentedTrendDays;
            ASV2.Is_Active__c = true;
            insert ASV2;
            
            //Instantiate AthenaSLUserProfile      
            AthenaSocialLearning sclLrng=new AthenaSocialLearning(); 
            AthenaSocialLearning.LikedItemCounts(SLUser1.id);       
            string sfins=sclLrng.getSfInstance;    
            User lgdinUsr=sclLrng.GetLoggedinUserDtls();          
            AthenaSocialLearning.GetSearchLB(1,-1,-2,'LB1');
            AthenaSocialLearning.GetPersonalizedLB(3,-1,-1);
            AthenaSocialLearning.GetFeaturedLB(7,-1,-2);
            AthenaSocialLearning.GetMostLikedTrends(-1,-1,-1);
            AthenaSocialLearning.GetMostCommentedTrends(-1,-1,-1);
            
        }
        
        Profile ESBSPROF = [SELECT Id FROM Profile WHERE Name='ES BASE PROFILE']; 
        SLUser1.ProfileId= ESBSPROF.id;
        Update SLUser1;
        
        system.runas(SLUser1){
            AthenaSocialLearning.IsModerator(SLUser1.id);
            AthenaSocialLearning.Isproducer(SLUser1.id);
        }
        
        PermissionSet ESProducerPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Producer'];
        PermissionSetAssignment ProdPermSetAssgn= new PermissionSetAssignment();
        ProdPermSetAssgn.PermissionSetId = ESProducerPermSet.id;
        ProdPermSetAssgn.AssigneeId = SLUser1.id;        
        insert ProdPermSetAssgn;
        
        system.runas(SLUser1){
            AthenaSocialLearning.IsProducer(SLUser1.id);            
        }
        
        delete ProdPermSetAssgn;
        PermissionSet ESModeratorPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Moderator'];
        PermissionSetAssignment ModPermSetAssgn= new PermissionSetAssignment();
        ModPermSetAssgn.PermissionSetId = ESModeratorPermSet.id;
        ModPermSetAssgn.AssigneeId = SLUser1.id;        
        insert ModPermSetAssgn;
        
        system.runas(SLUser1){
            AthenaSocialLearning.IsModerator(SLUser1.id);            
        }
        
        system.runas(SLUser2){
            AthenaSocialLearning.IsModerator(SLUser2.id); 
            AthenaSocialLearning.GetPersonalizedLB(4,5,6);           
        }
        
        Test.stopTest();        
    }
}