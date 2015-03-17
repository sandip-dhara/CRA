global class AthenaEditLBNew  {
 
    public string LearningBoardId {get;set;}
    public string ChatterLike {get;set;}
    public string ChatterImprovement {get;set;}
    public string ChatterTags  {get;set;}
    public string ChatterComment {get;set;}
    public string TopicId {get;set;}
    Public String strSearchValue{get;set;}

     public AthenaEditLBNew()
     {
       this.LearningBoardId = ApexPages.currentPage().getParameters().get('id');//'a6tZ00000008RI0IAM';
         this.TopicId=ApexPages.currentPage().getParameters().get('TopicId');
         RelatedLearningBoards=new list<RelatedLearningBoardCustomClass>();
     }
 
     Public User getLearningBoardOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl, u.Name, u.FullPhotoUrl,u.AboutMe, u.Email  From User u where u.id in 
        (select ownerid from learning_board__c where id = :LearningBoardId)];
        return U;
    }
 
       public PageReference  NavigateToGlobalSearch()
      {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
      }


  Public boolean IsLearningBoardCreator
    { 
       get
          { 
            AthenaUserAccess usrAccs=new AthenaUserAccess(); 
            if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                return true; 
            else
                return false;
           } 
    }

   Public User GetLoggedinUserDtls(){
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }

     Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

 Public class RelatedLearningBoardCustomClass{
        public id AttachmentId{get;set;}
        public string LBSubTitle {get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
        public String DefaultImageName{get;set;}
        public String LBShortDescription{get;set;}  

    }
     private String GetInstanceResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       }

 
 Public RelatedLearningBoardCustomClass LearningBoardDtls{
        get {
    
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :LearningBoardId];
        
        List<Learning_Board__c>  lrngbrds= [select id, Sub_Title__c, Name__c,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c,
        CreatedDate from Learning_Board__c where ID =:LearningBoardId ];
        //Is_Active__c = True and                            
         
        for(Learning_Board__c lb: lrngbrds){
            RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
        
            lbCustom.LBName = lb.Name__c; 
              lbCustom.LBSubTitle=lb.Sub_Title__c;
            lbCustom.LBDescription=lb.description__c;           
            lbCustom.LbId = lb.Id;            
            lbCustom.StaticImage = true;
            
            if(lbCustom.LBDescription.length()>150)
                {
                    lbCustom.LBShortDescription = lbCustom.LBDescription.substring(0,150) + '...';
                }
                else
                {
                    lbCustom.LBShortDescription=lbCustom.LBDescription;
                }

             if(lb.Default_Image_Name__c!=''){                        
                lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetInstanceResourceURL('img_athena')+ '/img_athena/' + lb.Default_Image_Name__c;          
            }
            
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
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

 
 
   Public  class LearningDtlsCustomClass{
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public String LShortDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public boolean StaticImage{get;set;}   
        public integer LikeCount{get;set;}   
        public boolean LikedOrNot{get;set;}  
        public boolean DocLnkXst{get;set;}
        public boolean IsActive{get;set;}  
        public List<string> Tags{get;set;}   
        public string DefaultImageName{get;set;}  
        public boolean ClientFacing{get;set;}     
        public string hpsharedIcon {get;set;}       
        public string FileUpload  {get;set;}
        public string filePDFUpload {get;set;} 
        public string filePPTUpload {get;set;} 
        public string fileWordUpload {get;set;} 
       
       
    } 
    
    Public  Class LrngDtlsWithCategory{
       public string CategoryId{get;set;}  
       public string CategoryName{get;set;}  
       public List<LearningDtlsCustomClass> lstlrngs{get;set;}  
    }
    
     @RemoteAction
    public static List<LrngDtlsWithCategory> getLrngWithCat(string LrngBrdId)
    {
        //a6tZ00000008RI0IAM
        List<LrngDtlsWithCategory> lsWithCat=new List<LrngDtlsWithCategory>();
        Learning_Board__c  lngBoard= [SELECT Id, Name__c, Is_Active__c, Featured__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: LrngBrdId];
        system.debug('Learninglb:'+lngBoard.Learning_Board_Template_ID__c);
        if(lngBoard.Learning_Board_Template_ID__c==null || lngBoard.Learning_Board_Template_ID__c=='')
        {
             //If Learning Board Doesn't have Template
                List<Learning_category__c> lrngCatlst= [select Name__c,id from Learning_category__c order by Display_Sequence_Nbr__C];
                
                for(Learning_category__c lcc :lrngCatlst)
                {
                   LrngDtlsWithCategory dtlsWithCat=new LrngDtlsWithCategory();
                   dtlsWithCat.CategoryId=lcc.id;
                   dtlsWithCat.CategoryName=lcc.Name__c;
                   lsWithCat.add(dtlsWithCat);
                }
                
        }
        else
        {
        List<Required_Learning_Category__c> lstRequiredLCat =[SELECT Learning_Category_Id__c, Id, Name, Is_Active__c, Learning_Board_Template_ID__c,Learning_Category_Id__r.Name__C FROM Required_Learning_Category__c where Learning_Board_Template_ID__c =:lngBoard.Learning_Board_Template_ID__c];
            for(Required_Learning_Category__c RqrdL :lstRequiredLCat)
                {
                   LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();
                   dtlsWithCats.CategoryId=RqrdL.Learning_Category_Id__c;
                   dtlsWithCats.CategoryName=RqrdL.Learning_Category_Id__r.Name__C;
                   lsWithCat.add(dtlsWithCats);
                }
        }
        
        
        //If Learning Board have Template
            List<LrngDtlsWithCategory> lstLearningBrdCat=GenerateLearningCtgry(lsWithCat,LrngBrdId);
            system.debug('lstLearningBrdCat:'+lstLearningBrdCat.size());
            return lstLearningBrdCat;
        
        
    }
    
       private static String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       } 

   public static List<LrngDtlsWithCategory> GenerateLearningCtgry(List<LrngDtlsWithCategory> LrngDetails, string LrngBoardId)
   {
        list<id> lstLearningIds= new list<id>();
      List<LrngDtlsWithCategory> lstContainer=new List<LrngDtlsWithCategory>();
      List<Learning_Board_Learning__c> lstBoardLearning=[select Learning_ID__c,Learning_ID__r.Name__c,
            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.Default_Image_Name__c ,Learning_ID__r.ClientFacing__c,Learning_ID__r.Practice_Approved__c,Learning_ID__r.Is_Active__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name, Learning_Category_Id__c
            from Learning_Board_Learning__c where 
            Learning_Board_ID__c =:LrngBoardId  order by Display_Sequence_Nbr__c asc];
        system.debug('lstContainer:'+lstContainer.size());
        for (Learning_Board_Learning__c l:lstBoardLearning ) {
                lstLearningIds.add(l.Learning_ID__c);
            }
            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds];
        
        
        for(LrngDtlsWithCategory LCL:LrngDetails)
        {
                LrngDtlsWithCategory lngCat=new LrngDtlsWithCategory();
                lngCat.CategoryId=LCL.CategoryId;
                lngCat.CategoryName=LCL.CategoryName;
                lngCat.lstlrngs=new List<LearningDtlsCustomClass>();
            
                for(Learning_Board_Learning__c learningB:lstBoardLearning)
                {
                    if(learningB.Learning_Category_Id__c==LCL.CategoryId)
                    {
                        LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                        lrng.LName=learningB.Learning_ID__r.Name__c;
                        lrng.LDescription = learningB.Learning_ID__r.Description__c;
                        
                        if(lrng.LDescription.length()>150){
                    
                            lrng.LShortDescription = lrng.LDescription.substring(0,150) + '...';
                        }
                        else{
                            lrng.LShortDescription=lrng.LDescription;
                        }

                        lrng.LOwnerName = learningB.Learning_ID__r.Owner.name; 
                        lrng.LType= learningB.Learning_ID__r.type__c;   
                        lrng.LURL= learningB.Learning_ID__r.URL__C; 
                        lrng.FileUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
                        lrng.hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';

                        lrng.filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
                        lrng.filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
                        lrng.fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';

                        lrng.LId = learningB.Learning_ID__c;
                        lrng.ClientFacing=learningB.Learning_ID__r.ClientFacing__c;
                    
                        lrng.DocLnkXst=false; 
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        List<string> strlst=AthenaUtility.getAssociatedTags(AthenaUtility.Learning,learningB.Learning_ID__r.id);
                        
                        if(strlst.size()==0)
                              strlst.add('No Tags Associated');        
     
                        system.debug('staticimage:'+learningB.Learning_ID__r.Default_Image_Name__c);
                    
                    
                        lrng.Tags=strlst;    
                        
                        if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                              lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                              lrng.LURL=lrng.LURL.replace('http:', 'https:');
                        }
                        else if(lrng.LType=='Video' && lrng.LURL.contains('www.brainshark.com')){
                              lrng.LURL=lrng.LURL+'&dm=5&pause=1&nrs=1';
                              
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
                     
                        if(learningB.Learning_ID__r.type__c!='Video')
                        {        
                            for(Attachment a: Att)
                            { 
                                if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg' || a.ContentType == 'image/gif') )
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
                        
                        if(learningB.Learning_ID__r.Default_Image_Name__c!='')
                        {                        
                                lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + learningB.Learning_ID__r.Default_Image_Name__c;
                                //lrng.DefaultImageName='';
                        }
                        if(!lrng.StaticImage)
                        {
                            lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +'/servlet/servlet.FileDownload?file='+lrng.AttachmentId;
                        }

                        

                        lngCat.lstlrngs.add(lrng);
                    }
                }
            lstContainer.add(lngCat);
        
        }
        system.debug('Container:'+lstContainer.size());
        return lstContainer;
        
   }

  //Insert FeedBackLike,FeedBackImprovement and Rating Comment
    public  Void AddToChatterComment()
    {
        system.debug('ChatterImprovement:'+ChatterImprovement);
        system.debug('ChatterLike:'+ChatterLike);
        if (ChatterLike!=null || ChatterLike!='')
        {
             AthenaUtility.AddToChatterComment(LearningBoardId,AthenaUtility.FeedBackLike,ChatterLike);
        }
         if (ChatterImprovement!=null || ChatterImprovement!='')
        {
             AthenaUtility.AddToChatterComment(LearningBoardId,AthenaUtility.FeedBackImprovement,ChatterImprovement);
        }

        //FeedItem post = new FeedItem();     
        //post.ParentId = LearningBoardId; 
        //post.Body = '#[' + ChatterTags + ']' + ChatterComment;
        //insert post;
        //system.debug('$$$$'+post.id);
        //system.debug('$$$$'+post.Body);
        //system.debug('$$$$'+post.ParentId);
    }

    Public List<User> GetContributors()
    {
        List<User> ContributorsUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:LearningBoardId)];
        return  ContributorsUsers;
    }

  Public List<User> GetFollowers()
    {
        List<User> FollowersUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (select SubscriberID from EntitySubscription where ParentId =:LearningBoardId)];
        return  FollowersUsers;
    }
    

    

public List <RelatedLearningBoardCustomClass> RelatedLearningBoards{
        get {
            RelatedLearningBoards.clear();  
            
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 
                       List<Related_Learning_Board__c>  rLBs =[SELECT Display_Sequence_Nbr__c,Learning_Board_ID__c,Related_Learning_Board_ID__c 
,Related_Learning_Board_ID__r.name__c,Related_Learning_Board_ID__r.Owner.Name,Related_Learning_Board_ID__r.Default_Image_Name__c,Related_Learning_Board_ID__r.description__c,Related_Learning_Board_ID__r.ID,Related_Learning_Board_ID__r.OwnerId
FROM Related_Learning_Board__c where Learning_Board_ID__c=: this.LearningBoardId and Related_Learning_Board_ID__r.Is_Active__c = True order by 
            Display_Sequence_Nbr__c ];

           
              
            for (Related_Learning_Board__c rLB:rLBs) {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Related_Learning_Board__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                
                 if(lb.Related_Learning_Board_ID__r.Default_Image_Name__c!=''){                        
                    lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + lb.Related_Learning_Board_ID__r.Default_Image_Name__c;          
                  }
                lbCustom.LBOwnerName=lb.Related_Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif')){
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
 
}