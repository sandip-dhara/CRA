/**********************************************************
    * Class Name: TMProcessLocSOMCrtBatch
    * Author: Raghvendra Jha
    * Date: 04-Jan-2013  
    *  Requirement # Req Id:10320 
    * Description: This batch class is a handle the SOM logic.
    ***********************************************************/
    global class TMProcessLocSOMCrtBatch implements Database.batchable<sObject> ,  Database.Stateful{
       
        public String productLineItem='select id from OpportunityLineItem'+
                            ' where (OpportunityId IN :opptyIdSet) AND (Opportunity.IsClosed=False)';
        global string stDatetime;
        global set<ID> opptyIdSet= new set<ID>();
        
        public TMProcessLocSOMCrtBatch (set<Id> oppIdSet,String datetime2){
            opptyIdSet=oppIdSet; 
            stDatetime= datetime2;  
        } 
        
        
        global Database.queryLocator start(Database.BatchableContext ctx){ 
            if ( Test.isRunningTest() ) productLineItem+= ' limit 30';
            return Database.getQueryLocator(productLineItem); 
           
        }
        
        // this method prepares MAP for Opportunity id and product.
        global void execute(Database.BatchableContext ctx, List<OpportunityLineItem > opportunitylineItemList){
           
            set<Id> oliSet= new set<Id>();
            Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();       
            for(OpportunityLineItem olItem :opportunitylineItemList){
                oliSet.add(olItem.id);           
            }
            for(OpportunityLineItem oppLineItemObj : [Select o.Id, o.Product__c, o.OpportunityId From OpportunityLineItem o Where id in : oliSet ]){ 
                Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
                if(null == productSet){
                    productSet = new Set<Id>(); 
                } 
                productSet.add(oppLineItemObj.Product__c);
                oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
            }
              
            SOMCreationController.executeSomLogic(oppLineItemProductSetMap);     
        }
        
        
        global void finish(Database.BatchableContext ctx){
         TMEngineScheduledFlag__c TMEngineScheduledFlagObj = TMEngineScheduledFlag__c.getValues(Label.TMProcessProdLineItemSOMBatch);
                boolean flag = TMEngineScheduledFlagObj.SchedularFlag__c;
                if(flag== True){
                    TMEngineScheduledFlagObj.SchedularFlag__c = False;
                    update TMEngineScheduledFlagObj;
                }  
                
                String queParam = 'Select Id,New_Specialty_search__c from Product_Specialty__c where New_Specialty_search__c = true' +  ' AND' +  ' LastModifiedDate <'+ stDatetime;
                String param = 'New_Specialty_search__c';            
                //TM:Sreenath scheduling a batch from a batch without cron expression starts
                EvaluateTerrRealignBatch ETRB = new EvaluateTerrRealignBatch(queParam,param);
                String cronID1 = System.scheduleBatch(ETRB, 'EvaluateTerrRealign_Batch_Job1', 3);
                //TM:Sreenath scheduling a batch from a batch without cron expression ends
                
                
                String queParam1 = 'Select Id,New_User_Alert__c from sales_Territory__c where New_User_Alert__c = true' +  ' AND' +  ' DateTime_User_Insert__c <'+ stDatetime;
                String param1 = 'New_User_Alert__c';               
                //TM:Sreenath scheduling a batch from a batch without cron expression starts
                EvaluateTerrRealignBatch ETRB1 = new EvaluateTerrRealignBatch(queParam1,param1);
                String cronID2 = System.scheduleBatch(ETRB1, 'EvaluateTerrRealign_Batch_Job2', 6);
                //TM:Sreenath scheduling a batch from a batch without cron expression ends
                
                String queParam2 = 'Select Id,New_User_Insert_Sales_Territory__c from Product_Specialty_User_Assignment__c where New_User_Insert_Sales_Territory__c = true' +  ' AND' +  ' LastModifiedDate <'+ stDatetime;
                String param2 = 'New_User_Insert_Sales_Territory__c';                        
                //TM:Sreenath scheduling a batch from a batch without cron expression starts
                EvaluateTerrRealignBatch ETRB2 = new EvaluateTerrRealignBatch(queParam2,param2);
                String cronID3 = System.scheduleBatch(ETRB2, 'EvaluateTerrRealign_Batch_Job3', 10);
                //TM:Sreenath scheduling a batch from a batch without cron expression ends
                
                if (ctx != null) {
                AsyncApexJob apexJob = [SELECT id, ApexClassId,   
                               JobItemsProcessed, TotalJobItems,   
                               NumberOfErrors, CreatedBy.Email   
                            FROM AsyncApexJob   
                            WHERE id = :ctx.getJobId()];  
                
                String emailMessage = 'Your APEX Batch Job for TMProcessLocationSOMBatch has been completed ';  
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