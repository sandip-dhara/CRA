// -------------------------------------------------------------------------------------------
// This class covers business logic for class isvContactUsPage
// -------------------------------------------------------------------------------------------
// Version#    Date             Author                 Description
// -------------------------------------------------------------------------------------------
// 1.0         09-Aug-2012      Bhawna Pipal           Initial Version
// ------------------------------------------------------------------------------------------

@isTest(SeeAllData=True)
private class hpContactUsPageTrackerr  
{
    // Variable Declaration---------------------------------------------------------------
    private static Account objAccount;
    private static Contact objContact;
    private static hpContactUsPage objisvContactUsPage;
    private static hpContactUsPage objisvContactUsPageOther;
    private static final string PHONE_NUMBER = '9876543210';
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if Cookie Stored
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfCookie()
    {
        // Loads test data
        LoadsTestData();
        
        // Insert Cookie                         
        InsertValueToCookie(objContact.Id);
        
        objisvContactUsPage = new hpContactUsPage();
        // Set Email Address
        objisvContactUsPage.strEmailAddress = 'bhawnapipal@yahoo.com';
        // Set Phone Number
        objisvContactUsPage.strPhoneNumber = PHONE_NUMBER;
        // Set First Name
        objisvContactUsPage.strFirstName = objContact.FirstName;
        // Set Last Name
        objisvContactUsPage.strLastName = objContact.LastName;
        
        objisvContactUsPage.strCompanyName = 'test';
        
        objisvContactUsPage.correctResponse = true;
        
        objisvContactUsPage.strOpenResponse = 'test';
        
       
        
        objisvContactUsPage.strTaskQuery = 'test';
        
        objisvContactUsPage.testlogin = true;
        
        objisvContactUsPage.verify();
        
        // Calls Save Detail Function
        objisvContactUsPage.SaveDetails();
        
        objisvContactUsPage.ResetFields();
        
        
        objisvContactUsPage.testlogin = false;
        
        objisvContactUsPage.strEmailAddress = 'bhawnapipal@yahoo.com';
        
        objisvContactUsPage.strLastName = objContact.LastName;
        objisvContactUsPage.strCompanyName = 'test';
        objisvContactUsPage.strOpenResponse = 'test';
        objisvContactUsPage.verify();
        objisvContactUsPage.correctResponse = true;
        
        // Calls Save Detail Function
        objisvContactUsPage.SaveDetails();
        
        objisvContactUsPage.ResetFields();
        
        objisvContactUsPage.goToRedirect();
        // assert statement-----------------------------------------------------------------------
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Please add a query.');
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if Cookie Stored
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       5-Sept-2012      Ajeet Singh        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfCookieWithTaskQuery()
    {
        // Loads test data
        LoadsTestData();
        
        // Insert Cookie                         
        InsertValueToCookie(objContact.Id);
        
        objisvContactUsPage = new hpContactUsPage();

        // Set Email Address
        objisvContactUsPage.strEmailAddress = 'bhawnapipal@yahoo.com';
        // Set Phone Number
        objisvContactUsPage.strPhoneNumber = PHONE_NUMBER;
        // Set First Name
        objisvContactUsPage.strFirstName = objContact.FirstName;
        // Set Last Name
        objisvContactUsPage.strLastName = objContact.LastName;
        // Calls Save Detail Function
        objisvContactUsPage.strTaskQuery='TaskQuery';
        
        objisvContactUsPage.SaveDetails();
            
        // assert statement-----------------------------------------------------------------------
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Thank You! Your request has been submitted successfully,we will get back to you soon.');
    }
    
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if Cookie Stored and wrong Email
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfCookieWrongEmail()
    {
        // Loads test data
        LoadsTestData();
        
        // Insert Cookie                         
        InsertValueToCookie(objContact.Id);
        
        objisvContactUsPage = new hpContactUsPage();

        // Set Email Address
        objisvContactUsPage.strEmailAddress = 'bhawnapipal';
        // Set Phone Number
        objisvContactUsPage.strPhoneNumber = PHONE_NUMBER;
        // Set First Name
        objisvContactUsPage.strFirstName = objContact.FirstName;
        // Set Last Name
        objisvContactUsPage.strLastName = objContact.LastName;
        // Calls Save Detail Function
        objisvContactUsPage.SaveDetails();
            
        // assert statement-----------------------------------------------------------------------
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Please add a query.');
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if cookie exists and no email provided
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfCookieAndNullEmail() 
    {
        // Loads Test Data
        LoadsTestData();
        
        // Insert Cookie            
        InsertValueToCookie(objContact.Id);
            
        objisvContactUsPage = new hpContactUsPage();           
            
        // Set First Name
        objisvContactUsPage.strFirstName = objContact.FirstName;
        // Set Last Name
        objisvContactUsPage.strLastName = objContact.LastName;
        // Call Save Detail function
        objisvContactUsPage.SaveDetails();
                    
        // assert statement-----------------------------------------------------------------------
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Please add a query.');
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if no cookie but email provided
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfNoCookie() 
    {
        // Loads Test Data
        LoadsTestData();
            
        InsertValueToCookie('');
        
        objisvContactUsPageOther = new hpContactUsPage();

        // Set Email Address
        objisvContactUsPageOther.strEmailAddress = 'bhawnapipal123@gmail.com';
        // Set Phone Number
        objisvContactUsPageOther.strPhoneNumber = PHONE_NUMBER;
        // Set First Name
        objisvContactUsPageOther.strFirstName = 'Test First';
        // Set Last Name
        objisvContactUsPageOther.strLastName = 'Last Name';
        // Call Save Details function
        objisvContactUsPageOther.SaveDetails();
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Thank You! Your request has been submitted successfully,we will get back to you soon.');        
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if no cookie but email provided
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfNoCookieWrongEmail() 
    {   
        // Loads Test Data
        LoadsTestData();
            
        InsertValueToCookie('');
        
        objisvContactUsPageOther = new hpContactUsPage();

        // Set Email Address
        objisvContactUsPageOther.strEmailAddress = 'bhawnapipal';
        // Set Phone Number
        objisvContactUsPageOther.strPhoneNumber = PHONE_NUMBER;
        // Set First Name
        objisvContactUsPageOther.strFirstName = 'Test First';
        // Set Last Name
        objisvContactUsPageOther.strLastName = 'Last Name';
        // Call Save Details function
        objisvContactUsPageOther.SaveDetails();
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Please insert a valid email address.');     
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Save functionality if no cookie and no email exists
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesSaveIfNoCookiewithNullEmail() 
    {
        // Loads Test Data
        LoadsTestData();        
        InsertValueToCookie('');
        
        objisvContactUsPageOther = new hpContactUsPage();
        // Call Save Detail function        
        objisvContactUsPageOther.SaveDetails();       
        
        // assert statement-----------------------------------------------------------------------
        //system.assertEquals(ApexPages.getMessages()[0].getDetail(),'Please enter all required fields');         
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate Load Data functionality
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       09-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validatesLoadData()
    {
        // Loads Test Data
        LoadsTestData();
            
        // Insert Cookie            
        InsertValueToCookie(objContact.Id);
        
        objisvContactUsPage = new hpContactUsPage();   
        
        objisvContactUsPage.LoadData();
        
        // Assert statement-----------------------------------
        system.assert(true, objisvContactUsPage.isLoggedIn);
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate return null 
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       17-Aug-2012    Bhawna Pipal        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validateNullStatement()
    {
        // Loads Test Data
        LoadsTestData();        
        InsertValueToCookie('');
        
        objisvContactUsPageOther = new hpContactUsPage();
        Pagereference objPR = objisvContactUsPageOther.SaveDetails();
        
        // Assert statement
        system.assertEquals(objPR, null);   
            
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate goto Home page function in case login 
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       27-Aug-2012      Ajeet Singh        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validateGotoHomePageInCaseLogin()
    {
        // Loads Test Data
        LoadsTestData();
        
        // Insert Cookie                         
        InsertValueToCookie(objContact.Id);        
        
        objisvContactUsPageOther = new hpContactUsPage();
        Pagereference objPR = objisvContactUsPageOther.GoToHomePage();
        
        // Assert statement
        //system.assertEquals(objPR.getURL(), 'http://hp.fullsb.cs17.force.com/mvarportal/SecuredContentPage');
        //system.assertEquals(objPR.getURL(), 'http://hp.force.com/mvarportal/SecuredContentPage');   
    }
    
    // -------------------------------------------------------------------------------------------
    // Test scenario: Validate goto Home page function in case Not login 
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0       27-Aug-2012      Ajeet Singh        Initial Version
    // -------------------------------------------------------------------------------------------
    static testMethod void validateGotoHomePageInCaseNotLogin()
    {
        // Loads Test Data
        LoadsTestData();
        
        // Insert Cookie                         
        InsertValueToCookie('');
        
        objisvContactUsPageOther = new hpContactUsPage();
        Pagereference objPR = objisvContactUsPageOther.GoToHomePage(); 
        
        // Assert statement
        //system.assertEquals(objPR.getURL(), 'http://hp.fullsb.cs17.force.com/mvarportal/UnsecuredContentPage');   
        //system.assertEquals(objPR.getURL(), 'http://hp.force.com/mvarportal/UnsecuredContentPage');
    }
    
    // -------------------------------------------------------------------------------------------
    // Load test data
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0        09-Aug-2012     Bhawna Pipal       Initial Version
    // ------------------------------------------------------------------------------------------- 
    static void LoadsTestData()
    {
        // create Account
        CreateAccount();
        
        // Create Contact
        CreateContact();
    }
    
    // -------------------------------------------------------------------------------------------
    // Creates Account
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0        09-Aug-2012     Bhawna Pipal       Initial Version
    // ------------------------------------------------------------------------------------------- 
    static void CreateAccount()
    {
        objAccount =  new Account();        
        objAccount.Name = 'Test Account';
        objAccount.Source_System_Account_ID__c = '123';
        // insert Account
        insert objAccount;
        
        Account tempAccount = [Select Id, Name from Account where Id=:objAccount.Id ];
        //---------------------------- assert statement--------------------------------------//
        system.assertEquals(tempAccount.Name , 'Test Account');
    }
    
    // -------------------------------------------------------------------------------------------
    // Creates Contact
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0        09-Aug-2012     Bhawna Pipal       Initial Version
    // ------------------------------------------------------------------------------------------- 
    static void CreateContact()
    {
        objContact =  new Contact();
        
        objContact.FirstName = 'Bhawna';
        objContact.LastName = 'Pipal';
        objContact.AccountId = objAccount.Id;
        objContact.Email = 'TestEmail@gmail.com';
        
        // insert Contact
        insert objContact;
        
        Contact tempContact = [select Id,  FirstName from Contact where Id=:objContact.Id];
        //---------------------------- assert statement--------------------------------------//
        system.assertEquals(tempContact.FirstName, 'Bhawna');
    }
    
    // -------------------------------------------------------------------------------------------
    // Creates Cookie
    // Input Parameters:
    //      - None
    // Returns: 
    //      - None
    // Version#   Date              Author                Description
    // -------------------------------------------------------------------------------------------
    // 1.0        09-Aug-2012     Bhawna Pipal       Initial Version
    // ------------------------------------------------------------------------------------------- 
    static void InsertValueToCookie(string idContact)
    {
       //create a new cookie with name 'conid',an initial value of Name at the page,   
       // path 'null', maxAge '-1', and isSecure 'true'.  
       Cookie myCookies = new Cookie('conid',idContact ,null,-1,true);
       
       ApexPages.currentPage().setCookies(new Cookie[]{myCookies});
    }
    
    public static  testmethod void ValidateVerify() 
   {
        hpContactUsPage  objRegistrationComponent = new hpContactUsPage ();
        
        objRegistrationComponent.challenge = objRegistrationComponent.response = 'foo';
        string publick = objRegistrationComponent.publicKey; 
        string host = objRegistrationComponent.remoteHost; 
        PageReference objPageReference = objRegistrationComponent.verify();
        
        // assert .........
        system.assertEquals(objPageReference == null, true);
   }
   
   public static  testmethod void ValidateVerifyWithout() 
    {
        hpContactUsPage  objRegistrationComponent = new hpContactUsPage();
        PageReference objPageReference = objRegistrationComponent.verify();
        
        // assert..........
        system.assertEquals(objPageReference == null, true);
    }
    
    public static  testmethod void ValidateReset() 
    {
        hpContactUsPage  objRegistrationComponent = new hpContactUsPage();
        objRegistrationComponent.reset();
        
        // assert.....
        system.assertEquals((objRegistrationComponent.challenge==null), true);
    }
    
    
}