public class OAE_ObjectAssign {
    private class sortRules {
        Set<String> ubz_rq;
        Set<String> tb_rq;
        Map<String,Decimal> ubz_sc;
        Map<String,Decimal> tb_sc;
        Boolean osn_rq;
        Integer osnTR_sc;
        Integer osnFA_sc;
        Integer mos_rq;
        Integer mos_sc;
        Boolean hasTBRule;
        Decimal wk_sc;
        
        public sortRules() {
            ubz_rq = new Set<String>();
            tb_rq = new Set<String>();
            ubz_sc = new Map<String,Decimal>();
            tb_sc = new Map<String,Decimal>();
            osn_rq = null;
            osnTR_sc = 0;
            osnFA_sc = 0;
            mos_rq = 0;
            mos_sc = 0;
            hasTBRule = false;
            wk_sc = 0;
        }
        public void add_wkSc(Decimal d) {
            wk_sc = wk_sc + d;
        }
        public void add_mosSc(Integer pts) {
            mos_sc = mos_sc + pts;
            hasTBRule = true;
        }
        public void add_osnSc(Integer pts, Boolean b) {
            if (b)
                osnTR_sc += pts;
            else
                osnFA_sc += pts;
            hasTBRule = true;
        }
        public String outString() {
            return 'RQ: ubz: ' + ubz_rq + ' osn: ' + osn_rq + ' mos: ' + mos_rq + ' SC: ubz: ' + ubz_sc + 
                ' osnTR: ' + osnTR_sc + ' osnFA: ' + osnFA_sc + ' mos: ' + mos_sc + ' wk: ' + wk_sc; 
        }
    }

//0.  global variable declarations and constants
    String sAll = '__all__';                        //prefix for rules which match all values
    String g_workloadFieldStr;                      //the field with workload points for this object
    String g_timeFieldStr;                          //the name of the field on the object which is the time-based string
    String g_wkpIncFieldStr;                        //the name of the field on the object which is the workload point increment
    String g_skedRecTypeID;                         //the id of schedule record types, if there is any
    ID g_defQueueID;                                //the default queue ID

    Integer g_vaporSize = 3;                        //number of characters used in display to the user
    Double g_columnCount;                           //number of columns, userCount / 50

    Map<Long, String> g_efOrderMap;                 //map of engine field paths, keyed by order
    Map<String, String> g_umfLabelMap;              //map of engine field paths, keyed by label

    List<sObject> g_toAssignObjs;                   //the sObjects to be assigned to users
    String g_objType;                               //the type of sObject being assigned

    Set<String> g_paramsOnObjs;                     //the different values on the sObjects, based on the dynamic field set
    Map<String,Set<Integer>> g_rBitzParamMap;       //map of rule scenario number sets, for each paramvalue string
    Map<ID,Set<Integer>> g_objApplicableRSMap;      //map of applicable RS numbers, for each object ID

    Map<Integer,RuleScenario__c> g_ruleScenarioMap; //ruleScenarios which apply to any one of the sObjects, keyed by rule number

    Map<ID, String> g_objAssignDirectMap;           //map of the highest scoring AssignDirect, for each object
    Set<ID> g_assignDirectIDSet;                    //set of IDs of sObjects being directly assigned
    Map<ID, sortRules> g_objSortRulesMap;           //map of "sortRules", for each object
    Set<String> g_uBitzQueryParamSet;               //set of strings representing all relevant parameters, for querying
    Map<String,String> g_vaporStringMap;            //map of truncated vapor strings for displaying to user
    Map<String,Set<Integer>> g_uBitzParamMap;       //map of userNumber sets, for each paramvalue string
    Map<ID, Set<Integer>> g_eligibleUNumMap;        //set of user numbers, representing eligible users, for each sObject
    Map<Integer,UserData__c> g_userDataMap;         //UserData objects, keyed by user number
    Map<Integer,Decimal> g_userWorkPointsMap;       //map of workpoints by usernumber
    Map<ID, Map<Integer,Long>> g_objUserMinutesMap; //map of minutes on shift for each user number, for each sObject
    Map<Integer, Boolean> g_userOnShiftMap;         //map of on-shift-now for each user, keyed by user number
    Map<ID,Integer> g_userNumberByIDMap;            //map of userIDs to user number (for eligible users only)
    Map<ID,Map<Integer,scoreObj>> g_objScoreMap;    //map of scoreObj, keyed by user number.  one for each object by ID
    Map<ID,List<Integer>> g_objSortedHighScoreMap;  //map of highest scoring longs keyed by object
    Map<ID,Integer> g_objTopScorerMap;              //map of highest scoring single usernum keyed by object
    Map<Integer,User> g_listedUsers;                //map of users, keyed by user number

    //object assignment
    //accepts a set of object IDs and how many results to return
    //returns a sorted list of users and scores
    public Map<ID,scoreObj[]> objectAssign( List<ID> objIDs, Integer count) {
        //need some IDs for anything to occur
        if (objIDs == null) return null;
//TODO: check for dupes!

//1.  get object type
        getObjectType(objIDs);
        
//1a.  retrieve custom settings
        InUseRoster__c fieldProperties = InUseRoster__c.getInstance(g_objType);
        if (fieldProperties == null) return null;   //not routing this type of object, sorry!

        g_workloadFieldStr = fieldProperties.UD_WorkloadField__c;
        g_timeFieldStr = fieldProperties.TimeField__c;
        g_wkpIncFieldStr = fieldProperties.WorkloadIncrementField__c;
        g_skedRecTypeID = fieldProperties.skedRecTypeID__c;
        g_defQueueID = (ID)(fieldProperties.DefaultQueue__c);

        //one column for every 50 users
//TODO: Error trap if the custom setting doesn't exist
        g_columnCount = (Double)(EngineProperties__c.getInstance('NextUserSet').doubleValue__c);

        g_efOrderMap = new Map<Long,String>();
        g_umfLabelMap = new Map<String,String>();

        for (EngineFields__c ef : EngineFields__c.getAll().values()) {
            //get rid of the digits (lead3 becomes lead)
            String trimmedName = ef.Name.replaceAll('\\d','');
            //skip if it's the wrong type
            if(!trimmedName.equalsIgnoreCase(g_objType)) continue;
            //add the path to the appropriate maps
            g_efOrderMap.put(ef.order__c.longValue(),ef.Path__c);
//          g_efLabelMap.put(ef.label__c,ef.Path__c);
        }
        
        Set<String> sObjQParams = new Set<String>();
        sObjQParams.addAll(g_efOrderMap.values());
        for (UserMatchFields__c umf : UserMatchFields__c.getAll().values()) {
            //get rid of the digits (lead3 becomes lead)
            String trimmedName = umf.Name.replaceAll('\\d','');
            //skip if it's the wrong type
            if(!trimmedName.equalsIgnoreCase(g_objType) || umf.Path__c == null || umf.Path__c == '') continue;
            sObjQParams.add(umf.Path__c);           
            g_umfLabelMap.put(umf.label__c,umf.Path__c);
        }
        
//2.  retrieve sObject details
        querySObjects(objIDs, sObjQParams);

//3.  figure out which parameters are relevant for the sObject set
        consolidateParams();
            system.debug('consolidated parameters');
            for (String s : g_paramsOnObjs) system.debug(s);

//4.  Query for RuleBitz based on parameters
        queryRuleBitz();
            system.debug('rule bitz queried');
            for (String s : g_rBitzParamMap.keySet()) 
                system.debug('param ' + s + ': ' + g_rBitzParamMap.get(s));

//5.  figure out rule scenarios for each case
        createApplicableRSSetMap();
            system.debug('applicable rule scenario sets determined');
            for (ID i : g_objApplicableRSMap.keyset()) 
                system.debug('object ' + i + ': ' + g_objApplicableRSMap.get(i));

//6.  query for relevant rule scenarios which apply to any of our evaluated objects
        queryRuleScenarios();
            system.debug('rule scenarios queried');
            system.debug(g_ruleScenarioMap);

//7.  sort out reqs and scorings into collections
//    also get the list of directly assigned objects, for short-out later
        g_assignDirectIDSet = createSortRules();
            system.debug('sortRules sorted');
            for (ID i : g_objSortRulesMap.keyset()) system.debug('object ' + i + ': ' + g_objSortRulesMap.get(i).outString());

//8.  query for userbitz based on requirements and scorings, get a set of user numbers who have each param as a skill
        g_uBitzParamMap = userBitzQuery();
            system.debug('userbitz queried');
            for (String s : g_uBitzParamMap.keyset()) system.debug('param ' + s + ': ' + g_uBitzParamMap.get(s));

//9.  for each object, get the users which match all the attribute and userdata parameters
        g_eligibleUNumMap = getRqEligibleMap();
            system.debug('eligible sets initiated');
            for (ID i : g_eligibleUNumMap.keyset()) system.debug('object ' + i + ': ' + g_eligibleUNumMap.get(i));

//10.  query UD for remaining eligible users
        g_userDataMap = userDataQuery();
            system.debug('UserData queried');
            for (Integer i : g_userDataMap.keyset()) system.debug('user# ' + i + ': ' + g_userDataMap.get(i));

//10a.  for any unrestricted user sets, add all the users
        for (Id i : g_eligibleUNumMap.keySet()) {
            Set<Integer> thisSet = g_eligibleUNumMap.get(i);
            if (thisSet == null) {
                g_eligibleUNumMap.put(i,g_userDataMap.keySet());
            }
        }

//11.  create a map of userIDs, for schedule query
        g_userNumberByIDMap = new Map<ID,Integer>();
        for(Integer userNum : g_userDataMap.keySet()) {
            g_userNumberByIDMap.put(g_userDataMap.get(userNum).user__c,userNum);
        } 

//12.  query for schedules
        scheduleQuery();
            system.debug('schedules queried, on shift determiend');
            for (Integer i : g_userOnShiftMap.keyset()) system.debug('user# ' + i + ': ' + g_userOnShiftMap.get(i));

//13.  loop through all objects to perform each of the remaining actions (time-based elimination, all scoring)
        //objScoreMap has, for every object ID, one map of long (number of user) to scoreObj
        //objScoreMap replaces eligibleMap, as it has the same info, but with the scoreObj attached
        g_objScoreMap = new Map<ID,Map<Integer,scoreObj>>();
        g_objSortedHighScoreMap = new Map<ID,List<Integer>>();
        g_objTopScorerMap = new Map<ID,Integer>();

        //loop variables
        Set<Integer> thisEligibleUNumSet;
        sortRules thisSortRules;
        Map<Integer,Long> thisMinuteMap;
        Map<Integer,scoreObj> thisScoreSet;
        ID thisID;

        for (sObject oList : g_toAssignObjs) {
            if (g_assignDirectIDSet.contains(oList.ID)) continue;
            thisID = oList.ID;
            thisSortRules = g_objSortRulesMap.get(thisID);
            thisEligibleUNumSet = g_eligibleUNumMap.get(thisID);
            thisMinuteMap = g_objUserMinutesMap.get(thisID);

//14.  Eliminate based on time-based requirements
            cutOnTimeReqs(thisSortRules, thisEligibleUNumSet, thisMinuteMap);
                system.debug('time reqs evaluated');
                system.debug('object ' + thisID + ': ' + thisEligibleUNumSet);

//15.  assign direct bucket
            if (thisEligibleUNumSet.isEmpty()) {
                //nobody's eligible; put thisID in the set so it can be bucketed (or assigned to default) later 
                g_assignDirectIDSet.add(thisID);
            } else {
//16. collection of scores for eligibles for this object
                thisScoreSet = makeObjScoreMap(thisEligibleUNumSet);
                g_objScoreMap.put(thisID, thisScoreSet);
        
//17.  do scores for the at and ud parameters
                doAtUdScoring(thisSortRules, thisScoreSet, thisEligibleUNumSet);
                    system.debug('thru attribute scoring');
                    for (Integer i : thisScoreSet.keySet()) system.debug('user# ' + i + ': ' + thisScoreSet.get(i).getScore());

//18.  do scores for time-based parameters
                doTBScoring(thisSortRules, thisScoreSet, thisMinuteMap);
                    system.debug('thru time-based scoring');
                    for (Integer i : thisScoreSet.keySet()) system.debug('user# ' + i + ': ' + thisScoreSet.get(i).getScore());

                if (count > 1) {
//19.  do scores for workload
                    doWKScoring(thisSortRules.wk_sc, thisScoreSet);
                        system.debug('multi-set, thru work scoring');
                        for (Integer i : thisScoreSet.keySet()) system.debug('user# ' + i + ': ' + thisScoreSet.get(i).getScore());
//20.  figure out high scorers for this object
                    g_objSortedHighScoreMap.put(thisID,getTopScorers(thisScoreSet, count));
                        system.debug('sorted list of scorers');
                        system.debug(g_objSortedHighScoreMap.get(thisID));
                } else {
//19.  do scores for workload and figure out high scorer for this object, increment their workload
                    Integer highScoreUser = getTopScorer(thisScoreSet,thisSortRules.wk_sc);
                    //put the usernum in the winner map
                    g_objTopScorerMap.put(thisID, highScoreUser);
                        system.debug('single set, thru work scoring');
                        system.debug('top scorer: ' + highScoreUser);
//20.  add to the winning user's wkp score
                    Decimal thisObjIncrement;
                    if (g_wkpIncFieldStr == null)
                        thisObjIncrement = 1;
                    else {
                        thisObjIncrement = Decimal.valueOf(getFieldVal(oList,g_wkpIncFieldStr));
                    }
                    g_userWorkPointsMap.put(highScoreUser, g_userWorkPointsMap.get(highScoreUser)+thisObjIncrement);
                }
            }
        }

//21.  if auto-assign, do the assignment
        if (count < 1) {
            assignAndUpdate();
            return null;
        }
//otherwise build the return set
//22.  query for any assign direct queue details
        Map<ID,Group> assignDirectQueues = assignDirectQueueQuery();

//23.  query for user details
        g_listedUsers = userQuery(count);

//24.  create scoreObj collection
        Map<ID,scoreObj[]> returnMap = createScoreObjCollection(count, assignDirectQueues);
        
        return returnMap;

        return null;
    }


//Functional Breakouts
    //In here, we can add more Rule_Bit_Array fields as is necessary
    public Set<Integer> getActiveSet(RuleBitz__c thisRB) {
        return OAE_Utils.bitToSet(thisRB.ruleBitArray__c.round(),0);
    }
    //creates a set with all numbers 1 through max
    public Set<Integer> makeFullSet(Integer max) {
        Set<Integer> retVal = new Set<Integer>();
        max++;
        for (Integer i = 1; i < max; i++)
            retVal.add(i);
        return retVal;
    }

    public static String getFieldVal(sObject parentObj, String sPath) {
        String field = sPath;
        
        if (sPath.contains('.')) {
            String[] splitPath = sPath.split('\\.',0);
            for (Integer i = 0; i < (splitPath.size()-1); i++) {
                parentObj = (sObject)parentObj.getSObject(splitPath[i]);
            }
            field = splitPath[splitPath.size()-1];
        }

        return parentObj == null ? null : String.valueOf(parentObj.get(field));
    }

    private void getObjTypeFromID(ID firstID) {
        String IDstr = firstID;
        String prefix = IDstr.substring(0,3);
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String sObj : gd.keySet()) {
            String thisPrefix = gd.get(sObj).getDescribe().getKeyPrefix();
            if (prefix == thisPrefix) {
                g_objType = sObj;
                break;
            }
        }
    }
        
    //getObjectType
    //this function looks makes sure the objects are all the same type by matching the 3-char prefix.
    //returns false if there are differences
    //returns true if all are the same
    //calls another function to set the object type
    private Boolean getObjectType(List<ID> inboundIDs) {
        //grab any ID
        ID firstID;
        for (ID i : inboundIDs) {
            firstID = i;
            break;
        }

        //get the 3-char prefix
        String prefix = ((String)firstID).substring(0,3);

        //match all the IDs to the prefix
        for (ID i : inboundIDs) {
            if(!((String)i).startsWith(prefix))
                return false;
        }

        getObjTypeFromID(firstID);
        return true;
    }   

//  private void querySObjects(set<ID> objIDs) {
    private void querySObjects(List<ID> objIDs, Set<String> params) {
        g_toAssignObjs = new List<sObject>();

        //construct query string
        String qStr = 'Select id';

        //add dynamic parameters to query
        for (String sParam : params)
            qStr = qStr +', '+ sParam;
            
        if (g_timeFieldStr != null)
            qStr = qStr + ', ' + g_timeFieldStr;
        
        if (g_wkpIncFieldStr != null)
            qStr = qStr + ', ' + g_wkpIncFieldStr;
        
        qStr = qStr + ' From ' + g_objType + ' Where id in :objIDs';

        //query with this string
        SObject[] qRes = Database.query(qStr);
        //create a list of the objects
        for (SObject o : qRes)
            g_toAssignObjs.add(o); 
    }

    //consolidateParams
    //this function creates a string for all relevant values of each field
    //if two cases are inspected, with statuses of "Open" and "Closed", and Status is index 1, the resulting strings would be
    //"case;1;Open", "case;1;Closed", and "case;1;__all__"
    //this will restrict the rule bitz query to only those bitz which matter for these objects (i.e. don't retrieve "1;Processing")
    private void consolidateParams () {
        g_paramsOnObjs = new Set<String>();     
        //loop through engine fields to get paths
        for (Long lIndex : g_efOrderMap.keyset()) {
            String sPath = g_efOrderMap.get(lIndex);
            //for each object, retrieve the field value based on path and add it to the parameter set
            for (sObject oList: g_toAssignObjs) {
                g_paramsOnObjs.add(g_objType + ';' + lIndex + ';'+ getFieldVal(oList,sPath));
            }
            g_paramsOnObjs.add(g_objType + ';' + lIndex + ';' + sAll);
        }
    }

    private void queryRuleBitz() {
        g_rBitzParamMap = new Map<String,Set<Integer>>();
        //query for rulebitz
        List<RuleBitz__c> lrb = [Select id, paramValue__c, objectType__c, ruleBitArray__c
                        from RuleBitz__c where paramValue__c in :g_paramsOnObjs and objectType__c = :g_objType];

        //put rulebitz into the map, keyed by paramValue
        for (RuleBitz__c rb : lrb) 
            g_rBitzParamMap.put(rb.paramValue__c,getActiveSet(rb));
    }

    //createApplicableRSSetMap
    //this function looks at each object and creates a bit map representing which rules apply
    //e.g. rules 2 and 4 ==> 0000001010
    private void createApplicableRSSetMap() {
        g_objApplicableRSMap = new Map<ID,Set<Integer>>();
        Set<Integer> currentActive;
        Set<Integer> loopBitSet;
        Set<Integer> loopAllSet;
        String loopString;
        Set<Long> efKeys = g_efOrderMap.keyset();
        
        Set<Integer> fullSet = makeFullSet(50);
        //loop through the objects, checking which RS apply to each
        for (sObject oList : g_toAssignObjs) {
            currentActive = fullSet.clone();
            //loop through the relevant fields
            for(Long lIndex : efKeys) {
                //get field values for this particular object and this particular field
                loopString = g_objType + ';' + lIndex + ';' + getFieldVal(oList,g_efOrderMap.get(lIndex));
                //pull the bitz out for this particular parameter
                loopBitSet = g_rBitzParamMap.get(loopString);
                    
                //next check the all parameter, since those will also count
                loopString = g_objType + ';' + lIndex + ';' + sAll;
                loopAllSet = g_rBitzParamMap.get(loopString);
                if (loopBitSet == null) {
                    if (loopAllSet != null) {
                        currentActive.retainAll(loopAllSet);
                    }                   
                } else {
                    if (loopAllSet != null)
                        loopBitSet.addAll(loopAllSet);
                    currentActive.retainAll(loopBitSet);
                }
            }
            g_objApplicableRSMap.put(oList.ID, currentActive);
        }
    }

    private void queryRuleScenarios() {
        g_ruleScenarioMap = new Map<Integer,RuleScenario__c>();

        List<RuleScenario__c> ruleScenarioQuery;

        Set<Integer> applicableRS = new Set<Integer>();
        for (Set<Integer> s : g_objApplicableRSMap.values())
            applicableRS.addAll(s);     

        ruleScenarioQuery = [SELECT Id, Name, RuleNumber__c, RuleObject__c, AssignDirect__c, Order__c,
               (SELECT Id, Parameter__c, Value__c, Level__c, EngineValue__c, ParamNumber__c, 
                        IsDynamic__c, IsMinutesOnShift__c, IsOnShiftNow__c, MinValue__c, MaxValue__c
                  FROM Requirements__r
                  ORDER BY Parameter__c, Value__c, Level__c),
               (SELECT Id, Parameter__c, Value__c, Level__c, Points__c, EngineValue__c, ParamNumber__c,
                        IsDynamic__c, IsMinutesOnShift__c, IsOnShiftNow__c
                   FROM Scorings__r
                   ORDER BY Parameter__c, Value__c, Level__c)
            FROM RuleScenario__c 
            WHERE RuleNumber__c in :applicableRS and
                  RuleObject__c = :g_objType];

        //put rulescenarios in a map, keyed by rule number
        for (RuleScenario__c rs : ruleScenarioQuery)
            g_ruleScenarioMap.put(rs.RuleNumber__c.intValue(),rs);
    }

    //createSortRules
    //creates the various parameters which will be evaluated for each object
    private Set<ID> createSortRules() {
        g_objSortRulesMap = new Map<ID, sortRules>();
        g_uBitzQueryParamSet = new Set<String>();
        g_vaporStringMap = new Map<String,String>();
        g_objAssignDirectMap = new Map<ID, String>();
        g_objAssignDirectMap.put(g_defQueueID,g_defQueueID);        //need this ID in values() for later query

        //IDs of objects which should be assigned immediately
        Set<ID> assignNowIDSet = new Set<ID>();
        
        for (sObject sObj : g_toAssignObjs) {
            //create the new sortRules for this object
            sortRules thisSortRules = new sortRules();
            //get the set of RS which apply to this object
            Set<Integer> rSet = g_objApplicableRSMap.get(sObj.ID);

            //the highest order seen for assign direct for the object
            //starts as null, can get a neg or pos value
            Decimal iHighestOrder;
            //used to spot conflicting on-shift now requirements
            Boolean osnShorted = false;

            //loop through applicable rule scenarios
            for (Integer thisRuleNum : rSet) {
                RuleScenario__c matchingRS = g_ruleScenarioMap.get(thisRuleNum);

                //look if this RS has assign direct queues associated with it
                if (matchingRS.AssignDirect__c != null && matchingRS.Order__c != null) {
                    //check if we're the highest; if so, store this queue id, keyed by the object ID
                    if (iHighestOrder == null || iHighestOrder < matchingRS.Order__c) {
                        iHighestOrder = matchingRS.Order__c;
                        g_objAssignDirectMap.put(sObj.ID,matchingRS.AssignDirect__c);
                    }
                }

                //short out in positive assign direct cases (queue assign, no need for requirements)
                if (iHighestOrder == null || iHighestOrder <= 0) {
                    //add the rqs and scorings to the sortRules
                    for (Requirement__c rq : matchingRS.requirements__r) {
                        String rqConvert;
                        if (rq.isMinutesOnShift__c) {
                            //minute on shift requirement
                            //largest requirement is the one we will keep
                            thisSortRules.mos_rq = Math.max(thisSortRules.mos_rq, rq.minValue__c.intValue());
                            thisSortRules.hasTBRule = true;
                        } else if (rq.isOnShiftNow__c) {
                            //on shift now parameter
                            //set the osn field to whether it's required that user is on shift or not
                            //if we get conflicting requirements, set back to null
                            if (!osnShorted) {
                                Boolean current = rq.value__c.equalsIgnoreCase('TRUE');
                                if (thisSortRules.osn_rq != null && thisSortRules.osn_rq != current) {
                                    //found a conflict, short out so a follow-on doesn't re-set the field
                                    osnShorted = true;
                                    thisSortRules.osn_rq = null;
                                } else
                                    thisSortRules.osn_rq = current;
                                    thisSortRules.hasTBRule = true;
                            }
                        } else {
                            //convert the requirement to the format of paramvalue (_#_;_value_)
                            //deparameterize any strings that are dynamic
                            if (rq.isDynamic__c) {
                                rqConvert = rq.ParamNumber__c + ';' + getFieldVal(sObj, g_umfLabelMap.get(rq.parameter__c));
                                if (rq.level__c != null && rq.level__c != '')
                                    rqConvert = rqConvert + ';' + rq.level__c;  
                            } else
                                rqConvert = rq.engineValue__c;
                            
                            thisSortRules.ubz_rq.add(rqConvert);
                            g_uBitzQueryParamSet.add(rqConvert);
                        }
                    }
    
                    for (Scoring__c sc : matchingRS.scorings__r) {
                        String scConvert;
                        String vaporVal = sc.value__c;
                        
                        if (sc.isMinutesOnShift__c) {
                            //minute on shift requirement
                            //largest requirement is the one we will keep
                            thisSortRules.add_mosSc(sc.points__c.intValue());
                        } else if (sc.isOnShiftNow__c) {
                            //on shift now parameter
                            Boolean current = sc.value__c.equalsIgnoreCase('TRUE');
                            thisSortRules.add_osnSC(sc.points__c.intValue(),current);
                        } else if (sc.Parameter__c == 'Workload') {
                            thisSortRules.add_wkSc(sc.points__c);
                        } else {
                            //convert the scoring to the format of paramvalue (_#_;_value_)
                            //deparameterize any strings that are dynamic
                            if (sc.isDynamic__c) {
                                vaporVal = getFieldVal(sObj, g_umfLabelMap.get(sc.parameter__c));
                                scConvert = sc.ParamNumber__c + ';' + vaporVal;
                                if (sc.level__c != null && sc.level__c != '')
                                    scConvert = scConvert + ';' + sc.level__c;  
                            } else
                                scConvert = sc.engineValue__c;
    
                            thisSortRules.ubz_sc.put(scConvert,sc.points__c);
                            g_uBitzQueryParamSet.add(scConvert);
                        
                            //add vapor strings for user display
                            if (!g_vaporStringMap.containsKey(scConvert)) {
                                String vp1 = sc.parameter__c != null ? sc.parameter__c : '';
                                if (vp1 != null && vp1.length() > g_vaporSize) 
                                    vp1 = vp1.substring(0,g_vaporSize);
        
                                if (vaporVal != null && vaporVal.length() > g_vaporSize) 
                                    vaporVal = vaporVal.substring(0,g_vaporSize);
                                if (vaporVal == null)
                                    vaporVal = '';
                                    
                                g_vaporStringMap.put(scConvert,vp1 + vaporVal);                         
                            }
                        }
                    }
                }
            }
            //put the new sort rules in the map
            g_objSortRulesMap.put(sObj.ID,thisSortRules);
            
            //if we found an assign direct > 0, store the id to short out later processing
            if (iHighestOrder != null && iHighestOrder > 0)
                assignNowIDSet.add(sObj.ID);
        }

        return assignNowIDSet;
    }

    private Map<String,Set<Integer>> userBitzQuery() {
        Map<String,Set<Integer>> retVal = new Map<String,Set<Integer>>();

        //construct query string
        String qStr = 'Select id, paramvalue__c';

        //add dynamic parameters to query
        for (Integer i = 1; i <= g_columnCount; i++)
            qStr = qStr +', ' +'UBArray' +i +'__c';
        
        qStr = qStr + ' From UserBitz__c Where paramvalue__c in :g_uBitzQueryParamSet';

        //query with this string
        SObject[] qRes = Database.query(qStr);

        for (SObject o : qRes) {
            UserBitz__c ub = (UserBitz__c)o;
            Set<Integer> allBitz = new Set<Integer>();
            //go through all the UBArray## columns, adding each to the userBitz grid
            for (Integer j = 0; j < g_columnCount; j++) {
                Decimal d = (Decimal)ub.get('UBArray' +(j+1) +'__c');
                allBitz.addAll(OAE_Utils.bitToSet(d.longValue(),j*50));
            }
            retVal.put(ub.paramValue__c, allBitz);
        }
        return retVal;
    }

    private Map<ID, Set<Integer>> getRqEligibleMap() {
        Map<ID, Set<Integer>> retVal = new Map<ID, Set<Integer>>();
        //loop through and get eligibles for each object
        for (sObject sObj : g_toAssignObjs) {
            if (g_assignDirectIDSet.contains(sObj.ID)) continue;

            //get the requirements for matching rules on this object
            sortRules objSO = g_objSortRulesMap.get(sObj.id);

            Set<Integer> theseEligibles = null;
            //go through each attribute and userdata requirement
            for (String s : objSO.ubz_rq) {
                //pull the user set for this requirement
                Set<Integer> eligibleByThisRule = g_uBitzParamMap.get(s);
                if (eligibleByThisRule == null)
                    //nobody matched, no results!
                    theseEligibles = new Set<Integer>();
                else {
                    if (theseEligibles == null)
                        theseEligibles = eligibleByThisRule;
                    else
                        //drop those who don't match by taking the intersection
                        theseEligibles.retainAll(eligibleByThisRule);
                }
            }
            retVal.put(sObj.ID, theseEligibles);
        }
        return retVal;
    }

    private Map<Integer,UserData__c> userDataQuery() {
        Set<Integer> allEligibleNumbers = new Set<Integer>();
        Boolean permissive = false;
        g_userWorkPointsMap = new Map<Integer,Decimal> ();
        Map<Integer,UserData__c> retVal = new Map<Integer,UserData__c>();

        //combine the eligible users for all objects, for query filter
        //if any eligible sets are null, no restrictions placed - query for all userdata objects
        for (Set<Integer> thisSet : g_eligibleUNumMap.values()) {
            if (thisSet == null) {
                permissive = true;
                break;
            } else {
                allEligibleNumbers.addall(thisSet);
            }
        }

        //query user data
        //construct query string
        String qStr = 'Select id, UserNumber__c, User__c, Available__c';

        if (g_workloadFieldStr != null)  //dynamic workload points field, per object
            qStr = qStr + ', ' + g_workloadFieldStr;
        
        qStr = qStr + ' From UserData__c';

        if (!permissive) //we have a limited eligible set for all evaluated objects, use it to filter
            qStr = qStr + ' Where UserNumber__c in :allEligibleNumbers';

        //query with this string
        SObject[] qRes = Database.query(qStr);

//TODO: loop on the query for large return sets (I'm looking at you, BRE)
        for (SObject o : qRes) {
            UserData__c ud = (UserData__c)o;
            retVal.put(ud.UserNumber__c.intValue(), ud);
            if (g_workloadFieldStr != null)
                g_userWorkPointsMap.put(ud.UserNumber__c.intValue(),(Decimal)ud.get(g_workloadFieldStr));
        }
        return retVal;
    }
    
    private void scheduleQuery() {
        g_objUserMinutesMap = new Map<ID, Map<Integer,Long>>();
        g_userOnShiftMap = new Map<Integer, Boolean>();

//TODO synch this with "theNow" concept
        DateTime theNow = DateTime.now();
        DateTime startWindow = theNow;                      //start of time window
        DateTime endWindow = theNow;                        //end of time window for all rules
        List<sObject> timedObjects = new List<sObject>();   //list of objects with time-based rules

        //build timedObjects collection, determine the end of the query window
        for (sObject sObjThis : g_toAssignObjs) {
            if (g_assignDirectIDSet.contains(sObjThis.ID)) continue;
            //get rules for this object
            sortRules sr = g_objSortRulesMap.get(sObjThis.ID);
            //any time-based rules?
            if (sr.hasTBRule) {
                timedObjects.add(sObjThis);
                //shift the end of window out (as needed) based on this object's time field
                if (g_timeFieldStr != null) {
                    DateTime thisD = (DateTime)sObjThis.get(g_timeFieldStr);
                    if (thisD != null && endWindow < thisD)
                        endWindow = thisD;
                }
            }
        }

        //skip the rest if no objects have time-based rules
        if (timedObjects.size() > 0) {
            Map<ID, List<Event>> skedMap = new Map<ID, List<Event>>();      //schedules by user ID
            List<Event> myEvents;                                           //temp variable

            if (endWindow == null)
                endWindow = theNow;

//TODO add recordType here
            //query for schedules for eligible users, collect events by user
            for (Event e : [SELECT Id, Startdatetime, Enddatetime, ShowAs, IsRecurrence, ownerID 
                        FROM Event
                        WHERE ownerID in :g_userNumberByIDMap.keySet() and isrecurrence = false AND StartDateTime < :endWindow
                        AND EndDateTime > :startWindow ORDER BY ownerID, StartDateTime, EndDateTime]) {
                //add a new list to the map for this user if needed
                if (!skedMap.containsKey(e.ownerID)) {
                    myEvents = new List<Event>();
                    skedMap.put(e.ownerID, myEvents);
                } else
                    myEvents = skedMap.get(e.OwnerID);
                //put this event in the corresponding user's list
                myEvents.add(e);
            }
    
            //for each object that needs it, create a time map
            //the objMinuteMap is keyed by evaluated object id
            //the map it contains is a list of minutes keyed by user number
            for (sObject timedObj : timedObjects) {
                g_objUserMinutesMap.put(timedObj.ID, new Map<Integer, Long>());
            }
            for (ID thisUserID : g_userNumberByIDMap.keySet()) {
                myEvents = skedMap.get(thisUserID);

                //OnShiftNow: figure out on-shift, put that value in the map
                if (myEvents == null) { //no events! not on shift
                    g_userOnShiftMap.put(g_userNumberByIDMap.get(thisUserID), false);
                } else {
                    g_userOnShiftMap.put(g_userNumberByIDMap.get(thisUserID), getOnShift(myEvents));
                }

                //MinutesOnShift: figure out based on time field for each object
//TODO: make getMinutes a single call that returns MOS for each possible start/end combo, rather than doing it mutliple times
//ie call with a map of end times and get back a map of minutes
                for (sObject timedObj : timedObjects) {
//TODO: offer a fixed window rather than just timefieldStr
                    Map<Integer,Long> thisMinuteMap = g_objUserMinutesMap.get(timedObj.ID);
                    if (myEvents == null  || g_timeFieldStr == null) { //no events or no end in sight
                        thisMinuteMap.put(g_userNumberByIDMap.get(thisUserID), 0);
                    } else {
                        DateTime thisDT = (DateTime)timedObj.get(g_timeFieldStr);
                        thisMinuteMap.put(g_userNumberByIDMap.get(thisUserID), getMinutes(myEvents, thisDT));
                    }
                }
            }
        }       
    }

    private void cutOnTimeReqs(sortRules objSortRules, Set<Integer> thisEligibleSet, Map<Integer,Long> thisMinuteMap) {
        Boolean thisOSN = objSortRules.osn_rq;
        if (thisOSN != null) {
            Set<Integer> cutForOSN = new Set<Integer>();
            for (Integer userNum : thisEligibleSet) {
                if (g_userOnShiftMap.get(userNum) != thisOSN)
                    cutForOSN.add(userNum);
            }
            thisEligibleSet.removeAll(cutForOSN);
        }

        Integer thisMOS = objSortRules.mos_rq;
        if (thisMOS > 0) {
            Set<Integer> cutForMOS = new Set<Integer>();
            for (Integer userNum : thisEligibleSet) {
                if (thisMinuteMap.get(userNum) < thisMOS)
                    cutForMOS.add(userNum);
            }
            thisEligibleSet.removeAll(cutForMOS);
        }
    }

    private Map<Integer,scoreObj> makeObjScoreMap(Set<Integer> thisObjEligibles) {
        Map<Integer,scoreObj> thisObjMap = new Map<Integer,scoreObj>();
        
        for (Integer userNum : thisObjEligibles) {
            //make sure UserData exists, esp for no-req scenarios
            if (g_userDataMap.containsKey(userNum))
                thisObjMap.put(userNum, new scoreObj());
        }

        return thisObjMap;
    }

    private void doAtUdScoring(sortRules objSortRules, Map<Integer,scoreObj> objScoreSet, Set<Integer> objEligible) {
        Integer userCount;

        //loop through the scoring rules
        for (String s : objSortRules.ubz_sc.keyset()) {
            //grab the point total for this rule
            Integer thisScore = objSortRules.ubz_sc.get(s).intValue();
            if (thisScore == null) continue;
            
            if (g_uBitzParamMap.containsKey(s)) {
                Set<Integer> userNumsWhoHaveThisSkill = new Set<Integer>(g_uBitzParamMap.get(s));
            
                //of those who have this skill, who are eligible on this object?
                userNumsWhoHaveThisSkill.retainAll(objEligible);

                for (Integer gimmePoints : userNumsWhoHaveThisSkill) {
                    scoreObj so = objScoreSet.get(gimmePoints);
                    if (so != null) {
                        so.addVaporPts(g_vaporStringMap.get(s),thisScore);
                    }
                }
            }
        }
    }

    private void doTBScoring(sortRules objSortRules, Map<Integer,scoreObj> objScoreSet, Map<Integer,Long> thisMinuteMap) {
        Integer thisOSNTrue = objSortRules.osnTR_sc;
        Integer thisOSNFalse = objSortRules.osnFA_sc;

        if (thisOSNTrue != 0 || thisOSNFalse != 0){
            for(Integer userNum : objScoreSet.keySet()) {
                scoreObj so = objScoreSet.get(userNum);
                Boolean myOnShift = g_userOnShiftMap.get(userNum);
                if (myOnShift == null) continue;
                if (myOnShift && thisOSNTrue != 0) {
                    //yes i hard coded the vapor string here.  Sorry.
                    so.addVaporPts('OSNTru',thisOSNTrue);
                } else if (!myOnShift && thisOSNFalse != 0) {
                    so.addVaporPts('OSNFal',thisOSNFalse);
                }
            }
        }
        Integer thisMOS = objSortRules.mos_sc;
        if (thisMOS != 0) {
            for(Integer userNum : objScoreSet.keySet()) {
                scoreObj so = objScoreSet.get(userNum);
                Long myMins = thisMinuteMap.get(userNum);
                if (myMins != null && myMins != 0) {
                    so.addVaporPts('Min:'+myMins+'*'+thisMOS,(myMins * thisMOS).intValue());
                }
            }
        }
    }

    //returns the user number of the top scoring user
    private Integer getTopScorer(Map<Integer,scoreObj> scoreMap, Decimal multiplier) {
        Integer topUser;
        Decimal topScore = -99999999;
        for (Integer userNum : scoreMap.keySet()) {
            scoreObj thisSO = scoreMap.get(userNum);
            system.debug('debOAEch1' + thisSO.getScore() + ' ' + g_userWorkPointsMap.get(userNum) + ' ' + multiplier);
            Decimal postWorkloadScore = thisSO.getScore() + g_userWorkPointsMap.get(userNum) * multiplier;
            if (postWorkloadScore > topScore) { //new top score
                topScore = postWorkloadScore;
                topUser = userNum;
            }
        }
        scoreObj so = scoreMap.get(topUser);
        Decimal currentPts = g_userWorkPointsMap.get(topUser);
        so.addVaporPts('Work:'+currentPts+'*'+multiplier, (currentPts * multiplier).intValue());
        return topUser;
    }
    
    private void doWKScoring(Decimal wkPts, Map<Integer,scoreObj> objScoreSet) {
        if (wkPts != 0) {
            for (Integer userNum : objScoreSet.keySet()) {
                scoreObj thisScoreObj = objScoreSet.get(userNum);
                Decimal workScore = g_userWorkPointsMap.get(userNum);
                if (thisScoreObj != null && workScore != null) {
                    thisScoreObj.addVaporPts('Work:'+workScore+'*'+wkPts, (wkPts * workScore).intValue());
                }
            }
        }
    }

    //return a sorted list of user numbers, in order of top score
    private List<Integer> getTopScorers(Map<Integer,scoreObj> thisScoreSet, Integer count) {
        List<Integer> retVal = new List<Integer>();
        
        Map<Double,Integer> scoreToUNumMap = new Map<Double,Integer>();
        for (Integer uNum : thisScoreSet.keySet()) {
            //negative to handle the fact that the sort() function only does ascending sort
            Double thisPointCount = -1 * Double.valueOf(thisScoreSet.get(uNum).getScore());
            //tie scores - get them all in the map by ticking the key up by .0001
            while (scoreToUNumMap.containsKey(thisPointCount))
                thisPointCount += 0.0001;
            scoreToUNumMap.put(thisPointCount, uNum);
        }
        List<Double> sortingScores = new List<Double>();
        sortingScores.addAll(scoreToUNumMap.keySet());
        sortingScores.sort();
        
        //only return the top N users if the list is larger than N
        Integer loopVal = Math.min(count,sortingScores.size());

        for (Integer i = 0; i < loopVal; i++) {
            Double highScore = sortingScores.get(i);
            retVal.add(scoreToUNumMap.get(highScore));
        }
        return retVal;
    }

    private Map<ID,Group> assignDirectQueueQuery() {
        return new Map<ID,Group>([select id, name from Group where id in :g_objAssignDirectMap.values()]);
    }

    private void assignAndUpdate() {
        UserData__c thisUserData;
        Integer winnerInt;

        for (sObject thisObj : g_toAssignObjs) {
            if (g_assignDirectIDSet.contains(thisObj.ID)) {
                String queueID = g_objAssignDirectMap.get(thisObj.ID);
                if (queueID == null) {
                    thisObj.put('OwnerID',g_defQueueID);                    
                } else {
                    thisObj.put('OwnerID',queueID);
                }   
            } else {
                winnerInt = g_objTopScorerMap.get(thisObj.ID);
                thisUserData = g_userDataMap.get(winnerInt);
                if (thisUserData != null) {
//change this here (as well as the UserData query) to assign to other than user
                    thisObj.put('OwnerID',thisUserData.User__c);
                }
            }
        }       
        update g_toAssignObjs;
    }

//return a map of user objects, keyed by user number
    private Map<Integer,User> userQuery(Integer count) {
        UserData__c thisUserData;
        User thisUser;

        //consolidate user numbers for all objects
        Set<Integer> allUsers = new Set<Integer>();

        if (count <=1) {
            //we only have one, so it's in the top scorer map
            allUsers.addAll(g_objTopScorerMap.values());
        } else {
            //we have multiples, so check the sorted score map
            for (List<Integer> theseGuys : g_objSortedHighScoreMap.values())
                allUsers.addAll(theseGuys);
        }
        //create a map to retrieve the user number later
        Map<ID,Integer> idToUNumMap = new Map<ID,Integer>();

        for (Integer thisUNum : allUsers) {
            thisUserData = g_userDataMap.get(thisUNum);
            if (thisUserData != null)
                idToUNumMap.put(thisUserData.User__c, thisUNum);
        }

        //query for users based on the IDs of the users
        Map<ID,User> queryMap = new Map<ID,User>([Select id, name, firstname, lastname, username
            From User Where id in :idToUNumMap.keySet()]);

        Map<Integer,User> retVal = new Map<Integer,User>();

        //construct the UNum->User map
        for (ID thisID : queryMap.keySet()) {
            thisUser = queryMap.get(thisID);
            retVal.put(idToUNumMap.get(thisID),thisUser);
        }
        return retVal;
    }

    private Map<ID,scoreObj[]> createScoreObjCollection(Integer count, Map<ID,Group> assignDirectQueues) {
        Map<ID,scoreObj[]> retVal = new Map<ID,scoreObj[]>();
        Map<Integer,scoreObj> thisScoreMap;
        scoreObj thisScoreObj;
        List<Integer> thisSortedUNums;
        User thisUser;
        UserData__c thisUserData;

        for (sObject thisObj : g_toAssignObjs) {
            if (g_assignDirectIDSet.contains(thisObj.ID)) {
                String queueID = g_objAssignDirectMap.get(thisObj.ID);
                Group queue;
                if (queueID != null) 
                    queue = assignDirectQueues.get(queueID);

                if (queue == null)
                    queue = assignDirectQueues.get(g_defQueueID);

                thisScoreObj = new scoreObj(queue);

                scoreObj[] thisSOSet = new scoreObj[]{thisScoreObj};
                retVal.put(thisObj.id, thisSOSet);
            } else {
                thisScoreMap = g_objScoreMap.get(thisObj.ID);
                if (count > 1)
                    thisSortedUNums = g_objSortedHighScoreMap.get(thisObj.ID);
                else
                    thisSortedUNums = new List<Integer>{g_objTopScorerMap.get(thisObj.ID)};

                if (thisScoreMap != null && thisSortedUNums != null) {
                    scoreObj[] thisSOSet = new scoreObj[]{};
        
                    for (Integer uNum : thisSortedUNums) {
                        thisScoreObj = thisScoreMap.get(uNum);
                        thisUser = g_listedUsers.get(uNum);
                        if (thisScoreObj != null && thisUser != null) {
                            thisScoreObj.setUser(thisUser);
                    // tphan 2 21 2012 Make the engine look at availability on UserData object
                             if (g_userDataMap.get(uNum).Available__c == True)
                                thisScoreObj.setAvail(True);   
                            thisSOSet.add(thisScoreObj);
                        }
                    }
                    retVal.put(thisObj.id, thisSOSet);
                }
            }
        }
        return retVal;
    }


    //EVENT LIST MUST BE SORTED BY START DATE
    public static Long getMinutes(List<Event> myEvents, DateTime windowEnd){
        Long total = 0;
        DateTime beginDT = DateTime.now(); //all valid hours before me are added already
        DateTime endDT = beginDT;
        Boolean busy;

        for (Event e : myEvents) {
            if (e.endDateTime > beginDT) {
                busy = (e.ShowAs == 'Busy');
                if (e.StartDateTime > endDT) {
                    //add current to total
                    total += (endDT.getTime() - beginDT.getTime());
                    if (busy)
                        beginDT = e.StartDateTime;
                    else
                        beginDT = e.EndDateTime;
                    endDT = e.EndDateTime;
                } else {
                    if (busy) {
                        if (e.EndDateTime > endDT)
                            endDT = e.EndDateTime;
                    } else {
                        //add any not-cancelled part to total
                        if (beginDT < e.StartDateTime)
                            total += (e.StartDateTime.getTime() - beginDT.getTime());
                        //move begin of window to end of OOO event
                        beginDT = e.EndDateTime;
                        //if OOO goes beyond current window, cancel up to that time
                        if (e.EndDateTime > endDT)
                            endDT = e.EndDateTime; 
                    }
                }
                if (endDT > windowEnd) endDT = windowEnd;
            }
        }

        //add final segment 
        total += (endDT.getTime() - beginDT.getTime());

        return total / 60000;
    }

    public static Boolean getOnShift(List<Event> myEvents){
        DateTime now = DateTime.now();
        Boolean retVal = false;
        for (Event e : myEvents) {
            if (e.StartDateTime < now && e.EndDateTime > now) {
                if (e.showAs == 'Busy')
                    retVal = true;
                else
                    return false;
            }
        }
        return retVal;
    }
}