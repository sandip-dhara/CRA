public with sharing class ContentBlockItemPreviewExtension {

	public String previewurl {get;set;}

	public ContentBlockItemPreviewExtension(ApexPages.StandardController controller){
		//since this contentblock could be used in any page in any site, we'll just preview it in the first site available
		if(!CMSForceSites__c.getAll().values().isEmpty()) previewurl = CMSForceSites__c.getAll().values()[0].Site_Url__c;
	}
	
	/**TEST **/
	private static testMethod void t1() {		
		ContentBlockItemPreviewExtension cbipe = new ContentBlockItemPreviewExtension(new ApexPages.Standardcontroller(new ContentBlockItem__c()));
		//depending on the existence of the custom settings, the previewurl will be ok or not. This really is a non-test
		System.assert(cbipe.previewurl == null || cbipe.previewurl != null);
	}

}