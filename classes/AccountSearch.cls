public class AccountSearch {
 
  String searchText;
   List<Account> results;
 
public String getSearchText() {
      return searchText;
   }
 
   public void setSearchText(String s) {
      searchText = s;
   }
 
   public List<Account> getResults() {
      return results;
   }
    public PageReference search() {
    results = (List<Account>)[FIND :searchText RETURNING Account(Name, Industry, Rating)][0];  
        return null;
    }
 
}