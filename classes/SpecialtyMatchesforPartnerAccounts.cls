/**
 * Class Name: SpecialtyMatchesforPartnerAccounts 
 * Author: Sunder/Raghvendra
 * Date: 01-Oct-2013
 * CR : 1242
 * Description: This custom controller contains the logic to fetch Specialty Opportunity Matches relevent for Partner Accounts/Locations
 */

public with sharing class SpecialtyMatchesforPartnerAccounts {

    List<Location__c> selectedLocations = new List<Location__c>();
    public integer counter=0;  
    public integer list_size=200; 
    public integer total_size=0;  
    public String activeUser{get;set;} 
    public Map<Id, Opportunity> convetOptyAmount; 

    public List<SpecialtymatchwithPartner> displaySOMRecords{
        get{
            integer loopLimit=0;
            if(counter!=0){
                populateSpeOpptyfromLocLookup();
            } 
            displaySOMRecords= new List<SpecialtymatchwithPartner>();        
            if(prodoppmatchwithaccnt!= null && prodoppmatchwithaccnt.size()>0){
                if((prodoppmatchwithaccnt.size()<list_size) || ((prodoppmatchwithaccnt.size()-counter)<list_size)){
                    loopLimit = prodoppmatchwithaccnt.size();
                }
                else{                    
                    loopLimit = counter+list_size;                    
                }
                for(integer i=counter;i<loopLimit;i++){
                    displaySOMRecords.add(prodoppmatchwithaccnt[i]);
                } 
            }
            return displaySOMRecords;
       }
       set;
    }
    
    public class SpecialtymatchwithPartner {
        public Product_Specialty_Oppty_Assignment__c prodsplmatch{get; set;}
        public Channel_Partner__c partnerData{get; set;}
        public Set<String> productName{get; set;}
        public Location__c locationObj{get; set;}
        public Opportunity opptyAmount{get; set;}

        public SpecialtymatchwithPartner(Product_Specialty_Oppty_Assignment__c psoa, Channel_Partner__c accName, Set<String> prodSet, Location__c locObj, Opportunity opptyObj){
            System.debug('accname  '+accName);
            prodsplmatch = psoa;
            partnerData = accName;
            productName = prodSet;
            locationObj=locObj;
            opptyAmount=opptyObj;
        }
    }        
    public class SearchCheckedAccounts {
        public Boolean checkedVal{get; set;}
        public Account accrec{get; set;}
        public Location__c locrec{get; set;}
        public Boolean check{get; set;}
        
        public SearchCheckedAccounts(Account accVal){
            checkedVal = false;
            accrec = accVal;
        }
        public SearchCheckedAccounts(Location__c locVal){
            checkedVal = false;
            locrec = locVal;
        }
    }    
    
    transient public List<SpecialtymatchwithPartner> prodoppmatchwithaccnt;
    //transient public List<SpecialtymatchwithPartner> prodoppmatchwithaccnt{get; set;};
    transient public List<Product_Specialty_Oppty_Assignment__c> prodoppmatch{get; set;}
    public List<SelectOption> chanelAllianceParterAccountsList{get; set;}
    public String selectedAccountId{get; set;}
    public String accNameStringVal{get;set;}
    public String locIdStringVal{get;set;}
    public String accIdStringVal{get;set;}
    public Channel_Partner__c lookupVal = new Channel_Partner__c();
    //deb
    public Channel_Partner__c lookupValList = new Channel_Partner__c();
    //Nazeer: Added for Location lookup    
    public Channel_Partner__c lookupLocNew = new Channel_Partner__c();
    public Map<Id,Set<Id>> partnerAccOppSet;
    public Map<Id,Set<Channel_Partner__c>> partnerAccMap;
    public String searchByKeyWord{get;set;}
    public String searchString{get;set;} // search keyword
    //public List<Account> results{get;set;} // search results
    public List<SearchCheckedAccounts> results{get;set;} // search results
    //public List<Location__c> locResults{get;set;} // search results
    public List<SearchCheckedAccounts> locResults{get;set;} // search results
    public Integer numberofrows{get; set;} // shows number of rows
    public Id userId;

    public Channel_Partner__c getlookupVal() {

        return lookupVal;
    }

    public void setlookupVal(Channel_Partner__c lookup) {
        this.lookupVal = lookup;
    }
    //Nazeer: Added for Location lookup    
    public Channel_Partner__c getlookupLocNew() {

        return lookupLocNew;
    }

    public void setlookupLocNew(Channel_Partner__c lookup) {
        this.lookupLocNew = lookup;
    }
    public SpecialtyMatchesforPartnerAccounts(){
        userId = UserInfo.getUserId();
        searchByKeyWord = 'LocatorID';
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        system.debug('search string '+searchString);
        runSearch();
    }
    

    public SpecialtyMatchesforPartnerAccounts(ApexPages.StandardController controller) {
        Set<Id> salesterrIdSet = new Set<Id>();
        numberofrows = 0;
        //prodoppmatch = new List<Product_Specialty_Oppty_Assignment__c>();
        prodoppmatchwithaccnt = new List<SpecialtymatchwithPartner>();
        Map<Id,Product_Specialty_Oppty_Assignment__c> opptySplMatchMap = new Map<Id,Product_Specialty_Oppty_Assignment__c>();
        userId = UserInfo.getUserId();
        activeUser = UserInfo.getDefaultCurrency();
        //populatePartnerAccounts();
    }
    
    /*
     * @Description: This method is used to fetch all the opportunities based on selected location.
     * 
     */
    public void populateSpeOpptyfromLocLookup(){
        if(locIdStringVal == null || locIdStringVal.length() ==0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select locations from lookup.'));
            return;
        }
        List<Id> locIdList = locIdStringVal.split(',');
        Id userId = UserInfo.getUserId();       
        Map<Id,Product_Specialty_Oppty_Assignment__c> opptyProdSpltyMap = new Map<Id,Product_Specialty_Oppty_Assignment__c>();
        Map<Id,Channel_Partner__c> oppCAPartnerMap = new Map<Id,Channel_Partner__c>();
        Map<Id,Set<String>> opptyProdSetMap = new Map<Id,Set<String>>();
        Set<String> prodLineSet = new Set<String>();
        Set<String> subProdLineSet = new Set<String>();
        Map<Id,Id> userSpltyMap = new Map<Id,Id>();
        prodoppmatchwithaccnt = new List<SpecialtymatchwithPartner>();
        List<id> allOpptyList=new List<id>();
        List<Location__c> allLocList=new List<Location__c>();
        Map<Id, Location__c> optyLocMap= new Map<id, Location__c>();
        Set<Id> optyAmountId = new Set<Id>();
        
        try{
            if(locIdList == null || locIdList.size() == 0){
                return;
            }
            for(Channel_Partner__c cprecs : [Select Opportunity__c, Location__c,Channel_Partner__r.Name, Channel_Partner__c, Partner_Type__c from Channel_Partner__c where Location__c IN : locIdList]){ 
                oppCAPartnerMap.put(cprecs.Opportunity__c,cprecs);
            } 
            //End of Filtering opportunities based on location        
            if(oppCAPartnerMap != null && oppCAPartnerMap.size() > 0){
                //total_size = [select count() from Product_Specialty_Oppty_Assignment__c where Product_Specialty_User_Assignment__r.User__c = :userId AND Opportunity__c In : oppCAPartnerMap.keySet()];
                //for(Product_Specialty_Oppty_Assignment__c psoarec :  [Select HP_Opportunity_Id__c,Opportunity__c,Opportunity__r.Amount, Opportunity__r.CurrencyIsoCode, Opportunity__r.Value__c, Opportunity_Amount__c, Opportunity__r.Account.Name, Stage__c,Product_Specialty_User_Assignment__r.Product_Specialty__c from Product_Specialty_Oppty_Assignment__c where Product_Specialty_User_Assignment__r.User__c = :userId AND Opportunity__c In : oppCAPartnerMap.keySet()]){
                for(Product_Specialty_Oppty_Assignment__c psoarec : [Select HP_Opportunity_Id__c,Opportunity__c,Opportunity__r.Amount, Opportunity__r.CurrencyIsoCode, convertCurrency(Opportunity__r.value__c), Opportunity__r.Account.Name, Stage__c,Product_Specialty_User_Assignment__r.Product_Specialty__c from Product_Specialty_Oppty_Assignment__c where Product_Specialty_User_Assignment__r.User__c = :userId AND Opportunity__c In : oppCAPartnerMap.keySet()]){
                    System.debug('Line 210 psoarec '+psoarec);
                    opptyProdSpltyMap.put(psoarec.Opportunity__c,psoarec);
                    userSpltyMap.put(userId,psoarec.Product_Specialty_User_Assignment__r.Product_Specialty__c);
                    /*if (activeUser != psoarec.Opportunity__r.CurrencyIsoCode){*/
                        optyAmountId.add(psoarec.Opportunity__c);
                    /*}*/
                }
                total_size=opptyProdSpltyMap.size();
                if(optyAmountId != null && optyAmountId.size()>0){
                    convetOptyAmount = new Map<Id, Opportunity>([Select Id,  CurrencyIsoCode, ConvertCurrency(Amount) from Opportunity where id =: optyAmountId]);
                }
            }
            System.debug('Line 214 opptyProdSpltyMap '+opptyProdSpltyMap);
            for(Product_Specialty_Definition__c psdrec : [Select Id,Product__r.Sub_Product_Line__c,Product__r.Product_Line__c from Product_Specialty_Definition__c where Product_Specialty__c = :userSpltyMap.get(userId)]){
                if(psdrec.Product__r.Sub_Product_Line__c != null && !('').equalsIgnoreCase(psdrec.Product__r.Sub_Product_Line__c)){
                    subProdLineSet.add(psdrec.Product__r.Sub_Product_Line__c);
                }
                if(psdrec.Product__r.Product_Line__c != null && !('').equalsIgnoreCase(psdrec.Product__r.Product_Line__c)){
                    prodLineSet.add(psdrec.Product__r.Product_Line__c);
                }
            }        
            for(OpportunityLineItem oppLinerecs : [Select OpportunityId,Product__c,ProductName__c FROM OpportunityLineItem where OpportunityId IN : opptyProdSpltyMap.keySet() AND (PricebookEntry.Product2.Product_Line__c IN : prodLineSet OR PricebookEntry.Product2.Sub_Product_Line__c IN : subProdLineSet)]){
                Set<String> prodSet = opptyProdSetMap.get(oppLinerecs.OpportunityId);
                if(prodSet == null){
                    prodSet = new Set<String>();
                }
                prodSet.add(oppLinerecs.ProductName__c);
                opptyProdSetMap.put(oppLinerecs.OpportunityId,prodSet);
            }
    
            //List<Location__c> locDetailsList=[Select Name, Id, Account__c,Location_Name__c, Country__c, City__c, State__c, Business_Relationship__c From Location__c  where Id IN:locIdList];
            Map<id, Location__c> locIdMap=new Map<id, Location__c>([Select Id, Name, Account__c,Location_Name__c, Country__c, City__c, State__c, Business_Relationship__c From Location__c where Id IN:locIdList]);
            //integer loopCount=0;
            for(Id oppId : opptyProdSpltyMap.keySet()){                
                allOpptyList.add(oppId);
                Id acpLocId= oppCAPartnerMap.get(oppId).Location__c;
                if(locIdMap.containsKey(acpLocId)){
                    optyLocMap.put(oppId, locIdMap.get(acpLocId));
                }
                /*for(Location__c locDetail: locDetailsList){
                    if(locDetail.Id==acpLocId)
                    {
                        optyLocMap.put(oppId, locDetail); 
                    }
                }*/
            }
            for(Id oppId : allOpptyList){
                prodoppmatchwithaccnt.add(new SpecialtymatchwithPartner(opptyProdSpltyMap.get(oppId),oppCAPartnerMap.get(oppId),opptyProdSetMap.get(oppId),optyLocMap.get(oppId),convetOptyAmount.get(oppId)));
            }
    
            if(prodoppmatchwithaccnt.size() > 0){
                numberofrows = prodoppmatchwithaccnt.size();
            }
          }
         catch(Exception ex){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The following exception has occurred:'+ex));
      }
    }

    /**
     * @description: performs the keyword search
     * @return: return null
     * 
     */
    public PageReference search() {
        runSearch();
        return null;
    }
    /**
     * @description: performs the keyword search
     * @return: return null
     * 
     */
    public PageReference searchLoc() {
        //runSearch();
        locResults = new LookupPartnerAccountSearch().performLocationSearch(searchString,userId,searchByKeyWord);
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
        results = new LookupPartnerAccountSearch().performSearch(searchString,userId,searchByKeyWord);                
    }

    /**********************************************************
     * Class Name: LookupPartnerAccountSearch
     * Author: HP
     * Date: 23-Feb-2013 
     * Requirement # Request Id:0474
     * Description: run the search in sharing mode and return the records found.
     ***********************************************************/
    public with sharing class LookupPartnerAccountSearch {
        /*
         * @Description: This method is used to fetch all the locations belonging to the logged in user.
         * 
         */  
         
        private List<SearchCheckedAccounts> performLocationSearch(string searchString,Id uId,String searchByKeyWord) {
            system.debug('search string..  '+searchString);
            List<SearchCheckedAccounts> locToDisplayList=new List<SearchCheckedAccounts>();
            Set<Id> locIdsToDisplaySet=new Set<Id>();  
            Id userId = UserInfo.getUserId();                
            List<Id> salesTerritoriesList=new List<id>();
            List<Id> partnerTerritoriesList=new List<id>();     
            Set<Id> locIdsForBRTerrSet=new Set<Id>();
            Set<Id> locIdsForLocTerrSet=new Set<Id>();             
            //Fetching all territories associated with the looged in user
            for(Sales_Territory_User_Assignment__c salesTerrUserAssign:[Select User__c, Sales_Territory__c, Id From Sales_Territory_User_Assignment__c  where User__c=:userId]){
                salesTerritoriesList.add(salesTerrUserAssign.Sales_Territory__c);
            }
            //Getting only partner territories
            for(Sales_Territory__c salesTerr:[Select IsPartner__c, Id,name From Sales_Territory__c  where ispartner__c=true and isExternal__c=false and id in :salesTerritoriesList]){
                partnerTerritoriesList.add(salesTerr.id);
            }
            
            //Getting all the locations associated with the above partner sales territories
            for(Sales_Territory_Location_Assignment__c salesTerrLoc:[Select Sales_Territory__c, Location__c From Sales_Territory_Location_Assignment__c  where Sales_Territory__c in :partnerTerritoriesList]){
                locIdsToDisplaySet.add(salesTerrLoc.Location__c);
                //locIdsForLocTerrSet.add(salesTerrLoc.Location__c);
            }
            //Getting all the locations associated with the above salesTerritoriesList' partner accounts
            for(Location__c locationObj:[Select Id, Account__c From Location__c where Account__c in(Select Account__c From Sales_Territory_Account_Assignment__c  where Sales_Territory__c in :partnerTerritoriesList)]){
                locIdsToDisplaySet.add(locationObj.Id);
                //locIdsForLocTerrSet.add(locationObj.Id);
                //locIdsForBRTerrSet.add(locationObj.Id);
            }
            if(searchString == null || searchString == ''){
                //locToDisplayList=[Select Id,Location_Name__c, Country__c, City__c, Business_Relationship__c,Name,account__r.Name From Location__c where id in :locIdsToDisplaySet];
                for(Location__c locrec : [Select Id,Location_Name__c, Country__c, City__c,State__c, Business_Relationship__c,Name,account__r.Name From Location__c where id in :locIdsToDisplaySet order by account__r.Name ASC LIMIT 50]){
                    SearchCheckedAccounts searec = new SearchCheckedAccounts(locrec);
                    locToDisplayList.add(searec);
                }
            }else{
                searchString = searchString.replaceAll('\\*','%');
                searchString = searchString.replace('\'','\\\'');
                String soql;
                Set<Id> accSTIdsSet=new Set<Id>();
                Set<Id> locIdsSet=new Set<Id>(); 
                if(searchByKeyWord.equals('Name')){
                    soql = 'Select Id,Name,Location_Name__c, State__c, Country__c, City__c, Business_Relationship__c, account__r.Name From Location__c where id in :locIdsToDisplaySet and account__r.Name LIKE \'' + searchString +'%\''+ ' order by account__r.Name ASC';
                }
                else if(searchByKeyWord.equals('LocatorID')){
                    soql = 'Select Id,Name,Location_Name__c, State__c, Country__c, City__c, Business_Relationship__c, account__r.Name From Location__c where id in :locIdsToDisplaySet and Name LIKE \'' + searchString +'%\'' + ' order by account__r.Name ASC';
                }
                //String soql = 'Select Id,Name,Location_Name__c, Country__c, City__c, Business_Relationship__c, account__r.Name From Location__c where id in :locIdsToDisplaySet'+' and (Location_Name__c LIKE \'' + searchString +'%\''+ ' OR Name LIKE \'' + searchString +'%\''+')';
                System.debug('Query Statement  '+soql);
                //locToDisplayList=database.query(soql);
                for(Location__c locrec : database.query(soql)){
                    SearchCheckedAccounts searec = new SearchCheckedAccounts(locrec);
                    locToDisplayList.add(searec);
                }
            }                 
            return locToDisplayList;
        }
        // run the search and return the records found. 
        private List<SearchCheckedAccounts> performSearch(string searchString,Id uId,String searchByKeyWord) {
            List<Sales_Territory_Account_Assignment__c> returnSTAccList=new List<Sales_Territory_Account_Assignment__c>();
            List<Account> returnAccList=new List<Account>();
            Set<Id> accId = new Set<Id>();
            Set<Id> salesTerrSet = new Set<Id>();
            Id RecordTypeId=null;
            try{
                RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            }catch(Exception ex){
                System.debug('Exception:'+ex.getMessage());
            }

            for(Sales_Territory_User_Assignment__c stua : [Select Sales_Territory__c from Sales_Territory_User_Assignment__c where      User__c = : uId and Sales_Territory__r.IsPartner__c = true]){
                salesTerrSet.add(stua.Sales_Territory__c);
            }

            String soql = 'select Account__c from Sales_Territory_Account_Assignment__c where Sales_Territory__c In: salesTerrSet';

            String whereCondition = '';
            if(searchString != null && searchString != ''){
                searchString = searchString.replaceAll('\\*','%');
                searchString = searchString.replace('\'','\\\'');
                if(searchByKeyWord.equals('Name')){
                    whereCondition = whereCondition +  ' Account__r.name LIKE \'' + searchString +'%\' and';
                }
                else if(searchByKeyWord.equals('Location_ID__c')){
                    whereCondition = whereCondition +  ' Account__r.Location_ID__c LIKE \'' + searchString +'%\' and';
                }

            }            
            if(whereCondition!=null && whereCondition.length()>0 ){
                whereCondition = ' and'+whereCondition.substring(0,whereCondition.length()-4);
            }
            else{
                whereCondition = '';
            }
            soql = soql + whereCondition + ' limit 250';            
            returnSTAccList=database.query(soql);
            for(Sales_Territory_Account_Assignment__c a: returnSTAccList){
                accId.add(a.Account__c);
            }
            String accsoql = 'select id, name, regions__c, type, owner.Alias, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, Location_ID__c, HP_SFDC_Access__c from Account where Id In: accId';
            returnAccList = database.query(accsoql);
            //New Code for Requirement #1504: Enable ISRs to view Partner Accounts that have active Partner Users in SFDC

            set<String> PartnersListIDs=new set<String>();
            List<User> PartnerUsersList=new List<User>();
            Map<id,List<User>> partnerUsersMap=new Map<id,List<User>>();
            List<SearchCheckedAccounts> accToDisplay=new List<SearchCheckedAccounts>();
            for(Account a: returnAccList){                
                String str=convertTo15Digit(a.id);                
                partnersListIDs.add(str);

            }

            partnerUsersList=[select id,name,isActive,Partner_account_ID__c from User where Partner_account_ID__c= :PartnersListIDs];
            for(Account a: returnAccList){
                List<User> ulist=new List<User>();
                for(User u: partnerUsersList){
                    if(u.Partner_account_ID__c == convertTo15Digit(a.id))
                        ulist.add(u);
                }   
                partnerUsersMap.put(a.id,ulist);
            }
            for(Account a: returnAccList){                
                List<User> userslist=new List<User>();
                Boolean isUserActive=false;
                userslist=partnerUsersMap.get(a.id);                
                if(userslist.size()>0){
                    for(User u: usersList){
                        if(u.isActive==true){                            
                            isUserActive=true;
                        }
                    }
                }   

                if(isUserActive==true)
                    a.HP_SFDC_Access__c='Yes';
                else a.HP_SFDC_Access__c='No';

                SearchCheckedAccounts searec = new SearchCheckedAccounts(a);
                accToDisplay.add(searec);

            }
            return accToDisplay;
        }

        /*private Map<Id,Account> getAccountRegions(Set<Id> accIdSet){
            Id RecordTypeId=null;
            try{
                RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
            }catch(Exception ex){
                System.debug('Exception:'+ex.getMessage());
            }
            Map<Id,Account> searchedAccList = new Map<Id,Account>([Select id,regions__c,Channel_Partner_Flag__c,Alliance_Partner_Flag__c from Account where id IN:accIdSet]);
            return searchedAccList;
        }*/
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
    //Raghv:Start
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      //populateSpeOpptyfromLocLookup();
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
       if (Test.isRunningTest()){
           list_size=1;
           counter=2;
       }
      counter -= list_size;
      //populateSpeOpptyfromLocLookup();
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
      //populateSpeOpptyfromLocLookup();
      return null;
   }
 
   public PageReference End() { //user clicked end
       if (Test.isRunningTest()){
           total_size = 1;
           list_size=1;
       }
      if(math.mod(total_size, list_size) !=0)
      {
          counter = total_size - math.mod(total_size, list_size);
          //populateSpeOpptyfromLocLookup();
      }
      else
      {
          counter = total_size - list_size;
          //populateSpeOpptyfromLocLookup();
       }
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
   System.debug('next button ' +(counter + list_size));
   System.debug('Total_size ' +(total_size));
   
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   public Integer getListSize() {
      return list_size;
   }
 
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
    //Raghv:End
}