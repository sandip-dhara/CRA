Public class AthenaSarahLearningBoardDtls{

    Public String strSearchValue{get;set;}
    Public String LearningBoardsid {get;set;}
    Public string Learningid{get;set;}

    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
    Public User getLearningBoardOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe, u.Division, u.Department, 
        u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id in 
        (select ownerid from learning_board__c where id = :this.LearningBoardsid)];
        return U;
    }
    
    Public void getLBComCount(){  
        LBCommentCount=getCommentCount(this.LearningBoardsid);
    }
    
    Private Integer getCommentCount(string lid){
        List<FeedItem> feedItms = [Select id from FeedItem where parentID=:lid];
        return feedItms.size(); 
    }   
    
    Public integer LBLikeCount{
        get{     
            LBLIkeCount=LikedItemCount(this.LearningBoardsid);
            return LBLIkeCount;
        }
        set;
    }

    Public integer LBOwnerLikeCount{
        get{     
            Learning_board__C lrngBrd=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
            LBOwnerLikeCount=LikedItemCount(lrngBrd.ownerid);
            return LBOwnerLikeCount;
        }
        set;
    }   
    
    Public integer LBCommentCount{
    get{     
        LBCommentCount=getCommentCount(this.LearningBoardsid);
        return LBCommentCount;
    }
    set;}
    
    Public integer LBOwnerCommentCount{
    get{     
        Learning_board__C lrngBrd=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
        LBOwnerCommentCount=getCommentCount(lrngBrd.ownerid);
        return LBOwnerCommentCount;
    }
    set;}
    
    Private integer LikedItemCount(string itemIdentifier){
        List<Liked_Item__C> LikdItms= [select like_count__c from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(LikdItms.size()!=0)
        {
            return Integer.ValueOf(LikdItms[0].like_count__c);
        }
        return 0;
    }  
    
    Public List <LearningDtlsCustomClass> LearningDtls{
        get {
            LearningDtls.clear();            
            list<id> lstLearningIds= new list<id>();
            
            List<Learning_Board_Learning__c> learnings=[select Learning_ID__c,Learning_ID__r.Name__c,
            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name 
            from Learning_Board_Learning__c where Learning_ID__r.Is_Active__c = True and 
            Learning_Board_ID__c= : this.LearningBoardsid order by Display_Sequence_Nbr__c asc];
            
            for (Learning_Board_Learning__c l:learnings ) {
                lstLearningIds.add(l.Learning_ID__c);
            }
            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds]; 
            
            
            List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :lstLearningIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        
            
            
            //system.debug('@#$'+commCount.CommentCount);    
            for (Id LBId :lstLearningIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            }
                                            
            for (Learning_Board_Learning__c l:learnings ) {
                    LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                    
                    lrng.LName=l.Learning_ID__r.Name__c;
                    lrng.LDescription = l.Learning_ID__r.Description__c;
                    lrng.LOwnerName = l.Learning_ID__r.Owner.name; 
                    lrng.LType= l.Learning_ID__r.type__c;   
                    lrng.LURL= l.Learning_ID__r.URL__C; 
                    lrng.LId = l.Learning_ID__c;
                    lrng.LikedOrNot=LikedOrNotLearn(l.Learning_ID__r.id);
                    lrng.LikeCount=integer.valueof( LBLikeCountMap.get(l.Learning_ID__r.id));
                    lrng.DocLnkXst=false; 
                    if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                          lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                    }
                    //lrng.LType=='Link Or Document' &&
                    if( lrng.LURL!=null)
                    {   
                        lrng.DocLnkXst=true;
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
                 
                    if(l.Learning_ID__r.type__c!='Video')
                    {        
                        for(Attachment a: Att)
                        { 
                            if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg') )
                            {
                                lrng.AttachmentId = a.Id;
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
    
    public List <RelatedLearningBoardCustomClass> RelatedLearningBoards{
        get {
            RelatedLearningBoards.clear();  
            
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 
            
            List<Related_Learning_Board__c>  rLBs =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, 
            CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Display_Sequence_Nbr__c, 
            Learning_Board_ID__c,Related_Learning_Board_ID__r.name__c,Learning_Board_ID__r.Owner.Name,
            Related_Learning_Board_ID__r.description__c,Learning_Board_ID__r.ID,Learning_Board_ID__r.OwnerId,
            Learning_Board_ID__r.IsDeleted,Learning_Board_ID__r.Name,Learning_Board_ID__r.CurrencyIsoCode,
            Learning_Board_ID__r.CreatedDate,Learning_Board_ID__r.LastModifiedDate,Learning_Board_ID__r.SystemModstamp,
            Learning_Board_ID__r.LastViewedDate,Learning_Board_ID__r.Name__c,Learning_Board_ID__r.Description__c,
            Learning_Board_ID__r.Featured__c,Learning_Board_ID__r.Is_Active__c from Related_Learning_Board__c where 
            Learning_Board_ID__r.Is_Active__c = True and Learning_Board_ID__r.id=: this.LearningBoardsid order by 
            Display_Sequence_Nbr__c];
              
            for (Related_Learning_Board__c rLB:rLBs) {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Related_Learning_Board__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                lbCustom.LBOwnerName=lb.Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage = false;
                    }  
                }
                RelatedLearningBoards.add(lbCustom);
            }                
        return RelatedLearningBoards;                
        }   
        set;    
    }
    
    Public RelatedLearningBoardCustomClass LearningBoardDtls{
        get {
    
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :LearningBoardsid];
        
        List<Learning_Board__c>  lrngbrds= [select id,Name__c,description__c, Owner.name,Owner.Id, Featured__c,
        CreatedDate from Learning_Board__c where ID =:LearningBoardsid ];
        //Is_Active__c = True and                            
         
        for(Learning_Board__c lb: lrngbrds){
            RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
        
            lbCustom.LBName = lb.Name__c; 
            lbCustom.LBDescription=lb.description__c;           
            lbCustom.LbId = lb.Id;            
            lbCustom.StaticImage = true;
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                    lbCustom.AttachmentId = att.Id;                
                    lbCustom.StaticImage = false;
                }  
            }
            LearningBoardDtls=lbCustom;
        }                
        return LearningBoardDtls;                
    }   
    set;    
    }
    
    Public AthenaSarahLearningBoardDtls(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        Learningid='';
        LearningDtls = new list<LearningDtlsCustomClass>();
        LearningBoardDtls=new RelatedLearningBoardCustomClass();
        RelatedLearningBoards=new list<RelatedLearningBoardCustomClass>();
    }
    
    Public boolean LikedOrNotLB{
    get{
            boolean isLiked=false;    
            List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
            for(Liked_Item__c LikdItm:LikdItms)
            {            
                list<User_Liked_Item__c> UsrlikdItms=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c=:UserInfo.getUserId()and Liked_Item_ID__c=:LikdItm.Id];

                for(User_Liked_Item__c UsrlikdItm:UsrlikdItms)
                {                       
                     isLiked=true;                                                    
                }
                return isLiked;
            }  
            return isLiked;    
    }    
    set;}
    
    Public void LearningBoardLike(){
        List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
        boolean isLikedItem=false;
        Liked_Item__c litm=new Liked_Item__c();           
        for(Liked_Item__c lb:lbdtls)
        {
            isLikedItem=true;  
            litm.id=lb.id;  
        }
        
        if(!isLikedItem)
        {
            litm.Item_Identifier__c=LearningBoardsid;
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
    
    Public void LearningBoardUnLike(){        
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where 
            Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C UsrlikdItm:UsrlikdItms)
                {
                    delete UsrlikdItm;            
                }
            }
        }
    } 
    
    Public void LearningLike(){
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
        
        
        List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
        if(UsrlikdItms.size()==0)
        {
            User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
            UsrlikdItm.Liked_Item_ID__C=litm.ID;
            UsrlikdItm.User_ID__C=UserInfo.getUserId();                
            insert UsrlikdItm;            
        }       
                   
    } 
    
    Public void LearningUnLike(){    
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:Learningid];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where 
            Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C UsrlikdItm:UsrlikdItms)
                {
                    delete UsrlikdItm;            
                }
            }
        }         
    } 
            
    Private boolean LikedOrNotLearn(string lrngID){
        boolean isLiked = false;    
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c = :lrngID];
        for(Liked_Item__c LikdItm:LikdItms)
        {
            list<User_Liked_Item__c> UsrlikdItms=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c = :UserInfo.getUserId() and Liked_Item_ID__c = :LikdItm.Id];
    
            for(User_Liked_Item__c UsrlikdItm :UsrlikdItms)
            {                       
                 isLiked=true;                                                    
            }
            return isLiked;                
        }  
        return isLiked;    
    }   
      
    //Learning Board Search: redirects to the social learning page to display the search results
    Public PageReference dosearch(){
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
     
    Public class RelatedLearningBoardCustomClass{
        public id AttachmentId{get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
    }       
    
    Public class LearningDtlsCustomClass{
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public boolean StaticImage{get;set;}   
        public integer LikeCount{get;set;}   
        public boolean LikedOrNot{get;set;}  
        public boolean DocLnkXst{get;set;}      
    }       
}