//when we update an RS, we need to reflect the new parameter value selections in the RuleBitz object
trigger RS_afterUpdate on RuleScenario__c (after update) {

	//split trigger collection by object
	Map<String, List<RuleScenario__c>> triggerNewMap = new Map<String, List<RuleScenario__c>> (); 
	for (RuleScenario__c rs : trigger.new) {
		List<RuleScenario__c> thisList = triggerNewMap.get(rs.ruleObjectInternal__c);
		if (thisList == null) {
			thisList = new List<RuleScenario__c>();
			triggerNewMap.put(rs.ruleObjectInternal__c, thisList);
		}
		thisList.add(rs);
	}	
	
	//run logic on each collection
	for (String oName : triggerNewMap.keySet())
		OAE_TriggerUtils.modifyBitzOnRSUpdate(triggerNewMap.get(oName), trigger.oldMap, oName);
	//damn the consequences
}