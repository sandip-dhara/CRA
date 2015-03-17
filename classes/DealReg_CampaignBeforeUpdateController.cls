/**
* Class Name: DealRegCampaignBeforeUpdateController
* Author: HP
* Date: 18-Oct-2012 
* Requirement # Request Id:3396 
* Description: To check if there are Program product Association records, if exists should not allow to change the All product eligible to true
*/
Public class DealReg_CampaignBeforeUpdateController{
    public void checkAllProductElligibleField(List<Campaign> campaignRecordsList){
        List<Id> programIdsList= new List<Id>() ;
        List<Campaign> campErrorList = new List<Campaign>();
        List<Program_Product_Association__c>  associationList = new List<Program_Product_Association__c>();
        Id recordId=RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        /*Getting Program ID of new Record*/
        for(Campaign campObj : campaignRecordsList){
            if(campObj.All_Products_Eligible__c =='Yes' && campObj.RecordTypeId==recordId){
                campErrorList.add(campObj);
                programIdsList.add(campObj.id );
            }
        }
        /* Querying the existing records of program product association */
        associationList= [Select program__c  from Program_Product_Association__c where Program__c in: programIdsList Limit 10];
        /* Checking if the new record is duplicate of existing program product association */
        for(Program_Product_Association__c progProd: associationList) 
        {      
            for(Campaign campError: campErrorList)
            { 
                if(campError.id == progProd.program__c)
                    campError.All_Products_Eligible__c.addError(Label.R3_PartnerProgram_APE);
            }
        }
        /* clearing all the Lists used in the class*/
        if(programIdsList.size()>0)
            programIdsList.clear();
        if(associationList.size()>0)
            associationList.clear();
        if(campErrorList.size()>0)
            campErrorList.clear();
    }
}