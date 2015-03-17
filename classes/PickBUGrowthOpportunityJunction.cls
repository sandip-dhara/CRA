/**********************************************************
* Class Name: PickBUGrowthOpportunityJunction 
* Author: HP  
* Date: 20/09/2012
* Requirement # Request Id:3254 
* Description: PickBUGrowthOpportunityJunction has been using pick the list of Opportunities.
**********************************************************/

public with sharing class PickBUGrowthOpportunityJunction {
     public  String growthId,str = null;      
     public String searchString{get;set;}
     public List<Opty> optyList {get; set;}
     public  List<Account_Plan__c> listacc=new List<Account_Plan__c>();
     public PageReference pageRef = ApexPages.currentPage();
     public list<String> accountIDs{get;set;}
     public list<String> firstLevelAcctIDs{get;set;}
     public list<String> secondLevelAcctIDs{get;set;}
     public list<String> thirdLevelAcctIDs{get;set;}
     public list<String> fourthLevelAcctIDs{get;set;}
     public list<String> fifthLevelAcctIDs{get;set;}
      /**
   * @description: Constructor for PickBUGrowthOpportunityJunction  controller  
    * @param: parameter - ApexPages.StandardSetController controller
    */              
       public PickBUGrowthOpportunityJunction (ApexPages.StandardSetController controller)
         {
            growthId= ApexPages.currentPage().getParameters().get('id');
          BU_Growth_Strategy__c bug=[Select bu.BU_Plan__c From BU_Growth_Strategy__c bu where bu.Id= :growthId];
            listAcc=[Select a.Primary_AccountAccount__c,a.Name,a.CurrencyIsoCode From Account_Plan__c a where a.Id in (Select b.Account_Plan__c From Business_Unit_Plan__c b where b.Id  = :bug.BU_Plan__c )];
         }
         /**
    * @description: Returns Opportunities
    * @return: parameter - List<Opty> List of Opportunities  
    */           
        
        public List<Opty> getopps()
        {
            if(optyList == null)
            {
                optyList = new List<Opty>();
                for(Account_Plan__c acctPlan:listAcc)
                    str= acctPlan.Primary_AccountAccount__c;
                    
                accountIDs = new list<String>();
                firstLevelAcctIDs = new list<String>();
                secondLevelAcctIDs = new list<String>();
                thirdLevelAcctIDs = new list<String>();
                fourthLevelAcctIDs = new list<String>();
                fifthLevelAcctIDs = new list<String>();
                List<Account> children = [select id from Account where parentID = :str limit 1000];
           if (children.size() > 0)  {
              For(Account a : children)
               {
                    firstLevelAcctIDs.add(a.id);
               }
               children = [select id from Account where parentID in :firstLevelAcctIDs limit 1000];
               if (children.size() > 0)  {
                           for(Account a: children)
                           {
                               secondLevelAcctIDs.add(a.id);
                           }
                           children = [select id from Account where parentID in :secondLevelAcctIDs limit 1000];
                           if (children.size() > 0)  {
                               for(Account a: children)
                               {
                                   thirdLevelAcctIDs.add(a.id);
                               }
                               children = [select id from Account where parentID in :thirdLevelAcctIDs limit 1000];
                               if (children.size() > 0)  {                           
                                   for(Account a: children)
                                   {
                                       fourthLevelAcctIDs.add(a.id);
                                   }
                                   children = [select id from Account where parentID in :fourthLevelAcctIDs limit 1000];
                                   if (children.size() > 0)  {
                                       for(Account a: children)
                                       {
                                           fifthLevelAcctIDs.add(a.id);
                                       }
                                   }
                               }
                           }
                       }
                }                    
                    
                  accountIDs.add(str); 
                  accountIDs.addAll(firstLevelAcctIDs);       
                  accountIDs.addAll(secondLevelAcctIDs);
                  accountIDs.addAll(thirdLevelAcctIDs);
                  accountIDs.addAll(fourthLevelAcctIDs);
                  accountIDs.addAll(fifthLevelAcctIDs);  
                for(Opportunity c: [Select  Name, Id, CloseDate, AccountId From Opportunity  where AccountId in :accountIDs and StageName Not in('06 - Won, Deploy & Expand','Lost','HP Not Pursued','Error') limit 50000]) {
                  optyList.add(new Opty(c));
                }
            }
                return optyList;
        }
        
       //Navigate to BUGrouth Strategy detail page
        public PageReference Cancel()
        {
            Pagereference pageRef = new PageReference('/' + growthId);
            return pageref;
        }
        
        /**
        * @description: Adding Selectd Opportunities to Opportunity-BU Growth Strategy junction object 
        */   
        public PageReference processSelected()
        {
                Pagereference pageRef = new PageReference('/' + growthId);
                List<Opportunity> selectedOpties = new List<Opportunity>();

                for(Opty op: getopps()) {
                        if(op.selected == true) 
                    selectedOpties.add(op.Opp1);        
                }
             List<Related_BU_Growth_Opportunities__c> sIopJunc = new List<Related_BU_Growth_Opportunities__c>();
            if(selectedOpties.size()>0)
            {           
            for(Opportunity Opp1:SelectedOpties)
            {
                    Related_BU_Growth_Opportunities__c buOpp=new  Related_BU_Growth_Opportunities__c();                   
                    buOpp.BU_Growth_Strategy__c=growthId;
                    buOpp.Opportunity__c= Opp1.Id;
                    buOpp.Unique_Key_RBUO__c=Opp1.Id+growthId;                                        
                    sIopJunc.add(buOpp);                    
                    system.debug('BUGrouth opportunity junction'+sIopJunc);                                                                            
             }            
               database.insert(sIopJunc,false);
                pageRef.setRedirect(true);        
                return pageRef;
           }        
        
        else{
             return null;
            }
        }
         
        //Wrapper Class to hold selected Opportunities         
        public class Opty {
            public Opportunity Opp1 {get; set;}
            public Boolean selected {get; set;}
            public Opty(Opportunity o) {
            Opp1 = o;
            selected = false;
            }
        }
        // To search the available Opportunities associated to Account.
        public PageReference search() {
             optyList.clear();
            List<Opty> results=runSearch(searchString);
            return null;
        }
         
        public List<Opty> runSearch(String searchString)
        {
                // TODO prepare query string for complex serarches & prevent injections
                String Soql = 'Select  o.Name, o.Id, o.CloseDate, o.AccountId From Opportunity o';
                String whereCondition = '';
                if(searchString != null && searchString != ''){
                searchString = searchString.replaceAll('\\*','%');  
                searchstring=searchstring.replaceAll('%','');
                whereCondition = whereCondition +  ' o.AccountId In (:str) and o.name LIKE \'' +'%' + searchString +'%\'  and';
                whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);                         
                        }
                else{
                whereCondition=' where' +  ' o.AccountId In (:str)';}
                        soql= soql + whereCondition + ' limit 5000';
                        List<Opportunity> opplist =new List<Opportunity>();
                        opplist=database.query(soql); 
        
                   for(Opportunity opp: opplist){
                        
                        optyList.add(new Opty(opp));
                        
                     }
        
                        return optyList;
        }
 /**
    * @description: Return true if Opportunity list is empty   
    */
    public boolean getIsPickOptyListEmpty(){
        boolean retValue = false;
        if (optyList== null || optyList.size() < 1) {
            retValue = true;
        }
        return retvalue;
    }
  
 

}