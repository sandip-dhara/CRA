public class LearningSearch {

    //public PageReference add() {return null;}
    public String lrnlst { get; set; }

    //public String getLearningsName { get; set; }

    public String SearchText { get; set; }
 
    //String searchText;
    public List<Learning__c> results{get;set;}
 
    public String learning {get; set;}
    //public String getSearchText() {return searchText;}
 
   //public void setSearchText(String s) {searchText = s;}
 
   //public List<Learning__c> getResults() {return results;}
   
   public List<SelectOption> LearningsName{get;set;}
   
    public pagereference search() {
    results = [select Name,name__c from learning__c where name__c like 'Big%'];
    return null;
    }
    
    public pagereference add1() {
    //results = [select Name,name__c from learning__c where name__c like 'Big%'];
    system.debug('HI');
    return null;
    }


    public  LearningSearch()
    {
         list<SelectOption> learnlist = new List<SelectOption>() ;
         List<Learning__c> lrnlst=new List<Learning__c>();
         LearningsName = new List<SelectOption>();
         for(Learning__c lrn:[select Name,Name__c from Learning__c where name__c like 'Big%'])
         {
          learnlist.add(new SelectOption(lrn.Name,lrn.Name__c)) ;
         }
         LearningsName = learnlist ; 
    } 
}