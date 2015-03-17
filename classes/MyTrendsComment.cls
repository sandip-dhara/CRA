public class MyTrendsComment{
    public static void TComments(){
		 
        Integer TrendDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostCommentedTrendDays));
        system.debug('NoOfDays' + TrendDays);
        string typeComm='\'' + 'TextPost' + '\'';
       
        //Fetch all the Comments for all learning boards in N number days
        //List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and CreatedDate>= N_DAYS_AGO:TrendDays and ParentId IN (Select id from learning_board__c)];    
         List<FeedItem> feeddItmlst = Database.query('SELECT ParentId FROM FeedItem where Type=' + typeComm + ' and CreatedDate>= N_DAYS_AGO:' + TrendDays + ' and ParentId IN (Select id from learning_board__c)');    
        
		//Making the map of Learning Board Id anf Comment Count        
        Map<String,Integer> CmntCntMap = new Map<String,Integer>();
        system.debug('FI##'+feeddItmlst);
        for (FeedItem feedItm : feeddItmlst){            
            if(!CmntCntMap.containskey(feedItm.ParentId)){
                CmntCntMap.put(feedItm.ParentId,1);
            }
            else{
                integer i = CmntCntMap.get(feedItm.parentId);
                CmntCntMap.put(feedItm.parentId,i+1);            
            }
        }  
        system.debug('CmntCntMap'+CmntCntMap);          
        
		//Making Comment counts in Ascending order in  a list        
        List<integer> CmtCntLst = new List<integer>();
        CmtCntLst.addAll(CmntCntMap.Values());
        CmtCntLst.sort();
        System.debug(' Comment Count Lst' + CmtCntLst);
        
        //Making Comment counts in Descending order in  a list     
        List<integer> CmtCntDscLst = new List<integer>();
        for(Integer i = CmtCntLst.size()-1; i>=0;i--)
        {   
            CmtCntDscLst.add(CmtCntLst.get(i));
        }
		system.debug('CmtCntDscLst' + CmtCntDscLst);       
        
        //Getting Learning Board Ids in to a list 
        List<String> lrngBrdIdLstTmp = new List<string>();
        for(integer i : CmtCntDscLst){
            for(String s : CmntCntMap.keyset()){
                if(i==CmntCntMap.get(s)){
                    lrngBrdIdLstTmp.add(s);                    
                }
            }
        }
        
		Set<String> myset = new Set<String>();
        List<String> finallrngBrdIdLst = new List<String>();
        List<Learning_Board__c> lrngBrdLst=[SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c, Default_Image_Name__c FROM Learning_Board__c where id in:lrngBrdIdLstTmp];
        List<Learning_Board__c> lstLearningBoard=new List<Learning_Board__c>();
        system.debug(' lrngBrdLst ' + lrngBrdLst);
       
        for (String s : lrngBrdIdLstTmp) {
          if (myset.add(s)) {
              finallrngBrdIdLst.add(s); 
              for(Learning_Board__c lb:lrngBrdLst)
              {
                  if(lb.id==s)
                  {
                      lstLearningBoard.add(lb);
                  }
              }
          }            
        }
        
        system.debug(' Final Learning Board Lst ' + finallrngBrdIdLst);
        System.debug(' lstLearningBoard ' + lstLearningBoard);
        
    }
   }