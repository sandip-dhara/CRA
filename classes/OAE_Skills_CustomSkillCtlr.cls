public with sharing class OAE_Skills_CustomSkillCtlr {

    public final String targetObjectType { get; set; }
	public Boolean showExisting {get;set;}					//whether we have any existing params or not
	public Boolean showNew {get;set;}						//show the new once user has requested to do so

	public List<TableCols> existingParams {get;set;}		//tablecols of existing params, from the custom setting schema
	private Set<String> objectsInUse;

    public String newSkillObject {get;set;}					//new custom values input by the user
    public String newSkillLabel {get;set;}					//new custom values input by the user
    public String newSkillVals {get;set;}					//new custom values input by the user
    public String newLevelVals {get;set;}					//new custom values input by the user
    public String newCustomVals {get;set;}					//new custom values input by the user

    public String skillLevelsToEdit {get;set;}				//new custom values input by the user
    public String skillToDelete {get;set;}					//new custom values input by the user
    public String levelToRemove {get;set;}					//new custom values input by the user
    public String customToRemove {get;set;}					//new custom values input by the user
    public String customToEdit {get;set;}					//new custom values input by the user

	public Set<String> existingCustomVals {get;set;}
	public Boolean showExistingCustom {get;set;}
	
	public Set<String> existingLevels {get;set;}
	public Boolean showLevels {get;set;}
	public Boolean showExistingLevels {get;set;}
	
	EnginePicklists__c existingEP;

	public OAE_Skills_CustomSkillCtlr() {

		objectsInUse = new Set<String>();
		for (EngineFields__c ef : EngineFields__c.getAll().values())
			objectsInUse.add(ef.Object__c);

		existingParams = new List<TableCols>();

        for (UserMatchFields__c umf : UserMatchFields__c.getAll().values()) {
			//filter out only the custom parameters
            if (umf.Base__c.equalsignorecase('CUSTOM')) {
				existingParams.add(new TableCols(umf.Name, umf.Label__c, OAE_VFUtils.getCustomVals('M'+umf.Name)));
			}
        }

		existingCustomVals = new Set<String>();
		showExistingCustom = false;

		existingLevels = new Set<String>();
		showExistingLevels = false;

		showNew = false;
		showExisting = existingParams.size() > 0;
	}

    public List<SelectOption> getObjInUseList() {
        List<SelectOption> options = new List<SelectOption>();

		for (String s : objectsInUse) {
			options.add(new SelectOption(s,s));
		}
        return options;
    }

	public PageReference showNewArea() {
		showNew = true;
		existingEP = null;
		existingCustomVals = new Set<String>();
		showExistingCustom = false;
		existingLevels = new Set<String>();
		showLevels = false;
		showExistingLevels = false;
		return null;
	}

	public PageReference showLevelArea() {
		showNew = false;
		existingCustomVals = new Set<String>();
		showExistingCustom = false;
		existingLevels = new Set<String>();
		existingEP = EnginePicklists__c.getInstance('L'+skillLevelsToEdit);

		if (existingEP != null) {
            String pv = existingEP.PickValues1__c;
            if (existingEP.PickValues2__c != null)
                pv = pv + existingEP.PickValues2__c;
			List<String> strings = pv.split(';',0);
			for (String s : strings)
				existingLevels.add(s);
		}
		showExistingLevels = existingLevels.size() > 0;
		showLevels = true;

		return null;
	}

	public PageReference showCustomArea() {
		showNew = false;
		existingLevels = new Set<String>();
		showExistingLevels = false;
		showLevels = false;
		existingCustomVals = new Set<String>();

		existingEP = EnginePicklists__c.getInstance('M'+customToEdit);

		if (existingEP != null) {
            String pv = existingEP.PickValues1__c;
            if (existingEP.PickValues2__c != null)
                pv = pv + existingEP.PickValues2__c;
			List<String> strings = pv.split(';',0);
			for (String s : strings)
				existingCustomVals.add(s);
		}
		showExistingCustom = existingCustomVals.size() > 0;

		return null;
	}

	//VF action:  create a new custom skill
	public PageReference createNewCustomSkill() {
        List<String> valSplit = newSkillVals.split('\r\n',0);
        String scDelim = '';
        for (String s : valSplit) {
			if (s.startsWith('$')) {
//TODO: add error message
				return null;
			} else
 	           scDelim = scDelim + s + ';';
		}

		//truncate last semicolon
        if (scDelim.length() > 0)
            scDelim = scDelim.substring(0,scDelim.length()-1);		

		Long nextNum = OAE_VFUtils.addFieldToUserSetting(newSkillLabel,newSkillObject,'','Custom','Custom');

        if (scDelim.length() < 255)
			OAE_VFUtils.addCustomRulePicklist('M'+newSkillObject+nextNum, newSkillObject, '', scDelim, '');
        else
			OAE_VFUtils.addCustomRulePicklist('M'+newSkillObject+nextNum, newSkillObject,
					scDelim.substring(0,255),scDelim.substring(255,Math.min(510,scDelim.length())));

        PageReference curr = new PageReference('/apex/OAE_Skills_CustomSkill');
        curr.setRedirect(true);
        return curr;
	}

	//VF action:  edit custom pick values for this custom skill
	public PageReference customRemove() {
		existingCustomVals.remove(customToRemove);

		existingEP = OAE_VFUtils.modifyLevels(existingEP, newCustomVals, existingCustomVals, false);

		update existingEP;

        return null;
	}

	//VF action:  edit levels for this custom skill
	public PageReference modifyCustomSkill() {
		existingEP = OAE_VFUtils.modifyLevels(existingEP, newCustomVals, existingCustomVals, true);
		update existingEP;

        PageReference curr = new PageReference('/apex/OAE_Skills_CustomSkill');
        curr.setRedirect(true);
        return curr;
	}

	//VF action:  edit levels for this custom skill
	public PageReference levelRemove() {
		existingLevels.remove(levelToRemove);

		existingEP = OAE_VFUtils.modifyLevels(existingEP, newLevelVals, existingLevels, false);

		update existingEP;

        return null;
	}

	//VF action:  edit levels for this custom skill
	public PageReference saveLevels() {
		if (existingEP == null) {
	        EnginePicklists__c epk = new EnginePicklists__c();
	        epk.Name = 'L' + skillLevelsToEdit;
			epk = OAE_VFUtils.modifyLevels(epk, newLevelVals, existingLevels, true);
	        insert epk;
		} else {
			existingEP = OAE_VFUtils.modifyLevels(existingEP, newLevelVals, existingLevels, true);
			update existingEP;
		}

        PageReference curr = new PageReference('/apex/OAE_Skills_CustomSkill');
        curr.setRedirect(true);
        return curr;
	}

	//VF action:  delete the selected custom skill
	public PageReference skillDelete() {
        PageReference curr;
		UserMatchFields__c umf = UserMatchFields__c.getInstance(skillToDelete);
		if (umf != null) {
			OAE_VFUtils.removeFieldFromUserSetting(umf);
	        curr = new PageReference('/apex/OAE_Skills_CustomSkill');
        	curr.setRedirect(true);
		}
        return curr;
	}
}