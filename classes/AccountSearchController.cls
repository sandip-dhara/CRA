public class AccountSearchController {
    public AccountSearchController(ApexPages.StandardController controller) {

    }

public ID AcntId = ApexPages.currentPage().getParameters().get('Id');
 
    // the results from the search. do not init the results or a blank rows show up initially on page load
    public List<AccountWrapper> searchResults {get;set;}
    // the Accounts that were checked/selected.
    public List<AccountWrapper> selectedAccounts {
        get {
            if (selectedAccounts == null) selectedAccounts = new List<AccountWrapper>();
            return selectedAccounts;
        }
        set;
    }  

     public List<ID> MergeIds {
        get {
            if (MergeIds == null) MergeIds = new List<ID>();
            return MergeIds;
        }
        set;
    }  
    

 
    // the text in the search box
    public string searchText {
        get {
            if (searchText == null) searchText = ''; // prefill the serach box for ease of use
            return searchText;
        }
        set;
    } 
    
     public string mdcpId{
        get {
            if (mdcpId== null) mdcpId= ''; // prefill the serach box for ease of use
            return mdcpId;
        }
        set;
    } 
 
    // constructor
    public AccountSearchController() {}
 
    // fired when the search button is clicked
    public PageReference search() {
 
        if (searchResults == null) {
            searchResults = new List<AccountWrapper>(); // init the list if it is null
        } else {
            searchResults.clear(); // clear out the current results if they exist
        }
        // Note: you could have achieved the same results as above by just using:
        // searchResults = new List<AccountWrapper>();
 
 
       string wherecondition = '';

   
    if (mdcpId== null||mdcpId== '') {
            // wherecondition = '+mdcpId+';  
            wherecondition = '';  

        }else {
        wherecondition = 'c.MDCP_Organization_ID__c LIKE \'%'+mdcpId +'%\'';}

      if (searchText!= null||searchText!= '') {
                  if (wherecondition.length() > 1){ 
                  
                      wherecondition = wherecondition + ' and c.Name LIKE \'%'+searchText +'%\'';  
                        } else { 
                       wherecondition = 'c.Name LIKE \'%'+searchText +'%\''; 
                          }
             } else { 
                      wherecondition = 'c.Name LIKE \'%'+searchText +'%\''; 
                   }                 
                   
       
           //String qry = 'Select c.Name, c.Id,c.AMID_L2__c,c.MDCP_Organization_ID__c,c.WorldRegion_SubRegion1__c,c.WorldRegion_SubRegion2__c,c.AccountNumber,c.Site,c.AnnualRevenue,c.owner.name,c.NumberOfEmployees,c.Industry_Vertical__c,c.Active_Flag__c,c.Country_Code__c,c.DUNS__c,c.Industry_Segment__c,c.Location_ID__c,c.BillingCountry,c.BillingState, c.BillingCity,c.BillingStreet,c.BillingPostalCode From Account c Where '+ wherecondition +' Order By c.Name';
           // String qry = 'Select c.Name, c.Id,c.AMID_L2__c,c.MDCP_Organization_ID__c,c.WorldRegion_SubRegion1__c,c.WorldRegion_SubRegion2__c,c.AccountNumber,c.Site,c.AnnualRevenue,c.owner.name,c.NumberOfEmployees,c.Industry_Vertical__c,c.Active_Flag__c,c.Country_Code__c,c.DUNS__c,c.Industry_Segment__c,c.Location_ID__c,c.BillingCountry,c.BillingState, c.BillingCity,c.BillingStreet,c.BillingPostalCode,c.ShippingStreet,c.ShippingState,c.ShippingPostalCode,c.ShippingCountry, c.ShippingCity From Account c Where '+ wherecondition +'Order By c.Name ';
          String qry = 'Select c.Name, c.Id,c.AMID_L2__c,c.MDCP_Organization_ID__c,c.WorldRegion_SubRegion1__c,c.WorldRegion_SubRegion2__c,c.AccountNumber,c.Site,c.AnnualRevenue,c.owner.name,c.NumberOfEmployees,c.Industry_Vertical__c,c.Active_Flag__c,c.Country_Code__c,c.DUNS__c,c.Industry_Segment__c,c.Location_ID__c,c.BillingCountry,c.BillingState, c.BillingCity,c.BillingStreet,c.BillingPostalCode,c.ShippingStreet,c.ShippingState,c.ShippingPostalCode,c.ShippingCountry, c.ShippingCity From Account c WHERE RecordTypeId in(select Id FROM RecordType where SobjectType= \'Account\' and name =\'Customer\') and '+ wherecondition +'Order By c.Name limit 500';



        // may need to modify for governor limits??
        for(Account c : Database.query(qry)) {
            // create a new wrapper by passing it the Account in the constructor
            AccountWrapper cw = new AccountWrapper(c);
            // add the wrapper to the results
            searchResults.add(cw);
        }
        return null;
            }   
      public PageReference next() {
 
        // clear out the currently selected Accounts
        selectedAccounts.clear();
        MergeIds.clear();
 
        // add the selected Accounts to a new List
       
        for (AccountWrapper cw : searchResults) {
            if (cw.checked){
                selectedAccounts.add(new AccountWrapper(cw.cat));
        MergeIds.add(cw.cat.Id);
        }

        }
 
        // ensure they selected at least one Account or show an error message.
        if (selectedAccounts.size() > 0) {

                if (selectedAccounts.size() < 2) {
                    return Page.Account_Results;
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select only one account.'));
                    return null;   
                    }     
                       
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Account.'));
            return null;
        }       
 
    } 
         
 
    // fired when the back button is clicked
    public PageReference back() {
        return Page.Account_Search;
     } 
     
     public PageReference AccountMerge() {    
           
   Account masterAcct = [SELECT Id, Name FROM Account WHERE Id =: MergeIds LIMIT 1];
   List<Account> mergeAcct = [SELECT Id,Name,AMID_L2__c,MDCP_Organization_ID__c,WorldRegion_SubRegion1__c,WorldRegion_SubRegion2__c FROM Account WHERE Id =: AcntId LIMIT 1];   


     merge masterAcct mergeAcct; {      
        }
               // selectedAccounts.clear();
               // return Page.Account_Search;
               return Page.Account_Tab_Override;

       } 



     public class AccountWrapper {
 
    public Boolean checked{ get; set; }
    public Account cat { get; set;}
    
    
 
    public AccountWrapper(){
        cat = new Account();
        checked = false;
    }
 
    public AccountWrapper(Account c){
        cat = c;
        checked = false;
    }
 
  } 
     }