public with sharing class CMSForceUtils {


	//returns the top level folder for any folder id.
	public static CMSFolder__c findRootFolder(ID folderid) {
		//query to five levels up
		List<CMSFolder__c> parents = [Select 
			c.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c
			From CMSFolder__c c
			where c.Id =:folderid];
		//if the top level one still has a parent, keep going five levels up untill we hit 'null' parent folders
		ID topfolderid = parents[0].Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c;
		while(topfolderid != null) {
			parents = [Select 
				c.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c
				From CMSFolder__c c
				where c.Id =:topfolderid];
			topfolderid = parents[0].Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c;
		}
		//when this is over, our parents list should contain the top folder somewhere in it's five levels
		CMSFolder__c folder = parents[0];
		if(folder.Parent_CMSFolder__c == null) return getfolder(folder.Id);
		if(folder.Parent_CMSFolder__r.Parent_CMSFolder__c == null) return getFolder(folder.Parent_CMSFolder__c);
		if(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c == null) return getFolder(folder.Parent_CMSFolder__r.Parent_CMSFolder__c);
		if(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c == null) return getFolder(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c);
		if(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c == null) return getFolder(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c);
		if(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c == null) return getFolder(folder.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__r.Parent_CMSFolder__c);
		return null;
	}
	
	//fills a CMSFolder with some fields
	private static CMSFolder__c getFolder(ID folderid) {
		CMSFolder__c f = [select Id, Name, Site_Id__c from CMSFolder__c where Id =:folderid];
		return f;		
	}
	
	//gets the objecttype for a certain sfid
    public static String getObjectType(String sfid) {
        //Determine the object type of the id passed to this method
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String,String> keyPrefixMap = new Map<String,String>{};
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
           Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
           String tempName = r.getName();
           String tempPrefix = r.getKeyPrefix();
           keyPrefixMap.put(tempPrefix,tempName);
        }
        //prefix is just the first 3 chars
        String prefix = sfid.substring(0,3);
        String objecttype = keyPrefixMap.get(prefix);
        return objecttype;
    }

}