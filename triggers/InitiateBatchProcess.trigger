trigger InitiateBatchProcess on Batch_Job_Invoker__c (before insert, after insert) {
if(trigger.isAfter && trigger.isInsert){

  // Terrtory Management Reallignment Process Call.
  if(trigger.new[0].Type__c == 'Territory Management'){
   /*  SREENATH:  we are allowing specialty batch in realignment from R6EF
    // On reallignment (full load) skipping hourly specialty batch to process.
    TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c){
            try{
                //Update to true
                specialtyFlag.SchedularFlag__c = true;
                update specialtyFlag;
            }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to true in TMProcessGeoRulesBatch '+exp.getMessage());
            }
        }*/
    // Execute reallignment of Accounts.
    //Id batchInstanceId = Database.executeBatch(new AccountProcessOnTMReallignment(trigger.new[0]), 2000);
    //sreenath : Now we are not using this realignment process for 2089 requirement engine will call     
     if(trigger.new[0].Type__c == 'Territory Management' && trigger.new[0].Region__C != Null){
          TMEngineAccountRecordType__c regobj = TMEngineAccountRecordType__c.getValues('Realignment_Region');
          regobj.AccountRecordType__c = trigger.new[0].Region__C;
          update regobj;
          // TM : Ritesh --> Subregion1 changes
          if(null == trigger.new[0].SubRegion1__c){
            TMEngineAccountRecordType__c regobj1 = TMEngineAccountRecordType__c.getValues('Realignment_SubRegion1');
            regobj1.AccountRecordType__c = trigger.new[0].SubRegion1__c;
            update regobj1;
            
            system.debug(regobj1.AccountRecordType__c + '****');
          }
          /*TM : Sreenath Req No. 3095 starts*/
          TMEngineAccountRecordType__c regobj2;
          if(trigger.new[0].Account_Record_Type__c != null){
          regobj2 = TMEngineAccountRecordType__c.getValues('AccRecTypeVal');
          regobj2.AccountRecordType__c = trigger.new[0].Account_Record_Type__c;
          update regobj2;
          }
          else if(trigger.new[0].Account_Record_Type__c == null){
          regobj2 = TMEngineAccountRecordType__c.getValues('AccRecTypeVal');
          regobj2.AccountRecordType__c = 'Customer';
          update regobj2;
          }
          /*TM : Sreenath Req No.3095 ends*/
          
          system.debug(regobj.AccountRecordType__c);
          TerritoryDeltaChanges__c terrchanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
          terrchanges.Territory_Evaluation__c = trigger.new[0].Consider_New_or_Changed_Territories_Only__c;
          update terrchanges;
          datetime CurrentDateTime = datetime.now();
          String Hour = String.valueOf(math.mod((currentDateTime.Hour()),60));
          String Min = String.valueOf(math.mod((currentDateTime.minute()+2),60));          
          String CRON_EXP = '0 '+min+' * * * ?';
          TMEngineSchelduled sch = new TMEngineSchelduled();
          system.schedule(Label.TM_Engine_Hourly_Schedule+regobj.AccountRecordType__c, CRON_EXP, sch);
    }
    
    // sreenath 2089 10/15/2012 ends
  }
  //Product Speciality Batch Call...  
  /*
     * Start: Changes for CR-0134: Rahul Kunal
     * Date: 8/8/2012
     * Description: Seperate the two batches.
     */
  //Keeping default value to 50 in case if there is any issue with Custom Setting it will take default size as 50 else whatever will be given in custom setting.
        Integer size = 50;
        Batch_Size__c batchSize = Batch_Size__c.getInstance('SpecialtyReallignmentBatchSize');
        system.debug('SOM7:'+batchSize);
        if(batchSize != null && batchSize.Batch_Size__c != null){
            size = Integer.valueOf(batchSize.Batch_Size__c);
        }
        if(trigger.new[0].Type__c == 'Specialty Oppty Update'){
            //Call the batch for Specialty Functionality on Opportunity Update
            Id batchInstanceId = Database.executeBatch(new ProcessOppUpdateSpecialtyBatch(trigger.new[0]), size);
        }
        //TM: Nasir JAwed:R6: For specialty realignment from Realignment schedular with REgions and sub regions: Start 

        if(trigger.new[0].Type__c == 'Specialty Realignment'){
    
            if(trigger.new[0].Region__C != Null){
                TMEngineAccountRecordType__c regionObj= TMEngineAccountRecordType__c.getValues('SpecialtyRealignmentRegion');
                system.debug('SOM:'+regionObj);
                if(regionObj!=null){            
                    regionObj.AccountRecordType__c = trigger.new[0].Region__C;
                    update regionObj; 
                    system.debug('SOM1:'+regionObj); 
                    TMEngineAccountRecordType__c subRegionObj = TMEngineAccountRecordType__c.getValues('SpecialtyRealignmentSubRegion');
                    system.debug('SOM2:'+subRegionObj); 
                        if(null != trigger.new[0].SubRegion1__c){                
                            subRegionObj.AccountRecordType__c = trigger.new[0].SubRegion1__c;
                            update subRegionObj; 
                            system.debug('SOM3:'+subRegionObj);  
                            //TM: Manasa:R7: For specialty realignment from Realignment schedular with subregion2: Start    
                             TMEngineAccountRecordType__c subRegionObj2 = TMEngineAccountRecordType__c.getValues('SpecialtyRealignmentSubRegion2');
                             system.debug('SOM2a:'+subRegionObj2); 
                             if(null != trigger.new[0].SubRegion2__c){
                                 subRegionObj2.AccountRecordType__c = trigger.new[0].SubRegion2__c;
                                 update subRegionObj2; 
                                 system.debug('SOM3a:'+subRegionObj2);
                             }else{
                                subRegionObj2.AccountRecordType__c = '';
                                update subRegionObj2; 
                             } 
                             //TM: Manasa:R7: For specialty realignment from Realignment schedular with subregion2: End          
                        }
                        else{
                            subRegionObj.AccountRecordType__c = '';
                            update subRegionObj;
                            }
                }
            }
            // On Specialty reallignment (full load) setting hourly specialty batch to process in coming incremental changes.
            TMEngineScheduledFlag__c hourlySpecialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
            TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyRealignmentBatchFlag');
            system.debug('SOM4:'+specialtyFlag); 
            if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c && (!hourlySpecialtyFlag.SchedularFlag__c || hourlySpecialtyFlag.SchedularFlag__c)){
                try{
                    //Update to true
                    specialtyFlag.SchedularFlag__c = true;
                    update specialtyFlag;
                    system.debug('SOM5:'+specialtyFlag); 
                    //Call the batch for Specialty Functionality Reallignment
                    Id batchInstanceId = Database.executeBatch(new TMOpportunityShareSOMBatch(trigger.new[0]), size);
                    system.debug('SOM6:'+batchInstanceId); 
                    }catch(Exception exp){
                    system.debug('Exception Occured while updating Specialty Flag to true '+exp.getMessage()); 
                    }
            }
            
        //Call the batch for Specialty Functionality Reallignment. This batch is commented during R6 release    
        //Id batchInstanceId = Database.executeBatch(new ProcessOpportunitySpecialtyBatch(trigger.new[0]), size);
        }
       //TM: Nasir JAwed:R6: For specialty realignment from Realignment schedular with REgions and sub regions: End 
       
        //End: Changes for CR-0134.
         
       // Start: Changes for Defect # 2540: Rahul Kunal. Invoking new batch on OLI delete.
      
        if(trigger.new[0].Type__c == 'Specialty On OLI Delete'){
        //Call the batch for Specialty Functionality On OLI Delete.
        Id batchInstanceId = Database.executeBatch(new ProcessSpecialtyOnOLIDelete(trigger.new[0]), size);
        } 
        //* End: Changes for Defect # 2540.      
    }
/* sreenath - 2089  10/18/2012 starts
display message for already jobs are running & manual realignment job won't execute
*/ 

if(trigger.isBefore && trigger.isInsert){

   TMEngineScheduledFlag__c RuleEngineFlag = TMEngineScheduledFlag__c.getInstance('SchedularFlagVal');
   TMEngineScheduledFlag__c SpecialityFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
   TMEngineScheduledFlag__c TMWeekendFlag = TMEngineScheduledFlag__c.getInstance('TMEngineWeekend_flag');
   TMEngineScheduledFlag__c SpecialtyRealignFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyRealignmentBatchFlag');
   

  if(trigger.new[0].Type__c != NULL && RuleEngineFlag.SchedularFlag__c == true && trigger.new[0].Type__c != 'Specialty Realignment'){
    trigger.new[0].REgion__c.addError('Rules engine batch is already running in apex jobs. You cannot schedule any job related to same');
   }
  else if(trigger.new[0].Type__c != NULL && SpecialityFlag.SchedularFlag__c == true && trigger.new[0].Type__c == 'Territory Management' ){
   trigger.new[0].REgion__c.addError('Another batch is already running in apex jobs. You cannot schedule any job related to same.');
   }
  else if(trigger.new[0].Type__c == 'Territory Management' && TMWeekendFlag.SchedularFlag__c == true && RuleEngineFlag.SchedularFlag__c == true){
   trigger.new[0].REgion__c.addError('Weekend rules engine is running. You can not schedule any job related to same.');
  }
  else{
   // If Region is not selected in Realignment Schedular Tab this error will get.

       if((trigger.new[0].Type__c == 'Territory Management' || trigger.new[0].Type__c == 'Specialty Realignment')  && trigger.new[0].Region__C == Null && (SpecialityFlag.SchedularFlag__c == false && RuleEngineFlag.SchedularFlag__c == false && TMWeekendFlag.SchedularFlag__c == false)){
          trigger.new[0].REgion__c.addError('Choose Region value to process the Realignment job of Territory Management option');
       }
       if(((trigger.new[0].Type__c == 'Specialty Realignment' || trigger.new[0].Type__c == 'Specialty Oppty Update' || trigger.new[0].Type__c == 'Specialty On OLI Delete')  && trigger.new[0].Account_Record_Type__c != null ) && (SpecialityFlag.SchedularFlag__c == false && RuleEngineFlag.SchedularFlag__c == false && TMWeekendFlag.SchedularFlag__c == false) ){
          trigger.new[0].Account_Record_Type__c.addError('Choose AccountRecordtype value must be "none". Not customer or partner when you need to schedule Speciality related jobs');
       }
  }
}
    
    
    
 //sreenath - 2089  10/18/2012 ends
}