trigger UD_afterUpdate on UserData__c (after update) {
	//loop thru UMF for base == userdata__c
	//get the order and the path, for all objects
	OAE_TriggerUtils.updateUD(trigger.new, trigger.oldMap);

	/*
    Map<String,String> removes = new Map<String,String>();
    Map<String,String> adds = new Map<String,String>();

	//get the parent's user number
	Map<ID,Long> parentMap = new Map<ID,Long>();
	for (UserData__c ud : trigger.new)
		parentMap.put(ud.id,ud.UserNumber__c.longValue());

	//creat a map of parameters and numbers
    Map<String,UserMatchFields__c> umfNames = UserMatchFields__c.getAll();
	Map<String,Long> paramNums = new Map<String,Long>();

	for (UserMatchFields__c umf : umfNames.values()) {
		if (umf.base__c == 'UserData__c') {
			paramNums.put(umf.Path__c,umf.order__c.longValue());
		}
	}

	UserData__c oldUD;
	String bitzPVString;

	for (UserData__c ud : trigger.new) {
		Long userNum = parentMap.get(ud.id);
		oldUD = trigger.oldMap.get(ud.id);

		//look at each UD-based parameter to see if it has changed
		for (String path : paramNums.keyset()) {
			if (ud.get(path) != oldUD.get(path)) {
				//park old value in removes collection
				bitzPVString = paramNums.get(path)+';'+oldUD.get(path);
				removes.put(userNum+';'+bitzPVString, bitzPVString);

				//park new value in adds collection
				bitzPVString = paramNums.get(path)+';'+ud.get(path);
				adds.put(userNum+';'+bitzPVString, bitzPVString);

			}
		}
	}

    Set<String> allValues = new Set<String>();
    //create full stack
    allValues.addall(removes.values());
    allValues.addall(adds.values());

    //load all relevant bitz
    List<UserBitz__c> rulez = [select id, paramvalue__c, UBArray1__c from UserBitz__c where paramvalue__c in :allValues];

    //make a map keyed by paramvalue
    Map<String, UserBitz__c> ruleMap = new Map<String, UserBitz__c>();
    for (UserBitz__c rz : rulez)
        ruleMap.put(rz.paramvalue__c, rz);

    //update / create new
    UserBitz__c thisBitz;
    Map<String, UserBitz__c> newBitz = new Map<String, UserBitz__c>();
	Integer thisUNum;
	String[] numParam;

    for (String s : adds.keyset()) {
		numParam = s.split(';',2);
//TODO null check??
		thisUNum = Integer.valueOf(numParam[0]);
        thisBitz = ruleMap.get(numParam[1]);
        if (thisBitz == null)
            thisBitz = newBitz.get(numParam[1]);
        if (thisBitz == null) {
            thisBitz = new UserBitz__c();
            thisBitz.paramvalue__c = numParam[1];
            thisBitz.UBArray1__c = 0;
            newBitz.put(numParam[1],thisBitz);
        }
        thisBitz.UBArray1__c = OAE_Utils.flipOn(thisBitz.UBArray1__c.longValue(), thisUNum);
    }

    for (String s : removes.keyset()) {
		numParam = s.split(';',2);
//TODO null check??
		thisUNum = Integer.valueOf(numParam[0]);
        thisBitz = ruleMap.get(numParam[1]);
        if (thisBitz == null)
            thisBitz = newBitz.get(numParam[1]);
        if (thisBitz != null)
            thisBitz.UBArray1__c = OAE_Utils.flipOff(thisBitz.UBArray1__c.longValue(), thisUNum);
    }

    insert newBitz.values();
    update ruleMap.values();
*/
}