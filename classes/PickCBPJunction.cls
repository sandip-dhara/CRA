/**********************************************************
* Page Name:PickCustomerBusinessPriority  Class 
* Author: HP  
* Date: 25-JULY-2012 
* Requirement # Request Id: 
* Description: pick customerBusinessPriorities using Strategic Initiative 
and CustomerBusinessPriority
**********************************************************/

public with sharing class PickCBPJunction {
 public String strategicId,str = null;      
 public String errorMessage1 {get;set;}
 public String searchString{get;set;}
 public List<CustomerPriority> cbpList {get; set;}
 public List<Account_Plan__c> listacc=new List<Account_Plan__c>();
   /**
   * @description: Constructor for PickCBPJunction controller  
    * @param: parameter - ApexPages.StandardSetController controller
    */              
       public PickCBPJunction(ApexPages.StandardSetController controller)
        {
            strategicId = ApexPages.currentPage().getParameters().get('id');
            listAcc=[Select a.Primary_AccountAccount__c,a.Name,a.CurrencyIsoCode From Account_Plan__c a where a.Id in (Select s.Account_Plan__c From Strategic_Initiative__c s where s.Id = :strategicId )];
        }
     /**
    * @description: Returns CustomerBusinessPriorities 
    * @return: parameter - List<CustomerPriority> List of CustomerBusinessPriorities  
    */           
        public List<CustomerPriority> getBusinessPriorities()
        {
           if(cbpList == null)
            {
                cbpList = new List<CustomerPriority>();
                for(Account_Plan__c acctPlan:listAcc)
                    str= acctPlan.Id;
                    
                for(Customer_Business_Priority__c customBP : [Select  Name, Id,Account_Plan__c,Short_Description__c,Priority__c,Timing__c From Customer_Business_Priority__c  where Account_Plan__c in (:str) limit 50000]) {
                    cbpList.add(new CustomerPriority(customBP));
                }
            }
                return cbpList;
        }
        //Navigate to Strategic Initiative detail page
        public PageReference Cancel()
        {
            Pagereference pageRef = new PageReference('/' + strategicId );
            return pageref;
        }
        /**
    * @description: Adding Selectd CustomerBusinessPriorities to CBP-Strategic Intiative junction object 
    */   
        public PageReference processSelected()
        {
            Pagereference pageRef = new PageReference('/' + strategicId );
            
            List<Customer_Business_Priority__c> selectedOpties = new List<Customer_Business_Priority__c>();

            for(CustomerPriority op: getBusinessPriorities()) {
                if(op.selected == true) 
                    selectedOpties.add(op.Opp1);        
            }
            
            List<Related_CustomerBusiness__c> sIopJunc = new List<Related_CustomerBusiness__c>();
            if(selectedOpties.size()<=0){
            
               return null;
             
        }
         else{
                for(Customer_Business_Priority__c Opp1:SelectedOpties) {
               Related_CustomerBusiness__c soj=new Related_CustomerBusiness__c();
                   soj.Strategic_Initiative__c=strategicId;
                    soj.Customer_Business_Priority__c=Opp1.Id;
                    soj.UniqueCBP_Key__c=Opp1.Id+strategicId;
                  sIopJunc.add(soj);
                    
                     
            }
            
            database.insert(sIopJunc,false);
              pageRef.setRedirect(true);
                  return pageRef;
              }
        }
        // To search the available customer business priorities associated to Account plan.
        public PageReference search() {
            cbpList.clear();
            List<CustomerPriority> results=runSearch(searchString);
             return null;
        }
        
         public List<CustomerPriority> runSearch(String searchString)
     {
        // TODO prepare query string for complex serarches & prevent injections
        String Soql = 'Select  cbp.Name, cbp.Id,cbp.Account_Plan__c,cbp.Short_Description__c,cbp.Priority__c,cbp.Timing__c  From Customer_Business_Priority__c cbp';
        String whereCondition = '';
        if(searchString != null && searchString != ''){
              searchString = searchString.replaceAll('\\*','%'); 
              searchstring=searchstring.replaceAll('%',''); 
              whereCondition = whereCondition +  ' cbp.Account_Plan__c In (:str) and cbp.name LIKE \''+'%'  + searchString +'%\'  and';
              whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);                         
        }
        else{
            whereCondition=' where' +  ' cbp.Account_Plan__c In (:str)';}
           soql= soql + whereCondition + ' limit 5000';
           List<Customer_Business_Priority__c> customBusinessPrior =new List<Customer_Business_Priority__c>();
           customBusinessPrior=database.query(soql); 
         for(Customer_Business_Priority__c cbp: customBusinessPrior){
            cbpList.add(new CustomerPriority(cbp));
          }
          return cbpList;
     }
     //Wrapper Class to hold selected Customer Business Priorities
        public class CustomerPriority{
            public Customer_Business_Priority__c Opp1 {get; set;}
            public Boolean selected {get; set;}
            public CustomerPriority(Customer_Business_Priority__c o) {
            Opp1 = o;
            selected = false;
            }
        }
       /**
    * @description: Return true if CustomerBusinessPriority list is empty   
    */
 public boolean getIsPickCbpListEmpty(){
        boolean retValue = false;
        if (cbpList== null || cbpList.size() < 1) {
            retValue = true;
        }
        return retvalue;
    }

}