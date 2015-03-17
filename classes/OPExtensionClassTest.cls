/**********************************************************
* Class Name: OPExtensionClassTest
* Author: HP
* Date: 15-FEB-2013 
* Description: This class does the test coverage for OPExtensionClass class.
***********************************************************/
@isTest(SeeAllData=True)
public class OPExtensionClassTest
    {  
        static testmethod void testOPExtensionClass(){  
        
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
        
        test.startTest(); 
        PageReference pageRef = Page.OpportunityPlanAddin;
        ApexPages.currentPage().getParameters().put('ToolnameCP','EG'); 
               
        ApexPages.StandardController controller= new ApexPages.StandardController(new Opportunity_Plan__c());
        OPExtensionClass oExt = new OPExtensionClass(controller);
        //oExt.OPMapCP1();
        oExt.opt=opplan;
        oExt.getOPToolOptCR();
        oExt.getOPToolMapCP();
        oExt.getOPToolMapVP();
        oExt.getOPToolMapOG();
        oExt.getOPToolMapDG();
        oExt.getOPToolMapCR();
        oExt.getOPToolMapRS();
        oExt.getOPToolMapCSP();
        oExt.getOPToolMapDHCL();
        oExt.getOPToolMapCLSP();
        oExt.getTabInFocus();
        oExt.getOPToolMapCP1();
        test.stopTest();
        }
       
    }