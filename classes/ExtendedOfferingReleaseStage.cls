public class ExtendedOfferingReleaseStage {

    public ExtendedOfferingReleaseStage(ApexPages.StandardController controller) {
        /*orsc = (Offering_Release_Stage__c)controller.getRecord();
        StatusDisable = false;
        CurReleaseId = orsc.Offering_Release_ID__c;
        if(string.isNotEmpty(CurReleaseId))
        {
            Offering_Release__c orc = [select Offering_ID__c,Offering_Name__c,Name__c from Offering_Release__c where id=:CurReleaseId];
            CurRelease = orc.Name__c;
            CurOffering = orc.Offering_Name__c;
            CurOfferingId = orc.Offering_ID__c;
            Offering__c oc = [select Service_Line_Name__c,Service_Line__c from Offering__c where id =:CurOfferingId];
            CurServiceLine = oc.Service_Line__c;
            CurServiceLineId = oc.Service_Line_Name__c;
            WrongCall = false;
            
            if(string.isNotEmpty(orsc.Stage_ID__c))
            {
                SetStageName();
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You call this page did not deliver the priority parameter'));
            WrongCall = true;
        }
        
        string upId = ApexPages.currentPage().getParameters().get('id');
        if(string.isNotEmpty(upId)) //update risk
        {
            myEditStates = 'Update';
            if(orsc.Status__c == 'Complete' || orsc.Status__c == 'In Review')
            {
                StatusDisable = true;
            }
        }
        else
        {
            myEditStates = 'New';
        }*/
    }
    
   /*public void SetStageName()
    {
        List<Stage__c> basicStage = [select Name__c from Stage__c where id =:orsc.Stage_ID__c];
        if(basicStage.size() == 1)
        {
            StageName = basicStage[0].Name__c;
        }
    }
    
    public string saveData(){
        try{
            string validateStr = PLMValidationTools.ValidateReleaseStage(orsc);
            if(validateStr == 'success')
            {
                upsert orsc;
                if(myEditStates == 'New')
                {
                     List<Stage_Deliverable__c> deliverables = [Select id,Deliverable_ID__c,Deliverable_ID__r.Name__c,Deliverable_ID__r.Description__c,Deliverable_ID__r.RecordType.Name
                                        From Stage_Deliverable__c
                                        Where Stage_ID__c = :orsc.Stage_ID__c];
                    for(Stage_Deliverable__c sdc:deliverables)
                    {
                        Release_Deliverable__c c = new Release_Deliverable__c(
                        Offering_Release_Stage_ID__c = orsc.id,
                        Stage_Deliverable_ID__c = sdc.Id,
                        Release_Deliverable_Name__c = sdc.Deliverable_ID__r.Name__c,
                        Description__c = sdc.Deliverable_ID__r.Description__c,
                        RecordTypeId = TransferRecordType(sdc.Deliverable_ID__r.RecordType.Name));
                        insert c;
                    }
                }
                else
                {
                    List<Stage_Deliverable__c> deliverables = [Select id,Deliverable_ID__c,Deliverable_ID__r.Name__c,Deliverable_ID__r.Description__c,Deliverable_ID__r.RecordType.Name
                                        From Stage_Deliverable__c
                                        Where Stage_ID__c = :orsc.Stage_ID__c];
                    List<Release_Deliverable__c> rds = [Select Stage_Deliverable_ID__r.id
                                        From Release_Deliverable__c
                                        Where Offering_Release_Stage_ID__c = :orsc.id];
                    for(Stage_Deliverable__c sdc:deliverables)
                    {
                        if(CheckStageDeliverableNotExists(rds, sdc.Id))
                        {
                            Release_Deliverable__c c = new Release_Deliverable__c(
                            Offering_Release_Stage_ID__c = orsc.id,
                            Stage_Deliverable_ID__c = sdc.Id,
                            Release_Deliverable_Name__c = sdc.Deliverable_ID__r.Name__c,
                            Description__c = sdc.Deliverable_ID__r.Description__c,
                            RecordTypeId = TransferRecordType(sdc.Deliverable_ID__r.RecordType.Name));
                            insert c;
                        }
                    }
                }
                return 'success';
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));
                return 'failed';
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'exception:' + e.getMessage()));
            return 'failed';   
        }                   
    }
    
    private id TransferRecordType(string name)
    {
        return [SELECT Id FROM RecordType WHERE Name = :name AND SobjectType = 'Release_Deliverable__c'].Id;
    }
    
    private boolean CheckStageDeliverableNotExists(List<Release_Deliverable__c> rds, id sdId)
    {
        for(Release_Deliverable__c c:rds)
        {
            if(c.Stage_Deliverable_ID__r.id == sdId)
            {
                return false;
            }
        }
        return true;
    }
    
    public PageReference Save(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            PageReference OFPage = new PageReference('/'+orsc.Offering_Release_ID__c);
            OFPage.setRedirect(true);
            return OFPage;
        }
        else
        {
            return null;
        }
    }
    
    public string CurRelease{get;set;}
    public string CurReleaseId{get;set;}
    
    public string CurOffering{get;set;}
    public string CurOfferingId{get;set;}
    
    public string CurServiceLine{get;set;}
    public string CurServiceLineId{get;set;}
    
    public string myEditStates{get;set;}
    public boolean WrongCall{get;set;}
    
    public final Offering_Release_Stage__c orsc;
    
    public String StageName{get;set;}
    
    public boolean StatusDisable{get;set;}*/
}