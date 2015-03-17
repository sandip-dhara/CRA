public with sharing class CMSConsoleActionsController {
	
	private Boolean fullscreen = false;
	private Boolean console = false;

	//method that will dispatch the url param operation to the correct Apex method
	public PageReference dispatchOperation() {
		String operation = System.currentPageReference().getParameters().get('operation');
		if(System.currentPageReference().getParameters().get('fullscreen') == 'true') fullscreen = true;
		if(System.currentPageReference().getParameters().get('console') == 'true') console = true;
		
    	if(operation == 'delete_pageitem') {
    		return deletePageItem();
    	}
    	return null;
	}
	
	
	public PageReference deletePageItem() {
		String pageitemid = System.currentPageReference().getParameters().get('pageitemid');
		String retUrl = System.currentPageReference().getParameters().get('returl');
		try {
			PageToItem__c pi = [Select p.Page__c, p.Id From PageToItem__c p where p.Id =:pageitemid];
			String pageid = pi.Page__c;	
			delete pi;
			String instance;
			if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null) instance = CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c;
			PageReference pr = new PageReference(instance + '/apex/PreviewPage?pageid='+pageid+'&console=true&pod='+instance);
			if(fullscreen) pr = new PageReference(instance + '/apex/PreviewPage?pageid='+pageid+'&console=true&fullscreen=true&pod='+instance);
			return pr;
		}
		catch(Exception ex) {
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			return null;
		}
		
	} 
	
	
	/** TEST **/
	public static testMethod void t1() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c pagefolder2 = new CMSFolder__c(Type__c = 'Page', Name='test', Parent_CMSFolder__c = pagefolder.Id);
		insert pagefolder2;
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
		//set up a test template
		PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
		insert template;
		//set up a test page
		Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
		insert pg;
		//set up a test ContentBlockItem
        ContentBlockItem__c cb = new ContentBlockItem__c(Name='test content', Content__c='some content');
        insert cb;
        //set up Page Item
        PageToItem__c pti = new PageToItem__c(Page__c = pg.Id, ContentBlockItem__c = cb.Id);
        insert pti;
        
        Test.setCurrentPage(Page.CMSConsoleActions);
        ApexPages.currentPage().getParameters().put('pageitemid',pti.Id);
        ApexPages.currentPage().getParameters().put('operation','delete_pageitem');
        
        CMSConsoleActionsController cac = new CMSConsoleActionsController();
        System.assert(cac.dispatchOperation() != null);
        
        ApexPages.currentPage().getParameters().put('pageitemid','norealid');
        CMSConsoleActionsController cac2 = new CMSConsoleActionsController();
        System.assert(cac2.dispatchOperation() == null);
       
       	ApexPages.currentPage().getParameters().put('operation','norealoperation');
        
        CMSConsoleActionsController cac3 = new CMSConsoleActionsController();
        System.assert(cac3.dispatchOperation() == null);
	}

}