public with sharing class PreviewPageController {

	public PageReference preview() {
		//find the root folder this page belongs to
		String pageid = System.currentPageReference().getParameters().get('pageid');
		String console = System.currentPageReference().getParameters().get('console');
		String fullscreen = System.currentPageReference().getParameters().get('fullscreen');
		
		Page__c p = [Select p.Id, p.Folder__c From Page__c p where p.Id =:pageid];
		//get the root folder for this page. It will have a reference to the site
		CMSFolder__c topfolder = CMSForceUtils.findRootFolder(p.Folder__c);
		String siteid = topfolder.Site_Id__c;
		String previewurl = '';
		if(CMSForceSites__c.getAll().get(siteid) != null) previewurl = CMSForceSites__c.getAll().get(siteid).Site_Url__c + '/page?pageid='+pageid;
		
		//if we're in the console, pass on the console = true param and provide the callback edit url from sites to the org		
		if(console == 'true') {
			String sfdcorg = '';
			if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null) sfdcorg = CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c;			
			previewurl = previewurl + '&console=true&pod='+Encodingutil.urlEncode(sfdcorg, 'UTF-8');
		}
		//if we're also in fullscreen preview, pass that as well
		if(fullscreen=='true') {
			previewurl = previewurl+ '&fullscreen=true';
		}
		//add a random integer var to avoid the page being pulled from the browser or proxy caches
		previewurl = previewurl + '&nocache=' + Encodingutil.urlEncode(Math.random().format(), 'UTF-8');
		return new PageReference(previewurl);
	}


	/** TESTS**/
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
		
		Test.setCurrentPage(Page.PreviewPage);
		ApexPages.currentPage().getParameters().put('pageid',pg.Id);
		ApexPages.currentPage().getParameters().put('console','true');
		ApexPages.currentPage().getParameters().put('fullscreen','true');
		PreviewPageController ppc = new PreviewPageController();
		System.assert(ppc.preview() != null);
		
	}

}