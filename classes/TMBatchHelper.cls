/**********************************************************
* Class Name: TMBatchHelper
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: Helper Class for Query String in Batch and
*              Email Notifivation Template for all Batches.  
***********************************************************/

public class TMBatchHelper {
    

    /**
    * @description: Initialiases query string to be used in batch.
    **/
    // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - Start
    /*public static String queryString1 = 'Select Id, Regions__c, RecordTypeId, RAD__c, MDCP_Organization_ID__c, ' +  
                                        'Industry, Confidential_Account__c, World_Region__c, AMID_L2__c, ' + 
                                        'ShippingState, ShippingPostalCode, ShippingCountry, ' + 
                                        'Source_System_Account_ID__c, Named_Account__c, LastAssignmentDate__c, AccountProfileEvaluated__c, ' +
                                        'LastAcountProfAssignmentDate__c, LastIndustryAssignmentDate__c, LastCoverageAssignmentDate__c, ' + 
                                        'Industry_Vertical__c, Coverage_Segmentation__c, EvaluateTerritory__c ' +
                                    'From Account ' +
                                    'Where EvaluateTerritory__c = true AND RecordType.Name = \'Customer\'';

    public static String queryString(){
        TMEngineScheduledFlag__c flag = TMEngineScheduledFlag__c.getInstance('AccountProfFullRun');
        if(flag != null && !flag.SchedularFlag__c){
            queryString1 += ' AND AccountProfileEvaluated__c = false';
        }        
        return queryString1;
    }*/
    public static String queryString {
        set;
        get{
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String currAccountRecordType = obj1.AccountRecordType__c;
            queryString = 'Select Id, Regions__c, RecordTypeId, RAD__c, MDCP_Organization_ID__c, MDCP_Business_Relationship__c, ' +  
                                   'Industry, Confidential_Account__c, World_Region__c, AMID_L2__c, ' + 
                                   'ShippingState, ShippingPostalCode, ShippingCountry, ' + 
                                   'Source_System_Account_ID__c, Named_Account__c, LastAssignmentDate__c, ' + 
                                   'Industry_Vertical__c, Coverage_Segmentation__c, EvaluateTerritory__c,' +
            //sreenath added code for Region value evaluation 2089
            //TM:R4:CR3999:Debmalya:4th Jan,2013:get BA Market Segmentfrom Account
                                   'WorldRegion_Hierarchy__c, BG_Target_Segments__c ' +
                                   'From Account ' +
            //sreenath added code for Region value evaluation 2089
            //                       'Where EvaluateTerritory__c = true AND RecordType.Name = \'' + currAccountRecordType + '\'';
                                   'Where RecordType.Name = \'' + currAccountRecordType + '\''; 
            //sreenath added code for Region value evaluation 2089
            TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
            string Regionvalue = Robj2.AccountRecordType__c;
            system.debug('+++++'+querystring);
            if(null != Robj2 && Robj2.AccountRecordType__c != 'None'){
                querystring = querystring + ' AND WorldRegion_Region__c = \'' + Regionvalue + '\'';
                TMEngineAccountRecordType__c objSR = TMEngineAccountRecordType__c.getValues('Realignment_SubRegion1');
                if(null != objSR && objSR.AccountRecordType__c != '' && objSR.AccountRecordType__c != null){
                    querystring += ' AND WorldRegion_SubRegion1__c = \'' + objSR.AccountRecordType__c + '\'';
                    system.debug('+++++'+querystring);
                }
            }else{
                querystring = querystring + ' AND EvaluateTerritory__c = true '; 
                system.debug('+++++'+querystring);
            } 
             
            TMEngineScheduledFlag__c flag = TMEngineScheduledFlag__c.getInstance('AccountProfFullRun');
            if(flag != null && !flag.SchedularFlag__c){
               queryString += ' AND AccountProfileEvaluated__c = false';
               system.debug('+++++'+querystring);
            }                                    
             system.debug('+++++'+querystring);
             //TM:R6:CR-11429:If Batch is Partner and Hourly, fetch 100 Accounts at a time-Start
             /*TerritoryDeltaChanges__c weekendFlagObj = TerritoryDeltaChanges__c.getInstance('RealignmentProcess');
             Boolean weekendFlag = weekendFlagObj.Territory_Evaluation__c;
             if(currAccountRecordType == 'Partner' && weekendFlag == false && Regionvalue == 'None'){
                queryString += ' LIMIT 100';
             }*/
             //TM:R6:CR-11429:If Batch is Partner fetch 100 Accounts at a time-End
             return queryString;
             
       }
    }
   
                                        
    /**
    * @description: Initialiases query string to be used in batch based on AccountProfile Evaluation flag.
    **/
    /*public static String queryString2 = 'Select Id, Regions__c, RecordTypeId, RAD__c, MDCP_Organization_ID__c, ' +  
                                            'Industry, Confidential_Account__c, World_Region__c, AMID_L2__c, ' + 
                                            'ShippingState, ShippingPostalCode, ShippingCountry, ' + 
                                            'Source_System_Account_ID__c, Named_Account__c, LastAssignmentDate__c, AccountProfileEvaluated__c, ' + 
                                            'LastAcountProfAssignmentDate__c, LastIndustryAssignmentDate__c, LastCoverageAssignmentDate__c, ' + 
                                            'Industry_Vertical__c, Coverage_Segmentation__c, EvaluateTerritory__c ' +
                                        'From Account ' +
                                        'Where EvaluateTerritory__c = true AND RecordType.Name = \'Customer\' AND AccountProfileEvaluated__c = true';*/
    public static String queryString2 {
        set;
        get{
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String currAccountRecordType = obj1.AccountRecordType__c;
            queryString2 = 'Select Id, Regions__c, RecordTypeId, RAD__c, MDCP_Organization_ID__c, ' +  
                                            'Industry, Confidential_Account__c, World_Region__c, AMID_L2__c, ' + 
                                            'ShippingState, ShippingPostalCode, ShippingCountry, ' + 
                                            'Source_System_Account_ID__c, Named_Account__c, LastAssignmentDate__c, AccountProfileEvaluated__c, ' + 
                                            'LastAcountProfAssignmentDate__c, LastIndustryAssignmentDate__c, LastCoverageAssignmentDate__c, ' + 
                                            'Industry_Vertical__c, Coverage_Segmentation__c, EvaluateTerritory__c, ' +
            //sreenath added code for Region value evaluation 2089
            //TM:R4:CR3999:Debmalya:4th Jan,2013:get BA Market Segmentfrom Account
                                   'WorldRegion_Hierarchy__c, BG_Target_Segments__c ' +
                                   'From Account ' +
            //sreenath added code for Region value evaluation 2089
            //                       'Where EvaluateTerritory__c = true AND RecordType.Name = \'' + currAccountRecordType + '\'';
                                   'Where RecordType.Name = \'' + currAccountRecordType + '\' AND AccountProfileEvaluated__c = true'; 
            //sreenath added code for Region value evaluation 2089
             TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
              string Regionvalue = Robj2.AccountRecordType__c;
              if(null != Robj2 && Robj2.AccountRecordType__c != 'None'){
                querystring2 = querystring2 + ' AND WorldRegion_Region__c = \'' + Regionvalue + '\'';
             }                               
             return queryString2;
       }
    }
    
    //TM: Vinay: Req-6201 Apr 9,2013: Location query for Location Rules - Start
    public static String queryString3 {
        set;
        get{
            queryString3 = 'Select Account__c, Annual_Revenue__c, Business_Relationship__c, City__c,'+
                           'Country__c, Demerit_Count__c, DUNS__c, Number_Of_Employees__c,'+
                           'EvaluateTerritory__c, Fax__c, WorldRegion_Hierarchy__c, HP_Lead_Status__c,'+
                           'HP_SFDC_Access__c, Location_Status__c, Location_Name__c,'+ 
                           'MDCP_Organization_ID__c, MDCP_Other_Party_Site_Instance_ID__c, Out_Of_Business__c, Partner_Portal_Eligible__c,'+ 
                           'Phone__c, Primary__c, WorldRegion_Region__c, Sell_Into_Market__c, Sequence__c,'+
                           'Source_System_Account_ID__c, State__c, Street__c, WorldRegion_SubRegion1__c, WorldRegion_SubRegion2__c,'+
                           'WorldRegion_SubRegion3__c, Userkey__c, World_Region1__c, Postal_Code__c, Name,'+
                           'CurrencyIsoCode, Id From Location__c ';
                           
            //Condition to fetch Location records region wise               
            TMEngineAccountRecordType__c region = TMEngineAccountRecordType__c.getValues('Realignment_Region');
            String regionValue = region.AccountRecordType__c;
            
            if(regionValue != null && regionValue != 'None'){
                queryString3 += 'Where WorldRegion_Region__c = \''+regionValue+'\'';
                TMEngineAccountRecordType__c subRegion1 = TMEngineAccountRecordType__c.getValues('Realignment_SubRegion1');
                String subRegion1Value = subRegion1.AccountRecordType__c;
                if(subRegion1Value != null && subRegion1Value != ''){
                    queryString3 += 'AND WorldRegion_SubRegion1__c = \''+subRegion1Value+'\'';
                }
            }else{
                queryString3 += 'Where EvaluateTerritory__c = true';
            }
            //TM:R5:EF02:Vinay
             TerritoryDeltaChanges__c weekendFlagObj = TerritoryDeltaChanges__c.getInstance('RealignmentProcess');
             Boolean weekendFlag = weekendFlagObj.Territory_Evaluation__c;
                
                if(Test.isRunningTest()){
                    queryString3 += ' Limit 5';
                }                
            return queryString3;
        }
    }
    //TM: Vinay: Req-6201 Apr 9,2013: Location query for Location Rules - End
    
    // TM: Debmalya: Req-2091 Aug 28, 2012:Handling Recordtype Partner for Account - End
    // Email Notification Based on Type.                                
    /**
    * @description: Sends Email Notification after batch Completion
    **/
    public static void sendEmailNotification(Database.BatchableContext ctx, String ruleType) {
        
        if (ctx != null) {
            AsyncApexJob apexJob = [SELECT id, ApexClassId,   
                                       JobItemsProcessed, TotalJobItems,   
                                       NumberOfErrors, CreatedBy.Email   
                                    FROM AsyncApexJob   
                                    WHERE id = :ctx.getJobId()];  
            
            //TM:Vinay: Req-6201 Apr 4,2013:Handling Location Rule type - Start
            String emailMessage;
            if(ruleType == 'Location'){
                    emailMessage = Label.NotificationMessage4+' ' + ruleType + ' '+Label.NotificationMessage2+' '  
                        + apexJob.totalJobItems   
                        + ' '+Label.NotificationMessage3; 
            }
            //TM:Vinay: Req-6201 Apr 4,2013:Handling Location Rule type - Start
            else{
                emailMessage = Label.NotificationMessage1+' ' + ruleType + ' '+Label.NotificationMessage2+' '  
                  + apexJob.totalJobItems   
                  + ' '+Label.NotificationMessage3;  
            }
            Messaging.SingleEmailMessage mail =   
                  new Messaging.SingleEmailMessage();  
            String[] toAddresses = new String[] {apexJob.CreatedBy.Email};  
            mail.setToAddresses(toAddresses);  
            mail.setReplyTo('noreply@salesforce.com');  
            mail.setSenderDisplayName(Label.SenderDisplayName);  
            mail.setSubject(Label.Subject);  
            mail.setPlainTextBody(emailMessage);  
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]  
                              { mail });
        }
        
    }                                      
}