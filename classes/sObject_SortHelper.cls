public class sObject_SortHelper {  
  
 public static void sortList(List<Sobject> items, String sortField, String order){


       List<Sobject> resultList = new List<Sobject>();
  
        //Create a map that can be used for sorting
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
          
       for(Sobject ob : items){
                if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(sortField), new List<Sobject>());
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
            for(Sobject ob : resultList){
                items.add(ob);
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]); 
            }
        }
    }
    }