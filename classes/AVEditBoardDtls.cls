global class AVEditBoardDtls
{
        Public string BoardCategory {get;set;}
          Public String BoardId {get;set;}
          public string BoardDescription{get;set;}
          public id AttachmentId{get;set;}
          public String BoardName{get;set;}
          
          public boolean BoardStaticImage{get;set;} 
          public String BoardOwnerName{get;set;} 
          public boolean BoardPublish{get;set;}
          public boolean BoardFeatured{get;set;}
          public string BoardDefaultImageName{get;set;} 
          public string BoardSubTitle {get;set;}
          public string BoardTemplateId {get;set;}
          public string dropDefaultSelected {get;set;}
          public Attachment BoardAttach {get;set;}
          public string ImageSelectionOption {get;set;}
          public string hdnAddTag {get;set;}
         public  string  hdnChangeOwnerId {get;set;}
         public string CategoryId  {get;set;}
          
        //Topic 
        public string TopicName {get;set;}
        public string TopicDesc {get;set;}
        

     
    public List<SelectOption> getImageOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('UFC','Upload from Computer')); 
        options.add(new SelectOption('DI','Default Image')); 
        return options; 
    }


   Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('athena_images') +'/images/';
        }
    }

public void BoardChangeOwner(){
system.debug('Change :' +hdnChangeOwnerId);
  Learning_Board__c LBO = [SELECT OwnerId, Id, Name FROM Learning_Board__c where Id =:BoardId limit 1];
        LBO.OwnerId = hdnChangeOwnerId;
        update LBO;
}

public AVEditBoardDtls(ApexPages.StandardController controller) {
        BoardId = ApexPages.currentPage().getParameters().get('id');
        BoardAttach = new Attachment();
        LearningBoardDtls();
    }

public string LBAssociatedTags{
    get{    
    List<string> strlst=AthenaUtility.getAssociatedTags(AthenaUtility.LearningBoard,BoardId);
    string AssTags='';
    for(string str:strlst){
        AssTags+=str + ',';
    }
    if(AssTags.endsWith(','))
    {
        AssTags = AssTags.removeEnd(',');
    }
    return AssTags;
    }
set {LBAssociatedTags = value;}
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


Public List<SelectOption> getTopicCategory(){
            
        List<SelectOption> LstCategories= new List<SelectOption>();
        LstCategories.add(new SelectOption('','--Select Category--'));
        
                                Learning_Board__c  lngBoard= [SELECT Id, Name__c, Is_Active__c, Featured__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: BoardId];
        system.debug('Learninglb:'+lngBoard.Learning_Board_Template_ID__c);
        string strLBTemplate=lngBoard.Learning_Board_Template_ID__c;
        if(strLBTemplate==null)
                                {
                                  List<Learning_category__c> lrngCatlst= [select Name__c,id from Learning_category__c where Is_Active__c=True order by Display_Sequence_Nbr__C];               
                                   
                                   for(Learning_category__c lc:lrngCatlst){
            LstCategories.add(new SelectOption(lc.id,lc.name__c));    
                                                }
                                
                                }
                                else
                                {
                                
                                List<Required_Learning_Category__c> rlcatlst=[SELECT Learning_Category_Id__c,Learning_Category_Id__r.Name__c, Is_Active__c, Learning_Board_Template_ID__c, Display_Sequence_Nbr__c FROM Required_Learning_Category__c where Learning_Category_Id__r.Is_Active__c=true and Is_Active__c=true and Learning_Board_Template_ID__c=:strLBTemplate order by Display_Sequence_Nbr__c];
                                
                                   
                                   for(Required_Learning_Category__c rlc:rlcatlst){
                                        LstCategories.add(new SelectOption(rlc.Learning_Category_Id__c,rlc.Learning_Category_Id__r.Name__c));    
                                                }
                                }
                                  return LstCategories;
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
                        lrng.fileURLUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
                        lrng.hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
system.debug('hpsharedIcon:'+lrng.hpsharedIcon);
                        lrng.filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
                        lrng.filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
                        lrng.fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';

                        lrng.LId = learningB.Learning_ID__c;
                        lrng.ClientFacing=learningB.Learning_ID__r.ClientFacing__c;
                    
                        lrng.DocLnkXst=false; 
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        //List<string> strlst = AthenaUtility.getAssociatedTags(AthenaUtility.Learning,learningB.Learning_ID__r.id);
                        List<string> strlst=new List<string>();
                        if(strlst.size() == 0)
                              strlst.add('No Tags Associated');        
                        
                        integer strSize = strlst.size();
                        
                        

                        system.debug('staticimage suman:'+ strSize);

                        system.debug('staticimage:'+learningB.Learning_ID__r.Default_Image_Name__c);
                    
                    
                        lrng.Tags = strlst;    
                        
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


  //private String GetResourceURL(String resourceName)  
  //    {  
  //      //Fetching the resource 
  //      List<StaticResource> resourceList= new List<StaticResource>();
  //      resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
  //      //Checking if the result is returned or not  
  //      if(resourceList.size() == 1)  
  //      {  
  //         //Getting namespace  
  //         String namespace = resourceList[0].NamespacePrefix;  
  //         //Resource URL  
  //         return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
  //      }  
  //      else return '';  
  //     }

    Public List<SelectOption> getBoardTemplates(){
            
        List<SelectOption> LstTemplates= new List<SelectOption>();
        LstTemplates.add(new SelectOption('','--Select template--'));
        
        for(Learning_Board_Template__c LBC:[select id,Name__c from Learning_Board_Template__c where is_active__c=true]){
            LstTemplates.add(new SelectOption(LBC.id,LBC.name__c));    
        }
        return LstTemplates;
     }

    Public User GetLoggedinUserDtls(){
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }


 Public User getLearningBoardOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe,u.Name, u.Division, u.Department, 
        u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id in 
        (select ownerid from learning_board__c where id = :BoardId)];
        return U;
    }
    
     Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

 Public List<SelectOption> DefaultImagefilename{
     get{
            List<string> lstImgFileName=new List<string>();
            string imageFileNames = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningBoardDefaultImages);
            lstImgFileName = imageFileNames.split(',');
            List<SelectOption> options = new List<SelectOption>();
            integer index;
            options.add(new selectOption('selectImage', '- Select Image -'));
            for(index=0;index<lstImgFileName.size();index++){
                string strText=lstImgFileName[index];               
                options.add( new SelectOption(lstImgFileName[index],strText.split('\\.')[0]));
            }
            return options;
        }
    set;    
    }



      public void BoardImageupload()
        {       
 
    try
    {
           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');
       
            if(ImageSelectionOption=='DI'){
 
                If(dropDefaultSelected!='SelectImage')
                {
 
                    Learning_Board__c lb=[SELECT Default_Image_Name__c,Description__c,Featured__c,Id,Is_Active__c,Name FROM Learning_Board__c Where id =: BoardId];
                    lb.Default_Image_Name__c=dropDefaultSelected;
                    update lb;
                    List<Attachment> lbatt=[select id from Attachment where ParentId =:BoardId ];
                    delete lbatt;
                }
 
            }
            else if(ImageSelectionOption=='UFC'){

                If(BoardAttach!=null)
                {
                    If(BoardAttach.contenttype!='')
                    {
                        List<Attachment> lbatt=[select id from Attachment where ParentId =:BoardId ];
                        delete lbatt;
                        BoardAttach.ParentId =BoardId;
                        insert BoardAttach;
                        Learning_Board__c lb=[SELECT Default_Image_Name__c,Description__c,Featured__c,Id,Is_Active__c,Name FROM Learning_Board__c Where id =:BoardId];
                        lb.Default_Image_Name__c='';
                        update lb;

                    }
                }
            
        
            }
       
}
catch (DMLException e) 
{

}
 finally
    {
 
      BoardAttach = new Attachment();
 
    }
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
        public string fileURLUpload  {get;set;}
        public string filePDFUpload {get;set;} 
        public string filePPTUpload {get;set;} 
        public string fileWordUpload {get;set;} 
       
       
    }

  global  Class LrngDtlsWithCategory{
       public string CategoryId{get;set;}  
       public string CategoryName{get;set;}  
       public List<LearningDtlsCustomClass> lstlrngs{get;set;}  
    }

    Public void LearningBoardDtls()
    {
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :BoardId];
        
        Learning_Board__c  LearningBoards= [select id,Name__c,Sub_Title__c ,Learning_Board_Template_ID__c ,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,
        CreatedDate from Learning_Board__c where ID =:BoardId ];

        BoardName=LearningBoards.Name__c;
        BoardDescription=LearningBoards.description__c;
        BoardSubTitle=LearningBoards.Sub_Title__c;
        BoardTemplateId=LearningBoards.Learning_Board_Template_ID__c;
        BoardPublish=LearningBoards.Is_Active__c ;
        BoardFeatured=LearningBoards.Featured__c;
        
        if(LearningBoards.Default_Image_Name__c!='')
            {                        
                BoardDefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + LearningBoards.Default_Image_Name__c;          
            }
                        
            BoardStaticImage = true;
            for(Attachment att: attachmentList)
            {
                if(BoardId == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    AttachmentId = att.Id;                
                    BoardStaticImage = false;
                }  
            }

    }

 @RemoteAction
    global static List<LrngDtlsWithCategory> getLrngWithCat(string BoardId)
    {
        //a6tZ00000008RI0IAM
        List<LrngDtlsWithCategory> lsWithCat=new List<LrngDtlsWithCategory>();
        Learning_Board__c  lngBoard= [SELECT Id, Name__c, Is_Active__c, Featured__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: BoardId];
        system.debug('Learninglb:'+lngBoard.Learning_Board_Template_ID__c);
        string strLBTemplate=lngBoard.Learning_Board_Template_ID__c;
        if(strLBTemplate==null)
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
        List<Required_Learning_Category__c> lstRequiredLCat =[SELECT Learning_Category_Id__c, Id, Name, Is_Active__c, Learning_Board_Template_ID__c,Learning_Category_Id__r.Name__C FROM Required_Learning_Category__c where Learning_Board_Template_ID__c =:strLBTemplate];
            for(Required_Learning_Category__c RqrdL :lstRequiredLCat)
                {
                   LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();
                   dtlsWithCats.CategoryId=RqrdL.Learning_Category_Id__c;
                   dtlsWithCats.CategoryName=RqrdL.Learning_Category_Id__r.Name__C;
                   lsWithCat.add(dtlsWithCats);
                }
        }
        
        
        //If Learning Board have Template
            List<LrngDtlsWithCategory> lstLearningBrdCat=GenerateLearningCtgry(lsWithCat,BoardId);
            system.debug('lstLearningBrdCat:'+lstLearningBrdCat.size());
            return lstLearningBrdCat;
        
        
    }


public void UpdateBoard()
    {
           Learning_Board__c LearningBoards=[SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c,  Default_Image_Name__c FROM Learning_Board__c where id=:BoardId limit 1];

        LearningBoards.Name__c=BoardName;
        LearningBoards.description__c=BoardDescription;
        LearningBoards.Sub_Title__c=BoardSubTitle;
        LearningBoards.Learning_Board_Template_ID__c=BoardTemplateId;
        LearningBoards.Is_Active__c =BoardPublish;
        LearningBoards.Featured__c=BoardFeatured;

        List<string> strLst=new List<string>();
                    If(hdnAddTag.trim() != '')
                    {
                        strLst=hdnAddTag.split(',');
                    }
        system.debug('LBAssociatedTags:'+hdnAddTag);

        if (strLst != null && strLst.size() > 0 && hdnAddTag.trim() != '')
        {
            AthenaUtility.AssociateTags(strLst,AthenaUtility.LearningBoard, BoardId);
        }

         update LearningBoards;
                  

                   
             
                //AthenaUtility.AssociateTags(strLst,AthenaUtility.LearningBoard,BoardId);
        

    }

//Veeresh Below Code - Start
          public string contrId  {get;set;}   
  Public List<User> GetFollowers()
    {
        List<User> FollowersUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (select SubscriberID from EntitySubscription where ParentId =:BoardId)];
        return  FollowersUsers;
    }       
        
    Public List<User> GetContributors()
    {
        List<User> ContributorsUsers =  [Select id, Name,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:BoardId)];
        return  ContributorsUsers;
    }
    
    public void AddContributor()
    {
        Learning_Board__Share lbContr= new Learning_Board__Share();
        lbContr.ParentId=BoardId;
        lbContr.AccessLevel='Edit';
        lbContr.UserOrGroupId=contrId;       
        insert lbContr;
        
        User usr=[Select Name,email from User where id=:contrId];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {usr.Email};
        mail.setToAddresses(toAddresses);       
        mail.setSubject('You have been added as Contributor for the Learning Board - ' + BoardName); 
        //mail.setUseSignature(false);

        string bodyString = 'Hi ' + usr.Name + ',';
        //bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        //bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><span style="fon

        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }
    
    public void RemoveContributor()
    {
        Learning_Board__Share lbContr=[SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:BoardId and UserOrGroupId=:contrId];
        delete lbContr;
    }

//Veeresh Below Code - End 

}