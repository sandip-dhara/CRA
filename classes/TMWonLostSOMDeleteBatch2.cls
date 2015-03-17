//TM Nasir Jawed: 7/06/2013: CR-0979 Specialty Opportunity match Delete batch for Won/Lost Opportunities Start
/*
This batch queries all the opportunity for which stagename is lost and Won and then deletes the SOM for those 
*/

global class TMWonLostSOMDeleteBatch2 implements Database.batchable<sObject> ,  Database.Stateful{
    
    global String oppstoprocess = 'select id, stagename from opportunity where stagename in (\'Error\', \'HP Not Pursued\' ,\'Lost\',\'06-Won,Deploy & Expand\')';
    
    
    global Database.queryLocator start(Database.BatchableContext ctx){
        if ( Test.isRunningTest() ){     
        oppstoprocess+= ' Limit 10';           
        }  
        system.debug('Recycle:'+ oppstoprocess);
        return Database.getQueryLocator(oppstoprocess);    
    }
    
    global void execute(Database.BatchableContext ctx, List<Opportunity> opps){
        List<ID> oppid = new List<ID>();
        List<Product_Specialty_Oppty_Assignment__c> somId= new List<Product_Specialty_Oppty_Assignment__c>(); 
        
        for(Opportunity opp: opps){
            oppid.add(opp.id);
        }
        // Load the psoa's
        try{
            for(Product_Specialty_Oppty_Assignment__c psoa:[Select  p.Id From Product_Specialty_Oppty_Assignment__c p Where p.opportunity__c IN :oppid]){
                system.debug('Recycle1:'+ psoa); 
                somId.add(psoa);
                      
            }
        // Deleteing the SOM for Won/Lost opp from Specialty opportunity matches table
            if( somId.size()>0){                   
                database.delete(somId);
                system.debug('Recycle2:'+ database.delete(somId));
                database.emptyRecycleBin(somId);
                            
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
            
            String emailMessage = 'Your APEX Batch Job for TMWonLostSOMDeleteBatch2 has been completed ';  
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