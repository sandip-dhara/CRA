/************************************************************************
Purpose     : Test Class for customRelatedCallPlans
Parameters  : None
Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class customRelatedCallPlansTest
    {  
        static testmethod void testcustomRelatedCallPlans(){ 
        Account acc=new Account(Name='test',Source_System_Account_ID__c='0987',ShippingCountry='India'); 
        insert acc;
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
        
        system.currentPageReference().getParameters().put('retURL','/apex/');
        system.currentPageReference().getParameters().put('id',opplan.Id);
        ApexPages.StandardController controller= new ApexPages.StandardController(new Call_Plan__c());
        customRelatedCallPlans callplan=new customRelatedCallPlans(controller);        
        callplan.getrelatedCallPlans();
        callplan.cancel();
        
        }
     }