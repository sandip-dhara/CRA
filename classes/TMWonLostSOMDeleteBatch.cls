//TM Nasir Jawed: 7/06/2013: CR-0979 Specialty Opportunity match Delete batch for Won/Lost Opportunities Start
/*
This batch queries all the opportunity for which stagename is lost and Won and then deletes the SOM for those 
*/

global class TMWonLostSOMDeleteBatch implements Database.batchable<sObject> ,  Database.Stateful{
    
    global String oppstoprocess = 'select id,Opportunity__c from Product_Specialty_Oppty_Assignment__c where Opportunity__r.IsClosed= True' ;
    Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('LimitSomDeleteBatch').Batch_Size__c);    

    global Database.queryLocator start(Database.BatchableContext ctx){
        if ( Test.isRunningTest() ){     
                 batchSize =10;
                 oppstoprocess=oppstoprocess ;           
        }    
        system.debug('Recycle:'+ oppstoprocess);
        return Database.getQueryLocator(oppstoprocess + ' Limit'+' '+ batchSize);        
    }
    
    global void execute(Database.BatchableContext ctx, List<Product_Specialty_Oppty_Assignment__c> somId){

        // Deleting the SOM for Won/Lost opp from Specialty opportunity matches table
           try{
               if( somId.size()>0){
                database.delete(somId);
                database.emptyRecycleBin(somId);
                system.debug('Recycle1:'+ somId);               
            }
        }catch(Exception e){
             system.debug('*****Exception in DeletePSOA_SFDC****' + e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext ctx){
         if (ctx != null) {
            AsyncApexJob apexJob = [SELECT id, ApexClassId,   
                           JobItemsProcessed, TotalJobItems,   
                           NumberOfErrors, CreatedBy.Email   
                        FROM AsyncApexJob   
                        WHERE id = :ctx.getJobId()];  
            
            String emailMessage = 'Your APEX Batch Job for TMWonLostSOMDeleteBatch has been completed ';  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
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

//TM Nasir Jawed: 7/06/2013: CR-0979 Specialty Opportunity match Delete batch for Won/Lost Opportunities: End