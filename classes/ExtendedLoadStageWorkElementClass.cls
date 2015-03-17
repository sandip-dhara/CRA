public class ExtendedLoadStageWorkElementClass {

    public string para_RelStgName{get; set;}
    public string para_RelStgID{get; set;}
    public string para_WkEleId{get; set;}
    
    public string curRelStg{get;set;}
    public List<Work_Element__c> WEC {get;set;}
    public Release_Stage__c RSC{get;set;}

    public string FlightPlanID{get; set;}

    public ExtendedLoadStageWorkElementClass (){
        para_RelStgName= ApexPages.currentPage().getParameters().get('RelStgName');
        para_RelStgID = ApexPages.currentPage().getParameters().get('RelStgID');
        
        RSC = [select Offering_Release_ID__r.Flight_Plan_ID__c, Offering_Release_ID__r.Flight_Plan_Name__c, Stage_Name__c from Release_Stage__c where id =:para_RelStgID];
        
        WEC = [select Name__c, Deliverable_Name__c, Is_Active__c , Review_Required__c, Stage_Name__c from Work_Element__c where Stage_Name__c =:RSC.Stage_Name__c];
    }
    public PageReference cancel() {
        return null;
    }
    public PageReference save() {
        return null;
    }

}