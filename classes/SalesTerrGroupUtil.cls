public class SalesTerrGroupUtil {
	
	
	public static void salesTerrAfterInsert(List<Sales_Territory__c> TriggerNew){
		
		try{
			List<Group> groupList = new List<Group>();
			List<Sales_Territory__c> stList =  new List<Sales_Territory__c>();
			Map<String, Id> grpIdSTMap = new Map<String, Id> ();
			
			for(Sales_Territory__c salesT : TriggerNew)
	            {
	        	 	if(salesT.IsActive__c == true){
		                Group grp = new Group(Name = ('' + salesT.GroupAutoNum__c));  
		                groupList.add(grp);
	        	 	}
	            }
	        if(!groupList.isEmpty()){
	            insert groupList;
	        }
	        for(Group g : groupList){
	            grpIdSTMap.put(g.Name, g.Id);
	        }
	    
	       for(Sales_Territory__c sTObj : TriggerNew)
	        {
	            Sales_Territory__c tempSTObj = new Sales_Territory__c(Id = sTObj.Id, GroupId__c = grpIdSTMap.get('' + sTObj.GroupAutoNum__c));
	            stList.add(tempSTObj);
	        }
	        if(!stList.isEmpty()){
	        	update stList;
	        }
	        
		}catch(Exception e){
			system.debug('*****Exception in salesTerrAfterInsert****' + e.getMessage());
		}
	}
	
	public static void salesTerrAfterUpdate(List<Sales_Territory__c> TriggerNew, List<Sales_Territory__c> TriggerOld){
		
		List<Group> grpListToUpdate = new List<Group>();
        Map<Id, String> grpIdNameMap = new Map<Id, String>();
        Set<Id> grpToDeleteId = new Set<Id>();
        Set<Id> stdToChange = new Set<Id>();
        
        List<Sales_Territory__c> saleTerrReProcessList = new List<Sales_Territory__c>();
        
        try{
	        for(Integer i=0; i< TriggerNew.size(); i++){
	          
	            if(TriggerNew[i].IsActive__c != TriggerOld[i].IsActive__c && TriggerNew[i].IsActive__c == false){
	            	grpToDeleteId.add(TriggerNew[i].GroupId__c);
	            	
	            }
	            if(TriggerNew[i].IsConfidential__c != TriggerOld[i].IsConfidential__c && ((TriggerNew[i].IsConfidential__c == true) || (TriggerNew[i].IsConfidential__c == false))){
	            	stdToChange.add(TriggerNew[i].Id);
	            }
	        }
	        
	        if(!grpToDeleteId.isEmpty()){
	        	
	        	CreateGroupMemberForTerrUser.deleteGroup(grpToDeleteId);
	    	}
	    	
	    	if(!stdToChange.isEmpty()){
	    		List<Sales_Territory_Definition__c> stdList = [Select Id from Sales_Territory_Definition__c where Sales_Territory__c IN : stdToChange];
				if(!stdList.isEmpty()){
					update stdList;
	    		}
	    	}
        } catch(Exception e){
        	system.debug('****Exception in salesTerrAfterUpdate******' + e.getMessage());
        	
        }
	}
}