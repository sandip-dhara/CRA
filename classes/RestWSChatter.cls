@RestResource(urlMapping='/AthenaChatter/*')
global class RestWSChatter{
    @HttpPost
    global static RestWSResult Post(String method,String OpId, String content, String FeedItemID, List<followFlag> followFlags, String AthenaUserId) {
        RestWSResult result = new RestWSResult();
        If(method == 'GetCurrentUserInfo'){
            try{
                User curU = [select AboutMe, CompanyName, Country, Email, FullPhotoUrl, SmallPhotoUrl, FirstName, LastName, Title from User where Id =: UserInfo.getUserId()];
                result = new RestUserDetails();
                result.success = true;
                RestUserDetails restUserDetail= (RestUserDetails)result;
                restUserDetail.UserId = UserInfo.getUserId();                
                restUserDetail.FirstName= curU.FirstName;
                restUserDetail.LastName= curU.LastName;
                restUserDetail.UserEmail= curU.Email;
                restUserDetail.PhotoURL= curU.FullPhotoUrl;
                restUserDetail.SmallPhotoURL= curU.SmallPhotoUrl;                
                restUserDetail.AboutMe= curU.AboutMe;
                restUserDetail.CompanyName= curU.CompanyName;
                restUserDetail.Country= curU.Country;
                restUserDetail.Title= curU.Title;
                restUserDetail.IsFollowedByLoginUser =  false;                
            }
            catch(exception e){
                result.success = false;
                result.error = 'Exception Occurs, Please contact Web Service Publisher';
            }
        }
        else If(method == 'GetUserProfile'){
            try{
                User curU = [select AboutMe, CompanyName, Country, Email, FullPhotoUrl, SmallPhotoUrl, FirstName, LastName, Title from User where Id =: AthenaUserId];
                result = new RestUserDetails();
                result.success = true;
                RestUserDetails restUserDetail= (RestUserDetails)result;
                restUserDetail.UserId = AthenaUserId;
                restUserDetail.FirstName= curU.FirstName;
                restUserDetail.LastName= curU.LastName;
                restUserDetail.UserEmail= curU.Email;
                restUserDetail.PhotoURL= curU.FullPhotoUrl;
                restUserDetail.SmallPhotoURL= curU.SmallPhotoUrl;                
                restUserDetail.AboutMe= curU.AboutMe;
                restUserDetail.CompanyName= curU.CompanyName;
                restUserDetail.Country= curU.Country;
                restUserDetail.Title= curU.Title;
                
                List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:AthenaUserId];
                if(subs.size() == 1)
                {
                    restUserDetail.IsFollowedByLoginUser  =  true; 
                }
                else{
                    restUserDetail.IsFollowedByLoginUser  =  false; 
                }                    
                              
            }
            catch(exception e){
                result.success = false;
                result.error = 'Exception Occurs, Please contact Web Service Publisher';
            }
        }
        
        else if(method == 'Follow'){
            FollowResult res = Follow(OpId);
            result.success = res.success;
            result.error = res.error;
        }
        else if(method == 'UnFollow'){
            FollowResult res = UnFollow(OpId);
            result.success = res.success;
            result.error = res.error;                                   
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
        else if(method == 'PostChatter'){

            if([select count() FROM Offering_Release__c where id=:opId] < 1 & [select count() FROM Learning_Board__c where id=:opId] < 1 )
            {
                result.success = false;
                result.error = 'The queried Offering Release or Learning Board does not exist';
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
        else if(method == 'PostCommentsForFeedID'){
            FeedComment fcomment =  new FeedComment();
            fcomment.FeedItemId = Id.Valueof(FeedItemID);
            fcomment.CommentBody = content;
            insert fcomment;
            result.success = True;
        }
        else if(method == 'GetCommentsByFeedID'){

            List <FeedComment> feedCommentsList = [select Id, CommentBody, CreatedDate, CreatedById, CreatedBy.FirstName, CreatedBy.LastName, FeedItemId from FeedComment where FeedItemId=:FeedItemID ORDER BY CreatedDate DESC];
            result = new RestChatterComments();
            result.success = true;
            RestChatterComments restComments = (RestChatterComments)result;
            restComments.CommentsList = new Set<ChatterComments>();
            for(FeedComment fc : feedCommentsList){
                ChatterComments cc = new ChatterComments();
                cc.Id = fc.Id;
                cc.PostFeedItemID = fc.FeedItemId; 
                cc.CommentBody = fc.CommentBody;
                cc.CreatedById = fc.CreatedById;
                //List<User> commentPosters = [SELECT FirstName, LastName FROM User WHERE Id=:fc.CreatedById];
                cc.CreaterName = fc.CreatedBy.FirstName + fc.CreatedBy.LastName;
                cc.CreatedDate = fc.CreatedDate;
                
                ConnectApi.Comment comment= ConnectApi.ChatterFeeds.getComment(null,fc.Id);
                cc.IsMylike = comment.myLike != null;
                if(cc.IsMylike){
                    cc.LikeId = comment.myLike.Id;
                }
                
                restComments.CommentsList.add(cc);
            }
        }
        else if(method == 'ChatterGetPost'){
            integer countOR = [select count() FROM Offering_Release__c where id=:opId];
            integer countLB = [select count() FROM Learning_Board__c where id=:opId];
            if( countOR < 1 & countLB < 1)
            {
                result.success = false;
                result.error = 'The queried Offering Release or learning board does not exist';
                return result;
            }
            else
            {
                result = new RestChatterPost();
                result.success = true;
                RestChatterPost restPosts= (RestChatterPost)result;
                restPosts.PostList = new Set<ChatterPost>();
                
                if(countOR == 1 & countLB == 0){
                    List<Offering_Release__Feed> orFeeds = [Select Id,CreatedById,CreatedBy.Name,
                    ParentId, Type, Body, CommentCount, LikeCount, CreatedDate
                    From Offering_Release__Feed where ParentId=:opId and Type = 'TextPost'];
                    
                    for(Offering_Release__Feed obj:orFeeds){
                        ChatterPost post = new ChatterPost();
                        post.ID = obj.Id;
                        post.ParentId = obj.ParentId;
                        post.Body = obj.Body;
                        post.CommentCount = obj.CommentCount;
                        post.LikeCount = obj.LikeCount;
                        post.CreatedById = obj.CreatedById;
                        //post.CreaterName = obj.CreatedBy.Name + '|' + obj.Type;
                        post.CreaterName = obj.CreatedBy.Name;
                        post.CreatedTime = obj.CreatedDate;
                        List<User> poster = [SELECT SmallPhotoUrl 
                            FROM User 
                            WHERE Id=:obj.CreatedById];
                        post.CreaterPhotoUrl = poster[0].SmallPhotoUrl;

                        ConnectApi.FeedItem feedItem = ConnectApi.ChatterFeeds.getFeedItem(null,obj.Id);
                        post.IsMylike = feedItem.myLike != null;
                        if(post.IsMylike){
                            post.LikeId = feedItem.myLike.Id;
                        }
                        
                        restPosts.PostList.add(post);
                    }
                }
                else if(countOR == 0 & countLB == 1){
                    List<Learning_Board__Feed> orFeeds = [Select Id,CreatedById,CreatedBy.Name,
                    ParentId, Type, Body, CommentCount, LikeCount, CreatedDate
                    From Learning_Board__Feed where ParentId=:opId];
                    
                    for(Learning_Board__Feed obj:orFeeds){
                        ChatterPost post = new ChatterPost();
                        post.ID = obj.Id;
                        post.ParentId = obj.ParentId;
                        post.Body = obj.Body;
                        post.CommentCount = obj.CommentCount;
                        post.LikeCount = obj.LikeCount;
                        post.CreatedById = obj.CreatedById;
                        //post.CreaterName = obj.CreatedBy.Name + '|' + obj.Type;
                        post.CreaterName = obj.CreatedBy.Name;
                        post.CreatedTime = obj.CreatedDate;
                        List<User> poster = [SELECT SmallPhotoUrl 
                            FROM User 
                            WHERE Id=:obj.CreatedById];
                        post.CreaterPhotoUrl = poster[0].SmallPhotoUrl;
                        
                        ConnectApi.FeedItem feedItem = ConnectApi.ChatterFeeds.getFeedItem(null,obj.Id);
                        post.IsMylike = feedItem.myLike != null;
                        if(post.IsMylike){
                            post.LikeId = feedItem.myLike.Id;
                        }
                        restPosts.PostList.add(post);
                    }
                }              
            }
        }
        else if(method == 'LikeFeedItem'){
            try{
             ConnectApi.ChatterLike likeflag = ConnectApi.ChatterFeeds.likeFeedItem(null, FeedItemID);
             result = new RestChatterLike();
             result.success = true;
             RestChatterLike restLikes= (RestChatterLike)result;
             restLikes.ChatterLikeID= likeflag.Id;
            }
            catch(exception e){
                result.success = false;
                result.error = 'Invalid FeedItem ID. Please try again';
            }       
        }
        else if(method == 'LikeComment'){
            try{
             ConnectApi.ChatterLike likeflag = ConnectApi.ChatterFeeds.likeComment(null, FeedItemID);
             result = new RestChatterLike();
             result.success = true;
             RestChatterLike restLikes= (RestChatterLike)result;
             restLikes.ChatterLikeID= likeflag.Id;
            }
            catch(exception e){
                result.success = false;
                result.error = 'Invalid Comments ID. Please try again';
            }       
        }        
        else if(method == 'UnLikeFeedItem'){
/*        
            FeedItem feed = [Select Id, Body, (Select Id, CreatedBy.Alias, CreatedDate From FeedLikes ) From FeedItem where Id =: FeedItemID];
            List<FeedLike> flikes = feed.FeedLikes;
            delete flikes;
            result.success = True;
            //result.error = feed + '-----' + flikes;
*/            
            try{
                //OpId will be the LikeId.
                ConnectApi.ChatterLike likeFlag = ConnectApi.ChatterFeeds.getLike(null, FeedItemID);
                ConnectApi.ChatterFeeds.deleteLike(null, FeedItemID);
                result.success = True;
            }     
            catch(exception e){
                result.success = false;
                result.error='Invalid LikeID. Please try again later';
            }
        }        
        else
        {
            result.success = false;
            result.error = 'Invalid method';
        }
        return result;
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
        global integer LikeCount;
        global Boolean IsMyLike;
        global String LikeId;
    }
    
    global class RestChatterPost extends RestWSResult
    {
        global Set<ChatterPost> PostList;
    }
    
    global class ChatterComments
    {
        global String Id;
        global String PostFeedItemID;
        global String CommentBody;
        global String CreatedById;
        global String CreaterName;
        global DateTime CreatedDate;
        global Boolean IsMyLike;
        global String LikeId;
    }
    
    global class RestChatterComments extends RestWSResult
    {
        global Set<ChatterComments> CommentsList;
    }
    

    global class RestChatterLike extends RestWSResult
    {
        global String ChatterLikeID;
    }
    
    global class RestUserDetails extends RestWSResult
    {
        global String UserEmail;
        global String UserId;        
        global String FirstName;
        global String LastName;
        global String PhotoURL;
        global String SmallPhotoURL;        
        global String AboutMe;
        global String CompanyName;
        global String Country;
        global String Title;
        global boolean IsFollowedByLoginUser;        
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
    }   
}