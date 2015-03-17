trigger RS_beforeDelete on RuleScenario__c (before delete) {
	//get rule object names
	Set<String> ruleObjNames = new Set<String>();
	for (RuleScenario__c rs : trigger.old)
		ruleObjNames.add(rs.ruleObjectInternal__c);

//get rosters
	Map<String,InUseRoster__c> rosterMap = new Map<String,InUseRoster__c>();	//rosters keyed by objName
	for (String oName : ruleObjNames) {
		if (!rosterMap.containsKey(oName)) {
			InUseRoster__c ruleRoster = InUseRoster__c.getInstance('RS_'+oName);
			rosterMap.put(oName, ruleRoster);
		}
	}

	//list of the RS numbers for each object type, in bitmap form, keyed by object name
	//e.g. we've deleteed rules 5 & 3:  010100
	Map<String, Long> objectRulesRemovedMaskMap = new Map<String,Long>();
	
	for (RuleScenario__c rs : trigger.old) {
		InUseRoster__c thisRoster = rosterMap.get(rs.ruleObjectInternal__c);

		Long bitMask = 1L<<(rs.RuleNumber__c.intValue()-1);			//eg 0010000 for rule #5

		//keep track of what we've created, for the rule bitz
		Long thisLong = objectRulesRemovedMaskMap.get(rs.ruleObjectInternal__c);
		if (thisLong == null) 
			thisLong = 0;
		thisLong = thisLong | bitMask;
		objectRulesRemovedMaskMap.put(rs.ruleObjectInternal__c,thisLong);
	}
	
	for (String s : rosterMap.keyset()) {
		InUseRoster__c thisRoster = rosterMap.get(s);
		Long deleteMask = objectRulesRemovedMaskMap.get(s);
		thisRoster.Bitz__c = OAE_Utils.flipOff(thisRoster.Bitz__c.longValue(), deleteMask, false);
	}
	for(InUseRoster__c updateMe : rosterMap.values())
		update updateMe;

	//query for all rulebitz
	List<RuleBitz__c> allBitz = [select objectType__c, ruleBitArray__c from rulebitz__c
								where objectType__c in :ruleObjNames];
	for (RuleBitz__c rb : allBitz) {
		Long deleteMask = objectRulesRemovedMaskMap.get(rb.objectType__c);
		rb.ruleBitArray__c = OAE_Utils.flipOff(rb.ruleBitArray__c.longValue(), deleteMask, false);
	}
	update allBitz;

}
/*
trigger RS_beforeDelete on RuleScenario__c (before delete) {
	//find the next number for the RS
	EngineProperties__c ep = EngineProperties__c.getInstance('RuleScenarioSet');
	//throw some error if that's not there.  "Shame on you for deleting it."
	Long deletedRS = 0;
	
	for (RuleScenario__c rs : trigger.old) {
		deletedRS = deletedRS | 1L<<(rs.RuleNumber__c.intvalue()-1);
	}
	
	ep.Bitz__c = OAE_Utils.flipOff(ep.Bitz__c.longValue(), deletedRS, false);
	update ep;

	//query for all rulebitz
	List<RuleBitz__c> allBitz = [select paramValue__c, rule_bit_array__c from rulebitz__c];
	for (RuleBitz__c rb : allBitz) {
		rb.rule_bit_array__c = OAE_Utils.flipOff(rb.rule_bit_array__c.longValue(),deletedRS,false);
	}
	update allBitz;

}
*/