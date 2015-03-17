/**
* Class Name: HPQuoteUtils
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Calling from trigger,showing latest 3 versions of Quote
*/
public with sharing class HPQuoteUtils {
    
    /*public static void HPQuoteAfterUpdate(List<HP_Quote__c> oQuoteList,Map<ID,HP_Quote__c> OldQuoteMap){
        if(!HPUtils.alreadyCreatedTasks){
            List<FeedItem> oFeedItemList= new List<FeedItem>();
            for(HP_Quote__c oQuote:oQuoteList){
                if(oQuote.Quote_Status__c=='Quote Complete' && oQuote.Quote_Status__c!=OldQuoteMap.get(oQuote.Id).Quote_Status__c){
                    FeedItem oFeed= new FeedItem();
                    oFeed.ParentId=oQuote.opportunity_Name__c;
                    oFeed.Body= 'Quote : ' + oQuote.Name+ ' status has changed from '+OldQuoteMap.get(oQuote.Id).Quote_Status__c + ' to '+oQuote.Quote_Status__c;
                    oFeedItemList.add(oFeed);                       
                }
            }
            if(!oFeedItemList.isEmpty()){
                insert(oFeedItemList);
                HPUtils.alreadyCreatedTasks = true;
            }
       } 
    }*/
    
    //set hide flag based on Merged quote information
    
    public static void populateHideBasedOnMergedQuoteInformation(List<HP_Quote__c> newQuoteList){
        if(!HPUtils.byPassHPQuoteBeforeTriggers){
            if(!newQuoteList.isEmpty()){
                List<String> listQuoteIDs = new List<String>();
                for(HP_Quote__c objHpQuote : newQuoteList){
                    If(objHpQuote.Quote_IDS_ID__c != '' && objHpQuote.Quote_IDS_ID__c != null){
                        listQuoteIDs.add(objHpQuote.Quote_IDS_ID__c);
                    }
                }
                if(!listQuoteIDs.isEmpty()){
                    systemHideQuote(listQuoteIDs);
                }
            }
        }
        
    }
    
    //@future
    public static void systemHideQuote(List<String> sQuoteIDS_ID){
        HideQuotes(sQuoteIDS_ID);            
    }

   public static void HideQuotes(List<String> sQuoteIDS_ID)
   {
      List<HP_Quote__c> oQuoteList= [SELECT Id,Quote_IDS_ID__c,Merged_Quote_Information__c,Originating_System_Quote_Version__c,
                                        Synced_To_Opportunity__c,Opportunity_ID__c,CreatedDate from HP_Quote__c where Quote_IDS_ID__c in :sQuoteIDS_ID
                                        order by Opportunity_ID__c,Quote_IDS_ID__c,CreatedDate DESC];
      Integer sQuotePageSize= Integer.valueOf(Label.CPQ_QUOTE_SIZE);
      System.debug('*****************Quote Page Size**********'+sQuotePageSize);
      String oldOptyId='';
      String newOptyId='';
      String oldQuoteNum='';
      String newQuoteNum='';
      Integer sVisibleList=0;
      System.debug('*****************Quote List**********'+oQuoteList);
      List<HP_Quote__c> oQuoteFinalList= new List<HP_Quote__c>();
      for(HP_Quote__c oQuote:oQuoteList)
      {
        boolean isChanged=false;
        newOptyId=oQuote.Opportunity_ID__c;
        newQuoteNum=oQuote.Quote_IDS_ID__c;
        System.debug('*****New Quote Num*****'+newQuoteNum+'*****Old Quote Num*****'+oldQuoteNum);
        System.debug('*****New Opty ID*****'+newOptyId+'*****Old Quote Num*****'+oldOptyId);
        if(newOptyId!=oldOptyId||newQuoteNum!=oldQuoteNum)
        {
            
            sVisibleList=0;
        }
        if(oQuote.Synced_To_Opportunity__c)
         {
            oQuote.Hide_Record__c=false;
            sVisibleList++;
            isChanged=true;
            
         }
        else
            {
                System.debug('*****Merging infor*****'+oQuote.Merged_Quote_Information__c+'*****sVisibleList*****'+sVisibleList);
                if(oQuote.Merged_Quote_Information__c!=null||sVisibleList>=sQuotePageSize)
                {
                    oQuote.Hide_Record__c=true;
                    isChanged=true;
                    System.debug('*****************oQuote Modified**********'+oQuote);
                   
                }
                 sVisibleList++;
            }
        
        if(isChanged)
         {
            oQuoteFinalList.add(oQuote);
         }
            
         oldOptyId=newOptyId;
         oldQuoteNum=newQuoteNum;
        
        }
       if(!oQuoteFinalList.isEmpty())
       {
         
         HPUtils.byPassHPQuoteBeforeTriggers = true;
         //update(oQuoteFinalList);
         Database.SaveResult[] updateResult = Database.update(oQuoteFinalList,false);
       }   
       System.debug('*****************oQuoteFinalList**********'+oQuoteFinalList);                                 
   }
   
   
}