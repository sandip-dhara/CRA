public with sharing class OAE_VFUtils {
    public static String getPickVals(Map<String, Schema.SObjectField> objSchema, String field) {
        String retVal = '';
        Boolean start = true;
        
        //loop through on periods for deep paths
        if (field.contains('.')) {
            field = field.replace('.',':');
            String[] splitPath = field.split(':',0);
            for (Integer i = 0; i < (splitPath.size()-1); i++) {
                for (Schema.SObjectField s : objSchema.values()) {
                    Schema.DescribeFieldResult sdr = s.getDescribe();
                    if (sdr.getType().name().equalsIgnoreCase('REFERENCE') &&
                            sdr.getRelationshipName() == splitPath[i]) {
                        String parentType = sdr.getReferenceTo()[0].getDescribe().getName();
                        objSchema = Schema.getGlobalDescribe().get(parentType).getDescribe().fields.getMap();
                        break;
                    }
                }
            }
            field = splitPath[splitPath.size()-1];
        }

        Schema.SObjectField sof = objSchema.get(field);
        if (sof != null) {
            List<Schema.PicklistEntry> lp = sof.getDescribe().getPicklistValues();
            for (Schema.PicklistEntry p : lp) {
                if (!start) {
                    retVal = retVal + ', ';
                } else {
                    start = false;
                } 
                retVal = retVal + p.getValue();
            }             
        }

        return retVal;
    }

    public static String customParamString(Schema.SObjectField sof, String objType, String prior, String objForward, String base) {
    	return customParamString(sof,objType,prior,objForward) + '&oBase=' + base;
    }

    public static String customParamString(Schema.SObjectField sof, String objType, String prior, String objForward) {
        String retVal='';
        Schema.DescribeFieldResult sdr = sof.getDescribe(); 

        retVal = retVal + '&oObject=' + objType
                        + '&oPath=' + prior + sdr.getName()
                        + '&oLabel=' + sdr.getLabel()
                        + '&oParent=' + objForward;
        return retVal;
    }

	public static Long addFieldToCustomSetting(Schema.SObjectField sof, String objType, String prior, String ft) {
		Schema.DescribeFieldResult sdr = sof.getDescribe(); 
		return addFieldToCustomSetting(sdr.getLabel(),objType,prior+sdr.getName(),ft);
	}
	public static Long addFieldToCustomSetting(String label, String objType, String priorName, String ft) {
		EngineFields__c ef = new EngineFields__c();
		InUseRoster__c thisRoster = InUseRoster__c.getInstance(objType);

		if (thisRoster == null) {
			thisRoster = new InUseRoster__c();
			thisRoster.name = objType;
			thisRoster.Bitz__c = 0;
			insert thisRoster;
		}

		Long nextOrder = nextHole(thisRoster);
		
		if(ft.equalsIgnoreCase('ID') && !priorName.endsWith('__r'))
			priorName = priorName + 'ID';
		else 
			priorName = priorName.replace('__r', '__c');

        ef.Name = objType + nextOrder;
        ef.Label__c = label;
        ef.Type__c = ft;
        ef.Path__c = priorName;
        ef.Order__c = nextOrder;
        ef.Object__c = objType;
        insert ef;

		thisRoster.bitz__c = thisRoster.bitz__c.longValue() | 1L<<(nextOrder-1);
        update thisRoster;

		//set up the ruleBitz for the new rule, where at first all covers all
		RuleBitz__c newBitz = new RuleBitz__c();
		newBitz.objectType__c = objType;
		newBitz.parameter__c = Integer.valueOf(nextOrder);
		newBitz.value__c = '__all__';

		//set all to true for the rules in place, so get the rules in place
		InUseRoster__c ruleRoster = InUseRoster__c.getInstance('RS_'+objType);
		if (ruleRoster != null)
			newBitz.ruleBitArray__c = ruleRoster.bitz__c.longValue();
		else
			newBitz.ruleBitArray__c = 0;

		insert newBitz;

		return nextOrder;
    }

    public static void removeFieldFromCustomSetting(EngineFields__c efRemove) {
		Long ruleNum = efRemove.order__c.longValue();
		String objType = efRemove.object__c;
		
   		InUseRoster__c thisRoster = InUseRoster__c.getInstance(objType);
		thisRoster.Bitz__c = OAE_Utils.flipOff(thisRoster.Bitz__c.longValue(), 1L<<(ruleNum-1), false);
    	update thisRoster;

//		String leadStr = ruleNum + ';%';
		List<RuleBitz__c> deleteRulez = [Select id, parameter__c, objectType__c from RuleBitz__c 
										where Parameter__c = :ruleNum and objectType__c = :objType];
		delete deleteRulez;
		
		//check if this has a custom associated with it
		if (efRemove.type__c == 'Custom') {
			//if so, remove it
			EnginePicklists__c epRemove = EnginePicklists__c.getInstance('R' + objType + ruleNum);
			if (epRemove != null)
				delete epRemove;
		}
    	delete efRemove;
    }

    public static Long addFieldToUserSetting(Schema.SObjectField sof, String objType, String prior, String ft, String base) {
		Schema.DescribeFieldResult sdr = sof.getDescribe(); 
		return addFieldToUserSetting(sdr.getLabel(),objType,prior+sdr.getName(),ft, base);
    }
    public static Long addFieldToUserSetting(String label, String objType, String priorName, String ft, String base) {
        UserMatchFields__c umf = new UserMatchFields__c();
		InUseRoster__c thisRoster = InUseRoster__c.getInstance('M'+objType);
		if (thisRoster == null) {
			thisRoster = new InUseRoster__c();
			thisRoster.name = 'M'+objType;
			thisRoster.Bitz__c = 0;
			insert thisRoster;
		}
		//figure out the next unused order
		Long nextOrder = nextHole(thisRoster);

        umf.Name = objType + nextOrder;
        umf.Label__c = label;
        umf.Type__c = ft;
        umf.Path__c = priorName;
        umf.Order__c = nextOrder;
        umf.Base__c = base;
        insert umf;

		//mark this slot as used by flipping on the bit
		thisRoster.bitz__c = thisRoster.bitz__c.longValue() | 1L<<(nextOrder-1);
        update thisRoster;

        return nextOrder;
    }    

    public static void removeFieldFromUserSetting(UserMatchFields__c umfRemove) {
		Long ruleNum = umfRemove.order__c.longValue();

		String base = umfRemove.Name.replaceAll('\\d','');

   		InUseRoster__c thisRoster = InUseRoster__c.getInstance('M'+base);
		thisRoster.Bitz__c = OAE_Utils.flipOff(thisRoster.Bitz__c.longValue(), 1L<<(ruleNum-1), false);
    	update thisRoster;

		//check if this has a custom associated with it
		if (umfRemove.type__c == 'Custom') {
			//if so, remove it
			EnginePicklists__c epRemove = EnginePicklists__c.getInstance('M' + base + ruleNum);
			if (epRemove != null)
				delete epRemove;
		}
    	delete umfRemove;
    }

    public static void addCustomRulePicklist(String nameStub, String objName, String fieldPath, String delimitedVals) {
        if (delimitedVals.length() < 255)
            addCustomRulePicklist(nameStub,objName,fieldPath,delimitedVals,'');
        else {
            addCustomRulePicklist(nameStub,objName,fieldPath, delimitedVals.substring(0,255), 
            	delimitedVals.substring(255,Math.min(510,delimitedVals.length())));
        }    	
    }
	public static void addCustomRulePicklist(String nameStub, String objName, String fieldPath, String pickVals1, String pickVals2) {
		EnginePicklists__c epk = new EnginePicklists__c();
		epk.Name = nameStub;
		epk.ObjectName__c = objName;
		
		//determine field name
		if (fieldPath.contains('.')) {
			String[] breakup = fieldPath.split('\\x2E',0);  //splitting on period, hex 2E ("." is special)
			epk.field__c = breakup[breakup.size()-1];
		} else
			epk.field__c = fieldPath;
		
		epk.PickValues1__c = pickVals1;
		epk.PickValues2__c = pickVals2;

		insert epk;
	}
	
	public static EnginePicklists__c modifyLevels(EnginePicklists__c currentEP, String inputVals, Set<String> existingList, Boolean adding) {
        String scDelim = '';

		//grab from the existing strings
        for (String s : existingList) 
            scDelim = scDelim + s + ';';

		//if strings are being added, pull from the input field
		if (adding) {
	        List<String> valSplit = inputVals.split('\r\n',0);
	        for (String s : valSplit) 
	            scDelim = scDelim + s + ';';
		}
				
		//truncate last semicolon
        if (scDelim.length() > 0)
            scDelim = scDelim.substring(0,scDelim.length()-1);		

		String pick1;
		String pick2;		
        if (scDelim.length() < 255) {
        	pick1 = scDelim;
        	pick2 = '';
        } else {
        	pick1 = scDelim.substring(0,255);
        	pick2 = scDelim.substring(255,Math.min(510,scDelim.length()));
        }

		currentEP.PickValues1__c = pick1;
		currentEP.PickValues2__c = pick2;
		
		return currentEP;
	}
	
    public static String[] getCustomVals(EnginePicklists__c ep) {
        String pv;
        if (ep != null) {
            pv = ep.PickValues1__c;
            if (ep.PickValues2__c != null)
                pv = pv + ep.PickValues2__c;
        } else {
        	pv = '';
        }
        return pv.split(';',0);
    }
    
    public static String getCustomVals(String field) {
        String retVal = '';
        EnginePicklists__c ep = EnginePicklists__c.getInstance(field);
        if (ep != null) {
            String pv = ep.PickValues1__c;
            if (ep.PickValues2__c != null)
                pv = pv + ep.PickValues2__c;
            List<String> vals = pv.split(';',0);
            for (String s : vals)
                retVal = retVal + s + ', ';
            if (retVal.length() > 2)
                retVal = retVal.substring(0,retVal.length() -2);
        }
        return retVal;
    }
    
	public static List<TableCols> sortTC(List<TableCols> sortem) {
		Map<String,TableCols> mappedTC = new Map<String,TableCols>();
		for(TableCols tc : sortem) 
			mappedTC.put(tc.sOne,tc);
		List<String> sortKeys = new List<String>();
		sortKeys.addall(mappedTC.keyset());
		sortKeys.sort();
		List<TableCols> retVal = new List<TableCols>();
		for (String s : sortKeys)
			retVal.add(mappedTC.get(s));
		return retVal;
	}

	public static List<UserMatchFields__c> sortUMFList(List<UserMatchFields__c> theList) {
        List<UserMatchFields__c> retVal = new List<UserMatchFields__c>();

		Map<String,Integer> objectColumn = new Map<String,Integer>();
		Integer nextCount = 1;
		
        for (UserMatchFields__c umf : theList) {
        	if (!objectColumn.containsKey(umf.base__c)) {
        		objectColumn.put(umf.base__c, nextCount++);
        	}
        }
        
        Map<Decimal,UserMatchFields__c> countedMap = new Map<Decimal,UserMatchFields__c>();
        for (UserMatchFields__c umf : theList) {
        	countedMap.put(objectColumn.get(umf.base__c)*1000+umf.order__c,umf);
        }
        return sortedMap(countedMap);
	}
	
	public static List<UserMatchFields__c> sortedMap(Map<Decimal,UserMatchFields__c> theMap) {
        List<UserMatchFields__c> retVal = new List<UserMatchFields__c>();
        
        //get the keys into a list for sorting
        List<Decimal> sortkeys = new List<Decimal>();
        sortkeys.addAll(theMap.keySet());
        sortkeys.sort();
    
        for (Decimal dc : sortkeys) 
            retVal.add(theMap.get(dc));

        return retVal;
		
	}

	public static Long nextHole(InUseRoster__c thisRoster) {
		Long orderBitz = thisRoster.bitz__c.longValue();
		Long nextOrder = 1;

		while ((orderBitz & 1) == 1) {
			nextOrder++;
			orderBitz = orderBitz >> 1L;
		}
		return nextOrder;		
	}
}