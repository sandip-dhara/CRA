/**
  * @author: rahul.kunal (Accenture)
  * HP Release 2
  * This Class drives the logic for controlling trigger.
  * Date:
  */
public with sharing class OppLineItemTriggerController {
    
    /*
     * @Description: Method to Control Update Logic for Product Specialty either for Opportunity Updtae or Opp Line Item Update.
     * @Param: Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap.
     */
    public static void controlUpdateOppOrLineItemLogic(Map<id,Opportunity> optyOldMap,Map<id,Opportunity> optyNewMap){
        
        Map<Id,Opportunity> changedOppIdOppObjMap = new Map<Id,Opportunity>();
        
        //check to prevent the logic to run everytime except the real Opp Type RTM change scenario.
        if(null != optyOldMap && null != optyNewMap){
            //system.debug('Inside update Logic Start');
            for(Id oppIdNew:optyNewMap.KeySet()){
                Opportunity newObj = optyNewMap.get(oppIdNew);
                Opportunity oldObj = optyOldMap.get(oppIdNew);
                
                //system.debug('>>>>>>>>Print NewObj'+newObj);
                //system.debug('>>>>>>>>Print OldObj'+oldObj);
                
                if(null != newObj && null != oldObj){
                    //system.debug('>>>>>>Inside for If First');
                    if((null != newObj.Route_To_Market__c && !newObj.Route_To_Market__c.equalsIgnoreCase(oldObj.Route_To_Market__c)) || (null !=newObj.Type && !newObj.Type.equalsIgnoreCase(oldObj.Type))){
                        system.debug('inside main If');
                        changedOppIdOppObjMap.put(oppIdNew,newObj);
                    }
                }
            }
            
            // Fetch records from OpportunityLineItem object for the Opportunity Ids to be updated.
            Map<Id,Set<Id>> fetchedOppIdPordSetMap;
            if(null != changedOppIdOppObjMap && changedOppIdOppObjMap.size() > 0){
                fetchedOppIdPordSetMap = fetchOppLineItem(changedOppIdOppObjMap.keySet());
                //system.debug('Check Value '+fetchedOppIdPordSetMap);
                executeUpdateProdSpcltyOppAsgnmntLogic(fetchedOppIdPordSetMap); 
            } 
        }else{
            return;
        }
        
    }
    
    /*
     * @Description: Method to control Insert Logic for Product Specialtyfor Opp Line Item Insert.
     * @Param: Map<Id,OpportunityLineItem> triggerMap.
     */
    public static void controlInsertOppLineItemLogic(Map<Id,OpportunityLineItem> triggerMap){
        system.debug('*******Enter to Check controlInsertOppLineItemLogic method');
        
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(Id id : triggerMap.keySet()){
            
            Set<Id> productSet = oppLineItemProductSetMap.get(triggerMap.get(id).OpportunityId);
            if(null == productSet){
                productSet = new Set<Id>();
            }
            productSet.add((Id)triggerMap.get(id).Product__c);
            oppLineItemProductSetMap.put(triggerMap.get(id).OpportunityId,productSet);
        }
        
        //calling insertLogic
        executeInsertProdSpcltyOppAsgnmntLogic(oppLineItemProductSetMap);
        system.debug('*************Exit controlInsertOppLineItemLogic method****');
    }
    
    /*
     * @Description: Method to control Delete Logic for Product Specialty for Opp Line Item Delete.
     * @Param: Map<Id,OpportunityLineItem> triggerMap.
     */
    
    public static void controlDeleteOppLineItemLogic(Map<Id,OpportunityLineItem> triggerMap){
        
        system.debug('Flow Point 2 controlDeleteOppLineItemLogic method called triggerMap '+triggerMap);
        Map<Id,Set<Id>> oppIdProdIdSetMap = new Map<Id,Set<Id>>();
        
        if(null != triggerMap){
            for(Id oppLineItemId:triggerMap.keySet()){
                Set<Id> prodSet = oppIdProdIdSetMap.get(triggerMap.get(oppLineItemId).OpportunityId);
                if(null == prodSet){
                    prodSet = new Set<Id>();
                }
                prodSet.add(triggerMap.get(oppLineItemId).Product__c);
                
                oppIdProdIdSetMap.put(triggerMap.get(oppLineItemId).OpportunityId,prodSet);
            }
            
            //system.debug('Check Value oppIdProdIdSetMap '+oppIdProdIdSetMap);
            
            executeDeleteProdSpcltyOppAsgnmntLogic(oppIdProdIdSetMap.keySet());
            /*
             * Before Deleting record Check whether the present Product Specialty Opportunity Assignment Record is also because of other Product Specialty Definition
             * for the Same Product Specialty for the same Opportunity with other line items presnet on the opportunity record. If yes then after delete run the same insert logic.
             */
            // Fetch all the Line Item for the Opportunity Record Deleted
            Map<Id,Set<Id>> oppIdLineItemProdSetmap = fetchOppLineItem(oppIdProdIdSetMap.keySet());
            //system.debug('Check Value oppIdLineItemProdSetmap '+oppIdLineItemProdSetmap);
            
            //Now for fetched records drive the same logic as for inserting the records, so that if other same combination matches for deleted Prod Spclty then again we will have the same access available.
            if(null != oppIdLineItemProdSetmap && oppIdLineItemProdSetmap.size() > 0){
                executeInsertProdSpcltyOppAsgnmntLogic(oppIdLineItemProdSetmap);
            }
            
        }
    }
    
    /*
     * @Description: Method to control Delete Logic for Product Specialty for Opportunity record Delete.
     * @Param: Map<Id,Opportunity> triggerMap.
     */
    public static void controlDeleteOpportunityLogic(Map<Id,Opportunity> triggerMap){
        
        /*****************Added by OMPM R3.0 **********Open***********************************************/
        List<GBU_Product_Summary__c> gbuList = new List<GBU_Product_Summary__c>();
        gbuList = [Select id From GBU_Product_Summary__c Where Opportunity__c IN :triggerMap.keyset()];
        
        if(gbuList.size()>0)
            delete gbuList;
        /*****************Added by OMPM R3.0 *********Close**********************************************/
        
        //call exceute delete method passing the set of opportunities
        executeDeleteProdSpcltyOppAsgnmntLogic(triggerMap.keySet());
    }
    
    
    /* 
     * @Description: Method for executing Insert Logic for Product Specialtyfor Opp Line Item Insert.
     * @Param: Map<Id,Set<Id>> oppLineProdSetMap. 
     */
    private static void executeInsertProdSpcltyOppAsgnmntLogic(Map<Id,Set<Id>> oppLineProdSetMap){
        
        //retrieving Product Specialty for each Opportunity from OpportunityLineItem.
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnList = 
                                                                (List<Product_Specialty_Oppty_Assignment__c>) ProductSpecialtyOpptyAsgnMnt.callProdSpecailtyLogic(oppLineProdSetMap);
        
        //system.debug('*******prodSpcltyOptyAsgnList values******'+prodSpcltyOptyAsgnList);
        if(prodSpcltyOptyAsgnList != null && prodSpcltyOptyAsgnList.size()>0 ){
            try{
                upsert prodSpcltyOptyAsgnList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
            }catch(Exception excp){
                system.debug('Exception Forund In Inserting Records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
    }
    
    /*
     * @Description: Method for executing Update Logic for Product Specialtyfor Opp Line Item Insert.
     *               Making this method as public so that it can be called directly from batch process.
     * @Param: Map<Id,Set<Id>> oppLineProdSetMap.
     */
    public static void executeUpdateProdSpcltyOppAsgnmntLogic(Map<Id,Set<Id>> oppLineProdSetMap){
        
        //retrieving Product Specialty for each Opportunity from OpportunityLineItem.
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnList = 
                                                                (List<Product_Specialty_Oppty_Assignment__c>) ProductSpecialtyOpptyAsgnMnt.callProdSpecailtyLogic(oppLineProdSetMap);
        
        //system.debug('*******prodSpcltyOptyAsgnList values******'+prodSpcltyOptyAsgnList);
        
        //Delete here before updating the records.
        //system.debug('*****Call Delete'+oppLineProdSetMap);
        executeDeleteProdSpcltyOppAsgnmntLogic(oppLineProdSetMap.keySet());
        
        if(prodSpcltyOptyAsgnList != null && prodSpcltyOptyAsgnList.size()>0 ){
            try{
                //Then insert the new values.
                upsert prodSpcltyOptyAsgnList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
            }catch(Exception excp){
                system.debug('Exception Forund In Updating Records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
    }
    
     
    
    /*
     * @Description: Method for executing Delete Logic for Product Specialty.
     * @Param: Set<Id> oppIDSet.
     */
    private static void executeDeleteProdSpcltyOppAsgnmntLogic(Set<Id> oppIDSet){
        system.debug('executeDeleteProdSpcltyOppAsgnmntLogic called');
        
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnListToDel = 
                                                                            (List<Product_Specialty_Oppty_Assignment__c>) ProductSpecialtyOpptyAsgnMnt.fetchRecordsFromPSD(oppIDSet);
        if(null != prodSpcltyOptyAsgnListToDel && prodSpcltyOptyAsgnListToDel.size() > 0){
            try{
                delete prodSpcltyOptyAsgnListToDel;
                //system.debug('Deleted');
            }catch(Exception excp){
                system.debug('Exception found while deleting records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
        
    }    
     //TM Nasir Jawed: R5 CR-0712: 25/04/2013:    Start 
     public static void executeSomLogic(Map<Id,Set<Id>> oppLineProdSetMap){
        
        //retrieving Product Specialty for each Opportunity from OpportunityLineItem.
        List<Product_Specialty_Oppty_Assignment__c> prodSpcltyOptyAsgnList = 
                                                                (List<Product_Specialty_Oppty_Assignment__c>) ProductSpecialtyOpptyAsgnMnt.executeSOMLogicForProdLineItem(oppLineProdSetMap);
        
       if(prodSpcltyOptyAsgnList != null && prodSpcltyOptyAsgnList.size()>0 ){
            try{
                //Then insert the new values.
                upsert prodSpcltyOptyAsgnList Product_Specialty_Oppty_Assignment__c.OpptyUserPSKey__c;
                system.debug('block9:'+ prodSpcltyOptyAsgnList ); 
            }catch(Exception excp){
                system.debug('Exception Forund In Updating Records for Opportunity Product Specialty Assgnment '+excp.getMessage());
            }
        }
    }
    //TM Nasir Jawed: R5 CR-0712: 25/04/2013:  End
    
    /*
     * @Description: Method for Fetching records for Product Specialtyfor Opp Line Item Insert.
     * @Param: Set<Id> oppIdSet
     */
     private static Map<Id,Set<Id>> fetchOppLineItem(Set<Id> oppIdSet){
        
        Map<Id,Set<Id>> oppLineItemProductSetMap = new Map<Id,Set<Id>>();
        for(OpportunityLineItem oppLineItemObj: [Select o.Id, o.Product__c, o.OpportunityId From OpportunityLineItem o Where o.OpportunityId in : oppIdSet]){
            //system.debug('Inside for Loop for OppLineItem: '+oppLineItemObj);
            Set<id> productSet = oppLineItemProductSetMap.get(oppLineItemObj.OpportunityId);
            if(null == productSet){
                productSet = new Set<Id>();
            } 
            productSet.add(oppLineItemObj.Product__c);
            oppLineItemProductSetMap.put(oppLineItemObj.OpportunityId,productSet);
        }
        
        return oppLineItemProductSetMap;
    }
    
    /*
     * @Description: Insert the Opportunity Ids in Log Object.
     */
     public static void logOpptyId(Map<Id,Opportunity> newTriggerMap, Map<Id,Opportunity> oldTriggerMap){
        /*
         * Start: Changes for CR-0134: Rahul Kunal
         * Date: 8/8/2012
         * Description: Removing IsUpdated flag and adding the Log Object logic.
         */
        List<Log_Object__c> dataLogListToInsert = new List<Log_Object__c>();
        String key;
        for(Id newOppIdObj : newTriggerMap.keySet()){
            Opportunity newObj = newTriggerMap.get(newOppIdObj);
            Opportunity oldObj = oldTriggerMap.get(newOppIdObj);
            
            if(newObj != null && oldObj != null && newObj.Route_To_Market__c != null && newObj.Type != null && (newObj.Route_To_Market__c.equalsIgnoreCase(oldObj.Route_To_Market__c) || newObj.Type.equalsIgnoreCase(oldObj.Type))){
                //Removing IsUpdated Flag
                    //newObj.isUpdated__c = true;
                
                key = 'Opportunity'+'-'+newOppIdObj;
                Log_Object__c logObj = new Log_Object__c(Object_Name__c = 'Opportunity',Record_Id__c = newOppIdObj,Is_Added__c = true,Unique_Index__c = key);
                dataLogListToInsert.add(logObj);
            }
        }
        try{
            if(dataLogListToInsert != null && dataLogListToInsert.size() > 0){
                upsert dataLogListToInsert Log_Object__c.Unique_Index__c;
            }
        }catch(Exception exp){
            system.debug('Exception Occured While Inserting Records in Log Object: '+exp.getMessage());
        }
        /*
         * End: Changes for CR-0134.
         */
     }
     
     /*
      * @Description: Insert the Opportunity Ids from OLI Delete in Log Object .
      */
     public static void logOpptyIdfromOLIDel(Map<Id,OpportunityLineItem> oldTriggerMap){
        
        List<Log_Object__c> dataLogListToInsert = new List<Log_Object__c>();
        String key;
        set<Id> opptyIdSet = new set<Id>();
        for(OpportunityLineItem obj : oldTriggerMap.values()){
            opptyIdSet.add(obj.OpportunityId);
        }
        for(Id opptyObj : opptyIdSet){
            key = 'Opportunity'+'-'+opptyObj;
            Log_Object__c logObj = new Log_Object__c(Object_Name__c = 'Opportunity',Record_Id__c = opptyObj,Is_Added__c = true,Unique_Index__c = key);
            dataLogListToInsert.add(logObj);
        }
        
        try{
            if(dataLogListToInsert != null && dataLogListToInsert.size() > 0){
                upsert dataLogListToInsert Log_Object__c.Unique_Index__c;
            }
        }catch(Exception exp){
            system.debug('Exception Occured While Inserting Records in Log Object: '+exp.getMessage());
        }
        
     }
     
     
    /* 
     * Method: contractValueSumup
     * Author: HP
     * Description: To Rollup Subtotal value of all the lineitems to Total contract Value in associated contract Reference.
     */

   public static void contractValueSumup(set<Id> contractIds){
        List<Contract_Reference__c> contractsToUpdate = new List<Contract_Reference__c>();
        system.debug('###contractIds'+contractIds);
        Map<id,Double> contractMap = new Map<id,Double>();
        system.debug([select Contract__c, sum(Subtotal) from OpportunityLineItem where Contract__c IN :contractIds group by Contract__c]);
        
        //Map<id,OpportunittLineItem> OppLineItem = new Map<id,OpportunittLineItem>
        Double SummedValue=0;
        Id PrevValue;
        integer i = 0;
                
        List<OpportunityLineItem> OppLineItem = [select Contract__c, Subtotal from OpportunityLineItem where Contract__c IN :contractIds order by Contract__c ];
        For(OpportunityLineItem Item: OppLineItem)
        {           
            If(i == 0 || Item.Contract__c == PrevValue )
            {
                SummedValue += Double.valueOf(Item.Subtotal);
                PrevValue = Item.Contract__c;
                If(i != OppLineItem.Size())
                {
                    contractMap.put((Id)PrevValue,(Double)SummedValue);
                }
            }else{
                contractMap.put((Id)PrevValue,(Double)SummedValue);
                SummedValue = Double.valueOf(Item.Subtotal);
                PrevValue = Item.Contract__c;
            }
            i = i + 1;
        }
        system.debug('###contractMap'+contractMap);
        for(Contract_Reference__c con : [Select Id, Total_Contract_Value__c from Contract_Reference__c where Id IN :contractIds]){
            Double contractSum = contractMap.get(con.Id);
            con.Total_Contract_Value__c = contractSum;
            contractsToUpdate.add(con);
        }
        system.debug('###contractsToUpdate'+contractsToUpdate);
        update contractsToUpdate;
    }
    /*
    * 
    * @Description: To calculate calcDIMvalue
    * @Revised in R6
    * @param: List<OpportunityLineItem>, 
    *  As per Laura request calcDIMvalue method added and removed calculateMonthlyRevenue method.
    */
public static void calcDIMvalue(List<OpportunityLineItem> oli){
        List<string> opptyIDs = new List<string>();
        //List<Opportunity> Oppty = new List<Opportunity>();
        for (OpportunityLineItem opptyli : oli){    
            if(opptyli.Contract__c !=NULL){
                opptyIDs.add(opptyli.OpportunityId);
            }   
        }
        List<contract_reference__c> contracts = [Select id, Total_Contract_Value__c from contract_reference__c where Original_opportunity__c = :opptyIDs ];
        List<Opportunity> opptys = [Select id, Difference_in_Maintenance__c, Value__c from Opportunity where id = :opptyIDs];
        for(Opportunity opp : opptys){
            opp.Difference_in_Maintenance__c = 0;
            if(contracts.size()>0){
                for( Contract_Reference__c tcv: contracts){
                    opp.Difference_in_Maintenance__c = opp.Difference_in_Maintenance__c+tcv.Total_Contract_Value__c;
                } 
                system.debug('###DIMvaluesofar'+opp.Difference_in_Maintenance__c);
                opp.Difference_in_Maintenance__c = opp.Value__c - opp.Difference_in_Maintenance__c;
                update opp;
            }else{}
        } 
    }
    
  /*
    * 
    * @Description: To calculate Annualized value for Opportunity Line Item
    * @Revised in R6
    * @param: List<OpportunityLineItem>, 
    *  Author : Vinay Kumar
    */   
public static void LineItemAnnualizationlogic(List<OpportunityLineItem> opptyLineItems){
 List<OpportunityLineItem> OppLineItem = [select Id, Subtotal, OpportunityID, Opportunity.RecordType.name from OpportunityLineItem where Id in : opptyLineItems Limit 5000];
 
 for (OpportunityLineItem oli : opptyLineItems) {
            //If(oli.Opportunity.RecordType.name == 'Renewal')
            {
                Date contractStartDate;
                Date contractEndDate;
                Date QuoteEndDate;
                //use contract dates if oli from contract - use quote dates if quote oli have already been synced
                if(oli.Contract_Start_Date__c!=null && oli.Contract_End_Date__c!=null){
                    contractStartDate = oli.Contract_Start_Date__c;
                    contractEndDate = oli.Contract_End_Date__c;
                }else if(oli.Quote_Start_Date__c!=null && oli.Quote_End_Date__c!=null){
                    contractStartDate = oli.Quote_Start_Date__c;
                    contractEndDate = oli.Quote_End_Date__c;
                    QuoteEndDate = oli.Quote_End_Date__c;
                }
                if (contractStartDate != null && contractEndDate != null) {
                    Integer csdYear = contractStartDate.year();
                    Integer csdMonth = contractStartDate.month();
                  Integer csdDay = contractStartDate.day()-1;
                  // Integer daysInStartMonth = date.daysInMonth(csdYear, csdMonth) - csdDay;
                    Integer cedYear = contractEndDate.year();
                   Integer cedMonth = contractEndDate.month();
                  //Integer cedDay = contractEndDate.day();
                //Integer NoOfDays = contractStartDate.daysBetween(QuoteEndDate);
                system.debug('csd'+ csdYear);
                system.debug('ced'+ csdMonth);
                system.debug('csd'+ cedYear);
                system.debug('ced'+ cedMonth);
                //system.debug('&&&&&&'+ NoOfDays);
                //Double NoOfMonths = (NoOfDays)/30.0;
                //system.debug('&&&&&&'+ NoOfMonths);
                //double CeiledMonths =  Math.ceil(NoOfMonths);
                  double CeiledMonths1=((((cedYear - csdYear) - 1) *12) + ((12 - csdMonth +1) + cedMonth));
                  system.debug('&&&&&&CeiledMonths1&&&'+ CeiledMonths1 );
                 
                    If(CeiledMonths1 >= 12)
                    {
                    oli.First_12_Month_Value__c = (oli.Subtotal/CeiledMonths1 )*12;
                    }
                    If(CeiledMonths1 <= 12)
                    {
                    oli.First_12_Month_Value__c = oli.Subtotal;
                    }
                system.debug('First12MonthValue'+ oli.First_12_Month_Value__c );
                }
    
    
                 }
            } 
    }
}