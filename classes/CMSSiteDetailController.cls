public with sharing class CMSSiteDetailController {

	public String homepreview {get;set;}
	public String instance {get;set;}
	public Site s {get;set;}
	
	public CMSSiteDetailController() {
		try {
			String id = System.currentPageReference().getParameters().get('id').substring(0,15);
			instance = CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c;
			homepreview = CMSForceSites__c.getAll().get(id).Site_Url__c;
			//add a random integer var to avoid the page being pulled from the browser or proxy caches
			homepreview = homepreview + '?nocache=' + Encodingutil.urlEncode(Math.random().format(), 'UTF-8');
			s = [Select s.Status, s.MasterLabel, s.Description From Site s where s.Id =:id];
		}
		catch(Exception ex) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No CMSForce home page found for this site'));
		}
	}
	
	
	/** TESTS **/
	private static testMethod void t1() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;
		String shortid = siteid.substring(0,15);
		Test.setCurrentPage(Page.CMSSiteDetail);
		ApexPages.currentPage().getParameters().put('id', shortid);
		CMSSiteDetailController cdc = new CMSSiteDetailController();
		System.assert(true); //nothing to assert. The custom settings will be empty on installation and this will throw an error
		if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null && CMSForceSites__c.getAll().get(shortid) != null) {
			System.assert(cdc.homepreview != null && cdc.instance != null);
		}
	}

}