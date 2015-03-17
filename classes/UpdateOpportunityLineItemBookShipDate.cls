/**
  * Class Name: UpdateOpportunityLineItemBookShipDate
  * Release : HP R4
  * Author: HP
  * Date: 17/12/2012  
  * Requirement # 4302: 
  * Description: Automatically adjust Ship/Book Dates when Close Date is updated.Ship/Book Dates should be set after Close Date.
  */ 
public class UpdateOpportunityLineItemBookShipDate{
    public static void updateBookshipDate(Map<id,Opportunity> newMap,Map<id,Opportunity> oldMap){
        if(HPUtils.updateBookshipDateFlag == False){
        /* if(test.isRunningTest()== true){
            HPUtils.updateBookshipDateFlag = True;
        }*/        
        HPUtils.updateBookshipDateFlag = True;
                Map<ID,Date> dateOptyMap=new Map<ID,Date>();
                
                //creating Map for bulk data handling
                for(opportunity op : newMap.values()){
                  system.debug('Closed dates new :::: '+op.closedate+' :::: old close date :::: '+oldMap.get(op.id).closedate);
                  if(op.closedate != oldMap.get(op.id).closedate){
                      dateOptyMap.put(op.id,op.closedate);
                      
                  }
              
                }
                
                Map<ID,List<OpportunityLineItem>> oppLineItemMap=new Map<ID,List<OpportunityLineItem>>();
                //creating map with each opporunity and assosiated line items
                if(dateOptyMap.size() > 0){
                    for(OpportunityLineItem opl: [select id,servicedate,opportunityid from OpportunityLineItem where opportunityid in :dateOptyMap.keySet()]){
                        
                       if(oppLineItemMap.containsKey(opl.opportunityId)){
                                        List<opportunityLineItem> relOplitems = oppLineItemMap.get(opl.opportunityId);
                                        relOplitems.add(opl);
                                        oppLineItemMap.put(opl.opportunityId,relOplitems);
                        }else{
                            oppLineItemMap.put(opl.opportunityId,new List<opportunityLineItem>{opl});
                        }
                   }
               }
               List<OpportunityLineItem>  oplitemsToUpdate=new List<OpportunityLineItem> ();
               
               /*updating opportunity line item book ship date with opportunity closedate 
               if new close date is greater than line item bookship date  */
               if(oppLineItemMap.size()>0){
                   for(opportunity op: newMap.values()){
                
                        List<OpportunityLineItem> oplitems=oppLineItemMap.get(op.id);
                        
                        if(oplitems.size()>0){
                            for(OpportunityLineItem ol : oplitems){
                                
                                   if( ol.servicedate < dateOptyMap.get(op.id))
                                   {
                                        ol.servicedate = dateOptyMap.get(op.id);
                                        oplitemsToUpdate.add(ol);
                                   }
                                
                            }
                        }
                    }
                         
                   
                }
                //updating the line items
               if(oplitemsToUpdate.size()>0){
               update oplitemsToUpdate;
                }
            
      }
    }
}