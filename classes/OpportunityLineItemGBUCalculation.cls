public class OpportunityLineItemGBUCalculation{
    /*
     * @Description:  .
     */
    public static void primaryGBUCalculation(Map<Id,OpportunityLineItem> TriggerMap){
        Set<id> opportunityIDSet = new Set<Id>();
        for(OpportunityLineItem oli: TriggerMap.values()){
            opportunityIDSet.add(oli.Opportunityid);
        }
        OpportunityLineItemGBUCalculation.calculatePrimaryNUpsert(opportunityIDSet);
    }
    
    @future
    public static void calculatePrimaryNUpsert(Set<ID> opptyIds) {
        Map<String,Decimal> summaryMap = new Map<String,Decimal>();
        Set<Id> queriedOLIOptyIdSet = new Set<Id>();
        for(OpportunityLineItem oli :[Select GBU__c,Subtotal,Opportunityid,Opportunity.CurrencyIsoCode from OpportunityLineItem where Opportunityid in :opptyIds]){
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
        system.debug('@@@@@@@@@@@@@'+summaryMap);
        system.debug('@@@@@@@@@@@@@'+opptyIds.size());
        opptyIds.removeAll(queriedOLIOptyIdSet);
        system.debug('@@@@@@@@@@@@@'+opptyIds.size());
        
        List<GBU_Product_Summary__c> productSummaryList = new List<GBU_Product_Summary__c>();
        
        if(opptyIds.size()>0){
            for(GBU_Product_Summary__c gbuSummaryRecord : [Select Opportunity_ID__c,Primary__c from GBU_Product_Summary__c where Opportunity__c IN :opptyIds]){
                gbuSummaryRecord.Primary__c = false;
                productSummaryList.add(gbuSummaryRecord);
            }
        }
        
        for(String str : summaryMap.keySet()){
            String[] arrStr = Str.split('#',0);
            GBU_Product_Summary__c tmpSummaryRecord = new GBU_Product_Summary__c();
            tmpSummaryRecord.Primary__c = true;
            tmpSummaryRecord.Opportunity__c = arrStr[0];
            tmpSummaryRecord.Opportunity_ID__c = arrStr[0];
            tmpSummaryRecord.CurrencyIsoCode = arrStr[1];
            tmpSummaryRecord.GBU__c = arrStr[2];
            tmpSummaryRecord.Total_Value__c = summaryMap.get(str);
            productSummaryList.add(tmpSummaryRecord);
        }
        try{
        upsert productSummaryList Opportunity_ID__c;
        }catch(Exception ex){
        }
    }
}