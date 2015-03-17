@IsTest
public Class IntegratedReportController_UT{

static testmethod void testpageBlockTitle(){
IntegratedReportController integreport = new IntegratedReportController();

integreport.isLink = true;
integreport.isReport = false;
integreport.linkClick();

}
}