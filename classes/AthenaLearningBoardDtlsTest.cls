@isTest
public class AthenaLearningBoardDtlsTest
{   
    public static testMethod void LearningBoardDtlsTest() 
    {   
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
        
        //Inserting a new learning board
        
        Learning_board__C lb= new Learning_board__C(Name__c='test name',Is_Active__c=true,Description__c='test description');
        insert lb;
        
        Blob bodyblobLB = Blob.valueOf('Unit Test Attachment Body LB');
        
        Attachment atLB=new Attachment(Body=bodyblobLB,ContentType='image/jpeg',name='test att',ParentId=lb.id);
        insert atLB;    
            
        //Inserting a new learning 
        
        Learning__c l1=new Learning__c(Name__c='testll',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.google.com');
        insert l1;
            
        Blob bodyblobLrng = Blob.valueOf('Unit Test Attachment Body Lrng');
        
        Attachment atlrng=new Attachment(Body=bodyblobLrng,ContentType='image/jpeg',name='test att',ParentId=l1.id);
        insert atlrng;
        
        //Inserting a new learning boaed learning        
        Learning_Board_Learning__c lbl1=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l1.id,Display_Sequence_Nbr__c=1);
        insert lbl1;
            
        //Learning 2       
        Learning__c l2=new Learning__c(Name__c='pdf',Description__c='pdf test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/4/c04030034.pdf');
        insert l2;           
            
        Learning_Board_Learning__c lbl2=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l2.id,Display_Sequence_Nbr__c=2);
        insert lbl2;
            
        //Learning 3       
        Learning__c l3=new Learning__c(Name__c='Brainshark',Description__c='Brainshark test description',Is_Active__c=true,Type__c='Video',
                                       URL__c='https://www.brainshark.com/HPLearning/VirPrivateCloud1');
        insert l3;           
            
        Learning_Board_Learning__c lbl3=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l3.id,Display_Sequence_Nbr__c=3);
        insert lbl3;    
            
        //Learning 4       
        Learning__c l4=new Learning__c(Name__c='Youtube',Description__c='Youtube test description',Is_Active__c=true,Type__c='Video',
                                       URL__c='http://www.youtube.com/watch?v=8XqO-wWUwNk');
        insert l4;           
            
        Learning_Board_Learning__c lbl4=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l4.id,Display_Sequence_Nbr__c=4);
        insert lbl4;      
        
        //Learning 5       
        Learning__c l5=new Learning__c(Name__c='Bs1',Description__c='Bs1 test description',Is_Active__c=true,Type__c='Video',
                                       URL__c='https://www.brainshark.com/HPLearning/vu?pi=zHWzJnk6sz4IGyz0');
        insert l5;           
            
        Learning_Board_Learning__c lbl5=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l5.id,Display_Sequence_Nbr__c=5);
        insert lbl5;      
        
         //Learning 6       
        Learning__c l6=new Learning__c(Name__c='pptx',Description__c='pptx test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/amer/wws/7/c04025987.pptx');
        insert l6;           
            
        Learning_Board_Learning__c lbl6=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l6.id,Display_Sequence_Nbr__c=6);
        insert lbl6;         
        
            //Learning 7       
        Learning__c l7=new Learning__c(Name__c='docx',Description__c='docx test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='http://intranet.hp.com/enterpriseservices/ww2/wg/gse/Documents/PAT/Portfolio_Alignment_Guide_ECS_VPC_v5.6.docx');
        insert l7;           
            
        Learning_Board_Learning__c lbl7=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l7.id,Display_Sequence_Nbr__c=7);
        insert lbl7;  
            
               //Learning 8      
        Learning__c l8=new Learning__c(Name__c='Other URL',Description__c='Other test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='https://hpedia.hp.com/wiki/Enterprise_Cloud_Services_%28ECS%29_%E2%80%93_Virtual_Private_Cloud_Solution_Guide');
        insert l8;           
            
        Learning_Board_Learning__c lbl8=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l8.id,Display_Sequence_Nbr__c=8);
        insert lbl8; 
            
            
       //Inserting a new liked item
        
       // Liked_Item__c litem= new Liked_Item__c(Name='test liked item',Item_Identifier__c=lb.id,Item_Name__c=lb.Name__c);
        //insert litem;
        
        //Inserting a new user liked item record
        //User_Liked_Item__c uli=new User_Liked_Item__c(Liked_Item_ID__c=lbl.id,User_ID__c=utest.id);
        //insert uli;
        
        //Inserting a new attachment record//
        
        //Another LB to map
        Learning_board__C lb2= new Learning_board__C(Name__c='Another LB',Is_Active__c=true,Description__c='test description');
        insert lb2;
        
        Blob bodyblobLB2 = Blob.valueOf('Unit Test Attachment Body LB');
        
        Attachment atLB2=new Attachment(Body=bodyblobLB2,ContentType='image/jpeg',name='test att',ParentId=lb2.id);
        insert atLB2;   
        
        Related_Learning_Board__c rlbs=new Related_Learning_Board__c(Learning_Board_ID__c=lb.id,Related_Learning_Board_ID__c=lb2.id,Display_Sequence_Nbr__c=1);
        insert rlbs;
        //Instansiating Controller extension
        ApexPages.StandardController stc = new ApexPages.StandardController(lb);
        AthenaLearningBoardDtls albdts = new AthenaLearningBoardDtls(stc);
        AthenaLearningBoardDtls.LearningDtlsCustomClass ldcs = new AthenaLearningBoardDtls.LearningDtlsCustomClass();
        AthenaLearningBoardDtls.RelatedLearningBoardCustomClass rlb=new AthenaLearningBoardDtls.RelatedLearningBoardCustomClass();
        
        //Calling class methods and property//
        albdts.LearningBoardsid=lb.id;
        
        albdts.strSearchValue='Cloud';
        albdts.dosearch();
        
        string sfi=albdts.getSfInstance;
        User u= albdts.GetLoggedinUserDtls();
        User lbu=albdts.getLearningBoardOwnerDtls();
        
        
        integer LOwnerCount=albdts.LBOwnerLikeCount;
        
        integer LCount=albdts.LBLikeCount;
        boolean lonlb=albdts.LikedOrNotLB;
        albdts.LearningBoardLike();
        lonlb=albdts.LikedOrNotLB;
        albdts.LearningBoardUnLike();
        albdts.LearningBoardLike();  
        ldcs.Lid=l1.id;         
        integer LBComCnt=albdts.LBCommentCount;       
        integer LOwnerComCount=albdts.LBOwnerCommentCount;
        albdts.getLBComCount();    
        albdts.Learningid=l8.id; 
        albdts.LearningLike();
        albdts.LearningUnLike();
        albdts.LearningLike();
        string lrngID=lb.id;
       
        List <AthenaLearningBoardDtls.LearningDtlsCustomClass> LDtls=albdts.LearningDtls; 
        List <AthenaLearningBoardDtls.RelatedLearningBoardCustomClass> rlbdtls=albdts.RelatedLearningBoards;
        AthenaLearningBoardDtls.RelatedLearningBoardCustomClass atherlb=albdts.LearningBoardDtls;

        }
        
        
        //Murali test class
        
        //Fetch the profile Id        
        Profile ProfITAdm = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User ITAdUr = new User(Alias = 'ITAdUr', Email='ITAdUr@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='ITAdUr@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfITAdm.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ITAdUr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998881');
        insert ITAdUr;
        
        System.runAs(ITAdUr)
        { 
            Learning_board__C lb2= new Learning_board__C(Name__c='test name1',Is_Active__c=true,Description__c='test description1');
            insert lb2;
            ApexPages.StandardController stc1 = new ApexPages.StandardController(lb2);
            AthenaLearningBoardDtls albdts1 = new AthenaLearningBoardDtls(stc1);
            Boolean b = albdts1.LBEditPermission;
        }
        
        Profile ProfESBase = [SELECT Id FROM Profile WHERE Name='ES Base Profile'];
        
        User ESBaseUr = new User(Alias = 'ESBaseUr', Email='ESBaseUr@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='ESBaseUr@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfESBase.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ESBaseUr@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='99998883');
        insert ESBaseUr;
        
        System.runAs(ESBaseUr)
        { 
            Learning_board__C lb2= new Learning_board__C(Name__c='test name2',Is_Active__c=true,Description__c='test description1');
            insert lb2;
            ApexPages.StandardController stc1 = new ApexPages.StandardController(lb2);
            AthenaLearningBoardDtls albdts1 = new AthenaLearningBoardDtls(stc1);
            Boolean b = albdts1.LBEditPermission;
        }
        
       
        
        PermissionSet ESModeratorPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Moderator'];
        
        PermissionSetAssignment ModerPermSetAssgn = new PermissionSetAssignment();
        ModerPermSetAssgn.PermissionSetId = ESModeratorPermSet.id;
        ModerPermSetAssgn.AssigneeId = ESBaseUr.id;
        insert ModerPermSetAssgn;
        
        System.runAs(ESBaseUr)
        { 
            Learning_board__C lb2= new Learning_board__C(Name__c='test name3',Is_Active__c=true,Description__c='test description1');
            insert lb2;
            ApexPages.StandardController stc1 = new ApexPages.StandardController(lb2);
            AthenaLearningBoardDtls albdts1 = new AthenaLearningBoardDtls(stc1);
            Boolean b = albdts1.LBEditPermission;
        }
        
        User ESBseUr2 = new User(Alias = 'ESBseUr2', Email='ESBseUr2@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='ESBseUr2@hp.com',LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = ProfESBase.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ESBseUr2@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='88888484');
        insert ESBseUr2;
        
        PermissionSet ESProducerPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  Label='ES Social Learning Producer'];
        PermissionSetAssignment ProdPermSetAssgn= new PermissionSetAssignment();
        ProdPermSetAssgn.PermissionSetId = ESProducerPermSet.id;
        ProdPermSetAssgn.AssigneeId = ESBseUr2.id;
        insert ProdPermSetAssgn;
        
        System.runAs(ESBseUr2)
        { 
            Learning_board__C lb2= new Learning_board__C(Name__c='test name6',Is_Active__c=true,Description__c='test description1');
            insert lb2;
            ApexPages.StandardController stc1 = new ApexPages.StandardController(lb2);
            AthenaLearningBoardDtls albdts1 = new AthenaLearningBoardDtls(stc1);
            albdts1.LearningBoardsid=lb2.id;
            Boolean b = albdts1.LBEditPermission;
            system.runas(utest){
                Learning_board__C lb5= new Learning_board__C(Name__c='test name5',Is_Active__c=true,Description__c='test description1');
                insert lb5;
                
            }
            //albdts1.LearningBoardsid=lb5.id;
            //Boolean b1 = albdts1.LBEditPermission;
        }
        
        Test.stopTest();
    }  

}