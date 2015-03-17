@isTest(SeeAllData=true)
private class TestPLMTraggers{
    // Release Stage generator
    static Offering_Release_Stage__c createNewReleaseStage() {
        // Create test stage and insert it into the database
        Offering_Release_Stage__c stage = new Offering_Release_Stage__c();
        stage.Offering_Release_ID__c = id.valueOf('a6yZ0000000CxiU');
        stage.Stage_ID__c = id.valueOf('a6zZ00000008ekr');
        stage.Start_Date__c = date.newInstance(2013, 12, 15);
        stage.Allowable_Variance__c = date.newInstance(2013, 12, 15);
        stage.Status__c = 'Not Started';
        stage.PAC__c = 'ABS';
        return stage;
    }
    
	// Single row Release Stage => Create
    static testMethod void verifyReleaseStageCreate(){
        Offering_Release_Stage__c stage = createNewReleaseStage();
 
        // Delete the Invoice, capture the result
        Database.SaveResult result = Database.insert(stage, false);
 
        // Assert success, because target Invoice doesn't have Line Items
        System.assert(result.isSuccess());
    }
}