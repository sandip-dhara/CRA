/**********************************************************
* Class Name: TMAddToAccountTeamBatch 
* Author: Accenture
* Description: This is a batch class that performs creation of Account Team Member for TM.
***********************************************************/
global class TMAddToAccountTeamBatch implements Database.batchable<sObject> ,  Database.Stateful
{

    //global String accountToProcess = 'Select Id, Account__c, TrackAssociationToDelete__c, Sales_Territory__c, AddToAccountProcess__c from Sales_Territory_Account_Assignment__c where Assignment_Type__c = \'Territory Engine\' AND (AddToAccountProcess__c = true OR Sales_Territory__r.Account_Team_Changes__c=true)';
    global String accountToProcess = 'Select Id, Account__c, TrackAssociationToDelete__c, Sales_Territory__c, AddToAccountProcess__c from Sales_Territory_Account_Assignment__c where Assignment_Type__c = \'Territory Engine\' AND (AddToAccountProcess__c = true)';
    
    /* Delta changes Data ------ Sreenath 10/23/2012 Req. 2089  Starts */
    
    TMEngineScheduledFlag__c Wobj1 = TMEngineScheduledFlag__c.getValues('TMEngineWeekend_flag');
    
    TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
    
    TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');

    TMEngineAccountRecordType__c Robj2 = TMEngineAccountRecordType__c.getValues('Realignment_Region');
    
    TMEngineAccountRecordType__c objSR = TMEngineAccountRecordType__c.getValues('Realignment_SubRegion1');
    
    TerritoryDeltaChanges__c Terrchanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
    
    TM_Suspend_APJ_Realignment__c ApjSuspend = TM_Suspend_APJ_Realignment__c.getValues('APJSuspension');
    
    TM_Suspend_APJ_Realignment__c EmeaSuspend = TM_Suspend_APJ_Realignment__c.getValues('EMEASupsension');
    
    TM_Suspend_APJ_Realignment__c AmsSuspend = TM_Suspend_APJ_Realignment__c.getValues('AMSSuspension');
    
    TM_Suspend_APJ_Realignment__c ApjSuspendPartner = TM_Suspend_APJ_Realignment__c.getValues('APJSuspensionPartner');
    
    TM_Suspend_APJ_Realignment__c EmeaSuspendPartner = TM_Suspend_APJ_Realignment__c.getValues('EMEASupsensionPartner');
    
    TM_Suspend_APJ_Realignment__c AmsSuspendpartner = TM_Suspend_APJ_Realignment__c.getValues('AMSSuspensionPartner');
    
    
    String ShortDayOfweek = DateTime.now().format('EEE');
    
    datetime CurrentDateTime = datetime.now();
    String Hour = String.valueOf(math.mod((currentDateTime.HourGMT()+7),60));
    String Min = String.valueOf(math.mod((currentDateTime.minute() +2),60));
    
    /* Delta changes Data ------ Sreenath 10/23/2012 Req. 2089  ENDS */ 
    
    /**
    * @description: Queries accounts in Sales_Territory_Account_Assignment__c to process
    * @param: Database.BatchableContext ctx
    * @return: Database queryLocator
    **/    
    global Database.queryLocator start(Database.BatchableContext ctx){                 
        // TM: Debmalya: Req-2089 Oct 22, 2012:Handle Incremental changes in Territory:Start
        //Query in incremental load
        TerritoryDeltaChanges__c deltaChanges = TerritoryDeltaChanges__c.getValues('RealignmentProcess');
        if(deltaChanges.Territory_Evaluation__c){
            accountToProcess = accountToProcess.substring(0,accountToProcess.length()-1);
            accountToProcess += ' OR Sales_Territory__r.Account_Team_Changes__c=true)';
            accountToProcess += ' AND Sales_Territory__r.EvaluateTerritory_for_Realignment__c = true';
        }
        // TM: Debmalya: Req-2089 Oct 22, 2012:Handle Incremental changes in Territory:End    
        
        system.debug('****accountToProcess in Account Team----' + accountToProcess);                
        if ( Test.isRunningTest() ) accountToProcess += ' limit 5';
        return Database.getQueryLocator(accountToProcess);
    }
     
    /**
    * @description: Execute method for finding matching Geo rules
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/
    global void execute(Database.BatchableContext ctx, List<Sales_Territory_Account_Assignment__c> accountToProcessList)
    {
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        String currentRecordType = obj1.AccountRecordType__c;
        if(currentRecordType == 'Customer')
        {        
        try
        {
            Set<Id> salesTIdSet = new Set<Id>();
            Set<Id> acctId = new Set<id>();
            Set<String> staaDel = new Set<String>();
            Map<Id, Set<Id>> aIdSalesTIdMap = new Map<Id, Set<Id>>();
            Map<Id, Set<Sales_Territory_User_Assignment__c>> stIdUserAMap = new Map<Id, Set<Sales_Territory_User_Assignment__c>>();
            Map<Id, Set<Sales_Territory_User_Assignment__c>> accIdSTUserAObjMap = new Map<Id, Set<Sales_Territory_User_Assignment__c>>();
            List<Sales_Territory_Account_Assignment__c> aTeamList = new List<Sales_Territory_Account_Assignment__c>();
            
            // To create Map of Account Id & Sales Territory Id
            for(Sales_Territory_Account_Assignment__c aObj : accountToProcessList){
    
                salesTIdSet.add(aObj.Sales_Territory__c);
                acctId.add(aObj.Account__c);
                
                Set<Id> tempIdSet = aIdSalesTIdMap.get(aObj.Account__c);
                if(null == tempIdSet){
                    tempIdSet = new Set<Id>();              
                }
                tempIdSet.add(aObj.Sales_Territory__c);
                aIdSalesTIdMap.put(aObj.Account__c, tempIdSet);
            
                //flagging AddToAccountProcess__c as false...
                aObj.AddToAccountProcess__c = false;
                aTeamList.add(aObj);         
            }
            
            Set<Id> userIdSet = new Set<Id>();
            // To create Map for Sales Terr Id & Sales Terr User Assignment Set
            if(!salesTIdSet.isEmpty()){
                for(Sales_Territory_User_Assignment__c stuaObj : [Select User__c, User__r.IsActive, Sales_Territory__c, Account_Team_Role__c, Add_to_Account_Team__c From Sales_Territory_User_Assignment__c 
                                                                    where Sales_Territory__c IN : salesTIdSet AND Add_to_Account_Team__c = true AND IsActive__c = true AND User__r.IsActive = true]){
                    userIdSet.add(stuaObj.User__c);
                                                                        
                    Set<Sales_Territory_User_Assignment__c> tempSet = stIdUserAMap.get(stuaObj.Sales_Territory__c);
                    if(null == tempSet){
                        tempSet =  new Set<Sales_Territory_User_Assignment__c>();
                    }
                    tempSet.add(stuaObj);
                    stIdUserAMap.put(stuaObj.Sales_Territory__c, tempSet);
                }
                // Cleans the Set to reduce heap size
                salesTIdSet.clear();
            }
            
            Set<String> uIdAccIdkeySet = new Set<String>();
            List<AccountTeamMember> ateamMemList = new List<AccountTeamMember>();
            if(!userIdSet.isEmpty()){
                for(AccountTeamMember aTeam : [Select Id, AccountId, UserId from AccountTeamMember where AccountId IN: acctId AND UserId IN : userIdSet]){
                    ateamMemList.add(aTeam);
                    uIdAccIdkeySet.add('' + aTeam.UserId + aTeam.AccountId);
                }
            }
            // Cleans the Set to reduce heap size
                acctId.clear();
                userIdSet.clear();
                
            // To create Map for Account Id & Sales Terr User Assignmnt Set                                                 
            for(Id accId : aIdSalesTIdMap.keySet()){
                Set<Sales_Territory_User_Assignment__c> tempSet = new Set<Sales_Territory_User_Assignment__c>();
                
                for(Id stId : aIdSalesTIdMap.get(accId)){
                    if(null != stIdUserAMap && null != stIdUserAMap.get(stId)){
                        tempSet.addAll(stIdUserAMap.get(stId));
                    }
                }
                if(!tempSet.isEmpty()){
                    accIdSTUserAObjMap.put(accId, tempSet);
                }
            }
            // Cleans the map/set to reduce heap size
            aIdSalesTIdMap.clear();
            stIdUserAMap.clear();
            
            
            // To create Account Team Entry for User Assignment record having Add to Account Team Checked.
            List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>();
            for(Id accId : accIdSTUserAObjMap.keySet()){
                
                for(Sales_Territory_User_Assignment__c stuaObj : accIdSTUserAObjMap.get(accId)){
                    
                    if(stuaObj.Add_to_Account_Team__c && stuaObj.User__r.IsActive && !uIdAccIdkeySet.contains('' + stuaObj.User__c + accId)){
                        accountTeamList.add(new AccountTeamMember (UserId = stuaObj.User__c, TeamMemberRole= stuaObj.Team_Role__c , AccountId = accId));
                    } 
                    else if(uIdAccIdkeySet.contains('' + stuaObj.User__c + accId)){
                        uIdAccIdkeySet.remove('' + stuaObj.User__c + accId);
                    }
                }
            }
            
            // Cleans the map to reduce heap size
            accIdSTUserAObjMap.clear();
            
            List<AccountTeamMember> aTeamToDel = new List<AccountTeamMember>();
            for(AccountTeamMember aT : ateamMemList){
                if(uIdAccIdkeySet.size() > 0 & uIdAccIdkeySet.contains('' + aT.UserId + aT.AccountId)){
                    aTeamToDel.add(aT);             
                }
            }
            // Cleans the set to reduce heap size
            uIdAccIdkeySet.clear();
            
            system.debug('****accountTeamList****' + accountTeamList.size()+ '***' + aTeamToDel.size() + '****' + aTeamList.size());
            
            //delete account team...
            if(!aTeamToDel.isEmpty()){
                delete aTeamToDel;
            }
            
            // create Account team entries....    
            if(!accountTeamList.isEmpty()){
                database.insert(accountTeamList, false);
            }
            
            // update the Account Assignment by setting AddToAccountProcess flag to false...
            if(!aTeamList.isEmpty()){
                update aTeamList;
            }
             
            }catch(Exception e){
                system.debug('*****Exception in addToAccountTeamforTM****' + e.getMessage());
            }
        }
    }
    /**
    * @description: finish method for sending completion mail of matching Geo rules 
    * @param: Database.BatchableContext ctx, List<Account> accountToProcessList - accounts list to process
    **/      
    
    global void finish(Database.BatchableContext ctx)
    {
        TMEngineAccountRecordType__c obj1 = TMEngineAccountRecordType__c.getValues(Label.AccRecTypeVal);
        String currentRecordType = obj1.AccountRecordType__c;
        datetime currentDateTime = datetime.now();  
        system.debug(currentRecordType);
        string TerrListvalues = 'select id,EvaluateTerritory_for_Realignment__c,MyComp_Sales_Territory_Name__c  from Sales_Territory__c where EvaluateTerritory_for_Realignment__c = true';
        String param = 'EvaluateTerritory_for_Realignment__c';        
        if (currentRecordType == 'Customer')
        {
            if(Wobj1.SchedularFlag__c == false && Robj2.AccountRecordType__c == 'None')
            {     
                try
                {
                    obj1.AccountRecordType__c = 'Partner';
                    update obj1;
                }
                catch (Exception e)
                {
                    system.debug('****Exception in TM Account Record type change to Partner ****' + e.getMessage());
                }
            }   
            if(Wobj1.SchedularFlag__c == true)
            {             
                try
                {
                    obj.SchedularFlag__c = false;
                    update obj;
                }
                catch(Exception e)
                {
                    system.debug('****Exception in TM Scheldular flagging to false ****' + e.getMessage());
                }            
            }            
            AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                   WHERE id = :ctx.getJobId()];  
            String emailMessage = 'Your batch job ' 
                                  + 'APEX Batch Job for '
                                  + 'TM Add To Account Team has finished. It executed '  
                                  + a.totalJobItems   
                                  + ' batches.';  
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();         
            String[] toAddresses = new String[] {a.CreatedBy.Email};  
            mail.setToAddresses(toAddresses);  
            mail.setReplyTo('noreply@salesforce.com');  
            mail.setSenderDisplayName('Batch Job Summary');  
            mail.setSubject('Batch Job Completed - TM Add to Account Team Batch'); 
            mail.setPlainTextBody(emailMessage);  
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]   
                          { mail });
            Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('Account Profile batch size').Batch_Size__c);                           
            if(Wobj1.SchedularFlag__c == false && Robj2.AccountRecordType__c != 'None')
            { 
                 TerrListvalues += ' AND IsPartner__c = false';
                 if(Robj2.AccountRecordType__c == 'Asia Pacific')
                 {
                    TerrListvalues += ' AND (MyComp_Territory_Region__c = \'APJ\' OR MyComp_Territory_Region__c = \'Asia Pacific\')';
                 }
                 else if(Robj2.AccountRecordType__c == 'EMEA')
                 {
                    TerrListvalues += ' AND MyComp_Territory_Region__c = \'EMEA\'';
                 }
                 else if(Robj2.AccountRecordType__c == 'Americas')
                 {
                    TerrListvalues += ' AND (MyComp_Territory_Region__c = \'AMS\' OR MyComp_Territory_Region__c = \'Americas\')';
                 }
                Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(TerrListvalues,param),150);
                if(obj.SchedularFlag__c)
                {
                    try 
                    {
                        obj.SchedularFlag__c = false;
                        update obj;
                        //Raghvendra:07/06/2013:ALM:10062 : commented below two lines :Start
                        //Robj2.AccountRecordType__c = 'None';     
                        //update Robj2;
                        //Raghvendra:07/06/2013:ALM:10062 : commented below two lines :End
                        Terrchanges.Territory_Evaluation__c = false;
                        update Terrchanges;               
                        //specialtyFlag.SchedularFlag__c = false;
                        //update specialtyFlag;
                        if(objSR.AccountRecordType__c != '' )
                        {  
                            objSR.AccountRecordType__c = '';     
                            Update objSR;
                        }      
                    }
                    catch(Exception e)
                    {
                        system.debug('****Exception in TM Scheldular flagging to false ****' + e.getMessage());
                    }          
                } 
                String min1 = String.valueOf(math.mod((currentDateTime.minute() +2),60));          
                String CRON_EXP = '0 '+min1+' * * * ?';
                TMEngineSchelduled sch = new TMEngineSchelduled();
                system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch);
           }                   
           if(Wobj1.SchedularFlag__c == false && Robj2.AccountRecordType__c == 'None')
           {
               Id batchId = Database.executeBatch(new TMProcessAccountProfRulesBatch(), batchSize);
           }
        }
        else
        {
            try 
            {
                TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues(Label.SchedularFlagVal);
                obj.SchedularFlag__c = false;                                        
                update obj;
                //specialtyFlag.SchedularFlag__c = false;
                //update specialtyFlag;
                Terrchanges.Territory_Evaluation__c = false;
                update Terrchanges; 
            }
            catch(Exception e)
            {
                system.debug('****Exception in TM Scheldular flagging to false ****' + e.getMessage());
            } 
            AsyncApexJob a = [SELECT id, ApexClassId,  JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob   
                                                                                                                            WHERE id = :ctx.getJobId()];  
            String emailMessage = 'Your batch job ' 
                                  + 'APEX Batch Job for '
                                  + 'TM Add To Account Team has finished. It executed '  
                                    + a.totalJobItems   
                                    + ' batches.';      
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();      
            String[] toAddresses = new String[] {a.CreatedBy.Email};  
            mail.setToAddresses(toAddresses);  
            mail.setReplyTo('noreply@salesforce.com');  
            mail.setSenderDisplayName('Batch Job Summary');  
            mail.setSubject('Batch Job Completed - Add to Account Team Batch'); 
            mail.setPlainTextBody(emailMessage);  
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail }); 
            
            if(Wobj1.SchedularFlag__c == false && Robj2.AccountRecordType__c == 'None')
            {           
                String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));            
                TMCreateRemoveAcctScheduler accTeamSc = new TMCreateRemoveAcctScheduler();
                String schExp = '0 '+min1+' * * * ? ';
                system.schedule('TM-Create-Remove Account Team'+datetime.now(), schExp, accTeamSc);                  
                obj1.AccountRecordType__c = 'Customer';
                update obj1;
            }          
            else if(Wobj1.SchedularFlag__c == false && Robj2.AccountRecordType__c != 'None')
            {            
                 TerrListvalues += ' AND IsPartner__c = true';
                 if(Robj2.AccountRecordType__c == 'Asia Pacific')
                 {
                    TerrListvalues += ' AND (MyComp_Territory_Region__c = \'APJ\' OR MyComp_Territory_Region__c = \'Asia Pacific\')';
                 }
                 else if(Robj2.AccountRecordType__c == 'EMEA')
                 {
                    TerrListvalues += ' AND MyComp_Territory_Region__c = \'EMEA\'';
                 }
                 else if(Robj2.AccountRecordType__c == 'Americas')
                 {
                    TerrListvalues += ' AND (MyComp_Territory_Region__c = \'AMS\' OR MyComp_Territory_Region__c = \'Americas\')';
                 }
                Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(TerrListvalues,param),150);                   
                try
                {       
                    if(obj.SchedularFlag__c)
                    {
                        Robj2.AccountRecordType__c = 'None';
                        update Robj2;
                        obj1.AccountRecordType__c = 'Customer';
                        update obj1;
                        Terrchanges.Territory_Evaluation__c = false;
                        update Terrchanges;               
                        //specialtyFlag.SchedularFlag__c = false;
                        //update specialtyFlag;
                        if(objSR.AccountRecordType__c != '' )
                        {  
                            objSR.AccountRecordType__c = '';     
                            update objSR;
                        } 
                    }
                }                
                catch (Exception e)
                {
                    system.debug('****Exception in TM Account Record type change to Partner ****' + e.getMessage());
                }
                String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                String CRON_EXP = '0 '+min1+' * * * ?';
                TMEngineSchelduled sch = new TMEngineSchelduled();
                system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch);   
            }        
            if(Wobj1.SchedularFlag__c == true && Robj2.AccountRecordType__c == 'None')
            {
                obj1.AccountRecordType__c = 'Customer';
                update obj1;
            }           
        }    
        if(Wobj1.SchedularFlag__c == true)
        {        
            Terrchanges.Territory_Evaluation__c = true;
            update Terrchanges;         
            if(Robj2.AccountRecordType__c == 'None')
            {               
                Robj2.AccountRecordType__c = 'Asia Pacific';
                update Robj2;
            }
            else if(Robj2.AccountRecordType__c == 'Asia Pacific')
            {
                Robj2.AccountRecordType__c = 'EMEA';
                update Robj2;
            }
            else if(Robj2.AccountRecordType__c == 'EMEA')
            {
                Robj2.AccountRecordType__c = 'Americas';
                update Robj2;
            }
            else if(Robj2.AccountRecordType__c == 'Americas')
            {
                if(obj1.AccountRecordType__c == 'Customer')
                {                 
                    Robj2.AccountRecordType__c = 'Asia Pacific';
                    update Robj2;
                    obj1.AccountRecordType__c = 'Partner';
                    update obj1;
                }
                else
                {
                    obj1.AccountRecordType__c = 'Customer';
                    update obj1;
                    Robj2.AccountRecordType__c = 'None';
                    update Robj2;
                    Terrchanges.Territory_Evaluation__c = false; 
                    update Terrchanges;
                    Wobj1.SchedularFlag__c = false;
                    update Wobj1;
                    //specialtyFlag.SchedularFlag__c = false;
                    //update specialtyFlag;
                    obj.SchedularFlag__c = false;                                        
                    update obj;                     
                    Id batchEvalTerr = Database.executeBatch(new EvaluateTerrRealignBatch(TerrListvalues,param),150);         
                    Id batchOpptyOutsideTerr = Database.executeBatch(new OpptyOutsideTerrBatch(),150);
                    Integer myInt = integer.valueOf(Hour);
                                        
                    if(ShortDayOfweek != 'Sat' && ShortDayOfweek != 'Sun')
                    {
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch);
                    }      
                    else
                    {
                        if((ShortDayOfweek == 'Sat') || (ShortDayOfweek == 'Sun' && myInt <= 22))
                        {
                            String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                             String CRON_EXP = '0 '+min1+' 22 ? * 1';
                             TMEngineSchelduled sch = new TMEngineSchelduled();
                             system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch); 
                        }
                        else if(ShortDayOfweek == 'Sun' && myInt > 22)
                        {
                            String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                            String CRON_EXP = '0 '+min1+' * * * ?';
                            TMEngineSchelduled sch = new TMEngineSchelduled();
                            system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch); 
                        }
                    }
                }
            }
            if(obj1.AccountRecordType__c  == 'Customer')
            {
                if(Robj2.AccountRecordType__c == 'Asia Pacific') 
                {
                    if(ApjSuspend.Suspendflag__c == false)
                    {
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule Asia Pacific', CRON_EXP, sch);  
                    }
                    else
                    {
                        try
                        {
                            Robj2.AccountRecordType__c = 'EMEA';
                            update Robj2;
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                    }                     
                }
                if(Robj2.AccountRecordType__c == 'EMEA')
                {
                    if(EmeaSuspend.Suspendflag__c == false) 
                    {
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule EMEA', CRON_EXP, sch);                         
                    }
                    else
                    {
                        try
                        {
                            Robj2.AccountRecordType__c = 'Americas';
                            update Robj2;
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                    }
                }
                if( Robj2.AccountRecordType__c == 'Americas')
                {
                    if(AmsSuspend.Suspendflag__c == false)
                    { 
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));           
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule Americas', CRON_EXP, sch);                                  
                    }
                    else
                    {
                        try
                        {   
                            obj1.AccountRecordType__c  = 'Partner';
                            update obj1;                        
                            Robj2.AccountRecordType__c = 'Asia Pacific';
                            update Robj2;
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                    }
                }
            }
            if(obj1.AccountRecordType__c  == 'Partner')
            {
                if(Robj2.AccountRecordType__c == 'Asia Pacific') 
                {
                    if(ApjSuspendPartner.Suspendflag__c == false)
                    {
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule Asia Pacific', CRON_EXP, sch);  
                    }
                    else
                    {
                        try
                        {
                            Robj2.AccountRecordType__c = 'EMEA';
                            update Robj2;
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                    }                     
                }
                if(Robj2.AccountRecordType__c == 'EMEA')
                {
                    if(EmeaSuspendPartner.Suspendflag__c == false) 
                    {
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule EMEA', CRON_EXP, sch);                         
                    }
                    else
                    {
                        try
                        {
                            Robj2.AccountRecordType__c = 'Americas';
                            update Robj2;
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                    }
                }
                if( Robj2.AccountRecordType__c == 'Americas')
                {
                    if(AmsSuspendPartner.Suspendflag__c == false)
                    { 
                        String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));           
                        String CRON_EXP = '0 '+min1+' * * * ?';
                        TMEngineSchelduled sch = new TMEngineSchelduled();
                        system.schedule('TM Engine Hourly Schedule Americas', CRON_EXP, sch);                                  
                    }
                    else
                    {
                        try
                        {   
                            obj1.AccountRecordType__c  = 'Customer';
                            update obj1;                            
                        }
                        catch(Exception e)
                        {
                            system.debug('Exception Occurred');
                        }
                        Integer myInt = integer.valueOf(Hour);
                        if(ShortDayOfweek != 'Sat' && ShortDayOfweek != 'Sun')
                        {
                            String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                            String CRON_EXP = '0 '+min1+' * * * ?';
                            TMEngineSchelduled sch = new TMEngineSchelduled();
                            system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch);
                        }      
                        else
                        {
                            if((ShortDayOfweek == 'Sat') || (ShortDayOfweek == 'Sun' && myInt <= 22))
                            {
                                String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                                String CRON_EXP = '0 '+min1+' 22 ? * 1';
                                TMEngineSchelduled sch = new TMEngineSchelduled();
                                system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch); 
                            }
                            else if(ShortDayOfweek == 'Sun' && myInt > 22)
                            {
                                String min1 = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                                String CRON_EXP = '0 '+min1+' * * * ?';
                                TMEngineSchelduled sch = new TMEngineSchelduled();
                                system.schedule('TM Engine Hourly Schedule Starts', CRON_EXP, sch); 
                            }
                        }
                    }
                }
            } 
        }
        else if(Robj2.AccountRecordType__c != 'None' )
        {   
            Terrchanges.Territory_Evaluation__c = false;
            Update Terrchanges;   
            Robj2.AccountRecordType__c = 'None';     
            Update Robj2;           
            specialtyFlag.SchedularFlag__c = false;
            update specialtyFlag;
            if(objSR.AccountRecordType__c != '' )
            {  
                objSR.AccountRecordType__c = '';     
                Update objSR;
            }
        }  
    }
}