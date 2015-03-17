/**********************************************************
* Class Name: TMProcessCleanUpBatch 
* Author: HP
* Description: This batch deletes associations and shares between Account and Sales Territories no longer Valid
***********************************************************/
global class TMProcessCleanUpBatch implements Database.batchable<sObject> ,  Database.Stateful{
      
    global String stAcctoProcess = 'Select Id, Account__c, Sales_Territory__c, AddToAccountProcess__c, TrackAssociationToDelete__c, Sales_Territory__r.GroupId__c from Sales_Territory_Account_Assignment__c where TrackAssociationToDelete__c = true';
     
         
    /**
    * @description: Queries accounts in Sales_Territory_Account_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/ 
    global Database.queryLocator start(Database.BatchableContext ctx){
        
         if ( Test.isRunningTest() ) stAcctoProcess += ' limit 30';
         return Database.getQueryLocator(stAcctoProcess);
    }
    
    /**
    * @description: Execute method for finding matching Geo rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> stAcctoProcessList){
        
        try{
            List<Sales_Territory_Account_Assignment__c> stuaDelList = new List <Sales_Territory_Account_Assignment__c>();
            List<AccountTeamMember> accTeamToDel = new List<AccountTeamMember>();
            List<AccountShare> accShareToDel = new List<AccountShare>();
            List<OpportunityShare> optySharetoDel = new list<OpportunityShare>();
            Set<Id> accountToDel = new Set<Id>();
            TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
            String recType = obj1.AccountRecordType__c ;
            
            Set<String> accIdGrpIdConSet = new Set<String>();
            Set<Id> grpRefrSet = new Set<Id>();
            Set<id> sTerrId = new Set<id>();
            
            Map<Id, Set<Id>> aIdSalesTIdMap = new Map<Id, Set<Id>>();
            Map<Id, Set<Id>> stIdUserAMap = new Map<Id, Set<Id>>();
            
            for(Sales_Territory_Account_Assignment__c stua : stAcctoProcessList){
                stuaDelList.add(stua);
                grpRefrSet.add(stua.Sales_Territory__r.GroupId__c);
                accIdGrpIdConSet.add('' + stua.Account__c + stua.Sales_Territory__r.GroupId__c);
                accountToDel.add(stua.Account__c);
                
                // START (A)- TM : Ritesh -Deletion of Account team for TrackAssociationToDelete__c flagged records
                sTerrId.add(stua.Sales_Territory__c);
                Set<Id> tempIdSet = aIdSalesTIdMap.get(stua.Account__c);
                if(null == tempIdSet){
                    tempIdSet = new Set<Id>();              
                }
                tempIdSet.add(stua.Sales_Territory__c);
                aIdSalesTIdMap.put(stua.Account__c, tempIdSet);
                // TM : Ritesh -Deletion of Account team for TrackAssociationToDelete__c flagged records : END (A)
            }
            
            // START (B)- TM : Ritesh -Deletion of Account team for TrackAssociationToDelete__c flagged records
            Set<Id> userIdSet = new Set<Id>();
            if(!sTerrId.isEmpty()){
                for(Sales_Territory_User_Assignment__c stuaObj : [Select User__c, User__r.IsActive, Sales_Territory__c From Sales_Territory_User_Assignment__c 
                                                                    where Sales_Territory__c IN : sTerrId AND Add_to_Account_Team__c = true AND IsActive__c = true]){
                    userIdSet.add(stuaObj.User__c);
                    
                    Set<Id> tempSet = stIdUserAMap.get(stuaObj.Sales_Territory__c);
                    if(null == tempSet){
                        tempSet =  new Set<Id>();
                    }
                    tempSet.add(stuaObj.User__c);
                    stIdUserAMap.put(stuaObj.Sales_Territory__c, tempSet);
                }
            }
             
            // To create Map for Account Id & Sales Terr User Assignmnt Set      
            Set<String> uIdAccIdkeySet = new Set<String>();                                           
            for(Id accId : aIdSalesTIdMap.keySet()){
                Set<Sales_Territory_User_Assignment__c> tempSet = new Set<Sales_Territory_User_Assignment__c>();
            
                for(Id stId : aIdSalesTIdMap.get(accId)){
                    if(null != stIdUserAMap && null != stIdUserAMap.get(stId)){
                        for(Id uId : stIdUserAMap.get(stId)){
                            uIdAccIdkeySet.add('' + uId + accId);
                        }
                    }
                }
            }
            
            // Cleans the map/set to reduce heap size
            aIdSalesTIdMap.clear();
            stIdUserAMap.clear();
            
            List<AccountTeamMember> ateamMemList = new List<AccountTeamMember>();
            for(AccountTeamMember aTeam : [Select Id, AccountId, UserId from AccountTeamMember where AccountId IN: accountToDel AND UserId IN : userIdSet]){
                if (uIdAccIdkeySet.contains('' + aTeam.UserId + aTeam.AccountId)){
                    ateamMemList.add(aTeam);
                }
            }
        
            //delete account team...
            if(!ateamMemList.isEmpty()){
                delete ateamMemList;
            }
            // TM : Ritesh -Deletion of Account team for TrackAssociationToDelete__c flagged records : END (A)
            
            //-----------------------------------------------------------------------------------------------------------------------------------//
            if(!stuaDelList.isEmpty()){
                delete stuaDelList;
            }
            
            system.debug('***ateamMemList****' + ateamMemList.size() + '----stuaDelList****' + stuaDelList.size());
            
            //To Delete records in AccountTeamMember.
            if(!accountToDel.isEmpty()){    
                
                //To Delete records in AccountShare.
               if(recType == 'Customer')
               {
                    for(AccountShare accSh : [Select Id, AccountId, UserOrGroupId from AccountShare where AccountId IN : accountToDel AND UserOrGroupId IN : grpRefrSet AND RowCause = 'Manual']){
                        if(accIdGrpIdConSet.contains('' + accSh.AccountId + accSh.UserOrGroupId)){
                            accShareToDel.add(accSh);   
                        }       
                    }
                    
                if(!accShareToDel.isEmpty()){
                    delete accShareToDel;
                }
               }
               if(recType == 'Partner')
               {
                    Map<String, AccountShare> createAccShareMap = new Map<String, AccountShare>();
                    Map<String, OpportunityShare> createOptyShareMap = new Map<String, OpportunityShare>();            
                    Map<Id,List<Location__c>> accAssign = new   Map<Id,List<Location__c>>(); 
                    Map<Id,List<Id>> optyAssign = new   Map<Id,List<Id>>(); 
                    Map<Id,List<OpportunityShare>> optyShareAssign = new Map<Id,List<OpportunityShare>>();            
                     
                    List<Location__c> locAcc = [select id,Account__c from location__c where Account__c in :accountToDel];
                    List<Channel_Partner__c> optyList = [Select Id,Opportunity__c,Location__c From Channel_Partner__c where Location__c in :locAcc];
                    List<OpportunityShare> optyShares = new List<OpportunityShare>();
                    List<OpportunityShare> optyShareToDelete = new List<OpportunityShare>();
                    List<Id> optyIdTemp = new List<Id>();
                    boolean optyProc = false;
                        for(Id aId : accountToDel)
                        {
                            List<Location__c> tempLoc = new List<Location__c>();
                            for(integer i = 0 ; i<locAcc.size(); i++)
                            {
                                if(aid == locAcc[i].Account__c)
                                {
                                    tempLoc.add(locAcc[i]);
                                }
                            }
                            accAssign.put(aid,tempLoc);
                        }                   
                        for(Location__c lId : locAcc)
                        {
                            List<Id> tempOpty = new List<Id>();
                            for(integer i = 0 ; i<optyList.size(); i++)
                            {
                                if(!optyProc)
                                {
                                    optyIdTemp.add(optyList[i].Opportunity__c);
                                }
                                if(lId.Id == optyList[i].Location__c)
                                {
                                    tempOpty.add(optyList[i].Opportunity__c);
                                }
                            }
                            optyProc = true;
                            optyAssign.put(lId.Id,tempOpty);
                        }
                        optyShares = [select id,UserorGroupId,opportunityId, rowcause from OpportunityShare where opportunityid in :optyIdTemp];
                        
                        for(Id tempOptyId :optyIdTemp)
                        {
                            List<OpportunityShare> tempShare = new List<OpportunityShare>();
                            for(OpportunityShare tempOptyShare : optyShares)
                            {
                                if(tempOptyId == tempOptyShare.opportunityId)
                                {
                                    tempShare.add(tempOptyShare);
                                }
                            }
                            optyShareAssign.put(tempOptyId,tempShare);
                            
                        }                       
                        
                        for(Id accId : accAssign.keyset())
                        {
                            for(Location__c locId : accAssign.get(accId))
                            {
                                for(Id optyId : optyAssign.get(locId.id))
                                {
                                    for(OpportunityShare optyShare : optyShareAssign.get(optyId))
                                    {
                                        for(Id tempGrpId : grpRefrSet)
                                        {
                                            if(optyShare.UserorGroupId == tempGrpId)
                                            {
                                                optyShareToDelete.add(optyShare);
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                        system.debug('Opportunity Share to delete' + optyShareToDelete);
                          if(!optyShareToDelete.isEmpty())
                          {
                                delete optyShareToDelete;
                          }                               
                    }
                }
        }catch(Exception e){
            system.debug('*****Exception in processCleanUpBatchforTM****' + e.getMessage());
        }
    }
    
    /**
    * @description: finish method for sending completion mail of matching Geo rules 
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/      
    global void finish(Database.BatchableContext ctx){
        
        //Mail notification...
        AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                        WHERE id = :ctx.getJobId()];  
        String emailMessage = 'Your batch job ' 
                              + 'APEX Batch Job for '
                              + 'TM Process Clean up' + ' has finished. It executed '  
                              + a.totalJobItems   
                              + ' batches.';  
        
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage(); 
         
        String[] toAddresses = new String[] {a.CreatedBy.Email};  
        mail.setToAddresses(toAddresses);  
        mail.setReplyTo('noreply@salesforce.com');  
        mail.setSenderDisplayName('Batch Job Summary'); 
        mail.setSubject('Batch Job Completed - TM Process Clean up Batch'); 
        mail.setPlainTextBody(emailMessage);  
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail }); 
                                      
        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
        TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        String currentRecordType = obj1.AccountRecordType__c;        
        system.debug('test'+Robj2.AccountRecordType__c);
        if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c && Robj2.AccountRecordType__c == 'Americas' && currentRecordType == 'Partner'){
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
            }
        else{
            //TM:Ritesh: Req:2089: 24th Oct, 2012: Account Team creation moved to a seperate batch...
            TMAddToAccountTeamScheduler sc = new TMAddToAccountTeamScheduler();
        
            datetime currentDateTime = datetime.now();
            String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
        
            String schExp = '0 '+min+' * * * ? ';
            system.schedule('TM-Add To Account Team Job'+datetime.now(), schExp, sc);
        }
    }
}