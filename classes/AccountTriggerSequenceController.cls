/**********************************************************
* Class Name: AccountTriggerSequenceController
* Author: Accenture
* Date: 19-JUL-2012  
* Requirement # Request Id: 
* Description: This class has methods called from Trigger.
               They make call to other business logic methods.  
***********************************************************/
public class AccountTriggerSequenceController {
    
    /**
    * @description: This method is called from before insert trigger
    *               It calls method to update flag on Account.
    * @param: List of new Account
    * TM: Debmalya: Req:3293 Oct 2,2012:Adding Return type for Error Handling
    **/
    public static void beforeInsert(List<Account> accounts) {
        // TM: Debmalya: Req-3293 Sep 27, 2012:Populate World Region based on Shipping Country- Start
        Set<String> countryName = new Set<String>();
        List<Account> acctoUpdate = new List<Account>();
        for(Account acc: accounts){
            if(acc.ShippingCountry != null){
                countryName.add(acc.ShippingCountry);
            }
        }
        Map<String,World_Region__c> mapNameRegion = new Map<String,World_Region__c>();
        mapNameRegion = mapWorldRegion(countryName);
        updateWorldRegionId(accounts,mapNameRegion);
        // TM: Debmalya: Req-3293 Sep 27, 2012:Populate World Region based on Shipping Country- End
        upadateFlag(accounts);
        
    }
    

    /**
    * @description: This method is called from before update trigger
    *               It identifies Accounts for which concerned fields are
                    modified during update & send them to updateFlag method. 
    * @param: map of new Account & old Account
    * TM: Debmalya: Req:3293 Oct 2,2012:Adding Return type for Error Handling
    **/
    public static void beforeUpdate(Map<Id, Account> accountNewMap, Map<Id, Account> accountOldMap) {
        List<Account> accounts = new List<Account>();  
        
        Set<Id> accountIds = new Set<Id>();
        // TM: Debmalya: Req-3293 Sep 27, 2012:set of account id- Start
        Set<String> countryName = new Set<String>();
        List<Account> acctoUpdate = new List<Account>();
        // TM: Debmalya: Req-3293 Sep 27, 2012:set of account id- End
        if (accountNewMap != null && accountOldMap != null) {
            
            for (Id accountId: accountNewMap.keySet()) {
                if (accountOldMap.get(accountId).MDCP_Organization_ID__c != accountNewMap.get(accountId).MDCP_Organization_ID__c ||
                   //add based on the request 13492
                    accountOldMap.get(accountId).MDCP_Subscribed_Flag__c != accountNewMap.get(accountId).MDCP_Subscribed_Flag__c ||
                    accountOldMap.get(accountId).Source_System_Account_ID__c != accountNewMap.get(accountId).Source_System_Account_ID__c ||
                    accountOldMap.get(accountId).AMID_L2__c != accountNewMap.get(accountId).AMID_L2__c ||
                    accountOldMap.get(accountId).ShippingState != accountNewMap.get(accountId).ShippingState ||
                    accountOldMap.get(accountId).Confidential_Account__c != accountNewMap.get(accountId).Confidential_Account__c ||
                    accountOldMap.get(accountId).ShippingPostalCode != accountNewMap.get(accountId).ShippingPostalCode ||
                    accountOldMap.get(accountId).ShippingCountry != accountNewMap.get(accountId).ShippingCountry ||
                    accountOldMap.get(accountId).Named_Account__c != accountNewMap.get(accountId).Named_Account__c ||
                    accountOldMap.get(accountId).Industry_Vertical__c != accountNewMap.get(accountId).Industry_Vertical__c ||
                    accountOldMap.get(accountId).Coverage_Segmentation__c != accountNewMap.get(accountId).Coverage_Segmentation__c ||
                    //accountOldMap.get(accountId).World_Region__c != accountNewMap.get(accountId).World_Region__c ||
                    (accountOldMap.get(accountId).World_Region1__c != accountNewMap.get(accountId).World_Region1__c && accountOldMap.get(accountId).World_Region1__c != null) ||
                    accountOldMap.get(accountId).RAD__c != accountNewMap.get(accountId).RAD__c ||
//Sreenath                  
                  accountOldMap.get(accountId).MDCP_Subscribed_Flag__c!= accountNewMap.get(accountId).MDCP_Subscribed_Flag__c||

                    //R5:Req-6021:Vinay M New condition is added to check Evaluate Territory flag when BR field is updated
                    accountOldMap.get(accountId).MDCP_Business_Relationship__c != accountNewMap.get(accountId).MDCP_Business_Relationship__c) {
                                    
                    accounts.add(accountNewMap.get(accountId)); 
                }
                // TM: Debmalya: Req-3293 Sep 27, 2012:Update World Region id Shipping Country changes- Start
                If(accountOldMap.get(accountId).ShippingCountry != accountNewMap.get(accountId).ShippingCountry ||
                   accountNewMap.get(accountId).World_Region1__c == null){
                       if(accountNewMap.get(accountId).ShippingCountry != '' || accountNewMap.get(accountId).ShippingCountry != null){
                           countryName.add(accountNewMap.get(accountId).ShippingCountry);
                           acctoUpdate.add(accountNewMap.get(accountId));
                       }
                   }
            // TM: Debmalya: Req-3293 Sep 27, 2012:Update World Region id Shipping Country changes- End
            }
        }
        
        if (accounts.size() > 0) {
            //send acccounts for flag updation
            upadateFlag(accounts);
            
        }
        
        
        // TM: Debmalya: Req-3293 Sep 27, 2012:Get World Region for country names & update accounts- Start
        Map<String,World_Region__c> mapNameRegion = new Map<String,World_Region__c>();
        mapNameRegion = mapWorldRegion(countryName);
        updateWorldRegionId(acctoUpdate,mapNameRegion);
        // TM: Debmalya: Req-3293 Sep 27, 2012:Get World Region for country names & update accounts- End
        
        
         
       //PRM:Suchitra R4:Req:4046:Start
     
        /**
        * @description: This method is called from before update trigger
        *               To make the strike count of the Partner User to zero,
        *               when 'Hp Lead Status' field value changes from Non compliant  to Active/Inactive/Disqualified
        *               @param: map of new Account & old Account
        **/                      
       
        //PCLM_NoncompliantRemovalController.toUpdateStrikeCount(accountNewMap,accountOldMap);
       
       //PRM:Suchitra R4:Req:4046:End
    }
    
    /**
    * @description: marks EvaluateTerritory__c flag true for account 
    *               
    * @param: list of Account
    **/
    // TM: Nasir: from mail of trung oct 19, 2012: Start
    public static void upadateFlag(List<Account> accounts) {
        if (accounts != null) {
            for (Account account: accounts) {
                                system.debug('testing:'+account.EvaluateTerritory__c);
               //add based on the request 13492

               if(account.Verified_Account__c=='False' && account.MDCP_Subscribed_Flag__c=='False'){
               // if(account.Verified_Account__c=='False'){
                    account.EvaluateTerritory__c = False;
                }
                // add based on the request 13492
                //if(account.Verified_Account__c=='True' || account.MDCP_Subscribed_Flag__c=='True'){
                if(account.Verified_Account__c=='True'){
                    account.EvaluateTerritory__c = true;
                }
               /* TM: Sreenath: Req- Nov 6, 2012: Starts
               if(account.World_Region1__c == null && (accountOldMap.get(accountId).World_Region1__c != accountNewMap.get(accountId).World_Region1__c)) {
                    account.EvaluateTerritory__c = false;
                } 
               else if(account.World_Region1__c != null && (accountOldMap.get(accountId).World_Region1__c != accountNewMap.get(accountId).World_Region1__c)){
                    account.EvaluateTerritory__c = true;
                }   
        // TM: Sreenath: Req- Nov 6, 2012: Ends   */
            }
        }
    }
    // TM: Nasir: from mail of trung oct 19, 2012: end
    // TM: Debmalya: Req-3293 Sep 27, 2012: End
    /**
    * @description: Returns a map of Country Names and World Region 
    *               
    * @param: Set of Country Names
    * @Return: Map of Country Names and Corresponding World Regions
    **/
    public static Map<String,World_Region__c> mapWorldRegion(Set<String> setCountryName){
        List<World_Region__c> wrList = [Select Id, Country_Name__c, Name from World_Region__c where Country_Name__c In: setCountryName];
        Map<String,World_Region__c> retNameRegions = new Map<String,World_Region__c>();
        if (wrList.size() > 0){
            for(World_Region__c wrRec : wrList){
                if(wrRec.Country_Name__c != '')
                retNameRegions.put(wrRec.Country_Name__c,wrRec);
            }
        }
        return retNameRegions;
    }
    
    /**
    * @description: set Id to World Region lookup field in account object 
    *               
    * @param: list of Account, Map of Country Names and Corresponding World Regions
    **/
    public static void updateWorldRegionId(List<Account> accounts,Map<String,World_Region__c> wrMaps){
        If(accounts != null && wrMaps != null){
            for (Account account: accounts) {
                try{
                    if(account.ShippingCountry != null || account.ShippingCountry != ''){
                        account.World_Region1__c = wrMaps.get(account.ShippingCountry).Id;
                    }
                }catch(Exception e){
                    system.debug('Invalid Country');
                }
            }
        }
    }
    // TM: Debmalya: Req-3293 Sep 27, 2012:End
         
    /**
     * @description: R4 Requirement Change.
     *               Renamed HP Lead Status field value from 'Probation' to 'Non compliant'
     */
       
    public static void partnerLeadStatusNotInactiveToProbation(Map<id,Account> accNewMap,Map<id,Account> accOldMap){
        Id RecordTypeId=null;
        RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Partner');
                   
        if(accNewMap != null && accOldMap != null){
            
            for(Account acc: accNewMap.values()){
                
                
                if(acc.RecordTypeId==RecordTypeId){
                    system.debug('it is a partner');
                    //PRM:Suchitra R4:Req:4046:Start
                    if(accOldMap.get(acc.id).HP_Lead_Status__c=='Inactive' && acc.HP_Lead_Status__c=='Non compliant'){
                    //PRM:Suchitra R4:Req:4046:End
                        system.debug('criteria met');
                        acc.addError('You can\'t change the Partner Lead status form Inactive to Non compliant');
                        return;
                    }
                }
        
            }
        
        }
    
    }
    
}