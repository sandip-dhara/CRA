@isTest(SeeAllData=true)
private class HPLeadRequestComponentControllerTracker {
	
	// -------------------------------------------------------------------------------------------
    // Test Method for validate ValidatehpTemplateMemberLoginController
    // Version#     Date            Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0      5-Jul-2013      Naveen            Initial Version
    // -------------------------------------------------------------------------------------------
    
    static Page__c objPage; 
    static Lead objlead; 
   
    static testMethod void ValidateHPLeadRequestComponentController() {
    	 
    	//get ordertype
    	//Apexpages.currentPage().getParameters().put('orderid', '1');
    	insertLead();
    	insertPage();
    	
    	Cookie affId1 = new Cookie('conid',objPage.Id,null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{affId1});
        ApexPages.currentPage().getParameters().put('returl',objPage.Id);
        
        //create instance of class hpTemplateMemberLoginController
        HPLeadRequestFormComponentController  objTemp = new HPLeadRequestFormComponentController ();
        
        
        hpcommon.IsEmailValid('Test123@gmail.com');
        hpcommon.IsNullOrEmpty('Test123@gmail.com');
        
        insertLead();
        objTemp.Submit();
        
        objTemp.objlead.LastName = 'test';
        objTemp.objlead.Company = 'Company';
        objTemp.objlead.Status = 'Working';
        objTemp.objlead.FirstName = 'Test';
        objTemp.objlead.Email = 'Test123@gmail.com';
        objTemp.objlead.Phone = '123456789';
        //objTemp.objLead.Estimated_Unit_Volume__c = '3';
        //objTemp.objlead.Month__c = 'May';
        //objTemp.objlead.Year__c = '2015';
        //objTemp.objlead.Budgets__c = 'Budgets';
        //objTemp.objlead.Product_details__c = 'Test';
        //objTemp.objlead.HP_Contact_e_mail__c  = 'Test123@gmail.com';
        //objTemp.objlead.opportunity_registered_in_salesforce__c = 'Yes';
        //objTemp.objlead.Customer_Name__c = 'Test';
        //objTemp.objlead.Customer_AMID_ID__c = 'Test';
        //objTemp.objlead.Opportunities_Id__c = 'Test';
        //objTemp.objlead.working_with_a_specific_customer__c = 'Yes';
        objTemp.objlead.Description = 'TestDescription';
       
        objtemp.testlogin = true;
        objtemp.testsitename = null;
        
        objTemp.Submit();
        
        
        //call method
        objTemp.Cancel();
        objTemp.CheckIsUserLoggedIn();
        objTemp.goToRedirect();
        
        
       
        
        
        
        //objTemp.Submit();
        //objTemp.objlead.Customer_Name__c = '';
        //objTemp.Submit();
        
        //objTemp.objlead.Customer_Name__c = 'Test';
        //objTemp.objlead.Customer_AMID_ID__c = '';
        //objTemp.Submit();
        
        
         //objTemp.objlead.HP_Contact_e_mail__c  = 'Test123@gmail123.com12';
          //objTemp.Submit();
          
         // objTemp.objlead.Customer_AMID_ID__c = 'test';
         // objTemp.objlead.HP_Contact_e_mail__c  = 'Test123@gmail123.com12';
          //objTemp.objlead.Opportunities_Id__c = '';
          //objTemp.Submit();
        //hpcommon.GetLoginType() ;
        
        
    }
    
    
    
    
    
     static testMethod void ValidateHPLeadRequestComponentController1() {
    	 
    	//get ordertype
    	//Apexpages.currentPage().getParameters().put('orderid', '1');
    	insertLead();
    	insertPage();
    	
    	Cookie affId1 = new Cookie('conid',objPage.Id,null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{affId1});
        ApexPages.currentPage().getParameters().put('returl',objPage.Id);
        
        //create instance of class hpTemplateMemberLoginController
        HPLeadRequestFormComponentController  objTemp = new HPLeadRequestFormComponentController ();
        
        
        hpcommon.IsEmailValid('Test123@gmail.com');
        hpcommon.IsNullOrEmpty('Test123@gmail.com');
        
        insertLead();
        objTemp.Submit();
        
        objTemp.objlead.LastName = 'test';
        objTemp.objlead.Company = 'Company';
        objTemp.objlead.Status = 'Working';
        objTemp.objlead.FirstName = 'Test';
        objTemp.objlead.Email = 'Test123@gmail.com';
        objTemp.objlead.Phone = '123456789';
       
        //objTemp.objlead.working_with_a_specific_customer__c = 'Yes';
        objTemp.objlead.Description = 'TestDescription';
        
        objtemp.testlogin = false;
        objtemp.testsitename = 'site';
        objTemp.Submit();
        
        
        //call method
        objTemp.Cancel();
        objTemp.CheckIsUserLoggedIn();
        objTemp.goToRedirect();
        
        
    }
    
    
         
    
    
    static void insertLead(){
    
        objLead = new Lead();
        objlead.LastName = 'test';
        objlead.Company = 'Company';
        objlead.Status = 'Working';
        objlead.FirstName = 'Test';
        objlead.Email = 'Test123@gmail.com';
        objlead.Phone = '123456789';
        //objLead.Estimated_Unit_Volume__c = '3';
        //objlead.Month__c = 'May';
        //objlead.Year__c = '2015';
        //objlead.Budgets__c = 'Budgets';
        //objlead.Product_details__c = 'Test';
        //objlead.HP_Contact_e_mail__c  = 'Test123@gmail.com';
        //objlead.opportunity_registered_in_salesforce__c = 'Yes';
        //objlead.Customer_Name__c = 'Test';
        //objlead.Customer_AMID_ID__c = 'Test';
        //objlead.Opportunities_Id__c = 'Test';
        //objlead.working_with_a_specific_customer__c = 'Yes';
        objlead.Description = 'TestDescription';
        insert objLead;
    }
    
    static void insertPage(){
    
        objPage = [select id, PageTemplate__c, Page_URL__c, FriendlyUrl__c from Page__c limit 1];
    }
    
    	
   
    
    
}