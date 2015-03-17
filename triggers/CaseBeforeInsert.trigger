/**
* Class Name: CaseBeforeInsert 
* Author: Accenture
* Date: 27-APR-2012 
* Requirement # Request Id: 
* Description: Trigger to update country of submitter
*/
trigger CaseBeforeInsert on Case (before insert){
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
     System.debug('???????'+trigger.new[0].Opportunity__c);
      System.debug('???????'+trigger.new[0].OwnerId);
      System.debug('???????'+trigger.new[0].AccountId);
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    Map<String, Entitlement_Process__c> EntitlementMap = Entitlement_Process__c.getAll();
    List<Entitlement_Process__c> ep = EntitlementMap.values();
    //CO:Debmalya:15/04/2013:Expertise Calculation
    List<Case> coCaseListforExpertise = new List<Case>();
    List<String> CountryNames = new List<String>();
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:Start
    List<Case> admSupCaseList = new List<Case>();
    Set<String> caseReason = new Set<String>();
    Set<String> caseScenario = new Set<String>();
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:End
    List<BusinessHours> businesshourList = new List<BusinessHours>();
    businesshourList = [Select id, Name From BusinessHours where isActive=true];
    //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation
    List<Case> coCaseListforAssignToTeam = new List<Case>();
    
    //List<CaseExternalSystemMapper__c> caseMapper = [Select id, SLA__c, Classification__c, Entitlement_Id__c, CaseReasonScenarioKey__c from CaseExternalSystemMapper__c Where Classification__c = 'Case Reason - Scenario Mapper' Limit 50000];
    
    for(Case ce : trigger.new){
        ce.Status = 'New';
        if(ce.Record_Name__c == 'CO Case' && ce.ParentId != null){
            ce.Opportunity__c = null;
            ce.Support_Request_ID__c = null;
        }
         /* CO R6.0 WorldRegion is field is Updating based on country selected on case */
        if( ce.Country__c!=null)
        {
         CaseTriggerUtil.CaseWorldRegionUpdate(Trigger.new);
        }
         /* CO R6.0 WorldRegion is field is Updating based on country selected on case End */
        /* Bala: CO R6 EF Entitlement update or insert */ 
        if(ce.Request_Type__c !=null)
        {
         CaseTriggerUtil.SetCaseEntitlements(Trigger.new);
        } 
        /* CO R6 EF Entitlement update or insert End */ 
        //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:Start
        if((ce.Record_Name__c == 'CO Case' || ce.Record_Name__c == 'TS Contact Center') && ce.ParentId == null && !ce.Case_Origin_is_Interface__c){
            coCaseListforAssignToTeam.add(ce);
        }
        //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:End
    //CO:Debmalya:15/04/2013:Expertise Calculation
        if(ce.Record_Name__c == 'CO Case' && ce.ParentId != null && (ce.BG__c == 'TS' || ce.BG__c == 'PPS' || ce.BG__c == 'IPG' || ce.BG__c == 'PSG')){
            coCaseListforExpertise.add(ce);
        }
          /**R6.0 Customer Operations Req#7016 Owner Balakrishna Teella 
          * Update the Missed Turnaround Time field based on Due Date and Revised Due Date fields while creation of new SubCase from ParentCase
          */
      if(ce.Record_Name__c == 'CO Case' && ce.ParentId != null && ce.Due_Date__c > System.Now()&& ce.Revised_Due_Date__c > System.Now() && ce.Missed_Turnaround_Time__c == True )
      {
       ce.Missed_Turnaround_Time__c = false;
      }
        /**********R6.0 Customer Operations Req#7016 Owner Balakrishna Teella End*************/  
        //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:Start
        if(ce.Record_Name__c == 'Admin Support' || ce.Record_Name__c == 'Account Request'){
                caseReason.add(ce.Reason);
                caseScenario.add(ce.Scenario__c);
                admSupCaseList.add(ce);
        }
        //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:End
        /*********** CO R5.0 Owner Deepak Saxena *******************/
        /********** R5.0 EF Owner: Deepak Saxena ***************/
        String bName2 = ce.Country_of_Submitter__c + '-' + UserInfo.getTimezone().getId();
        if(ce.Record_Name__c == 'Admin Support' || ce.Record_Name__c == 'Account Request'){                
                System.debug('?????1'+bName2);
                for(BusinessHours b: businesshourList){
                if(b.Name == bName2){
                    system.debug('?????2');
                    ce.BusinessHoursId = b.Id;
                    break;
                }
                else if(ce.Country_of_Submitter__c != null && b.Name.contains(ce.Country_of_Submitter__c)){
                    ce.BusinessHoursId = b.Id;
                }
                }
        }
        /********** R5.0 EF Owner: Deepak Saxena ***************/
                
        if(ce.Requestor_s_TimeZone__c != null){
            List<String> sc = ce.Requestor_s_TimeZone__c.split('\\(');
            List<String> scc = sc[2].split('\\)');
            String bName = ce.Country__c + '-' + scc[0];
            if(ce.Record_Name__c == 'CO Case'){
                for(BusinessHours b: businesshourList){
                    
                        if(b.Name == bName){
                            ce.BusinessHoursId = b.Id;
                            break;
                        }
                        else if(b.Name.contains(ce.Country__c)){
                            ce.BusinessHoursId = b.Id;
                        }  
                }
            }

        }

        /*********** CO R5.0 Owner Deepak Saxena *******************/ 
        

    }
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:Start
    Map<String,String> reqScenarioValsMap = new Map<String,String>();
    Map<String,String> reqScenarioEntitlIdMap = new Map<String,String>();
    Map<String,Decimal> reqScenarioSLAMap = new Map<String,Decimal>();
    for(CaseExternalSystemMapper__c caseMapperkeyset : [Select SLA__c,LevelofExpertise__c,Request_Type__c,SystemValue__c,Entitlement_Id__c from CaseExternalSystemMapper__c Where Classification__c = 'Case Reason - Scenario Mapper'and Request_Type__c In: caseReason and SystemValue__c In: caseScenario and Origin__c = 'Salesforce']){
        reqScenarioValsMap.put(caseMapperkeyset.Request_Type__c + caseMapperkeyset.SystemValue__c,caseMapperkeyset.LevelofExpertise__c);
        reqScenarioEntitlIdMap.put(caseMapperkeyset.Request_Type__c + caseMapperkeyset.SystemValue__c,caseMapperkeyset.Entitlement_Id__c);
        reqScenarioSLAMap.put(caseMapperkeyset.Request_Type__c + caseMapperkeyset.SystemValue__c,caseMapperkeyset.SLA__c);
    }
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:End   
    CaseTriggerController.beforeInsert();
    if(coCaseListforExpertise != null){
        CaseTriggerController.caseExpertiseCalculation(coCaseListforExpertise);
    }
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:Start
    if(reqScenarioValsMap != null && admSupCaseList != null){
        CaseTriggerController.caseWeightAdmSupcases(admSupCaseList,reqScenarioValsMap);
    }
    if(admSupCaseList != null){
        CaseTriggerController.caseEntSLAforADMSup(admSupCaseList,reqScenarioEntitlIdMap,reqScenarioSLAMap);
    }
    //CO:Debmalya:R5EF:12/06/13:Calculate Weight for Admin and Support cases:End
    //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:Start
    if(coCaseListforAssignToTeam != null && coCaseListforAssignToTeam.size() > 0){
        CaseTriggerController.caseAssignToTeam(coCaseListforAssignToTeam);
    }
    //CO:Debmalya:R5EF02:10/07/13:Assign to Team Calculation:End
}