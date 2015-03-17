/*
* NAME : AcceptAgreementTrigger
* NOTE : This Trigger is fired when user pick up Agreement from Queue
*		 we have Owner status formula field this will tell us wheather the owner is User or Queue
*		 based on that we can evaluate the owner & Update Legal Owner field to Logged in user(who pick up agreement from queue)
* Author : Apttus (Axay Varu)
*/
trigger AcceptAgreementTrigger on Apttus__APTS_Agreement__c (before update,before delete) {

    public static Boolean flag = true;
    public Integer i = 0;  
    public List<Legal_Issue__c> lstLegalIssue = new List<Legal_Issue__c>();
    public set<ID> agmtIDs = new set<ID>();
    
    if(Trigger.isUpdate){
    	
    	Map<String,String> mapRecrdTypeAbbreviation = new Map<String,String>();
    	List<RecordType> lstRecordType = [Select Id,Name From RecordType where sObjectType = 'Apttus__APTS_Agreement__c'];
    	mapRecrdTypeAbbreviation = getRecordTypeAbbrivations(); // get all record type abbriviations map
    	Map<Id,String> mapRecordTypeIdName = new Map<Id,String>();
    
    	for(RecordType rt : lstRecordType){
        	mapRecordTypeIdName.put(rt.Id,rt.Name);
    	}
    	if(flag){
		    for (Apttus__APTS_Agreement__c agreement: Trigger.new){
		    	
		    	if(mapRecrdTypeAbbreviation.get(mapRecordTypeIdName.get(agreement.RecordTypeId)) != null){
            		Trigger.New[i].Contract_Type_Abbreviation__c = mapRecrdTypeAbbreviation.get(mapRecordTypeIdName.get(agreement.RecordTypeId));
		    	} 
		        
		        Apttus__APTS_Agreement__c oldCase = Trigger.oldMap.get(agreement.ID); 
		        if (agreement.Owner_Status__c.equals('User') && oldCase.Owner_Status__c.equals('Queue')){
		            Trigger.New[i].Legal_Owner__c = UserInfo.getUserID();
		           }
		            i++;
		        }
		  flag = false;
		 }
    }
    
    if(Trigger.isDelete) {
    	
    	for(Apttus__APTS_Agreement__c agmt : Trigger.OLD){
    		agmtIDs.add(agmt.ID);
    	}
    	lstLegalIssue = [SELECT ID,NAME,Agreement__c FROM Legal_Issue__c WHERE Agreement__c IN :agmtIDs];
    	if(lstLegalIssue.size() > 0){
    		delete lstLegalIssue;
    	}
    }
    
    //method will return Map of Record type & its relative abbriviation
    private Map<String, String> getRecordTypeAbbrivations() {
    	List<Apttus_Record_Type_Abbrivations__c> abbrivations = [SELECT Record_Type_Abbrivation__c,Record_Type_Name__c 
    															 FROM Apttus_Record_Type_Abbrivations__c];
    	Map<String, String> myAbbrivatoins = new Map<String, String> ();
    	for(Apttus_Record_Type_Abbrivations__c rAbbrivations : abbrivations) {
    		myAbbrivatoins.put(rAbbrivations.Record_Type_Name__c, rAbbrivations.Record_Type_Abbrivation__c);
    	}
    	return myAbbrivatoins;
    }  
}