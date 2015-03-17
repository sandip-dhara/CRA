/**********************************************************
* Class Name: ProductSpecialityUserBatch
* Author: Debmalya (HP)
* Description: This batch inserts queries the Sales Territory Account Assignment Records and send set of associated  
* Opportunities to SpecialityOpportunityMatchesBatch to create Speciality Opportunity Match records.
***********************************************************/

global class ProductSpecialityUserBatch implements Database.batchable<sObject> ,  Database.Stateful{
    
    global String accounttoprocess = 'Select Id, Account__c from Sales_Territory_Account_Assignment__c where Sales_Territory__r.Related_User_Speciality_Updation__c = true and Sales_Territory__r.IsActive__c= true';
    global Set<Id> oppIdForAllAccs = new Set<Id>();
     // TM: R4 EF CR-0595: Nasir Jawed : Start: Variable added to get the current date and time when the batch starts.
    global Datetime currentTimeSpecialty = system.Now();
    global String formatedDtSpecialty = currentTimeSpecialty.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    // TM: R4 EF CR-0595: Nasir Jawed : End
    
    /**
    * @description: Queries accounts in Sales_Territory_Account_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/
    global Database.queryLocator start(Database.BatchableContext ctx){
        
        if ( Test.isRunningTest() ) accounttoprocess += ' limit 30';
        return Database.getQueryLocator(accounttoprocess);
    }
    
     /**
    * @description: Execute method for finding Opportunities associated with the set of accounts retrieved from Sales Territory
    *               Account assignments.This would be passed on to the next batch to be processed. 
    * @param: Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accnttoProcessList){
        
        try{
            Set<Id> accIdSet = new Set<Id>();
            for(Sales_Territory_Account_Assignment__c stacc : accnttoProcessList){
                accIdSet.add(stacc.Account__c);
            }
        
            
            for(Opportunity opprec : [Select Id, AccountId from Opportunity where AccountId IN : accIdSet]){
                oppIdForAllAccs.add(opprec.Id);
            }
             // TM:Nasir Jawed: R4: Req:3908 start   
                 
            
            for(Channel_Partner__c cp: [Select id,Channel_Partner__c,Opportunity__c from Channel_Partner__c where Channel_Partner__c IN:accIdSet]){
             
                if(cp!=null){
                    oppIdForAllAccs.add(cp.Opportunity__c);                     
                    system.debug('nasir6:'+oppIdForAllAccs)  ;                    
                }           
            }
                     
        // TM:Nasir Jawed: End
            
        }catch (Exception e){
            system.debug('*****Exception in ProductSpecialityUserBatch****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching Geo rules 
    * @param: Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accountToProcessList - accounts list to process
    **/      
    global void finish(Database.BatchableContext ctx){
        // TM: R4 EF CR-0595: Nasir Jawed : Start: Variable added to get the current date and time when the batch starts.
     // Passed the parameter "formatedDtSpecialty " to the batch "ProdSplOppMatchesBatch".
        Id batchEvalTerr = Database.executeBatch(new ProdSplOppMatchesBatch(oppIdForAllAccs,formatedDtSpecialty ),150);
     // TM: R4 EF CR-0595: Nasir Jawed : End   
        //batchEvalTerr = Database.executeBatch(new ProdSplOppMatchesBatch(oppIdForAllAccs),150);
    }
}