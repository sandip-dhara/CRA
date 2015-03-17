// TM :Nasir Jawed.7-31-2013 This batch creates SOM based on the user who are assigned in territory(customer and partner Territory) and gets oppty share.


global class TMOpportunityShareSOMBatch implements Database.batchable<sObject> , Database.Stateful{
    
    global final Batch_Job_Invoker__c batchInvoker;
    global String opportunityToProcess;
    
    global TMOpportunityShareSOMBatch(Batch_Job_Invoker__c invokerObj){
        batchInvoker = invokerObj; 
    }
    
    global TMOpportunityShareSOMBatch(){
        
    }  
    
    //Start method: here it executes the query.
    global Database.queryLocator start(Database.BatchableContext ctx){
        //opportunityToProcess='select id,OpportunityId from opportunitylineitem where Opportunity.IsClosed=False AND Opportunity.Account.WorldRegion_Region__c=\'Asia Pacific\' AND Opportunity.Account.WorldRegion_SubRegion1__c =\'Japan\'';
        
        if(batchInvoker != null && batchInvoker.Type__c.equalsIgnoreCase('Specialty Realignment')){            
            //Filtering the query with only open opportunity filtered by Region, so that unwanted records gets reduced from the opportunity.Start
            opportunityToProcess ='select id,Opportunity.Account.WorldRegion_Region__c from OpportunityLineItem  ';             
        }
        TMEngineAccountRecordType__c region=TMEngineAccountRecordType__c.getInstance('SpecialtyRealignmentRegion');
        String accRegion= region.AccountRecordType__c;
        
        if(accRegion!=null){ 
            opportunityToProcess += ' Where Opportunity.IsClosed=False AND Opportunity.Account.WorldRegion_Region__c=\''+ accRegion + '\'';  
            
            TMEngineAccountRecordType__c subRegion=TMEngineAccountRecordType__c.getInstance('SpecialtyRealignmentSubRegion');
            String accSubRegion= subRegion.AccountRecordType__c;
            
            if(accSubRegion!=null){
                opportunityToProcess += ' AND Opportunity.Account.WorldRegion_SubRegion1__c =\''+ accSubRegion + '\'';   
                 //TM: Manasa : R6 EF: adding subregion2 
                TMEngineAccountRecordType__c subRegion2=TMEngineAccountRecordType__c.getInstance('SpecialtyRealignmentSubRegion2');
                String accSubRegion2= subRegion2.AccountRecordType__c;   
                if( accSubRegion2!=null){
                    opportunityToProcess += ' AND Opportunity.Account.WorldRegion_SubRegion2__c =\''+ accSubRegion2 + '\'';
                }   
            }
        }
        if( Test.isRunningTest() ) opportunityToProcess += ' limit 10';
        	system.debug('testquery:'+opportunityToProcess);
           return Database.getQueryLocator(opportunityToProcess);
    }
    
    global void execute(Database.BatchableContext ctx, List<OpportunityLineItem> oliToProcessList){
        Set<Id> oliSet = new Set<Id>();
               
        for(OpportunityLineItem oliObj : oliToProcessList){
            oliSet.add(oliObj.id);
        }
        
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(OpportunityLineItem oppLineItemObj : [Select o.Id, o.Product__c, o.OpportunityId From OpportunityLineItem o Where Id in : oliSet AND Opportunity.RecordType.Name!='HPFS' ]){
              system.debug('3opp:'+oppLineItemObj);  
            Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
            if(null == productSet){
                productSet = new Set<Id>(); 
            } 
            productSet.add(oppLineItemObj.Product__c);
            oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
        }
          
        TMOpportunityShareSOMBatchInsertDelete.executeUpdateSOM(oppLineItemProductSetMap);   
        
    }
    
    global void finish(Database.BatchableContext ctx){
        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyRealignmentBatchFlag');              
        if(specialtyFlag != null && specialtyFlag.SchedularFlag__c){
            try{
            //Update to true
                specialtyFlag.SchedularFlag__c = False;
                update specialtyFlag;
               }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to False  '+exp.getMessage());
            }    
        }
        if (ctx != null) {
            AsyncApexJob apexJob = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :ctx.getJobId()];  
            
            String emailMessage = 'Your APEX Batch Job for "TMOpportunityShareSOMBatch" has been completed ';  
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
// TM :Nasir Jawed.7-31-2012 End