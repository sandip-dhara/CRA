public class OAE_US_EditExt {
    private UserSkill__c thisUS;
    public final String objType { get; set; }

	private List<String> paramPicklist;
	private Map<String,List<String>> valuePicklist;
	private Map<String,List<String>> levelPicklist;
	private Map<String,Decimal> umfOrderMap;
	private Map<String,String> umfBaseMap;

    public OAE_US_EditExt(ApexPages.StandardController stdC) {
        thisUS = (UserSkill__c)stdC.getRecord();

		paramPicklist = new List<String>();
		valuePicklist = new Map<String,List<String>>();
		levelPicklist = new Map<String,List<String>>();

		umfOrderMap = new Map<String,Decimal>();
		umfBaseMap = new Map<String,String>();

		Map<String,Map<String, Schema.SObjectField>> schemasByObject = new Map<String,Map<String, Schema.SObjectField>>();
        Map<String,UserMatchFields__c> umfAll = UserMatchFields__c.getAll();

		List<String> TrueFalse = new List<String>{'true','false'};
        
        for (UserMatchFields__c umf : umfAll.values()) {
			if (umf.Base__c == 'Schedule' || umf.Base__c == 'UserData__c') continue;

			paramPicklist.add(umf.label__c);
			List<String> thesePicks = new List<String>();
			umfOrderMap.put(umf.label__c,umf.order__c);
			umfBaseMap.put(umf.label__c,umf.base__c);

			//determine type
			if (umf.type__c.equalsignorecase('PICKLIST')) {
				Map<String, Schema.SObjectField> objSchema = schemasByObject.get(umf.base__c);
				if (objSchema == null) {
					objSchema = Schema.getGlobalDescribe().get(umf.base__c).getDescribe().fields.getMap();
					schemasByObject.put(umf.base__c,objSchema);
				}
				thesePicks.addAll(OAE_VFUtils.getPickVals(objSchema, umf.path__c).split(', ',0));
			} else if (umf.type__c.equalsignorecase('CUSTOM')) {
				thesePicks.addAll(OAE_VFUtils.getCustomVals('M'+umf.Name).split(', ',0));
			}  else if (umf.type__c.equalsignorecase('CHECKBOX')) {
				thesePicks = TrueFalse;
			}
			valuePicklist.put(umf.label__c,thesePicks);
			//look for the level pick
			EnginePicklists__c ep = EnginePicklists__c.getInstance('L'+umf.Name);
			if (ep != null)
				levelPicklist.put(umf.label__c, OAE_VFUtils.getCustomVals(ep));
		}
		if (thisUS.Parameter__c == null || thisUS.Parameter__c == '') {
			if (paramPicklist.size() > 0)
				thisUS.Parameter__c = paramPicklist.get(0);
		}
		thisUS.ParamNumber__c = umfOrderMap.get(thisUS.parameter__c);
		thisUS.baseObject__c = umfBaseMap.get(thisUS.parameter__c);
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
        List<String> relatedValues = valuePicklist.get(thisUS.parameter__c);

		if (relatedValues != null && relatedValues.size() > 0) {
	        //create select options for each item
	        for (String s : relatedValues) {
	            options.add(new SelectOption(s,s));
	        }
		}
        return options;
    }
    
    public List<SelectOption> getLevelItems() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> relatedValues = levelPicklist.get(thisUS.parameter__c);

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

    public PageReference refreshValues() {
		thisUS.ParamNumber__c = umfOrderMap.get(thisUS.parameter__c);
		thisUS.baseObject__c = umfBaseMap.get(thisUS.parameter__c);
		return null;    	
    }
}