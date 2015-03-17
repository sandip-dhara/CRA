public class LikeImplementationController 
{

    List<Learning_Board__Feed> lboard=new List<Learning_Board__Feed>();
    Learning_Board__Feed lb=new Learning_Board__Feed(); 
    public string LrngBoardID{get;set;}

    public LikeImplementationController() {
         this.LrngBoardID= ApexPages.currentPage().getParameters().get('id');
    }

    public boolean LikedOrNotLB{
    get{
            string LrngBoardID= ApexPages.currentPage().getParameters().get('id');
            boolean isLiked=false;    
           // List<Learning_Board__c> lbdtls = [select LikeId__c,Name,Is_Active__c from Learning_Board__c where id=:LrngBoardID];
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LrngBoardID];
            for(Liked_Item__c lb:lbdtls)
            {
                if(lb.ID==null)
                {
                    return false;
                }
                else
                {                    
                    list<User_Liked_Item__c> fitm=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c=:UserInfo.getUserId()and Liked_Item_ID__c=:lb.Id];

                    for(User_Liked_Item__c fi:fitm)
                    {                       
                         isLiked=true;                                                    
                    }
                    return isLiked;                
               }
            }  
            return isLiked;    
    }    
    set;}

    
     public static void LearningBoardLike()
     {
            string LrngBoardID= ApexPages.currentPage().getParameters().get('id');
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LrngBoardID];
            boolean isLikedItem=false;
            Liked_Item__c litm=new Liked_Item__c();           
            for(Liked_Item__c lb:lbdtls)
            {
                isLikedItem=true;  
                litm.id=lb.id;  
            }
            if(!isLikedItem)
            {
                litm.Item_Identifier__c=LrngBoardID;
                litm.Item_Name__c='Learning Board';
                insert litm;                        
            }
            
            User_Liked_Item__C ULikdItm=new User_Liked_Item__C();
            ULikdItm.Liked_Item_ID__C=litm.ID;
            ULikdItm.User_ID__C=UserInfo.getUserId();                
            insert ULikdItm;
            
     }



















    }