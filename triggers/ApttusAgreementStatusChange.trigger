/*
* NAME : ApttusAgreementStatusChange
* NOTE : Trigger to Update Status and Status Progress of Agreement to In Authoring/In Authoring while Attachment Related to Agreement(having statuses - Agreement/Only Metadata) is Checked In. 
* Author : Apttus (Axay Varu) 30-04-2013
*/
trigger ApttusAgreementStatusChange on Attachment (after insert,after update) {

	List<Attachment> lstAtmnt = Trigger.NEW;
	Set<ID> agmtID = new Set<ID>();
	List<Apttus__APTS_Agreement__c> lstAgreement = new List<Apttus__APTS_Agreement__c>(); // list of agreement
	List<Apttus__APTS_Agreement__c> lstUpdateAgreement = new List<Apttus__APTS_Agreement__c>(); //list of agreement to update
	String objKey = Apttus__APTS_Agreement__c.SObjectType.getDescribe().getKeyPrefix(); //get keyPrefix of Agreement to ensure that Parent ID of attachment is agreement
	String ParentIds = null;
	
	for(Attachment atmnt : lstAtmnt)
	{
		ParentIds = atmnt.ParentID;
		if(ParentIds != null && ParentIds.subString(0,3).equals(objKey))
		{
			agmtID.add(atmnt.ParentID);
		}
		
		ParentIds = null;
	}
	
	lstAgreement = [SELECT ID,Apttus__Status__c,Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c 
	WHERE Apttus__Status__c = 'Only Metadata' AND Apttus__Status_Category__c = 'Agreement' AND ID IN :agmtID];
	
	if(lstAgreement.size() > 0)
	{
		for(Apttus__APTS_Agreement__c agmt : lstAgreement)
		{
			agmt.Apttus__Status__c = 'In Authoring';
			agmt.Apttus__Status_Category__c = 'In Authoring';
			lstUpdateAgreement.add(agmt);
		}
	}
	
	if(lstUpdateAgreement.size() > 0)
	update lstUpdateAgreement;
}