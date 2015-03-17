Public class MyTrendsLike{
    
    public void TLikes(){
        
        AggregateResult[] groupedResults = [SELECT Count(Id) Con,Liked_Item_ID__r.Item_Identifier__c value FROM User_Liked_Item__c WHERE LastModifiedDate >= N_DAYS_AGO:2 and Liked_Item_ID__c in (SELECT Id FROM Liked_Item__c where Item_Name__c = 'Learning Board') GROUP BY  Liked_Item_ID__r.Item_Identifier__c order by count(id) desc];
        system.debug('groupedResults'+groupedResults);
        system.debug('String.ValueOf(Liked_Item_ID__r.Item_Identifier__c)'+string.ValueOf(groupedResults[0].get('value')));
        
        Map<ID,integer> TMap;
        TMap = new Map<ID,integer>();
        List<string> ULIList;
        ULIList = new List<string>();
    
        for (AggregateResult GR : groupedResults){
            system.debug('String.ValueOf(Liked_Item_ID__r.Item_Identifier__c)'+string.ValueOf(GR.get('value')));
            TMap.Put(string.ValueOf(GR.get('value')),integer.ValueOf(GR.get('Con')));
            ULIList.add(string.ValueOf(GR.get('value')));
            
        }
        system.debug('TMap'+TMap);
        system.debug('ULIList'+ULIList);
        list<Learning_Board__c> TLBList= [select id,name,name__c from Learning_Board__c where id =:ULIList];
        system.debug('TLBList'+TLBList);
        List<LearningBoardCustomClass> lbresult= new List<LearningBoardCustomClass>();
        system.debug('lbresult'+lbresult);
        system.debug('groupedResults'+groupedResults);
        for (AggregateResult GR : groupedResults){
            for (Learning_Board__c LB : TLBList){
                if(LB.id == GR.get('value')){
                    LearningBoardCustomClass lbcc= new LearningBoardCustomClass();
                    lbcc.LBID = LB.id;
                    lbcc.LBName = LB.name;
                    lbcc.LBNoOfLikes = TMap.get(LB.id);
                    lbresult.add(lbcc);
                }
            }
        }
        system.debug('lbresult'+lbresult);
        
    }
     Public class LearningBoardCustomClass{
        public id LBID{get;set;}        
        public String LBName{get;set;}
        public integer LBNoOfLikes{get;set;}
    }
    
    
   /* public Static void sortList(List<LearningBoardCustomClass> items, String sortField, String order){


       List<LearningBoardCustomClass> resultList = new List<LearningBoardCustomClass>();
   
        //Create a map that can be used for sorting 
       Map<object, List<LearningBoardCustomClass>> objectMap = new Map<object, List<LearningBoardCustomClass>>();
           
       for(LearningBoardCustomClass ob : items){
                if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(sortField), new List<LearningBoardCustomClass>()); 
                }
                objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(LearningBoardCustomClass ob : resultList){
                items.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        }
    }*/
}