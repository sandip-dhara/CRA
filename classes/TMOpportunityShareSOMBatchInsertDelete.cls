// TM :Nasir Jawed. 7-31-2013 This batch insert and delete the SOM (customer and partner account). Start
public Class TMOpportunityShareSOMBatchInsertDelete{

    public static void executeUpdateSOM(Map<Id,Set<Id>> oppLineProdSetMap){
        system.debug('testnasirtest2:'+ oppLineProdSetMap);
        //retrieving Product Specialty for each Opportunity from OpportunityLineItem.
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnList = 
                                                                (List<Product_Specialty_Oppty_Assignment__c>) OpportunityShareAndSomCreation.OpptyShareUser(oppLineProdSetMap);
        //Delete here before updating the records.
       
        executeDeleteProdSpcltyOppAsgnmntLogic(oppLineProdSetMap.keySet());
        
        if(prodSpcltyOptyAsgnList != null && prodSpcltyOptyAsgnList.size()>0 ){
            try{
                //Then insert the new values.
                system.debug('nasir done 7:'+ prodSpcltyOptyAsgnList);
                upsert prodSpcltyOptyAsgnList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
            }catch(Exception excp){
                system.debug('Exception Forund In Updating Records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
    }
    
    private static void executeDeleteProdSpcltyOppAsgnmntLogic(Set<Id> oppIDSet){
        system.debug('testnasirtest3:'+ oppIDSet);
        
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnListToDel = 
                                                                            (List<Product_Specialty_Oppty_Assignment__c>) ProductSpecialtyOpptyAsgnMnt.fetchRecordsFromPSD(oppIDSet);
        system.debug('nasir delete1:'+ prodSpcltyOptyAsgnListToDel);
        if(null != prodSpcltyOptyAsgnListToDel && prodSpcltyOptyAsgnListToDel.size() > 0){
            try{
                system.debug('nasir delete2:'+ prodSpcltyOptyAsgnListToDel);
                delete prodSpcltyOptyAsgnListToDel;
                system.debug('Deleted');
            }catch(Exception excp){
               system.debug('Exception found while deleting records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
        
    } 
    
}
// TM :Nasir Jawed. 7-31-2013. End