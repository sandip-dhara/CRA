@isTest
public class AthenaLearningBoardTest{
    static testMethod void AthenaLearningBoardTest(){
        //Fetch the profile Id        
        Profile p = [SELECT Id FROM Profile WHERE Name='IT Administrator']; 
        
        //Create Logged in User
        User LBUser = new User(Alias = 'LBUserAL', Email='LBUserAL@hp.com', 
        EmailEncodingKey='UTF-8',Email_Address__c='LBUserAL@hp.com',LastName='LBUserAL', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='LBUserAL@hp.com',Adoption_Role_Type__c='IT',Legacy_Employee_Ref__c='77778840');
        
        insert LBUser; 
        
        system.runas(LBUser){
            AthenaLearningBoard ALB = new AthenaLearningBoard();
            Learning_board__C lb= new Learning_board__C(Name__c='test name',Is_Active__c=true,Description__c='test description');
            insert lb;
            ALB.Name='Cloud Data';
            ALB.Description ='test description';
            ALB.DefaultImageName='image';
            ALB.IsActive = false;
            ALB.Featured = true;  
            ALB.LBID = lb.id;  
            ALB.Save();
            Tag__c T = new Tag__c();
            T.Value__c = 'Test Class';
            Tag_Item__c TI = new Tag_Item__c();
            TI.Item_Name__c= 'Learning Board';
            TI.Tag_ID__c = T.id;
            TI.Item_Identifier__c = LB.id;
            AthenaLearningBoard.SearchRelatedLearningBoard('test');
        }
        
        /*system.runas(LBUser){
            
            //<start> testing for Save Functionality
                       
            AthenaLearningBoard ALB = new AthenaLearningBoard();
            ALB.Name='Cloud Data';
            ALB.Description ='test description';
            ALB.DefaultImageName='image';
            ALB.IsActive = false;
            ALB.Featured = true;
            ALB.Save();
            Learning_Board__c LB = [Select id from Learning_Board__c where Name__c ='Cloud Data' Limit 1];
            AthenaLearningBoard ALB1 = new AthenaLearningBoard();
            ALB1.Name='Cloud Data';
            ALB1.Description ='test description';
            ALB1.DefaultImageName='image';
            ALB1.IsActive = false;
            ALB1.Featured = true;
            ALB1.LBID = LB.id;
            ALB1.Save();
            //<End> testing for Save Functionality
            List<Learning_Board__c> Strn = [Select id,Name__c from Learning_Board__c];
            List<Learning__c> LrngList = [select id from Learning__c];
            System.debug('Strn'+Strn);
            AthenaLearningBoard.SearchRelatedLearningBoard('Cloud');
            ALB1.LBList = strn;
            ALB1.LList = LrngList;
            //inserting Learning
            Learning__c l1=new Learning__c(Name__c='testll',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.google.com');
            insert l1;
             //Another LB to map
            Learning_board__C lb2= new Learning_board__C(Name__c='Another LB',Is_Active__c=true,Description__c='test description');
            insert lb2;
            //Inserting a new learning board learning        
            Learning_Board_Learning__c lbl1=new Learning_Board_Learning__c(Learning_Board_ID__c=lb.id,Learning_ID__c=l1.id,Display_Sequence_Nbr__c=1);
            insert lbl1;
            //inserting Related Learning Baord
            Related_Learning_Board__c rlbs=new Related_Learning_Board__c(Learning_Board_ID__c=lb.id,Related_Learning_Board_ID__c=lb2.id,Display_Sequence_Nbr__c=1);
            insert rlbs;
            //ALB1.MapRelatedLearningBoard(LB.id);
            //ALB1.ChangeRelatedLearningBoardOrder(Strn);
            //ALB1.RemoveRelatedLearningBoard(rlbs.id);
            ALB1.SearchLearning('testll');
            ALB1.MapLearnings(LB.id);
            //ALB1.AssociatedTags();
            ALB1.ChangeOwner(LBUser.id);
            
            Tag__c T = new Tag__c();
            T.Value__c = 'Test Class';
            Tag_Item__c TI = new Tag_Item__c();
            TI.Item_Name__c= 'Learning Board';
            TI.Tag_ID__c = T.id;
            TI.Item_Identifier__c = LB.id;
            
            ALB1.ChangeLearningBoardLearningOrder(lrngList);
            
            
            
            
            //Learning_board__C lb= new Learning_board__C(Name__c='test name',Description__c='test description',Default_Image_Name__c='image');
            
            //Learning_Board__c LB = [Select id from Learning_Board__c where Name__c ='test name' Limit 1];
            
            //AthenaLearningBoard ALB2 = new AthenaLearningBoard();
            
            //ALB2.LBID = 'a6tZ00000008RHH';
            //ALB2.LBID = 'a6tZ00000008RHHIA2';
            //string str = ALB2.AssociatedTags();
            //system.debug('str'+str);
            
            
            
        
        }*/
    }
}