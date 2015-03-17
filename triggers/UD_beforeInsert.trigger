trigger UD_beforeInsert on UserData__c (before insert) {
//1.  figure out what number the user is based on existing numbers
    Boolean saveEP = false;     //did we flip to a new user count
    InUseRoster__c newRoster;   //only gets used when we create a new roster object

    //how many sets of users we have
    EngineProperties__c ep = EngineProperties__c.getInstance('NextUserSet');
    Double userSetCount = ep.DoubleValue__c;

    //array of roster objects holding the existing user assingment pattern
    List<InUseRoster__c> userPattern = new List<InUseRoster__c>();
    
    String prefix = 'User';  //for fetching InUseRoster settings
    
    //get the N roster settings for userdata assignment patterns
    for (Integer i = 0; i < userSetCount; i++) {
        InUseRoster__c iur = InUseRoster__c.getInstance(prefix + i);
        userPattern.add(iur);
    }

    //Keeps count while we're looking through the previously used numbers
    Integer nextNumber = 0;
    //Keeps track of our place in the set (faster than a mod operation)
    Integer setCount = 0;
    //Keeps track of the next set to check
//TODO: an engine property with the last user used here so we don't have to start at zero every time
    Integer thisSet = 0;
    
    //start with the first set
    if (userPattern.size() == 0) {
        system.debug('deb001test');
        InUseRoster__c firstOne = new InUseRoster__c(name='User0',bitz__c=0);
        insert firstOne;
        userPattern.add(firstOne);
        ep.DoubleValue__c = 1;
        saveEP = true;
    }
    Long udBitz = userPattern[thisSet].bitz__c.longValue();

    for (UserData__c ud : trigger.new) {
        //go through all the bits looking for the first zero.  That's our user number
        while ((udBitz & 1) == 1) {
            nextNumber++;
            udBitz = udBitz >> 1L;
            //check if we've reached the end of the set
            if (++setCount == 50) {
                thisSet++;
                //got to 50; see if there's another 60-bit roster in the pattern array
                if (userPattern.size() > thisSet) {
                    udBitz = userPattern[thisSet].bitz__c.longValue();
                    setCount = 0;
                } else {
                    //if not we need to start one
//TODO: Bulkify in case over 50 new user data objects get made at once, make newRoster a list
                    newRoster = new InUseRoster__c();
                    newRoster.Name = prefix + thisSet;
                    newRoster.bitz__c = 0L;
                    udBitz = 0L;
                    ep.DoubleValue__c = ep.DoubleValue__c + 1;
                    saveEP = true;
                }
            }
        }
        //set the user number
        ud.UserNumber__c = ++nextNumber;
        //flip the bit on the roster
        userPattern[thisSet].bitz__c = userPattern[thisSet].bitz__c.longValue() | 1L<<(setCount++);
        udBitz = udBitz >> 1L;
    }
    //update back the flipped-on bits for future use
    update userPattern; 

    if (newRoster != null) {
        //save off the newbie if we made one
        insert newRoster;
    }
    if (saveEP) update ep;

//2.  Append the UserBitz with whatever field values were set
    OAE_TriggerUtils.insertUD(trigger.new);
}