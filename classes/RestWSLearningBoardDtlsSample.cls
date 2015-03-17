@RestResource(urlMapping='/LearningBoardDtlsSample/*')
global with sharing class RestWSLearningBoardDtlsSample{
		@HttpPost
        global static RestWSResult Post(String LearningBoardid,String method) {
            RestWSResult result = new RestWSResult();
            if(method == 'LBDetails'){
                if(LearningBoardid != null){
                    result = new LearningBoardDtls_GlobalSample(LearningBoardid);
                    result.success = true;
                }
                
                else{
                    result.success = false;
                    result.error = 'Invalid Learning Board';
                }
            }
            else  if(method == 'Like'){
                result.success = true;
                 List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardid ];
                    boolean isLikedItem=false;
                    Liked_Item__c litm=new Liked_Item__c();           
                    for(Liked_Item__c lb:lbdtls)
                    {
                        isLikedItem=true;  
                        litm.id=lb.id;  
                    }
                    
                    if(!isLikedItem)
                    {
                        litm.Item_Identifier__c=LearningBoardid;
                        litm.Item_Name__c='Learning Board';
                        insert litm;                        
                    }
                    
                    List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
                    if(UsrlikdItms.size()==0)
                    {
                        User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
                        UsrlikdItm.Liked_Item_ID__C=litm.ID;
                        UsrlikdItm.User_ID__C=UserInfo.getUserId();                
                        insert UsrlikdItm;            
                    }
            }
            else  if(method == 'Follow'){
                try{            
                    List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:LearningBoardid];
                    if(subs.size() < 1)
                    {
                        EntitySubscription newSub = new EntitySubscription();
                        newSub.ParentId = Id.valueOf(LearningBoardid);
                        newSub.SubscriberId = UserInfo.getUserId();
                        DataBase.insert(newSub); 
                        result.success = true;
                    }
                    else
                    {
                        result.success = false;
                        result.error = 'you have followed this Learning Board';
                    }
            	}     
            	catch(exception e){
                    result.success = false;
                    result.error=e.getMessage();
            	}
            }
            else  if(method == 'Comments'){
                 List<FeedItem> feedItms = [Select id from FeedItem where parentID=:LearningBoardid];
       			 if(feedItms.size()<1)
                 {
                     result.success = false;
                     result.error = 'No Comments available';
                 }
                 else
                 {
                     result.success = true;
                     result.error = 'Need to explore on this implementation';
                 }
            }
            else{
                    result.success = false;
                    result.error = 'Invalid method';
                }
            return result;
            
        }
}