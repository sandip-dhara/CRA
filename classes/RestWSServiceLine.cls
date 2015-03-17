@RestResource(urlMapping='/ServiceLine/*')
global with sharing class RestWSServiceLine {
   /* @HttpGet
    global static RestWSResult get() {
        RestWSResult result = new RestWSResult(); 
        List<Service_Line__c> sls = [SELECT Name,Short_Description__c,Name__c, Leader_User__r.Last_First_Name__c,Is_Active__c 
        FROM Service_Line__c];
        
        if(sls.size()< 1){
            result.success = false;
            result.error = 'No Avilable Service Lines';
        }
        else{
            result = new RestWSSL();
            result.success = true;
            RestWSSL restWSSL= (RestWSSL)result;
            restWSSL.ServiceLines = new Set<ServiceLineDetails>();
            
            for(Service_Line__c slobj:sls){
                ServiceLineDetails servicelines = new ServiceLineDetails();
                servicelines.ID= slobj.Id;
                servicelines.Name = slobj.Name__c;
                servicelines.Description = slobj.Short_Description__c;
                servicelines.IsActive= slobj.Is_Active__c;
                //servicelines.leader =  slobj.Leader_User__r.Name;
                servicelines.leader =  slobj.Leader_User__r.Last_First_Name__c;
                restWSSL.ServiceLines.add(servicelines);
            }
        }
        return result;
    }
    
    @HttpPost
    global static RestWSResult Post(String method,String OpId,string content, List<followFlag> followFlags) {
        RestWSResult result = new RestWSResult();
        
        if(method == 'PostChatter'){
            if([select count() FROM Offering_Release__c where id=:opId] < 1)
            {
                result.success = false;
                result.error = 'Offering Release is not exists';
                return result;
            }
            else
            {
                FeedItem fItem = new FeedItem();
                fItem.Type = 'TextPost';
                fItem.ParentId = Id.valueOf(OpId);
                fItem.Body = content;
                insert fItem;
                result.success = True;
            }
        }
        
        
        else if(method == 'GetCoreTeamMemberByOffRelID')
        {
            if([select count() FROM Offering_Release__c where id=:opId] < 1)
            {
                result.success = false;
                result.error = 'Offering Release is not exists';
                return result;
            }
            
            List<Core_Team_Member__c> ctms = [SELECT User__r.Name,User__r.Email FROM Core_Team_Member__c where Offering_Release_ID__c=:OpId];
            List <Role__c> RoleList = [select Role_Name__c from Role__c];              
            if(ctms.size()>0)
            {
                result = new RestWSCoreTeamMember();
                result.success = true;
                RestWSCoreTeamMember ctResult = (RestWSCoreTeamMember)result;
                ctResult.CoreTeamMembers = new Map<string,Set<string>>();
                for(Role__c r:RoleList)
                {
                    Set <String> sp = new Set <String>();
                    if(!ctResult.CoreTeamMembers.containsKey(r.Role_Name__c))
                    {
                        for(Core_Team_Member__c ctm:ctms){
                            //List <Team_member_Role__c> tmr = [select Role_Name__c from Team_member_Role__c where Team_Member_ID__c =: c.id];
                            //List <Team_Member_Role__c> TMRLIST = ctm.Team_Member_Role__r.Role_Name__c;
                            if(true){
                                sp.add(ctm.User__r.Name+'|'+ctm.User__r.Email);
                              //  sp.add(ctm.User__r.Name+'|'+ctm.User__r.Email);
                            }
                        }
                        ctResult.CoreTeamMembers.put(r.Role_Name__c, sp);
                    }
                    else
                    {
                        //ctResult.CoreTeamMembers.get(r.Role_Name__c).add(ctm.User__r.Name+'|'+ctm.User__r.Email);
                        //ctResult.CoreTeamMembers.get(ctm.Role_Name__c).add(ctm.User__r.Name+'|'+ctm.User__r.Id);
                    }
                }
            }
            else
            {
                result.success = true;
                result.error='this release did not assign core team members';
            }
        }
        
        
        
        
        
        else if(method == 'ChatterGetPost'){
            if([select count() FROM Offering_Release__c where id=:opId] < 1)
            {
                result.success = false;
                result.error = 'Offering Release is not exists';
                return result;
            }
            else
            {
                //List<Offering_Release__Feed> orFeeds = [Select Id,CreatedById,CreatedBy.Name,
                //    ParentId, Type, Body, CommentCount, CreatedDate
                //    From Offering_Release__Feed where ParentId=:opId]; // and Type='TextPost'];
                result = new RestChatterPost();
                result.success = true;
                RestChatterPost restPosts= (RestChatterPost)result;
                restPosts.PostList = new Set<ChatterPost>();
                ConnectApi.FeedItemPage items = ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null, ConnectApi.FeedType.Record, opId);
                for(ConnectApi.FeedItem item:items.items)
                {
                    ChatterPost post = new ChatterPost();
                    post.ID = item.Id;
                    post.ParentId = item.parent.Id;
                    post.Body = item.Body.text;
                    post.CommentCount = item.comments.total;
                    post.CreatedById = string.valueOf(item.Type);
                    post.CreaterName = item.actor.Name;
                    post.CreatedTime = item.createdDate;
                    post.IsLikedByCurrentUser = item.isLikedByCurrentUser;
                    if(post.IsLikedByCurrentUser)
                        post.MyLikeId = item.myLike.Id;
                    //post.CreaterPhotoUrl = item.actor;
                    restPosts.PostList.add(post);
                }
                for(Offering_Release__Feed obj:orFeeds){
                    ChatterPost post = new ChatterPost();
                    post.ID = obj.Id;
                    post.ParentId = obj.ParentId;
                    post.Body = obj.Body;
                    post.CommentCount = obj.CommentCount;
                    post.CreatedById = obj.CreatedById;
                    post.CreaterName = obj.CreatedBy.Name + '|' + obj.Type;
                    post.CreatedTime = obj.CreatedDate;
                    List<User> poster = [SELECT SmallPhotoUrl 
                        FROM User 
                        WHERE Id=:obj.CreatedById];
                    post.CreaterPhotoUrl = poster[0].SmallPhotoUrl;
                    restPosts.PostList.add(post);
                }
            }
        }
        else if(method == 'ChatterLike'){
            try{
                //OpId will be the feedItem Id.
                ConnectApi.ChatterLike likeFlag = ConnectApi.ChatterFeeds.likeFeedItem(null, OpId);
                result.success = True;
                //result.error = likeFlag.ToString();
            }
            catch(exception e){
                result.success = false;
                result.error='invalid item Id.';
            }
        }
        else if(method == 'ChatterDelLike'){
            try{
                //OpId will be the LikeId.
                ConnectApi.ChatterLike likeFlag = ConnectApi.ChatterFeeds.getLike(null, OpId);
                ConnectApi.ChatterFeeds.deleteLike(null, OpId);
                result.success = True;
            }     
            catch(exception e){
                result.success = false;
                result.error='invalid like Id.';
            }
        }
        else if(method == 'FollowOrUnFollow'){
            if(followFlags == null || followFlags.Size() < 1)
            {
                result.success = false;
                result.error = 'Invalid method call, must provide the parameter followFlags';
            }
            else{
                result = new RestFollowOrUnFollow();
                result.success = true;
                RestFollowOrUnFollow restFollows= (RestFollowOrUnFollow)result;
                restFollows.FollowList = new Set<FollowResult>();
                
                for(followFlag follower:followFlags)
                {
                    FollowResult res = null;
                    if(follower.flag)
                    {
                        res = Follow(follower.Id);
                    }
                    else
                    {
                        res = UnFollow(follower.Id);
                    }
                    restFollows.FollowList.Add(res);
                }
                result.success = true;
                result.error = '';
            }
        }
        
        return result;
    }
    global class RestWSCoreTeamMember extends RestWSResult
    {
        global Map<string,Set<string>> CoreTeamMembers;
    }
    global class ServiceLineDetails
    {
        global String ID;
        global String Name;
        global String Description;
        global Boolean IsActive;
        global String leader;
    }
    
    global class RestWSSL extends RestWSResult
    {
        global Set<ServiceLineDetails> ServiceLines;
    }
    
    global class ChatterPost
    {
        global String Id;
        global String ParentId;
        global String Body;
        global integer CommentCount;
        global String CreatedById;
        global String CreaterName;
        global String CreaterPhotoUrl;
        global DateTime CreatedTime;
        global Boolean IsLikedByCurrentUser;
        global String MyLikeId;
    }
    
    global class RestChatterPost extends RestWSResult
    {
        global Set<ChatterPost> PostList;
    }
    
    global class followFlag
    {
        global String Id;
        global Boolean flag;
    }
    
    global class FollowResult
    {
        global String Id;
        global Boolean flag;
        global Boolean success;
        global String error;
    }
    
    global class RestFollowOrUnFollow extends RestWSResult
    {
        global Set<FollowResult> FollowList;
    }
    
    static FollowResult Follow(String OpId)
    {
        FollowResult result = new FollowResult();
        result.Id = OpId;
        result.flag = true;
        try{            
            List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:OpId];
            if(subs.size() < 1)
            {
                EntitySubscription newSub = new EntitySubscription();
                newSub.ParentId = Id.valueOf(OpId);
                newSub.SubscriberId = UserInfo.getUserId();
                DataBase.insert(newSub); 
                result.success = true;
            }
            else
            {
                result.success = false;
                result.error = 'you have already followed this Offering release/Learning Board';
            }
        }     
        catch(exception e){
            result.success = false;
            result.error=e.getMessage();
        }         
        return result;
    }
    
    static FollowResult UnFollow(String OpId)
    {
        FollowResult result = new FollowResult();
        result.Id = OpId;
        result.flag = false;
         try{       
            List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:OpId];
            if(subs.size() > 0)
            {
                 DataBase.delete(subs[0]);
                 result.success = true;
            }
            else
            {
                result.success = false;
                result.error = 'you have not followed this Offering release/Learning Board before';
            }
        }     
        catch(exception e){
            result.success = false;
            result.error=e.getMessage();
        }
        return result;
    }*/
}