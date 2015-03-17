trigger RQ_beforeInsert on Requirement__c (before insert, before update) {
	for (Requirement__c rq : trigger.new)
		rq.isDynamic__c = (rq.Value__c != null && rq.Value__c.startsWith('$'));
}