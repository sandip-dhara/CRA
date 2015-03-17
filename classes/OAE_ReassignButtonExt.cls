public class OAE_ReassignButtonExt {
//    public Case oCase = new case();
    public sObject theRecord;
    
    public Integer ibringBack = 0;
    string strbringBack = ApexPages.currentPage().getParameters().get('bringBack');
    string strObjType = ApexPages.currentPage().getParameters().get('oType');
    string strObjID = ApexPages.currentPage().getParameters().get('ID');
    
    public Boolean IsAutoAssignment = false;
        public Boolean getIsAutoAssignment(){return this.IsAutoAssignment;}
    public list<ScoreObj> soList = new list<ScoreObj >();
        public list<ScoreObj> getsoList(){ return this.soList;}
    public list<ScoreObj> defaultGrid = new list<ScoreObj>();
        public list<ScoreObj> getdefaultGrid(){return this.defaultGrid;}
    public list<ScoreObj> QueueGrid = new list<ScoreObj>();
        public list<ScoreObj> getQueueGrid(){return this.QueueGrid;}
    
    public ScoreDebug__c scoreDebug;
    
    public string userID = '';
        public string getuserID(){ return this.userID;}
        public void setuserID(string str){this.userID = str;}
    
    public string QueueID = '';
        public string getQueueID(){ return this.QueueID;}
        public void setQueueID(string str){this.QueueID = str;}
   
    public boolean NoResult = false;
        public boolean getNoResult(){return this.NoResult;}
    public boolean Queue = false;
        public boolean getQueue(){return this.Queue;}
    public boolean Grid = false;
        public boolean getGrid(){return this.Grid;}
    
//    public OAE_ReassignButtonExt(ApexPages.StandardController SC) {
    public OAE_ReassignButtonExt() {
        try {
            //sets bring back paramater value
            ibringBack = Integer.valueOf(strbringBack);
            // checking if it is an auto-assignment.
            if(ibringBack <= 0)
                IsAutoAssignment = true;
        // If exception occurs in setting bring back parameter or invalid parameter is send it retrives bring back value from setting.
        } Catch(Exception ex) {
            ibringBack = 20;
        }
        try {
            String qStr = 'select id, ownerID from ' + strObjType + ' where id = :strObjID';
system.debug(qstr);
system.debug(strObjID);
            SObject[] qRes = Database.query(qStr);
            if (qRes.size() == 0)
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The ID could not be used in a query.'));
            else {
                theRecord = qRes[0];
    //          theRecord = SC.getRecord();
    //          oCase = (Case)SC.getRecord();
                //if some invalid case id is passed or not case found returns the error message.
                if(theRecord == null || theRecord.ID == null )
    //            if(oCase == null || oCase.ID == null )
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error in locating your case.  Please contact an administrator.'));
                else if(!IsAutoAssignment) {
                    OAE_ObjectAssign objAsgn = new OAE_ObjectAssign();
                    Map<ID,scoreObj[]> soMap = objAsgn.objectAssign(new List<ID>{theRecord.Id}, ibringBack); 
                    if (soMap == null) {
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No rules established for the ' + strObjType + ' object.  Please contact an administrator.'));
                    } else {
                        soList = soMap.get(theRecord.ID);
        //                soList = objAsgn.objectAssign(new List<ID>{oCase.Id}, ibringBack).get(oCase.ID);
                        if(soList.size() > 0) {
                            //get scoreDebug for later insertion
        //                    scoreDebug = soList[0].getSD();
        
                            //one item, with a queue value – do the queue grid
                            if(soList.size() == 1 && soList[0].getQueue() != null && soList[0].getQueue().ID != null) {
                                Queue = true;
                                QueueGrid = soList;
                            //if there is no user associated with the first item, and we’re not in the queue condition
                            //then this is the default queue scenario
                            } else if (soList[0].getUser() == null) {
                                //default queue
                                setUpDefaultQueue();
                            //otherwise we have users to display
                            } else {
                                Grid = true; 
                            }
                        }    
                        //if no valid assigne found retrive default queue from setting.
                        else {
                            setUpDefaultQueue();
                        }
                    }
                }
            }
        }
        Catch(Exception ex)
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    public void setUpDefaultQueue() {
        noResult = true;
        if (InUseRoster__c.getInstance(strObjType).DefaultQueue__c != null) {
            ID dqid = (ID)(InUseRoster__c.getInstance(strObjType).DefaultQueue__c);
            list<Group> lstQueue = [select id, name from Group where id = :dqid];
            defaultGrid.clear();
            if(lstQueue != null && lstQueue.size() > 0)
                defaultGrid.add(new scoreObj(lstQueue[0]));
            else 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Specified Default Queue not found. Please contact Administrator.'));
        }
        else 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Default Queue set for this object. Please contact Administrator.'));
      }

    public pageReference Autoassign() {
        try {
            if(IsAutoAssignment) {
                OAE_ObjectAssign objAsgn = new OAE_ObjectAssign();
                soList = objAsgn.objectAssign(new List<ID>{theRecord.Id}, ibringBack).get(theRecord.Id);
//              soList = objAsgn.objectAssign(new List<ID>{oCase.Id}, ibringBack).get(oCase.Id);
                return getCasePageReference();
            }
        } Catch(Exception ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }

    private boolean IsValidString(string str) {
        if(str != null && str.length() > 0)
            return true;
        return false;
    }

    public PageReference Reassign() {
        try {
            if(Grid && IsValidString(userID)) {
//              oCase.OwnerID = userID;
                theRecord.put('OwnerID',userID);
                update theRecord;
            }
            if((Queue || noResult) && IsValidString(QueueID)) {
//              oCase.OwnerID = QueueID;
                theRecord.put('OwnerID',QueueID);
                update theRecord; 
            }
//          if (scoreDebug != null) insert scoreDebug;
            return getCasePageReference();
        } Catch(Exception ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }

    public PageReference Cancel() {
        try {
//          if (scoreDebug != null) insert scoreDebug;
            return getCasePageReference();
        } Catch(Exception ex) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return null;
    }
    public pageReference getCasePageReference() {
        PageReference oPageReference = new PageReference('/' + theRecord.Id);
        oPageReference.setRedirect(true);
        return oPageReference;
    }
}