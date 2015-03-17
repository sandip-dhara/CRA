/**********************************************************
* Class Name: ProdSplOppMatchesBatch
* Author: Debmalya (HP)
* Description: This batch inserts Speciality Opportunity match records when a new Speciality User Assignment records gets
* created.
***********************************************************/

global class ProdSplOppMatchesBatch implements Database.batchable<sObject> ,  Database.Stateful{
    
    global String prodspltoprocess = 'Select p.Product_Specialty_User_Assignment__r.Product_Specialty__c, p.Product_Specialty_User_Assignment__c,'+
                                     'p.Opportunity__c, p.Id From Product_Specialty_Oppty_Assignment__c p '+
                                     'Where p.Product_Specialty_User_Assignment__r.Product_Specialty__c IN : prodSpcltySet '+
                                     'AND p.Opportunity__c IN : oppIdForAllAccs';
    // TM: R4 EF CR-0595: Nasir Jawed : Start:                                 
    global String formatedDtSpecialty;
    // TM: R4 EF CR-0595: Nasir Jawed : End:
    global Set<Id> oppIdForAllAccs = new Set<Id>();
    global Set<Id> prodSpcltySet = new Set<Id>();
    global Map<Id,Id> prodSpcltyUserIdProdSpcltyIdMap = new Map<Id,Id>();
    global Map<Id,Id> productSpcltyUserIdMap = new Map<Id,Id>();
    
    //global ProdSplOppMatchesBatch(Set<Id> oppIdSet){
// TM: R4 EF CR-0595: Nasir Jawed : Start:
    global ProdSplOppMatchesBatch(Set<Id> oppIdSet,String CurrentDt){
        formatedDtSpecialty=CurrentDt;    
// TM: R4 EF CR-0595: Nasir Jawed : Start:
        oppIdForAllAccs = oppIdSet;
        for(Product_Specialty_User_Assignment__c psuarec : [Select Id, Product_Specialty__c, User__c from Product_Specialty_User_Assignment__c where New_Or_Updated__c = true]){
            prodSpcltySet.add(psuarec.Product_Specialty__c);
            prodSpcltyUserIdProdSpcltyIdMap.put(psuarec.Product_Specialty__c,psuarec.Id);
            productSpcltyUserIdMap.put(psuarec.Id,psuarec.User__c);
        }
    }
    
     /**
    * @description: Queries accounts in Product_Specialty_Oppty_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/
    global Database.queryLocator start(Database.BatchableContext ctx){
        
        system.debug(prodspltoprocess);
        if ( Test.isRunningTest() ) prodspltoprocess += ' limit 30';
        return Database.getQueryLocator(prodspltoprocess);
    }
    
    /**
    * @description: Execute method for finding matching Specialty Opportunity Match records and inserting them 
    * @param: Database.BatchableContext ctx, List<Product_Specialty_Oppty_Assignment__c> prodspltoprocess
    **/
    global void execute(Database.BatchableContext ctx, List<Product_Specialty_Oppty_Assignment__c> prodspltoprocess){
        
        try{
            Set<Id> uniqueOppSet = new Set<Id>();
            Map<Id,Set<Id>> prodSpcltyOppMap = new Map<Id,Set<Id>>();
            for(Product_Specialty_Oppty_Assignment__c prodSpcltyOpty : prodspltoprocess){
                uniqueOppSet.add(prodSpcltyOpty.Opportunity__c);
                Set<Id> oppSet = prodSpcltyOppMap.get(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c);
                if(null == oppSet){
                    oppSet = new Set<Id>();
                }                           
                oppSet.add(prodSpcltyOpty.Opportunity__c);
                prodSpcltyOppMap.put(prodSpcltyOpty.Product_Specialty_User_Assignment__r.Product_Specialty__c,oppSet);   
            }
            
            Map<Id,Set<Id>> oppTerrUsermap = OppAccntTerrUser.callFetchAccntUserLogic(uniqueOppSet, 'Opportunity');
            List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOppltList = new List<Product_Specialty_Oppty_Assignment__c>();
            
            for(Id prodSpcltyId : prodSpcltyOppMap.keySet()){
                for(Id oppId : prodSpcltyOppMap.get(prodSpcltyId)){
                    if(oppTerrUsermap != null && oppTerrUsermap.get(oppId) != null && oppTerrUsermap.get(oppId).contains(productSpcltyUserIdMap.get(prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId)))){
                        Product_Specialty_Oppty_Assignment__c newObject = new Product_Specialty_Oppty_Assignment__c(Product_Specialty_User_Assignment__c  
                                                                                    = prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId), Opportunity__c = oppId,
                                                                                        OwnerId = productSpcltyUserIdMap.get(prodSpcltyUserIdProdSpcltyIdMap.get(prodSpcltyId)));
                        prodSpcltyOppltList.add(newObject);                                                                             
                    }
                }
            }
            
            if(null != prodSpcltyOppltList && prodSpcltyOppltList.size() > 0){
                try{
                    insert prodSpcltyOppltList;
                }catch(Exception excp){
                    system.debug('Exception found while inserting records for Opportunity Product Specialty Assgnment '+excp.getMessage());
                }
            }
        }catch(Exception e){
             system.debug('*****Exception in SpecialityOpportunityMatchesBatch****' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext ctx){
        //String stQuery = 'Select count() from Sales_Territory__c where Related_User_Speciality_Updation__c = true';
        //Integer i = Database.countQuery(stQuery);
        //if (i >= 9000){
         // TM: R4 EF CR-0595: Nasir Jawed : Start: In query " ' AND' +  ' LastModifiedDate <'+ formatedDtSpecialty " added so only those records come  by the batch for which changes were made before the start of batch.
            String queParam1 = 'Select Id, Related_User_Speciality_Updation__c from Sales_Territory__c where Related_User_Speciality_Updation__c = true' +  ' AND' +  ' LastModifiedDate <'+ formatedDtSpecialty ;
            // TM: R4 EF CR-0595: Nasir Jawed : End
           // String queParam1 = 'Select Id, Related_User_Speciality_Updation__c from Sales_Territory__c where Related_User_Speciality_Updation__c = true';
            String param1 = 'Related_User_Speciality_Updation__c';
            Id batchEvalTerr1 = Database.executeBatch(new EvaluateTerrRealignBatch(queParam1,param1),150);
        //}else{
        //    List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        //    for(Sales_Territory__c strec : [Select Id, Related_User_Speciality_Updation__c from Sales_Territory__c where Related_User_Speciality_Updation__c = true]){
        //        strec.Related_User_Speciality_Updation__c = false;
        //        stList.add(strec);
        //    }
        //    update stList;
        //}
        //String psuaQuery = 'Select count() from Product_Specialty_User_Assignment__c where New_Or_Updated__c = true';
        //Integer c = Database.countQuery(psuaQuery);
        //if (c >= 9000){
        // TM: R4 EF CR-0595: Nasir Jawed : Start: In query " ' AND' +  ' LastModifiedDate <'+ formatedDtSpecialty " added so only those records come  by the batch for which changes were made before the start of batch.
            String queParam = 'Select Id, New_Or_Updated__c from Product_Specialty_User_Assignment__c where New_Or_Updated__c = true' +  ' AND' +  ' LastModifiedDate <'+ formatedDtSpecialty ;
            // TM: R4 EF CR-0595: Nasir Jawed : End
           // String queParam = 'Select Id, New_Or_Updated__c from Product_Specialty_User_Assignment__c where New_Or_Updated__c = true';
            String param = 'New_Or_Updated__c';
            Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(queParam,param),150);
        //}else{
        //    List<Product_Specialty_User_Assignment__c> psuaList = new List<Product_Specialty_User_Assignment__c>();
        //    for(Product_Specialty_User_Assignment__c psuarec : [Select Id, New_Or_Updated__c from Product_Specialty_User_Assignment__c where New_Or_Updated__c = true]){
        //        psuarec.New_Or_Updated__c = false;
        //        psuaList.add(psuarec);
        //    }
        //    update psuaList;
        //}
        
         //Mail notification...
        AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                    WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'Product Speciality Opportuity Matches has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
    
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
     
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setReplyTo('noreply@salesforce.com');  
        mail.setSenderDisplayName('Batch Job Summary');  
        mail.setSubject('Batch Job Completed - Product Speciality Opportuity Matches Batch'); 
        mail.setPlainTextBody(emailMessage);  
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail });

        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c){
            try{
                //Update to true
                specialtyFlag.SchedularFlag__c = true;
                update specialtyFlag;
            }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to true '+exp.getMessage());
            }
            SpecialtyBatchScheduler specialtySc = new SpecialtyBatchScheduler();
        
            datetime currentDateTime = datetime.now();
            String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
            
            String schExp = '0 '+min+' * * * ? ';
            system.schedule(Label.Specialty_Batch_Job+datetime.now(), schExp, specialtySc);
        }
    }
}