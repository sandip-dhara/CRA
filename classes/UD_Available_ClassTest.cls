@isTest(SeeAllData=true)
private class UD_Available_ClassTest{
    
    static testMethod void UserAvailableTest(){
    
    Boolean bolValueOne = true;
    
    UserData__c UD = new UserData__c();
    UD.available__c=true;
    
    test.startTest();    
    ApexPages.StandardController ud_controller = new ApexPages.StandardController(UD); 
    UD_Available_Class udcontroller = new UD_Available_Class(ud_controller);
    udcontroller.getAvail();
    udcontroller.getOpenCases();
    udcontroller.switchAvail();
    test.stopTest();
    
    }

}