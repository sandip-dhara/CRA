/**********************************************************
* Class Name: SupportRequestRoutingRulesTriggerUtil
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Contains Support Request Action methods & Util methods
***********************************************************/

public class SupportRequestRoutingRulesTriggerUtil{
    private static Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
    private static Map<String,ID> recordTypeNameWithID = null;
    public List<Support_Request__c> supportRequestList = new List<Support_Request__c>();
    
    /**
    * @description: Query RecordType based on supportRequest Records
    * @param: List of Support Requests
    * @Return: List of recordTypes
    */
    public static Map<Id,RecordType> qryRecordTypeMap(List<Support_Request__c> supportRequestNewList){
        Set<Id> recordTypeIDSet = new Set<Id>();
        for(Support_Request__c request : supportRequestNewList){
            recordTypeIDSet.add(request.recordTypeId);
        }
        Map<Id,RecordType> recordTypeMap = new Map<Id,RecordType>([select Id,Name from RecordType where id In:recordTypeIDSet]);
        return recordTypeMap;
    }
    
    /**
    * @description: Query Opportunity CurrencyIsoCode based on supportRequest Records
    * @param: List of Support Requests
    * @Return: Map of opty ID with CurrencyIsoCode
    */
    public static Map<Id,Opportunity> qryOpportunityMap(List<Support_Request__c> supportRequestNewList){
        Set<Id> optyIdSet = new Set<Id>();
        for(Support_Request__c request : supportRequestNewList){
            if(request.Opportunity__c!=null){
                optyIdSet.add(request.Opportunity__c);
            }
        }
        Map<Id,Opportunity> qryOpportunityMap = new Map<Id,Opportunity>([select Id,Description,CurrencyIsoCode from opportunity where id In:optyIdSet]);
        return qryOpportunityMap;
    }
    
    /**
    * @description: Create RecordType Name based on Eligible BG from CS
    * @param: 
    * @Return: List of Support Request CS records
    */
    public static Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap(){
        Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap = new Map<String,Support_Request_FS_CS__c>();
        for(Support_Request_FS_CS__c csRecord : sRequestFieldSetCSMap.values() ){
            if(csRecord.isBG_Specific_RecordType__c){
                Set<String> eligibleBGSet = SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',csRecord.Eligible_BG__c);
                for(String eligibleBG : eligibleBGSet){
                    formNameWithSRequestCSMap.put(eligibleBG +'-'+ csRecord.RecordType_Name__c,csRecord);
                }
            }else{
                formNameWithSRequestCSMap.put(csRecord.RecordType_Name__c,csRecord);
            }
        }
        return formNameWithSRequestCSMap;
    }
    
    public static Set<id> setOptyIds(List<Support_Request__c> supportRequestNewList){
        Set<id> optyIdSet = new Set<id>();
         for(Support_Request__c request : supportRequestNewList){
            if(request.Opportunity__c!=null){
                optyIdSet.add(request.Opportunity__c);
            }
        }
        return optyIdSet;
    }
    
    /**
    * @description: Check and change recordType if BG is changed to different than userBG
    * @param: List of supportRquest, RecordType List, CS RecordType list
    * @Return: void
    */
    public static void checkNChangeRecordTypeifBGChanged(List<Support_Request__c> supportRequestNewList,Map<Id,RecordType> recordTypeMap,Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap){
        Map<Support_Request__c,String> sRequestWithNewRecordType = new Map<Support_Request__c,String>();
        for(Support_Request__c request : supportRequestNewList){
            System.debug('$$$$$$$$$$$$$$$$$$$$request.BG__c:'+request.BG__c);
            if(request.BG__c != null){
                String recordTypeName = recordTypeMap.get(request.RecordTypeId).Name;
                System.debug('$$$$$$$$$$$$$$$$$$$$recordTypeName :'+recordTypeName );
                Support_Request_FS_CS__c formCSRecord = formNameWithSRequestCSMap.get(recordTypeName);
                System.debug('$$$$$$$$$$$$$$$$$$$$formCSRecord :'+formCSRecord );
                Set<String> eligibleBGSet = SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',formCSRecord.Eligible_BG__c);
                System.debug('$$$$$$$$$$$$$$$$$$$$eligibleBGSet :'+eligibleBGSet );
                if(eligibleBGSet.contains(request.BG__c)){
                    System.debug('$$$$$$$$$$$$$$$$$$$$isBG_Specific_RecordType__c:'+formCSRecord.isBG_Specific_RecordType__c);
                    if(formCSRecord.isBG_Specific_RecordType__c){
                        String newRecordTypeName = request.BG__c+'-'+formCSRecord.RecordType_Name__c;
                        System.debug('$$$$$$$$$$$$$$$$$$$$request.BG__c-formCSRecord.RecordType_Name__c:'+newRecordTypeName );
                        sRequestWithNewRecordType.put(request,newRecordTypeName);
                    }else{
                        //Means No Change in RecordType
                        System.debug('$$$$$$$$$$$$$$$$$$$$Means No Change in RecordType' );
                    }
                }else{
                    request.addError(Label.SupportRequest_BGNotEligible);
                }
            }
        }
        Map<Id,RecordType> newRecordTypeMap = new Map<Id,RecordType>([select Id,Name from RecordType where Name In:sRequestWithNewRecordType.values()]);
        System.debug('$$$$$$$$$$$$$$$$$$$$newRecordTypeMap '+newRecordTypeMap);
        Map<String,Id> newRecordTypeNameWithId = new Map<String,Id>();
        for(RecordType rcType : newRecordTypeMap.values()){
            newRecordTypeNameWithId.put(rcType.Name,rcType.id);
        }
        for(Support_Request__c request : sRequestWithNewRecordType.keySet()){
            String newRecordTypeName = sRequestWithNewRecordType.get(request);
            System.debug('$$$$$$$$$$$$$$$$$$$$newRecordTypeName '+newRecordTypeName );
            if(newRecordTypeNameWithId.containsKey(newRecordTypeName)){
                System.debug('$$$$$$$$$$$$$$$$$$$$newRecordTypeNameWithId.get(newRecordTypeName)'+newRecordTypeNameWithId.get(newRecordTypeName));
                request.recordTypeId = newRecordTypeNameWithId.get(newRecordTypeName);
            }else{
                request.addError(Label.No_RecordType_Found);
            }
        }
    }
    
    /**
    * @description: Use to populate RecordType Id on Support Request Rule object
    * @param: List of Support Request Routing Rules
    * 
    */
    public static void populateRecordTypeId(List<SupportRequest_Routing_Rules__c> routingRulesNewList){
        for(SupportRequest_Routing_Rules__c rule : routingRulesNewList){
            Id recordTypeId = null;
            recordTypeId = getRecordTypeIDByName(rule.Form_Name_RecordType_Name__c);
            if(recordTypeId == null){
                rule.addError(Label.No_RecordType_Found);
            }
            else{
                rule.Support_Request_recordTypeID__c =  recordTypeId;
            }
        }
    }
    
    /**
    * @description: Use to populate opportunity currencyIsoCode on Support Request currencyIsoCode
    * @param: List of Support Request, Opporunity Map
    * 
    */
    public static void populateCurrencyIsoCode(List<Support_Request__c> supportRequestNewList,Map<Id,Opportunity> opportunityMap){
        if(opportunityMap!=null & opportunityMap.size()>0){
            for(Support_Request__c request : supportRequestNewList){
                if(request.Opportunity__c != null && opportunityMap.containsKey(request.Opportunity__c)
                  &&request.Support_Type__c!='Quote-to-Order' &&request.Sub_Type__c!='Config / Price / Quote')
                  {
                    request.CurrencyIsoCode = opportunityMap.get(request.Opportunity__c).CurrencyIsoCode;
                    request.Opportunity_Description__c = opportunityMap.get(request.Opportunity__c).Description;
                }
            }
        }
    }
    
    /**
    * @description: Use to populate BG on Support Request object from Contact user BG
    * @param: List of Support Request
    * 
    */
    public static void populateRoutingFields(List<Support_Request__c> supportRequestNewList,Set<id> optyIdSet){
        populateLookupFields(supportRequestNewList,optyIdSet);
        List<ID> supportRequestOptyIds = new List<ID>();
        Map<id,Account> optyAccountMap = getOptyAccountsDetail(supportRequestNewList,optyIdSet);
        User loginUser =[select id,Business_Group__c,Region__c from user where id=:UserInfo.getUserId()];
        Set<String> regionvaluesSet = new Set<String>();
        Schema.DescribeFieldResult regionField = Support_Request__c.Routing_Region__c.getDescribe();
        List<Schema.PicklistEntry> regionFieldValues = regionField.getPicklistValues();
        for(Schema.PicklistEntry val : regionFieldValues){
            regionvaluesSet.add(val.getValue().toLowerCase());
        }
        Set<String> subRegionvaluesSet = new Set<String>();
        Schema.DescribeFieldResult subRegionField = Support_Request__c.Routing_Sub_Region__c.getDescribe();
        List<Schema.PicklistEntry> subRegionFieldValues = subRegionField.getPicklistValues();
        for(Schema.PicklistEntry val : subRegionFieldValues){
            subRegionvaluesSet.add(val.getValue().toLowerCase());
        }
        Set<String> countryvaluesSet = new Set<String>();
        Schema.DescribeFieldResult countryField = Support_Request__c.Routing_Country__c.getDescribe();
        List<Schema.PicklistEntry> countryFieldValues = countryField .getPicklistValues();
        for(Schema.PicklistEntry val : countryFieldValues ){
            countryvaluesSet.add(val.getValue().toLowerCase());
        }
        for(Support_Request__c request : supportRequestNewList){
            if(request.BG__c==null){
                request.BG__c = loginUser.Business_Group__c;
                supportRequestOptyIds.add(request.Opportunity__c);
                }
            }
            //Account tmpAccount = optyAccountMap.get(request.Opportunity__c);
             List<Opportunity> optylist =[select id,AccountId,Account.WorldRegion_Region__c,Account.WorldRegion_SubRegion1__c,Account.ShippingCountry from opportunity where id in :supportRequestOptyIds];
             
            if(optylist.size()>0){
               for(Support_Request__c srequest : supportRequestNewList){
               for(Opportunity opty : optylist){
                if(srequest.Routing_Region__c==null && opty.Account.WorldRegion_Region__c!=null){
                    //String[] values = tmpAccount.Regions__c.split(';');
                   //if(values!=null && values[0]!=''){
                        if(regionvaluesSet.contains(opty.Account.WorldRegion_Region__c.toLowerCase())){
                            srequest.Routing_Region__c = opty.Account.WorldRegion_Region__c;
                            system.debug('routing Region from Account##'+opty.Account.WorldRegion_Region__c);
                        }
                   // }
                }
                if(srequest.Routing_Sub_Region__c==null && opty.Account.WorldRegion_SubRegion1__c!=null){
                    if(subRegionvaluesSet.contains(opty.Account.WorldRegion_SubRegion1__c.toLowerCase())){
                        srequest.Routing_Sub_Region__c = opty.Account.WorldRegion_SubRegion1__c;
                    }
                }
                if(srequest.Routing_Country__c==null && opty.Account.ShippingCountry!=null){
                    if(countryvaluesSet.contains(opty.Account.ShippingCountry.toLowerCase())){
                        srequest.Routing_Country__c = opty.Account.ShippingCountry;
                    }
                }
             }
           }
          }
        
    }
    
    /**
    * @description: Use to populate Region, Subregion country on Support Request object from Opporunity Account
    * @param: List of Support Request
    * 
    */
    public static Map<id,Account> getOptyAccountsDetail(List<Support_Request__c> supportRequestNewList,Set<id> optyIdSet){
        Map<id,Account> retoptyAccountMap = null;
        if(optyIdSet!=null && optyIdSet.size()>0){
            List<opportunity> qryOptyList = [select id,AccountId,Account.Regions__c,Account.WorldRegion_SubRegion1__c,Account.ShippingCountry from opportunity where id In: optyIdSet];
            if(qryOptyList!=null && qryOptyList.size()>0){
                retoptyAccountMap = new Map<id,Account>();
                for(opportunity opty: qryOptyList){
                    Account tmpAcc = new Account(id=opty.AccountId);
                    //tmpAcc.Regions__c = opty.Account.Regions__c;
                   // tmpAcc.WorldRegion_SubRegion1__c = opty.Account.WorldRegion_SubRegion1__c;
                    tmpAcc.ShippingCountry = opty.Account.ShippingCountry;
                    retoptyAccountMap.put(opty.id,tmpAcc);
                }
            }
        }
        return retoptyAccountMap;
    }
    
    public static void populateLookupFields(List<Support_Request__c> supportRequestNewList,Set<id> optyIdSet){
        Map<Id,Id> optyPrinaryPartnerMap = new Map<Id,Id>();
        Map<Id,Id> optyPrinaryCompetitorMap = new Map<Id,Id>();
        Map<Id,Id> optyIncumbentCompetitorMap = new Map<Id,Id>();
        
        if(optyIdSet!=null && optyIdSet.size()>0){
            List<Competitors__c> CompetitorsList = [select Id,Competitor_Account__c,Primary__c,Incumbent__c,Opportunity__c from Competitors__c where Opportunity__c In: optyIdSet];
            
            if(CompetitorsList!=null && CompetitorsList.size()>0){
                for(Competitors__c Competitor: CompetitorsList){
                    if(Competitor.Primary__c == true){
                        optyPrinaryCompetitorMap.put(Competitor.Opportunity__c,Competitor.Competitor_Account__c);
                    }
                    if(Competitor.Incumbent__c == true){
                        optyIncumbentCompetitorMap.put(Competitor.Opportunity__c,Competitor.Competitor_Account__c);
                    }
                }
            }
            
            List<Channel_Partner__c> PartnerList = [select Id,Channel_Partner__c,Primary__c,Opportunity__c from Channel_Partner__c where Opportunity__c In: optyIdSet and Primary__c=True];
            
            if(PartnerList!=null && PartnerList.size()>0){
                for(Channel_Partner__c primaryPartner: PartnerList){
                    optyPrinaryPartnerMap.put(primaryPartner.Opportunity__c,primaryPartner.Channel_Partner__c);
                }
            }
            for(Support_Request__c request : supportRequestNewList){
                if(request.Primary_Competitor__c==null && optyPrinaryCompetitorMap.containsKey(request.Opportunity__c)){
                    request.Primary_Competitor__c=optyPrinaryCompetitorMap.get(request.Opportunity__c);
                }
                if(request.Incumbent_Competitor__c==null && optyIncumbentCompetitorMap.containsKey(request.Opportunity__c)){
                    request.Incumbent_Competitor__c = optyIncumbentCompetitorMap.get(request.Opportunity__c);
                }
                if(request.Partner__c==null && optyPrinaryPartnerMap.containsKey(request.Opportunity__c)){
                    request.Partner__c=optyPrinaryPartnerMap.get(request.Opportunity__c);
                }
            }
        }
    }
    
    /**
    * @description: Use to populate Support Type & SubType on Support Request object
    * @param: List of Support Request
    * 
    */
    public static void populateSupportTypeNSubType(List<Support_Request__c> supportRequestNewList,Map<Id,RecordType> recordTypeMap,Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap){
        for(Support_Request__c request : supportRequestNewList){
            if(recordTypeMap.containskey(request.RecordTypeId)){
                String recordTypeName = recordTypeMap .get(request.RecordTypeId).Name;
                request.Support_Type__c = formNameWithSRequestCSMap.get(recordTypeName).SupportReqType__c;
                request.Sub_Type__c = formNameWithSRequestCSMap.get(recordTypeName).Request_SubType__c;
            }
        }
    }
    
    /**
    * @description: Use to Split string using pattern
    * @param: Delimiter as pattern & To split string using delimiter as str
    * @return: List of Split Values
    *
    */
    public static Set<String> splitNconvertToSet(String pattern,String str){
        Set<String> retSetValues = null;
        if(str!=null && str.length()>0){
            retSetValues = new Set<String>();
            List<String> splitValues = str.split(pattern,0);
            for(String val: splitValues){
                retSetValues.add(val);
            }
        }
        return retSetValues;
    }
    
    /**
    * @description: Return recordType ID by name
    * @param: Name of record Type
    * @return: Id of record Type
    *
    */
    /*public static ID getRecordTypeIDByName(String recordTypeName){
        Id recordTypeid = null;
        if(recordTypeName!=null){
            try{
                recordTypeid = Schema.SObjectType.Support_Request__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            }catch(Exception e){
                recordTypeid = null;
            }
        }else{
            recordTypeid = null;
        }
        return recordTypeid;
    }*/
    
    public static ID getRecordTypeIDByName(String recordTypeName){
        Id recordTypeid = null;
        if(recordTypeName!=null){
            if(recordTypeNameWithID == null || recordTypeNameWithID.size()<=0){
                Schema.DescribeSObjectResult R = Support_Request__c.SObjectType.getDescribe();
                List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
                recordTypeNameWithID = new Map<String,Id>();
                for(Schema.RecordTypeInfo recordType: RT){
                    recordTypeNameWithID.put(recordType.getName(),recordType.getRecordTypeId());
                }
            }
            if(recordTypeNameWithID.containsKey(recordTypeName)){
                recordTypeid = recordTypeNameWithID.get(recordTypeName);
            }
            
        }else{
            recordTypeid = null;
        }
        return recordTypeid;
    }
    
    /**
    * @description: Return recordType Name by ID
    * @param: ID of record Type
    * @return: Name of record Type
    *
    */
    public static String getRecordTypeNameById(ID recordTypeId){
        String recordTypeName= null;
        if(recordTypeId!=null){
            try{
                recordTypeName = Schema.SObjectType.Support_Request__c.getRecordTypeInfosByID().get(recordTypeId).getName();
            }catch(Exception e){
                recordTypeName = null;
            }
        }else{
            recordTypeName = null;
        }
        return  recordTypeName;
    }
}