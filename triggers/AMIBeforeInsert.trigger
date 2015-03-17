/****************************************
Author: Abrar
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description: updating Field API Name, 
Field Data Type fields of Approval Matrix Item objects
****************************************/
trigger AMIBeforeInsert on Approval_Matrix_Element__c (before insert, before update) {

    public Map<string,Schema.SObjectField> FieldMap = new Map<string,Schema.SObjectField>();
    public Map<String, String> NameApiList = new Map<String, String>();
    public Map<string,Schema.DisplayType> fieldInfo = new Map<string,Schema.DisplayType>(); 
    public list<approval_matrix_element__c> matlist = new list<approval_matrix_element__c>(); 
    for(approval_matrix_element__c app: trigger.new){
     app.object_name_field_name__c = app.Approval_Matrix__c+'-'+app.Object__c+'-'+app.Field_Name__c;
     FieldMap = Schema.getGlobalDescribe().get(app.Object__c).getDescribe().fields.getMap();
     for(String ss : FieldMap.keySet()){
             Schema.SObjectField s = FieldMap.get(ss);
             Schema.DescribeFieldResult fieldDes = s.getDescribe();
             NameApiList.put(fieldDes.getLabel(),ss);
             fieldInfo.put(fieldDes.getLabel(),fieldDes.getType());
                }
      
             app.Field_Api_Name__c = NameApiList.get(app.Field_Name__c);
             System.debug('!!!!!@@@Field Info Map-'+ fieldInfo.get(app.Field_Name__c).name());
             app.field_data_type__c = fieldInfo.get(app.Field_Name__c).name();
             system.debug('@@@@FieldAPIName-'+app.Field_Name__c);   
             system.debug('@@@@FieldAPIName-'+app.Field_Api_Name__c);
             system.debug('@@@@FieldData Type-'+app.field_data_type__c );
             matlist.add(app);
               }
              }