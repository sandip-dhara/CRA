trigger US_afterDelete on UserSkill__c (after delete) {
    //get UserNumbers for all relevant UserData objects
    Map<ID,Integer> parentMap = new Map<ID,Integer>();
    Set<ID> parentIDs = new Set<ID>();

    //split up collection by object
    Map<String,List<UserSkill__c>> triggerOldMap = new Map<String,List<UserSkill__c>>(); 

    for (UserSkill__c us : trigger.old) {
        //get all the parent ids for query
        parentIDs.add(us.userdata__c);
        //split by object
        List<UserSkill__c> thisList = triggerOldMap.get(us.baseObject__c);
        if (thisList == null) {
            thisList = new List<UserSkill__c>();
            triggerOldMap.put(us.baseObject__c, thisList);
        }
        thisList.add(us);
    }
        
    //query for parent userdata's user number, map by userdata ID
    for (UserData__c ud : [select id, UserNumber__c from UserData__c where id in :parentIDs])
        parentMap.put(ud.id,ud.UserNumber__c.intValue());

    for (String s : triggerOldMap.keySet())
        OAE_TriggerUtils.deleteUS(triggerOldMap.get(s), parentMap, s);
}