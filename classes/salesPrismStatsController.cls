public with sharing class salesPrismStatsController 
{
    
    public list<String> AcctID { get; set; }
    public String accountId { get; set; }
    public salesprism__Account_Details__c[]  stats { get; set; }
    
    public salesPrismStatsController(ApexPages.StandardController std)
    {
      
        accountId = [select primary_accountaccount__c from Account_Plan__c where id = :std.getId()].primary_accountaccount__c;
        AcctID = new list<String>();
        AcctID.add(accountId);
        System.debug('***********accountid*****************'+AcctID);
        
    }
    
    public List<salesprism__Account_Details__c> getStatsList()
    {
        return [Select s.salesprism__Account_ID__c, s.Name,s.salesprism__Alert_Count__c, s.salesprism__Play_Count__c, s.salesprism__Alert_Text__c, s.salesprism__Potential_New_Contacts__c, s.salesprism__Likelihood__c, s.salesprism__Total_Potential_Revenue__c From salesprism__Account_Details__c s where salesprism__Account_ID__c = :AcctID];
    }
    
    public String goToPrism()
    {
        salesprism__Properties__c properties = salesprism__Properties__c.getOrgDefaults();
        String matchingField = properties.salesprism__Matching_Field__c;
        Object result = null;
        if(matchingField != null)
        {
            String qryString = 'Select '+ properties.salesprism__Matching_Field__c + ' From Account Where Id = \'' +  accountId + '\'';
            Account foundAccount = (Account)Database.query(qryString);
            result = foundAccount.get(matchingField);
        }
        
        String link = 'https://hp--esit--salesprism.cs10.visual.force.com/apex/salesPRISM?prismAccountId=' + result;
        return link;
    }
    
    public String getLinkToPrism()
    {
        return goToPrism();
    }
    
    public Boolean getIsPrismAccount()
    {
        List<salesprism__Account_Details__c> accountDetails = [select Id,salesprism__Account_ID__c from salesprism__Account_Details__c where 
                                                        salesprism__Account_ID__c = :accountId];
        return accountDetails.size() > 0;
    }
    
}