/**********************************************************
 * Class Name: DealReg_CustomerSearchController
 * Author: HP Release 3 and 4
 * Date: 17-Jan-2013 
 * Requirement # Request Id:
 * Description: Controller class for Custmer search and creating a unverified account via Tibco and MDCP service.
 ***********************************************************/
public class DealReg_CustomerSearchController {

    // Variable to hold account record
    public Account account {get;set;}

    // Variable to hold list of account records
    public List<Account> results{get;set;} 

    // Variable to hold city value
    public String searchCity{get;set;}

    // Variable to hold list of accounts
    public List<Account> createResults{get;set;}

    // Variable to hold the name of the account
    public String name{get;set;}

    // Variable to hold shipping street
    public String shippingStreet{get;set;}

    // Variable to hold shipping city
    public String shippingCity{get;set;}

    // Variable to hold shipping state
    public String shippingState{get;set;}

    // Variable to hold shipping postal code
    public String shippingPostalCode{get;set;}

    // Variable to hold shipping country
    public String shippingCountry {get;set;}

    // Variable to hold account name to be searched
    public String searchKey{get;set;} 

    // Variable to hold searchCountry
    public String searchCountry{get;set;}

    // Variable to hold size of result set
    public Integer size{get;set;}

    // Variable to hold number of account records returned
    public Integer noOfRecords{get; set;}

    // Variable to hold status of result
    public String resultStatus{get;set;}

    // Variable to hold status of Tiboc or Mdcp down
    public String mdcpStatus{get;set;}

    // Variable to hold boolean value for the empty result
    public Boolean resultEmpty{get;set;}

    // Variable to hold boolean value for large number of records
    public Boolean largeResultsFound{get;set;}

    // Variable to hold boolean value for the search panel visibility
    public Boolean searchPanelVisible{get;set;}

    // Variable to hold boolean value
    public boolean flag{get;set;}

    // Variable to hold boolean value if many number of records which are fetched
    public Boolean largeProductFound {get;set;}

    // Variable to hold boolean value for the button visibility
    public Boolean isButtonVisible {get;set;}

    // Variable to hold boolean value for errors displayed on tab1
    public Boolean isTab1Error {get;set;}

    // Variable to hold boolean value for errors displayed on tab2
    public Boolean isTab2Error {get;set;}

    // Variable to hold list of accounts returned for the search
    public List<Account> searchResults{get;set;}

    //The flag is to verify that the record is subscribed to MDCP which means it already exists in Accounts of SFDC and would be updated if any change made in MDCP.
    public String isSubscribed{get;set;}

    // Mdcp id used to redirect to opportunity page
    public String mdcpId{get;set;}

    //mdcpSiteId used to uniquely identify the selected record form the Apex page
    public String mdcpSiteId{get;set;}

    // Checking the flag from MDCP, if it is 'true' directly go to opportunity page it 'no' then insert the record in account and create a case
    public String isSubscribedFlagCheck{get;set;}

    //Used to sort the results 
    private String sortDirection = 'ASC';

    // Helper class used to sort the list dynamically based on the column name
    private SortHelperMDCP sorter = new SortHelperMDCP();  

    //sortExp for true or false to pass it in above helper
    private String sortExp {get;set;}

    //Dynamically select the column name for sort and pass it in above helper
    public String sortField{get;set;}

    //This variable used to render the existing SFDC serach logic, if the Tibco or MDCP is down
    public String isMdcpOrTibcoIsRunning{get;set;}

    //If organizationId from MDCP and Subscribed flag is not same then below message rendered in Page
    public String isMdcpFoundInSfdc{get;set;}

    public String caseCountry {get;set;}

    public String caseRegion {get;set;}

    public String caseBg {get;set;}

    public Location__c partnerLocation=new Location__c();


    /*
     * @Description:Method is used pass sortExp for ASC or DESC to pass it in above helper 
     */
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }

    /*
     * @Description:Method is used pass sortExp for ASC or DESC to pass it in above helper 
     */
    public String getSortDirection()
    {
        //if no column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    /*
     *@Description: Method is used to set the value
     */
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }


    /*
     * @Description: Constructor for this class
     */
    public DealReg_CustomerSearchController(ApexPages.StandardController controller) {
        account = new Account();   
        createResults = new List<Account>(); 
        // get the current search name
        searchKey ='';
        searchCountry= '';
        searchCity='';
        User user=[select id,country,Location_Record_Id__c,Region__c,Business_Group__c from user where id=:UserInfo.getUserId()]; 
        if(user.Location_Record_Id__c!=null){
            partnerLocation=[select Sell_Into_Market__c from Location__c where id=:user.Location_Record_Id__c];
        }
        searchCountry=partnerLocation.Sell_Into_Market__c;
        shippingCountry=partnerLocation.Sell_Into_Market__c;
        caseBg=user.Business_Group__c;
        caseRegion=user.Region__c;
        caseCountry=user.country;
        system.debug('sreeekanth'+caseBg+caseRegion);
        largeResultsFound=true;   
        searchPanelVisible=false;
        flag=false;
        isTab1Error=false;
        isTab2Error=false;
    }


    /*
     * @Description: Method to perform search for accounts.
     * @Return: PageReference -  pagereference object.
     */
    public PageReference search() {

        List<Account> tempAccountList =new List<Account>();
        List<Account> accountList =new List<Account>();
        Account accountObject=null; 
        searchPanelVisible=true;    

        if(searchKey.length()==0){              
            searchPanelVisible=false;
            isTab1Error=true;
            isTab2Error=false;
            System.debug('inside customer name');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.DealReg_Enter_Customer_Name));
            return null;              
        }else if((searchKey.length()< 2)&&!(searchKey.contains('*'))){
            isTab1Error=true;
            isTab2Error=false;
            searchPanelVisible=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.NAME_MIN_TWO_CHAR));
            return null;
        }  
        String star='*';
        star=star.repeat(searchKey.length());
        String percent='%';
        percent=percent.repeat(searchKey.length());
        if(searchKey.contains(star)||searchKey.contains(percent)){
            searchPanelVisible=false;
            isTab1Error=true;
            isTab2Error=false;
            System.debug('inside wild card');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.WILDCARD_NOTALLOWD));
            return null;
        }              

        try{  

            String mdcpQuery='';

            //Dynamically constructing the mdcpQuery for Name, City and Country
            if(searchKey !=null && searchCountry !=null && searchCity !=null && searchKey !='' && searchCountry !='' && searchCity !='')
            {
                mdcpQuery= 'organizationExtendedName:'+'"'+searchKey+'"'+' AND '+'countryName:'+'"'+searchCountry+'"'+' AND '+'latinCity:'+searchCity;
            }
            else if(searchKey !=null && searchCountry !=null && searchKey !='' && searchCountry !='')
            {
                mdcpQuery= 'organizationExtendedName:'+'"'+searchKey+'"'+' AND '+'countryName:'+'"'+searchCountry+'"';
            }
            else if(searchKey  !=null && searchCity !=null && searchKey  !='' && searchCity !='')
            {
                mdcpQuery='organizationExtendedName:'+'"'+searchKey+'"'+' AND '+'latinCity:'+searchCity;
            }
            else if(searchCountry !=null && searchCity !=null && searchCountry !='' && searchCity !='')
            {
                mdcpQuery='latinCity:'+searchCity+' AND '+'countryName:'+'"'+searchCountry+'"';
            }
            else if(searchKey  !=null && searchKey  !='')
            {
                mdcpQuery='organizationExtendedName:'+'"'+searchKey+'"';
            }
            else if(searchCountry  !=null && searchCountry  !='')
            {
                mdcpQuery='countryName:'+'"'+searchCountry+'"';
            }
            else if(searchCity  !=null && searchCity  !='')
            {
                mdcpQuery='latinCity:'+searchCity;
            }  

            //To restric the private accounts -'includePrivateAccount:N' not to display in the search results
            mdcpQuery =mdcpQuery+' AND includePrivateAccount:N';

            DealReg_WebSvcCallout.callWebservice(accountObject,accountList,mdcpQuery);

            //Below condition is used take 25 records from the Tibco->MDCP service         
            if(accountList.size() <Integer.valueOf(Label.DEAL_Query_Limit))
            {
                searchResults=accountList;      
            }
            else
            {
                for (Integer i = 0; i < Integer.valueOf(Label.DEAL_Query_Limit); i++){
                    tempAccountList.add(accountList[i]);
                } 
                searchResults=tempAccountList;   
            } 
            //This variable used to render the Name hyperlink in visual force page, if the Tibco or MDCP is down 
            isMdcpOrTibcoIsRunning ='True';

            //Below condition is used to sort the customer name by default ASC
            if(searchResults !=null && searchResults.size()>0){
                searchResults=sorter.sortList(searchResults,'Name', 'ASC');
            } 

            if (searchResults.size() >=  Integer.valueOf(Label.DEAL_Query_Limit)){
                largeProductFound = true;
            }else{
                largeProductFound = false;    
            } 

            isMdcpFoundInSfdc='';

        } catch(Exception e){

            if(e.getMessage().contains('timed out')){

                // If Tibco and MDCP webservice is down than we will be redirecting the search logic to existing SFDC
                searchResults =DealReg_AccountSearchUtil.runSearch(searchKey,searchCountry, searchCity,results,size,noOfRecords);

                mdcpStatus='Tibco or MDCP service is down or Search criteria is not matching in MDCP: Redirecting to SFDC search';

                //Below condition is used to sort the customer name by default in ASC
                if(searchResults !=null && searchResults.size()>0){            
                    searchResults=sorter.sortList(searchResults,'Name', 'ASC');
                }

                //This variable used to render the Name hyperlink in visual force page, if the Tibco or MDCP is down
                isMdcpOrTibcoIsRunning ='False';

                if (searchResults.size() >=  Integer.valueOf(Label.DEAL_Query_Limit)){
                    largeProductFound = true;
                }else{
                    largeProductFound = false;    
                }            
            }  else{
                searchResults =null;
                largeProductFound = false; 
            }
            isMdcpFoundInSfdc='';
            system.debug('**Exception Occured while connecting the Tibco and MDCP webservice ****' +  'Exception: ' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
        }
        return null;
    }


    /*
     * @Description: Method to get list of accounts.
     * @Return: List<Account> -  List of accounts.
     */
    public list<account>getAccounts(){    
        results= new List<Account>();
        if(''!=searchKey){       
            if(null!=searchResults){
                for(Account accountObj : searchResults){
                    results.add(accountObj);
                }
                resultEmpty=false;
            }
        }
        if(results.size()==0){    
            resultStatus='--------------No results found------------------';
            resultEmpty=true;
        }
        return results;
    }


    /*
     * @Description: Method to save an account.
     * 
     */
    public void saveAccount() {
        account.recordTypeID =RecordTypeIdHelper.getRecordTypeId('Account','Customer');
        account.name=name;
        account.shippingStreet=shippingStreet;
        account.shippingCity=shippingCity;
        account.shippingState=shippingState;
        account.shippingPostalCode=shippingPostalCode;
        account.shippingCountry =shippingCountry;                    
        if( ''!=account.Name.trim() && ''!=account.shippingStreet.trim()  && ''!=account.shippingCity.trim()  && null!=account.shippingCountry && ''!=account.shippingCountry.trim()){    
            flag=true;
            insert account; 
            // Reset the account    
            createResults.add(new Account(ID=account.id,name=account.name,
                    shippingStreet=account.shippingStreet,
                    shippingCity=account.shippingCity,
                    shippingState=account.shippingState,
                    shippingPostalCode=account.shippingPostalCode,
                    shippingCountry=account.shippingCountry
            ));

        }else{
            isTab2Error=true;
            isTab1Error=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.MANDATORY_FIELDS));
            return;
        }
        // Creating a case for Unverified account creation.       
        Case caseObj = new Case(Reason = 'Create a new account', Origin = 'Salesforce',New_Account_Name__c =account.name);
        caseObj.accountId=account.ID;
        caseObj.ownerid=[Select id,QueueId from QueueSobject where SobjectType = 'Case' AND Queue.Name = 'Master Data - Back Office – SFDC'].QueueId;  
        caseObj.recordTypeID = RecordTypeIdHelper.getRecordTypeId('Case','Case Request');
        caseObj.street__c=account.ShippingStreet;
        caseObj.city__c=account.ShippingCity;
        caseObj.state_Province__c=account.ShippingState;
        caseObj.zip_Postal_Code__c=account.ShippingPostalCode;
        caseObj.country__c=account.ShippingCountry;
        // Added to force the priority to High.
        caseObj.Priority='High';
        caseObj.Scenario__c='Unverified Account Registration';
        caseObj.Request_Type__c='Single Record';   
        caseObj.Region__c=CaseRegion;
        caseObj.New_Account_Name__c=account.name;
        caseObj.description='New Unverified account submission request.';
        caseObj.subject=account.ShippingCountry +'- New Unverified account submission request';
        if( ''!=account.name   && ''!=account.shippingStreet  && ''!=account.shippingCity   && ''!=account.shippingCountry  ){
            insert caseObj;
        }                              
    }     


    /*
     * This method used to sort the column dynamically
     */
    public PageReference sortColumn() {

        searchResults=sorter.sortList(searchResults,sortField, getSortDirection());        
        return null;
    }       

    /*
     * @Description: This method is used to Check the flag from MDCP, if it is 'true' directly redirect to opportunity page 
     * if it is 'false' then insert the record in account and create a case accordingly
     * @Return: PageReference -  pagereference object.
     */
    public PageReference isSubscribedFlag() {

        //If Tibco and MDCP webservice is down than we will be redirecting the search logic to existing SFDC
        if(mdcpId !=null){  

            if(isMdcpOrTibcoIsRunning=='True'){

                // If SubscribedFlag true means , the account is available in SFDC and in MDCP
                if(isSubscribedFlagCheck=='true')
                {
                    List<Account>  mdcpIdList=[SELECT Id FROM Account where MDCP_Organization_ID__c =: mdcpId];

                    //If organizationId from MDCP and Subscribed flag is not same then below message rendered in Page
                    if(mdcpIdList.size()==0){
                        isMdcpFoundInSfdc='The MDCP OrganizationId '+mdcpId+' is not found in SFDC';
                    }
                    else
                    {
                        for(Account accountObj:mdcpIdList){               
                            Pagereference pageRef=new Pagereference('/006/e?nooverride=1&opp11=01+-+Understand+Customer&opp4_lkid='+accountObj.Id);
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    }
                }
                else
                {
                    isMdcpFoundInSfdc='';

                    for(Account accountObject: searchResults)
                    {

                        if(accountObject.MDCP_Organization_ID__c.contains(mdcpId) && accountObject.Mdcp_SiteId__c.contains(mdcpSiteId))
                        {
                            //accountObject.MDCP_Organization_ID__c=null;

                            if(accountObject.Name==null || accountObject.Name==''){
                                accountObject.Name='-';
                            }

                            if(accountObject.ShippingStreet==null || accountObject.ShippingStreet==''){                 
                                accountObject.ShippingStreet='-';
                            }

                            if(accountObject.ShippingPostalCode==null || accountObject.ShippingPostalCode==''){                   
                                accountObject.ShippingPostalCode='-';
                            }

                            if(accountObject.ShippingCity==null || accountObject.ShippingCity==''){                  
                                accountObject.ShippingCity='-';
                            }  

                            if(accountObject.ShippingState==null || accountObject.ShippingState==''){                 
                                accountObject.ShippingState='-';            
                            }

                            if(accountObject.ShippingCountry==null || accountObject.ShippingCountry==''){                    
                                accountObject.ShippingCountry='-';
                            }
                            /* Added exception handling to insert userkey to first Unverified Customer Account creation and blank for others*/
                            try{
                                // Inserting the account object 
                                insert accountObject;
                                system.debug('In try****'+accountObject.Userkey__c);  
                            }catch(Exception e){
                                system.debug('In catch1'+accountObject.Userkey__c);
                                if(e.getMessage().contains('Userkey__c')){
                                    accountObject.Userkey__c='';
                                    system.debug('In catch2'+accountObject.Userkey__c);
                                    insert accountObject; 
                                    system.debug('In catch accountObject'+accountObject);
                                }
                            }
                            // Creating the case
                            Case caseObj = new Case(Reason = 'Create a new account22', Origin = 'Salesforce',New_Account_Name__c =accountObject.name);
                            caseObj.accountId=accountObject.ID;
                            caseObj.ownerid=[Select id,QueueId from QueueSobject where SobjectType = 'Case' AND Queue.Name = 'Master Data - Back Office – SFDC'].QueueId;  
                            caseObj.recordTypeID = RecordTypeIdHelper.getRecordTypeId('Case','Case Request');
                            caseObj.street__c=accountObject.ShippingStreet;
                            caseObj.city__c=accountObject.ShippingCity;
                            caseObj.state_Province__c=accountObject.ShippingState;
                            caseObj.zip_Postal_Code__c=accountObject.ShippingPostalCode;
                            caseObj.country__c=accountObject.ShippingCountry;
                            // Added to force the priority to High.
                            caseObj.Priority='High';
                            caseObj.description='New Unverified account submission request for MDCP organizationId - '+mdcpId+' : MDCP OPS Id - '+mdcpSiteId+' : MDCP OPSI Id - '+accountObject.MDCP_Site_Instance_Id__c;
                            caseObj.subject=accountObject.ShippingCountry +'- New Unverified account submission request';
                            caseObj.Region__c=accountObject.World_Region__c;
                            caseObj.Scenario__c='Unverified Account Registration – Found in MDCP';
                            if( ''!=accountObject.name   && ''!=accountObject.shippingStreet  && ''!=accountObject.shippingCity   && ''!=accountObject.shippingCountry  ){
                                insert caseObj;
                            } 

                            Pagereference pageRef=new Pagereference('/006/e?nooverride=1&opp11=01+-+Understand+Customer&opp4_lkid='+accountObject.Id);
                            pageRef.setRedirect(true);
                            return pageRef;  
                        }            
                    }            
                }   
            }  
            else
            {
                isMdcpFoundInSfdc='';

                List<Account>  mdcpId=[SELECT Id FROM Account where MDCP_Organization_ID__c =: mdcpId];

                for(Account accountObj:mdcpId){               
                    Pagereference pageRef=new Pagereference('/006/e?nooverride=1&opp11=01+-+Understand+Customer&opp4_lkid='+accountObj.Id);
                    pageRef.setRedirect(true);
                    return pageRef;
                } 
            }  
        }
        return null;   
    }     
}