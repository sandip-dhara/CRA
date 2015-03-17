@isTest
public class JBP_NewCompLandscapeControllerTest{
    private static testMethod void testCase(){
        Account partAcc = new Account();
        Account competitorAccount = new Account();
        Account competitorAccount2 = new Account();
        competitorAccount = TestingSetupDataUtil.createAccount('CompetitorAccount', 'competitor@hp.com','Competitor');
        insert competitorAccount;
        
        competitorAccount2 = TestingSetupDataUtil.createAccount('CompetitorAccount', 'competitor@hp.com','Competitor');
        insert competitorAccount2;
        
        partAcc = TestingSetupDataUtil.createAccount('JBPAccount', 'partnerJBP@hp.com','Partner');
        partAcc.Partner_Portal_Eligible__c = true;
        insert partAcc;
        
        JBP__c jbp= new JBP__c(Name='TestJbp', Partner_Account__c=partAcc.Id, BG__c='EG', PPT_Export_Currency__c='USD', PPT_Export_Language__c='English',Plan_End_Date__c=system.today()+20);
        insert jbp;
        
        GBU_Specialization_Plans__c subPlan = new GBU_Specialization_Plans__c(GBU_Specialization__c='HPFS', Business_Group__c='EG', Joint_Business_Plan__c=jbp.Id,CurrencyIsoCode='USD');
        insert subPlan;
        
        PageReference pageRef = Page.JBP_NewCompetitiveLandscapesPage;
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('retURL', subPlan.Id);
        ApexPages.currentPage().getParameters().put('GBUId', subPlan.Id);
        //ApexPages.currentPage().getParameters().put('GBUId', null);
      
        JBP_Competitive_Landscape__c nulljbpCompetitive = new JBP_Competitive_Landscape__c(); 
        JBP_Competitive_Landscape__c jbpCompetitive = new JBP_Competitive_Landscape__c(GBU_Specialization_Plan__c=subPlan.Id,Competitor__c= competitorAccount.Id );
        insert jbpCompetitive;
        //Setting channel partner record with null opty reference in standard controller
        ApexPages.StandardController nullGBUStdController = new ApexPages.StandardController(nulljbpCompetitive );
        JBP_NewCompLandscapeController nulStdController = new JBP_NewCompLandscapeController(nullGBUStdController);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(jbpCompetitive);
        JBP_NewCompLandscapeController jbpCompetitor = new JBP_NewCompLandscapeController(stdController);
        if(jbpCompetitor.CompetitiveList!= null && 
                jbpCompetitor.CompetitiveList.size() > 0) {
                //keeping partner type null
                jbpCompetitor.CompetitiveList[0].competitor.Competitor__c = competitorAccount.Id;
                jbpCompetitor.save();
                
                //setting already linked partner Account
                jbpCompetitor.CompetitiveList[0].competitor.Competitor__c = competitorAccount.Id;
                jbpCompetitor.save();
                
                //setting same account twice
                if(jbpCompetitor.CompetitiveList.size() > 1) {
                    jbpCompetitor.CompetitiveList[0].competitor.Competitor__c = competitorAccount2.Id;
                    jbpCompetitor.CompetitiveList[1].competitor.Competitor__c = competitorAccount2.Id;
                    jbpCompetitor.save();
                }
                jbpCompetitor.CompetitiveList[0].competitor.Competitor__c = null;
                jbpCompetitor.CompetitiveList[0].competitor.Current_Share_of_Business__c = 28;
                jbpCompetitor.CompetitiveList[1].competitor.Current_Share_of_Business_Prcnt__c  = 12;
                jbpCompetitor.save();
                              
            }
        jbpCompetitor.save();
        jbpCompetitor.cancel();
            
    }
}