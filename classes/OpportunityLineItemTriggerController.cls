/**
* Class Name: OpportunityLineItemTriggerController
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id:
* Description: Contains support action methods for trigger on Opportunity Line Item object
*/
public with sharing class OpportunityLineItemTriggerController {
    /*
    * @description: Method to identify Opportunities with Multi BG products on it &
    *               update 'Has Multi BG Products' field on Opportunity
    */
    public Static Boolean isProductInsert=false;
    public static void identifyOpptyWithMultiBGProducts
        (List<OpportunityLineItem> opportunityLineItems, Boolean deleteFlag) {
        Set<ID> oppIds = New Set<ID>();
        List<OpportunityLineItem> listExistingLineItems = new List<OpportunityLineItem>();
        Map<string,Set<string>> opptyIdbyExistingProductsBGMap = new Map<string,Set<string>>();
        Map<string,Set<string>> opptyIdbyNewProductsBGMap = new Map<string,Set<string>>();
        Map<ID,Opportunity> opptysByIdMap = New Map<ID,Opportunity>(); 
        List<Opportunity> listOpptys = new List<Opportunity>();
        
        for(OpportunityLineItem o : opportunityLineItems){
            oppIds.add(o.OpportunityID);
            if (opptyIdbyNewProductsBGMap.containsKey(o.opportunityid)) {
                 Set<string> setNewTempBG = new Set<string>();
                 setNewTempBG = opptyIdbyNewProductsBGMap.get(o.opportunityid);
                 setNewTempBG.add(o.Business_Group__c);
                 opptyIdbyNewProductsBGMap.put(o.opportunityid,setNewTempBG);   
            }else {
                 Set<string> setNewProductsBG = new Set<string>();
                 setNewProductsBG.add(o.Business_Group__c);
                 opptyIdbyNewProductsBGMap.put(o.opportunityid,setNewProductsBG);
            }
        }
        listOpptys = [Select Id, has_Multi_BG_Products__c From Opportunity Where ID IN :oppIds];
        
            for(Opportunity opp : listOpptys){
            opptysByIdMap.put(opp.Id,opp);    
            }    
        
            
        listExistingLineItems = [Select opportunityid, Business_Group__c
                                 from OpportunityLineItem 
                                 where opportunityid in :oppIds];
                                 
        for(OpportunityLineItem oli: listExistingLineItems){
        
            if (opptyIdbyExistingProductsBGMap.containsKey(oli.opportunityid)) {
                 Set<string> setTempBG = new  Set<string>();
                 setTempBG = opptyIdbyExistingProductsBGMap.get(oli.opportunityid);
                 setTempBG.add(oli.Business_Group__c);
                 opptyIdbyExistingProductsBGMap.put(oli.opportunityid,setTempBG);   
            }else {
                 Set<string> setProductsBG = new  Set<string>();
                 setProductsBG.add(oli.Business_Group__c);
                 opptyIdbyExistingProductsBGMap.put(oli.opportunityid,setProductsBG);
            }                                       
        }
        Map<string,Set<string>> finalOpptyIdbyProductsBGMap = new Map<string,Set<string>>();
        Set<string> finalSetTempBG = new  Set<string>();
        
        
        for(Id opptyId : oppIds) {
            finalSetTempBG = opptyIdbyExistingProductsBGMap.get(opptyId);
            if (!deleteFlag) {
                if(finalSetTempBG != null){
                    finalSetTempBG.addAll(opptyIdbyNewProductsBGMap.get(opptyId));
                }else {
                    finalSetTempBG = opptyIdbyNewProductsBGMap.get(opptyId);    
                }
            }
            if(finalSetTempBG != null && finalSetTempBG.size() > 1){
                opptysByIdMap.get(opptyId).has_Multi_BG_Products__c = true;
            } else{
                try {
                    opptysByIdMap.get(opptyId).has_Multi_BG_Products__c = false;
                    }
                catch (exception ex){
                    system.debug('error on opptysByIdMap.get ' + ex.getMessage());
                }
            }
        }
        try {
            update opptysByIdMap.values();
        } catch (Exception ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'OpportunityLineItem', 'OpportunityLineItemTriggerController', 'class');
        }
        
    }
    
     /*
    * @description: cleans legacy ref id while cloning opportunity 
    */
    private static void cleanLegacyRefID(){
        if(OpportunityTriggerController.isOpportunityInsert==true){
            for(OpportunityLineItem lineitem :(List<OpportunityLineItem>)trigger.new){
                lineitem.Legacy_Ref_Id__c ='';
            }
        }
    }
    
    /*
    * @description: Action Before Opportunity Product Insert 
    */
    public static void beforeInsert() {
              /* 27/07/12 Abrar: Changed Book Ship Date logic per Business Request to fix ALM 1116 as per tony's Update(IM14369825)
              *  Modify rule to: if Oppty Not Closed then Book Ship Date Month must be greater than current Month 
              */
              System.debug('???????????? in before insert');
       isProductInsert=true;
       cleanLegacyRefID();
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        Boolean deleteFlag;
        deleteFlag = false;
        opportunityLineItems = trigger.new;
        /*@ Description: Comment the book/ship date error logic as per R4.0-4302 requirement 
       /* Date todaysDate = System.today(); */
        /*  for(OpportunityLineItem objOLI:(List<OpportunityLineItem>)trigger.new){
            
              if((objOLI.OpportunityStage__c== Label.Validate_Opportunity || 
              objOLI.OpportunityStage__c== Label.Understand_Customer || 
              objOLI.OpportunityStage__c== Label.Develop_Solution ||                    
              objOLI.OpportunityStage__c== Label.Qualify_Opportunity ||
              objOLI.OpportunityStage__c== Label.Propose_Solution ||
              objOLI.OpportunityStage__c== Label.Negotiate_And_Close
              )&& 
              (objOLI.serviceDate<objOLI.Opportunity_Close_Date__c) && 
              /* commenting the fix code of ALM 1116 as this was taken care as part of R2 */
              /*(objOLI.serviceDate.year()<todaysDate.year() ||
              (objOLI.serviceDate.year()==todaysDate.year() &&
              objOLI.serviceDate.month()<todaysDate.month())) &&
              (OpportunityTriggerController.isOpportunityInsert==false)){
                  objOLI.addError(Label.Ship_Date_Error);
              }
         }*/
         
        identifyOpptyWithMultiBGProducts(opportunityLineItems,deleteFlag);
    }
    /*
    * @description: Action Before Opportunity Product Update 
    */
    public static void beforeUpdate () {
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        Boolean deleteFlag;
        deleteFlag = false;
        opportunityLineItems = trigger.new;
        
        for(OpportunityLineItem objOLI:(List<OpportunityLineItem>)trigger.new){
             // system.debug('###########objOLI.OpportunityStage__c############'+objOLI.OpportunityStage__c);
             // system.debug('###########Label.Validate_Opportunity############'+Label.Validate_Opportunity);
             // system.debug('###########Label.Understand_Customer############'+Label.Understand_Customer);
             // system.debug('###########Label.Develop_Solution############'+Label.Develop_Solution);
             // system.debug('###########Label.Qualify_Opportunity############'+Label.Qualify_Opportunity);
             // system.debug('###########Label.Propose_Solution############'+Label.Propose_Solution);
             // system.debug('###########Label.Negotiate_And_Close############'+Label.Negotiate_And_Close);
             // system.debug('###########objOLI.serviceDate############'+objOLI.serviceDate);
             // system.debug('###########objOLI.Opportunity_Close_Date__c############'+objOLI.Opportunity_Close_Date__c);
             // system.debug('###########OpportunityTriggerController.isOpportunityInsert############'+OpportunityTriggerController.isOpportunityInsert);
              /* 27/07/12 Abrar: Changed Book Ship Date logic per Business Request to fix ALM 1116 as per tony's Update(IM14369825)
              *  Modify rule to: if Oppty Not Closed then Book Ship Date Month must be greater than current Month 
              */
              /*Date todaysDate = System.today();*/
              
              if((objOLI.OpportunityStage__c== Label.Validate_Opportunity || 
              objOLI.OpportunityStage__c== Label.Understand_Customer || 
              objOLI.OpportunityStage__c== Label.Develop_Solution ||                    
              objOLI.OpportunityStage__c== Label.Qualify_Opportunity ||
              objOLI.OpportunityStage__c== Label.Propose_Solution ||
              objOLI.OpportunityStage__c== Label.Negotiate_And_Close
              )&& 
              (objOLI.serviceDate<objOLI.Opportunity_Close_Date__c) &&
             /* commenting the fix code of ALM 1116 as this was taken care as part of R2 */
             /* (objOLI.serviceDate.year()<todaysDate.year() ||
              (objOLI.serviceDate.year()==todaysDate.year() &&
              objOLI.serviceDate.month()<todaysDate.month())) && */
              (OpportunityTriggerController.isOpportunityInsert==false)){
                  objOLI.addError(Label.Ship_Date_Error);
              }
         }
        
        //identifyOpptyWithMultiBGProducts(opportunityLineItems,deleteFlag);
    }
    /*
    * @description: Action After Opportunity Product Delete 
    */
    public static void afterDelete() {
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        Boolean deleteFlag;
        deleteFlag = true;
        opportunityLineItems = trigger.old;
        identifyOpptyWithMultiBGProducts(opportunityLineItems,deleteFlag);
    }
    /*
    * @description: Method to obtain values of opportunity line item
    *             before deleting it.  
    */
   public static void beforeDelete(){  
      List<Opportunity_Product_Delete_Capture__c> opptyproductdeletelist = new List<Opportunity_Product_Delete_Capture__c>();
      List<OpportunityLineItem> opptylineitemlist = (List<OpportunityLineItem>)Trigger.old;  
     
      for(OpportunityLineItem opptylineitem : opptylineitemlist){
         Opportunity_Product_Delete_Capture__c opptyproductlist = new Opportunity_Product_Delete_Capture__c();
         opptyproductlist.Business_Group__c = opptylineitem.Business_Group__c;
         opptyproductlist.Date__c = opptylineitem.ServiceDate;
         opptyproductlist.Discount__c = opptylineitem.Discount;
         opptyproductlist.GBU__c = opptylineitem.GBU__c;
         opptyproductlist.Legacy_Ref_Id__c = opptylineitem.Legacy_Ref_Id__c;
         opptyproductlist.Line_Description__c = opptylineitem.Description;
         opptyproductlist.List_Price__c = opptylineitem.ListPrice;
         opptyproductlist.Opportunity_Close_Date__c = opptylineitem.Opportunity_Close_Date__c;
         opptyproductlist.Opportunity_ID__c = opptylineitem.OpportunityId; 
         opptyproductlist.Opportunity_ID_Auto__c = opptylineitem.OpportunityID__c;
         opptyproductlist.Product_PIL_ID__c = opptylineitem.ProductId__c;
         opptyproductlist.Product_ID__c = opptylineitem.Id;
         opptyproductlist.Quantity__c = opptylineitem.Quantity;
         opptyproductlist.Sales_Price__c = opptylineitem.UnitPrice;
         opptyproductlist.Sub_Total__c = opptylineitem.Subtotal;
         opptyproductlist.Total_Price__c = opptylineitem.TotalPrice;
         opptyproductlist.User__c = opptylineitem.LastModifiedById;
         /* Devi Sudhakaran-Added additional fields on 05/08/2013 START*/
         opptyproductlist.Deleted_Record_Id__c = opptylineitem.Id;
         opptyproductlist.Deleted_Record_Parent_Id__c = opptylineitem.OpportunityId; 
         opptyproductlist.Deleted_Record_Object_Type__c = 'OpportunityLineItem';
         /* Added additional fields on 05/08/2013*/
         opptyproductdeletelist.add(opptyproductlist);
      }
        try{
             insert opptyproductdeletelist;
           }
       catch(Exception ex) {                    
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'OpportunityLineItem', 'OpportunityLineItemTriggerController', 'Trigger');               
           }   
     }
}