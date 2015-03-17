public class LearningBoardSearch {

    public PageReference processSelected() {
        return null;
    }


    public String LearningBoardSearch { get; set; }

    public PageReference add() {
        return null;
    }


    public String LearningBoardName { get; set; }

  String searchText;
   List<Learning_Board__c> results;

public String getSearchText() {
      return searchText;
   }

   public void setSearchText(String s) {
      searchText = s;
   }

   public List<Learning_Board__c> getResults() {
      return results;
   }
    public PageReference search() {
    results = [select Name,name__c from learning_board__c where name__c like 'cloud%'];
        return null;
    }

}