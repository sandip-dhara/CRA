/**
* Class Name: CaseTriggerController
* Author: Accenture
* Date: 30-APR-2012 
* Requirement # Request Id: 683
* Description: Contains support action methods for trigger on Case object
*/
global class CaseTriggerController{
    /**
    * @description: Country Of logged in User mapped to Country of Case Submitter
    */
    public static void beforeInsert() {
        CaseTriggerUtil.insertCaseFlag = true;
        CaseTriggerUtil.updateCountryOfSubmitter();
    }
    /**
    * @description: Trigger on Case before update
    */
    public static void beforeUpdate() {
        if (!CaseTriggerUtil.insertCaseFlag) {
            CaseTriggerUtil.validatePermissions();  
        }
    }
    
    /**
    * @description: Validation Rules on closure of a case
    */
    public static void beforeCOCaseClosure(List<Case> caseList) {
        /* Set<String> statusList = new Set<String>();
        for(Stop_status__c s : [Select Name From Stop_Status__c])
            statusList.add(s.Name);
        
        for(Case c : caseList){
            if(statusList.contains(c.Status))
                c.IsStopped = true;
            else
                c.IsStopped = false;
        
        }*/
                
        Map<Id, List<Case>> caseSubCaseMap = new Map<Id,List<Case>>();
        Map<Id, List<Case>> caseAssociatedMap = new Map<Id, List<Case>>();
        
        sObject[] CaseSubCase = [Select id, (Select id, Status From Cases), (Select Id, Status From Rework_Cases__r) From Case Where Id IN :caseList];
        
        Set<Id> caseIds = new Set<Id>();
        for(Integer i = 0; i<CaseSubCase.size(); i++){
            Id caseId = ((Case)CaseSubCase.get(i)).Id;
            caseIds.add(caseId);
            List<Case> subCaseList = new List<Case>();
            if((List<Case>)CaseSubCase.get(i).getSobjects('Cases') != null){
                subCaseList = (List<Case>)CaseSubCase.get(i).getSobjects('Cases');
                for(Case c: subCaseList)
                    caseIds.add(c.Id);
                    
                caseSubCaseMap.put(caseId,subCaseList);
            }
            
            if((List<Case>)CaseSubCase.get(i).getSobjects('Rework_Cases__r') != null){
                List<Case> subCaseList2 = (List<Case>)CaseSubCase.get(i).getSobjects('Rework_Cases__r');
                for(Case c: subCaseList2)
                    caseIds.add(c.Id);
                
                subCaseList.addAll(subCaseList2);
                
                caseSubCaseMap.put(caseId,subCaseList);
            }

        }
        
        Map<Id,List<Task>> caseTaskMap = new Map<Id,List<Task>>();
        
        sObject[] caseTaskList = [Select id, (Select id, Status From Tasks) From Case Where Id IN :caseIds];
        for(Integer i = 0; i<caseTaskList.size(); i++){
            Id caseId = ((Case)caseTaskList.get(i)).Id;
            if((List<Task>)caseTaskList.get(i).getSobjects('Tasks') != null){
                List<Task> taskList = (List<Task>)caseTaskList.get(i).getSobjects('Tasks');
                caseTaskMap.put(caseId,taskList);
            }
            else{
                //caseTaskMap.put(caseId,null);
            }
            
        }
        List<CaseMilestone> cm = [Select MilestoneTypeId, MilestoneType.Name, IsCompleted, TargetDate,CaseId From CaseMilestone where caseId in :caseList limit 50000];
        for(Case c : caseList){
            if(c.Status == 'Closed'){
                if(caseSubCaseMap.get(c.Id) != null){
                    for(Case sc : caseSubCaseMap.get(c.Id)){
                        if(sc.status != 'Closed'){
                            c.addError(Label.CO_Case_Validation_Error1);
                        }
                        
                        else{
                            if(caseTaskMap.get(sc.Id) != null){
                            for(Task t : caseTaskMap.get(sc.Id)){
                                if(t.Status != 'Closed' && t.Status != 'Completed' && t.Status != 'Cancelled')
                                    c.addError(Label.CO_Case_Validation_Error2);
                            }
                            }
                        
                        }
                    }
                }
                
                    if(caseTaskMap.get(c.Id) != null){
                        for(Task t : caseTaskMap.get(c.Id)){
                            if(t.Status != 'Completed' && t.Status != 'Closed' && t.Status != 'Cancelled'){
                                c.addError(Label.CO_Case_Validation_Error3);
                            }
                        }
                    }
                
                    for(CaseMilestone cmm : cm){
                        if(cmm.MilestoneType.Name != 'Resolution Time' && cmm.IsCompleted == False && cmm.CaseId == c.Id && c.Close_Case_Reason__c != 'Cancelled'&& c.Close_Case_Reason__c != 'Rejected')
                            c.addError(Label.CO_Case_Validation_Error4);
                       
                            
                    }
                    
                
            }
            
        }
    }
    
    /**
    * @description: Trigger on Case after update
    */
    public static void afterUpdate() {
        CaseTriggerUtil.insertEditSharing();    
    }
    
    //CO:Debmalya:R5:15/03/2013:Case Assignment logic:Start
    
    //Case Expertise level calculation from before Insert Trigger
    public static void caseExpertiseCalculation(List<Case> caseList){
        Map<String,Set<String>> reqSubcaseMap = new Map<String,Set<String>>();
        Map<Case,String> caseIdreqMap = new Map<Case,String>();
        Map<Case,String> caseIdExpertise = new Map<Case,String>();
        Set<String> subcaseSet = new Set<String>();
        
        for(Case caserec: caseList){
            if(caserec.Sub_Case_Type__c != null){
                List<String> subcaseList = caserec.Sub_Case_Type__c.split(';');
                Set<String> subcasegetSet = new Set<String>();
                subcasegetSet.addAll(subcaseList);
                reqSubcaseMap.put(caserec.Request_Type__c,subcasegetSet);
                caseIdreqMap.put(caserec,caserec.Request_Type__c);
                subcaseSet.addAll(subcaseList);
            }
        }
        
        if(subcaseSet != null && subcaseSet.size()>0){
            for(CaseExternalSystemMapper__c record :[Select LevelofExpertise__c,Request_Type__c,SystemValue__c from CaseExternalSystemMapper__c where Request_Type__c In: reqSubcaseMap.keySet() AND SystemValue__c In: subcaseSet AND Origin__c = 'Salesforce' AND Classification__c = 'Request Type - Subcase Type mapper']){
                if(reqSubcaseMap.get(record.Request_Type__c).contains(record.SystemValue__c)){
                    for(Case caserec : caseIdreqMap.keySet()){
                        if(caseIdreqMap.get(caserec) == record.Request_Type__c){
                            if(caseIdExpertise.get(caserec) == null){
                                caseIdExpertise.put(caserec,record.LevelofExpertise__c);
                            }else if(caseIdExpertise.get(caserec) != null &&  Integer.valueOf(caseIdExpertise.get(caserec)) < Integer.valueOf(record.LevelofExpertise__c)){
                                caseIdExpertise.put(caserec,record.LevelofExpertise__c);
                            }
                        }
                    }
                }
            }
        }
        
        for(Case caserec : caseIdExpertise.keySet()){
            caserec.Expertise_Level__c = String.valueOf(caseIdExpertise.get(caserec));
        }
    }
    
    //Cases to be Assigned through OAE
    public static void caseAssignmentthroughOAE(List<Id> caseListforOAE){
         system.debug('debcheckpoint4');
         for(Id caseRecId : caseListforOAE){
            OAE_ObjectAssign objAsgn = new OAE_ObjectAssign();
            Map<ID,scoreObj[]> soMap = objAsgn.objectAssign( new List<ID>{caseRecId}, 0 );
            System.debug( '>>> OAE RESPONSE: ' + soMap );
         }
     }

@future     
     public static void caseAssignmentthroughOAEfuture(Set<Id> caseIdforOAE){
        system.debug('debcheckpoint5');
        for(Id caserecId : caseIdforOAE){
            OAE_ObjectAssign objAsgn = new OAE_ObjectAssign();
            Map<ID,scoreObj[]> soMap = objAsgn.objectAssign( new List<ID>{caserecId}, 0 );
            System.debug( '>>> OAE RESPONSE: ' + soMap );   
        }
     }
     
     //Webservice to reassign multiple cases from the Search Layout.It accepts a semi-colon separated String of Case Ids 
     //as its parameter. It returns a String with the number of records updated. 
     Webservice static String caseAssignmentthroughOAEforList(String caseIds){
     //Hold sets of 5 Case Ids to be sent to OAE for evaluation and assignment
        Map<Integer,Set<Id>> caseIdSet = new Map<Integer,Set<Id>>();
        List<String> caseList = caseIds.split(';');
        List<Id> caseIdList = new List<Id>();

        Integer setCounter = 1;
        for(Integer i = 1; i <= caseList.size();i++){
            if(math.mod(i,5)!= 0){
                Set<Id> cSet = caseIdSet.get(setCounter);
                if(cSet == null){
                    cSet = new Set<Id>();
                }
                cSet.add(Id.valueOf(caseList[i-1]));
                caseIdSet.put(setCounter,cSet);
            }else{
                Set<Id> cSet = caseIdSet.get(setCounter);
                cSet.add(Id.valueOf(caseList[i-1]));
                caseIdSet.put(setCounter,cSet);
                setCounter = setCounter + 1;
            }
        }

        for(Integer i: caseIdSet.keySet()){
            caseAssignmentthroughOAEfuture(caseIdSet.get(i));
        }

        String return_msg = String.valueOf(caseList.size()) + ' cases have been submitted for reassignment';
        return return_msg;
     }
     
     //Cases to be assigned to Owner of Parent Case in case it is Reworked
     public static void caseAssignmentforReworked(List<Case> reworkedCaseList){
         
         Set<Id> parentCaseId = new Set<Id>();
         Map<Id,Id> parentIdcaseId = new Map<Id,Id>();
         Map<Id,Id> ownerIdCaseId = new Map<Id,Id>();
         Map<Id,Case> caseownerupdateMap;
         List<Case> caseownerupdatelist = new List<Case>();
         List<Id> caseListforOAE = new List<Id>();
         
         for(Case caseRec : reworkedCaseList){
             if(caseRec.Rework_to__c != null || caseRec.Rework_to__c != ''){
                 parentCaseId.add(caseRec.Rework_to__c);
                 parentIdcaseId.put(caseRec.Rework_to__c,caseRec.Id);
             }
         }
         
         for(Case parentcaserecs : [Select Id,OwnerId from Case where Id In: parentIdcaseId.keySet()]){
             ownerIdCaseId.put(parentcaserecs.OwnerId,parentIdcaseId.get(parentcaserecs.Id));
         }
         
         for(UserData__c useravaibalerecs : [Select User__c, Available__c from UserData__c where User__c In: ownerIdCaseId.keySet()]){
             if(!useravaibalerecs.Available__c){
                caseListforOAE.add(ownerIdCaseId.get(useravaibalerecs.User__c));
                ownerIdCaseId.remove(useravaibalerecs.User__c);
             }
         }
         
         caseownerupdateMap = new Map<Id,Case>([Select Id, OwnerId from Case where Id In : ownerIdCaseId.values()]);
         for(Id userids : ownerIdCaseId.keySet()){
             Case caserectoUpdate = caseownerupdateMap.get(ownerIdCaseId.get(userids));
             caserectoUpdate.OwnerId = userids;
             caseownerupdatelist.add(caserectoUpdate);
         }
         
         if(caseownerupdatelist != null){
             update caseownerupdatelist;
         }
         
         if(caseListforOAE != null){
             caseAssignmentthroughOAE(caseListforOAE);
         }
            
     }
     //CO:Debmalya:R5:15/03/2013:Case Assignment logic:End
     //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:Start
     public static void caseWeightAdmSupcases(List<Case> caseList,Map<String,String> reasonScenarioMapper){
        for(Case admSupCase : caseList){
            if(reasonScenarioMapper.keySet().contains(admSupCase.Reason + admSupCase.Scenario__c)){
                admSupCase.Weight_for_Acct_Req_Admin_Sup__c = reasonScenarioMapper.get(admSupCase.Reason + admSupCase.Scenario__c);
            }
        }
     }
     
     public static void caseEntSLAforADMSup(List<Case> caseList,Map<String,String> reqScenarioEntitlIdMap,Map<String,Decimal> reqScenarioSLAMap){
        for(Case admSupCase : caseList){
            if(reqScenarioEntitlIdMap.keySet().contains(admSupCase.Reason + admSupCase.Scenario__c)){
                admSupCase.EntitlementId = reqScenarioEntitlIdMap.get(admSupCase.Reason + admSupCase.Scenario__c);
            }
            if(reqScenarioSLAMap.keySet().contains(admSupCase.Reason + admSupCase.Scenario__c)){
                admSupCase.AdminCaseSLA__c = reqScenarioSLAMap.get(admSupCase.Reason + admSupCase.Scenario__c);
            }
        }
     }
     //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:End
     //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:Start
     public static void caseAssignToTeam(List<Case> caseList){
         string qrys;
         Map<Case,String> caseQueueId = new Map<Case,String>();
         //CO:Debmalya:R6:22/08/13:Code Optimization for OAE Exceptions : Start
         /*for(Case lc : caseList){
            string ctry =  '%' + lc.country__c + '%';
            string rqt =  '%' + lc.request_type__c + '%';
            string pgt =  lc.program_type__c;
            string rtm =  lc.route_to_market__c;
            if (pgt == null)
                {pgt = '';}
            else{pgt = pgt.replace(';','\',\'');}
            qrys = 'select Assign_To_Team__c, classification__c from CaseExternalSystemMapper__c where (Origin__c = \'' + lc.origin + '\' ) and ' +
                   ' (BG__c = \'' + lc.BG__C + '\' ) and Classification__c = \'OAE_Exceptions\' and program_type__c in (\'' + pgt +'\' ) and ' +
                   'request_type__c like \'' + rqt + '\' and country__c like \'' + ctry + '\' order by seq__c limit 1 ';
            system.debug('qrys:' +qrys);
            
            list <CaseExternalSystemMapper__c> csm = database.query(qrys);
            if (csm.size() > 0){
                lc.Assign_to_Team__c = csm[0].Assign_To_Team__c;
            }
            //CO:Debmalya:R6:25/07/13:Assign to Team Calculation for OAE Exception 2&3:Start
            else{  
                qrys = 'select Assign_To_Team__c, classification__c from CaseExternalSystemMapper__c where (Origin__c = \'' + lc.origin + '\' ) and ' +
                        'Classification__c = \'OAE_Exceptions2\' and route_to_market__c = \'' + rtm + '\'  and ' +
                        'request_type__c like \'' + rqt + '\' and country__c like \'' + ctry + '\' order by seq__c limit 1 ';
                system.debug('qrys:' +qrys);
               
                list <CaseExternalSystemMapper__c> csm1 = database.query(qrys);
                if (csm1.size() > 0){ lc.Assign_to_Team__c = csm1[0].Assign_To_Team__c;}
                else{
                    qrys = 'select queue__c, classification__c from CaseExternalSystemMapper__c where (Origin__c = \'' + lc.origin + '\' ) and ' +
                            'Classification__c = \'OAE_Exceptions3\' and ' +
                            'request_type__c like \'' + rqt + '\' and country__c like \'' + ctry + '\' order by seq__c limit 1 ';
                    system.debug('qrys:' +qrys);
                   
                    list <CaseExternalSystemMapper__c> csm2 = database.query(qrys);
                    if (csm2.size() > 0){
                        caseQueueId.put(lc,csm2[0].queue__c);
                        //lc.Assign_to_Team__c = csm2[0].Assign_To_Team__c;
                    }
                }
            }
            //CO:Debmalya:R6:25/07/13:Assign to Team Calculation for OAE Exception 2&3:End
         }*/
         Set<String> pgt = new Set<String>();
         Set<String> rtm = new Set<String>();
         Set<String> bgSet = new Set<String>();
         Set<String> originSet = new Set<String>();
         string ctry = '(';
         string rqt = '(';
         Set<String> classificationSet = new Set<String>();
         classificationSet.add('OAE_Exceptions');
         classificationSet.add('OAE_Exceptions2');
         classificationSet.add('OAE_Exceptions3');
         for(Case lc : caseList){
            system.debug('******lc.country__c******'+lc.country__c); 
            ctry = ctry + ' country__c like ' + '\'%' + String.escapeSingleQuotes(lc.country__c) + '%\'' + ' OR';
            rqt = rqt + ' request_type__c like' + '\'%' + String.escapeSingleQuotes(lc.request_type__c) + '%\'' + ' OR';
            if(lc.program_type__c != null){
                pgt.addAll(lc.program_type__c.split(';'));
            }
            rtm.add(lc.route_to_market__c);
            bgSet.add(lc.BG__C);
            originSet.add(lc.origin);
         }
         system.debug('******ctry********'+ctry);
         ctry = ctry.substring(0, ctry.length()-2);
         ctry = ctry + ')';
         rqt = rqt.substring(0, rqt.length()-2);
         rqt = rqt + ')';
         //Query String Contains Order By caluse on Case Calassification to ensure priority of OAE_Exceptions over OAE_Exceptions2 over OAE_Exceptions3
         qrys = 'select Assign_To_Team__c, Origin__c, BG__c, queue__c, program_type__c, route_to_market__c, classification__c,country__c,' + 
                'request_type__c from CaseExternalSystemMapper__c where Origin__c In :originSet and Classification__c In:classificationSet and ' +
                'BG__c In: bgSet and ' + rqt + ' and ' + ctry + ' AND (program_type__c = null OR program_type__c in :pgt OR route_to_market__c = null OR ' + 
                'route_to_market__c In :rtm) order by Classification__c,seq__c';
         
         for(CaseExternalSystemMapper__c staticRecs : database.query(qrys)){
            for(Case lc : caseList){
                if(staticRecs.Classification__c.equalsIgnoreCase('OAE_Exceptions')){
                    if(staticRecs.Origin__c.equalsIgnoreCase(lc.origin) && staticRecs.BG__c.equalsIgnoreCase(lc.BG__C) && 
                       staticRecs.request_type__c.containsIgnoreCase(lc.request_type__c) && staticRecs.country__c.containsIgnoreCase(lc.country__c)){
                        if(lc.program_type__c != null && staticRecs.program_type__c != null){
                        	if(lc.program_type__c.containsIgnoreCase(staticRecs.program_type__c)){
								if(lc.Assign_to_Team__c.equalsIgnoreCase('Standard Assignment') || lc.Assign_to_Team__c == null){
									lc.Assign_to_Team__c = staticRecs.Assign_To_Team__c;
								}
                        	}
						}else if(staticRecs.program_type__c == null && lc.program_type__c == null){
							if(lc.Assign_to_Team__c.equalsIgnoreCase('Standard Assignment') || lc.Assign_to_Team__c == null){
								lc.Assign_to_Team__c = staticRecs.Assign_To_Team__c;
							}
						}
                    }
                }else if(staticRecs.Classification__c.equalsIgnoreCase('OAE_Exceptions2')){
                    if(staticRecs.Origin__c.equalsIgnoreCase(lc.origin) && staticRecs.BG__c.equalsIgnoreCase(lc.BG__C) && lc.route_to_market__c.equalsIgnoreCase(staticRecs.route_to_market__c) && staticRecs.request_type__c.containsIgnoreCase(lc.request_type__c) && staticRecs.country__c.containsIgnoreCase(lc.country__c)){
                        if(lc.Assign_to_Team__c.equalsIgnoreCase('Standard Assignment') || lc.Assign_to_Team__c == null){
                            lc.Assign_to_Team__c = staticRecs.Assign_To_Team__c;
                        }
                    }
                }else If(staticRecs.Classification__c.equalsIgnoreCase('OAE_Exceptions3')){
                    if(staticRecs.Origin__c.equalsIgnoreCase(lc.origin) && staticRecs.BG__c.equalsIgnoreCase(lc.BG__C) && staticRecs.request_type__c.containsIgnoreCase(lc.request_type__c) && staticRecs.country__c.containsIgnoreCase(lc.country__c)){
                        if(lc.Assign_to_Team__c.equalsIgnoreCase('Standard Assignment') || lc.Assign_to_Team__c == null){
                            if(caseQueueId.get(lc) == null){
                                caseQueueId.put(lc,staticRecs.queue__c);
                            }
                        }
                    }
                }
            }
         }
         //CO:Debmalya:R6:22/08/13:Code Optimization for OAE Exceptions : End
         for(Group gqueues:[Select Id,Name from Group where Name In: caseQueueId.values()]){
             for(Case crec : caseQueueId.keySet()){
                 if(caseQueueId.get(crec) == gqueues.Name){
                     crec.OwnerId = gqueues.Id;
                     crec.Case_Origin_is_Interface__c = true;
                 }
             }
         }
     }
     //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:End
}