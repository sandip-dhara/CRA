trigger OAE_SC_beforeInsert on Scoring__c (before insert, before update) {
	for (Scoring__c sc : trigger.new)
		sc.isDynamic__c = (sc.Value__c != null && sc.Value__c.startsWith('$'));
}