public class ODP_Extension_VisualPortal {
        public boolean IsBizEngaPartners{get;set;}

    public integer OpptunityCount{get;set;}
    

    public integer contributorCount{get;set;}
    
    public integer reviewCount{get;set;}
    
    public integer approvalCount{get;set;}
    
    public string CurUserId {get;set;}

    public ODP_Extension_VisualPortal(ApexPages.StandardSetController controller) {
        IsBizEngaPartners = ODP_Class_CommonTools.IsBizEngaPartner();
        CurUserId = UserInfo.getUserId();
        AggregateResult[] resultGroup = [select Release_Role__r.Offering_Release__c from Core_Team_Member__c where User__c=:CurUserId  and (Release_Role__r.Offering_Release__r.Status__c != 'Complete' or Release_Role__r.Offering_Release__r.Status__c != 'Cancelled') group by Release_Role__r.Offering_Release__c ];
        List<String> OpportunityGroup = new List<String>();
        for(AggregateResult ar : resultGroup)  {
            OpportunityGroup.Add((String)ar.get('Offering_Release__c'));
        }
        OpptunityCount = OpportunityGroup.size();

        contributorCount = [select Count() from Contributor__c where Team_Members__r.User__c=:CurUserId and Completed__c=false and Stage_Work_Element__r.Status__c='In Progress'];
        integer countTemp = [select Count() from Stage_Work_Element__c where Accountable_Team_Member__r.User__c=:CurUserId and Status__c='Ready For Review'];
        contributorCount += countTemp;
        
        reviewCount = [select Count() from Review__c where Team_Member__r.User__c=:CurUserId and Complete__c=false and Stage_Work_Element__r.Status__c='Under Review'];
        countTemp = [select Count() from Stage_Work_Element__c where Accountable_Team_Member__r.User__c=:CurUserId and Status__c='Review Complete'];
        reviewCount += countTemp;
        
        approvalCount =[select count() from Stage_Review__c where (PAC_Member_ID__r.User__c=:CurUserId or Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c=:CurUserId) and Complete__c=false and Release_Stage_ID__r.status__c ='In Review']; 
   }
    
    public class RAResult{ 
        public Boolean Status{get;set;}
        public String Result{get;set;}
        public Integer Total{get;set;}
    }
   
    @RemoteAction
    public static RAResult getMyOpportunitys(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            AggregateResult[] resultGroup = [select Release_Role__r.Offering_Release__c from Core_Team_Member__c where User__c=:myID and (Release_Role__r.Offering_Release__r.Status__c != 'Complete' or Release_Role__r.Offering_Release__r.Status__c != 'Cancelled') group by Release_Role__r.Offering_Release__c ];
            List<String> OpportunityGroup = new List<String>();
            for(AggregateResult ar : resultGroup)  {
                OpportunityGroup.Add((String)ar.get('Offering_Release__c'));
            }
            integer OpptunityCount = OpportunityGroup.size();
            
            string queryString = 'select Id,Name__c,Facilitator__c,Facilitator__r.name,Facilitator__r.SmallPhotoUrl,Facilitator__r.email,Offering_Category__c,status__c,CreatedDate,LastModifiedDate,Practice__c from Offering_Release__c where id in :OpportunityGroup order by '+sortColumn+' '+direction;
    
            List<Offering_Release__c> OpportunityList = database.query(queryString);
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(OpportunityList );
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            List<Offering_Release__c> returnOpportunitys = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = OpptunityCount ;
            ra.Result = '[';
            for(Offering_Release__c orc:returnOpportunitys){
                ra.Result += '{';
                ra.Result += '"id":"'+orc.id+'",';
                ra.Result += '"name":"'+orc.Name__c+'",';
                ra.Result += '"email":"'+orc.Facilitator__r.email+'",';
                ra.Result += '"photo":"'+orc.Facilitator__r.SmallPhotoUrl+'",';
                ra.Result += '"bep":"'+orc.Facilitator__r.name+'",';
                ra.Result += '"sponsor":"'+orc.Practice__c +'",';
                ra.Result += '"category":"'+orc.Offering_Category__c+'",';
                ra.Result += '"status":"'+orc.status__c+'",';
                ra.Result += '"created":"'+orc.CreatedDate+'",';
                ra.Result += '"modified":"'+orc.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
    
    @RemoteAction
    public static RAResult getMyContributions(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            
            
            integer contributionCount = [select Count() from Contributor__c where Completed__c=false and Team_Members__r.User__c=:myID and Stage_Work_Element__r.Status__c='In Progress'];
            string queryString = 'select Id,LastModifiedDate,Stage_Work_Element_Name__c,Role_Name__c,Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email, Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Release_Name__c, Stage_Work_Element__r.Status__c,Team_Members__r.Id from Contributor__c where' + 
            ' Completed__c=false and Team_Members__r.User__c=:myID and Stage_Work_Element__r.Status__c=\'In Progress\' order by '+sortColumn+' '+direction;
            LIST<Contributor__c> contributionList = database.query(queryString);
            
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(contributionList);
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            LIST<Contributor__c> returnContributions = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = contributionCount;
            ra.Result = '[';
            for(Contributor__c con:returnContributions){
                ra.Result += '{';
                ra.Result += '"id":"'+con.id+'",';
                ra.Result += '"swe":"'+con.Stage_Work_Element_Name__c+'",';
                ra.Result += '"role":"'+con.Role_Name__c+'",';
                ra.Result += '"email":"'+con.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email+'",';
                ra.Result += '"photo":"'+con.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl+'",';
                ra.Result += '"owner":"'+con.Stage_Work_Element__r.Accountable_User__c+'",';
                ra.Result += '"stage":"'+con.Stage_Work_Element__r.Stage_Name__c+'",';
                ra.Result += '"opportunity":"'+con.Stage_Work_Element__r.Release_Name__c+'",';
                ra.Result += '"status":"'+con.Stage_Work_Element__r.Status__c+'",';
                ra.Result += '"modified":"'+con.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
    
    @RemoteAction
    public static RAResult getMyConAccountable(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            LIST<Contributor__c> accList = [select id,Stage_Work_Element__r.id from Contributor__c where Stage_Work_Element__r.Accountable_Team_Member__r.User__c=:myID and Stage_Work_Element__r.Status__c='Ready For Review'];
            
            set<id> setSWEIds = new Set<id>();
            set<id> setConIds = new Set<id>();
            for(Contributor__c con:accList){
                if(!setSWEIds.Contains(con.Stage_Work_Element__r.id)){
                    setSWEIds.Add(con.Stage_Work_Element__r.id);
                    setConIds.Add(con.id);
                }
            }
            
            integer contributionCount = [select Count() from Contributor__c where id in :setConIds];
            string queryString = 'select Id,LastModifiedDate,Stage_Work_Element_Name__c,Role_Name__c,Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email,Stage_Work_Element__r.Accountable_Process_Role_Name__c, Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Release_Name__c, Stage_Work_Element__r.Status__c,Team_Members__r.Id from Contributor__c where' + 
            ' id in :setConIds order by '+sortColumn+' '+direction;
            LIST<Contributor__c> contributionList = database.query(queryString);
            
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(contributionList);
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            LIST<Contributor__c> returnContributions = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = contributionCount;
            ra.Result = '[';
            for(Contributor__c con:returnContributions){
                ra.Result += '{';
                ra.Result += '"id":"'+con.id+'",';
                ra.Result += '"swe":"'+con.Stage_Work_Element_Name__c+'",';
                ra.Result += '"role":"'+con.Stage_Work_Element__r.Accountable_Process_Role_Name__c+'",'; 
                ra.Result += '"owner":"'+con.Stage_Work_Element__r.Accountable_User__c+'",';
                ra.Result += '"photo":"'+con.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl+'",';
                ra.Result += '"email":"'+con.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email+'",';
                ra.Result += '"stage":"'+con.Stage_Work_Element__r.Stage_Name__c+'",';
                ra.Result += '"opportunity":"'+con.Stage_Work_Element__r.Release_Name__c+'",';
                ra.Result += '"status":"'+con.Stage_Work_Element__r.Status__c+'",';
                ra.Result += '"modified":"'+con.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
    
    @RemoteAction
    public static RAResult getMyReviews(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            integer reviewsCount = [select Count() from Review__c where Complete__c=false and  (Team_Member__r.User__c=:myID or Stage_Work_Element__r.Accountable_Team_Member__r.User__c=:myID) and (Stage_Work_Element__r.Status__c='Under Review' or Stage_Work_Element__r.Status__c='Review Complete')]; //
            
            string queryString = 'select Id,Stage_Work_Element_Name__c,LastModifiedDate,Role_Name__c,Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email, Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Release_Name__c, Stage_Work_Element__r.Status__c  from Review__c where Complete__c=false and (Team_Member__r.User__c=:myID or Stage_Work_Element__r.Accountable_Team_Member__r.User__c=:myID) and (Stage_Work_Element__r.Status__c=\'Under Review\' or Stage_Work_Element__r.Status__c=\'Review Complete\') order by '+sortColumn+' '+direction; 
            LIST<Review__c> reviewList = database.query(queryString); 
            
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(reviewList);
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            LIST<Review__c> returnReviews = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = reviewsCount;
            ra.Result = '[';
            for(Review__c rev:returnReviews){
                ra.Result += '{';
                ra.Result += '"id":"'+rev.id+'",';
                ra.Result += '"swe":"'+rev.Stage_Work_Element_Name__c+'",';
                ra.Result += '"role":"'+rev.Role_Name__c+'",';
                ra.Result += '"owner":"'+rev.Stage_Work_Element__r.Accountable_User__c+'",'; 
                ra.Result += '"photo":"'+rev.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl+'",';
                ra.Result += '"email":"'+rev.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email+'",';
                ra.Result += '"stage":"'+rev.Stage_Work_Element__r.Stage_Name__c+'",';
                ra.Result += '"opportunity":"'+rev.Stage_Work_Element__r.Release_Name__c+'",';
                ra.Result += '"status":"'+rev.Stage_Work_Element__r.Status__c+'",';
                ra.Result += '"modified":"'+rev.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
    
    @RemoteAction
    public static RAResult getMyRevAccountable(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            LIST<Review__c> accList = [select id,Stage_Work_Element__r.id from Review__c where Stage_Work_Element__r.Accountable_Team_Member__r.User__c=:myID and Stage_Work_Element__r.Status__c='Review Complete'];
            
            set<id> setSWEIds = new Set<id>();
            set<id> setRevIds = new Set<id>();
            for(Review__c rev:accList){
                if(!setSWEIds.Contains(rev.Stage_Work_Element__r.id)){
                    setSWEIds.Add(rev.Stage_Work_Element__r.id);
                    setRevIds.Add(rev.id);
                }
            }
            
            integer reviewsCount = [select Count() from Review__c where id in :setRevIds];
            string queryString = 'select Id,Stage_Work_Element_Name__c,LastModifiedDate,Role_Name__c,Stage_Work_Element__r.Accountable_User__c,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl,Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email, Stage_Work_Element__r.Stage_Name__c,Stage_Work_Element__r.Release_Name__c, Stage_Work_Element__r.Status__c  from Review__c where' + 
            ' id in :setRevIds order by '+sortColumn+' '+direction;
            LIST<Review__c> reviewList = database.query(queryString);
            
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(reviewList);
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            LIST<Review__c> returnReviews = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = reviewsCount;
            ra.Result = '[';
            for(Review__c rev:returnReviews){
                ra.Result += '{';
                ra.Result += '"id":"'+rev.id+'",';
                ra.Result += '"swe":"'+rev.Stage_Work_Element_Name__c+'",';
                ra.Result += '"role":"'+rev.Role_Name__c+'",';
                ra.Result += '"owner":"'+rev.Stage_Work_Element__r.Accountable_User__c+'",';
                ra.Result += '"photo":"'+rev.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.SmallPhotoUrl+'",';
                ra.Result += '"email":"'+rev.Stage_Work_Element__r.Accountable_Team_Member__r.User__r.email+'",';
                ra.Result += '"stage":"'+rev.Stage_Work_Element__r.Stage_Name__c+'",';
                ra.Result += '"opportunity":"'+rev.Stage_Work_Element__r.Release_Name__c+'",';
                ra.Result += '"status":"'+rev.Stage_Work_Element__r.Status__c+'",';
                ra.Result += '"modified":"'+rev.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
    
    @RemoteAction
    public static RAResult getMyApprovals(String page, string sortColumn, string direction) {
        try{
            string myID = UserInfo.getUserId();
            integer approvalsCount =[select count() from Stage_Review__c where (PAC_Member_ID__r.User__c=:myID or Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c=:myID) and Complete__c=false and Release_Stage_ID__r.status__c ='In Review']; 
                        
            string queryString = 'select Id,Release_Stage_ID__c,Stage_Name__c,Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name,Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.SmallPhotoUrl,Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email, Release_Stage_ID__r.Release_Name__c,Release_Stage_ID__r.status__c,CreatedDate,LastModifiedDate from Stage_Review__c where (PAC_Member_ID__r.User__c=:myID or Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__c=:myID) and Complete__c=false and Release_Stage_ID__r.status__c =\'In Review\' order by '+sortColumn+' '+direction; 
            LIST<Stage_Review__c> approvalsList = database.query(queryString);
            
            ApexPages.StandardSetController ContriPagination= new ApexPages.StandardSetController(approvalsList);
            ContriPagination.setPageSize(10);
            ContriPagination.setpageNumber(integer.ValueOf(page));
            LIST<Stage_Review__c> returnApprovals = ContriPagination.getRecords();
            
            RAResult ra = new RAResult();
            ra.Status = true;
            ra.Total = approvalsCount;
            ra.Result = '[';
            for(Stage_Review__c apr: returnApprovals){
                ra.Result += '{';
                ra.Result += '"id":"'+apr.Release_Stage_ID__c+'",';
                ra.Result += '"opportunity":"'+apr.Release_Stage_ID__r.Release_Name__c+'",';
                ra.Result += '"stage":"'+apr.Stage_Name__c+'",';
                ra.Result += '"bep":"'+apr.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.Name+'",';
                ra.Result += '"photo":"'+apr.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.SmallPhotoUrl+'",';
                ra.Result += '"email":"'+apr.Release_Stage_ID__r.Offering_Release_ID__r.Facilitator__r.email+'",';
                ra.Result += '"status":"'+apr.Release_Stage_ID__r.status__c+'",';
                ra.Result += '"modified":"'+apr.LastModifiedDate+'"},';
            }
            ra.Result = ra.Result.Substring(0,ra.Result.length()-1);
            ra.Result += ']';
            
            return ra;
        }
        catch(Exception e){
            RAResult ra = new RAResult();
            ra.Status = false;
            ra.Result = e.getMessage();
            return ra;
        }
    }
}