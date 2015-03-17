trigger LeadPoints on Lead (after insert, after update) {
    List<Lead> oChangeLeads;
	Map<Id,Decimal> newIDMap = new Map<Id,Decimal>();
	Map<Id,Decimal> oldIDMap = new Map<Id,Decimal>();
	List<UserData__c> UserDataList = new List<UserData__c>();
	Map<ID,UserData__c> UDMap = new Map<ID,UserData__c>();       

	InUseRoster__c fieldProperties = InUseRoster__c.getInstance('lead');
	if (fieldProperties == null) return;	//no field to incrememnt

	String UD_FieldStr = fieldProperties.UD_WorkloadField__c;
	String Lead_FieldStr = fieldProperties.WorkloadIncrementField__c;

	if (UD_FieldStr != null) {
	
		if (trigger.isUpdate) {
		    oChangeLeads = new List<Lead>();
			for(Lead leadObj : trigger.new){
			    
			    Id oldOwnerId = trigger.oldMap.get(leadObj.Id).OwnerId;
			    Id newOwnerId = leadObj.OwnerId;
			    if((newOwnerId != oldOwnerId)){ 
					Decimal newD = newIDMap.get(newOwnerId);
					Decimal oldD = oldIDMap.get(oldOwnerId);
	
					Decimal thisLeadPoints;
					if (Lead_FieldStr == null) thisLeadPoints = 1;
					else thisLeadPoints = (Decimal)leadObj.get(Lead_FieldStr);
	
					if (thisLeadPoints == null) thisLeadPoints = 0;
	
					if (newD == null)
						newD = 0;
					newIDMap.put(newOwnerID, newD + thisLeadPoints);
	
					if (oldD == null)
						oldD = 0;
					oldIDMap.put(oldOwnerId ,oldD + thisLeadPoints);
	
			        oChangeLeads.add(leadObj);               
			    }
			}
		} else {
			for(Lead leadObj : trigger.new){
			    Id newOwnerId = leadObj.OwnerId;
				Decimal newD = newIDMap.get(newOwnerId);
	
				Decimal thisLeadPoints;
				if (Lead_FieldStr == null) thisLeadPoints = 1;
				else thisLeadPoints = (Decimal)leadObj.get(Lead_FieldStr);
	
				if (thisLeadPoints == null) thisLeadPoints = 0;
	
				if (newD == null)
					newD = 0;
			    	
		    	newIDMap.put(newOwnerId, newD + thisLeadPoints);
			}
			oChangeLeads = trigger.new;
		}
	
		Set<ID> queryIDs = newIdMap.keyset().clone();
		queryIDs.addAll(oldIdMap.keyset());
		
		//query user data
		//construct query string
		String qStr = 'Select id, User__c, User__r.username, ' + UD_FieldStr + ' From UserData__c ' +
			'where User__c IN :queryIDs';
	
		//query with this string
		SObject[] qRes = Database.query(qStr);
		for (sObject o : qRes) {
			UserData__c oUD = (UserData__c)o;
			UDMap.put(oUD.User__c,oUD);
		}
	    // decrementing the WorkLoadPoints for old Owner
	    
	    UserData__c userDataObj;
	
	    for(Id userID :oldIdMap.keyset()){
	        userDataObj= UDMap.get(userId);
	        if(userDataObj != null) {
				Decimal currentPts = (Decimal)userDataObj.get(UD_FieldStr);
				if (currentPts != null) {
					userDataObj.put(UD_FieldStr, currentPts - oldIdMap.get(userID));
				} else {
					userDataObj.put(UD_FieldStr, -1 * oldIdMap.get(userID));
				}
	        }
	    }
	    
	    // incrementing the WorkLoadPoints for new Owner
	    for(Id userID :newIdMap.keyset()){
	        userDataObj= UDMap.get(userId);
	        if(userDataObj != null) {
				Decimal currentPts = (Decimal)userDataObj.get(UD_FieldStr);
				if (currentPts != null) {
					userDataObj.put(UD_FieldStr, currentPts + newIdMap.get(userID));
				} else {
					userDataObj.put(UD_FieldStr, newIdMap.get(userID));
				}
	        }
	    }
	update(UDMap.values());
	}
}