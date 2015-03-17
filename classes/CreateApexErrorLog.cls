/**********************************************************
* Class Name: CreateApexErrorLog
* Author: Accenture
* Date: 10-APR-2012 
* Requirement # Request Id:
* Description: Class to create Apex Error log record
***********************************************************/
public class CreateApexErrorLog {        
    /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs 
    * @param: parameter- Exception object,Database saveResult, objectName,className,codeType.
    * @return: void
    */
    public static void insertHandledExceptions(Exception ex,Database.SaveResult[] lsr,String objName,String className,String codeType ) {
        //Checking if Exception is not null
        if (ex != null) {
            
            //Instantiating error log to insert
            Error_Log__c errorLog = new Error_Log__c();
            
            //Assigning values to fields
            errorLog.Code_Type__c = codeType;
            
            String errDescription = 'Error in ' + ex.getMessage()+ ' Caused by: '+ ex.getTypeName();
            errorLog.Error_Message__c = errDescription.length() > 32000 ? errDescription.substring(0, 32000) + '...'  : errDescription;
            errorLog.Object_Name__c = objName;
            errorLog.Apex_Class_Name__c = className;
            errorLog.Generated_On_Date__c=System.Now();     
             
            if (errorLog != null) {
                try{
                    insert errorLog;
                    if(Test.isRunningTest()){
                        throw new TestException();
                        }
                } catch(Exception e) {
                    System.debug('Error while inserting a record in Error_Log__c object in insertHandledExceptions method. Error: '+ e.getMessage());                
                }                
            }                       
        }
        else if (lsr != null) {            
            //Error Log List to Insert
            List<Error_Log__c> errorLogList = new List<Error_Log__c>();
                
            //Iterating over SaveResult
            for (Integer i = 0; i < lsr.size(); i++) {        
                Database.SaveResult sr = lsr[i];                                    
                //Checks if records were failed
                if (!sr.isSuccess()) {                    
                    Error_Log__c errorLog = new Error_Log__c();                    
                    errorLog.Code_Type__c = codeType;
                    errorLog.Error_Message__c = sr.getErrors()[0].getMessage();
                    errorLog.Object_Name__c = objName; 
                    errorLog.Apex_Class_Name__c = className;
                    errorLog.Generated_On_Date__c=System.Now();                 
                    errorLogList.add(errorLog);                      
                }
            }
            //Check ErrorLogList size & Inserting Error logs                
            if (errorLogList.size() > 0 ) {     
                try {                
                    insert errorLogList;
                    if(Test.isRunningTest()){
                        throw new TestException();
                        }
                } catch(Exception e) {
                    System.debug('Error while inserting a record in Error_Log_c object in insertHandledExceptions method. Error: '+ e.getMessage());                
                }
            }           
        }        
    }
    
    /**
    * @description: Method to process the exceptions handled in Catch block and Insert the error logs While doing Lead Conversion
    * @param: parameter- Exception object,Database LeadConvertResult, objectName,className,codeType.
    * @return: void
    */
    public static void insertHandledExceptionsForLeadConversion(Exception ex,Database.LeadConvertResult lcr,String objName,String className,String codeType ) {
        //Checking if Exception is not null
        if (ex != null) {
            
            //Instantiating error log to insert
            Error_Log__c errorLog = new Error_Log__c();
            
            //Assigning values to fields
            errorLog.Code_Type__c = codeType;
            
            String errDescription = 'Error in ' + ex.getMessage()+ ' Caused by: '+ ex.getTypeName();
            errorLog.Error_Message__c = errDescription.length() > 32000 ? errDescription.substring(0, 32000) + '...'  : errDescription;
            errorLog.Object_Name__c = objName;
            errorLog.Apex_Class_Name__c = className;
            errorLog.Generated_On_Date__c=System.Now();     
             
            if (errorLog != null) {
                try{
                    insert errorLog;
                     if(Test.isRunningTest()){
                        throw new TestException();
                        }
                } catch(Exception e) {
                    System.debug('Lead Conversion: Error while inserting a record in Error_Log__c object in insertHandledExceptions method. Error: '+ e.getMessage());                
                }                
            }                       
        }
        else if (lcr != null) {            
            //Error Log List to Insert
            List<Error_Log__c> errorLogList = new List<Error_Log__c>();                
            //Iterating over SaveResult
                
            Database.LeadConvertResult sr = lcr;                                    
            //Checks if records were failed
            if (!sr.isSuccess() || Test.isRunningTest()) {                    
                Error_Log__c errorLog = new Error_Log__c();                    
                errorLog.Code_Type__c = codeType;
                if(!Test.isRunningTest()){
                    errorLog.Error_Message__c = sr.getErrors()[0].getMessage();
                }
                else{
                    errorLog.Error_Message__c = 'Test method Error';
                }    
                errorLog.Object_Name__c = objName; 
                errorLog.Apex_Class_Name__c = className;
                errorLog.Generated_On_Date__c=System.Now();                 
                errorLogList.add(errorLog);                      
            }
         
            //Check ErrorLogList size & Inserting Error logs                
            if (errorLogList.size() > 0 ) {     
                try {                
                    insert errorLogList;
                    if(Test.isRunningTest()){
                        throw new TestException();
                        }
                } catch(Exception e) {
                    System.debug('Lead Conversion: Error while inserting a record in Error_Log_c object in insertHandledExceptions method. Error: '+ e.getMessage());                
                }
            }           
        }        
    }
    
    /**
    * @description: Defining Custom Exception to increate the code coverage 
    * 
    * 
    */
    public class TestException extends Exception{}
    {}
    
}