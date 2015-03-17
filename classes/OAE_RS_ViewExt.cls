public with sharing class OAE_RS_ViewExt {
    private RuleScenario__c thisRS;
    public String[] ruleLabels; 
    private Boolean[] showMe;
    
    public OAE_RS_ViewExt(ApexPages.StandardController stdC) {
        thisRS = (RuleScenario__c)stdC.getRecord();
        thisRS = [Select id, x1__c, x2__c, x3__c, x4__c, x5__c, x6__c, x7__c, x8__c, x9__c, x10__c,
        	RuleObject__c, RuleObjectInternal__c
//        	RuleObject__c
            From RuleScenario__c where id =:thisRS.ID];

        showMe = new Boolean[10];
        for (Integer i = 0; i < 10; i++) showMe[i] = false;

        ruleLabels = new String[10];
        for (Integer i = 0; i < 10; i++) ruleLabels[i] = '';

        //get current from custom settings
        Map<String,EngineFields__c> fNames = EngineFields__c.getAll();
        for (EngineFields__c ef : fNames.values()) {
			if(ef.object__c == thisRS.RuleObjectInternal__c) {
//			if(ef.object__c == thisRS.RuleObject__c) {
	            Integer z = ef.Order__c.intValue();
	            showMe[z-1] = true;
	            ruleLabels[z-1] = ef.Label__c;
			}
        }
    }

    private String getList(Integer i) {
        return ruleLabels[i-1];
    }
    
    private Boolean getShow(Integer i) {
        return showMe[i-1];
    }
    
    public String getList1() { return getList(1); }
    public String getList2() { return getList(2); }
    public String getList3() { return getList(3); }
    public String getList4() { return getList(4); }
    public String getList5() { return getList(5); }
    public String getList6() { return getList(6); }
    public String getList7() { return getList(7); }
    public String getList8() { return getList(8); }
    public String getList9() { return getList(9); }
    public String getList10() { return getList(10); }

    public Boolean getShow1() { return getShow(1); }
    public Boolean getShow2() { return getShow(2); }
    public Boolean getShow3() { return getShow(3); }
    public Boolean getShow4() { return getShow(4); }
    public Boolean getShow5() { return getShow(5); }
    public Boolean getShow6() { return getShow(6); }
    public Boolean getShow7() { return getShow(7); }
    public Boolean getShow8() { return getShow(8); }
    public Boolean getShow9() { return getShow(9); }
    public Boolean getShow10() { return getShow(10); }
}