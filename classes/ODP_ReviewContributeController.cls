public with sharing class ODP_ReviewContributeController 
{

    public LIST<Contributor__c> contributors {get;set;}
    public LIST<Review__c> deliverableReview{get;set;}
    
    public string UserId {get;set;}
    public boolean JustMyRecords {get;set;}
    
    public ODP_ReviewContributeController (){
        JustMyRecords = true;
        UserId = UserInfo.getUserId();
        doQuery();
    }
    
    private void doQuery()
    {
        string WhereThisUser = '';
        string queryString = '';
        
        // Contributors
        if ( JustMyRecords ) 
            {WhereThisUser = ' WHERE Team_Members__r.User__r.Id = \'' + UserId + '\' '; }
            else
            {WhereThisUser = ' WHERE Team_Members__c != null ';}
          queryString = 'SELECT id,name,Team_Member_Name__c,Role_Name__c,Completed__c,Stage_Work_Element_Name__c,Team_Members__r.User__r.Id,'+
                        'Stage_Work_Element__r.Work_Element_Name__c,Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c from Contributor__c '+
                        WhereThisUser + 
                        ' ORDER BY CreatedDate';
                     system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%'+queryString );
          contributors = Database.Query(queryString );

       
        // Reviews
        if ( JustMyRecords ) 
            {WhereThisUser = ' WHERE Team_Member__r.User__r.Id = \'' + UserId + '\' '; }
            else
            {WhereThisUser = ' WHERE Team_Member__c != null ';}   
            queryString = 'SELECT id, name, Team_Member_Name__c,Comment__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,Rating__c,'+
                        'Stage_Work_Element__r.Work_Element_Name__c,Stage_Work_Element__r.Release_Stage_ID__r.Release_Name__c,Stage_Work_Element__r.Contribute_Due_Date__c  from Review__c' +
                        WhereThisUser + 
                        ' ORDER BY CreatedDate';                            
          deliverableReview = Database.Query(queryString );
    }
    
    public PageReference MyRecords() {
        JustMyRecords = true;
        doQuery();
        return null;
    }
    public PageReference AllRecords() {
        JustMyRecords = false;
        system.debug('Sree: in All records');
        doQuery();
        return null;
    }

}