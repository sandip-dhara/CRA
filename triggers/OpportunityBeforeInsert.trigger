/**
* 10-12-12 Abrar - Consolidated OpportunityBeforeInsert,DealRegOpptyBeforeInsertManagedByField,
  RenewalForecastCategoryCommit and OpportunityBlacklisting
* Class Name: OpportunityBeforeInsert
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Calls Before Insert support action methods for trigger on opportunity object
*/
trigger OpportunityBeforeInsert on Opportunity (before insert) {

/*** R4.0 Populate Go to Market Route *****/
    
    system.debug('******Trigger.newmap****'+Trigger.newmap);
    system.debug('******Trigger.newmap****'+Trigger.new);
         
    //OpportunityTriggerController.addGoToMarketRoute1(Trigger.new); 
       
    /*******/

    OpportunityTriggerController.neverBypassMethod();
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            OpportunityTriggerController.addGoToMarketRoute1(Trigger.new); 
            return; 
        }
    }
    
//quang.vu@hp.com, 10/30/2012
//if triggered by HPFS engagement on old opportunity, skip trigger
    if (OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }   
    
/* Desc : -PRM Team- Trigger to set Managed By field for Partner created Opportunity  */    
         //User partnerUser=[select id, name,IsportalEnabled,Partner_account_ID__c, Business_Group__c, User_Type_Text__c from user where id=:UserInfo.getUserId()]; 
         if(HPUtils.partnerUser.IsportalEnabled==true){
         for(opportunity oppty:trigger.new){
         oppty.Managed_By__c='Partner';
         oppty.Customer_Engagement__c='Reseller';
         oppty.Fulfillment__c='Channel Fulfilled';
         oppty.Route_To_Market__c='Indirect';
         }
       }
         else{
         for(opportunity opp:trigger.new)
         opp.Managed_By__c='HP';
         }
/* Desc : -PRM Team-END of code of Trigger to set Managed By field for Partner created Opportunity  */          
            
/* Desc : Trigger for Opportunity Blacklisting of blacklisted Words. */
            OpportunityBlacklisting obj=new OpportunityBlacklisting();
                //String usertype=User.User_Type_Text__c;
                //String usertype=UserInfo.getUser_Type_Text__c();
                //User u=[Select id,Business_Group__c, User_Type_Text__c From User Where id=:UserInfo.getUserId()];
                for(Opportunity o: trigger.new){
                    if(HPUtils.partnerUser.User_Type_Text__c == 'PARTNER'){
                        o.Last_Modified_by_Partner__c= DateTime.now();
                    }
                }
                if(Trigger.isInsert)
                obj.filterwords(Trigger.new);
                
/* Opportunity Blacklisting Code Ends */
                
                
/**
* Class Name: OpportunityBeforeInsert
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id: 
* Description: Calls Before Insert support action methods for trigger on opportunity object
*/       
/************* OMPM Renewal R3.0 Owner: Deepak Saxena*********Open****************/
    //List<Id> recordTypeIds= new List<Id>();
    //for(Opportunity opp:trigger.new)
    //    recordTypeIds.add(opp.RecordTypeId);
    
    //Map<Id,RecordType> recordtypeMap= new Map<Id,RecordType>([Select id, Name From RecordType Where id IN :recordTypeIds ]);
    Id RenewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    Id HPFSRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    Id StandardRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
    Id PartnerDealRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Partner Deal').getRecordTypeId();
    
    //System.debug('???????'+RenewalRecordTypeId +'????????'+HPFSRecordTypeId+'????????????'+StandardRecordTypeId+'???????'+PartnerDealRecordTypeId);
    for(Opportunity opp:trigger.new){
        //RecordType recordtype= recordTypeMap.get(opp.RecordTypeId);
        if(opp.RecordTypeId != null){
          if(opp.RecordTypeId == HPFSRecordTypeId)
            opp.Record_Type_Name__C='HPFS';
          else if(opp.RecordTypeId == RenewalRecordTypeId)
            opp.Record_Type_Name__C='Renewal';
            else if(opp.RecordTypeId == StandardRecordTypeId)
              opp.Record_Type_Name__C='Standard';
              else if(opp.RecordTypeId == PartnerDealRecordTypeId)
                opp.Record_Type_Name__C='Partner Deal';
        }      
            
    }
    
/************* OMPM Renewal R3.0 Owner: Deepak Saxena*********Close****************/
  
    OpportunityTriggerController.beforeInsert(trigger.new); 
            
  /**
  * Trigger Name: RenewalForecastCategoryCommit 
  * Release : HP R2
  * Author: Accenture
  * Date:  
  * Requirement # Request Id: CR-0177 
  * Description: Calls before update on opportunity object & check if Opportunity is Renewal opportunity
  *              then for Sales 1 &2 Forecast category value should be "Pipeline" and for rest sales stage value should be "Commit".
  */
  Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    for (Opportunity opp : Trigger.new){
    
        if(opp.RecordTypeId  == RecordTypeId && HPUtils.partnerUser.Business_Group__c != 'ES'){ 
             opp.ForecastCategoryName = 'Commit';
             opp.StageName = '03 - Qualify the Opportunity';
             opp.Type = 'Renewal';
/************* OMPM Renewal R4.0 Foundation Work Owner: Deepak Saxena*********Open****************/              
             if(opp.Fulfillment__c == null)
                opp.Fulfillment__c = 'HP Fulfilled';
                
/************* OMPM Renewal R4.0 Foundation Work Owner: Deepak Saxena*********Close****************/
                
        }
        system.debug('*******BG*********'+HPUtils.partnerUser.Business_Group__c);
       if(opp.Type == 'Renewal' && opp.StageName != '03 - Qualify the Opportunity' && HPUtils.partnerUser.Business_Group__c != 'ES'){
             opp.ForecastCategoryName = 'Commit';
             opp.StageName = '03 - Qualify the Opportunity';
             
/************* OMPM Renewal R4.0 Foundation Work Owner: Deepak Saxena*********Open****************/              
             if(opp.Customer_Engagement__c == null)
                opp.Customer_Engagement__c = 'End User Sales';
             
             if(opp.Fulfillment__c == null)
                opp.Fulfillment__c = 'HP Fulfilled';
                
             if(opp.Managed_By__c == null)
                opp.Managed_By__c = 'HP';
                
/************* OMPM Renewal R4.0 Foundation Work Owner: Deepak Saxena*********Close****************/             
           }
        }    
        
        OpportunityTriggerController.addGoToMarketRoute1(Trigger.new);         
            
}