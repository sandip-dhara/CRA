public class ExtendedRelDelRev {

    
    public ExtendedRelDelRev(ApexPages.StandardController controller) {
       /*rdr = (Release_Deliverable_Reviewer__c)controller.getRecord();
       CurReleaseDeliverableId = rdr.Release_Deliverable_ID__c;
       if(string.isNotEmpty(CurReleaseDeliverableId))
        {
            Release_Deliverable__c rdc = [select Deliverable_Name__c,Offering_Release_Stage_ID__r.Id, Stage_Name__c,
                     Offering_Release_Stage_ID__r.Offering_Release_Name__c, Offering_Release_Stage_ID__r.Offering_Release_ID__c,
                     Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_Name__c, Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__c,
                     Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__r.Service_Line__c , Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__r.Service_Line_Name__c
                from Release_Deliverable__c where id=:CurReleaseDeliverableId];
            CurReleaseDeliverable  = rdc.Deliverable_Name__c;
            CurReleaseStage = rdc.Stage_Name__c;
            CurReleaseStageId = rdc.Offering_Release_Stage_ID__r.Id;
            CurRelease = rdc.Offering_Release_Stage_ID__r.Offering_Release_Name__c;
            CurReleaseId = rdc.Offering_Release_Stage_ID__r.Offering_Release_ID__c;
            CurOffering = rdc.Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_Name__c;
            CurOfferingId = rdc.Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__c;
            CurServiceLine = rdc.Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__r.Service_Line__c;
            CurServiceLineId = rdc.Offering_Release_Stage_ID__r.Offering_Release_ID__r.Offering_ID__r.Service_Line_Name__c;
            WrongCall = false;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You call this page did not deliver the priority parameter'));
            WrongCall = true;
        }*/
    }
    
   /* public PageReference save(){
        try{
            if(SaveValidation(rdr) == 'Success'){
                upsert rdr;
                PageReference RDRPage = new PageReference('/'+rdr.Release_Deliverable_ID__c);
                RDRPage.setRedirect(true);
                return RDRPage;
            }else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please Check your input. The Reviewer might be existed'));
                return null;
            }
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Please Check your input'));  
            return null;
        }
    }
    
    public void DynamicRelDelName(){
        list<Release_Deliverable__c> RelDelC= [select Release_Deliverable_Name__c from Release_Deliverable__c where id =:rdr.Release_Deliverable_ID__c];
        if(RelDelC.size() == 1)
        {
            curRelDelName = RelDelC[0].Release_Deliverable_Name__c;
            hideField =  'Release Deliverable Name';
        }
        else
        {
            curRelDelName= '';
            hideField =  '';
        }
    }
    public String SaveValidation(Release_Deliverable_Reviewer__c validateobj){
        list<Release_Deliverable_Reviewer__c> RelDelRList= [select Reviewer__c from Release_Deliverable_Reviewer__c where Release_Deliverable_ID__c =:rdr.Release_Deliverable_ID__c and Reviewer__c =: rdr.Reviewer__c];
        if(RelDelRList.size()>=1){
            return 'Failed';
        }else{
            return 'Success';
        }
    }
    
    public boolean disbledFiled{get;set;}
    public string curRelDelName{get;set;}
    public string curRelDelID{get;set;}
    public string hideField{get;set;}
    public final Release_Deliverable_Reviewer__c rdr;

    public string CurReleaseDeliverable{get;set;}
    public string CurReleaseDeliverableId{get;set;}
    public string CurReleaseStage{get;set;}
    public string CurReleaseStageId{get;set;}
    public string CurRelease{ get;set; }
    public string CurReleaseId{ get;set; }
    public string CurOffering{ get;set; }
    public string CurOfferingId{ get;set;}
    public string CurServiceLine{ get;set;}
    public string CurServiceLineId{ get;set; }
   
    public boolean WrongCall{get;set;}*/
}