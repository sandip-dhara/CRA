@isTest
public class AthenaLearningsTest
{
    public static testMethod void LearningsTest() 
    {   
        Test.startTest();
        //Inserting a new learning 
         Learning__c l1=new Learning__c(Name__c='testll',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.test.com');
         insert l1;
         
        Learning__c l2=new Learning__c(Name__c='testll',Description__c='test description',Is_Active__c=true,Type__c='Other',
                                       URL__c='www.test.com');
         //insert l2;
         
        //Instansiating Controller extension
        PageReference pageRef1 = Page.AthenaLearnings;
        Test.setCurrentPageReference(pageRef1);
        ApexPages.currentPage().getParameters().put('learID',l1.Id);
        ApexPages.StandardController stc = new ApexPages.StandardController(l1);
        AthenaLearnings aller = new AthenaLearnings(stc);
        aller.saveandnew();     
        
        
        
        Test.stopTest();
    }
}