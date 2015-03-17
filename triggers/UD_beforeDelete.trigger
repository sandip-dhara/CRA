trigger UD_beforeDelete on UserData__c (before delete) {
    //figure out how many sets of users we have
    EngineProperties__c ep = EngineProperties__c.getInstance('NextUserSet');
    Double userSetCount = ep.DoubleValue__c;

    //create an array of roster objects holding the user assingment pattern
    List<InUseRoster__c> userPattern = new List<InUseRoster__c>();

    String prefix = 'User';  //for fetching InUseRoster settings

    //get the N roster settings for userdata
    for (Integer i = 0; i < userSetCount; i++) {
        InUseRoster__c iur = InUseRoster__c.getInstance(prefix + i);
        userPattern.add(iur);
    }

    Integer setCount;  //for knowing which item to pull from userPattern

    for (UserData__c ud : trigger.old) {
        setCount = ((ud.UserNumber__c - 1)/ 50).intValue();
        InUseRoster__c thisRoster = userPattern.get(setCount);
        if (thisRoster != null) {
            thisRoster.Bitz__c = OAE_Utils.flipOff(thisRoster.Bitz__c.longValue(), 1L<<(Math.mod((ud.UserNumber__c-1).intValue(),50)), false);
        }
    }

    update userPattern;

    OAE_TriggerUtils.deleteUD(trigger.old);

}