public class athenaLearningBoardDtlsm{
public String strSearchValue{get;set;}
 public String LearningBoardsid {
        get;
        set;
    }
    public string Learningid {
        get;
        set;
    }
    public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    public User GetLoggedinUserDtls{
    get{
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    set;}
        public class RelatedLearningBoardCustomClass{
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
           public boolean StaticImage{get;set;} 
           public String LBOwnerName{get;set;} 
       }       
    
    public class LearningDtlsCustomClass{
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LName{get;set;}
            public String LDescription{get;set;}
            public string LType{get;set;}   
            public String Lid{get;set;}
            public String LOwnerName{get;set;}
            public String LURL{get;set;}
            public date AttDate{get;set;}   
            public string DocType{get;set;}  
            public string AttId{get;set;}     
            public boolean StaticImage{get;set;}   
            public integer LikeCount{get;set;}   
            public boolean LikedOrNot{get;set;}       
    }
    
    public athenaLearningBoardDtlsm(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        Learningid='';
        LearningDtls = new list<LearningDtlsCustomClass>();
        LearningBoardDtls=new RelatedLearningBoardCustomClass();
        RelatedLearningBoards=new list<RelatedLearningBoardCustomClass>();

    }
    
    Public User getLearningBoardOwnerDtls()
    {
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe, u.Division, u.Department, u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id in (select ownerid from learning_board__c where id = :this.LearningBoardsid)];
        return U;
    }

    public integer LBLikeCount{
        get{     
            LBLIkeCount=LikedItemCount(this.LearningBoardsid);
            return LBLIkeCount;
        }
        set;}
    
    public integer LBOwnerLikeCount{
        get{     
            Learning_board__C lb=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
            LBOwnerLikeCount=LikedItemCount(lb.ownerid);
            return LBOwnerLikeCount;
        }
        set;}

    Public integer LikedItemCount(string itemIdentifier)
    {
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        else
        {
            return 0;
        }
    }  
    
     public integer LBCommentCount{
        get{     
            LBCommentCount=CommentCount(this.LearningBoardsid);
            return LBCommentCount;
        }
        set;}
        
        
         public void getLBComCount(){
              LBCommentCount=CommentCount(ApexPages.currentPage().getParameters().get('lid'));
         }   
        
        public integer LBOwnerCommentCount{
        get{     
            Learning_board__C lb=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
            LBOwnerCommentCount=CommentCount(lb.ownerid);
            return LBOwnerCommentCount;
        }
        set;}
    
        private Integer CommentCount(string id){

            List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
            return commCount.size(); 
        }       

   public List <LearningDtlsCustomClass> LearningDtls {
        get {
                LearningDtls.clear();            
                list<id> lstLearningIds= new list<id>();
                
              //  List<Learning__c> learnings=[select id,Name__c,Description__c,  type__c,URL__C, Owner.Name,Editorial__C from Learning__c where Is_Active__c = True and id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid )];
              List<Learning_Board_Learning__c> learnings=[select Learning_ID__c,Learning_ID__r.Name__c,Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name from Learning_Board_Learning__c where Learning_ID__r.Is_Active__c = True and Learning_Board_ID__c= : this.LearningBoardsid order by Display_Sequence_Nbr__c asc];
                for (Learning_Board_Learning__c l:learnings ) {
                    lstLearningIds.add(l.Learning_ID__c);
                }
                
                list<Attachment> Att = new List<Attachment>();             
                Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds]; 
                                               
                for (Learning_Board_Learning__c l:learnings ) {
                    LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                    lrng.LName=l.Learning_ID__r.Name__c;
                    lrng.LDescription = l.Learning_ID__r.Description__c;
                    lrng.LOwnerName = l.Learning_ID__r.Owner.name; 
                    lrng.LType= l.Learning_ID__r.type__c;   
                    lrng.LURL= l.Learning_ID__r.URL__C; 
                    lrng.LId = l.Learning_ID__c;
                    lrng.LikedOrNot=LikedOrNotLearn(l.Learning_ID__r.id);
                    lrng.LikeCount=LikedItemCount(l.Learning_ID__r.id);
                    
                    if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                          lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                    }
                    
                    if(lrng.LType=='Other')
                    {   
                        if(lrng.LURL.contains('.pdf'))
                        {
                          lrng.DocType='PDF';
                        }
                        else if(lrng.LURL.contains('.ppt'))
                        {
                          lrng.DocType='PPT';
                        }                    
                        else if(lrng.LURL.contains('.doc'))
                        {
                          lrng.DocType='DOC';
                        }
                        else
                        {
                             lrng.DocType='OTHER';
                        }
                    }
                    lrng.StaticImage=true;
                    if(l.Learning_ID__r.type__c=='Other')
                    {        
                        for(Attachment a: Att)
                        {               
                            //if(l.id == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png') )
                            if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png') )
                            {
                                lrng.AttachmentId = a.Id;
                                lrng.AttBody = EncodingUtil.Base64Encode(a.body);
                                lrng.AttContentType = a.ContentType;
                               // lrng.AttId= a.ParentId;
                                lrng.Lid= a.ParentId;
                                lrng.StaticImage=false;
                            }                 
                        }
                    } 
                    else
                    {
                        lrng.StaticImage=false;
                    }
                    
                    LearningDtls.add(lrng);
                }        
                return LearningDtls;                
            }   
    set;    
    }


public List <RelatedLearningBoardCustomClass> RelatedLearningBoards {
        get {
                RelatedLearningBoards.clear();  
          
                list<id> lstRLBIds= new list<id>();
                list<Attachment> attachmentList = new List<Attachment>(); 
 
                
              //  List<Related_Learning_Board__c> rLBs=[select Related_Learning_Board_ID__c from Related_Learning_Board__c where Learning_Board_ID__c =: this.LearningBoardsid order by Display_Sequence_Nbr__c  ];
               
                List<Related_Learning_Board__c>  rLBs =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Display_Sequence_Nbr__c, Learning_Board_ID__c,Related_Learning_Board_ID__r.name__c,Learning_Board_ID__r.Owner.Name,Related_Learning_Board_ID__r.description__c,Learning_Board_ID__r.ID,Learning_Board_ID__r.OwnerId,Learning_Board_ID__r.IsDeleted,Learning_Board_ID__r.Name,Learning_Board_ID__r.CurrencyIsoCode,Learning_Board_ID__r.CreatedDate,Learning_Board_ID__r.LastModifiedDate,Learning_Board_ID__r.SystemModstamp,Learning_Board_ID__r.LastViewedDate,Learning_Board_ID__r.Name__c,Learning_Board_ID__r.Description__c,Learning_Board_ID__r.Featured__c,Learning_Board_ID__r.Is_Active__c from Related_Learning_Board__c where Learning_Board_ID__r.Is_Active__c = True and Learning_Board_ID__r.id=: this.LearningBoardsid order by Display_Sequence_Nbr__c];
              
                for (Related_Learning_Board__c rLB:rLBs) {
                    lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
                }
                
               attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];


              // List<Learning_Board__c>  lblist= [select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and ID in:lstRLBIds ];                           

               for(Related_Learning_Board__c lb: rLBs){
                    RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                    lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                      if(lb.Learning_Board_ID__r.description__c!=null){
                      if(lb.Learning_Board_ID__r.description__c.length()>53){
                            
                            lbCustom.LBDescription = lb.Learning_Board_ID__r.description__c.substring(0,53) + '...';
                        }
                        else{
                            lbCustom.LBDescription=lb.Learning_Board_ID__r.description__c;
                        }
                      }
                      lbCustom.StaticImage = true;
                      lbCustom.LBOwnerName=lb.Learning_Board_ID__r.Owner.Name; 
                    for(Attachment att: attachmentList){
                        if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.AttBody = EncodingUtil.Base64Encode(att.body);
                            lbCustom.AttContentType = att.ContentType;
                            lbCustom.LbId = att.ParentId;
                            lbCustom.StaticImage = false;
                        }  
                    }
                    RelatedLearningBoards.add(lbCustom);
                 }                
                return RelatedLearningBoards;                
            }   
    set;    
    }

public RelatedLearningBoardCustomClass LearningBoardDtls {
        get {
 
          
                list<Attachment> attachmentList = new List<Attachment>(); 
                
               attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :LearningBoardsid];


               List<Learning_Board__c>  lblist= [select id,Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and ID =:LearningBoardsid ];                           
              // 
               for(Learning_Board__c lb: lblist){
                    RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                    lbCustom.LBName = lb.Name__c; 
                     if(lb.description__c!=null){
                        if(lb.description__c.length()>53){
                            
                            lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                        }
                        else{
                            lbCustom.LBDescription=lb.description__c;
                        }
                      }
                      lbCustom.StaticImage = true;
                    for(Attachment att: attachmentList){
                        if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.AttBody = EncodingUtil.Base64Encode(att.body);
                            lbCustom.AttContentType = att.ContentType;
                            lbCustom.LbId = att.ParentId;
                            lbCustom.StaticImage = false;
                        }  
                    }
                    //LearningBoardDtls.add(lbCustom);
                    LearningBoardDtls=lbCustom;
                 }                
                return LearningBoardDtls;                
            }   
    set;    
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
     
     public  void LearningLike()
     {
           // string Learningid='';
           // system.debug(Learningid);
           
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:Learningid];
            boolean isLikedItem=false;
            Liked_Item__c litm=new Liked_Item__c();           
            for(Liked_Item__c lb:lbdtls)
            {
                isLikedItem=true;  
                litm.id=lb.id;  
            }
            if(!isLikedItem)
            {
                litm.Item_Identifier__c=Learningid;
                litm.Item_Name__c='Learning';
                insert litm;                        
            }
            
            User_Liked_Item__C ULikdItm=new User_Liked_Item__C();
            ULikdItm.Liked_Item_ID__C=litm.ID;
            ULikdItm.User_ID__C=UserInfo.getUserId();                
            insert ULikdItm;            
     } 
     
     public  void LearningUnLike()
     {    
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:Learningid];
            List<User_Liked_Item__C> ULikdItm= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where Liked_Item_ID__c=:lbdtls[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(ULikdItm.size()>0)
            {
                for(User_Liked_Item__C ul:ULikdItm)
                {
                    delete ul;            
                }
            }         
     } 
     
     public  void LearningBoardUnLike()
     {        
            string LrngBoardID= ApexPages.currentPage().getParameters().get('id');   
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LrngBoardID];
            User_Liked_Item__C ULikdItm= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where Liked_Item_ID__c=:lbdtls[0].Id and User_ID__c=:UserInfo.getUserId()];
            delete ULikdItm;            
     } 
     
      public boolean LikedOrNotLearn(string lrngID){
             
             boolean isLiked=false;    
            List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:lrngID];
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
      
      //Learning Board Search: redirects to the social learning page to display the search results
       public PageReference dosearch()
    {
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
        
    }