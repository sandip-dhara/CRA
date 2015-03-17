/************************************************************************
Purpose     : Test Class for cspExtensionController                  
Parameters  : None
Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class cspExtensionControllerTest
    {  
        static testmethod void testcspExtensionController(){  
        
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Competitor');
        insert acc;
        Account acc1=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc1;
        Opportunity opp = new Opportunity(AccountId = acc1.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
        Competitors__c competator=new Competitors__c(Opportunity__c=opp.id,Primary__c=true);
        insert competator;
        
        Competitive_Sales_Plan__c cspsalesplan=new Competitive_Sales_Plan__c(Opportunity_Plan__c=opplan.id,Competitors__c=competator.id);
        insert cspsalesplan;
        csp_defensive_strategy__c cspdefensive=new csp_defensive_strategy__c(csp__c=cspsalesplan.Id,Activity_Created_On__c=system.today());
        insert cspdefensive;
        csp_offensive_strategy__c cspoffensive=new csp_offensive_strategy__c(csp__c=cspsalesplan.Id);
        insert cspoffensive;
        
        Relationship_Suite__c relatiosuite=new Relationship_Suite__c(Opportunity_Plan__c=opplan.Id);
        insert relatiosuite;
        Decision__c decision=new Decision__c(Opportunity_Plan__c=opplan.Id,Who__c='test');
        insert decision;
        
        ApexPages.StandardController controller= new ApexPages.StandardController(new Competitive_Sales_Plan__c());
        system.currentPageReference().getParameters().put('id',competator.id);
        system.currentPageReference().getParameters().put('cspName',competator.id);
        system.currentPageReference().getParameters().put('oppPlanId',opplan.Id);
        
        cspExtensionController cspextention=new cspExtensionController(controller);
        cspextention.oppPlanId=opplan.Id;
        cspextention.chosenOffId=cspoffensive.Id;
        cspextention.chosenDefId=cspdefensive.Id;
        cspextention.idcount='test';
        cspextention.getRelatedOffensiveStrategies();
        cspextention.getRelatedDefensiveStrategies();       
        cspextention.addOffRow();
        cspextention.addDefRow();
        cspextention.customSave();
        cspextention.customCancel();
        cspextention.getBuyingCriteria();
        cspextention.getDecisionMakers();
        cspextention.getDecisionCount();
        cspextention.goBack();
        cspextention.getRelatedOffensiveStrategiesT();
        cspextention.getRelatedDefensiveStrategiesT();
        cspextention.CreateOffActivities();
        cspextention.CreateDefActivities();
        cspextention.removeOffRow();
        cspextention.removeDefRow();
        
        
       
        
        }
   }