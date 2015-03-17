/**
  * @author: Sreenath (HP)
  * HP Release 5
  * This Class drives the logic for processing batch operation for Unlinking opportunities of Specialty for the user. when user removed from Specialty User Assignment
  * Date: 04-04-2013
  * Requirement : CR-5909
  */
global class ProdSpecialtyOpptyDelBatch implements Database.batchable<sObject> ,  Database.Stateful{
    //TM: NAsir JAwed: R6: EF-Defect-ALM:14457. For user whose source is updated to "Iformative", SOM should be deleted for that user.Start  .
    public String SpecialtyOpptyList = 'Select p.Product_Specialty_User_Assignment__c, p.Id From Product_Specialty_Oppty_Assignment__c p '
                                        + 'Where (p.Product_Specialty_User_Assignment__r.To_be_deleted__c = TRUE OR p.Product_Specialty_User_Assignment__r.Source__c=\'Informative\') ';
    //TM: NAsir JAwed: R6-EF:Defect-ALM:14457. End
    global Datetime currentTime = system.Now();
    global String formatedDt = currentTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    

    global Database.queryLocator start(Database.BatchableContext ctx){           
 
        if ( Test.isRunningTest() ){             
                 SpecialtyOpptyList += ' Limit 10';           
        }        
        return Database.getQueryLocator(SpecialtyOpptyList);   
    }
 
 global void execute(Database.BatchableContext ctx, List<Product_Specialty_Oppty_Assignment__c > ProdSpecOpptylist){
 
       List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOpptyListToDel = new List<Product_Specialty_Oppty_Assignment__c>();
       Set<ID>  prodSpcltyUserListToDel = new Set<ID>();

        //deleting related opportunities for the user, to be deleted flag at SPUA object as checked to delete user & user related opportunities
        for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpptyObj : ProdSpecOpptylist)
        {
            prodSpcltyOpptyListToDel.add(prodSpcltyOpptyObj);
            //prodSpcltyUserListToDel.add(prodSpcltyOpptyObj.Product_Specialty_User_Assignment__c);
        }
        
        if(null != prodSpcltyOpptyListToDel && prodSpcltyOpptyListToDel.size() > 0){
            try{
                delete prodSpcltyOpptyListToDel;
            }catch(Exception excp){
                system.debug('Exception found while deleting records for Opportunity Product Specialty Assignment on Deleting Product Specialty User Asgnmnt Record '+excp.getMessage());
            }
        }        
 }
 global void finish(Database.BatchableContext ctx){

        String TerrListvalues = 'select id from Product_Specialty_User_Assignment__c where To_be_deleted__c = true'+ ' AND '+ 'LastModifiedDate <'+ formatedDt ;
        String param = 'delete'; 
        Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(TerrListvalues,param),150); 
                        
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