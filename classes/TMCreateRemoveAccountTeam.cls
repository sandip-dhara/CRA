/**********************************************************
* Class Name: TMCreateRemoveAccountTeam 
* Author: HP (CR-3737)
* Description: This is a batch class that performs creation and removal of Account Team based on changes to 
*              "Add to Account Team" flag on Sales Territory User Assignment Object.
***********************************************************/


global class TMCreateRemoveAccountTeam implements Database.batchable<sObject> ,  Database.Stateful{

    global String stAccnttoProcess = 'Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Sales_Territory__r.Account_Team_Changes__c = true and Sales_Territory__r.IsActive__c = true and Assignment_Type__c = \'Territory Engine\'';
    // TM: R4 EF CR-0595: Nasir Jawed : Start: Variable added to get the current date and time when the batch starts.
      global Datetime currentTime = system.Now();
      global String formatedDt = currentTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    // TM: R4 EF CR-0595: Nasir Jawed : Start
    
    /**
    * @description: Queries accounts in Sales_Territory_Account_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/
    global Database.queryLocator start(Database.BatchableContext ctx){
         system.debug('ctime:' + currentTime);
         if ( Test.isRunningTest() ) stAccnttoProcess += ' limit 50';
         return Database.getQueryLocator(stAccnttoProcess);
    }
    
    /**
    * @description: Execute method for finding Sales Territory Users whose Add to Account Team has undergone change and
    *               searches corrsponding Account Team records to add to remove those users 
    * @param: Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> stAccnttoProcessList){
        
        try{
            Map<Id,Set<Id>> stAcctMap = new Map<Id,Set<Id>>();
            Map<Id,Set<Sales_Territory_User_Assignment__c>> stUserAccTeamTrueMap = new Map<Id,Set<Sales_Territory_User_Assignment__c>>();
            Map<Id,Set<Id>> stUserAccTeamFalseMap = new Map<Id,Set<Id>>();
            Set<Id> stSet = new Set<Id>(); 
            
            //Create a Map of Sale Territory and Accounts and a Set of Sales Territories
            for(Sales_Territory_Account_Assignment__c stacc : stAccnttoProcessList){
                Set<Id> tempaccIdSet = stAcctMap.get(stacc.Sales_Territory__c);
                if(tempaccIdSet == null){
                    tempaccIdSet = new Set<Id>();
                }
                tempaccIdSet.add(stacc.Account__c);
                stAcctMap.put(stacc.Sales_Territory__c,tempaccIdSet);
                stSet.add(stacc.Sales_Territory__c);
            }
            
            //Create 2 Maps for Sales Territory and related Users which need changes in Account Team
            List<Sales_Territory_User_Assignment__c> activeTerritoryUsers = Database.Query('Select Id, User__c, Sales_Territory__c, Add_to_Account_Team__c,Team_Role__c,Account_Team_Role__c from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true and Sales_Territory__c IN : stSet and User__r.IsActive = true');
            List<Sales_Territory_User_Assignment__c> inActiveTerritoryUsers = Database.Query('Select Id, User__c, Sales_Territory__c, Add_to_Account_Team__c,Team_Role__c,Account_Team_Role__c from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true and Sales_Territory__c IN : stSet and User__r.IsActive = false');            
            
           // for(Sales_Territory_User_Assignment__c stua: [Select Id, User__c, Sales_Territory__c, Add_to_Account_Team__c, Account_Team_Role__c from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true and Sales_Territory__c IN : stSet and IsActive__c = true and User__r.IsActive = true]){
           for(Sales_Territory_User_Assignment__c stua: activeTerritoryUsers ){
                if(stua.Add_to_Account_Team__c == true){
                    Set<Sales_Territory_User_Assignment__c> tempSTUserSet = stUserAccTeamTrueMap.get(stua.Sales_Territory__c);
                    if(tempSTUserSet == null){
                        tempSTUserSet = new Set<Sales_Territory_User_Assignment__c>();
                    }
                    tempSTUserSet.add(stua);
                    stUserAccTeamTrueMap.put(stua.Sales_Territory__c,tempSTUserSet);
                }else{
                    Set<Id> tempSTUserSet = stUserAccTeamFalseMap.get(stua.Sales_Territory__c);
                    if(tempSTUserSet == null){
                        tempSTUserSet = new Set<Id>();
                    }
                    tempSTUserSet.add(stua.User__c);
                    stUserAccTeamFalseMap.put(stua.Sales_Territory__c,tempSTUserSet);
                }
            }
            for(Sales_Territory_User_Assignment__c stua1: inActiveTerritoryUsers){
                if(stua1.Add_to_Account_Team__c == false){
                    Set<Id> tempSTUserSet1 = stUserAccTeamFalseMap.get(stua1.Sales_Territory__c);
                    if(tempSTUserSet1 == null){
                        tempSTUserSet1 = new Set<Id>();
                    }
                    tempSTUserSet1.add(stua1.User__c);
                    stUserAccTeamFalseMap.put(stua1.Sales_Territory__c,tempSTUserSet1);
                }
            }
            CreateGroupMemberForTerrUser.addAccountTeamForSTUsers(stAcctMap,stUserAccTeamTrueMap);
            CreateGroupMemberForTerrUser.delAccountTeamForSTUsers(stAcctMap,stUserAccTeamFalseMap);
        }catch (Exception e){
            system.debug('*****Exception in TMCreateRemoveAccountTeam****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching Geo rules 
    * @param: Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accountToProcessList - accounts list to process
    **/      
    global void finish(Database.BatchableContext ctx){
        //String stQuery = 'Select count() from Sales_Territory__c where Account_Team_Changes__c = true limit 9000';
        //Integer i = Database.countQuery(stQuery);
        //if (i >= 5000){
            // TM: R4 EF CR-0595: Nasir Jawed : Start: In query "AND currentTime=>LastModifiedDate" added so only those records come which got picked up by the batch for which changes were made before the start of batch.
            String queParam1 = 'Select Id, Account_Team_Changes__c,MyComp_Sales_Territory_Name__c from Sales_Territory__c where Account_Team_Changes__c = true' +  ' AND'+  ' LastModifiedDate <'+ formatedDt ;
            // TM: R4 EF CR-0595: Nasir Jawed : End
            system.debug('query:' + queParam1);
            String param1 = 'Account_Team_Changes__c';
            //Id batchEvalTerr1 = Database.executeBatch(new EvaluateTerrRealignBatch(queParam1,param1),150);
            
            //TM:Sreenath scheduling a batch from a batch without cron expression starts
            EvaluateTerrRealignBatch ETRB3 = new EvaluateTerrRealignBatch(queParam1,param1);
            String cronID4 = System.scheduleBatch(ETRB3, 'EvaluateTerrRealign_Batch_Job_1', 3);
            //TM:Sreenath scheduling a batch from a batch without cron expression ends
            
        //}else{
        //    List<Sales_Territory__c> stList = new List<Sales_Territory__c>();
        //    for(Sales_Territory__c strec : [Select Id, Account_Team_Changes__c from Sales_Territory__c where Account_Team_Changes__c = true]){
        //        strec.Account_Team_Changes__c = false;
        //        stList.add(strec);
        //    }
        //    update stList;
        //}
        //String stuaQuery = 'Select count() from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true';
        //Integer c = Database.countQuery(stuaQuery);
        //if (c >= 5000){
            // TM: R4 EF CR-0595: Nasir Jawed : Start: In query "AND currentTime=>LastModifiedDate" added so only those records come which got picked up by the batch for which changes were made before the start of batch.
            String queParam = 'Select Id, New_Or_Changed__c from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true ' +  ' AND' +  ' LastModifiedDate <'+ formatedDt;
            // TM: R4 EF CR-0595: Nasir Jawed : End
            String param = 'New_Or_Changed__c';
            //Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(queParam,param),150);
            
            //TM:Sreenath scheduling a batch from a batch without cron expression starts
            EvaluateTerrRealignBatch ETRB4 = new EvaluateTerrRealignBatch(queParam,param);
            String cronID5 = System.scheduleBatch(ETRB4, 'EvaluateTerrRealign_Batch_Job_2', 6);
            //TM:Sreenath scheduling a batch from a batch without cron expression ends
            
            
        //}else if(c < 5000){
        //    List<Sales_Territory_User_Assignment__c> stuaList = new List<Sales_Territory_User_Assignment__c>();
        //    for(Sales_Territory_User_Assignment__c stuarec : [Select Id, New_Or_Changed__c from Sales_Territory_User_Assignment__c where New_Or_Changed__c = true limit 5000]){
        //        stuarec.New_Or_Changed__c = false;
        //        stuaList.add(stuarec);
        //    }
        //    update stuaList;
        //}
        
         //Mail notification...
        AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                    WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'TM Create-Remove Account Team has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
    
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
     
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setReplyTo('noreply@salesforce.com');  
        mail.setSenderDisplayName('Batch Job Summary');  
        mail.setSubject('Batch Job Completed - TM Create-Remove Account Team Batch'); 
        mail.setPlainTextBody(emailMessage);  
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail });
        //TM:Sreenath removing this batches from hourly rules engine cycle & handling separated batches starts
        /*ProductSpecUserBatchScheduler accTeamSc = new ProductSpecUserBatchScheduler();
        
        datetime currentDateTime = datetime.now();
        String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
        String schExp = '0 '+min+' * * * ? ';
        system.schedule('TM-Product Specialty User'+datetime.now(), schExp, accTeamSc);*/
        
         //TM: Sreenath 06/11/2013 issue of below createAccountTeamflag unchecking starts
        TMEngineScheduledFlag__c CreateRemAcctTeamFlag = TMEngineScheduledFlag__c.getInstance('CreateRemAcctTeam');
       
        if(CreateRemAcctTeamFlag != null && CreateRemAcctTeamFlag.SchedularFlag__c){
            try{
                CreateRemAcctTeamFlag.SchedularFlag__c = false;
                update CreateRemAcctTeamFlag;
            }
            catch(Exception exp){
                system.debug('Exception Occured while updating CreateRemAcctTeam Flag to false '+exp.getMessage());
            }
        }
        
        //TM: Sreenath 06/11/2013 issue of below flag unchecking ends
        
        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c){
            try{
                //Update to true
                specialtyFlag.SchedularFlag__c = true;
                update specialtyFlag;
            }catch(Exception exp){
                system.debug('Exception Occured while updating Specialty Flag to true '+exp.getMessage());
            }
            SpecialtyBatchScheduler specialtySc = new SpecialtyBatchScheduler();
        
            datetime currentDateTime = datetime.now();
            String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
            
            String schExp = '0 '+min+' * * * ? ';
            system.schedule(Label.Specialty_Batch_Job+datetime.now(), schExp, specialtySc);
        //TM:Sreenath removing this batches from hourly rules engine cycle & handling separated batches ends
        }
        
    }
}