/**********************************************************
* Class Name: MaxBookShipDate
* Author: Chintapalli Sudhakara Reddy
* Date: 4/4/2013 6:22 AM 
* Capability:OM Enhancements
* Description: This class has called in OpportunityLIneItem triggers OpportunityLineItemBeforeUpdate,OpportunityLineItemBeforeInsert.  
***********************************************************/

public class MaxBookShipDate{

    public static void updateBookshipDate(List<OpportunityLineItem> newlst,List<OpportunityLineItem> oldlst) {

    List<Opportunitylineitem> optylntoupdate=new List<opportunitylineitem>();
    Opportunitylineitem opty=new Opportunitylineitem();
    Set<Id> scheduOptlinids = new Set<Id>();
    Map<ID,OpportunityLineItem> opliMap=new Map<ID,OpportunityLineItem>();
    
                for (opportunitylineitem opli: newlst) {
                System.debug('HasSchedule'+opli.HasSchedule);
                    
                       opliMap.put(opli.id,opli);
                        
                       if (opli.HasQuantitySchedule||opli.HasRevenueSchedule){
                            scheduOptlinids.add(opli.id);
                            System.debug('@@@ssss');
                            }else
                               {
                               opli.Max_Book_Ship_date__c=opli.servicedate;
                               System.debug('@@@');
                               optylntoupdate.add(opli);
                                }
                }
       
       If( scheduOptlinids.size()>0){
       
              List<OpportunityLineItemSchedule> scheduledates = [select Id,ScheduleDate,OpportunityLineItemID from OpportunityLineItemSchedule where OpportunityLineItemId in :scheduOptlinids];
              Map<ID,List<Date>> schdatesMap=new Map<ID,List<Date>>();

                for(OpportunityLineItemSchedule oplisd:scheduledates ){

                    if(schdatesMap.containsKey(oplisd.OpportunityLineItemID)){
    
                    List<Date> schdates=new List<Date>();
                    schdates=schdatesMap.get(oplisd.OpportunityLineItemID);
                    schdates.add(oplisd.ScheduleDate);
                    System.debug('@');
                    schdatesMap.put(oplisd.OpportunityLineItemID,schdates);
    
                    }
                     else{
                     
                     List<Date> schdates=new List<Date>();
                     schdates.add(oplisd.ScheduleDate);
                     schdatesMap.put(oplisd.OpportunityLineItemID,schdates);
                     }
                     }
                     
                     
                for(ID OptylinId : schdatesMap.keySet()){
                    List<Date> totalDates = new List<Date>();
                    totalDates=schdatesMap.get(OptylinId);
                    totalDates.sort();
    
                    opliMap.get(OptylinId ).Max_Book_Ship_date__c=totalDates.get(totalDates.size()-1);
                    System.debug('@@');
                    optylntoupdate.add(Opty);
                    }
                    }
       
            }
         }