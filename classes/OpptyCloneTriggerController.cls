/**********************************************************
* Class Name: OpptyCloneTriggerController
* Author: HP
* Date: 25-Jan-2013
* Requirement # Request Id: # 4419
* Release: R4.0
* Description: This class is a controller class for Opportunity trigger which drives
* the Clone Button functionality.
*************************************************************/

public class OpptyCloneTriggerController{
    public static void opptyCloneTrigCon(String nextChange, String opptyID){
        String oppID;
       // String oppCompetitorsID;
        List<Channel_Partner__c> channelPartner_new = new List<Channel_Partner__c>();
        List<Competitors__c> competitors_new = new List<Competitors__c>(); 
        List<OpportunityLineItem> OLI_new = new List<OpportunityLineItem>();
        
        oppID = nextChange.subString(0,15);
        
        if(nextChange.contains('Partner')){
        //add all current opportunity's parners to the new opportunity
            oppID = nextChange.subString(0,15); 
            System.debug('****************oppID'+oppID);
            for (Channel_Partner__c cp :  [Select Id,Name,Opportunity__c,
                                                Channel_Partner__c,
                                                Location__c,
                                                Partner_Account_Role__c,
                                                Partner_Status__c,Partner_Type__c,Primary__c,Regions__c 
                                                from Channel_Partner__c where Opportunity__c =:oppID]){
                Channel_Partner__c newCp = cp.clone(false, true);
                newCp.Opportunity__c = opptyID;
                channelPartner_New.add(newCp);
            }
            if (channelPartner_New.size()>0){
                insert channelPartner_New;
            }
        }
        if(nextChange.contains('Competitor')){
        //add all current opportunity's competitors to the new opportunity
            //oppCompetitorsID = nextChange.subString(0,15); 
            System.debug('****************oppID'+oppID);
            for (Competitors__c comp : [Select Id,Name,Opportunity__c,
                                            Competitor_Account__c,Competitor_Name__c,Incumbent__c,Primary__c 
                                            from Competitors__c where Opportunity__c =:oppID]){
                Competitors__c newComp = comp.clone(false, true);
                newComp.Opportunity__c = opptyID;
                competitors_new.add(newComp);
            }
            if (competitors_new.size()>0){
                insert competitors_new;
            } 
        }
        
         if(nextChange.contains('Product')){
        //add all current opportunity's Active Products to the new opportunity
            //oppCompetitorsID = nextChange.subString(0,15); 
            System.debug('****************oppID Product'+oppID);
            for (OpportunityLineItem OLI : [SELECT ServiceDate,Legacy_Ref_Id__c,PricebookEntry.Product2Id,PricebookEntry.Product2.IsActive,
            PricebookEntry.Product2.Business_Group__c,PricebookEntry.Product2.GBU__c,PricebookEntry.Product2.Product_Line__c,PricebookEntry.Product2.Sub_Product_Line__c,Quantity,UnitPrice,First_12_Month_Value__c, First_Fiscal_Year_Value__c,Margin_Amount__c
            FROM OpportunityLineItem where OpportunityId =: oppID AND PricebookEntry.Product2.IsActive =TRUE]){
               System.debug('*******Product*********'); 
                OpportunityLineItem newOLI = OLI.clone(false, true);
                newOLI.OpportunityId = opptyID;
                newOLI.Legacy_Ref_Id__c = NULL;
                OLI_new.add(newOLI);
            }
            System.debug('****************OLI_new'+oppID);
            if (OLI_new.size()>0){
                insert OLI_new;
            } 
        }
    }
}