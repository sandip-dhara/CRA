/**********************************************************
* Class Name: ChannelPartnerController
* Author: Accenture
* Date: 20-March-2012 
* Requirement # Request Id:
* Description: Controller class for Alliance and Channel Partners Add VF page
***********************************************************/
public class ChannelPartnerController {
    public Account account {get;set;} // new account to create
    public List<Location__c> results{get;set;} // search results
    public String searchString{get;set;} // search keyword
    public String partnerTypeString {get;set;} // partnerType keyword
    private String userRegion;
    public List<channelPartnerClass> channelPartnerList{get;set;}
    public Channel_Partner__c channelPartnerRecord {get;set;}
    private Map<Id,String> addedPartnerMap;
    private List<Channel_Partner__c> addedPartnerList;
    //public String searchByKeyWord{get;set;}
    public Boolean hasEditAccess {get;set;}
    private Map<Id,String> addedLocationMap;
   
    
    public Id oppID {get;set;}
    public String retUrl {get;set;}
    
    /**
    * @description: Class Constructor method
    * 
    * 
    */ 
    public ChannelPartnerController () {
        //searchByKeyWord = 'Name';
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        partnerTypeString = System.currentPageReference().getParameters().get('partnerType');
        user currentUser = [Select id,Region__c from User where id =: UserInfo.getUserId()];
        if(currentUser!=null){
            userRegion = currentUser.Region__c;
        }
        runSearch();  
    }
       
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    * 
    */
    public ChannelPartnerController (ApexPages.StandardController stdController) {
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        channelPartnerList = new List<channelPartnerClass>();
        List<Id> accid = new List<Id>();
        this.channelPartnerRecord = (Channel_Partner__c)stdController.getRecord();
        System.debug('#############:'+channelPartnerRecord);
        if(channelPartnerRecord==null || channelPartnerRecord.Opportunity__c==null){
            channelPartnerRecord = new Channel_Partner__c();
            oppID = ApexPages.currentPage().getParameters().get('oppId');
            
            if(oppID ==null){
                    
                String retID =null;
                if(retURL!=null){
                    retID = retURL.replaceAll('/','');
                }
                channelPartnerRecord.Opportunity__c = retID;
            }else{
                channelPartnerRecord.Opportunity__c = oppID;
            }
        }
        addedPartnerList = [select id,Partner_Account_Role2__c,Opportunity__c,Channel_Partner__c,Channel_Partner__r.Name,Channel_Partner__r.MDCP_Business_Relationship__c,Location__c,Location__r.Name,Partner_Type__c,Primary__c from Channel_Partner__c where Opportunity__c=:channelPartnerRecord.Opportunity__c];    
        addedPartnerMap = new Map<Id,String>();
        addedLocationMap = new Map<Id,String>();
        for(Channel_Partner__c addedPartner : addedPartnerList){
             addedLocationMap.put(addedPartner.Location__c,addedPartner.Location__r.Name);
             addedPartnerMap.put(addedPartner.Location__c,addedPartner.Channel_Partner__r.Name);
        }
        for(Integer i=0;i<5;i++){
            channelPartnerList.add(new channelPartnerClass(channelPartnerRecord.Opportunity__c,null,null,null));
        }
    }

    
    /**
    * @description: Checks if logged in user has edit access on current opportunity record
    * 
    */
    /* public void checkOptyEditAccess() {
        hasEditAccess = true;
        if (oppID != null) {
                String editAccessResult = CheckOptyAccess.checkOptyEditAccess(oppID);
                if (editAccessResult != Label.SUCCESS) {
                        hasEditAccess = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Insufficient_Privileges));
                }
        }
    } */

    /**
    * @description: performs the keyword search
    * @return: return null;
    * 
    */
    public PageReference search() {
        runSearch();
        return null;
    }
    
    
    public Static String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        }
        return paramID;
    }

    /**
    * @description: prepare the query and issue the search command
    * 
    * 
    */
    private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    //results = new LookupAccountSearch().performSearch(searchString,partnerTypeString,userRegion,searchByKeyWord);   
    results = new LookupAccountSearch().performSearch(string.escapesinglequotes(searchString),partnerTypeString,userRegion);               
    }
    
    /**********************************************************
    * Class Name: LookupAccountSearch
    * Author: Accenture
    * Date: 20-March-2012 
    * Requirement # Request Id:
    * Description: run the search in sharing mode and return the records found.
    ***********************************************************/
    public  with sharing class LookupAccountSearch {
        // run the search and return the records found. 
        //private List<Account> performSearch(string searchString,String partnerTypeString,String userRegion,String searchByKeyWord) {
        private List<Location__c> performSearch(string searchString,String partnerTypeString,String userRegion) {
            List<Location__c> returnLocList=new List<Location__c>();
            Id RecordTypeId=null;
            try{
                RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            }catch(Exception ex){
                System.debug('Exception:'+ex.getMessage());
            }
            String soql = 'select id,Account__r.id,Location_Name__c, Account__r.name,Account__r.Alternate_Name__c,Business_Relationship__c,name,Street__c,Account__r.regions__c,Account__r.type,Account__r.owner.Alias,Account__r.Location_ID__c,City__c,state__c,Country__c,Account__r.HP_SFDC_Access__c,Account__r.MDCP_Business_Relationship__c from Location__c';
            String whereCondition = '';
            
            if(partnerTypeString!=null && !partnerTypeString.equalsIgnoreCase('')){
            if(userRegion != null && userRegion != ''){
                    if(partnerTypeString.equalsIgnoreCase(Label.Channel_Partner)){
                        whereCondition = whereCondition + ' Account__r.RecordTypeId = \''+RecordTypeId+'\' and Account__r.Channel_Partner_Flag__c = true and Account__r.regions__c includes  (\''+userRegion+'\') and Account__r.Active_Flag__c =true  ';
                    }
                    if(partnerTypeString.equalsIgnoreCase(Label.Alliance_Partner)){
                        whereCondition = whereCondition + ' Account__r.RecordTypeId = \''+RecordTypeId+'\' and Account__r.Alliance_Partner_Flag__c = true and Account__r.regions__c includes  (\''+userRegion+'\') and Account__r.Active_Flag__c =true  ';
                    }
                }
                else{
                    if(partnerTypeString.equalsIgnoreCase(Label.Channel_Partner)){
                        whereCondition = whereCondition + ' Account__r.RecordTypeId = \''+RecordTypeId+'\' and Account__r.Channel_Partner_Flag__c = true and  Account__r.Active_Flag__c =true ';
                    }
                    if(partnerTypeString.equalsIgnoreCase(Label.Alliance_Partner)){
                        whereCondition = whereCondition + ' Account__r.RecordTypeId = \''+RecordTypeId+'\' and Account__r.Alliance_Partner_Flag__c = true and  Account__r.Active_Flag__c =true ';
                    }
                }
            }
            
            if(searchString != null && searchString != ''){
                searchString = searchString.replaceAll('\\*','%');
                whereCondition = whereCondition +  ' AND ( name LIKE \'' + searchString +'%\' or Account__r.name LIKE \'' + searchString +'%\' or City__c LIKE \'' + searchString +'%\' or country__c LIKE \'' + searchString +'%\' or Account__r.Alternate_Name__c LIKE \'' + searchString +'%\' )';
                /*if(searchByKeyWord.equals('Name')){
                    whereCondition = whereCondition +  '  name LIKE \'' + searchString +'%\' and';
                }
                else if(searchByKeyWord.equals('Location_ID__c')){
                    whereCondition = whereCondition +  ' Location_ID__c LIKE \'' + searchString +'%\' and';
                }*/
                
            }
            if(whereCondition!=null && whereCondition.length()>0 ){
                //whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
                whereCondition = ' where '+whereCondition;
            }
            else{
                whereCondition = '';
            }
            soql = soql + whereCondition + ' limit 250';
            System.debug('query>>>'+soql);
            returnLocList=database.query(soql); 
            //New Code for Requirement #1504: Enable ISRs to view Partner Accounts that have active Partner Users in SFDC

            set<ID> LocationListIDs=new set<ID>();
            List<User> locationUsersList=new List<User>();
            Map<id,List<User>> locationUsersMap=new Map<id,List<User>>();
            List<Location__c> locToDisplay=new List<Location__c>();
            for(Location__c a: returnLocList){
                LocationListIDs.add(a.id);
            
            }
            
                        
            locationUsersList=[select id,name,isActive,Location_Record_Id__c from User where Location_Record_Id__c= :LocationListIDs];
            for(Location__c a: returnLocList){
                List<User> ulist=new List<User>();
                for(User u: locationUsersList){
                    
                    if(u.Location_Record_Id__c == a.id)
                    ulist.add(u);
                }   
                locationUsersMap.put(a.id,ulist);
            }
            for(Location__c a: returnLocList){
                
                List<User> userslist=new List<User>();
                Boolean isUserActive=false;
                userslist=locationUsersMap.get(a.id);
                
                if(userslist.size()>0){
                    for(User u: usersList){
                        if(u.isActive==true){
                            System.debug('user  '+u.name+' is '+ u.isActive);
                            isUserActive=true;
                        }
                    }
                }   
                
                if(isUserActive==true)
                a.HP_SFDC_Access__c='Yes';
                else a.HP_SFDC_Access__c='No';
                
                locToDisplay.add(a);
            
            }
            return locToDisplay;
        }
        
        private Map<Id,Account> getAccountRegions(Set<Id> accIdSet){
            Id RecordTypeId=null;
            try{
                RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            }catch(Exception ex){
                System.debug('Exception:'+ex.getMessage());
            }
            Map<Id,Account> searchedAccList = new Map<Id,Account>([Select id,regions__c,Channel_Partner_Flag__c,Alliance_Partner_Flag__c from Account where id IN:accIdSet]);
            return searchedAccList;
        }
    }

    /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    * 
    */
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
    }

    /**
    * @description: used by the visualforce page to send the link to the right dom element for the text box
    * @return: String returns url lknm paramter value
    * 
    */
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    }
    
    /**
    * @description return flag is Search Result Empty or not
    * @return: boolean True if list is empty
    * 
    */
    public Boolean getIsResultEmpty(){
        Boolean returnBoolean = false;
        if(results==null || results.size()<1){
            returnBoolean=true;
        }
        return returnBoolean;
            
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        Boolean isPrimaryChecked = false;
        List<Channel_Partner__c> cpList = new List<Channel_Partner__c>();
        Set<Id> checkDuplicatePartner = new set<id>();
        Set<Id> checkDuplicateLocation = new set<id>();
        
        System.debug('checkPartner' + channelPartnerList);
        for(channelPartnerClass cpr : channelPartnerList){
            if(cpr.channelPartner.Channel_Partner__c!=null && string.valueof(cpr.channelPartner.Channel_Partner__c).length()>1 ){
            system.debug('pppppp'+cpr.channelPartner.Channel_Partner__c);
            system.debug('>>>>>cpr.channelPartner.primary__c'+cpr.channelPartner.Primary__c);
                
                if(cpr.channelPartner.Partner_Type__c==null){
                    cpr.channelPartner.Partner_Type__c.addError(Label.You_must_enter_a_value);
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.You_must_enter_a_value));
                    return null;
                }
                /*if(addedPartnerMap.containsKey(cpr.channelPartner.Channel_Partner__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,addedPartnerMap.get(cpr.channelPartner.Channel_Partner__c)+' '+Label.Partner_already_exist));
                    return null;
                }*/
                        
                if(addedLocationMap.containsKey(cpr.channelPartner.Location__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,addedLocationMap.get(cpr.channelPartner.Location__c)+' '+Label.Location_already_exist));
                    return null;
                }
                if(cpr.channelPartner.primary__c==true){
                    isPrimaryChecked = true;
                }
                system.debug('>>>>>cpr.channelPartner.primary__c'+cpr.channelPartner.Primary__c);
                if(checkDuplicateLocation.contains(cpr.channelPartner.Location__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Location_already_exist));
                    return null;
                }else{
                    checkDuplicateLocation.add(cpr.channelPartner.Location__c);
                }
                checkDuplicatePartner.add(cpr.channelPartner.Channel_Partner__c);
                system.debug('>>>>>cpr.channelPartner.primary__c'+cpr.channelPartner.Primary__c);
                //if(cpr.PartnerRole != null)
                    //cpr.channelPartner.Business_Relationship__c = cpr.PartnerRole;
                cpList.add(cpr.channelPartner);
                }
            }
        
        system.debug('>>>>>cpList' + cpList);
        if(cpList!=null || cpList.size()>0){
            Map<Id,Account> accRegionsMap = new LookupAccountSearch().getAccountRegions(checkDuplicatePartner);
            for(Channel_Partner__c cp : cpList){
                if(cp.Primary__c == null){
                system.debug('>>>Inside Patch loop');
                    cp.Primary__c = false;    
                }
                if(accRegionsMap.get(cp.Channel_Partner__c)==null){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Not_match_filter_criteria));
                    return null;
                }else{
                    if(cp.Partner_Type__c!=null && cp.Partner_Type__c.equalsIgnoreCase(Label.Alliance_Partner)){
                        if(accRegionsMap.get(cp.Channel_Partner__c).Alliance_Partner_Flag__c != true){
                            cp.Channel_Partner__c.addError(Label.Not_match_filter_criteria);
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Not_match_filter_criteria));
                            return null;
                        }
                    }
                    if(cp.Partner_Type__c!=null && cp.Partner_Type__c.equalsIgnoreCase(Label.Channel_Partner)){
                        if(accRegionsMap.get(cp.Channel_Partner__c).Channel_Partner_Flag__c != true){
                            cp.Channel_Partner__c.addError(Label.Not_match_filter_criteria);
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Not_match_filter_criteria));
                            return null;
                        }
                    }                       
                }
                
            }
            try{
                insert cpList;
            }catch(DmlException dmlEx){
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Channel_Partner__c', 'ChannelPartnerController', '');
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
            catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Channel_Partner__c', 'ChannelPartnerController', '');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        //String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference Cancel(){
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description used as wrapper class for storing data of each line
    * 
    * @author Accenture
    */
    public class channelPartnerClass{
        public Channel_Partner__c channelPartner{get;set;}
        Public String PartnerName{get;set;}
        public String locatorname{set;get;}
        public String PartnerRole{get;set;}
        public channelPartnerClass(id optyId,String locname, String PName ,String PRole){
            locatorname=locname;
            PartnerName=PName;
            PartnerRole = PRole;
            this.channelPartner = new Channel_Partner__c();
            this.channelPartner.Opportunity__c = optyId;
        }
    }
}