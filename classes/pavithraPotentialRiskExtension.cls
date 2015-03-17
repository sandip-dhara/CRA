public with sharing class pavithraPotentialRiskExtension {
    public Potential_Risk__c objPotentialRisk{get;set;}
    public string description{get;set;}
    public string severity{get;set;}
    public Business_Impact__c objBusinessImpact{get;set;}
    //Public List<Potential_Risk__c> potentialRiskList{get;set;}
    //Public List<Business_Impact__c> businessImpactList{get;set;}

    public pavithraPotentialRiskExtension() {
        objPotentialRisk = new Potential_Risk__c();
        objBusinessImpact = new Business_Impact__c();
        //potentialRiskList = new List<Potential_Risk__c>();
        //businessImpactList = new List<Business_Impact__c>();
       // potentialRiskList = [select Id,Description__c,Owner_Team_Member_ID__c,Project_ID__c from Potential_Risk__c where Id=:objPotentialRisk.Id];
       // businessImpactList = [select Id,Potential_Risk_ID__c,Description__c,Severity__c from Business_Impact__c where Potential_Risk_ID__c=:objPotentialRisk.Id];
        

    }
    public void saveRecord() {
        insert objPotentialRisk;
        objBusinessImpact.Potential_Risk_ID__c = objPotentialRisk.Id;
        description = objBusinessImpact.Description__c;
        severity = objBusinessImpact.Severity__c;
        insert objBusinessImpact;
        /*for(Business_Impact__c c: businessImpactList){
                c.Potential_Risk_ID__c = objPotentialRisk.Id;
                c.Description__c = objBusinessImpact.Description__c;
                //description = objBusinessImpact.Description__c;
                insert businessImpactList;
        }*/
        
    }

    

}