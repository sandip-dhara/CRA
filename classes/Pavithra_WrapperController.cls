public class Pavithra_WrapperController {

    
    Public Offering_Release__c offeringReleaseObj{get;set;}
    public Potential_Risk__c potentialRiskObj{get;set;}
    


    public Business_Impact__c objBusinessImpact{get;set;}
    public Root_Cause__c objRootCause{get;set;}
    public Process_Control__c objProcessControl{get;set;}
    public Root_Cause_Control__c objRootCauseControl{get;set;}
    public Business_Impact_Cause__c objBusinessImpactCause{get;set;}
    Public List<Business_Impact__c> businessImpactList{get;set;}
    List<Business_Impact__c> business =new List<Business_Impact__c>();
    Public List<Root_Cause__c> rootCauseList{get;set;}
    
    public string description{get;set;}
    public String severity{get;set;}
    
    public Pavithra_WrapperController()
    {
    
        offeringReleaseObj = new Offering_Release__c();
        potentialRiskObj = new Potential_Risk__c();
        objProcessControl = new Process_Control__c();
        objRootCauseControl = new Root_Cause_Control__c();
        objBusinessImpactCause = new Business_Impact_Cause__c();
        //potentialRiskObj = [select Id,Description__c,Project_ID__c from Potential_Risk__c where Project_ID__c =:offeringReleaseObj.Id];
        system.Debug('########'+potentialRiskObj.Id);
        System.Debug('Test$$$$$'+offeringReleaseObj.Id);
    
    
    
        potentialRiskObj = new Potential_Risk__c();
        potentialRiskObj.Project_ID__c = 'a6yZ0000000DFz2';
        objBusinessImpact = new Business_Impact__c();
        objRootCause = new Root_Cause__c();
        businessImpactList = new List<Business_Impact__c>();
        rootCauseList = new List<Root_Cause__c>();
        businessImpactList.add(new Business_Impact__c());
        rootCauseList.add(new Root_Cause__c());
    }
    
    public Potential_Risk__c getPotentialRisk(){
        return potentialRiskObj;
    }
    
    public void addBusinessImpact(){
        businessImpactList.add(new Business_Impact__c());
        system.debug('#############'+businessImpactList);
    }
    
    public void addRootCause() {
        rootCauseList.add(new Root_Cause__c());
    }
    
    public void saveRecord()
    {   
        potentialRiskObj.Description__c = 'Testing1';
        insert potentialRiskObj;
        
        objBusinessImpact.Potential_Risk_ID__c = potentialRiskObj.Id;
        objBusinessImpact.Description__c = 'Test BI';
        severity = objBusinessImpact.Severity__c;
        insert objBusinessImpact;
        
        objRootCause.Description__c = 'Test Root Cause1';
        objRootCause.Occurance__c = '3';
        objRootCause.Potential_Risk_ID__c = potentialRiskObj.Id;
        insert objRootCause;
        
        objProcessControl.Potential_Risk_ID__c = potentialRiskObj.Id;
        objProcessControl.Description__c = 'Test Process Control1';
        insert objProcessControl;
        
        objRootCauseControl.Root_Cause_ID__c = objRootCause.Id;
        System.Debug('$$$$$$$$'+objRootCause.Id);
        objRootCauseControl.Process_Control_ID__c = objProcessControl.Id;
        System.Debug('$$$$$$$$'+objProcessControl.Id);
        insert objRootCauseControl;
        
        objBusinessImpactCause.Business_Impact_ID__c = objBusinessImpact.Id;
        objBusinessImpactCause.Root_Cause_ID__c = objRootCause.Id;
        insert objBusinessImpactCause;
        
    }
}