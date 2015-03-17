/**********************************************************
* Trigger Name: DealRegDealStatusUpdate 
* Author: HP
* Date: 05-OCT-2012 
* Description:Trigger to update the Deal Reg Status
***********************************************************/

trigger DealRegDealStatusUpdate on Deal_Registration__c (after update) {

for (Deal_Registration__c c: Trigger.new) {
        Deal_Registration__c oldValue = Trigger.oldMap.get(c.ID);
        if (c.Status__c != oldValue.Status__c) {

    List<Deal_Registration__c> dealRegUpdatedValuesList=Trigger.New;
    List<Deal_Registration__c> opportunityIdList= new List<Deal_Registration__c>();
    List<String> approvedList = new List<String>();
    List<String> rejectedList = new List<String>();
    List<String> SubmittedList = new List<String>();
    List<String> ReviewInitiatedList = new List<String>();
    List<String> expiredList = new List<String>();
    List<Opportunity> updateList=new List<Opportunity>();
    List<Opportunity> dealOpportunityIdList= new List<Opportunity>();    
    List<Deal_Registration__c> dealidsList = new List<Deal_Registration__c>();
    
    List<id> dealStatusIdList=new List<Id>();
    List<id> opportunityIdLists= new List<Id>();
    List<id> dealIdList = new List<id>();

   Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
  
    
    for(Deal_Registration__c dealStatus:dealRegUpdatedValuesList){   
    
         dealStatusIdList.add(dealStatus.Id);
    
     }
     
    opportunityIdList=[select Opportunity__r.Id from Deal_Registration__c where id in:dealStatusIdList];     

    for(Deal_Registration__c opId:opportunityIdList){    
    
            opportunityIdLists.add(opId.Opportunity__r.Id);
            
    }
    
   dealOpportunityIdList=[Select id,Deal_Registration_Status__c from Opportunity where id in:opportunityIdLists];

   
    for(Opportunity oId:dealOpportunityIdList){    
    
        dealIdList.add(oId.id);
    
    }
    
 
    
    dealidsList=[select id,Status__c from Deal_Registration__c where Opportunity__c in:dealIdList];

 
    for(Deal_Registration__c allDealIds:dealidsList){
        
      if(allDealIds.Status__C.contains('Submitted')){
      SubmittedList.add('Submitted');             
      }
      
      if(allDealIds.Status__C.contains('Review Initiated')){
      ReviewInitiatedList.add('Review Initiated');     
      }
      
      if(allDealIds.Status__C.contains('Approved')){
      approvedList.add('Approved');     
      }
      
      if(allDealIds.Status__C.contains('Rejected')){
        rejectedList.add('Rejected');
      }      
      }
     
    for(Opportunity allList:dealOpportunityIdList){
     
        if(SubmittedList.size()==dealidsList.size()){
          allList.Deal_Registration_Status__c='Submitted';
        }
        if((SubmittedList.size()!=dealidsList.size()) && ((ReviewInitiatedList.size() ==dealidsList.size()) || (SubmittedList.size()+ReviewInitiatedList.size())==dealidsList.size())){
          allList.Deal_Registration_Status__c='Review Initiated';
        }
        
        if(approvedList.size()==dealidsList.size()){
          allList.Deal_Registration_Status__c='Approved';
        }
        if(rejectedList.size()==dealidsList.size()){
          allList.Deal_Registration_Status__c='Rejected';
        }
        if((approvedList.size()!=dealidsList.size()) && (rejectedList.size()!=dealidsList.size()) && ((rejectedList.size()+approvedList.size())==dealidsList.size())){
          allList.Deal_Registration_Status__c='Partially Approved';
        }
           
           updateList.add(allList);
      }
           
        update updateList;
        
              }
    }
}