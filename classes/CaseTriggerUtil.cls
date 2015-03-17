/**
 * Class Name: CaseTriggerUtil
 * Author: Accenture
 * Date: 30-APR-2012
 * Requirement # Request Id: 683
 * Description: Contains support action methods for trigger on Competitors__c object
 */
public class CaseTriggerUtil {

    /**
     * @description: map country of logged in user to country of case submitter
     *
     */
    public static boolean insertCaseFlag = false;

    public static void updateCountryOfSubmitter() {
        map < ID, String > mapCountryByUser = new map < Id, String > ();
        List < Case > cases = (List < Case > ) Trigger.new;
        set < Id > users = new set < Id > ();
        for (Case caseObj: cases) {
            users.add(caseObj.OwnerId);
        }
        if (users.size() > 0) {
            for (User currentUser: [select Id, Country From User WHERE Id IN: users]) {
                if (currentUser.Country != null && currentUser.Country != '') {
                    mapCountryByUser.put(currentUser.Id, currentUser.Country);
                }
            }
        }
        for (Case caseObj: cases) {
            system.debug('=> case country = ' + caseObj.Country_of_Submitter__c);
            if (caseObj.Origin != 'Email' && caseObj.Reason != 'Create New Account' && caseObj.Country_of_Submitter__c==null) {
                caseObj.Country_of_Submitter__c = mapCountryByUser.get(caseObj.OwnerId);
            }
        }
    }
    /**
     * @description: To get 15 digit Id
     */
    private static String convertTo15Digit(String paramID) {
        try {
            if (paramID.length() > 15) {
                paramID = paramID.substring(0, 15);
            }
        } catch (Exception eX) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'String', 'CaseTriggerUtil', 'Class');
        }
        return paramID;
    }

    /**
     * @description: Method to validate permissions on Case object
     */
    public static void validatePermissions() {
        /* Bypass Admin Profiles mentioned in Custom Settings to allow him to make changes to account */
        Map < String, Admin_Profiles__c > adminProfilesMap = Admin_Profiles__c.getAll();
        Set < String > setAdminProfiles = new Set < String > ();
        String currentProfileId = Userinfo.getProfileId();
        currentProfileId = convertTo15Digit(currentProfileId);

        /* To check whether any profile have permission to change owner of the account */
        for (Admin_Profiles__c prof: adminProfilesMap.values()) {
            if (prof.Module__c != null) {
                if (prof.Module__c.equalsIgnoreCase('ModifyCase')) {
                    System.debug('###############');
                    if (prof.Profile_ID__c != null) {
                        setAdminProfiles.add(convertTo15Digit(prof.Profile_ID__c));
                    }
                }
            }
        }
        if (setAdminProfiles.contains(currentProfileId)) {

            return;
        }
        /* For all other users-They should not be able to make any chnages to Case */
        List < Case > cases = (List < Case > ) Trigger.new;
        for (Case caseObj: cases) {
            Map < String, Schema.SObjectField > caseFieldMap = Schema.SObjectType.Case.fields.getMap();
            for (String caseFieldName: caseFieldMap.keySet()) {
                // Check if any field value on Case is getting modified by user.If yes- then throw an error message.
                if (caseObj.get(caseFieldName) != Trigger.oldMap.get(caseObj.Id).get(caseFieldName)) {
                    caseObj.addError(System.Label.NO_ACCESS_TO_MODIFY_CASE);
                }
            }
        }
    }

    /**
     * @description: Method to insert edit sharing on Case object
     */
    public static void insertEditSharing() {
        List < Case > cases = (List < Case > ) Trigger.new;
        List < CaseShare > caseShares = new List < CaseShare > ();
        for (Case caseObj: cases) {
            CaseShare rule = new CaseShare();
            rule.CaseId = caseObj.Id;
            rule.UserOrGroupId = caseObj.CreatedById;
            rule.CaseAccessLevel = 'Edit';
            caseShares.add(rule);
        }
        try {
            insert caseShares;
        } catch (Exception ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'CaseShare', 'CaseTriggerUtil', 'Class');
        }
    }
    /**
     * CO R6.0 Customer Operation Req# 7016 Start @@@@ Owner Balakrishna
     * "Analze case" and "Analyze to production team" Milestones should be closed automatically in parent case if subcase created and milestones not yet closed in parent case
     */
    public static void ParentCaseMilestonesUpdate(Set < Id > ParentCaseIds) {
        List < CaseMilestone > ParentCaseUpdate = new List < CaseMilestone > ();
        List < CaseMilestone > cms = [select MilestoneTypeId, MilestoneType.Name, TargetDate, CaseId, CompletionDate From CaseMilestone where caseId in : ParentCaseIds];
        for (CaseMilestone cms2: cms) {
            if (cms2.CompletionDate == null && (cms2.MilestoneType.Name == 'Analyze Case' || cms2.MilestoneType.Name == 'Assign to production team')) {
                cms2.CompletionDate = System.Now();
                system.debug('Analyze case completiondate' + cms2.CompletionDate);
                ParentCaseUpdate.add(cms2);
            }

        }
        if (ParentCaseUpdate.size() > 0) {
            update ParentCaseUpdate;
        }
    }
    /* CO R6.0 Req#7016 Parentcase logic End */

    /* CO R6.0 Requirement Milestones update */
    public static void CaseMileStonesUpdate(List < Case > CaseData) {
        List < Support_Request__c > srsupdate = new List < Support_Request__c > ();
        List < CaseMilestone > cmUpdate = new List < CaseMilestone > ();
        //Boolean b = false;
        List < CaseMilestone > cm = [Select MilestoneTypeId, MilestoneType.Name, IsCompleted, CompletionDate, TargetDate, CaseId From CaseMilestone where caseId in : CaseData limit 50000];
        CaseTriggerController.beforeUpdate();
        /**********R5.0 Customer Operations Owner Deepak Saxena Open*************/
        List < Case > caseList = new List < Case > ();
        Set < Id > clist = new Set < Id > ();
        for (Case cid: CaseData) {
            If(cid.Support_Request_ID__c != null) {
                clist.add(cid.Support_Request_ID__c);
            }
        }

        Map < id, Support_Request__c > SupportList = New Map < id, Support_Request__c > ([Select Name from Support_Request__c where Id IN: clist]);

        for (Case c: CaseData) {
            if (Label.CO_Case_Record_Types.contains(c.Record_Name__c) && c.Status == 'Closed') {
                caseList.add(c);
                System.debug('???????');
            }
           
           for (caseMilestone cms: cm) {
              
                if (cms.MilestoneType.Name == 'Resolution Time' && c.Status != 'Closed')
                    c.Due_Date__c = cms.TargetDate;
                   
            }
            
            /** deepika code **/
            
            if (c.Record_Name__c == 'CO Case') {
                if (c.Close_Case_Reason__c == 'Completed' || c.Close_Case_Reason__c == 'Closed on first call' || c.Close_Case_Reason__c == 'Invalid Rework Request') {
                    if (c.Support_Request_ID__c != null) {
                        If(SupportList.get(c.Support_Request_ID__c) != null) {
                            Support_Request__c srs = SupportList.get(c.Support_Request_ID__c);
                            srs.Status__c = 'Completed';
                            srsupdate.add(srs);
                        }
                    }
                } else if (c.Close_Case_Reason__c == 'Cancelled' || c.Close_Case_Reason__c == 'Rejected') {
                    if (c.Support_Request_ID__c != null) {
                        If(SupportList.get(c.Support_Request_ID__c) != null) {
                            Support_Request__c srs = SupportList.get(c.Support_Request_ID__c);
                            srs.Status__c = 'Rejected';
                            srsupdate.add(srs);
                        }
                    }
                }
            } 

            /** deepika code end **/
            /**
             * R6.0 Customer Operations Req#7649 start  Owner @@@@ Balakrishna
             * Case MileStones closed automatically when trying to close the case with Cancelled or Rejected Reason
             */
            if ((c.Status == 'Closed' && c.Close_Case_Reason__c == 'Rejected') || (c.Status == 'Closed' && c.Close_Case_Reason__c == 'Cancelled')) {
                for (caseMilestone cms2: cm) {
                    if (cms2.CompletionDate == null) {
                        cms2.CompletionDate = System.Now();

                        cmUpdate.add(cms2);
                    }
                }

            } /*** End of Req#7649 **/
            /********R6.0 Customer Operations Req#7016 start @@@@ owner Balakrishna ******/
            else {
                for (caseMilestone cms3: cm) {
                    if ((c.status == 'Closed' && cms3.CompletionDate == null && c.parentId != null && cms3.MilestoneType.Name == 'Analyze Case') || (cms3.MilestoneType.Name == 'Resolution Time' && cms3.CompletionDate == null && c.Status == 'Closed')) {
                        cms3.CompletionDate = System.Now();

                        cmUpdate.add(cms3);
                    }
                }

            } /** End of Req#7016 **/


            if (srsupdate.size() > 0) {
                update srsupdate;
            }
            if (cmUpdate.size() > 0) {
                update cmUpdate;
            }

            if (caseList.size() > 0)
                CaseTriggerController.beforeCOCaseClosure(caseList);

        }
    }
    /** Assocaited Case Req# 7016 logic start*/
    public static void AssociateMilestonesUpdate(Set < Id > AssociateIds) {
        List < CaseMilestone > AssociateCaseUpdate = new List < CaseMilestone > ();
        List < CaseMilestone > cms = [select MilestoneTypeId, MilestoneType.Name, TargetDate, CaseId, CompletionDate From CaseMilestone where caseId in : AssociateIds];
        for (CaseMilestone cms4: cms) {
            if (cms4.CompletionDate == null && cms4.MilestoneType.Name == 'Quality Check') {
                cms4.CompletionDate = System.Now();
                system.debug('Associate case Update' + cms4.CompletionDate);
                system.debug('AssociatecaseUpadate' + cms4.MilestoneType.Name);
                AssociateCaseUpdate.add(cms4);
            }

        }
        if (AssociateCaseUpdate.size() > 0) {
            update AssociateCaseUpdate;
        }
    }
    /** Assocaited Case logic End*/
    /* CO R6.0 WorldRegion is field is Updating based on country selected on case Start */
   public static void CaseWorldRegionUpdate(List < Case > CaseData) {
        List < Id > CaseWorldRegionUpdate = new List < Id > ();
        List < String > CountryNames = new List < String > ();

        for (Case c: caseData) {
            if (c.Country__c != null)
                CountryNames.add(c.country__c);
        }
      
        Map<String,World_Region__c> World_Region_Map = New Map<String,World_Region__c> ();
        for(World_Region__c w: [select id, Country_Name__c from World_Region__c])
        {
            World_Region_Map.put(w.Country_Name__c, w);
        }
        Map<String,string> World_Region_country_Map = New Map<String,string> ();
        for(World_Region_Country__c w: [select  Case_country__c,External_System_Country__c from World_Region_Country__c where Case_country__c in : CountryNames])
        {
            World_Region_country_Map.put(w.Case_country__c, w.External_System_Country__c);        
        }
        
        
        
        for (Case c: caseData) {
            if(World_Region_Map.get(c.country__c) != null)
            {
            c.WorldRegion__c = World_Region_Map.get(c.country__c).id;
            }
            else if(World_Region_country_Map.get(c.country__c) != Null)
            {
            if(World_Region_Map.get(World_Region_country_Map.get(c.country__c)) != Null)
                c.WorldRegion__c = World_Region_Map.get(World_Region_country_Map.get(c.country__c)).id;
            }
            
           
        }

    }

    /* CO R6.0 WorldRegion is field is Updating based on country selected on case End */

    /*CO R6.0 EF EntitlementUpdate */
    public static void SetCaseEntitlements(List < Case > CaseData) {
        Map < String, Entitlement_Process__c > EntitlementMap = Entitlement_Process__c.getAll();
        List < Entitlement_Process__c > ep = EntitlementMap.values();
        // Getting Entitlement ID from Custom Setting and Setting it on New Case. 
        //R 5.0 Customer Ops : Owner Vinay  
        for (Case ce: CaseData) {
            if (ce.Record_Name__c == 'CO Case') {
                for (Entitlement_Process__c e: ep) {
                    if (ce.BG__c != null && ce.Region__c != null && ce.Request_Type__c != null && ce.Program_Type__c != null) {
                        system.debug('CaseProgramType' + ce.Program_Type__c + e.Non_Stop__c + e.Request_Type__c);
                        If(e.Request_Type__c.contains(ce.Request_Type__c) && e.Case_BG__c.contains(ce.BG__C) && e.Non_Stop__c == (ce.Program_Type__c == 'Non-Stop') && e.Express__c == (ce.Program_Type__c == 'Express') && e.PWB__c == (ce.Program_Type__c == 'PWB')) {
                            system.debug('CustomSettingEntitlementId' + e.EntitlementId__c + e.Non_Stop__c);
                            ce.EntitlementId = e.EntitlementId__c;
                            break;
                        }
                    }
                    if (ce.BG__c != null && ce.Region__c != null && ce.Request_Type__c != null && ce.Program_Type__c != null) {
                        system.debug('CaseProgramType' + ce.Program_Type__c + e.Non_Stop__c + e.Request_Type__c + e.EntitlementId__c);
                        If(ce.Request_Type__c == 'Renewal Amendment' && (ce.BG__c == 'TS' || ce.BG__c == 'PPS') && (ce.Program_Type__c == 'CAP' || ce.Program_Type__c == NULL) && ((ce.Region__c == 'APJ' && ce.Country__c == 'Japan') || (ce.Region__c == 'AMS' && ce.Country__c == 'United States' && ce.Business_Type__c == 'Standard'))) {
                            system.debug('CustomSettingEntitlementId' + e.EntitlementId__c + e.Non_Stop__c);
                            ce.EntitlementId = Label.CORenewalAmendmentJapanEntitlemement;
                            break;
                        }
                    }
                    Else If(ce.Program_Type__c == null) {
                        If(ce.Request_Type__c == 'Renewal Amendment' && (ce.BG__c == 'TS' || ce.BG__c == 'PPS') && (ce.Program_Type__c == 'CAP' || ce.Program_Type__c == NULL) && ((ce.Region__c == 'APJ' && ce.Country__c == 'Japan') || (ce.Region__c == 'AMS' && ce.Country__c == 'United States' && ce.Business_Type__c == 'Standard'))) {
                            system.debug('CustomSettingEntitlementId' + e.EntitlementId__c + e.Non_Stop__c);
                            ce.EntitlementId = Label.CORenewalAmendmentJapanEntitlemement;
                            break;
                        }

                        If(ce.BG__c != null && ce.Region__c != null && ce.Request_Type__c != null && ce.Program_Type__c == null) {
                            system.debug('CaseProgramType' + ce.Program_Type__c + e.Non_Stop__c + e.Request_Type__c + e.EntitlementId__c);
                            If(e.Request_Type__c.contains(ce.Request_Type__c) && e.Case_BG__c.contains(ce.BG__C) && e.Non_Stop__c == (ce.Program_Type__c == 'Non-Stop') && e.Express__c == (ce.Program_Type__c == 'Express') && e.PWB__c == (ce.Program_Type__c == 'PWB')) {
                                system.debug('CustomSettingEntitlementId' + e.EntitlementId__c + e.Non_Stop__c);
                                ce.EntitlementId = e.EntitlementId__c;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    /*CO R6.0 EF EntitlementUpdate end */


}