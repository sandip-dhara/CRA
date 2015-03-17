public class TMPostLocationAssignment 
{
   /* public static void postAssignmentforTM (Map<Id, List<Sales_Territory_Definition__c>> locIdSTDMap)
    {
        try
        {
            Map<String, OpportunityShare> createOptyShareMap = new Map<String, OpportunityShare>();         
            Map<Id,List<Channel_Partner__c>> optyAssign = new   Map<Id,List<Channel_Partner__c>>();
            //Added field Location__c in the query
            //TM:Vinay R6:Req 7525:Start
             //Condition to check non confidential opportunities
            List<Channel_Partner__c> tempOptyList = [Select Id, Opportunity__c,Location__c From Channel_Partner__c 
            where Location__c in :locIdSTDMap.keySet() And Opportunity__r.Confidential__c = false And Opportunity__r.Account.Confidential_Account__c = false];
            //TM:Vinay R6:Req 7525:End
            for(Id lId : locIdSTDMap.keySet())
            {
                List<Channel_Partner__c> tempOpty = new List<Channel_Partner__c>();
                for(integer i = 0 ; i<tempOptyList.size(); i++)
                {
                    if(lId == tempOptyList[i].Location__c)
                    {
                        tempOpty.add(tempOptyList[i]);
                    }
                }
                optyAssign.put(lId,tempOpty);
            }
            for(Id lId : locIdSTDMap.keySet())
            {
                if(lId != null)
                {
                    for(Sales_Territory_Definition__c stdObj : locIdSTDMap.get(lId))
                    {
                        if(null !=stdObj.Sales_Territory__r.GroupId__c && stdObj.Sales_Territory__r.GroupId__c !='')
                        {                           
                            List<Channel_Partner__c> optyList = optyAssign.get(lId);
                            if(optyList != null && optyList.size() > 0)
                            {
                               for(Channel_Partner__c opty : optyList)
                               {
                                   if(opty != null)
                                   {
                                       OpportunityShare optyShare = new OpportunityShare (OpportunityId = opty.Opportunity__c, 
                                       UserOrGroupId = stdObj.Sales_Territory__r.GroupId__c,OpportunityAccessLevel = 'Read');
                                       createOptyShareMap.put(''+opty.Id+'-' + stdObj.Sales_Territory__r.GroupId__c, optyShare);
                                   }         
                                }     
                            }                                    
                        }
                    }
                }
            }
            if(!createOptyShareMap.isEmpty())
            {
               Database.insert(createOptyShareMap.values(),false);
            } 
        }
        catch(Exception e)
        {
            system.debug('*****Exception in TerritoryManagementPostAssignment****' + e.getMessage());
        }
    }*/
    /*TM:R5:HP:Vinay M:Req 6201:Method to Remove Invalid association between Sales territory and Location - Start*/
    public static void processCleanUpLocation(Set<Id> locationIdSet){
        List<Sales_Territory_Location_Assignment__c> stlaUpdList = new List<Sales_Territory_Location_Assignment__c>();
        TerritoryDeltaChanges__c terrDeltaFlag = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
        if(terrDeltaFlag.Territory_Evaluation__c){
            for(Sales_Territory_Location_Assignment__c stla:[Select Id,TrackAssociationToDelete__c From Sales_Territory_Location_Assignment__c
                                                             Where Location__c IN :locationIdSet AND AssignmentType__c = 'Territory Engine' AND
                                                             Sales_Territory__r.EvaluateTerritory_for_Realignment__c = true]){
                stla.TrackAssociationToDelete__c = true;
                stlaUpdList.add(stla);
            }
        }else{
            for(Sales_Territory_Location_Assignment__c stla:[Select Id,TrackAssociationToDelete__c From Sales_Territory_Location_Assignment__c
                                                             Where Location__c IN :locationIdSet AND AssignmentType__c = 'Territory Engine']){
                stla.TrackAssociationToDelete__c = true;
                stlaUpdList.add(stla);                          
            }
        }
        if(!stlaUpdList.isEmpty()){
            try{
                database.update(stlaUpdList,true);
            }catch(Exception e){
                system.debug('******Exception in processCleanUpLocation*******'+e.getMessage());
            }
        }
    }
    /*TM:R5:HP:Vinay M:Req 6201:Method to Remove Invalid association between Sales territory and Location - End*/
}