/**
 * Class Name: DealReg_DuplicatePartnerAssoCheck
 * Author: HP
 * Date: 17-Oct-2012 
 * Requirement # Request Id: 3396
 * Description: Eliminate duplicate association of Partner to Program(Campaign)
 */
public class DealReg_DuplicatePartnerAssoCheck{
    public void sampleMethod(){}
    /*
     * @Description: Method to verify Duplicate records and Recordtype on Before Insert of Partner Program.  
     */  
     /*
    public void progPartnerRecordBeforeInsert(List<Program_Partner_Association__c> progPartAssociationList){
        List<Id> programIdList = new List<Id>();
        for(Program_Partner_Association__c newProgPartAssociation : progPartAssociationList) {
            programIdList.add(newProgPartAssociation.program__c);   
        }
        if(programIdList.size() >0){
            checkDuplicateProgPartnerRecord(programIdList, progPartAssociationList);
            checkPartnerProgRecordType(programIdList, progPartAssociationList);
        }
    }
    */
    /*
     * @Description: Method to verify Duplicate records and Recordtype on BeforeUpdate of Partner Program.   
     */
     /*
    public void progPartnerRecordBeforeUpdate(Map<Id,Program_Partner_Association__c> newProgPartnerList, Map<Id,Program_Partner_Association__c> oldProgPartnerList){
        List<Program_Partner_Association__c> progPartnerList = new List<Program_Partner_Association__c>();
        List<Id> progPartnerIdList = new List<Id>();

        for(Id updatedProgPartnerId:newProgPartnerList.keyset()){
            if(oldProgPartnerList.get(updatedProgPartnerId).Program__c != newProgPartnerList.get(updatedProgPartnerId).Program__c || oldProgPartnerList.get(updatedProgPartnerId).Partner__c != newProgPartnerList.get(updatedProgPartnerId).Partner__c){
                progPartnerIdList.add(newProgPartnerList.get(updatedProgPartnerId).Program__c);
                progPartnerList.add(newProgPartnerList.get(updatedProgPartnerId));
            }
        }
        if(progPartnerIdList.size() > 0  && progPartnerList.size() > 0){
            checkDuplicateProgPartnerRecord(progPartnerIdList, progPartnerList);
            checkPartnerProgRecordType(progPartnerIdList, progPartnerList);
        }
    }
    */
    /*
     * @Description: Method to perform duplicate check on ProgramPartner and to verify the creation of ProgramPartner. 
     */
     /*
    public void checkDuplicateProgPartnerRecord(List<Id> programIdList, List<Program_Partner_Association__c> newProgPartAssociationList){
        //List<Campaign>  campaignList = new List<Campaign>(); 
        List<Program_Partner_Association__c> oldProgPartAssList = new List<Program_Partner_Association__c>();
        // For duplicate check of Partner association to the Program 
        oldProgPartAssList = [Select id,program__c, Partner__c from Program_Partner_Association__c where Program__c IN: programIdList];
        for(Program_Partner_Association__c oldProgPartAss : oldProgPartAssList){
            for(Program_Partner_Association__c newProgPartAssociation : newProgPartAssociationList){
                if(newProgPartAssociation.Partner__c == oldProgPartAss.Partner__c && newProgPartAssociation.program__c == oldProgPartAss.Program__c){
                    newProgPartAssociation.addError(Label.R3_PartnerProduct_Duplicate);
                }
            }
        }

        if(oldProgPartAssList.size()>0)
            oldProgPartAssList.clear();
    }*/
    /*
     * @Description: To verify RecordType -'Partner Program' for Program Partner association
     */
     /*
    public void checkPartnerProgRecordType(List<Id> programIdsList, List<Program_Partner_Association__c> newProgPartnerAssociationList){
        List<Program_Partner_Association__c> recordTypeErrorList = new List<Program_Partner_Association__c>();
        Id recordId =RecordTypeIdHelper.getRecordTypeId('Campaign','Partner Program');
        if(programIdsList.size()>0){
            List<Campaign> programsRecordTypeList = [select Id,RecordtypeId from Campaign where Id IN: programIdsList];
            if(programsRecordTypeList.size()>0){
                for(Campaign programsRecordType: programsRecordTypeList){
                    if(programsRecordType.recordTypeId != recordId){
                        for(Program_Partner_Association__c newProgPartAssociation : newProgPartnerAssociationList){
                            if(newProgPartAssociation.program__c == programsRecordType.Id){
                                recordTypeErrorList.add(newProgPartAssociation);
                            }
                        }
                    }
                }
            }
            if(programsRecordTypeList.size()>0)
                programsRecordTypeList.clear();
        }   
        for(Program_Partner_Association__c recordTypeError: recordTypeErrorList){
            recordTypeError.addError(Label.R3_Program_recordType_PPA);
        }
        if(recordTypeErrorList.size()>0)
            recordTypeErrorList.clear();
    }*/
}