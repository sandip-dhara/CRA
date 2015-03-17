@isTest 
private class MDCPUnverifiedAccountControllerTestClass {

static testMethod void validateMDCPUnverifiedAccountController() {

    MDCPUnverifiedAccountController con=new MDCPUnverifiedAccountController();
    con.name='test account';
    con.PhysicalStreet='test PhysicalStreet';
    con.PhysicalState ='PhysicalState ';
    con.PhysicalCity='test PhysicalCity';
    con.PostalCode='testPostalCode';
    con.selectedCountry ='India';
    con.name='test account';
    con.name='test account';
    con.save();
    con.hidecaselink();
    con.hideAccountlink();
    con.back();
    con.getIsNewAccountCreated();    
    con.getnewUnverifiedAccountID();       
    con.getnewCaseID();       
    con.getisCaseCreated();  
    con.getisCaseCreationFailed();                             

 }
 
}