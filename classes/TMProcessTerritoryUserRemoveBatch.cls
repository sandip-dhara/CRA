/**
  * @author: Sreenath (HP)
  * HP Release 6 EF
  * This Class drives the logic for processing batch operation for Territory user inactivation & specialty User tobedelete flag checking. when user inactivated profile level
  * Date: 03-10-2013
  * Requirement : CR-17012
  */
global class TMProcessTerritoryUserRemoveBatch implements Database.batchable<sObject> ,  Database.Stateful{

    Set<ID>  terrInactiveUsersDelSOM = new Set<ID>();
    public String salesTerrActiveUserList;
    
    global Database.queryLocator start(Database.BatchableContext ctx){           
    TMEngineAccountRecordType__c lastRun = TMEngineAccountRecordType__c.getValues('InactiveTerrUserTimeStamp');
    
    if(lastRun.AccountRecordType__c != null){
        DateTime stDate = DateTime.valueOf(lastRun.AccountRecordType__c);
        salesTerrActiveUserList = 'Select id,User__c,Add_to_Account_Team__c,isActive__c,User__r.IsActive FROM sales_Territory_User_Assignment__c WHERE user__r.IsActive = false AND isActive__c = true And user__r.LastModifiedDate >= :stDate';
        DateTime newTimeStamp = datetime.now();
        lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
        update lastRun;
    }else{
        salesTerrActiveUserList = 'Select id,User__c,Add_to_Account_Team__c,isActive__c,User__r.IsActive FROM sales_Territory_User_Assignment__c WHERE user__r.IsActive = false AND isActive__c = true';
        DateTime newTimeStamp = datetime.now();
        lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
        update lastRun;
    }
        if ( Test.isRunningTest() ){             
                 salesTerrActiveUserList += ' Limit 10';           
        }        
        return Database.getQueryLocator(salesTerrActiveUserList);   
    }
 
 global void execute(Database.BatchableContext ctx, List<sales_Territory_User_Assignment__c > salesTerrActiveUserList){
 
       List<sales_Territory_User_Assignment__c> salesTerrUserToInactive = new List<sales_Territory_User_Assignment__c>();               

        for(sales_Territory_User_Assignment__c terrUserObj : salesTerrActiveUserList)
        {             
            terrInactiveUsersDelSOM.add(terrUserObj.user__c);
            terrUserObj.Add_To_Account_team__c = false;
            terrUserObj.isActive__c = false;
            salesTerrUserToInactive.add(terrUserObj);                                  
        }
        List<GroupMember> grpmember = database.query('Select id,UserOrGroupID,GroupID From GroupMember where UserOrGroupID IN : terrInactiveUsersDelSOM ');
        if(grpmember.size()>0){
            Delete grpmember;            
        }
        
        if(null != salesTerrUserToInactive && salesTerrUserToInactive.size() > 0 && grpmember.size()==0){
            try{
                update salesTerrUserToInactive;
            }catch(Exception excp){
                system.debug('Exception found while updating records for Sales Territory User inactivation '+excp.getMessage());
            }
        }       
 }
 global void finish(Database.BatchableContext ctx){
    
        List<Product_Specialty_User_Assignment__c> PSUAupdate = new List<Product_Specialty_User_Assignment__c>();    
        if(terrInactiveUsersDelSOM.size() > 0){
            List<Product_Specialty_User_Assignment__c> PSUA = Database.Query('Select id,User__c,To_Be_Deleted__c,User__r.IsActive FROM Product_Specialty_User_Assignment__c WHERE user__c IN : terrInactiveUsersDelSOM' );            
            for(Product_Specialty_User_Assignment__c specUserDel : PSUA){
                specUserDel.To_Be_Deleted__c = true;
                PSUAupdate.add(specUserDel);
            }
        }
        if(null != PSUAupdate && PSUAupdate.size() > 0){
            try{
                update PSUAupdate;
            }catch(Exception excp){
                system.debug('Exception found while updating records for Specialty User '+excp.getMessage());
            }
        }
        
                        
  //Mail notification...
 AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                        WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'ProdSpecialtyOpptyDelBatch' + ' has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
        
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
         
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setReplyTo('noreply@salesforce.com');  
        mail.setSenderDisplayName('Batch Job Summary');  
        mail.setSubject('Batch Job Completed - Specialty Scheduled Batch'); 
        mail.setPlainTextBody(emailMessage);  
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail }); 
 
 }
}