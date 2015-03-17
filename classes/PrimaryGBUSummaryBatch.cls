/**********************************************************
* Class Name: PrimaryGBUSummaryBatch
* Author: Accenture 
* Description: This is a PrimaryGBUSummaryBatch class 
*         to process opportunities entries.
***********************************************************/
global class PrimaryGBUSummaryBatch implements Database.Batchable<sObject>, Database.Stateful{
String email=null;
datetime now = null;
PrimaryGBUBatchConfig__c myCS = null;
public static Boolean isTestrun=false;
global Database.querylocator start(Database.BatchableContext BC){
    String query = null;
    DateTime lastRunCSDateTime = null;
   
    now = datetime.now();
    String nowDateTimeStr = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT');
    
    
    if(isTestrun){
        myCS = PrimaryGBUBatchConfig__c.getValues('PrimaryGBUtest');
        query ='Select id from Opportunity where id NOT IN (Select Opportunity__c from GBU_Product_Summary__c) LIMIT 200';
        
    }else{
        myCS = PrimaryGBUBatchConfig__c.getValues('PrimaryGBU');
    }
    
    if(myCS!=null){     
                      
        lastRunCSDateTime = myCS.Last_Run_Date_Time__c;
        email = myCS.Notification_Email_To__c;
        
        if(isTestrun==false)
        {
        if(lastRunCSDateTime == null){
            query ='Select id from Opportunity where id NOT IN (Select Opportunity__c from GBU_Product_Summary__c)';
        }else{
            String lastRunDateTimeStr = lastRunCSDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'','GMT');
            query = 'Select id from Opportunity where ';
            query += 'LastModifiedDate >= '+ lastRunDateTimeStr + ' AND LastModifiedDate <= '+ nowDateTimeStr +' ';
        }
      }
    }
    System.debug('@@@@@@@'+query);
    if(query!=null){
        return Database.getQueryLocator(query);
    }
    else{
        return null;
    }
}

global void execute(Database.BatchableContext BC, List<opportunity> scope){
    Set<ID> opptyIds = new Set<Id>();
    for(Opportunity opty : scope)
        opptyIds.add(opty.id);
    Map<String,Decimal> summaryMap = new Map<String,Decimal>();
    Set<Id> queriedOLIOptyIdSet = new Set<Id>();
    for(OpportunityLineItem oli: [Select GBU__c,Subtotal,Opportunityid,Opportunity.CurrencyIsoCode from OpportunityLineItem where Opportunityid IN : scope]){
        queriedOLIOptyIdSet.add(oli.Opportunityid);
        String key = oli.Opportunityid + '#' + oli.Opportunity.CurrencyIsoCode + '#' + oli.GBU__c;
        if(summaryMap.containskey(key)){
            Decimal val = summaryMap.get(key);
            Decimal tmpVal = val + oli.Subtotal;
            summaryMap.put(key,tmpVal);
        }else{
            summaryMap.put(key,oli.Subtotal);
        }
    }
    //system.debug('@@@@@@@@@@@@@'+summaryMap);
    //system.debug('@@@@@@@@@@@@@'+opptyIds.size());
    opptyIds.removeAll(queriedOLIOptyIdSet);
    //system.debug('@@@@@@@@@@@@@'+opptyIds.size());
    
    MAP<ID,GBU_Product_Summary__c> productSummaryMap = new Map<ID,GBU_Product_Summary__c>();
    
    if(opptyIds.size()>0){
        for(GBU_Product_Summary__c gbuSummaryRecord : [Select Opportunity_ID__c,Primary__c from GBU_Product_Summary__c where Opportunity__c IN :opptyIds]){
            gbuSummaryRecord.Primary__c = false;
            productSummaryMap.put(gbuSummaryRecord.Opportunity_ID__c,gbuSummaryRecord);
        }
    }
    
    for(String str : summaryMap.keySet()){
        String[] arrStr = Str.split('#',0);
        if(productSummaryMap.containsKey(arrStr[0])){
            if(productSummaryMap.get(arrStr[0]).Total_Value__c < summaryMap.get(str)){
                GBU_Product_Summary__c tmpSummaryRecord = new GBU_Product_Summary__c();
                tmpSummaryRecord.Primary__c = true;
                tmpSummaryRecord.Opportunity__c = arrStr[0];
                tmpSummaryRecord.Opportunity_ID__c = arrStr[0];
                tmpSummaryRecord.CurrencyIsoCode = arrStr[1];
                tmpSummaryRecord.GBU__c = arrStr[2];
                tmpSummaryRecord.Total_Value__c = summaryMap.get(str);
                productSummaryMap.put(arrStr[0],tmpSummaryRecord);
            }
        }else{
            GBU_Product_Summary__c tmpSummaryRecord = new GBU_Product_Summary__c();
            tmpSummaryRecord.Primary__c = true;
            tmpSummaryRecord.Opportunity__c = arrStr[0];
            tmpSummaryRecord.Opportunity_ID__c = arrStr[0];
            tmpSummaryRecord.CurrencyIsoCode = arrStr[1];
            tmpSummaryRecord.GBU__c = arrStr[2];
            tmpSummaryRecord.Total_Value__c = summaryMap.get(str);
            productSummaryMap.put(arrStr[0],tmpSummaryRecord);
        }
        
    }
    //try{
        upsert productSummaryMap.values() Opportunity_ID__c;
    //}catch(Exception ex){
        
    //}
}
    global void finish(Database.BatchableContext BC){
        //System.debug('$$$$$$$START$$$$$$$$');
        if(myCS!=null){
            //System.debug('$$$$$$$NOW$$$$$$$$'+now);
            myCS.Last_Run_Date_Time__c = now;
            update myCS;
        }
        //System.debug('$$$$$$$END$$$$$$$$');
        if(email!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo('batch@acme.com');
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Process Completed');
            mail.setPlainTextBody('Batch Process has completed');
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}