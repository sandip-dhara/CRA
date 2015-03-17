trigger US_afterUpdate on UserSkill__c (after update) {
	//get UserNumbers for all relevant UserData objects
	Map<ID,Integer> parentMap = new Map<ID,Integer>();
	Set<ID> parentIDs = new Set<ID>();

	//split up collection by object
	Map<String,List<UserSkill__c>> triggerNewMap = new Map<String,List<UserSkill__c>>(); 

	for (UserSkill__c us : trigger.new) {
		//get all the parent ids for query
		parentIDs.add(us.userdata__c);
		//split by object
		List<UserSkill__c> thisList = triggerNewMap.get(us.baseObject__c);
		if (thisList == null) {
			thisList = new List<UserSkill__c>();
			triggerNewMap.put(us.baseObject__c, thisList);
		}
		thisList.add(us);
	}
		
	//query for parent userdata's user number, map by userdata ID
	for (UserData__c ud : [select id, UserNumber__c from UserData__c where id in :parentIDs])
		parentMap.put(ud.id,ud.UserNumber__c.intValue());

	for (String s : triggerNewMap.keySet())
		OAE_TriggerUtils.updateUS(triggerNewMap.get(s), trigger.oldMap, parentMap, s);		
/*	
//    Map<String,Decimal> removes = new Map<String,Decimal>();
//    Map<String,Decimal> adds = new Map<String,Decimal>();
    Map<String,String> removes = new Map<String,String>();
    Map<String,String> adds = new Map<String,String>();

	//get the parent's user number
//	Map<ID,Decimal> parentMap = new Map<ID,Decimal>();
	Map<ID,Decimal> parentMap = new Map<ID,Long>();
	for (UserSkill__c us : [select id, UserData__r.UserNumber__c from UserSkill__c where id in :trigger.new])
//		parentMap.put(us.id,us.UserData__r.UserNumber__c);
		parentMap.put(us.id,us.UserData__r.UserNumber__c.longValue());

	//creat a map of parameters and numbers 
    Map<String,UserMatchFields__c> umfNames = UserMatchFields__c.getAll();
	Map<String,Decimal> paramNums = new Map<String,Decimal>();

	for (UserMatchFields__c umf : umfNames.values())
		paramNums.put(umf.label__c,umf.order__c);

	String bitzPVString;
	String noLevelCheck;
	UserSkill__c oldUS;
	
	for (UserSkill__c us : trigger.new) {
//		Decimal userNum = parentMap.get(us.id);
		Long userNum = parentMap.get(us.id).longValue();
		//will need to check if product is changing, or just param/val/level
		//for now, punting, and just doing p/v/l

		//get the condensed parameter/value string
		bitzPVString = paramNums.get(us.parameter__c).intValue() + ';' + us.Value__c;
//		adds.put(bitzPVString, userNum);
		adds.put(userNum + ';' + bitzPVString, bitzPVString);
		
		noLevelCheck = bitzPVString;
		
		//check if there's a level involved
		if (us.level__c != null && us.level__c != '') {
			bitzPVString = bitzPVString + ';' + us.level__c;
//			adds.put(bitzPVString, userNum);
			adds.put(userNum + ';' + bitzPVString, bitzPVString);
		}
		
		//get the old one to remove
		oldUS = trigger.oldMap.get(us.id);
		if (oldUS != null) {
			Decimal pNum = paramNums.get(oldUS.parameter__c);
			if (pNum != null) {
				//get the condensed parameter/value string
				bitzPVString = pNum.intValue() + ';' + oldUS.Value__c;
				if (bitzPVString != noLevelCheck)
//					removes.put(bitzPVString, userNum);
					removes.put(userNum + ';' + bitzPVString, bitzPVString);

				//check if there's a level involved
				if (oldUS.level__c != null && oldUS.level__c != '') {
					bitzPVString = bitzPVString + ';' + oldUS.level__c;
//					removes.put(bitzPVString, userNum);
					removes.put(userNum + ';' + bitzPVString, bitzPVString);
				}
			}
		}		
	}

    Set<String> allValues = new Set<String>();
    //create full stack
//    allValues.addall(removes.keyset());
//    allValues.addall(adds.keyset());
    allValues.addall(removes.values());
    allValues.addall(adds.values());

    //load all relevant bitz
//TODO make this a dynamic query
    List<UserBitz__c> rulez = [select id, paramvalue__c, UBArray1__c from UserBitz__c where paramvalue__c in :allValues];
    
    //make a map keyed by paramvalue
    Map<String, UserBitz__c> ruleMap = new Map<String, UserBitz__c>();
    for (UserBitz__c rz : rulez)
        ruleMap.put(rz.paramvalue__c, rz);
        
    //update / create new
    UserBitz__c thisBitz;
    Map<String, UserBitz__c> newBitz = new Map<String, UserBitz__c>();
//	Decimal thisUNum;
	Integer thisUNum;
	String[] numParam;
    
    for (String s : adds.keyset()) {
//		thisUNum = adds.get(s);
//        thisBitz = ruleMap.get(s);
		numParam = s.split(';',2);
//TODO null check??
		thisUNum = Integer.valueOf(numParam[0]);
		thisBitz = ruleMap.get(numParam[1]);
        if (thisBitz == null)
//            thisBitz = newBitz.get(s);
			thisBitz = newBitz.get(numParam[1]);
        if (thisBitz == null) {
            thisBitz = new UserBitz__c();
//            thisBitz.paramvalue__c = s;
			thisBitz.paramvalue__c = numParam[1];
            thisBitz.UBArray1__c = 0;
//            newBitz.put(s,thisBitz);
			newBitz.put(numParam[1],thisBitz);
        }
//TODO select UBArray by userNum
//        thisBitz.UBArray1__c = BitSwap.flipOn(thisBitz.UBArray1__c.longValue(), thisUNum.IntValue());
        thisBitz.UBArray1__c = BitSwap.flipOn(thisBitz.UBArray1__c.longValue(), thisUNum);
    }

    for (String s : removes.keyset()) {
//		thisUNum = removes.get(s);
//        thisBitz = ruleMap.get(s);
		numParam = s.split(';',2);
//TODO null check??
		thisUNum = Integer.valueOf(numParam[0]);
		thisBitz = ruleMap.get(numParam[1]);
        if (thisBitz == null)
//            thisBitz = newBitz.get(s);
			thisBitz = newBitz.get(numParam[1]);
        if (thisBitz != null)
//TODO select UBArray by userNum
//            thisBitz.UBArray1__c = BitSwap.flipOff(thisBitz.UBArray1__c.longValue(), thisUNum.IntValue());
			thisBitz.UBArray1__c = BitSwap.flipOff(thisBitz.UBArray1__c.longValue(), thisUNum);
    }

    insert newBitz.values();
    update ruleMap.values();
*/
}