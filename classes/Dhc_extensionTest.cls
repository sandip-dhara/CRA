/************************************************************************
Purpose     : Test Class for dhc_extension                  
Parameters  : None
Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class Dhc_extensionTest
    {  
        static testmethod void testDHCExtensionController(){  
        
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
       
       DHC_Questions__c dq=new DHC_Questions__c( Rating__c='Test',Sales_Stage__c='Test',CSF__c='Test',Sort_Order__c=2);
       insert dq;
       String myString = 'StringToBlob';
       Blob myBlob = Blob.valueof(myString);
       Attachment a = new Attachment(parentId = opplan.id, name='Filename'+'.pdf', body =myBlob);
       insert a;
        ApexPages.StandardController controller= new ApexPages.StandardController(opplan);
        system.currentPageReference().getParameters().put('opplanid',opplan.id);
        String opplanid=String.valueOf(opplan.id);
        dhc_extension de=new  dhc_extension(controller);
        String returnval=dhc_extension.savepdf(opplanid);
        dhc_extension.getPicklist('Test','Test');
        integer retval=dhc_extension.saveCopy(opplanid);
        
        
       
        
        }
   }