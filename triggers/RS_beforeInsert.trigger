//when creating a rule, we need to dynamically assign a number based on the in use roster
//also, rules are created without parameter values
//the "__all__" bitz for each should thus be set to include the new rule scenario (until it gets parameter values)
trigger RS_beforeInsert on RuleScenario__c (before insert) {
//get rule object names
	Set<String> ruleObjLabels = new Set<String>();
	for (RuleScenario__c rs : trigger.new)
		ruleObjLabels.add(rs.ruleObject__c);
	
	//get the internal names for each object
	Map<String,String> labelNameMap = new Map<String,String>();
	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
	for (String sObj : gd.keySet()) {
		String thisLabel = gd.get(sObj).getDescribe().getLabel();
		if (ruleObjLabels.contains(thisLabel)) {
			labelNameMap.put(thisLabel,sObj);
		}
	}
	for (RuleScenario__c thisRS : trigger.new) {
		thisRS.ruleObjectInternal__c = labelNameMap.get(thisRS.ruleObject__c);
	}

//get rosters
	Set<String> newRosterObjects = new Set<String>();		//object names which previously had no rules
	Map<String,InUseRoster__c> rosterMap = new Map<String,InUseRoster__c>();	//rosters keyed by objName
	for (String oName : labelNameMap.values()) {
		if (!rosterMap.containsKey(oName)) {
			InUseRoster__c ruleRoster = InUseRoster__c.getInstance('RS_'+oName);
			if (ruleRoster == null) {//first rule for an object!
				ruleRoster = new InUseRoster__c(name='RS_'+oName,bitz__c=0);
				newRosterObjects.add(oName);
			}
			rosterMap.put(oName, ruleRoster);
		}
	}

	//list of the RS numbers for each object type, in bitmap form, keyed by object name
	//e.g. we've added rules 5 & 3:  010100
	Map<String, Long> objectRulesAddedMaskMap = new Map<String,Long>();
	
	//assign rule numbers to each rule scenario based on in use roster
	for (RuleScenario__c rs : trigger.new) {
		InUseRoster__c thisRoster = rosterMap.get(rs.ruleObjectInternal__c);
		Long countBitz = thisRoster.Bitz__c.longValue();
		Integer nextNumber = 1;
		//skip to the next number (the first zero in the roster bitmap)
		while ((countBitz & 1) == 1) {
			nextNumber++;
			countBitz = countBitz >> 1L;
		}
		//when we find the smallest available number, assign to the rule
		rs.RuleNumber__c = nextNumber;

		Long bitMask = 1L<<(nextNumber-1);			//eg 0010000 for rule #5

		//keep track of what we've created, for the rule bitz
		Long thisLong = objectRulesAddedMaskMap.get(rs.ruleObjectInternal__c);
		if (thisLong == null) 
			thisLong = 0;
		thisLong = thisLong | bitMask;
		objectRulesAddedMaskMap.put(rs.ruleObjectInternal__c,thisLong);

		//doing separate so a second loop reflects the first assignment
		thisRoster.Bitz__c = thisRoster.Bitz__c.longValue() | bitMask;
	}

	//insert any first-time rosters
	Set<InUseRoster__c> newRosters = new Set<InUseRoster__c>();
	for (String s : newRosterObjects)
		insert rosterMap.get(s);

//	insert newRosters;
	//update the rest
	for (InUseRoster__c updateMe : rosterMap.values())
		update updateMe;
//	update rosterMap.values();
	
	//query for all "__all__" rulebitz for the relevant objects
	List<RuleBitz__c> allBitz = [select value__c, ruleBitArray__c, objectType__c from rulebitz__c 
								where value__c = '__all__' and objectType__c in :labelNameMap.values()];

	//mark the bitz so that the new rule scenario is included in "__all__" for each parameter
	for (RuleBitz__c rb : allBitz) {
		Long objBitMask = objectRulesAddedMaskMap.get(rb.objectType__c);
		if (objBitMask != null)
			rb.ruleBitArray__c = rb.ruleBitArray__c.longValue() | objBitMask;
	}
	update allBitz;

}
/*
trigger RS_beforeInsert on RuleScenario__c (before insert) {

//old version
	//find the next number for the RS
	EngineProperties__c ep = EngineProperties__c.getInstance('RuleScenarioSet');
	//throw some error if that's not there.  "Shame on you for deleting it."

	Long rsBitz = ep.Bitz__c.longValue();

//new version
	InUseRoster__c ruleCount = InUseRoster__c.getInstance('RuleScenario');
	Long countBitz = ruleCount.Bitz__c.longValue();

	Long addedRS = 0;
	Map<String, Long> objectAdds = new Map<String,Long>();
	Integer nextNumber = 1;
	
	for (RuleScenario__c rs : trigger.new) {
		//skip to the next number
		while ((rsBitz & 1) == 1) {
			nextNumber++;
			rsBitz = rsBitz >> 1L;
		}
		rs.RuleNumber__c = nextNumber;

		Long thisLong = objectAdds.get(rs.ruleobject__c);
		if (thisLong == null) {
			thisLong = 0;
			objectAdds.put(rs.ruleObject__c,thisLong);
		}
		thisLong = thisLong | 1L<<(nextNumber-1);

		addedRS = addedRS | 1L<<(nextNumber-1);
	}
	
	ep.Bitz__c = addedRS | ep.Bitz__c.longValue();
	update ep;
	ruleCount.Bitz__c = addedRS | ep.Bitz__c.longValue();
	update ruleCount;
	
	//query for all rulebitz
	List<RuleBitz__c> allBitz = [select paramValue__c, rule_bit_array__c, objectType__c from rulebitz__c where paramValue__c like '%;__all__'];
	//split by objects
	Map<String,List<RuleBitz__c>> keyedBitz = new Map<String,List<RuleBitz__c>>();
	for (String s : objectAdds.keySet()) 
		keyedBitz.put(s,new List<RuleBitz__c>());
		
	for (RuleBitz__c rb : allBitz) {
		List<RuleBitz__c> thisListBitz = keyedBitz.get(rb.objectType__c);
		if (thisListBitz != null) {
			thisListBitz.add(rb);
		}
	}

	for (String s : keyedBitz.keyset()) {
		List<RuleBitz__c> thisListBitz = keyedBitz.get(s);
		for (RuleBitz__c rb : thisListBitz) {
			rb.rule_bit_array__c = rb.rule_bit_array__c.longValue() | objectAdds.get(s);
		}
	}
	for (RuleBitz__c rb : allBitz) {
		rb.rule_bit_array__c = rb.rule_bit_array__c.longValue() | addedRS;
	}
	update allBitz;
}
*/