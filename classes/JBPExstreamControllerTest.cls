/**********************************************************
* Class Name: JBPExstreamControllerTest 
* Author: HP
* Date: 09-May-2013 
* Description: This class does the test coverage for JBPExstreamController class. 
***********************************************************/

@isTest(SeeAllData=true)
private class JBPExstreamControllerTest {
     
private static testMethod void testJBP(){     
     date dtDate = date.today();
      String usersId =  UserInfo.getUserId();
      Account partAcc = new Account();
      partAcc = TestingSetupDataUtil.createAccount('JBPAccount', 'partnerJBP@hp.com','Partner');
      partAcc.Partner_Portal_Eligible__c = true;
      insert partAcc;
      JBP__c jbp= new JBP__c(Name='TestJbp', Partner_Account__c=partAcc.Id, BG__c='EG', PPT_Export_Currency__c='MZE', PPT_Export_Language__c='English',Plan_End_Date__c=dtDate);
      insert jbp;
      PPT_Language__c pptLanguage =new PPT_Language__c (Name='English',PPT_Display_Language__c='en',PPT_Language_Code__c='en');
      insert pptLanguage;
      
      PPT_Currency_Symbol__c pptCurrency=new PPT_Currency_Symbol__c (Name='MZE',PPT_Currency_Code__c='MZE',PPT_Currency_Code_Key__c='ABC',PPT_Display_Code__c='ABZ');
      insert pptCurrency;
     
      PPT_Usage_Metric__c pptUsageMetric=new PPT_Usage_Metric__c (Name='abc@hp.com',UserEmailId__c='abc@hp.com');
      insert pptUsageMetric;
      
      ApexPages.currentPage().getParameters().put('jbpId',jbp.id); 
      JBPExstreamController jbpExstreamControllerObject =new JBPExstreamController();
      jbpExstreamControllerObject.pptLanguage= 'English';
      jbpExstreamControllerObject.currencyCode = 'MZE';
      jbpExstreamControllerObject.success='true';
      
      Test.setMock(WebServiceMock.class, new JBPExstreamControllerImpl());
      List<SelectOption> languageList=  jbpExstreamControllerObject.getLanguage;
      List<SelectOption> currencyList=  jbpExstreamControllerObject.getCurrency;
      jbpExstreamControllerObject.insertUsageMetric(usersId);
      jbpExstreamControllerObject.invokeTibcoWsService();    
    }      
 }