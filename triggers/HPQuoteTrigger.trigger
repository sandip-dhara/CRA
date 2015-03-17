trigger HPQuoteTrigger on HP_Quote__c (after update,after insert){
    if(Trigger.isInsert){ 
        HPQuoteUtils.populateHideBasedOnMergedQuoteInformation(Trigger.new);
    } 
    else{
        if(Trigger.isUpdate){
            List<HP_Quote__c> oQuoteList= new List<HP_Quote__C>();
            for(HP_Quote__c oQuote:Trigger.new){
                if(oQuote.Merged_Quote_Information__c!=Trigger.oldMap.get(oQuote.Id).Merged_Quote_Information__c){
                    oQuoteList.add(oQuote);
                }
            }
            if(!oQuoteList.isEmpty()){
                HPQuoteUtils.populateHideBasedOnMergedQuoteInformation(oQuoteList);
            }
        }
    }
}