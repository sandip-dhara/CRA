public with sharing class ReviewCustomPageController 
{

    public string StageApprovalId {get;set;}
    
    //public LIST<Stage_Approval__c> stageApprovals {get;set;}
    public LIST<Contributor__c> contributors {get;set;}
    public LIST<Review__c> deliverableReview{get;set;}
    
    public string UserId {get;set;}
    public boolean JustMyRecords {get;set;}
    
    public ReviewCustomPageController(){
        StageApprovalId = null;
        JustMyRecords = true;
        UserId = UserInfo.getUserId();
        doQuery();
    }
    
    private void doQuery()
    {
        string WhereThisUser = '';
        string queryString = '';
        
//        List<Contributor__c> queryString = new List<Contributor__c>();
  //      List<Review__c> queryString1 = new List<Review__c>();
        
        // Contributors
        if ( JustMyRecords ) WhereThisUser = ' WHERE Team_Member__r.User__r.Id = \'' + UserId + '\' ';                  
          queryString = 'SELECT id, name, Team_Member_Name__c,Comment__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,Rating__c,'+
                        'Stage_Work_Element__r.Work_Element_Name__c  from Review__c' +
                        WhereThisUser + 
                        ' ORDER BY CreatedDate';                            
          deliverableReview = Database.Query(queryString );
       
        //contributors = Database.Query(queryString);  // queryString = String.escapeSingleQuotes(queryString);
       // system.debug('##########queryString'+queryString);
        //system.debug('##########contributors'+contributors);
        
        
        // Reviews


 /*       if ( !JustMyRecords )
        {
        //queryString1 = [SELECT id, name, Team_Member_Name__c,Rating__c,Comment__c,Role__c,Complete__c,Stage_Work_Element__c
        //               from Review__c dr ORDER BY CreatedDate];
//        queryString1 = [SELECT id, name, Team_Member_Name__c,Comment__c,Role_Name__c,Complete__c,Stage_Work_Element__c,Stage_Work_Element__r.Work_Element_Name__c
  //                     from Review__c ORDER BY CreatedDate];   
        string q1 = 'SELECT id, name, Team_Member_Name__c,Comment__c,Role_Name__c,Complete__c,Stage_Work_Element_Name__c,Rating__c,Stage_Work_Element__r.Work_Element_Name__c  from Review__c ORDER BY CreatedDate';                            
        deliverableReview = Database.Query(q1);
        system.debug('Sree : queryString1'+q1);
        system.debug('Sree : deliverableReview'+deliverableReview);
       
        }*/
         //return queryString1;
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