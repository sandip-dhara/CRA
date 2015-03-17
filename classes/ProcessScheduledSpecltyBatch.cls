/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for processing batch operation for Specialty Functionality
  * on 2 hourly schedule.
  * Date:
  */
global class ProcessScheduledSpecltyBatch implements Database.batchable<sObject> , Database.Stateful {
    
    global String salesTerrAccntsToProcess ; 
   
    global Database.queryLocator start(Database.BatchableContext ctx){
         /* Code commented which was working since R2, because it was not processing the batches in weekend realignment and it was only processing accounts which got into STAA one houre ago!
        datetime now = datetime.now();
        datetime twoHrsLessFrmNow = now.addHours(-1);   
        
        String nowDateTime = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT');
        String twoHrLessDateTime = twoHrsLessFrmNow.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT');
        
        
        salesTerrAccntsToProcess = 'Select s.LastModifiedDate, s.Id, s.Account__c From Sales_Territory_Account_Assignment__c s WHERE s.LastModifiedDate >= '+ twoHrLessDateTime + ' AND s.LastModifiedDate <= '+ nowDateTime;
        */
        //TM: NAsir JAwed: R6:Defect-ALM:14171  . ProcessScheduledSpecltyBatch does not run in weekend Realignment.
        // After R6 EF this batch will also run in weekend Realignment which is a hourly job for definition change in STD. Start
        TMEngineAccountRecordType__c lastRun = TMEngineAccountRecordType__c.getValues('ProcessScheduledSpecltyBatchTimeStamp');
    
        if(lastRun.AccountRecordType__c != null){
            DateTime stDate = DateTime.valueOf(lastRun.AccountRecordType__c);
            salesTerrAccntsToProcess = 'Select s.LastModifiedDate, s.Id, s.Account__c From Sales_Territory_Account_Assignment__c s WHERE (s.CreatedDate>= :stDate OR (s.LastModifiedDate >= :stDate AND s.isdeleted = true)) AND s.Sales_Territory__r.MyComp_Sales_Territory_Type__c!=\'PROFILEGEO\' All ROWS' ;
            //s.LastModifiedDate >= :stDate ALL ROWS
            DateTime newTimeStamp = datetime.now();
            lastRun.AccountRecordType__c = String.valueOf(newTimeStamp);
            update lastRun;
        }
        
       //TM: NAsir JAwed: R6:Defect-ALM:14171  . ProcessScheduledSpecltyBatch does not run in weekend Realignment.End
       
       if(Test.isrunningTest()){
            salesTerrAccntsToProcess= salesTerrAccntsToProcess.substring(0,salesTerrAccntsToProcess.length()- 9);
            salesTerrAccntsToProcess+= ' Limit 10 ALL ROWS';
       }
        return Database.getQueryLocator(salesTerrAccntsToProcess);
    }
    
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> salesTerrAccList){
        //system.debug('>>>>>>>>>salesTerrAccList '+salesTerrAccList);
        Set<Id> accSet = new Set<Id>();
        Set<Id> oppSet = new Set<Id>();
        for(Sales_Territory_Account_Assignment__c obj : salesTerrAccList){
            accSet.add(obj.Account__c);
        }
        
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(OpportunityLineItem oppLineItemObj : [Select o.Product__c, o.Opportunity.AccountId, o.OpportunityId, o.Id From OpportunityLineItem o Where o.Opportunity.AccountId In: accSet]){
            Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
            if(null == productSet){
                productSet = new Set<Id>(); 
            } 
            productSet.add(oppLineItemObj.Product__c);
            oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
        }
        
        //TM:Raghvendra:ALM 10320 :Start
        //get all the opportunitylineitem related to partner account's opty.
        for(Channel_Partner__c cp:[select id,Opportunity__c from Channel_Partner__c where Channel_Partner__c IN:accSet]){
            if(cp!=null){
                oppSet.add(cp.Opportunity__c);
            }
        }
        if((oppSet != null) && (oppSet.size()>0)){
            for(OpportunityLineItem oppLineItemObj : [Select  Id, Product__c, OpportunityId From OpportunityLineItem  Where OpportunityId In: oppSet]){
                Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
                if(null == productSet){
                    productSet = new Set<Id>(); 
                } 
                productSet.add(oppLineItemObj.Product__c);
                oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
            }
        }
        //TM:Raghvendra:ALM 10320 :End
        OppLineItemTriggerController.executeUpdateProdSpcltyOppAsgnmntLogic(oppLineItemProductSetMap);
        
    }
    
    global void finish(Database.BatchableContext ctx){
        //Mail notification...
        AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                        WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'Specialty Scheduled Batch' + ' has finished. It executed '  
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
        
        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        if(specialtyFlag != null && specialtyFlag.SchedularFlag__c){
            try{
                //Update to false
                specialtyFlag.SchedularFlag__c = false;
                update specialtyFlag;
            }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to false in ProcessScheduledSpecltyBatch '+exp.getMessage());
            }
        } 
        //TM:Ritesh: Req:2089: 24th Oct, 2012: Account Team creation moved to a seperate batch...
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
            if(Wobj1 != null && Wobj1.SchedularFlag__c){
            TMAddToAccountTeamScheduler sc = new TMAddToAccountTeamScheduler();
        
            datetime currentDateTime = datetime.now();
            String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
            String schExp = '0 '+min+' * * * ? ';
            system.schedule('TM-Add To Account Team Job'+datetime.now(), schExp, sc);
        }               
    }                          

}