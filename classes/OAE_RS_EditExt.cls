public with sharing class OAE_RS_EditExt {
	private RuleScenario__c thisRS;

	public final String objType { get; set; }
	private Map<Decimal,TableCols> rsGridMap { get; set;}
	private Map<Decimal,Boolean> checkMap { get; set; }

	private Map<Decimal,EngineFields__c> efMap = new Map<Decimal,EngineFields__c>();

	public String[] pickSelected { get; set; }
	public String checkSelected { get; set; }
	public Boolean showSelect { get; set; }
	public Boolean showCheck { get; set; }
	public Integer selectSize { get; set; }
	public Decimal numberShown { get; set; }

	public OAE_RS_EditExt(ApexPages.StandardController stdC) {
		thisRS = (RuleScenario__c)stdC.getRecord();

		objType = thisRS.RuleObjectInternal__c;
//		objType = thisRS.RuleObject__c;
                
		showSelect = false;
		showCheck = false;
        
		rsGridMap = new Map<Decimal,TableCols>();
		checkMap = new Map<Decimal,Boolean>();

		Integer objNameLen = objType.length();        
		String dispColor;
		Decimal dc;        
		//get the relevant fields from custom setting
		Map<String,EngineFields__c> fNames = EngineFields__c.getAll();

		for (EngineFields__c ef : fNames.values()) {
			dispColor = 'black';

//			if (ef.Name.substring(0,objNameLen).equalsIgnoreCase(objType)) {
			if (ef.object__c == thisRS.RuleObjectInternal__c) {
				dc = ef.Order__c;
				//get the corresponding field, display current value
				String fieldName = 'X'+dc.round()+'__c';
				String currentVals = (String)thisRS.get(fieldName);

				//show that this field is ignored
				if (currentVals == null || currentVals == '') {
					currentVals = '';
					dispColor = 'darkgrey';
				}                

				efMap.put(dc,ef);
				rsGridMap.put(dc,new TableCols(ef.Label__c,currentVals,String.ValueOf(dc),dispColor));
				//boolean map indicating which items are checkboxes
				checkMap.put(dc,ef.Type__c == 'Checkbox');
			}
		}
	}
    
	public PageReference openSelectBox() {
		Boolean isCheckbox = checkMap.get(numberShown);
		showSelect = !isCheckbox;
		showCheck = isCheckbox;
		return null;
	}
    
	public PageReference modifyPick() {
		showSelect=false;
		showCheck=false;
		movePicksToList();
		return null;
	}
    
	public PageReference modifyCheck() {
		showSelect=false;
		showCheck=false;
		moveSelection();
		return null;
	}
    
	public PageReference cancelOut() {
		showSelect=false;
		showCheck=false;
		return null;
	}
    
	public PageReference updateRecord() {
		update thisRS;        
		return new PageReference('/'+thisRS.id);
	}
    
	public void moveSelection() {
		TableCols modCols = rsGridMap.get(numberShown);
		modCols.sTwo = checkSelected;
		modCols.sFour = 'red';

		thisRS.put('X'+numberShown.round()+'__c', checkSelected);
	}

	public void movePicksToList() {
		String delimitedPicks = convertPicks(pickSelected);
		TableCols modCols = rsGridMap.get(numberShown);
		modCols.sTwo = delimitedPicks;
		modCols.sFour = 'red';
		thisRS.put('X'+numberShown.round()+'__c', delimitedPicks);
	}

	public String convertPicks(String[] picks) {
		String retVal = '';
		for (String p : picks)
			retVal = retval + p + ';';
            
		if (retVal != '')
			retVal = retVal.substring(0,retVal.length()-1);
        
		return retVal;
	}
 
	public List<TableCols> getRsGrid() { 
		List<TableCols> retVal = new List<TableCols>();
        
		//get the keys into a list for sorting
		List<Decimal> sortkeys = new List<Decimal>();
		sortkeys.addAll(rsGridMap.keySet());
		sortkeys.sort();
    
		for (Decimal dc : sortkeys) 
			retVal.add(rsGridMap.get(dc));

		return retVal;
	}
        
	public List<SelectOption> getChecks() {
		List<SelectOption> options = new List<SelectOption>();       

		String objectValue = (String)thisRS.get('X'+numberShown.round()+'__c');
		if (objectValue != null) {
			checkSelected = objectValue;
		} else
			checkSelected = 'False';

		options.add(new SelectOption('True','True'));
		options.add(new SelectOption('False','False'));
		options.add(new SelectOption('','Ignore'));
		return options;
	}
    
	public List<SelectOption> getPickItems() {
		EngineFields__c thisEF = efMap.get(numberShown);
		List<SelectOption> options = new List<SelectOption>();       
		Set<String> allOptions = new Set<String>();
		String[] givenOptions;
		String objectValue;
        
		//get selectable values
		if (thisEF.type__c.equalsignorecase('PICKLIST')) {
			//for picklists, get dynamically from schema
			Map<String, Schema.SObjectField> objSchema = Schema.getGlobalDescribe().get(objType).getDescribe().fields.getMap();
			givenOptions = OAE_VFUtils.getPickVals(objSchema,thisEF.Path__c).split(', ',0);
		} else {
			//for custom, get from the custom settings
			givenOptions = OAE_VFUtils.getCustomVals('R'+thisEF.Name).split(', ',0);
		}

		//get selected values from the RS object        
		objectValue = (String)thisRS.get('X'+numberShown.round()+'__c');
		if (objectValue != null) { 
			if (objectValue.contains(';'))
				pickSelected = objectValue.split(';',0);
			else
				pickSelected = new String[]{objectValue};
		} else
			pickSelected = new String[]{};
        
		//add to a set to remove duplicates 
		allOptions.addall(givenOptions);
		allOptions.addall(pickSelected);

		//add to a list, which can be sorted
		List<String> sortedOptions = new List<String>();
		sortedOptions.addall(allOptions);
		sortedOptions.sort();
                
		//create select options for each item
		for (String s : sortedOptions) {
			options.add(new SelectOption(s,s));
		}
		selectSize = options.size() + 2;
		return options;
	}
	public String getX1() { return thisRS.X1__c; }
}