/**********************************************************
* Class Name: SupportRequestTriggerController
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Contains support action methods for trigger on Support_Request__c object
***********************************************************/
public class SupportRequestTriggerController{
    /**
    * @description: Action Before Support_Request__c Insert 
    * @return : Void
    * 
    */
    public Static void beforeInsert(){
        Set<id> setOptyIds = SupportRequestRoutingRulesTriggerUtil.setOptyIds(trigger.New);
        SupportRequestRoutingRulesTriggerUtil.populateRoutingFields(trigger.New,setOptyIds);
        Map<Id,RecordType> recordTypeMap = SupportRequestRoutingRulesTriggerUtil.qryRecordTypeMap(trigger.New);
        Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap = SupportRequestRoutingRulesTriggerUtil.formNameWithSRequestCSMap();
        SupportRequestRoutingRulesTriggerUtil.populateSupportTypeNSubType(trigger.New,recordTypeMap,formNameWithSRequestCSMap);
        SupportRequestRoutingRulesTriggerUtil.checkNChangeRecordTypeifBGChanged(trigger.New,recordTypeMap,formNameWithSRequestCSMap);
        Map<Id,Opportunity> opportunityMap = SupportRequestRoutingRulesTriggerUtil.qryOpportunityMap(trigger.New);
        SupportRequestRoutingRulesTriggerUtil.populateCurrencyIsoCode(trigger.New,opportunityMap);
    }
    
    /**
    * @description: Action Before Support_Request__c Update
    * @return : Void
    * 
    */
    public Static void beforeUpdate(){
        Set<id> setOptyIds = SupportRequestRoutingRulesTriggerUtil.setOptyIds(trigger.New);
        SupportRequestRoutingRulesTriggerUtil.populateRoutingFields(trigger.New,setOptyIds);
        Map<Id,RecordType> recordTypeMap = SupportRequestRoutingRulesTriggerUtil.qryRecordTypeMap(trigger.New);
        Map<String,Support_Request_FS_CS__c> formNameWithSRequestCSMap = SupportRequestRoutingRulesTriggerUtil.formNameWithSRequestCSMap();
        SupportRequestRoutingRulesTriggerUtil.checkNChangeRecordTypeifBGChanged(trigger.New,recordTypeMap,formNameWithSRequestCSMap);
        Map<Id,Opportunity> opportunityMap = SupportRequestRoutingRulesTriggerUtil.qryOpportunityMap(trigger.New);
        SupportRequestRoutingRulesTriggerUtil.populateCurrencyIsoCode(trigger.New,opportunityMap);
    }  
    /**
    * @description: Action After Support_Request__c Insert
    * @return : Void
    * 
    */
     public Static void beforeInsertForContRole(List<Support_Request__c> supportRequestList){
         List<Id> opptyIds =new List<Id>();
         for(support_request__c support : supportRequestList){
            opptyIds.add(support.Opportunity__c);
            }
    List<OpportunityContactRole> OpptyContRoleList=[select contactId,opportunityId From OpportunityContactRole where OpportunityId IN:opptyIds and IsPrimary=true];
        for(support_request__c supportReq :supportRequestList){
         if(supportReq.Sub_Type__c=='Legal' && supportReq.Support_Type__c=='Functional Support' && supportReq.RecordTypeId==Schema.SObjectType.Support_Request__c.getRecordTypeInfosByName().get('FunctionalSupport-Legal').getRecordTypeId()){
            for(OpportunityContactRole oCRole : OpptyContRoleList){
                if(supportReq.Opportunity__c==oCRole.opportunityId){
                    supportReq.PrimaryContact__c=oCRole .contactId;
                    }
                }
            }
        }
     }
      /**
    * @description: Global account is checking accoriding to the conditions.
    * @return : Void
    * 
    */
    public Static void beforeInsertForGlobalAcct(List<Support_Request__c> supportRequestNewList){
       List<id> opptyIds=new List<id>();
       Map<Support_Request__c,id> supportOpptyMap=new Map<Support_Request__c,id>();
       Map<id,id> opptyAccMap=new Map<id,id>();
       Map<Support_Request__c,id> supportAccMap=new Map<Support_Request__c,id>();
       Map<Support_Request__c,List<BG_Account_Data__c>> supportBGAccMap=new Map<Support_Request__c,List<BG_Account_Data__c>>();
       List<Support_Request__c> updateSRList=new List<Support_Request__c>();
       List<Id> accountList = new List<Id>();       
       for(Support_Request__c supp:supportRequestNewList){
          opptyIds.add(supp.Opportunity__c);
          supportOpptyMap.put(supp,supp.Opportunity__c);
       }
       system.debug('a1b'+supportOpptyMap);
       List<Opportunity> opptyList=[select id,accountid from Opportunity where id IN:opptyIds];
       for(Opportunity opp:opptyList){
         opptyAccMap.put(opp.id,opp.accountid);
         accountList.add(opp.accountid);
       }
       system.debug('a1c'+opptyAccMap);
       for(Support_Request__c supportreqst : supportOpptyMap.keySet()){
          for(id oppty: opptyAccMap.keySet()){
             if(supportOpptyMap.get(supportreqst)==oppty){
               supportAccMap.put(supportreqst,opptyAccMap.get(oppty));
             }
          }
       }
       system.debug('a1d'+supportAccMap);
       List<BG_Account_Data__c> bgAcctData=[select BG__c,account__c,Focus_Account_Indicator__c,Global_Account_Indicator__c,Top_Account_Indicator__c from BG_Account_Data__c where Account__c IN :accountList];
       System.debug('a1h'+bgAcctData);
       for(Support_Request__c SR: supportAccMap.keyset()){
           for(BG_Account_Data__c bGAcc : bgAcctData){
             if(bGAcc.account__c==supportAccMap.get(SR)){
                if(supportBGAccMap.containsKey(SR)){
                    supportBGAccMap.get(SR).add(bGAcc);
                    }
                else{
                    supportBGAccMap.put(SR,new List<BG_Account_Data__c>());
                    supportBGAccMap.get(SR).add(bGAcc);
                }
             }
           }
       }
       system.debug('a1e'+supportBGAccMap);
       for(Support_Request__c supportBGAccMapVar:supportBGAccMap.keyset()){
            for(BG_Account_Data__c bGAcct: supportBGAccMap.get(supportBGAccMapVar)){
              system.debug('a1f'+bGAcct);
            if(((supportBGAccMapVar.Owner_s_BG__c=='EG' || supportBGAccMapVar.Owner_s_BG__c=='ESSn') && (bGAcct.BG__c=='EG' || bGAcct.BG__c=='ESSN') && (bGAcct.Global_Account_Indicator__c=='Y')) || (supportBGAccMapVar.Owner_s_BG__c=='ES' && bGAcct.BG__c=='ES' && bGAcct.Focus_Account_Indicator__c=='Y') || (supportBGAccMapVar.Owner_s_BG__c=='PPS' && bGAcct.BG__c=='PPS' && bGAcct.Global_Account_Indicator__c=='Y') || (supportBGAccMapVar.Owner_s_BG__c=='SW' && bGAcct.BG__c=='SW' && bGAcct.Top_Account_Indicator__c=='Y') || (supportBGAccMapVar.Owner_s_BG__c=='HPFS' && bGAcct.BG__c=='HPFS' && bGAcct.Top_Account_Indicator__c=='Y')){
               supportBGAccMapVar.Global_Account_Affiliation__c=true;
               system.debug('a1a'+supportBGAccMapVar.Global_Account_Affiliation__c);
                }
           /* if(supportBGAccMapVar.Owner_s_BG__c=='ES' && bGAcct.BG__c=='ES' && bGAcct.Focus_Account_Indicator__c=='Y'){
               supportBGAccMapVar.Global_Account_Affiliation__c=true;
               system.debug('a1a'+supportBGAccMapVar.Global_Account_Affiliation__c);
          }   */      
       }
     }
    }    
   }