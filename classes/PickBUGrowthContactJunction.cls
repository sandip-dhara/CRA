/**********************************************************
* Class Name: PickBUGrowthContactJunction 
* Author: HP  
* Date: 17/09/2012
* Requirement # Request Id: 3256
* Description: PickBUGrowthContactJunction controller has been using pick the List of Contacts.
**********************************************************/

public with sharing class PickBUGrowthContactJunction {
 public String buGrowthId,str = null;      
 public String errorMessage1 {get;set;}
 public String searchString{get;set;}
 public List<CustomerPriority> cbpList {get; set;}
 public List<Account_Plan__c> listacc=new List<Account_Plan__c>();
   /**
   * @description: Constructor for PickBUGrowthContactJunction  controller  
    * @param: parameter - ApexPages.StandardSetController controller
    */              
       public PickBUGrowthContactJunction(ApexPages.StandardSetController controller)
        {
            buGrowthId= ApexPages.currentPage().getParameters().get('id');
             BU_Growth_Strategy__c bug=[Select bu.BU_Plan__c From BU_Growth_Strategy__c bu where bu.Id= :buGrowthId];
            listAcc=[Select a.Primary_AccountAccount__c,a.Name,a.CurrencyIsoCode From Account_Plan__c a where a.Id in (Select b.Account_Plan__c From Business_Unit_Plan__c b where b.Id  = :bug.BU_Plan__c )];
        }
     /**
    * @description: Returns Contacts 
    * @return: parameter - List<CustomerPriority> List of Contacts  
    */           
        public List<CustomerPriority> getBusinessPriorities()
        {
           if(cbpList == null)
            {
                cbpList = new List<CustomerPriority>();
                for(Account_Plan__c acctPlan:listAcc)
                    str= acctPlan.Primary_AccountAccount__c;
                    
                for(Contact con : [Select Name From Contact where AccountId in (:str) limit 1000]) {
                    cbpList.add(new CustomerPriority(con));
                }
            }
                return cbpList;
        }
        //Navigate to BUGrowth Strategy detail page
        public PageReference Cancel()
        {
            Pagereference pageRef = new PageReference('/' + buGrowthId);
            return pageref;
        }
        /**
    * @description: Adding Selectd Contacts to BUGrowth-Contact junction object 
    */   
        public PageReference processSelected()
        {
            Pagereference pageRef = new PageReference('/' + buGrowthId);
            
            List<Contact> selectedOpties = new List<Contact>();

            for(CustomerPriority op: getBusinessPriorities()) {
                if(op.selected == true) 
                    selectedOpties.add(op.Opp1);        
            }
            
            List<Related_Stakeholder_s__c> sIopJunc = new List<Related_Stakeholder_s__c>();
            if(selectedOpties.size()<=0){
            
               return null;
             
        }
         else{
                for(Contact Opp1:SelectedOpties) {
              Related_Stakeholder_s__c cbpJunction=new Related_Stakeholder_s__c();
                   cbpJunction.BU_Growth_Strategy__c=buGrowthId;
                    cbpJunction.Contact__c =Opp1.Id;
                    cbpJunction.Unique_Key_RSH__c=Opp1.Id+buGrowthId;
                  sIopJunc.add(cbpJunction);
                    
                     
            }
            
            database.insert(sIopJunc,false);
              pageRef.setRedirect(true);
                  return pageRef;
              }
        }
        // To search the available Contacts associated to Account plan their Account.
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
           soql= soql + whereCondition + ' limit 1000';
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