/*
* Class Name: OpportunityTriggerController
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Opportunity object
*/
public class OpportunityTriggerController{
    
    /*
    * @description: Action Before Opportunity Insert 
    * 
    * 
    */
    public Static Boolean isOpportunityInsert=false;
    public static void beforeInsert(list<opportunity> newOpptyList ){
        isOpportunityInsert=true;
        // TM: Debmalya: Req-1619 Oct 09, 2012:check flag Opportunity Outside Owner's Territory - Start
        if(newOpptyList.size() == 1){
            String oppownerterr = CheckUserAccountTerritory.userAccountTerritoryMatch(newOpptyList[0].AccountId, newOpptyList[0].OwnerId);
            newOpptyList[0].Opportunity_Outside_Owner_s_Terr__c = oppownerterr.equals('true');
        }
        system.debug('List of opp sent '+newOpptyList);
        OpportunityTriggerUtil.updatingWithPriceBookId(newOpptyList);
        // TM: Debmalya: Req-1619 Oct 09, 2012:check flag Opportunity Outside Owner's Territory - End
        //OpportunityTriggerUtil.OppNameAccNameUnique(trigger.new);
        //OpportunityTriggerUtil.updateOwner(trigger.new);
    }
    public static void neverBypassMethod(){
         OpportunityTriggerUtil.updateOwner(trigger.new);
    }

    
    /*
    * @description: Action Before Opportunity Update 
    * 
    * 
    */
    public static void beforeUpdate(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap){

        OpportunityTriggerUtil.checkIsMarketingAdminProfile(optyOldMap,optyNewMap);
        
        /********** OMPM Renewal R3.0 Owner: Deepak Saxena*************************
        ***********Commented Out by Deepak Saxena as new Validation Rules *********
        ***********have been created for this requirement with Custom Settings*****
        **************************************************************************/
        //OpportunityTriggerUtil.checkProductHierarchyLevel(optyOldMap,optyNewMap);
        
        /********* OMPM Renewal R4.0 EF Owner: Deepak Saxena ****Open*****************/
        for(Opportunity o : optyNewMap.values()){
            if(o.Renewal_Type__c != optyOldMap.get(o.Id).Renewal_Type__c){
                if(o.Renewal_Type__c == 'SW Renewal'){
                    o.Renewal_Sub_Type__c = 'Standard';
                    o.TS_PROP__c = False;
                    o.TS_Multinational__c = False;
                    o.TS_Multi_BG__c = False;
                }
                else{
                    o.SW_ELA__c = False;
                    o.SW_Premier__c = False;
                    o.SW_Push_To__c = False;
                    
                }
            }
            
            if(o.Renewal_Sub_Type__c != optyOldMap.get(o.Id).Renewal_Sub_Type__c){
                if(o.Renewal_Sub_Type__c == 'Standard'){
                    o.TS_PROP__c = False;
                    o.TS_Multinational__c = False;
                    o.TS_Multi_BG__c = False;
                }
            }
        
        }
        
        /********* OMPM Renewal R4.0 EF Owner: Deepak Saxena ****Closed*****************/
        OpportunityTriggerUtil.checkLineItemShipDate(optyOldMap,optyNewMap);
         //PRM:Amala R4:Req:4091- Start
         /**
         * @description: Commented this fuctionality and implemented same in OpportunityOwnerChangeExtn Class
         */
         //OpportunityTriggerUtil.addingISRtoOpptySalesTeam(optyNewMap,optyOldMap);
         //PRM:Amala R4:Req:4091- Stop
        OpportunityTriggerUtil.partnerPortalForcastChangeToUpside(optyOldMap, optyNewMap.values());
        //OpportunityTriggerUtil.updateOwner(trigger.new);
        
        /*
        * Author: Accenture
        * Date: 24-JUL-2012
        * Modification: Added method call to update 'opportunity' and 'strike count track' fields when an opportunity is assigned to a partner
        */
        
        PartnerCollabOpportunityUtil.OpptyUpdate(optyOldMap, optyNewMap);        
    }
    
   /* R4.0 - Populate 'Go To Market Route' field */ 
    
 public static void addGoToMarketRoute1(List<opportunity> optynewlist){
 system.debug('**********optynewlist***'+optynewlist);
  For(Opportunity opp: optynewlist)
     if(opp.Customer_Engagement__c=='End User Sales' && opp.Fulfillment__c =='HP Fulfilled' || opp.Customer_Engagement__c=='End User Sales' && opp.Fulfillment__c =='VSI Fulfilled' || opp.Customer_Engagement__c=='Alliance' && opp.Fulfillment__c =='HP Fulfilled' || opp.Customer_Engagement__c=='OEM' && opp.Fulfillment__c =='HP Fulfilled' || opp.Customer_Engagement__c=='OEM' && opp.Fulfillment__c =='VSI Fulfilled')
        opp.Route_To_Market__c='Direct';
              else if(opp.Customer_Engagement__c=='End User Sales' && opp.Fulfillment__c =='Channel Fulfilled' || opp.Customer_Engagement__c=='Alliance' && opp.Fulfillment__c =='Channel Fulfilled' || opp.Customer_Engagement__c=='OEM' && opp.Fulfillment__c =='Channel Fulfilled' || opp.Customer_Engagement__c=='Reseller' && opp.Fulfillment__c =='HP Fulfilled' || opp.Customer_Engagement__c=='Reseller' && opp.Fulfillment__c =='Channel Fulfilled')
                 opp.Route_To_Market__c='Indirect';
                 else
                   opp.Route_To_Market__c='';
            }        
  
  
    public static void addGoToMarketRoute(List<opportunity> optyList,Map<id,opportunity> optyoldmap){
    system.debug('**********optynewlist***'+optyList+'***optyoldmap******'+optyoldmap);
    List<Opportunity> listOpportunity = new List<Opportunity>();
     For(Opportunity opp: optyList){
         if(optyoldmap != null){
        if(opp.Customer_Engagement__c != optyoldmap.get(opp.id).Customer_Engagement__c || opp.Fulfillment__c != optyoldmap.get(opp.id).Fulfillment__c ){
           listOpportunity.add(opp);
         }
        }
        else{
           listOpportunity.add(opp); 
        }
  }
   if(!listOpportunity.isEmpty()){
       addGoToMarketRoute1(listOpportunity);
   } 
         
}
 //Getting opportunities with partner ownerids
  
 public static void partnerOpptyFiledsDefulat(List<opportunity> optyList){
   List<id> userIdList=new List<id>();
    for(Opportunity oppty:optyList){
        userIdList.add(oppty.ownerId);
    }
    List<User> partnerIUserList=[Select id from User where id in:userIdList and isPortalEnabled=true];
    Set<Id> partnerIdSet=new Set<Id>();
    for(User partnerUser:partnerIUserList){
        partnerIdSet.add(partnerUser.id);
    }
    for(Opportunity oppty:optyList){
        if(partnerIdSet.contains(oppty.ownerId)){
            if(null==oppty.Customer_Engagement__c && null==oppty.Fulfillment__c ){
                oppty.Customer_Engagement__c='Reseller';
                oppty.Fulfillment__c='Channel Fulfilled';
                oppty.Route_To_Market__c='Indirect';
            }
        }
    }
 }
}