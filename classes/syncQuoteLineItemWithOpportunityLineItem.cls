/**
* Class Name: syncQuoteLineItemWithOpportunityLineItem
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: copy all quote line item and insert into oppty line item
*/
global class syncQuoteLineItemWithOpportunityLineItem{

   Webservice static String syncQuoteLineItemWithOpptyLineItem(String OpportunityId,String runQuoteLineItem,String opptyISOCode,String QuoteNumber){
    Map<Id,HP_Quote__c> mapSyncQuote;
    if(QuoteNumber != null && QuoteNumber != ''){
      /*mapSyncQuote = New Map<Id,HP_Quote__c>([select id,Opportunity_Name__r.CloseDate,Opportunity_Name__r.CurrencyIsoCode,Expiring_Contract_Number__c from HP_Quote__c where id =: QuoteNumber and Synced_To_Opportunity__c =: true]);*/
      return('');
    }
    else{
      mapSyncQuote = New Map<Id,HP_Quote__c>([select id,Opportunity_Name__r.CloseDate,Opportunity_Name__r.CurrencyIsoCode,Expiring_Contract_Number__c from HP_Quote__c where Opportunity_Name__c =: OpportunityId and Synced_To_Opportunity__c =: true]);
    }
        //*************update opty Sales matric code form Hp Quote Sale Matric **********************//
        List<Opty_Sales_Metric_Code__c> OSMCDelete = new List<Opty_Sales_Metric_Code__c>([select Id from Opty_Sales_Metric_Code__c where OpportunityId__c=:OpportunityId]);
        Database.DeleteResult[] deleteResultOSMC = Database.delete(OSMCDelete,false);
        List<Opty_Sales_Metric_Code__c> OSMC = new List<Opty_Sales_Metric_Code__c>();
        List<Quote_Sales_Metric_Code__c> QSMC = new List<Quote_Sales_Metric_Code__c>([select HP_Quote__c,Total_Value__c,Name,HP_Quote__r.CurrencyIsoCode from Quote_Sales_Metric_Code__c where HP_Quote__c in :mapSyncQuote.keyset()]);
        for ( Quote_Sales_Metric_Code__c Qobj : QSMC)
        {
            Opty_Sales_Metric_Code__c Oobj = new Opty_Sales_Metric_Code__c();
            Oobj.OpportunityId__c = OpportunityId;
            Oobj.Total_Value__c = Qobj.Total_Value__c*(CurrencyConversionUtil.GetCoversionRate(Qobj.HP_Quote__r.CurrencyIsoCode, mapSyncQuote.get(Qobj.HP_Quote__c).Opportunity_Name__r.CurrencyIsoCode, mapSyncQuote.get(Qobj.HP_Quote__c).Opportunity_Name__r.CloseDate));
            Oobj.QuoteID__c = Qobj.HP_Quote__c;
            Oobj.name = Qobj.name;
            OSMC.add(Oobj);
        }
        Database.SaveResult[] InsertOSMC = Database.insert(OSMC,false);
        //*************update opty Sales matric code form Hp Quote Sale Matric **********************//
        set<string> setHpQuoteExpiringContractNumber = new set<String>();
        //Remove Contract Functionality from Sync
        //Map<string,id> mapExpiringContractWithContractId = new Map<string,id>();
        List<OpportunityLineItem> listKeepOpptyLineItem = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listDeleteOpptyLineItem = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listInsertOpptyLineItem = new List<OpportunityLineItem>();
        Map<String,Double> oConversionList= new Map<String,Double>();
        String returnError = 'Inserted';
        List<Opportunity> listOpportunity = [select id,SAP_Feed__c  from opportunity where id=: OpportunityId and SAP_Feed__c = true and recordtypeId=:Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId()];
        for(OpportunityLineItem objOpptyLineItem : [select Id,Keep__c from OpportunityLineItem where OpportunityId =: OpportunityId]){
            if(objOpptyLineItem.Keep__c == true){
                listKeepOpptyLineItem.add(objOpptyLineItem);
            }
            else{
                listDeleteOpptyLineItem.add(objOpptyLineItem);
            }
        }
        
        for(Hp_Quote__c objHpQuote : mapSyncQuote.values()){
            if(objHpQuote.Expiring_Contract_Number__c != '' && objHpQuote.Expiring_Contract_Number__c != null){
                setHpQuoteExpiringContractNumber.add(objHpQuote.Expiring_Contract_Number__c);
            }
        }
        //Remove Contract Functionality from Sync
        /*
        for(Contract_Reference__c objContract : [select id,Name from Contract_Reference__c where Name In: setHpQuoteExpiringContractNumber]){
            mapExpiringContractWithContractId.put(objContract.Name,objContract.id);
        }*/
        if(!mapSyncQuote.IsEmpty() && runQuoteLineItem == 'True'){
            List<HP_Quote_Line_Item__c> listQuoteLineItem = new List<HP_Quote_Line_Item__c>();
            set<Id> setProducts = new set<Id>();
            for(HP_Quote_Line_Item__c objQuoteLineItem : [select id,Product_Name__c,Total_Sales_Price__c,HP_Quote_Name__r.Originating_System_Quote_ID__c,HP_Quote_Name__c,HP_Quote_Name__r.CurrencyIsoCode from HP_Quote_Line_Item__c where HP_Quote_Name__c In: mapSyncQuote.keyset()]){
                listQuoteLineItem.add(objQuoteLineItem);
                setProducts.add(objQuoteLineItem.Product_Name__c);
               if(!oConversionList.containsKey(objQuoteLineItem.HP_Quote_Name__c)){
                    oConversionList.put(objQuoteLineItem.HP_Quote_Name__c,
                            CurrencyConversionUtil.GetCoversionRate(objQuoteLineItem.HP_Quote_Name__r.CurrencyIsoCode, 
                                                                    mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Opportunity_Name__r.CurrencyIsoCode, 
                                                                    mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Opportunity_Name__r.CloseDate));
                }
            }
            Map<Id,Id> mapProductAndPricebookEntry = new Map<Id,Id>();
            for(PricebookEntry objPriceBookEntry : [select id,Product2Id from PricebookEntry where Pricebook2.Name =: Label.PriceBook_Name and Product2Id In : setProducts and CurrencyIsoCode =:opptyISOCode]){
                mapProductAndPricebookEntry.put(objPriceBookEntry.Product2Id, objPriceBookEntry.id);
            }
            if(!mapProductAndPricebookEntry.isEmpty()){
                for(HP_Quote_Line_Item__c objQuoteLineItem : listQuoteLineItem){
                    OpportunityLineItem objOpptyLineItem = new OpportunityLineItem();
                    objOpptyLineItem.PricebookEntryId= mapProductAndPricebookEntry.get(objQuoteLineItem.Product_Name__c);
                    objOpptyLineItem.Quantity= 1;
                    objOpptyLineItem.UnitPrice = objQuoteLineItem.Total_Sales_Price__c*oConversionList.get(objQuoteLineItem.HP_Quote_Name__c);
                    objOpptyLineItem.OpportunityId = OpportunityId;
                    objOpptyLineItem.Quote_Number__c = objQuoteLineItem.HP_Quote_Name__r.Originating_System_Quote_ID__c;
                    objOpptyLineItem.HP_Quote__c = mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Id;
                    objOpptyLineItem.ServiceDate = mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Opportunity_Name__r.CloseDate;
                    //Remove Contract Functionality from Sync
                    /*if(mapExpiringContractWithContractId.containsKey(mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Expiring_Contract_Number__c))
                        objOpptyLineItem.Contract__c = mapExpiringContractWithContractId.get(mapSyncQuote.get(objQuoteLineItem.HP_Quote_Name__c).Expiring_Contract_Number__c);*/
                    listInsertOpptyLineItem.add(objOpptyLineItem);
                }
                if(!listInsertOpptyLineItem.isEmpty()){
                    Database.SaveResult[] insertedLineItemsResult = Database.insert(listInsertOpptyLineItem,false);
                    //insert listInsertOpptyLineItem;
                    for(Database.SaveResult result:insertedLineItemsResult){
                        if(!result.isSuccess()){
                            //returnError = Label.CPQSyncResult;
                            for(Database.Error err : result.getErrors()){
                                returnError = err.getStatusCode() + ': ' + err.getMessage();
                                system.debug('******Error******'+err.getStatusCode() + ': ' + err.getMessage());
                            }
                        }
                    }
                }
            }
        }
        if(!listDeleteOpptyLineItem.isEmpty()){
            //Delete listDeleteOpptyLineItem;
            Database.DeleteResult[] deleteResult = Database.delete(listDeleteOpptyLineItem,false);
        }
        if(!listOpportunity.isEmpty()){
            for(opportunity objOpportunity: listOpportunity){
                objOpportunity.SAP_Feed__c  = false;
            }
            Database.SaveResult[] updateAutoSyncFlagResult = Database.update(listOpportunity,false);
        }
        
        return returnError;
    }
}