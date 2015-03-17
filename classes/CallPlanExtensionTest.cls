@IsTest(seealldata=true)
public Class CallPlanExtensionTest{

static testmethod void testcallplanextension(){   
    
ApexPages.StandardController controller= new ApexPages.StandardController(new Call_Plan__c());
       Account acc=new Account();
       acc.Name='test';
       acc.Source_System_Account_ID__c='0987';
       acc.ShippingCountry='India';
       insert acc;
       Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='AUD');
       insert opp;
       Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
       insert opplan;
        system.currentPageReference().getParameters().put('OppPlanId',opplan.id);       
        system.currentPageReference().getParameters().put('retURL','/apex/cp_list?id='+opplan.id);
        CallPlanExtension callplan=new CallPlanExtension(controller);
        callplan.save();
        callplan.SaveoppPlan();
        callplan.cancel();
        
        ApexPages.StandardController controller1= new ApexPages.StandardController(new Call_Plan__c());       
         system.currentPageReference().getParameters().put('OppPlanId',Null); 
         CallPlanExtension callplan1=new CallPlanExtension(controller1);        
         callplan1.save();
         callplan1.SaveoppPlan();
}

}