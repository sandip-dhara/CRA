public class controllerforcomponent{

public string learningBoard{get;set;}
public List<Learning_Board__c> learningBoardList{get;set;}
public String sQuery;
public List<Learning_Board__c> getRecords() {
        sQuery='';
         sQuery = sQuery + 'select id,name,description__c from ' + learningBoard;
         system.debug('squery:'+squery);
         learningBoardList = new LIst<Learning_Board__c>();
         learningBoardList = database.query(sQuery);
         if(learningBoardList.size() != null && learningBoardList.size()>0)
             return learningBoardList;
         else
             return null;
  }
}