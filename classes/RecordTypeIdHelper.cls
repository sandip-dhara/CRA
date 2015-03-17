/**********************************************************
* Class Name: RecordTypeIdHelper
* Author: HP
* Date: 04-Apr-2012 
* Requirement # Request Id:
* Last modified date: 25-Jan-2013
* Description: Used By Classes for Getting RecordType ID.(modified the old with new code - new code uses schema methods instead of SOQL to get the recordtype id)
***********************************************************/
public with sharing class RecordTypeIdHelper{
    /**
    * @description: return record type id throws an exception if SobjectApiName or recTypeName is not valid
    * @param: object api name, record type name
    * @return: Record Type id
    */
    public static Id getRecordTypeId(String SobjectApiName, String recTypeName)
    {
    
        Map<String, Schema.SObjectType> completeobjMap  = Schema.getGlobalDescribe() ;
        Schema.SObjectType selectedSobjType = completeobjMap.get(SobjectApiName) ;
        if(selectedSobjType<>NULL){
            Schema.DescribeSObjectResult sObjResult = selectedSobjType.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> RecordTypeInfo = sObjResult.getRecordTypeInfosByName();
            if(RecordTypeInfo.containsKey(recTypeName)){
                Id recordTypeID = RecordTypeInfo.get(recTypeName).getRecordTypeId();
                return recordTypeID;
            }else{
                throw new getRecordTypeException('\'' + recTypeName + '\'' + ' is not a valid record type name of ' + '\'' + SobjectApiName + '\'' + '.');
            }
        }else{
            throw new getRecordTypeException('\'' + SobjectApiName + '\'' + ' is not a valid object api name or does not have any record type.');
        }
    }

	
    /**
    * @description: return record type id throws an exception if SobjectApiName or recTypeId is not valid
    * @param: object api name, record type name
    * @return: Record Type id
    */
    public static String getRecordTypeName(String SobjectApiName, String recTypeId)
    {
    
        Map<String, Schema.SObjectType> completeobjMap  = Schema.getGlobalDescribe() ;
        Schema.SObjectType selectedSobjType = completeobjMap.get(SobjectApiName) ;
        if(selectedSobjType<>NULL){
            Schema.DescribeSObjectResult sObjResult = selectedSobjType.getDescribe() ;
            Map<Id,Schema.RecordTypeInfo> RecordTypeInfo = sObjResult.getRecordTypeInfosByID();
            if(RecordTypeInfo.containsKey(recTypeId)){
                String recordTypeName = RecordTypeInfo.get(recTypeId).getName();
                return recordTypeName;
            }else{
                throw new getRecordTypeException('\'' + recTypeId + '\'' + ' is not a valid record type name of ' + '\'' + SobjectApiName + '\'' + '.');
            }
        }else{
            throw new getRecordTypeException('\'' + SobjectApiName + '\'' + ' is not a valid object api name or does not have any record type.');
        }
    }	
    public class getRecordTypeException extends Exception{}
}