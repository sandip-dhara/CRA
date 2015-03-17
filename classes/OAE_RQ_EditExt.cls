public with sharing class OAE_RQ_EditExt {
	private final String sMOS = 'Minutes on-shift';	
	private final String sOSN = 'On-shift now';
	private final String sWK = 'Workload';
	
	private Requirement__c thisRQ;
	private Requirement__c queryRQ;
	public final String objType { get; set; }

	private List<String> paramPicklist;
	private Map<String,List<String>> valuePicklist;
	private Map<String,List<String>> levelPicklist;

//	public String[] pickSelected { get; set; }
//	public String checkSelected { get; set; }
//	public Boolean showSelect { get; set; }
//	public Boolean showCheck { get; set; }
	private Boolean showNumbers;
	public Decimal numberRight { get; set; }
	private Map<String,Decimal> umfOrderMap;
	private Set<Decimal> numberFields;

    public OAE_RQ_EditExt(ApexPages.StandardController stdC) {
        thisRQ = (Requirement__c)stdC.getRecord();
//TODO error check for null
        RuleScenario__c parentRS = [Select id, RuleObjectInternal__c From RuleScenario__c where id =:thisRQ.RuleScenario__c];

        objType = parentRS.RuleObjectInternal__c;

		paramPicklist = new List<String>();
		valuePicklist = new Map<String,List<String>>();
		levelPicklist = new Map<String,List<String>>();

		umfOrderMap = new Map<String,Decimal>();
		numberFields = new Set<Decimal>();

		Map<String, Schema.SObjectField> objSchema = Schema.getGlobalDescribe().get(objType).getDescribe().fields.getMap();
        Map<String,UserMatchFields__c> fNames = UserMatchFields__c.getAll();

		List<String> TrueFalse = new List<String>{'true','false'};

        for (UserMatchFields__c umf : fNames.values()) {
			String trimmedName = umf.Name.replaceAll('\\d','');
        	if(!trimmedName.equalsIgnoreCase(objType)) continue;
	
			if (!umf.type__c.equalsignorecase('NUMERIC')) {
				paramPicklist.add(umf.label__c);
				umfOrderMap.put(umf.label__c,umf.order__c);
				List<String> thesePicks = new List<String>();
				String deParam = '$'+ objType + '.' + umf.Label__c;
				//determine type
				if (umf.type__c.equalsignorecase('PICKLIST')) {
					thesePicks.add(deParam);
					thesePicks.addAll(OAE_VFUtils.getPickVals(objSchema, umf.path__c).split(', ',0));
				} else if (umf.type__c.equalsignorecase('CUSTOM')) {
					thesePicks.add(deParam);
					thesePicks.addAll(OAE_VFUtils.getCustomVals('M'+umf.Name).split(', ',0));
				}  else if (umf.type__c.equalsignorecase('CHECKBOX')) {
					thesePicks = TrueFalse;
					thesePicks.add(deParam);
				}
				valuePicklist.put(umf.label__c,thesePicks);
				//look for the level pick
				EnginePicklists__c ep = EnginePicklists__c.getInstance('L'+umf.Name);
				if (ep != null)
					levelPicklist.put(umf.label__c, OAE_VFUtils.getCustomVals(ep));
			} else {
				if (!umf.Label__c.equalsIgnoreCase(sWK)) {
					paramPicklist.add(umf.label__c);
					umfOrderMap.put(umf.label__c,umf.order__c);
					numberFields.add(umf.order__c);
				}
			}
		}
		if (thisRQ.Parameter__c == null || thisRQ.Parameter__c == '') {
			if (paramPicklist.size() > 0)
				thisRQ.Parameter__c = paramPicklist.get(0);
		}
		if (umfOrderMap.size() > 0)
			setVals();
	}
	
    public List<SelectOption> getParamItems() {
        List<SelectOption> options = new List<SelectOption>();
                
        //create select options for each item
        for (String s : paramPicklist) {
            options.add(new SelectOption(s,s));
        }
        return options;
    }

    public List<SelectOption> getValueItems() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> relatedValues = valuePicklist.get(thisRQ.parameter__c);

		if (relatedValues != null) {
	        //create select options for each item
	        for (String s : relatedValues) {
	            options.add(new SelectOption(s,s));
	        }
		}
        return options;
    }
    
    public List<SelectOption> getLevelItems() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> relatedValues = levelPicklist.get(thisRQ.parameter__c);

		if (relatedValues != null && relatedValues.size() > 0) {
			//offer the blank for "no level"
			options.add(new SelectOption('',''));
	        //create select options for each item
	        for (String s : relatedValues) {
	            options.add(new SelectOption(s,s));
	        }
        } else {
			options.add(new SelectOption('',''));
		}
        return options;
    }
    public Boolean getShowNumbers() { return showNumbers; }
	private void setVals() {
		thisRQ.ParamNumber__c = umfOrderMap.get(thisRQ.parameter__c);
		thisRQ.isOnShiftNow__c = thisRQ.parameter__c.equalsIgnoreCase(sOSN);
		thisRQ.isMinutesOnShift__c = thisRQ.parameter__c.equalsIgnoreCase(sMOS);
		showNumbers = numberFields.contains(thisRQ.ParamNumber__c);
		if (showNumbers) thisRQ.value__c = '';
	}
    public PageReference refreshValues() {
		setVals();
		return null;
    }
}