public with sharing class AcctPlan360ViewController {

    public list<String> accountIDs{get;set;}
    public list<String> firstLevelAcctIDs{get;set;}
    public list<String> secondLevelAcctIDs{get;set;}
    public list<String> thirdLevelAcctIDs{get;set;}
    public list<String> fourthLevelAcctIDs{get;set;}
    public list<String> fifthLevelAcctIDs{get;set;}
    
    public string mainAcctID{get;set;}
    
       
    public AcctPlan360ViewController(ApexPages.StandardController std)
    {
       mainAcctID = [select primary_accountaccount__c from Account_Plan__c where id = :std.getId()].primary_accountaccount__c;
       accountIDs = new list<String>();
       firstLevelAcctIDs = new list<String>();
       secondLevelAcctIDs = new list<String>();
       thirdLevelAcctIDs = new list<String>();
       fourthLevelAcctIDs = new list<String>();
       fifthLevelAcctIDs = new list<String>();
       List<Account> children = [select id from Account where parentID = :mainAcctID limit 1000];
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
        accountIDs.add(mainAcctID);
        accountIDs.addAll(firstLevelAcctIDs);       
        accountIDs.addAll(secondLevelAcctIDs);
        accountIDs.addAll(thirdLevelAcctIDs);
        accountIDs.addAll(fourthLevelAcctIDs);
        accountIDs.addAll(fifthLevelAcctIDs);
        System.debug('account levels ' + accountIDs);                
    }
        
    public list<Opportunity> getoptyList(){
        return [Select o.Name, o.CloseDate, o.OwnerId, o.Amount, o.AccountId,o.StageName From Opportunity o where accountID in :accountIDs and StageName Not in('06 - Won, Deploy & Expand','Lost','HP Not Pursued','Error') order by o.Amount desc NULLS LAST  limit 20];
    }
    
    public List<Case> getCaseList(){
        return [Select c.AccountId, c.Subject, c.ContactId, c.Status From Case c where accountID in :accountIDs and isclosed = false order by createdDate asc limit 20];
    }
    
    public List<Task> getTaskList(){
    return [Select t.OwnerId, t.Subject, t.ActivityDate, t.Status, t.Priority, t.AccountId From Task t where accountID in :accountIDs and IsClosed = false order by activityDate asc limit 20];
        //return [Select t.AccountId, t.Subject, t.Status, t.WhoId, t.Priority, t.ActivityDate From Task t where accountID in :accountIDs and IsClosed = false order by activityDate asc limit 7];
    }
    
    public List<Event> getEventList(){
        return [Select e.OwnerId, e.Subject, e.StartDateTime, e.EndDateTime, e.AccountId From Event e where accountID in :accountIDs order by activityDate asc limit 20];
    } 
    
     public List<Contract_Reference__c> getContractList(){
           /* List<Contract_Reference__c> salesDocNum = [Select Sales_Doc_Nbr__c from Contract_Reference__c where Accounts__c = :mainAcctID];
            List<String> salesDocNums = new List<String>();
            for(Contract_Reference__c c: salesDocNum) { 
               salesDocNums.add(c.Sales_Doc_Nbr__c);
            }
            List<OpportunityLineItem> product = [SELECT Product__c FROM OpportunityLineItem where Sales_Doc_Nbr__c in :salesDocNums];

            List<String> products = new List<String>();
            for(OpportunityLineItem p:product){
            products.add(p.Product__c);
            }
            List<Product2> leadBU = [SELECT GBU__c FROM Product2 where Id in :products]; */
            //and Renewal_Month_Year__c < '+getTargetDate()+' and Renewal_Month_Year__c > '+DateTime.now()+'
            //return [Select e.Sales_Doc_Nbr__c, e.Contract_Start_Date__c, e.Total_Contract_Value__c, e.Contract_Length_in_Months__c, e.Renewal_Month_Year__c From Contract_Reference__c e where e.Accounts__c = :mainAcctID];
           // return [SELECT Sales_Doc_Nbr__c, Name, Contract_Start_Date__c, Total_Value__c, Renewal_Month_Year__c, convertCurrency(Total_Contract_Value__c), Contract_Length_in_Months__c, CurrencyIsoCode, (SELECT GBU__c, Business_Group__c FROM Opportunity_Product__r) FROM Contract_Reference__c];// where Accounts__c = :mainAcctID order by Total_Contract_Value__c desc limit 20
            //return[SELECT Sales_Doc_Nbr__c, Name, Contract_Start_Date__c, total_contract_value_formula__c , Renewal_Month_Year__c, Total_Contract_Value__c, Contract_Length_in_Months__c, CurrencyIsoCode, (SELECT GBU__c, Business_Group__c FROM Opportunity_Product__r) FROM Contract_Reference__c ORDER BY total_contract_value_formula__c DESC NULLS LAST];
             return[SELECT Sales_Doc_Nbr__c, Name, Contract_Start_Date__c, total_contract_value_formula__c , Renewal_Month_Year__c, Total_Contract_Value__c, Contract_Length_in_Months__c, CurrencyIsoCode, (SELECT GBU__c, Business_Group__c, Product_Line__c FROM Opportunity_Product__r) FROM Contract_Reference__c where Accounts__c = :mainAcctID and Contract_End_date__c >= TODAY and Contract_End_date__c <= NEXT_N_MONTHS:24 ORDER BY Total_Contract_Value__c desc limit 20];   
            //SELECT Sales_Doc_Nbr__c, Name, Contract_Start_Date__c, Total_Value__c, Renewal_Month_Year__c, convertCurrency(Total_Contract_Value__c), Contract_Length_in_Months__c, CurrencyIsoCode, (SELECT GBU__c, Business_Group__c FROM Opportunity_Product__r) FROM Contract_Reference__c where Accounts__c = :mainAcctID order by Total_Contract_Value__c desc limit 20
    } 

   /* public List<Product2> getLeadBU(){
            List<Contract_Reference__c> salesDocNum = [Select Sales_Doc_Nbr__c from Contract_Reference__c where Accounts__c = :mainAcctID];
            List<String> salesDocNums = new List<String>();
            for(Contract_Reference__c c: salesDocNum) { 
               salesDocNums.add(c.Sales_Doc_Nbr__c);
            }
            List<OpportunityLineItem> product = [SELECT Product__c FROM OpportunityLineItem where Sales_Doc_Nbr__c in :salesDocNums];

            List<String> products = new List<String>();
            for(OpportunityLineItem p:product){
            products.add(p.Product__c);
            }
            return [SELECT GBU__c FROM Product2 where Id in :products];

            //return leadBU;  
     }  
    private String DateStr;     
     
    Public String getTargetDate() {
        if (DateStr==null){
            DateTime t = DateTime.now();
            t = t.addYears(2);
            DateStr = t.format('yyyy-MM-dd'); //formatting complies with SOQL
        }
        return DateStr; 
    }  */

    
}