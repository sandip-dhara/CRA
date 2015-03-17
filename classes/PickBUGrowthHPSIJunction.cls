/**********************************************************
* Class Name: PickBUGrowthHPSIJunction
* Author: HP  
* Date:  15/09/2012
* Requirement # Request Id:3256 
* Description: PickBUGrowthHPSIJunction has been using pick the list of HP Strategic Intiatives.
**********************************************************/

public with sharing class PickBUGrowthHPSIJunction{
 public String buGrowthId,str = null;      
 public String errorMessage1 {get;set;}
 public String searchString{get;set;}
 public List<CustomerPriority> cbpList {get; set;}
 public List<Account_Plan__c> listacc=new List<Account_Plan__c>();
   /**
   * @description: Constructor for PickBUGrowthHPSIJunction controller  
    * @param: parameter - ApexPages.StandardSetController controller
    */              
       public PickBUGrowthHPSIJunction(ApexPages.StandardSetController controller)
        {
            buGrowthId= ApexPages.currentPage().getParameters().get('id');
            BU_Growth_Strategy__c bug=[Select bu.BU_Plan__c From BU_Growth_Strategy__c bu where bu.Id= :buGrowthId];
            listAcc=[Select a.Primary_AccountAccount__c,a.Name,a.CurrencyIsoCode From Account_Plan__c a where a.Id in (Select b.Account_Plan__c From Business_Unit_Plan__c b where b.Id  = :bug.BU_Plan__c )];
        }
     /**
    * @description: Returns HP Strategic Intiatives
    * @return: parameter - List<CustomerPriority> List of HP Strategic Intiatives  
    */           
        public List<CustomerPriority> getBusinessPriorities()
        {
           if(cbpList == null)
            {
                cbpList = new List<CustomerPriority>();
                for(Account_Plan__c acctPlan:listAcc)
                    str= acctPlan.Id;
                    
                for(Strategic_Initiative__c customBP : [Select  Name, Id,Account_Plan__c From Strategic_Initiative__c  where Account_Plan__c in (:str) limit 50000]) {
                    cbpList.add(new CustomerPriority(customBP));
                }
            }
                return cbpList;
        }
        //Navigate to BU Growth Strategy detail page
        public PageReference Cancel()
        {
            Pagereference pageRef = new PageReference('/' + buGrowthId);
            return pageref;
        }
        /**
    * @description: Adding Selectd HP Strategic Intiatives to BuGrowth Strategy-HP Strategic Intiative junction object 
    */   
        public PageReference processSelected()
        {
            Pagereference pageRef = new PageReference('/' + buGrowthId);
            
            List<Strategic_Initiative__c> selectedOpties = new List<Strategic_Initiative__c>();

            for(CustomerPriority op: getBusinessPriorities()) {
                if(op.selected == true) 
                    selectedOpties.add(op.Opp1);        
            }
            
            List<Related_HP_Strategic_Initiatives__c> sIopJunc = new List<Related_HP_Strategic_Initiatives__c>();
            if(selectedOpties.size()<=0){
            
               return null;
             
        }
         else{
                for(Strategic_Initiative__c Opp1:SelectedOpties) {
               Related_HP_Strategic_Initiatives__c soj=new Related_HP_Strategic_Initiatives__c();
                   soj.BU_Growth_Strategy__c=buGrowthId;
                    soj.HP_Strategic_Initiative__c=Opp1.Id;
                    soj.Unique_Key_RHPSI__c=Opp1.Id+buGrowthId;
                  sIopJunc.add(soj);
                    
                     
            }
            
            database.insert(sIopJunc,false);
              pageRef.setRedirect(true);
                  return pageRef;
              }
        }
        // To search the available HP Strategic Intiatives associated to Account plan.
        public PageReference search() {
            cbpList.clear();
            List<CustomerPriority> results=runSearch(searchString);
             return null;
        }
        
         public List<CustomerPriority> runSearch(String searchString)
     {
        // TODO prepare query string for complex serarches & prevent injections
        String Soql = 'Select  cbp.Name, cbp.Id,cbp.Account_Plan__c  From Strategic_Initiative__c cbp';
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
           List<Strategic_Initiative__c> customBusinessPrior =new List<Strategic_Initiative__c>();
           customBusinessPrior=database.query(soql); 
         for(Strategic_Initiative__c cbp: customBusinessPrior){
            cbpList.add(new CustomerPriority(cbp));
          }
          return cbpList;
     }
     //Wrapper Class to hold selected HP Strategic Intiatives
        public class CustomerPriority{
            public Strategic_Initiative__c Opp1 {get; set;}
            public Boolean selected {get; set;}
            public CustomerPriority(Strategic_Initiative__c o) {
            Opp1 = o;
            selected = false;
            }
        }
       /**
    * @description: Return true if HP Strategic Intiatives list is empty   
    */
 public boolean getIsPickCbpListEmpty(){
        boolean retValue = false;
        if (cbpList== null || cbpList.size() < 1) {
            retValue = true;
        }
        return retvalue;
    }

}