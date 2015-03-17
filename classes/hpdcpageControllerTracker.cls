@isTest
private class hpdcpageControllerTracker {

    static testMethod void validatePageController() 
    {
         Site site = [select Id from Site limit 1];
        String siteid = site.Id;        
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
        insert pg;
        
        PageReference pr = Page.page;
        pr.getParameters().put('pageid', pg.Id);
        Test.setCurrentPageReference(pr);
        
        pageController pc = new pageController();
        
        pc.RedirectURL();
        
        ApexPages.currentPage().getParameters().put('pagename',pg.name);
        
        ApexPages.currentPage().getParameters().put('tab','true');
        
        System.assertEquals(pc.pagetemplatename, 'TestTemplate');       
        
        //create a controller with no pageid parameter
        pr.getParameters().remove('pageid');
        
        pageController pc2 = new pageController();
        System.assertEquals(pc2.pagetemplatename, 'Id error :');
        
       
        
        
    }
}