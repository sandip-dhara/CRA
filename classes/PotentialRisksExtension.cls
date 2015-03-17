public with sharing class PotentialRisksExtension {

    public Potential_Risk__c objPotentialRisk{get;set;}
    public List<Potential_Risk__c> potentialRiskList{get;set;}

    public PotentialRisksExtension(ApexPages.StandardController controller) {
        objPotentialRisk = (Potential_Risk__c)controller.getRecord();
        if(objPotentialRisk.Id != null)
        {
            objPotentialRisk = [select Id,Name,Description__c,Project_ID__c from Potential_Risk__c where Project_ID__c = 'a6yZ0000000DFz2'];
            //potentialRiskList = [Select Id,Name,Description__c from Potential_Risk__c where Project_ID__c = 'a6yZ0000000DFz2'];
        }

    }

}