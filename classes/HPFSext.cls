global class HPFSext{
    
    
    WebService static string sendMessage(string oppId) {
        Savepoint sp1 = Database.setSavepoint();
        try{
        
        
        //string userId, string accName, string oppValue, string bsDate, 
        
        //variables
        List<OpportunityTeamMember> otmList = new List<OpportunityTeamMember>();
        
        //clone opp
        String soql;
        soql = getCreatableFieldsSOQL('opportunity','Id=\''+oppId+'\'');
        Opportunity opp1 = (Opportunity)Database.query(soql);
        
       if (opp1.Confidential__c){
            Database.rollback(sp1);
            return '\'Engage HPFS\' is disabled to ensure that the opportunity content remains confidential. Please contact your HPFS counterpart directly to engage HPFS.';
        }
        
        if (opp1.HPFS_Needed__c){
            Database.rollback(sp1);
            return 'HPFS has already been engaged.';
        }
        
        if (opp1.type == 'Renewal'){
            Database.rollback(sp1);
            return 'HPFS engagement cannot occur on Renewal opportunities.';
        }
        
        Opportunity opp2 = opp1.clone(false, true);
        
        //append HPFS_ to clone opp name
        opp2.Name = 'HPFS-' + opp1.Name;
        
        //set clone opp record type to HPFS
        Id rt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
        opp2.RecordTypeId = rt;
        
        //set clone opp sales stage to 01
        OpportunityStage os = [SELECT MasterLabel FROM OpportunityStage WHERE MasterLabel like '01%' limit 1];
        opp2.StageName = os.MasterLabel;
        system.debug('new HPFS opp masterlabel = ' + opp2.stagename);
        
        //determine close date
        Date today = Date.today();
        Date minDate = today.addDays(30);
        if (opp1.CloseDate <= minDate){
            opp2.CloseDate = minDate;
        }
        else if (opp1.CloseDate > minDate){
            opp2.CloseDate = opp1.CloseDate;
        }
        
        //determine new opp owner
        User newOwner = null;
       // Id randSdmId = null;
         User randSdmUser = null;
        String newOwnerRole;
        User oldOwner = [Select Id, Business_Group__c, Region__c, userrole.name from User where Id = :opp1.OwnerId];
        String userRoleString;
        if (oldOwner.userrole.name != null){
            userRoleString = oldOwner.userrole.name;
        }
        else{userRoleString = '';}
        System.debug('##quang checking if es');
        if (oldOwner.Business_Group__c == 'ES'){ //if user is ES
            
            //get 'HPFS OAM' user from account team or territory
            newOwner = getAccUser('HPFS OAM',Opp1.AccountId,opp1.Id);
            newOwnerRole = 'Specialist';
            if (newOwner == null){
                    System.debug('No valid HPFS OAM or SDM reps were found, randomly assigning to SDM in opportunity region.');
                    
                         randSdmUser= getRandSdm(oldOwner.Region__c);
                         
                    opp2.Owner__c = randSdmUser.Id;
                    opp2.OwnerId = randSdmUser.Id;
                }
            else{
                    opp2.Owner__c = newOwner.Id;
                    opp2.OwnerId = newOwner.Id;
                    }
            
            }//end main if
        else if (userRoleString.contains('GSB') ) {
            newOwner = getAccUser('HPFS GSB FAM',Opp1.AccountId,opp1.Id);
            newOwnerRole = 'Specialist';
            if (newOwner == null){
                    System.debug('No valid HPFS GSB FAM or SDM reps were found, randomly assigning to SDM in opportunity region.');
                    
                         randSdmUser= getRandSdm(oldOwner.Region__c);
                         
                    opp2.Owner__c = randSdmUser.Id;
                    opp2.OwnerId = randSdmUser.Id;
                }
            else{
                    opp2.Owner__c = newOwner.Id;
                    opp2.OwnerId = newOwner.Id;
                    }
        }
        //original opp owner is NOT ES and NOT GSB
        else {
            //check if has PL55
            Boolean isPL55 = false;
            List<Id> prodIds = new List<Id>();
            for (OpportunityLineItem oli : [SELECT Product__c FROM OpportunityLineItem WHERE OpportunityId = :opp1.Id]){
                Id newid = oli.Product__c;
                prodIds.add(newid);
                }//end prodIds loop
            List<Product2> prod2list = new List<Product2>( [Select ProductCode from Product2 WHERE Product_Line__c like '55%' AND Id in :prodIds]);
            if (prod2list.size() > 0){
                    //opp is NOT DIRECT
                    isPL55 = true;
                }//end prod2list if
            
            //PL55 or Direct
            if (isPL55 == true){
                    
                    newOwner = getAccUser('HPFS T-SAM',Opp1.AccountId,opp1.Id);
                    newOwnerRole = 'Specialist';
                    if (newOwner == null){
                        System.debug('No valid HPFS T-SAM or SDM reps were found, randomly assigning to SDM in opportunity region.');
                         
                         randSdmUser= getRandSdm(oldOwner.Region__c);
                         
                    opp2.Owner__c = randSdmUser.Id;
                    opp2.OwnerId = randSdmUser.Id;

                        }
                    else{
                        opp2.Owner__c = newOwner.Id;
                        opp2.OwnerId = newOwner.Id;
                        }
                    
                    }//end Pl55 true if
            else if (isPL55 == false){
                    System.debug('##quang opportunity is not ES and not PL55, looking for HPFS FAM on account team');
                    newOwner = getAccUser('HPFS FAM',Opp1.AccountId,opp1.Id);
                    newOwnerRole = 'Specialist';
                    if (newOwner == null){
                        System.debug('No valid HPFS FAM or SDM reps were found, randomly assigning to SDM in opportunity region.');
                         
                         randSdmUser= getRandSdm(oldOwner.Region__c);
                         
                    opp2.Owner__c = randSdmUser.Id;
                    opp2.OwnerId = randSdmUser.Id;
                        }
                    else{
                        opp2.Owner__c = newOwner.Id;
                        opp2.OwnerId = newOwner.Id;
                        }
                }//end PL55 false if
            
            }//end main else
        
        
        //insert the clone opp
        opp2.Finance_Type__c = '';
        opp2.ForecastCategoryName = null;
        opp2.Legacy_Ref_id__c = null;
        insert opp2;
        opp1.HPFS_Needed__c = true;
        update opp1;
        
        //add newOwner into new opportunity team
        //OpportunityTeamMember otm = new OpportunityTeamMember(UserId = newOwner.Id,TeamMemberRole = newOwnerRole, OpportunityId = opp2.Id);
        //insert otm;
        //modify newOwner access by inserting user into OpportunityShare table
        //OpportunityShare oppshare = new OpportunityShare(OpportunityId = opp2.Id, OpportunityAccessLevel = 'Edit', UserOrGroupId = newOwner.Id);
        //insert oppshare;
        
        //relate opportunities
        Related_Opportunities__c new_ro1 = new Related_Opportunities__c();
        new_ro1.Opportunity__c = opp1.Id;
        new_ro1.Related_Opportunity__c = opp2.Id;
        insert new_ro1;
        Related_Opportunities__c new_ro2 = new Related_Opportunities__c();
        new_ro2.Opportunity__c = opp2.Id;
        new_ro2.Related_Opportunity__c = opp1.Id;
        insert new_ro2;
        

//        opp2.Related_Opportunity__c = opp1.id;
//        opp2.Originating_Opportunity__c = opp1.id;
//        update opp2;
        
        //add alliance/channel partners
        soql = getCreatableFieldsSOQL('Channel_Partner__c','Opportunity__c=\''+opp1.Id+'\''); //get all editable fields
        List<Channel_Partner__c> cpl = (List<Channel_Partner__c>)Database.query(soql); //get all channel partners for original opp
        List<Channel_Partner__c> cplNew = new List<Channel_Partner__c>(); //channel partners to be added
        for (Channel_Partner__c cp : cpl){
            //for each channel partner found, clone, set new ID, add to new list
            Channel_Partner__c newCp = cp.clone(false, true);
            newCp.Opportunity__c = opp2.Id;
            cplNew.add(newCp);
        }
        //if cplNew is not empty, insert new records
        if (cplNew.size() > 0){
            insert cplNew;
            }
        
        //add original product lines
        soql = getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\''+opp1.Id+'\''); //get all editable fields
        List<OpportunityLineItem> oliList = (List<OpportunityLineItem>)Database.query(soql); //get all products related to original opp
        Map<Id, OpportunityLineItem> oldOLInewOLI = new Map<Id, OpportunityLineItem>();
        List<Id> oliWithSchedule = new List<Id>();
        Integer oppLineItemCount = 0;
        
        //10-25-2012 for loop by quang
        for (OpportunityLineItem oli : oliList) {
                        if (oli.HasSchedule){
                            oliWithSchedule.add(oli.id);   
                                }
                        OpportunityLineItem newOli = oli.clone(false, true);
                        
                        if ( newOli.ServiceDate <= minDate ){
                            newOli.ServiceDate = minDate;
                            }
                        
                        newOli.TotalPrice = null;
                        newOli.Legacy_Ref_Id__c = null;
                        newOli.opportunityid = opp2.id;
                        oldOLInewOLI.put(oli.id,newOli);
                }
        if (oldOLInewOLI.size()>0){        
                insert oldOLInewOLI.values();
        }
        system.debug('opp line items cloned, looping through items with schedules');
        
        system.debug('oliWithSchedule size: ' + oliWithSchedule.size());
        if (oliWithSchedule.size()>0){
        //generate soql string with matched ids
        system.debug('generating soql for opp line items with schedule');
        Integer matchedCount = 0;
        String matchedIdString = '';
        for (Id matchedId : oliWithSchedule){
                if (matchedCount == 0){
                    matchedIdString = matchedIdString + 'OpportunityLineItemId= \'' + matchedId + '\' ';
                    matchedCount += 1;
                        }
                else {
                    matchedIdString = matchedIdString + 'OR OpportunityLineItemId= \'' + matchedId + '\' ';
                        }
                }
        system.debug('matchedIdString: ' + matchedIdString);
        soql = getCreatableFieldsSOQL('OpportunityLineItemSchedule',matchedIdString);
        system.debug('soql string: ' + soql);
        List<OpportunityLineItemSchedule> olisListOld = (List<OpportunityLineItemSchedule>)Database.query(soql);
        List<OpportunityLineItemSchedule> olisListNew = new List<OpportunityLineItemSchedule>();
        for (OpportunityLineItemSchedule olis : olisListOld){

                    OpportunityLineItemSchedule newOlis = olis.clone(false, true);
                    if ( newOlis.ScheduleDate <= minDate ){
                            newOlis.ScheduleDate = minDate;
                        }
                    
                    newOlis.OpportunityLineItemId = oldOLInewOLI.get(olis.OpportunityLineItemId).Id;
                    olisListNew.add(newOlis);
            }
        
         if (olisListNew.size()>0){
              insert olisListNew;
         }    
         
         }
            
            
            
            
            
        
        //old for loop
        /*for (OpportunityLineItem oli : oliList) {
            //system.debug('put old oli into map with key: '+oppLineItemCount);
            //oldOppLineItemMap.put(oppLineItemCount, oli);
            System.debug ('cloning oli: ' + oli.id);
            //for each opportunitylineitem: clone, update opp id, change servicedate if applicable, insert new OLI
            OpportunityLineItem newOli = oli.clone(false, true);
            newOli.OpportunityId = opp2.id;
            if (newOli.ServiceDate <= minDate){
                    newOli.ServiceDate = minDate;
                }
            newOli.TotalPrice = null;
            newOli.Legacy_Ref_Id__c = null;
            insert newOli;
            
            System.debug('oli.hasschedule = '+oli.HasSchedule);
            
            if (oli.HasSchedule == true){
                    List<OpportunityLineItemSchedule> olisListNew = new List<OpportunityLineItemSchedule>();
                    //if OLI has schedule, copy OLIschedule and assign to OLI
                    soql = getCreatableFieldsSOQL('OpportunityLineItemSchedule','OpportunityLineItemId=\''+oli.Id+'\'');
                    List<OpportunityLineItemSchedule> olisList = (List<OpportunityLineItemSchedule>)Database.query(soql);
                    
                    for (OpportunityLineItemSchedule olis : olisList){
                            System.debug('adding oli schedule ' + olis.id);
                            OpportunityLineItemSchedule newOlis = olis.clone(false, true);
                            //OpportunityLineItemSchedule newOlis = new OpportunityLineItemSchedule();
                            
                            
                                if ( newOlis.ScheduleDate <= minDate ){
                                        newOlis.ScheduleDate = minDate;
                                    }
                                
                                
                                
                            
                            newOlis.OpportunityLineItemId = newOli.Id;
                            olisListNew.add(newOlis);
                        }
                    insert olisListNew;
                }
            
            
            }*/
        
        

        //get Opportunity_Id__c autonumber (it won't auto get this)
        String hpOppId;
        String totalOppValue;
        Opportunity oppo = [Select Opportunity_Id__c, Name, Amount, CurrencyIsoCode, Account.Name, CloseDate from Opportunity where Id = :opp2.id];
        hpOppId = oppo.Opportunity_Id__c;
        String oppAmount = currency(String.valueof(oppo.Amount));
        if (oppAmount == null){
            oppAmount='0';
        }
        totalOppValue = oppo.CurrencyIsoCode + ' ' + oppAmount;
        
        //chatter notification section
        User currentUser = (User)[Select Id, Name, Email from User where Id= :UserInfo.getUserId()];
        FeedItem post = new FeedItem();
       if (newOwner != null){
        post.ParentId = newOwner.id;

        }else{
      post.ParentId = randSdmUser.id;

}
        DateTime newDt = oppo.CloseDate;
        String chatterCloseDate = newDt.format('MMM dd, yyyy');
if (newOwner != null){

        post.Body = 'Dear ' + newOwner.Name + ', this is a notification that HPFS Engagement has been triggered by '+ currentUser.Email + '.' +
                    ' Please engage on this opportunity as soon as possible.' + 
                    '\n\n Account Name: ' + oppo.Account.Name + 
                    '\n Opportunity Name: ' + oppo.Name +
                    '\n Total Opportunity Value: ' + totalOppValue + 
                    '\n Close Date: ' + chatterCloseDate +
                    '\n Opportunity ID: ' + hpOppId;
}

else{

post.Body = 'Dear ' + randSdmUser.Name + ', this is a notification that HPFS Engagement has been triggered by '+ currentUser.Email + '.' +
                    ' Please engage on this opportunity as soon as possible.' + 
                    '\n\n Account Name: ' + oppo.Account.Name + 
                    '\n Opportunity Name: ' + oppo.Name +
                    '\n Total Opportunity Value: ' + totalOppValue + 
                    '\n Close Date: ' + chatterCloseDate +
                    '\n Opportunity ID: ' + hpOppId;


}

        //post.Title = hpOppId;
        post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+ '/'+opp2.Id;
        //remember to uncomment
        insert post;
        return 'HPFS has been engaged.';
        }
        catch (exception ex){
            Database.rollback(sp1);
            
            String theError = ex.getMessage();
            
            if(theError.contains('pricebook entry is inactive')){
                return 'You cannot engage HPFS with inactive Products/Services. Please update the opportunity with valid Products/Services before engaging HPFS again.';
            }
            
            String errorString ='There was an error with engaging HPFS on this opportunity. Please review and correct the error where possible. \n\n'
            +'If the error cannot be resolved, please submit a case with following message for assistance: \n\n'
            +'*****\n';
            return String.valueof(errorString + ex.GetTypeName()+ ' ' + ex.getLineNumber() + '\n' + theError + '\n\n *****');
        }

    }
    
    //returns a random sdm from original opportunity owner's region
    private static User getRandSdm(String region){
            if (region == '' || region == null){
                         region = 'AMS';
                         }
            List<Product_Specialty__c> sdm = new List<Product_Specialty__c>([Select Id from Product_Specialty__c where Name = 'HPFS SDM']);
            Id sdm_select = sdm[0].Id;
            List<User> userlist = new List<User>([select Id,Name from User where Region__c = :region and Id in (select User__c from Product_Specialty_User_Assignment__c where Product_Specialty__c = :sdm_select)]);
            
      User sdmuser;
            
            if ( userlist.size() > 0 ){
                    sdmuser = userlist [0];
                }
            else if ( userlist.size()>1 ){
                    sdmuser = userlist[0];
                }
            return sdmuser;
        }
    
    
    //returns team member based on role, takes account team role and account id
    private static User getAccUser(String role, Id accid, String oppId){
        List<Id> atmIdList = new List<Id>();
        for (AccountTeamMember atm : [Select UserId from AccountTeamMember where AccountId = :accid]){
            Id newId = atm.UserId;
            atmIdList.add(newId);
            }
        List<User> atmUserList = [Select Id, Name, Proudct_speciality__c from User where Proudct_speciality__c = :role and Id in :atmIdList];
        if (atmUserList.size() == 1 ){
                System.debug( role +' found on account team for opportunity: ' + oppId);
                return atmUserList[0];
                
                }
        else if (atmUserList.size() > 1){
                    System.debug('More than 1 '+role+' on account team, sending to SDM');
                    List<Id> terrIdList = new List<Id>();
                    for (Sales_Territory_User_Assignment__c terrUser : [SELECT User__c FROM Sales_Territory_User_Assignment__c where IsActive__c = true and Sales_Territory__c in (select Sales_Territory__c from Sales_Territory_Account_Assignment__c where Account__c = :accId)])
                        {
                            Id newId = terrUser.User__c;
                            terrIdList.add(newId);
                            }
                    List<User> terrUserList = [Select Id, Name, Proudct_speciality__c from User where Proudct_speciality__c = 'HPFS SDM' and Id in :terrIdList];                    
                    if (terrUserList.size() == 1){
                                System.debug( 'HPFS SDM found on account territory for opportunity: ' + oppId);
                                return terrUserList[0];
                                }
                    else {
                        return null;                    
                    }
                }
        else{
                List<Id> terrIdList = new List<Id>();
                for (Sales_Territory_User_Assignment__c terrUser : [SELECT User__c FROM Sales_Territory_User_Assignment__c where IsActive__c = true and Sales_Territory__c in (select Sales_Territory__c from Sales_Territory_Account_Assignment__c where Account__c = :accId)])
                    {
                        Id newId = terrUser.User__c;
                        terrIdList.add(newId);
                        }
                List<User> terrUserList = [Select Id, Name, Proudct_speciality__c from User where Proudct_speciality__c = :role and Id in :terrIdList];
                if (terrUserList.size() == 1){
                        System.debug( role +' found on an account territory for opportunity: ' + oppId);
                        return terrUserList[0];
                    }
                else {
                        terrUserList = [Select Id, Name, Proudct_speciality__c from User where Proudct_speciality__c = 'HPFS SDM' and Id in :terrIdList];
                        if (terrUserList.size() == 1){
                                System.debug( 'HPFS SDM found on account territory for opportunity: ' + oppId);
                                return terrUserList[0];
                            }
                        else{
                                return null;
                            }
                    }
                }
    }
    

    
    // Returns a dynamic SOQL statement for the whole object
    // includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            if (objectName == 'OpportunityLineItem') {
                selectFields.add('HasSchedule');
            }
            if (objectName == 'Opportunity') {
            boolean hpfsNeeded = false;
            boolean privateField = false;
                for (string fields : selectFields){
                    if(fields.equalsIgnoreCase('HPFS_Needed__c')) hpfsNeeded = true;
                    if(fields.equalsIgnoreCase('Confidential__c')) privateFIeld = true;
                }
                if (!hpfsneeded)selectFields.add('HPFS_Needed__c');
                  if (!privateField)selectFields.add('Confidential__c');
            }
            for (string s:selectFields){
                selects += s + ',';
            }
            
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
    //returns formatted currency
    public static String currency(String i) {
        String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
        return s.substring(0,s.length()-1);
    }
    
    //returns a random Integer
    public static Integer getRandomNumber(Integer size){
        Double d = math.random() * size;
        return d.intValue();
    }
    
}