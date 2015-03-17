@isTest
public class AthenaViewLearningTest
{
    public static testMethod void AthenaViewLearningTest() 
    {   
        Test.startTest();
        //Inserting test profile and test user 1
        Profile ITADUR= [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        User VLUser1= new User(Alias = 'VLUser1', Email='VLUser1@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='VLUser1@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ITADUR.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='VLUser1@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998889');
        insert VLUser1;
        
        //Inserting test profile and test user 2        
        Profile CustOps = [SELECT Id FROM Profile WHERE Name='Customer Ops'];
        
        User VLUser2= new User(Alias = 'VLUser2', Email='VLUser2@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='VLUser2@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = CustOps.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='VLUser2@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='97998889');
        insert VLUser2;
        
        system.runas(VLUser1){
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
        User_Liked_Item__c l1ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrnglitem1.id,User_ID__c=VLUser1.ID);
        insert l1ulitem;
        
        //inserting Tag for learning 1
        Tag__c  lrngT1 = new Tag__c(Value__c='LB1');
        insert lrngT1;
        
        //inserting Tag Item for learning 1
        Tag_Item__c LrngTI1 = new Tag_Item__c(Item_Name__c='Learning',Tag_ID__c=lrngT1.Id,Item_Identifier__c=l1.id);
        insert LrngTI1;
        
        //inserting PDF type Learning 2       
        Learning__c l2=new Learning__c(Name__c='pdf',Description__c='pdf test description',Is_Active__c=true,Type__c='Other',
                                                   URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/4/c04030034.pdf');
        insert l2;
        //inserting brainshark video type learning  3       
        Learning__c l3=new Learning__c(Name__c='Brainshark',Description__c='Brainshark test description',Is_Active__c=true,Type__c='Video',
                                                   URL__c='https://www.brainshark.com/HPLearning/VirPrivateCloud1');
        insert l3;  
        //inserting Youtube Video type learning 4
        Learning__c l4=new Learning__c(Name__c='Youtube',Description__c='Youtube test description',Is_Active__c=true,Type__c='Video',
                                                   URL__c='http://www.youtube.com/watch?v=8XqO-wWUwNk');
        insert l4;      
        
        //inserting PPT type Learning 5
        Learning__c l5=new Learning__c(Name__c='pptx',Description__c='pptx test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/7/c04025987.pptx');
        insert l5;
        
        //inserting DOC type Learning 6      
        Learning__c l6=new Learning__c(Name__c='docx',Description__c='docx test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/ww2/wg/gse/Documents/PAT/Portfolio_Alignment_Guide_ECS_VPC_v5.6.docx');
        insert l6; 
        Learning_Board__c lb1 = new Learning_Board__c(Name__c='LB1',Is_Active__c=True,Description__c='test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1 test description1',featured__c=false);
        insert lb1;
        
        Blob bodyblobLrngBrd1 = Blob.valueOf('Unit Test Attachment Body Lrng1');
        
        Attachment atlrngBrd1=new Attachment(Body=bodyblobLrngBrd1 ,ContentType='image/jpeg',name='test att lrng',ParentId=lb1.id);
        insert atlrngBrd1;
        
        //inserting like Item for Learning Board 1
        Liked_Item__c lrngBrdlitem1= new Liked_Item__c(Name='Learning Borad liked item1',Item_Identifier__c=lb1.id,Item_Name__c='Learning Board');
        insert lrngBrdlitem1;
        
        //Insert User Liked Item for Learning Board 1
        User_Liked_Item__c lb1ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrngBrdlitem1.id,User_ID__c=VLUser1.ID);
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
        Learning_Board__c lb2 = new Learning_Board__c(Name__c='LB2',Is_Active__c=false,Description__c='test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2 test description2',featured__c=false);
        insert lb2;
        
        //inserting like Item for Learning Board 2
        Liked_Item__c lrngBrdlitem2= new Liked_Item__c(Name='Learning Borad liked item2',Item_Identifier__c=lb2.id,Item_Name__c=lb2.Name__c);
        insert lrngBrdlitem2;
        
        //Insert User Liked Item for Learning Board 2
        User_Liked_Item__c lb2ulitem= new User_Liked_Item__c(Liked_Item_ID__c=lrngBrdlitem2.id,User_ID__c=VLUser2.ID);
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
        
        //inserting Learning Board Learning to map learning 1 and learning board 1
        Learning_Board_Learning__c LBL1 = new Learning_Board_Learning__c(Learning_Board_ID__c=lb1.id,Learning_ID__c=l1.id,Display_Sequence_Nbr__c=1);
        insert LBL1;
        
        AthenaViewLearning AVL = new AthenaViewLearning();
        AVL.LearningId = l1.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC=AVL.LearningDtls;
        List<AthenaViewLearning.RelatedLearningBoardCustomClass> AVLRLBCC=new List<AthenaViewLearning.RelatedLearningBoardCustomClass>();    
        AVLRLBCC= AVL.RelatedLearningBoards;
        
        List<string> LstStr = AVL.AssociatedTags;
        String Str= AVL.getSfInstance;
        AVL.GetLoggedinUserDtls();
        AVL.getLearningOwnerDtls();
       
        Boolean b = AVL.IsOwner;
        str= AVL.getSfInstance;
        integer i = AVL.LrngOwnerLikeCount;
        i = AVL.LrngOwnerCommentCount;
        AVL.dosearch();

        AVL.LearningId = l2.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC2=AVL.LearningDtls;
        i = AVL.LrngOwnerLikeCount;
        
        AVL.LearningId = l3.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC3=AVL.LearningDtls;

        AVL.LearningId = l4.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC4=AVL.LearningDtls;
        
        AVL.LearningId = l5.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC5=AVL.LearningDtls;
        
        AVL.LearningId = l6.id;
        AthenaViewLearning.LearningDtlsCustomClass LDCC6=AVL.LearningDtls;
        
        Test.stopTest();
        } 
        
        system.runas(VLUser2){
            AthenaViewLearning AVL = new AthenaViewLearning();
            Boolean b= AVL.IsOwner;
        }
        
        Profile ESBSPR = [SELECT Id FROM Profile WHERE Name='ES BASE PROFILE'];
        VLUser1.ProfileId=ESBSPR.id;
        Update VLUser1;
                      
        PermissionSet ESProducerPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Producer'];
        PermissionSetAssignment ProdPermSetAssgn= new PermissionSetAssignment();
        ProdPermSetAssgn.PermissionSetId = ESProducerPermSet.id;
        ProdPermSetAssgn.AssigneeId = VLUser1.id;        
        insert ProdPermSetAssgn;
        
        system.runas(VLUser1){
            AthenaViewLearning AVL = new AthenaViewLearning();
            Learning__c l7=new Learning__c(Name__c='LB7',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.google.com');
            insert l7;
            AVL.LearningId = l7.id;
            Boolean b= AVL.IsOwner;
        }
        
        delete ProdPermSetAssgn;
        PermissionSet ESModeratorPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Moderator'];
        PermissionSetAssignment ModPermSetAssgn= new PermissionSetAssignment();
        ModPermSetAssgn.PermissionSetId = ESModeratorPermSet.id;
        ModPermSetAssgn.AssigneeId = VLUser1.id;        
        insert ModPermSetAssgn;
        
        system.runas(VLUser1){
            AthenaViewLearning AVL = new AthenaViewLearning();
            Boolean b= AVL.IsOwner;
        }
    }
}