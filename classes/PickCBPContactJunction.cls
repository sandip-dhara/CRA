/**********************************************************
* Class Name: PickCBPContactJunction 
* Author: HP  
* Date: 15/09/2012
* Requirement # Request Id:3256 
* Description: Using this class Pick the List of Contacts Associated with the Account.
**********************************************************/

public with sharing class PickCBPContactJunction {
 public String cbpId,str = null;      
 public String errorMessage1 {get;set;}
 public String searchString{get;set;}
 public List<CustomerPriority> cbpList {get; set;}
 public List<Account_Plan__c> listacc=new List<Account_Plan__c>();
   /**
   * @description: Constructor for PickCBPContactJunction controller  
    * @param: parameter - ApexPages.StandardSetController controller
    */              
       public PickCBPContactJunction(ApexPages.StandardSetController controller)
        {
            cbpId= ApexPages.currentPage().getParameters().get('id');
            listAcc=[Select a.Primary_AccountAccount__c From Account_Plan__c a where a.Id in (Select cbp.Account_Plan__c From Customer_Business_Priority__c cbp where cbp.Id = :cbpId)];
        }
     /**
    * @description: Returns Contacts 
    * @return: parameter - List<CustomerPriority> List of CustomerBusinessPriorities  
    */           
        public List<CustomerPriority> getBusinessPriorities()
        {
           if(cbpList == null)
            {
                cbpList = new List<CustomerPriority>();
                for(Account_Plan__c acctPlan:listAcc)
                    str= acctPlan.Primary_AccountAccount__c;
                    
                for(Contact con : [Select Name From Contact where AccountId in (:str)]) {
                    cbpList.add(new CustomerPriority(con));
                }
            }
                return cbpList;
        }
        //Navigate to CustomerBusinessPrority detail page
        public PageReference Cancel()
        {
            Pagereference pageRef = new PageReference('/' + cbpId);
            return pageref;
        }
        /**
    * @description: Adding Selectd Contacts to CBP-Contact junction object 
    */   
        public PageReference processSelected()
        {
            Pagereference pageRef = new PageReference('/' + cbpId);
            
            List<Contact> selectedOpties = new List<Contact>();

            for(CustomerPriority op: getBusinessPriorities()) {
                if(op.selected == true) 
                    selectedOpties.add(op.Opp1);        
            }
            
            List<Related_Customer_Contacts__c> sIopJunc = new List<Related_Customer_Contacts__c>();
            if(selectedOpties.size()<=0){
            
               return null;
             
        }
         else{
                for(Contact Opp1:SelectedOpties) {
              Related_Customer_Contacts__c cbpJunction=new Related_Customer_Contacts__c();
                   cbpJunction.Customer_Business_Priority__c=cbpId;
                    cbpJunction.Contact__c =Opp1.Id;
                    cbpJunction.Unique_Key_RCC__c=Opp1.Id+cbpId;
                  sIopJunc.add(cbpJunction);
                    
                     
            }
            
            database.insert(sIopJunc,false);
              pageRef.setRedirect(true);
                  return pageRef;
              }
        }
        // To search the available Contacts associated to Account plan.
        public PageReference search() {
            cbpList.clear();
            List<CustomerPriority> results=runSearch(searchString);
             return null;
        }
        
         public List<CustomerPriority> runSearch(String searchString)
     {
        // TODO prepare query string for complex serarches & prevent injections
        String soql = 'Select  cbp.Name From Contact cbp';
        String whereCondition = '';
        if(searchString != null && searchString != ''){
              searchString = searchString.replaceAll('\\*','%'); 
              searchstring=searchstring.replaceAll('%',''); 
              whereCondition = whereCondition +  ' cbp.AccountId In (:str) and cbp.name LIKE \''+'%'  + searchString +'%\'  and';
              whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);                         
        }
        else{
            whereCondition=' where' +  ' cbp.AccountId In (:str)';}
           soql= soql + whereCondition + ' limit 5000';
           List<Contact> customBusinessPrior =new List<Contact>();
           customBusinessPrior=database.query(soql); 
         for(Contact cbp: customBusinessPrior){
            cbpList.add(new CustomerPriority(cbp));
          }
          return cbpList;
     }
     //Wrapper Class to hold selected Contacts
        public class CustomerPriority{
            public Contact Opp1 {get; set;}
            public Boolean selected {get; set;}
            public CustomerPriority(Contact o) {
            Opp1 = o;
            selected = false;
            }
        }
       /**
    * @description: Return true if Contact list is empty   
    */
 public boolean getIsPickCbpListEmpty(){
        boolean retValue = false;
        if (cbpList== null || cbpList.size() < 1) {
            retValue = true;
        }
        return retvalue;
    }

}