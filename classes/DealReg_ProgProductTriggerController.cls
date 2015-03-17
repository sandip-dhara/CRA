/**
 * Class Name: DealReg_ProgProductTriggerController
 * Author: HP
 * Date: 19-Oct-2012 
 * Requirement # Request Id: 3396
 * Description: To validate insertion and updation of ProgramProducts.
 */
public class DealReg_ProgProductTriggerController{
    /*
     * @Description: Method to perform duplicate check on ProgramProducts and to verify the creation of ProgramProduct on BeforeInsert. 
     */  
    public void progProductRecordBeforeInsert(List<Program_Product_Association__c> newProgProdAssociationList){
        List<Id> programIdList = new List<Id>();
        for(Program_Product_Association__c newProgProdAssociation : newProgProdAssociationList) {
            programIdList.add(newProgProdAssociation.program__c);   
        }
        if(programIdList.size() >0){
            checkDuplicateProgProductRecord(programIdList, newProgProdAssociationList);
            checkPartnerProgRecordType(programIdList, newProgProdAssociationList);
        }
    }
    /*
     * @Description: Method to perform duplicate check on ProgramProducts and to verify the creation of ProgramProduct on BeforeUpdate. 
     */
    public void progProductRecordBeforeUpdate(Map<Id,Program_Product_Association__c> newProgProductList, Map<Id,Program_Product_Association__c> oldProgProductList){
        List<Program_Product_Association__c> progProductList = new List<Program_Product_Association__c>();
        List<Id> progProductIdList = new List<Id>();

        for(Id updatedProgProductId:newProgProductList.keyset()){
            if(oldProgProductList.get(updatedProgProductId).Program__c != newProgProductList.get(updatedProgProductId).Program__c || oldProgProductList.get(updatedProgProductId).Product__c != newProgProductList.get(updatedProgProductId).Product__c){
                progProductIdList.add(newProgProductList.get(updatedProgProductId).Program__c);
                progProductList.add(newProgProductList.get(updatedProgProductId));
            }
        }
        if(progProductIdList.size() > 0  && progProductList.size() > 0){
            checkDuplicateProgProductRecord(progProductIdList, progProductList);
            checkPartnerProgRecordType(progProductIdList, progProductList);
        }
    }
    /*
     * @Description: Method to perform duplicate check on ProgramProducts and to verify the creation of ProgramProduct. 
     */
    public void checkDuplicateProgProductRecord(List<Id> programIdsList, List<Program_Product_Association__c> newProgProdAssociationList){
        List<Campaign>  campaignList = new List<Campaign>(); 
        List<Program_Product_Association__c> oldProgProdAssList = new List<Program_Product_Association__c>();
        /* For duplicate check of Product association to the Program */
        oldProgProdAssList = [Select id,program__c, Product__c from Program_Product_Association__c where Program__c IN: programIdsList];
        for(Program_Product_Association__c oldProgProdAss : oldProgProdAssList){
            for(Program_Product_Association__c newProgProdAssociation : newProgProdAssociationList){
                if(newProgProdAssociation.product__c == oldProgProdAss.Product__c && newProgProdAssociation.program__c == oldProgProdAss.Program__c){
                    newProgProdAssociation.addError(Label.R3_PPA_Duplicate_Error);
                }
            }
        }
        /* Cannot add Products to the Program if All product eligibility is yes */
        campaignList = [Select id, All_Products_Eligible__c from campaign  where id IN: programIdsList];
        for(campaign  campaignRec : campaignList){
            for(Program_Product_Association__c newProgProdAssociation: newProgProdAssociationList){
                if(campaignRec.id == newProgProdAssociation.program__c && campaignRec.All_Products_Eligible__c == 'Yes'){
                    newProgProdAssociation.addError(Label.R3_PPA_APE_ErrorMessages);
                } 
            }
        }
        if(campaignList.size()>0)
            campaignList.clear();
        if(oldProgProdAssList.size()>0)
            oldProgProdAssList.clear();
    }
    /*
     * @Description: To verify RecordType -'Partner Program' for Program Product association
     */
    public void checkPartnerProgRecordType(List<Id> programIdsList, List<Program_Product_Association__c> newProgProdAssociationList){
        List<Program_Product_Association__c> recordTypeErrorList = new List<Program_Product_Association__c>();
        Id recordId =RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        if(programIdsList.size()>0){
            List<Campaign> programsRecordTypeList = [select Id,RecordtypeId from Campaign where Id IN: programIdsList];
            if(programsRecordTypeList.size()>0){
                for(Campaign programsRecordType: programsRecordTypeList){
                    if(programsRecordType.recordTypeId != recordId){
                        for(Program_Product_Association__c newProgProdAssociation : newProgProdAssociationList){
                            if(newProgProdAssociation.program__c == programsRecordType.Id){
                                recordTypeErrorList.add(newProgProdAssociation);
                            }
                        }
                    }
                }
            }
            if(programsRecordTypeList.size()>0)
                programsRecordTypeList.clear();
        }   
        for(Program_Product_Association__c recordTypeError: recordTypeErrorList){
            recordTypeError.addError(Label.R3_Program_recordType_PPA);
        }
        if(recordTypeErrorList.size()>0)
            recordTypeErrorList.clear();
    }
}