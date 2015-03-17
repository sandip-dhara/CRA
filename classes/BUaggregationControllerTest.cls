@isTest
private class  BUaggregationControllerTest{
static testMethod void myTest() 
    {
        Account acc = new Account(Name='testacc1',Source_System_Account_ID__c='56544565');
        insert acc ;  
        Account_Plan__c newAP = new Account_Plan__c(Name='Sample Account plan',Primary_AccountAccount__c=acc.id);
        insert newAP;
        Business_Unit_Plan__c newBUP = new Business_Unit_Plan__c(Account_Plan__c=newAP.id,Name='test BU',BU_Name__c='ES',FY11_Revenue_actuals__c=10,FY12_Revenue_YTD__c=20,FY13_Projected_Revenue__c=30,FY14_Projected_Revenue__c=40,FY15_Projected_Revenue__c=50,FY16_Projected_Revenue__c=60);
        insert newBUP;
        List<AggregateResult> results = [SELECT BU_Name__c red,SUM(FY11_Revenue_actuals__c) totalfy11, SUM(FY12_Revenue_YTD__c) fy12Sum, SUM(FY13_Projected_Revenue__c) totalfy13, SUM(FY14_Projected_Revenue__c) totalfy14, SUM(FY15_Projected_Revenue__c) totalfy15, SUM(FY16_Projected_Revenue__c) totalfy16, AVG(Year_over_Year_1__c) YOY1,AVG(Year_over_Year_2__c)YOY2,AVG(Year_over_Year_3__c) YOY3,AVG(Year_over_Year_4__c) YOY4 FROM Business_Unit_Plan__c where Account_Plan__c = :newAp.Id group by BU_Name__c ];  //and BU_Name__c != 'HPFS'                 
               
        ApexPages.StandardController sc = new ApexPages.StandardController(newAP);
        BUaggregationController ars = new  BUaggregationController(sc);
        ars.results = results;
          //Butotals butot = new BuTotals();
          
       //  BUaggregationController.Butotals oc =  ars.new Butotals();
        ars.getResults();
        ars.back();
       
        
       }   
}