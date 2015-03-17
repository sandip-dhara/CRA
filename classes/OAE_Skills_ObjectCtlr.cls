public with sharing class OAE_Skills_ObjectCtlr {

//TODO:  What to do with target
    public final String targetObjectType { get; set; }

	public String selectedObject {get;set;}				//the object we're working with, based on selection on vf page
	public String currentPath {get;set;}				//current traversal down from base
	private String currentObjType;						//type of object at current traversal

	public Boolean showExisting {get;set;}				//whether we have any existing params or not
														//switches on/off top of VF page
	public Boolean showingObject {get;set;}				//have we selected an object to work with?
														//switches on/off bottom of VF page
	public Boolean showTraversing {get;set;}			//switches on/off traversal display

	public List<TableCols> inUseParams {get;set;}		//tablecols of existing params, from the custom setting schema
    													//displayed at the top of the VF page
	private Set<String> availObjNames;					//the names of objects we can select from (driven by rule select)
	public List<TableCols> objectsInUse {get;set;}
														//drives the dropdown on VF page

	public String relatedFieldName {get;set;}				//the object we're working with, based on selection on vf page
	public String relatedFieldLabel {get;set;}				//the object we're working with, based on selection on vf page
	public String relatedObjType {get;set;}				//the object we're working with, based on selection on vf page
	public String pathToAdd {get;set;}				//the object we're working with, based on selection on vf page
	public String fieldTypeToAdd {get;set;}				//the object we're working with, based on selection on vf page
	public String nameToDelete {get;set;}				//the object we're working with, based on selection on vf page
	public String nameForLevels {get;set;}				//the object we're working with, based on selection on vf page

    private Map<String, Map<String, Schema.SObjectField>> sourceObjSchemas;  //map of schemas keyed by object

	private Map<String,Set<String>> inUseParamsByObject;	//set of parameters being used, keyed by object, for dupe checks

	private Map<String,List<TableCols>> paramsByObject;
    public List<TableCols> unusedParams { get;set;}
    private Map<String,List<TableCols>> childObjsByObject;
    public List<TableCols> childObjs { get; set;}

	public OAE_Skills_ObjectCtlr() {
        //initialize
		sourceObjSchemas = new Map<String, Map<String, Schema.SObjectField>>();
		paramsByObject = new Map<String,List<TableCols>>();
		childObjsByObject = new Map<String,List<TableCols>>();
        unusedParams = new List<TableCols>();
        childObjs = new List<TableCols>();
//TODO: make the target anything, not just user
        targetObjectType = 'User';						

		//get the set of objects currently in use per the rule select
		availObjNames = new Set<String>();
        Map<String,EngineFields__c> fNames = EngineFields__c.getAll();
		for (EngineFields__c ef : fNames.values())
			availObjNames.add(ef.Object__c);
		//assign the set to the list for display
		objectsInUse = new List<TableCols>();
		for (String objName : availObjNames) 
			objectsInUse.add(new TableCols(objName,Schema.getGlobalDescribe().get(objName).getDescribe().getLabel()));

        //get current in-use object fields from custom settings
        inUseParamsByObject = new Map<String,Set<String>>();
        String uBase;
		Set<String> objInUseParams;

        Map<String,UserMatchFields__c> umfNames = UserMatchFields__c.getAll();
		List<UserMatchFields__c> inUseParamsList = new List<UserMatchFields__c>();	
        for (UserMatchFields__c umf : umfNames.values()) {
            uBase = umf.Base__c;
			//filter out only the object parameters
            if (!uBase.equalsignorecase('SCHEDULE') && !uBase.equalsignorecase('USERDATA__C') && !uBase.equalsignorecase('CUSTOM')) {
				inUseParamsList.add(umf);
				objInUseParams = inUseParamsByObject.get(uBase.toUpperCase());
				if (objInUseParams == null) {
					objInUseParams = new Set<String>();
					inUseParamsByObject.put(uBase.toUpperCase(),objInUseParams);
				}
				objInUseParams.add(umf.Path__c);
            }
        }

		inUseParams = convertToTableCols(OAE_VFUtils.sortUMFList(inUseParamsList));

		showExisting = inUseParams.size() > 0;
		showingObject = false;
	}

	//go to the metadata and get the schema for the specified object
	private Map<String, Schema.SObjectField> populateSchema(String objName) {
		Map<String, Schema.SObjectField> thisSchema;
		Schema.Sobjecttype thisSOType = Schema.getGlobalDescribe().get(objName);
        if (thisSOType != null) {
        	thisSchema = thisSOType.getDescribe().fields.getMap();
			sourceObjSchemas.put(objName.toUpperCase(), thisSchema);
        }
        return thisSchema;
	}

//	private void getParamsForObject(String objName){
	private TableCols getParamsForObject(String objName){
		Map<String, Schema.SObjectField> thisSchema = sourceObjSchemas.get(objName.toUpperCase());
		if (thisSchema == null)
			thisSchema = populateSchema(objName);

		List<TableCols> thisParamSet = new List<TableCols>();
		List<TableCols> thisChildObjs = new List<TableCols> ();

        //get other options from schema
        String thisType;
        String thisName;

        for (Schema.SObjectField s : thisSchema.values()) {
            Schema.DescribeFieldResult sdr = s.getDescribe(); 

            thisType = sdr.getType().name();
            thisName = sdr.getName();

            if (thisType.equalsIgnoreCase('REFERENCE')) {
                if ( sdr.getRelationshipName() != null &&  sdr.getRelationshipName() != '') {
                    TableCols tc = new TableCols(sdr.getLabel(), sdr.getReferenceTo()[0].getDescribe().getName(), 
                        sdr.getRelationshipName(),sdr.getName());
					thisChildObjs.add(tc);
                }
            } else if (s.getDescribe().isCalculated()) { 
                    TableCols tc = new TableCols(sdr.getLabel(), 'Formula', thisName);
                    thisParamSet.add(tc);
			} else if (thisType.equalsIgnoreCase('PICKLIST')) {
                    TableCols tc = new TableCols(sdr.getLabel(), 'Picklist', thisName);
                    thisParamSet.add(tc);
			} else if (thisType.equalsIgnoreCase('BOOLEAN')) {
                    TableCols tc = new TableCols(sdr.getLabel(), 'Checkbox', thisName);
                    thisParamSet.add(tc);
			}
        }
    	thisParamSet = OAE_VFUtils.sortTC(thisParamSet);
    	thisChildObjs = OAE_VFUtils.sortTC(thisChildObjs);
    	
    	paramsByObject.put(objName.toUpperCase(),thisParamSet);
    	childObjsByObject.put(objName.toUpperCase(),thisChildObjs);
		return null;
	}

	//return a filtered list of tablecols, removing ones already in use
	private List<TableCols> filterDupes (List<TableCols> fullList, Set<String> dupes) {		
		if (dupes == null) return fullList;
		
		String currentDot = '';
		if (currentPath != '') currentDot = currentPath + '.';  

		List<TableCols> retVal = new List<TableCols>();

		for (TableCols tc : fullList) {
			if (tc.sThree != null && !dupes.contains(currentDot+tc.sThree)) {
				retVal.add(tc);
			}
		}
		return retVal;
	}
	
	//used by the VF page to get a sorted list of in use params
/*
	public List<TableCols> getInUseParams() {  
		return convertToTableCols(OAE_VFUtils.sortUMFList(inUseParams));
	}
*/	
	//convert existing fields to tablecols for display
	public List<TableCols> convertToTableCols(List<UserMatchFields__c> theList) {
		List<TableCols> retVal = new List<TableCols>();

		TableCols tc;
		String ufType;
		String fourth;
		for (UserMatchFields__c uf : theList) {
			ufType = uf.Type__c;
            if (ufType.equalsignorecase('PICKLIST')) {
            	//get picklist values for this field
            	//get the schema for the correct base object
				Map<String, Schema.SObjectField> thisSchema = sourceObjSchemas.get(uf.Base__c.toUpperCase());
				if (thisSchema == null) {
					thisSchema = populateSchema(uf.Base__c);
				}					
				fourth = OAE_VFUtils.getPickVals(thisSchema, uf.Path__c);
            } else if (ufType.equalsignorecase('CHECKBOX')) {
				fourth = 'true, false';
            } else if (ufType.equalsignorecase('NUMERIC')) {
				fourth = 'n/a';
            } else {
				fourth = OAE_VFUtils.getCustomVals('M'+uf.Name);
            }
            tc = new TableCols(uf.Base__c, uf.Label__c, uf.Type__c, uf.Path__c, fourth, uf.Name);
            retVal.add(tc);
		}
		return retVal;
	}
	
	//VF action:  start the process of picking a field for the selected object
	//selectedObject passed by the button click
	public PageReference startWithObject() {
		showTraversing = false;
		currentPath = '';  //start at base
		currentObjType = selectedObject;
		redrawTableContents();
		return null;
	}
	public void redrawTableContents() {
		//grab the parameter list from the map if we've done it already
		List<TableCols> thisSchemaFieldList = paramsByObject.get(currentObjType.toUpperCase());

		//if we haven't, go do the schema work
		if (thisSchemaFieldList == null)
			unusedParams.add(getParamsForObject(currentObjType));

		//and now go get the list from the map (it won't be null anymore)
		thisSchemaFieldList = paramsByObject.get(currentObjType.toUpperCase());
		//also go get the child objects from the schema map
		List<TableCols> thisChildObjs = childObjsByObject.get(currentObjType.toUpperCase());

		//retrieve the duplicates already in use
		set<String> dupesForThisObject = inUseParamsByObject.get(selectedObject.toUpperCase());

		//filter the existing "dupes" from the schema list
		//this unusedParams is used by the VF page for display
		unusedParams = filterDupes(thisSchemaFieldList,dupesForThisObject);
		childObjs = thisChildObjs;

		showingObject = true;
	}

	//VF action:  delete the selected field
	public PageReference fieldDelete() {
        PageReference curr;
		UserMatchFields__c umf = UserMatchFields__c.getInstance(nameToDelete);
		if (umf != null) {
			OAE_VFUtils.removeFieldFromUserSetting(umf);
			curr = new PageReference('/apex/OAE_Skills_Object');
        	curr.setRedirect(true);
		}
        return curr;
	}

	//VF action:  edit levels for the selected field
	public PageReference editLevels() {
        PageReference curr;
		curr = new PageReference('/apex/OAE_Skills_Level?oName='+nameForLevels);
    	curr.setRedirect(true);

        return curr;
	}

	//VF action:  move to a child in the current path
	public PageReference traverseChildObject() {
		showTraversing = true;
		if (currentPath != '') currentPath = currentPath + '.';
		currentPath = currentPath + relatedFieldName;
		
		currentObjType = relatedObjType;
		
		redrawTableContents();
		
		//for now:
		return null;
	}
	//VF action:  add the field clicked by the user
	public PageReference addSelectedField() {
        PageReference curr;
		String wholePath = currentPath;
		if (wholePath != '') wholePath = wholePath + '.';
		Map<String, Schema.SObjectField> thisSchema = sourceObjSchemas.get(currentObjType.toUpperCase());
		if (thisSchema != null) {
	        if (fieldTypeToAdd.equalsignorecase('Formula')) {
	            String paramString = OAE_VFUtils.customParamString(thisSchema.get(pathToAdd),selectedObject,wholePath,currentObjType,selectedObject);
	            curr = new PageReference('/apex/OAE_Skills_Formula?'+paramString);
	        } else {
	            OAE_VFUtils.addFieldToUserSetting(thisSchema.get(pathToAdd),selectedObject,wholePath,fieldTypeToAdd,selectedObject);
		        curr = new PageReference('/apex/OAE_Skills_Object');
	        }
		}
        curr.setRedirect(true);
        return curr;
	}
}