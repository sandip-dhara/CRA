/****************************************
Author: Abrar
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description: Approval Matrix record creation
****************************************/
public class DGApprovalMatrixCreationController {
   
    public Approval_Matrix__c am {get;set;}
     public Id MatrixId;
    public DGApprovalMatrixCreationController(ApexPages.StandardController controller) {
        am = new Approval_Matrix__c();
        MatrixId= ApexPages.CurrentPage().getParameters().get('Id');
        if(MatrixId != Null)
        {
         am = [SELECT Account_Region__c,Approval_Flow_Type__c,Approval_Type__c,Active__c,Approver_Level_1__c,Approver_Level_2__c,
             Approver_Level_3__c,Approver_Level_4__c,Approver_Level_5__c,Approver_Level_6__c,Approver_Level_7__c,Approver_Level_8__c,
             Approver_Level_9__c,Approver_Level_10__c,Approver_Level_11__c,Approver_Level_12__c,Approver_Level_13__c,Approver_Level_14__c,
             Approver_Level_15__c,Approver_Level_16__c,Approver_Level_17__c,Approver_Level_18__c,
             Approver_Level_19__c,Approver_Level_20__c,Approver_Level_Type_1__c,Approver_Level_Type_2__c,Approver_Level_Type_3__c,
             Approver_Level_Type_4__c,Approver_Level_Type_5__c,Approver_Level_Type_6__c,Approver_Level_Type_7__c,Approver_Level_Type_8__c,
             Approver_Level_Type_9__c,Approver_Level_Type_10__c,Approver_Level_Type_11__c,
             Approver_Level_Type_12__c,Approver_Level_Type_13__c,Approver_Level_Type_14__c,Approver_Level_Type_15__c,Approver_Level_Type_16__c,
             Approver_Level_Type_17__c,Approver_Level_Type_18__c,Approver_Level_Type_19__c,Approver_Level_Type_20__c,
             Id,Name,OwnerId,Owner_BG__c,Weight__c,Approval_Matrix_Name__c FROM Approval_Matrix__c
             where Id = :MatrixId];
            }
          }
          
    /* Custom Save function of VF Page */     
    public PageReference save() {
                Database.saveResult result;
                try{
                if(MatrixId!=Null)
                upsert(am);
                else{
                result = Database.Insert(am);
                    }
                }
                catch(DMLException ex){
                        ApexPages.addMessages(ex);
                        return null;
                           }
               if(MatrixId!=Null)
               return new PageReference('/'+MatrixId);
               else
               return new PageReference('/'+result.getId());
               //return null;
              
               }
               
      
}