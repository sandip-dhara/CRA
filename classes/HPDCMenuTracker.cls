@isTest(SeeAllData=true)
private class HPDCMenuTracker {
    
    static HPMenu__c objMenu;
    static Page__c objPage;
    
    static testMethod void ValidateHpMenu() 
    {
        loadData();
        
        Cookie affId1 = new Cookie('conid',objPage.Id,null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{affId1});
        ApexPages.currentPage().getParameters().put('returl',objPage.Id);
        Test.setCurrentpage(new pagereference('/apex/page'));
        HPDCMenu objhpdcmenu =new HPDCMenu();
        objhpdcmenu.getdescription();
        objhpdcmenu.login();
        objhpdcmenu.recoverPassword();
        objhpdcmenu.LoginAsSalesRep();
        objhpdcmenu.Signup();
        objhpdcmenu.Contactus();
        objhpdcmenu.LoginLogout();
        
        Contact obContact = new Contact();
        //obContact.Username__c = 'test';
        //obContact.Password__c = 'test';
        objhpdcmenu.objContact = obContact;
        objhpdcmenu.login(); 
        // obContact.Password__c = '';
        objhpdcmenu.objContact = obContact;
        
    }
    static void loadData(){
    
        insertContact();
        insertMenu();
        insertSubMenu();
        insertPage();
        
    }
    
    static void insertPage(){
    
        objPage = [select id, PageTemplate__c, Page_URL__c, FriendlyUrl__c from Page__c limit 1];
    }
    
    static void insertContact(){
    
        Contact obContact = new Contact();
      //  obContact.Username__c = 'test';
      //  obContact.Password__c = 'test';
      //  obContact.Active__c = true;
        obContact.LastName = 'test';
        insert obContact;
    }
    
    static void insertMenu(){
    
        objMenu = new HPMenu__c();
        objMenu.Name = 'mainMenu';
        objMenu.Active__c = true;
        objMenu.Description__c = 'test';
        objMenu.ShortDescription__c = 'test';
        insert objMenu;        
    }
    
    static void insertSubMenu(){
    
        HPMenu__c objSubMenu = new HPMenu__c();
        objSubMenu.Name = 'subMenu';
        objSubMenu.Active__c = true;
        objSubMenu.Description__c = 'test';
        objSubMenu.ShortDescription__c = 'test';
        objSubMenu.SubMenu__c = objMenu.Id;
        insert objSubMenu;        
    }
}