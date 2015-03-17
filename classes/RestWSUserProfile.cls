@RestResource(urlMapping='/UserProfile/*')
global with sharing class RestWSUserProfile{
        @HttpPost
        global static RestWSResult Post(String method,String AthenaUserId) {
        RestWSResult result = new RestWSResult();
        if(method == 'UserProfile')
        {
            if([Select count() From User where id =:AthenaUserId] < 1)
            {
                result.success = false;
                result.error = 'No Such User exists';
               
            }
            else{
                User u = [Select u.name,u.title,  u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe, u.Division, u.Department, u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id =:AthenaUserId];
                result = new RestWSUserPro();
                RestWSUserPro userResult = (RestWSUserPro)result;
                UserProfile up = new UserProfile();
                up.Id = u.Id;
                up.Name = u.Name;
                up.Title = u.Title;
                up.SmallPhotoUrl = u.SmallPhotoUrl;
                up.FullPhotoUrl = u.FullPhotoUrl;
                up.AboutMe = u.AboutMe;
                up.Email = u.Email;
                
                userResult.User = up;
                result.success = true;
                List<Learning_Board__c>  userProfileLearningBoard= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Owner.Id=:u.Id];                           
				if(userProfileLearningBoard.size() < 1)
                    {
                        //result.success = false;
                        result.error = 'No learning Board for this user';
                    }
                else{
                    List<LearningBoardCustomClass> lbclist = new List<LearningBoardCustomClass>();
                        for(Learning_Board__c lb:userProfileLearningBoard){
                            LearningBoardCustomClass lbc = new LearningBoardCustomClass();
                             Attachment attach = new Attachment(); 
                            lbc.ID = lb.id;
                            lbc.LBName = lb.Name__c; 
                            lbc.LBDescription = lb.Description__c;
                            lbc.lbid = lb.id;
                            lbc.LBOwnerName = lb.Owner.Name;
                            lbc.LBOwnerURL = u.SmallPhotoUrl;
                            lbc.LBCrtDate = lb.CreatedDate;
                            List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : lb.id];
                            if(li.size()!=0)
                                {
                                    lbc.LBNoOfLikes = Integer.ValueOf(li[0].like_count__c);
                                }
                            else {lbc.LBNoOfLikes = 0;}
                            //List<FeedItem> commCount = [Select id from FeedItem where parentID=: lb.id];
                            List<FeedItem> commCount = FeedItemQueryUtils.getFeedItems(lb.id);
                            
                            lbc.LBNoOfComments = commCount.size();
                            if([select count() FROM Attachment WHERE Parentid = :lb.id] < 1){
                            }
                            else    {
                            attach = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :lb.id];
                            
                                if(lb.id == attach.ParentId  && (attach.ContentType == 'image/jpeg' || attach.ContentType == 'image/png')){
                                lbc.AttachmentId = attach.Id;
                                lbc.StaticImage=false;
                                lbc.AttBody = EncodingUtil.Base64Encode(attach.body);
                                lbc.AttContentType = attach.ContentType;
                                }
                            }  
                            lbclist.add(lbc);
                        }
                    userResult.User.userLearningBoards = lbclist;
                    }
                 
                }
            }
            else if(method == 'Follow'){
                //List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:AthenaUserId];
                List<EntitySubscription> subs = [select Id from EntitySubscription where SubscriberId=:UserInfo.getUserId() and ParentId=:AthenaUserId Limit 1000];
                    if(subs.size() < 1)
                    {
                        EntitySubscription newSub = new EntitySubscription();
                        newSub.ParentId = Id.valueOf(AthenaUserId);
                        newSub.SubscriberId = UserInfo.getUserId();
                        DataBase.insert(newSub); 
                        result.success = true;
                    }
                    else
                    {
                        result.success = false;
                        result.error = 'you have followed this User';
                    }
            }
            else{
                result.success = false;
                result.error = 'Invalid method';
            }
            
            return result;
        }      
   
        global class UserProfile
    {
        global String ID;
        global String Name;
        global String title;
        global String SmallPhotoUrl;
        global String FullPhotoUrl;
        global String AboutMe;
        global String Email;
        global List<LearningBoardCustomClass> userLearningBoards;
    }
    global class RestWSUserPro extends RestWSResult{
      global UserProfile User;
    }
    global class LearningBoardCustomClass{ 
            global String ID;
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public String LBOwnerName{get;set;} 
            public String LBOwnerURL{get;set;}
            public datetime LBCrtDate{get;set;}
            public integer LBNoOfLikes{get;set;}
            public integer LBNoOfComments{get;set;} 
            public boolean StaticImage{get;set;}  
    }
}