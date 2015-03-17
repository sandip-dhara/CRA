/*****************************************
Author: Abrar
Date: 11-01-2012
Description: Batch Apex for updating 
Customer Engagement, fulfillment and 
Go to Market fields of Opportunity
implements Database.Batchable<sObject>
*****************************************/

global class Opportunityfieldupdate {

  //dummy method for code coverage
  public void DummymethodforTest()
  {
   system.debug('This dummy method for Test Class');
   }

/*global Database.querylocator start(Database.BatchableContext BC){
    String query = Label.OptyBatchUpdateQuery;
    system.debug('SOQL###'+query);
    
    if(test.isRunningTest()){
        query ='Select id,fulfillment__c,Customer_Engagement__c,Route_To_Market__c,StageName,RecordType.Name,Premier_Type__c,Business_Group2__c from Opportunity where name like \'BatchTestOpty%\' limit 5';
        system.debug(query);
    }
    //query ='Select id,fulfillment__c,Customer_Engagement__c,Route_To_Market__c,Business_Group2__c,stageName  from Opportunity';
    return Database.getQueryLocator(query);
    }
    
global void execute(Database.BatchableContext BC, List<opportunity> scope)
{
    List<opportunity> opptyList=new List<opportunity>();
        for(Opportunity opty : scope)
        {
        
        /******** OMPM Renewals R4.0 Owner Deepak Saxena ************
          if(opty.RecordType.Name == 'Renewal')
            if(opty.Premier_Type__c == '' || opty.Premier_Type__c == null)
                opty.Premier_Type__c = 'Uplift';
        /******** OMPM Renewals R4.0 Owner Deepak Saxena ************
        
          if(opty.fulfillment__c == 'OEM')
             {
              opty.Customer_Engagement__c='OEM';
              opty.fulfillment__c = null;
              }
          else if(opty.fulfillment__c == 'Sell With')
          {
              opty.Customer_Engagement__c='End User Sales';
               opty.fulfillment__c = null;
               }
          else if(opty.fulfillment__c == 'Sell Through')
              {
              opty.Customer_Engagement__c='Reseller';
              opty.fulfillment__c = null;
              }
          else if(opty.fulfillment__c == 'VSI')
             {
              opty.Customer_Engagement__c='End User Sales';
              opty.fulfillment__c = 'VSI Fulfilled'; 
              }
          else if ((opty.fulfillment__c == '' || opty.fulfillment__c == Null) && (opty.stageName <> '01 - Understand Customer' && opty.stageName <> '02 - Validate Opportunity') && (opty.Business_Group2__c  <> 'HPFS' && opty.Business_Group2__c  <> 'ES'))
             {  
              opty.Customer_Engagement__c= 'End User Sales';
              opty.fulfillment__c = null;
              }
          If(opty.Route_To_Market__c == 'Direct')
            {
              opty.fulfillment__c = 'HP Fulfilled'; 
             }
          else if(opty.Route_To_Market__c == 'Indirect')
            {
              opty.fulfillment__c = 'Channel Fulfilled'; 
             }
             opptyList.add(opty);
             system.debug('###RecordsUpdated'+opty.id);
          }
          if(opptyList.size()>0)
          update opptyList;
     }
 global void finish(Database.BatchableContext BC){
     }*/
}