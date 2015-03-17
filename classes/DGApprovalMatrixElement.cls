/****************************************
Author: Abrar
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description: Approval Matrix Item record creation, 
Dynamic picklist population of Field Name field based on Object selected 
and updating Field API Name,Field Data Type fields of Approval Matrix Item objects
****************************************/

public class DGApprovalMatrixElement {

    public Approval_Matrix_element__c AME{get;set;}
    public Id MatId;
    public Id MatrixeleId;
    public Id MatrixId;
    public Map<String, String> NameAPIMap = new Map<String, String>();
    public boolean checkflag = True;
     public List<SelectOption> FieldList{get;
      set;
      }
    public list<Approval_Matrix_Element__c> MatrixItemListToUpsert = new list<Approval_Matrix_Element__c>();
    public list<Approval_Matrix_Element__c> MatrixItemList = new list<Approval_Matrix_Element__c>();
    public set<Id> MatIds = new set<Id>();
    public Map<string,Schema.DisplayType> fieldInfo = new Map<string,Schema.DisplayType>();  
    public Map<string,Schema.SObjectField> FieldMap = new Map<string,Schema.SObjectField>();
      
    /* Constructor to get the current context record*/  
    public DGApprovalMatrixElement(ApexPages.StandardController controller) {
         AME = new Approval_Matrix_element__c();
         MatrixId= ApexPages.CurrentPage().getParameters().get(label.matrix_item_new_button);
         MatrixeleId= ApexPages.CurrentPage().getParameters().get('Id');
         AME.Approval_Matrix__c = MatrixId;
         if(MatrixeleId!=Null){
             AME=[select Field_API_Name__c,Field_Name__c,Match_Type__c,Object__c,Value__c,Value_Max__c,Value_Min__c,Approval_Matrix__c from Approval_Matrix_element__c where Id = :MatrixeleId];
             system.debug('@@@'+AME);
             MatrixId=AME.Approval_Matrix__c;  
             getFieldInfo(); 
                 }
                
    }
      
    /* Method which describes the fields based on objects selected*/
    public void getFieldInfo(){
        String ObjectName = AME.Object__c;
        FieldList = new List<SelectOption>();
        AME.Object__c = ObjectName;
        system.debug('###Object Name###'+ObjectName);
        if(ObjectName != Null){
        FieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();
        for(String ss : FieldMap.keySet()){
             Schema.SObjectField s = FieldMap.get(ss);
             Schema.DescribeFieldResult fieldDes = s.getDescribe();
             fieldInfo.put(fieldDes.getLabel(),fieldDes.getType());
             NameAPIMap.put(fieldDes.getLabel(),ss);
             
             system.debug('Field Name@@'+fieldDes.getLabel());
             system.debug('Field Type@@'+fieldDes.getType());
         }
          system.debug('FieldMap'+FieldInfo.values());
         FieldList.clear(); 
         FieldList.add(new SelectOption('--None--', '--None--'));
         for(String listfield : FieldInfo.Keyset()){
         if(fieldInfo.get(listfield)==Schema.DisplayType.Boolean || fieldInfo.get(listfield)==Schema.DisplayType.Integer || fieldInfo.get(listfield)==Schema.DisplayType.String || fieldInfo.get(listfield)==Schema.DisplayType.Picklist || fieldInfo.get(listfield)==Schema.DisplayType.MultiPicklist || fieldInfo.get(listfield)==Schema.DisplayType.Currency || fieldInfo.get(listfield)==Schema.DisplayType.Double)
            FieldList.add(new SelectOption(listfield, listfield));
            FieldList.sort();
            system.debug('^^^^^'+Schema.DisplayType.Boolean+'--'+fieldInfo.get(listfield));
                     
        } 
        //AME.Field_API_Name__c=NameAPIMap.get(AME.Field_Name__c);
        
      }  
    }
    
   /* Custom Save function of VF Page */
   
    public PageReference save() {
            
                try{
                upsert(AME);
                }
                catch(DMLException ex){
                        ApexPages.addMessages(ex);
                        return null;
                           }
               return new PageReference('/'+MatrixId);
              
               }
       
    

}