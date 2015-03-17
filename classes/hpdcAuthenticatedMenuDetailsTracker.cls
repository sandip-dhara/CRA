@isTest
private class hpdcAuthenticatedMenuDetailsTracker{

    static HPMenu__c objMenu;
    static testMethod void firstMethod() {
        
        loadData();
        
        ApexPages.currentPage().getParameters().put('menu','mainMenu');
        ApexPages.currentPage().getParameters().put('tab','subMenu');
        hpdcAuthenticatedMenuDetailsController ob = new hpdcAuthenticatedMenuDetailsController();
        
    }
    
    static void loadData(){
        
        insertMainMenu();
        insertSubMenu();
    }
    
    static void insertMainMenu(){
    
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