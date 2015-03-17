public with sharing class SreeWorkElementPredecessorController {
    public Stage_Work_Element_Predecessor__c stageWorkElementPredecessor{get;set;}
    public String myEditWEP{get;set;}
    public string UserID{get;set;}
    public List<Stage_Work_Element_Predecessor__c> startupStageWEP{get;set;}
    public SreeWorkElementPredecessorController(ApexPages.StandardController controller) {
        stageWorkElementPredecessor = (Stage_Work_Element_Predecessor__c)controller.getRecord();
        UserID = UserInfo.getUserId();

        if(stageWorkElementPredecessor.Id == null)
        {
            myEditWEP = 'Create';
        }
        else
        {
            stageWorkElementPredecessor = [Select Id,
                                                  Name,
                                                  Predecessor_Stage_Work_Element_ID__c,
                                                  Work_Element__c,Stage_Work_Element__c,
                                                  Include__c,
                                                  Predecessor_Stage_Work_Element_Name__c,
                                                  Stage_Work_Element_Name__c from Stage_Work_Element_Predecessor__c where Id=:stageWorkElementPredecessor.Id];
            myEditWEP = 'Update';
        }

    }
    private string saveData(){
        try{
            upsert stageWorkElementPredecessor;
            return 'success';
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'exception:' + e.getMessage()));
            return 'failed';   
        }                 
    }
    public PageReference Save(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            PageReference WEPPage = new PageReference('/'+stageWorkElementPredecessor.Id);
            WEPPage.setRedirect(true);
            return WEPPage;
        }
        else
        {
            return null;
        }
    }

}