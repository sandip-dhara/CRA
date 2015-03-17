public with sharing class CMSForceSetupController {

	Map<String, CMSForceSites__c> sitesettings;
	public Map<ID,Site> sitesmap {get;set;}
	public List<sitesetup> sitesetuplist {get;set;}
	public CMSForceDomain__c currenthost {get;set;}
	public Boolean settingssaved {get;set;}

	
	public CMSForceSetupController() {
		//get a Map of the configured Sites in this org
		sitesmap = new Map<ID,Site>([Select s.UrlPathPrefix, s.TopLevelDomain, s.Subdomain, s.Status, s.Name, s.MasterLabel, s.Id, s.Description From Site s where Status = 'Active' limit 25]);
		//get the custom settings that already might exist
		sitesettings = CMSForceSites__c.getAll();
		
		//drop the Sites in the setup list
		sitesetuplist = new List<sitesetup>();
		for(Site s:sitesmap.values()) {
			sitesetup ss = new sitesetup();
			ss.siteId = s.Id;
			ss.siteName = s.MasterLabel;
			//check if we already have a preview url for this site, if so : prefill
			String siteid = s.Id;
			String shortid = siteid.substring(0,15);
			CMSForceSites__c cmsfs = sitesettings.get(shortid);
			if(cmsfs != null) { 
				ss.sitePreviewUrl = cmsfs.Site_Url__c;
				ss.customsettingId = cmsfs.Id;
			}
			sitesetuplist.add(ss);
		}
		
		//check if we already have a configured instance
		currenthost = CMSForceDomain__c.getAll().get('cmsforcedomain');
		if(currenthost == null) currenthost = new CMSForceDomain__c(Name = 'cmsforcedomain');
	}
	
	//save the preview urls back into the custom settings
	public PageReference save() {
		try {
			List<CMSForceSites__c> customsettings = new List<CMSForceSites__c>();
			
			for(sitesetup ss:sitesetuplist) {
				CMSForceSites__c s = new CMSForceSites__c(Id = ss.customsettingId);
				s.Site_Url__c = ss.sitePreviewUrl;
				//preview url is required
				if(ss.sitePreviewUrl == null || ss.sitePreviewUrl.length() == 0) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Please fill in the Preview Url address for each of the sites below'));
					return null;
				}
				s.Site_Name__c = ss.siteName;
				s.Site_Id__c = ss.siteId.substring(0,15);
				s.Name = ss.siteId.substring(0,15);
				customsettings.add(s);
			}
			if(currenthost.Url__c == null || currenthost.Url__c.length() == 0) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Please fill in your Salesforce domain'));
					return null;
			}
			if(currenthost.Url__c.endsWith('/')) currenthost.Url__c = currenthost.Url__c.substring(0,currenthost.Url__c.length()-1);
			upsert customsettings;
			upsert currenthost;
			settingssaved = true;
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your settings have been saved. You can now continue using the console.'));
		return null;
	}
	
	//internal value object
	public class sitesetup {
		public String siteId {get;set;}
		public String customsettingId {get;set;}
		public String siteName {get;set;}
		public String sitePreviewUrl {
      		get { return sitePreviewUrl; }
      		set {
      			if(value == null) {sitePreviewUrl = null; return;}
      			//remove any trailing '/'
      			if(value.endsWith('/')) {sitePreviewUrl = value.substring(0, value.length()-1);}
      			else {sitePreviewUrl = value;}
      		}
   		}
		
	}
	
	
	/** TESTS **/
	private static testMethod void t1() {
		CMSForceSetupController csc = new CMSForceSetupController();
		//we should have at least one active Site
		System.assert(!csc.sitesetuplist.isEmpty());
		
		//get the first site setup and fill in a custom setting (provide trailing '/' to get the cleanup code to run)
		sitesetup ss = csc.sitesetuplist[0];
		ss.sitePreviewUrl = 'http://somesite.force.com/someprefix/';
		//and provide the instance we're running in
		csc.currenthost.Url__c = 'https://na1.salesforce.com/';
		csc.save();		
		if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null) System.assertEquals(CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c, 'https://na1.salesforce.com');		
		
	}

}