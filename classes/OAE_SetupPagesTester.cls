@isTest
public class OAE_SetupPagesTester {
public static testmethod void TestSetupPageControllers() {
    Test.setCurrentPage(Page.OAE_Rules_Start);
    OAE_Rules_StartCtlr startPg = new OAE_Rules_StartCtlr();
    startPg.getAvailablePicklist();
    startPg.objToEdit = 'fooey';
    startPg.editObject();
    Test.setCurrentPage(Page.OAE_Rules_Start);
    startPg.objToAdd = 'case';
    startPg.editNewObject();
        
    Test.setCurrentPage(Page.OAE_Rules_FieldAdd);
    ApexPages.currentPage().getParameters().put('oObject','lead');
    OAE_Rules_FieldAddCtlr fieldPg = new OAE_Rules_FieldAddCtlr();
    fieldPg.getFieldGrid();
    fieldPg.addThisField = 'a';
    fieldPg.objectForward = 'b';
    fieldPg.fieldType = 'c';
    fieldPg.objLoop();
    Test.setCurrentPage(Page.OAE_Rules_FieldAdd);
    fieldPg.addThisField = 'Status';
    fieldPg.fieldType = 'Picklist';
    fieldPg.fieldAdd();
    
    Test.setCurrentPage(Page.OAE_Rules_RelatedField);
    ApexPages.currentPage().getParameters().put('oType','lead');
    ApexPages.currentPage().getParameters().put('oPath','ConvertedAccount');
    ApexPages.currentPage().getParameters().put('oName','Account');
    ApexPages.currentPage().getParameters().put('oLabel','Converted Account ID');
    ApexPages.currentPage().getParameters().put('oFull','ConvertedAccount');
    OAE_Rules_RelatedFieldCtlr relatedPg = new OAE_Rules_RelatedFieldCtlr();
    relatedPg.objAssign();  
    Test.setCurrentPage(Page.OAE_Rules_RelatedField);
    relatedPg.addThisField = 'a';
    relatedPg.objectForward = 'b';
    relatedPg.fieldType = 'c';
    relatedPg.objLoop();

    Test.setCurrentPage(Page.OAE_Rules_CustomList);
    ApexPages.currentPage().getParameters().put('oObject','lead');
    ApexPages.currentPage().getParameters().put('oPath','ConvertedAccount.Customer_Value__c');
    ApexPages.currentPage().getParameters().put('oParent','Account');
    ApexPages.currentPage().getParameters().put('oLabel','Customer Label');
    OAE_Rules_CustomListCtlr listPg = new OAE_Rules_CustomListCtlr();
    listPg.inputVals = 'blee\r\nblah\r\nbloo';
    listPg.setVals();   

    Test.setCurrentPage(Page.OAE_Skills_Start);
    OAE_Skills_StartCtlr skillPg = new OAE_Skills_StartCtlr();
    skillPg.getCustParams();
    skillPg.getSkedParams();
    skillPg.getUserParams();

    Test.setCurrentPage(Page.OAE_Skills_Object);
    OAE_Skills_ObjectCtlr skillObjPg = new OAE_Skills_ObjectCtlr();
    skillObjPg.selectedObject = 'case';
    skillObjPg.startWithObject();
    skillObjPg.redrawTableContents();
    
    Test.setCurrentPage(Page.OAE_Skills_CustomSkill);
    OAE_Skills_CustomSkillCtlr skillCustPg = new OAE_Skills_CustomSkillCtlr();
    skillCustPg.getObjInUseList();
    skillCustPg.showNewArea();
    skillCustPg.newSkillLabel = 'mama';
    skillCustPg.newSkillObject = 'lead';
    skillCustPg.newSkillVals = 'leoni\\r\\npakeeta\\r\\nmia';
    skillCustPg.createNewCustomSkill();
    skillCustPg.customToEdit = 'lead4';
    skillCustPg.showCustomArea();
    skillCustPg.customToRemove = 'mia';
    //skillCustPg.customRemove();
    skillCustPg.newCustomVals = 'marigold';
    //skillCustPg.modifyCustomSkill();
    skillCustPg.skillLevelsToEdit = 'lead4';
    skillCustPg.showLevelArea();
    skillCustPg.newLevelVals = 'top\\r\\nmid\\r\\nbottom\\r\\nway way down';
    skillCustPg.saveLevels();
    skillCustPg.showLevelArea();
    skillCustPg.levelToRemove = 'way way down';
    skillCustPg.levelRemove();
    
    Test.setCurrentPage(Page.OAE_Skills_Level);
    ApexPages.currentPage().getParameters().put('oName','lead4');
    OAE_Skills_LevelCtlr skillLevelPg = new OAE_Skills_LevelCtlr();
    skillLevelPg.strToRemove = 'mid';
    skillLevelPg.fieldRemove();
    skillLevelPg.inputVals = 'real\\r\\nful';
    skillLevelPg.setVals();

    Test.setCurrentPage(Page.OAE_Skills_Formula);
    ApexPages.currentPage().getParameters().put('oParent','lead');
    ApexPages.currentPage().getParameters().put('oObject','lead');
    ApexPages.currentPage().getParameters().put('oLabel','Not Real');
    ApexPages.currentPage().getParameters().put('oBase','lead');
    ApexPages.currentPage().getParameters().put('oPath','Not_Real__c');
    OAE_Skills_FormulaCtlr skillFormPg = new OAE_Skills_FormulaCtlr();
    skillFormPg.doRedirect();
    skillFormPg.inputVals = 'real\\r\\nful';
    skillFormPg.setVals();

    User u = OAE_DataSetup.getOrCreateUser();
    System.runAs(u) {
        Test.setCurrentPage(Page.OAE_Start_Here);
        OAE_StartHereCtlr startHerePg = new OAE_StartHereCtlr();
        startHerePg.populateFirst();
    }   

    Lead singleLead = [select id from Lead limit 1];
    Test.setCurrentPage(Page.OAE_ReassignButton);
    ApexPages.currentPage().getParameters().put('oType','lead');
    ApexPages.currentPage().getParameters().put('bringBack','20');
    ApexPages.currentPage().getParameters().put('ID',singleLead.ID);
    OAE_ReassignButtonExt buttonPg = new OAE_ReassignButtonExt();
    buttonPg.setUpDefaultQueue();
}
}