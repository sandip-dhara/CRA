public with sharing class CMSForceConsoleController {

	//public Boolean pageproperties {get;set;}
	public String selectednode {get;set;}
	public String selectednodetype {get;set;}
	
	public Page__c page {get;set;}
	public String previewlink {get;set;}
	public Map<ID,Site> sites;
	public List<SelectOption> siteSelectOptions {get;set;}
	public String siteurl {get;set;}
	
	public CMSForceConsoleController() {		
		sites = new Map<ID,Site>([Select s.UrlPathPrefix, s.TopLevelDomain, s.Subdomain, s.Status, s.Name, s.MasterLabel, s.Id, s.Description From Site s where Status = 'Active' limit 25]);
		siteSelectOptions = new List<Selectoption>();
		for(Site s:sites.values()) {
			Selectoption so = new Selectoption(s.Id,s.Name);
			siteSelectOptions.add(so);
		}
		//pageproperties = false;
		selectednode = 'nothing yet';
	}
	
	//pull in the properties of the page and show them
	public PageReference editPageProperties() {
		try {
			page = [Select p.PageTemplate__c, p.FriendlyUrl__c, p.Site_Id__c, p.PageTemplateVFPage__c, p.Name, p.Home_Page__c, p.Folder__c, p.Cache_expires__c From Page__c p where Id = :selectednode];
			//find the site via the rootfolder
			CMSFolder__c rootfolder = CMSForceUtils.findRootFolder(page.Folder__c);
			if(CMSForceSites__c.getAll().get(rootfolder.Site_Id__c) != null) siteurl = CMSForceSites__c.getAll().get(rootfolder.Site_Id__c).Site_Url__c;
		}
		catch(Exception ex) {
			//do nothing
		}
		return null;
	}
	
	//create a new page item
	/**
	public PageReference newPageItem() {
		PageToItem__c pti = new PageToItem__c();
		pti.Page__c = page.Id;		
		ContentBlockItem__c cbi = new ContentBlockItem__c();
		cbi.Name = '';
		insert cbi;
		pti.ContentBlockItem__c = cbi.id;
		insert pti;
		ApexPages.StandardController sc = new ApexPages.StandardController(pti);
		return sc.edit();
	}
	**/
	public PageReference savePage() {
		try {
			update page;
		}
		catch(Exception ex) {
			ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
		
		return null;
	}

	
	//get the site id for the current page
	public String getSiteId() {		
		String siteid = CMSForceUtils.findRootFolder(page.Folder__c).Site_Id__c;
		return siteid;
	}
	
	//check if the needed custom settings are initialed
	//if not redirect to the setup page
	public PageReference checkSetup() {		
		if(CMSForceDomain__c.getAll().get('cmsforcedomain') == null || CMSForceSites__c.getAll().isEmpty()) {
			return new PageReference('/apex/CMSForceSetup?showheader=true');
		}
		return null; 
	}
	
	
	/** TESTS **/
	private static testMethod void t1() {
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
		
		Test.setCurrentPage(Page.CMSForceConsole);
		CMSForceConsoleController ccc = new CMSForceConsoleController();
		
		ccc.selectednode = pg.Id;
		ccc.editPageProperties();
		System.assertEquals(pg.Id, ccc.page.Id);
		ccc.savePage();
		System.assertEquals(siteid.substring(0,15), ccc.getSiteId());
		ccc.checkSetup();
		
	}
	

}