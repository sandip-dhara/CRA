public with sharing class OAE_TriggerUtils {
    private static final Integer f_legalParamCount = 10;
//TODO grab this from the custom setting
    private static EngineProperties__c ep_Maxnumber = EngineProperties__c.getInstance('NextUserSet');
    //private static final Integer f_userColumns = 8;
    private static final Integer f_userColumns = Integer.valueOf(ep_Maxnumber.DoubleValue__c);
    private static final Integer f_bitsPerLong = 50;

/* ruleScenario trigger helper functions begin here */
//this function sets the rulebitz when a rule scenario changes
//TODO
//this could be simplified like the userskill/userdata functions below:
//--all the adds in one collection, all the removes in another
//--create the net new
//--switch off the removes
//--switch on the adds 
    public static void modifyBitzOnRSUpdate (List<RuleScenario__c> triggerNewCollex, Map<ID,RuleScenario__c> triggerOldMap, String objType) {
        //RuleNumber-keyed maps of sets of strings
        //the sets of strings in "removes" are parameters which have been removed from rule N
        Map<Decimal,Set<String>> removes = new Map<Decimal,Set<String>>();
        //the sets of strings in "adds" are parameters which have been added to rule N
        Map<Decimal,Set<String>> adds = new Map<Decimal,Set<String>>();
        //set of all the object/parameter/value pairs that have changed, for query
        Set<String> allParamValues = new Set<String>();
    
        RuleScenario__c rsOld;      

        //get changed fields for update
        for (RuleScenario__c rs : triggerNewCollex) {
            Set<String> thisRemoveSet;
            Set<String> thisAddSet;
            Decimal ruleNum = rs.RuleNumber__c;
            rsOld = triggerOldMap.get(rs.id);
            
            if (rsOld == null) continue;
            
            for (Integer i = 0; i< f_legalParamCount; ) {
                i++;
                String fieldName = 'X'+i+'__c';
                String nowVal = (String)rs.get(fieldName);
                String thenVal = (String)rsOld.get(fieldName);
                
                //check if a change was made on this parameter
                if (nowVal != thenVal) {
                    //look at the delimited parameter values, check what has been added and/or removed from old RS

                    //split into a list each different strings
                    Set<String> newVals = splitUpRSParams(nowVal);
                    Set<String> oldVals = splitUpRSParams(thenVal);

                    //add the obj/param part to each
                    Set<String> newValConcats = new Set<String>();
                    Set<String> oldValConcats = new Set<String>();
                    for (String s : newVals)
                        newValConcats.add(objType + ';' + i + ';' + s);
                    for (String s : oldVals)
                        oldValConcats.add(objType + ';' + i + ';' + s);

                    //remove overlap - BOGGLE style!
                    Set<String> overlap = newValConcats.clone();
                    overlap.retainAll(oldValConcats);
                    newValConcats.removeAll(overlap);
                    oldValConcats.removeAll(overlap);

                    //get the list of removed parameters for this rule number (existing list, or create new)
                    thisRemoveSet = OAE_TriggerUtils.getThisSet(thisRemoveSet,removes,ruleNum);
                    //add removed items to the "removes" map
                    thisRemoveSet.addall(oldValConcats);

                    //get the list of added parameters for this rule number (existing list, or create new)
                    thisAddSet = OAE_TriggerUtils.getThisSet(thisAddSet,adds,ruleNum);
                    //add added items to the "adds" map
                    thisAddSet.addall(newValConcats);

                    allParamValues.addAll(newValConcats);
                    allParamValues.addAll(oldValConcats);
                }
            }
        }
        
        //load all relevant bitz
        List<RuleBitz__c> rulez = [select id, parameter__c, value__c, objectType__c, paramValue__c, ruleBitArray__c from RuleBitz__c 
                                    where paramvalue__c in :allParamValues];

        //make a map keyed by paramvalue
        Map<String, RuleBitz__c> ruleMap = new Map<String, RuleBitz__c>();
        for (RuleBitz__c rz : rulez)
            ruleMap.put(rz.paramvalue__c, rz);
            
        //update / create new
        RuleBitz__c thisBitz;
        Set<String> theseStrings;
        Map<String, RuleBitz__c> newBitz = new Map<String, RuleBitz__c>();
        
        //for rule # d, the user removed theseStrings
        for (Decimal d : removes.keyset()) {
            theseStrings = removes.get(d);
            for (String s : theseStrings) {
                thisBitz = ruleMap.get(s);
                if (thisBitz == null)
                    thisBitz = newBitz.get(s);
                if (thisBitz != null)
                    thisBitz.ruleBitArray__c = OAE_Utils.flipOff(thisBitz.ruleBitArray__c.longValue(), d.IntValue());
            }
        }
        //for rule # d, the user added theseStrings
        for (Decimal d : adds.keyset()) {
            theseStrings = adds.get(d);
            for (String s : theseStrings) {
                thisBitz = ruleMap.get(s);
                //see if we have created the bitz in this run already
                if (thisBitz == null)
                    thisBitz = newBitz.get(s);
                //create a new bitz when needed
                if (thisBitz == null) {
                    thisBitz = new RuleBitz__c();
                    String[] splitty = s.split(';',0);
                    thisBitz.objectType__c = objType;
                    thisBitz.parameter__c = Integer.valueOf(splitty[1]);
                    thisBitz.value__c = splitty[2];
                    thisBitz.ruleBitArray__c = 0;
                    newBitz.put(s,thisBitz);
                }
                //flip the d bit on
                thisBitz.ruleBitArray__c = OAE_Utils.flipOn(thisBitz.ruleBitArray__c.longValue(), d.IntValue());
            }
        }
        insert newBitz.values();
        update ruleMap.values();
    }

    //gets a value from a map, creates it if it wasn't there
    public Static Set<String> getThisSet(Set<String> current, Map<Decimal,Set<String>> topSet, Decimal ruleNum) {
        if (current != null) return current;
        if (!topSet.containskey(ruleNum)) topSet.put(ruleNum, new Set<String>());
        return topSet.get(ruleNum);
    }

    //splits a parameter string into its constituent parts
    public static Set<String> splitUpRSParams (String splitEm) {
        if (splitEm != null && splitEm != '') {
            return new Set<String>(splitEm.split(';',0));
        } else 
            //the parameter which says "all are valid", when nothing is specified in the string
            return new Set<String>{'__all__'};      
    }

/* ruleScenario trigger helper functions end here */

/* userSkill trigger helper functions begin here */

    public static void insertUS (List<UserSkill__c> triggerNewCollex, Map<ID,Integer> parentMap, String objType) {
        Map<String,Set<Integer>> pvAdds = new Map<String,Set<Integer>>();
        Map<String,Decimal> usParamMap = new Map<String,Decimal>();
        Map<String,String> usValueMap = new Map<String,String>();
        Map<String,String> usLevelMap = new Map<String,String>();
          
        for (UserSkill__c us : triggerNewCollex) {
            Integer parentUDUserNum = parentMap.get(us.userdata__c);
            Set<Integer> thisAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, us.engineValue__c);
            thisAddSet.add(parentUDUserNum);
    
            //check if there's a level involved
            if (us.level__c != null && us.level__c != '') {
                Set<Integer> thisLevelAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, us.engineValueLevel__c);
                thisLevelAddSet.add(parentUDUserNum);

                usParamMap.put(us.engineValueLevel__c, us.paramNumber__c);
                usValueMap.put(us.engineValueLevel__c, us.value__c);
                usLevelMap.put(us.engineValueLevel__c, us.level__c);
            }
            usParamMap.put(us.engineValue__c, us.paramNumber__c);
            usValueMap.put(us.engineValue__c, us.value__c);
        }
    
        //load all relevant bitz
        Set<String> queryParam = pvAdds.keySet().clone();
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, false);

        //find which additions are new
        Set<String> netNewUBs = pvAdds.keySet().clone();
        netNewUBs.removeAll(existingUBMap.keySet());
    
        //add the new UserBitz  
        OAE_TriggerUtils.UBAddNew(netNewUBs, objType, pvAdds, usValueMap, usParamMap, usLevelMap);
        
        //update existing userbitz
        OAE_TriggerUtils.UBTurnOn(pvAdds, existingUBMap);
    }
    public static void updateUS (List<UserSkill__c> triggerNewCollex, Map<ID,UserSkill__c> triggerOldMap, Map<ID,Integer> parentMap, String objType) {
        Map<String,Set<Integer>> pvAdds = new Map<String,Set<Integer>>();
        Map<String,Set<Integer>> pvRemoves = new Map<String,Set<Integer>>();
        Map<String,Decimal> usParamMap = new Map<String,Decimal>();
        Map<String,String> usValueMap = new Map<String,String>();
        Map<String,String> usLevelMap = new Map<String,String>();
          
        for (UserSkill__c us : triggerNewCollex) {
            Integer parentUDUserNum = parentMap.get(us.userdata__c);
            Set<Integer> thisAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, us.engineValue__c);
            thisAddSet.add(parentUDUserNum);
    
            //check if there's a level involved
            if (us.level__c != null && us.level__c != '') {
                Set<Integer> thisLevelAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, us.engineValueLevel__c);
                thisLevelAddSet.add(parentUDUserNum);

                usParamMap.put(us.engineValueLevel__c, us.paramNumber__c);
                usValueMap.put(us.engineValueLevel__c, us.value__c);
                usLevelMap.put(us.engineValueLevel__c, us.level__c);
            }

            usParamMap.put(us.engineValue__c, us.paramNumber__c);
            usValueMap.put(us.engineValue__c, us.value__c);

            UserSkill__c oldUS = triggerOldMap.get(us.id);
            if (oldUS != null) {
                Set<Integer> thisRemoveSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, oldUS.engineValue__c);
                thisRemoveSet.add(parentUDUserNum);
        
                //check if there's a level involved
                if (oldUS.level__c != null && oldUS.level__c != '') {
                    Set<Integer> thisLevelRemoveSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, oldUS.engineValueLevel__c);
                    thisLevelRemoveSet.add(parentUDUserNum);
    
                    usParamMap.put(oldUS.engineValueLevel__c, oldUS.paramNumber__c);
                    usValueMap.put(oldUS.engineValueLevel__c, oldUS.value__c);
                    usLevelMap.put(oldUS.engineValueLevel__c, oldUS.level__c);
                }
    
                usParamMap.put(oldUS.engineValue__c, oldUS.paramNumber__c);
                usValueMap.put(oldUS.engineValue__c, oldUS.value__c);
            }
        }

        //load all relevant bitz
        Set<String> queryParam = pvAdds.keySet().clone();
        queryParam.addAll(pvRemoves.keySet());
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, false);

        //find which additions are new
        Set<String> netNewUBs = pvAdds.keySet().clone();
        netNewUBs.removeAll(existingUBMap.keySet());
    
        //add the new UserBitz  
        OAE_TriggerUtils.UBAddNew(netNewUBs, objType, pvAdds, usValueMap, usParamMap, usLevelMap);

        //update existing userbitz
        //first do removes
        OAE_TriggerUtils.UBTurnOff(pvRemoves, existingUBMap);
        //next do adds
        OAE_TriggerUtils.UBTurnOn(pvAdds, existingUBMap);
    }
    public static void deleteUS (List<UserSkill__c> triggerOldCollex, Map<ID,Integer> parentMap, String objType) {
        Map<String,Set<Integer>> pvRemoves = new Map<String,Set<Integer>>();
        Set<String> levelRemoves = new Set<String>();
        
        for (UserSkill__c oldUS : triggerOldCollex) {
            Integer parentUDUserNum = parentMap.get(oldUS.userdata__c);
            Set<Integer> thisRemoveSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, oldUS.engineValue__c);
            thisRemoveSet.add(parentUDUserNum);
    
            //check if there's a level involved
            if (oldUS.level__c != null && oldUS.level__c != '') {
                Set<Integer> thisLevelRemoveSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, oldUS.engineValueLevel__c);
                thisLevelRemoveSet.add(parentUDUserNum);
                levelRemoves.add(oldUS.engineValueLevel__c);
            }   
        }

        //query for relevant userBitz
        Set<String> queryParam = pvRemoves.keySet().clone();
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, false);

        //remove users from UBs
        OAE_TriggerUtils.UBTurnOff(pvRemoves, existingUBMap);
//TODO
        //figure out if users get to keep the parent value or not, 
        //based on if they have other expert listings or the skill itself
    }
/*
    private Static Map<String, UserBitz__c> UBQuery(Set<String> queryParam) {
        //construct query string
        String qStr = 'Select id, paramvalue__c';

        //add dynamic parameters to query
        for (Integer i = 1; i <= f_userColumns; i++)
            qStr = qStr +', ' +'UBArray' +i +'__c';
        
        qStr = qStr + ' From UserBitz__c where paramvalue__c in :queryParam';

        //query with this string
        SObject[] qRes = Database.query(qStr);

        //make a map of userBitz keyed by paramvalue
        Map<String, UserBitz__c> existingUBMap = new Map<String, UserBitz__c>();
        for (SObject o : qRes) {
            UserBitz__c uz = (UserBitz__c)o;
            existingUBMap.put(uz.paramvalue__c, uz);
        }
        return existingUBMap;
    }
*/
    private Static Set<Integer> getSetIntegerByString(Map<String,Set<Integer>> topSet, String key) {
        if (!topSet.containskey(key)) topSet.put(key, new Set<Integer>());
        return topSet.get(key);
    }   
    private static void UBAddNew(Set<String> netNewUBs, String objType, Map<String,Set<Integer>> pvAdds,
                Map<String,String> usValueMap, Map<String,Decimal> usParamMap, Map<String,String> usLevelMap) {
        List<UserBitz__c> newUserBitz = new List<UserBitz__c>();
        for (String sKey : netNewUBs) {
            UserBitz__c thisNewUB = new UserBitz__c();
            thisNewUB.objectType__c = objType;
            thisNewUB.parameter__c = usParamMap.get(sKey);
            thisNewUB.value__c = usValueMap.get(sKey);
            if (usLevelMap.containsKey(sKey))
                thisNewUB.level__c = usLevelMap.get(sKey);
            
            Map<Integer,Long> ubArrays = OAE_Utils.setToBit(pvAdds.get(sKey));
            for (Integer i : ubArrays.keySet()) {
                Long indexedArray = ubArrays.get(i);
                thisNewUB.put('UBArray'+(i+1)+'__c', Decimal.valueOf(indexedArray));
            }
            newUserBitz.add(thisNewUB);     
        }
        insert newUserBitz;
    }
    private static void UBTurnOn(Map<String,Set<Integer>> pvAdds, Map<String, UserBitz__c> existingUBMap) {
        //next do adds
        for (String pvKey : pvAdds.keySet()) {
            UserBitz__c currentUB = existingUBMap.get(pvKey);
            if (currentUB != null) {        
                Map<Integer,Long> onFlippers = OAE_Utils.setToBit(pvAdds.get(pvKey));
                for (Integer i : onFlippers.keySet()) {
                    Long indexedArray = onFlippers.get(i);
                    Long alreadySet = ((Decimal)(currentUB.get('UBArray'+(i+1)+'__c'))).longValue();
                    currentUB.put('UBArray'+(i+1)+'__c', Decimal.valueOf(indexedArray | alreadySet));
                }
            }
        }
        update existingUBMap.values();
    }
    private static void UBTurnOff(Map<String,Set<Integer>> pvRemoves, Map<String, UserBitz__c> existingUBMap) {
        for (String pvKey : pvRemoves.keySet()) {
            UserBitz__c currentUB = existingUBMap.get(pvKey);
            if (currentUB != null) {        
                Map<Integer,Long> offFlippers = OAE_Utils.setToBit(pvRemoves.get(pvKey));
                for (Integer i : offFlippers.keySet()) {
                    Long indexedArray = offFlippers.get(i);
                    Long alreadySet = ((Decimal)(currentUB.get('UBArray'+(i+1)+'__c'))).longValue();
                    currentUB.put('UBArray'+(i+1)+'__c', Decimal.valueOf(OAE_Utils.flipOff(alreadySet, indexedArray, true)));
                }
            }
        }
        update existingUBMap.values();
    }
/* userSkill trigger helper functions end here */

/* userData trigger helper functions begin here */
    public static void insertUD(List<UserData__c> triggerNewCollex) {
        Map<String,Set<Integer>> pvAdds = new Map<String,Set<Integer>>();
        Map<String,String> udObjectMap = new Map<String,String>();
        Map<String,Decimal> udParamMap = new Map<String,Decimal>();
        Map<String,String> udValueMap = new Map<String,String>();
          
        //get the fields for UD
        Map<String,Map<Integer,String>> umfMap = OAE_TriggerUtils.getUserDataUMFMap();

    //look at all relevant fields
        for (String objName : umfMap.keySet()) {
            //loop by object
            Map<Integer,String> umfParams = umfMap.get(objName);
            //get each # / fieldname set
            for (Integer paramNum : umfParams.keySet()) {
                String paramFieldName = umfParams.get(paramNum);
                //inspect each new UD
                for (UserData__c ud : triggerNewCollex) {
                    Object o = ud.get(paramFieldName);
                    if (o == null) continue;
                    String paramValue = String.valueOf(o);
                    String objEngineValue = objName + ';' + paramNum + ';' + paramValue;
                    Set<Integer> thisAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, objEngineValue);
                    thisAddSet.add(ud.UserNumber__c.intValue());

                    udObjectMap.put(objEngineValue, objName);
                    udParamMap.put(objEngineValue, paramNum);
                    udValueMap.put(objEngineValue, paramValue);
                }
            }
        }       
        //load all relevant bitz
        Set<String> queryParam = pvAdds.keySet().clone();
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, true);

        //find which additions are new
        Set<String> netNewUBs = pvAdds.keySet().clone();
        netNewUBs.removeAll(existingUBMap.keySet());
    
        //add the new UserBitz  
        OAE_TriggerUtils.UBAddNew(netNewUBs, pvAdds, udValueMap, udParamMap, udObjectMap);
        
        //update existing userbitz
        OAE_TriggerUtils.UBTurnOn(pvAdds, existingUBMap);
    }
    public static void updateUD(List<UserData__c> triggerNewCollex, Map<ID,UserData__c> triggerOldMap) {
        Map<String,Set<Integer>> pvAdds = new Map<String,Set<Integer>>();
        Map<String,Set<Integer>> pvRemoves = new Map<String,Set<Integer>>();
        Map<String,String> udObjectMap = new Map<String,String>();
        Map<String,Decimal> udParamMap = new Map<String,Decimal>();
        Map<String,String> udValueMap = new Map<String,String>();
          
        //get the fields for UD
        Map<String,Map<Integer,String>> umfMap = OAE_TriggerUtils.getUserDataUMFMap();

    //look at all relevant fields
        for (String objName : umfMap.keySet()) {
            //loop by object
            Map<Integer,String> umfParams = umfMap.get(objName);
            //get each # / fieldname set
            for (Integer paramNum : umfParams.keySet()) {
                String paramFieldName = umfParams.get(paramNum);
                //inspect each new UD
                for (UserData__c ud : triggerNewCollex) {
                    Object o = ud.get(paramFieldName);
                    if (o == null) continue;
                    String paramValue = String.valueOf(o);
                    String objEngineValue = objName + ';' + paramNum + ';' + paramValue;
                    Set<Integer> thisAddSet = OAE_TriggerUtils.getSetIntegerByString(pvAdds, objEngineValue);
                    thisAddSet.add(ud.UserNumber__c.intValue());

                    udObjectMap.put(objEngineValue, objName);
                    udParamMap.put(objEngineValue, paramNum);
                    udValueMap.put(objEngineValue, paramValue);

                    UserData__c oldUD = triggerOldMap.get(ud.id);
                    if (oldUD != null) {
                        Object oldO = oldUD.get(paramFieldName);
                        if (oldO == null) continue;
                        String oldParamValue = String.valueOf(oldO);
                        String oldObjEngineValue = objName + ';' + paramNum + ';' + oldParamValue;
                        Set<Integer> thisRemoveSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, oldObjEngineValue);
                        thisRemoveSet.add(ud.UserNumber__c.intValue());
                
                        udObjectMap.put(oldObjEngineValue, objName);
                        udParamMap.put(oldObjEngineValue, paramNum);
                        udValueMap.put(oldObjEngineValue, paramValue);
                    }

                }
            }
        }       

        //load all relevant bitz
        Set<String> queryParam = pvAdds.keySet().clone();
        queryParam.addAll(pvRemoves.keySet());
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, true);

        //find which additions are new
        Set<String> netNewUBs = pvAdds.keySet().clone();
        netNewUBs.removeAll(existingUBMap.keySet());
    
        //add the new UserBitz  
        OAE_TriggerUtils.UBAddNew(netNewUBs, pvAdds, udValueMap, udParamMap, udObjectMap);
        
        //update existing userbitz
        //first do removes
        OAE_TriggerUtils.UBTurnOff(pvRemoves, existingUBMap);
        //next do adds
        OAE_TriggerUtils.UBTurnOn(pvAdds, existingUBMap);
    }
    public static void deleteUD (List<UserData__c> triggerOldCollex) {
        Map<String,Set<Integer>> pvRemoves = new Map<String,Set<Integer>>();
          
        //get the fields for UD
        Map<String,Map<Integer,String>> umfMap = OAE_TriggerUtils.getUserDataUMFMap();

    //look at all relevant fields
        for (String objName : umfMap.keySet()) {
            //loop by object
            Map<Integer,String> umfParams = umfMap.get(objName);
            //get each # / fieldname set
            for (Integer paramNum : umfParams.keySet()) {
                String paramFieldName = umfParams.get(paramNum);
                //inspect each new UD
                for (UserData__c ud : triggerOldCollex) {
                    Object o = ud.get(paramFieldName);
                    if (o == null) continue;
                    String paramValue = String.valueOf(o);
                    String objEngineValue = objName + ';' + paramNum + ';' + paramValue;
                    Set<Integer> thisAddSet = OAE_TriggerUtils.getSetIntegerByString(pvRemoves, objEngineValue);
                    thisAddSet.add(ud.UserNumber__c.intValue());

                }
            }
        }       

        //query for relevant userBitz
        Set<String> queryParam = pvRemoves.keySet().clone();
        Map<String, UserBitz__c> existingUBMap = OAE_TriggerUtils.UBQuery(queryParam, true);

        //remove users from UBs
        OAE_TriggerUtils.UBTurnOff(pvRemoves, existingUBMap);
    }

    private static Map<String,Map<Integer,String>> getUserDataUMFMap() {
        Map<String,Map<Integer,String>> retVal = new Map<String,Map<Integer,String>> ();

        Map<Integer,String> thisMap;
                
        for (UserMatchFields__c umf : UserMatchFields__c.getAll().values()) {
            if (umf.Base__c == 'UserData__c') {
                //get the object from the name
                String objectName = umf.Name.replaceAll('\\d','');
                if (retVal.containsKey(objectName)) thisMap = retVal.get(objectName);
                else {
                    thisMap = new Map<Integer,String>();
                    retVal.put(objectName,thisMap);
                }
                thisMap.put(umf.order__c.intValue(), umf.path__c);
            }
        }
        return retVal;
    }
    private static Map<String, UserBitz__c> UBQuery(Set<String> queryParam, Boolean useObjParamValue) {
        //construct query string
        String qStr = 'Select id, paramvalue__c, objparamvalue__c';

        //add dynamic parameters to query
        for (Integer i = 1; i <= f_userColumns; i++)
            qStr = qStr +', ' +'UBArray' +i +'__c';

        if (useObjParamValue)
            qStr = qStr + ' From UserBitz__c where objparamvalue__c in :queryParam';
        else
            qStr = qStr + ' From UserBitz__c where paramvalue__c in :queryParam';

        //query with this string
        SObject[] qRes = Database.query(qStr);

        //make a map of userBitz keyed by paramvalue
        Map<String, UserBitz__c> existingUBMap = new Map<String, UserBitz__c>();
        for (SObject o : qRes) {
            UserBitz__c uz = (UserBitz__c)o;
            if (useObjParamValue)
                existingUBMap.put(uz.objparamvalue__c, uz);
            else
                existingUBMap.put(uz.paramvalue__c, uz);
        }
        return existingUBMap;
    }
    private static void UBAddNew(Set<String> netNewUBs, Map<String,Set<Integer>> pvAdds,
                Map<String,String> usValueMap, Map<String,Decimal> usParamMap, Map<String,String> usObjectMap) {
        List<UserBitz__c> newUserBitz = new List<UserBitz__c>();
        for (String sKey : netNewUBs) {
            UserBitz__c thisNewUB = new UserBitz__c();
            thisNewUB.objectType__c = usObjectMap.get(sKey);
            thisNewUB.parameter__c = usParamMap.get(sKey);
            thisNewUB.value__c = usValueMap.get(sKey);
            
            Map<Integer,Long> ubArrays = OAE_Utils.setToBit(pvAdds.get(sKey));
            for (Integer i : ubArrays.keySet()) {
                Long indexedArray = ubArrays.get(i);
                thisNewUB.put('UBArray'+(i+1)+'__c', Decimal.valueOf(indexedArray));
            }
            newUserBitz.add(thisNewUB);     
        }
        insert newUserBitz;
    }
/* userData trigger helper functions end here */
}