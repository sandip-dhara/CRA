global class AthenaEditBoardDtls
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
        public string AvailTags{get;set;}
          
        //Topic 
//Topic Create
public string CreateTopicName {get;set;}
public string CreateTopicDesc {get;set;}
public boolean CreateTopicPublish {get;set;}
public boolean CreateTopicClientFacing {get;set;}
public boolean CreateTopicPracticeApprv {get;set;}
public string CreateTypeOfTopic {get;set;}
public string CreateImageSelectionTopic {get;set;}
public string CreateTopicCtgryId {get;set;}
public string CreateTopicVideoURL {get;set;}
    public string TopicTags {get;set;}
public string CreateTopicDefaultSelected {get;set;}
public string SearchTopicIds {get;set;}
public string SearchCtgry {get;set;}


        public string TopicId {get;set;}
        public string TopicName {get;set;}
        public string TopicDesc {get;set;}
        public string dropTopicDefaultSelected {get;set;}
        public string ImageSelectionTopic {get;set;}
        public Attachment BoardTopicAttach {get;set;}        
        public boolean TopicPublish{get;set;}
          public boolean TopicFeatured{get;set;}
        public boolean TopicClientFacing{get;set;}
          public boolean TopicPracticeApprv{get;set;}
        public string TypeOfTopic {get;set;}
public string TopicVideoURL {get;set;}
public string TopicVideoDocURL {get;set;}
public string TopicCtgryId {get;set;}
public string LearningLink {get;set;}
public string hdnTopicCatId {get;set;}

public string DTopicId  {get;set;}
public Attachment TopicAttach {get;set;}

// Suman Start Code Here
        public string hdnRelatedLB {get;set;} 
        public string hdnRelBrdId {get;set;}
        public string hdnContributeId {get;set;}
        public string hdnContributeDummy {get;set;}

        // Suman Start Code Here - Today
        public SelectOption[] ChangeOrderRelatedLearningBoard {get;set;}
        public string hdnNewContributorId { get; set;}
        public User UserOwnerDetails {get;set;}
        public User UserDetails {get;set;}
        public boolean IsBoardModeratorOrOwner {get;set;}        

//Suman Start Code Thursday
        Public String strSearchValue{get;set;}
        public string UserTags {get;set;}
        public string ContributorId {get;set;}


        Public class RelatedLearningBoardCustomClass
        {
            public id AttachmentId{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public boolean StaticImage{get;set;} 
            public String LBOwnerName{get;set;} 
            public boolean LB_Active{get;set;}
            public boolean LB_Featured{get;set;}
            public string DefaultImageName{get;set;} 
        }       
    
        // Suman Start End Here

     
    public List<SelectOption> getImageOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('UFC','Upload from Computer')); 
        options.add(new SelectOption('DI','Default Image')); 
        return options; 
    }

        public PageReference DoCancel()
        {
            PageReference pRef = new PageReference('/apex/AthenaLearningBoardDtls');
            pRef.getParameters().put('id', BoardId);
            pRef.setRedirect(true);
            return pRef;
        }

public PageReference  doSearch()
      {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
      }


  public void CreateSearchTopic(){

system.debug('SearchTopicIds:'+SearchTopicIds);
system.debug('BoardId:'+BoardId);
system.debug('SearchCtgry:' + SearchCtgry);

        List<Learning_Board_Learning__c> groupedResults = [SELECT Id FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:BoardId];

         integer maxDsplySeqNo = 0;
         if(groupedResults==null)
            {
               maxDsplySeqNo=1;
            } 
            else
            {
               maxDsplySeqNo = groupedResults.size() + 1;
            }    
        List<Learning_Board_Learning__c> LBLList=new  List<Learning_Board_Learning__c>();
 
        String[] splitInput = SearchTopicIds.split(',');
        List<String> LBvalues = new List<String>( splitInput );
 
        for(string LLst : LBvalues){
            Learning_Board_Learning__c LBL = new Learning_Board_Learning__c();
            LBL.Learning_ID__c = LLst;
            LBL.Learning_Board_ID__c = this.BoardId;
            LBL.Display_Sequence_Nbr__c =maxDsplySeqNo;
            LBL.Learning_Category_Id__c= SearchCtgry;
            LBLList.add(LBL);  
        }
        insert LBLList;    
    }


 public List<SelectOption> getLearningType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('TopicType','Select type of learning')); 
        options.add(new SelectOption('Text','Text/Image')); 
options.add(new SelectOption('Video','Video')); 
options.add(new SelectOption('LinkORDoc','Link/Document')); 

        return options; 
    }



   Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('athena_images') +'/images/';
        }
    }

public void BoardChangeOwner()
    {
        system.debug('Change :' +hdnChangeOwnerId);

        List<User> ContributorsUsers =  [Select id From User where id IN (SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:BoardId)];

        Learning_Board__c LBO = [SELECT OwnerId, Id, Name FROM Learning_Board__c where Id =:BoardId limit 1];
        LBO.OwnerId = hdnChangeOwnerId;
        update LBO;
      
        List<Learning_Board__Share> lbshareLst=new List<Learning_Board__Share>();

        for (User u:ContributorsUsers)
        {
            if (hdnChangeOwnerId != u.id)
            {
                  Learning_Board__Share lbshare=new Learning_Board__Share();
                  lbshare.UserOrGroupId=u.id;
                  lbshare.ParentId=BoardId;
                  lbshare.AccessLevel='Edit';
                  lbshareLst.add(lbshare);
            }
        }
        insert lbshareLst;

        system.debug('#############3 contributor size ##########'+ lbshareLst.size());

        User usr=[Select Name,email from User where id=: hdnChangeOwnerId];
        
        User user = GetLoggedinUserDtls();        

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {usr.Email};
        mail.setToAddresses(toAddresses);       
        mail.setSubject('You are the new owner of this Learning Board - ' + BoardName); 
        mail.setUseSignature(true);

        string bodyString = '';
        bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You are the new owner of this Learning Board - '+BoardName+'</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+user.Name+'</span></h3></td></tr></tbody></table>';

        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }


public AthenaEditBoardDtls(ApexPages.StandardController controller) {
        BoardId = ApexPages.currentPage().getParameters().get('id');
        BoardAttach = new Attachment();
        BoardTopicAttach=new Attachment();
        TopicAttach=new Attachment();
        RelatedLearningBoards = new list<RelatedLearningBoardCustomClass>();

        // Suman Added code
        UserOwnerDetails = getLearningBoardOwnerDtls();
        UserDetails = GetLoggedinUserDtls();
        CheckIfModeratorOrOwner();
        
        GetRelatedLB();

        LearningBoardDtls();
AvailTags=AthenaUtility.getAvailableTags();  
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

 @RemoteAction
    global static List<Learning__c> LearningSearch(string strSearch,string LearningBrdId)
    {
                        List<Learning__c> relLBs=SearchLearning(strSearch,LearningBrdId);
                          return relLBs;
    }

Public static List<Learning__c> SearchLearning(String SearchStr,string LearningBrdId){
            String  SearchStrWithLike= '%'+ SearchStr+ '%';
            SET<ID> lrngIds = new SET<ID>();
            SET<ID> LrngIdsSet = new SET<ID>();
           
            List<Learning__c> lrngSrchRslt= new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);//stroing list of learing boards where name like cloud

           LIST<Learning__c> lstLrng = new LIST<Learning__c>([select id from Learning__c]);
            for (Learning__c l :lstLrng){
            lrngIds.add(l.id);
            }
            List<Tag_Item__c> tagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c = : SearchStr) and Item_Name__c=:AthenaUtility.Learning and Item_Identifier__c IN :lrngIds];

            for(Tag_Item__c TagItm : tagItmLst){
            LrngIdsSet.add(TagItm.Item_Identifier__c);
            }

            for(Learning__c Lrng : lrngSrchRslt){
            LrngIdsSet.add(Lrng.id);
            }

            List<learning_Board_Learning__c> LrngBrdLrngLst =[select id,learning_ID__c from learning_Board_Learning__c where Learning_Board_ID__c =:LearningBrdId];
            boolean flag;
            set<ID> finalLrngIds  = new set<ID>();
            for(ID l : LrngIdsSet){
                flag=false;
                for(learning_Board_Learning__c lbl : LrngBrdLrngLst){
                    if(lbl.Learning_ID__c == l){
                        flag=true;
                    }          
                }
                if(flag==false){
                    finalLrngIds.add(l);
                }   
            }

            List<Learning__c> lstLearnings = [SELECT Id,Name__c FROM Learning__c Where id IN:finalLrngIds and Is_Active__c=true order by LastModifiedDate Desc];
            return lstLearnings;
     }

@RemoteAction
 global static void RemoveTopic(string TopicId, string TopicName,string BoardId){
        Learning_Board_Learning__c LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =:TopicId AND Learning_Board_ID__c =:BoardId Limit 1];
        delete LBL;
 
    } 

public void DeleteTopic()
{
system.debug('DTopicId:'+DTopicId);
   Learning_Board_Learning__c LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =:DTopicId AND Learning_Board_ID__c =:BoardId Limit 1];
        delete LBL;
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

   string FileURLUpload= 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
    string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
    //system.debug('hpsharedIcon:'+lrng.hpsharedIcon);
                      string  filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
                        string filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
                        string fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';
    string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
    string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';

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

        List<string> lstTags=new List<string>(); 
        List<Tag_Item__c> tagItmlst = new List<Tag_Item__c>();
        tagItmlst = [SELECT Item_Identifier__c,Tag_ID__r.Value__c FROM Tag_Item__c WHERE Item_Name__c=:AthenaUtility.Learning  and Item_Identifier__c in :lstLearningIds];// 
        

                Map<String,List<String>> TagMap = new Map<String,List<string>>();
                                List<string> lstags=new List<string>();
                                for (Tag_Item__c ti : tagItmlst){            
            if(!TagMap.containskey(ti.Item_Identifier__c)){
                                                                lstags=new List<string>();
                                                                lstags.add(ti.Tag_ID__r.Value__c);
                TagMap.put(ti.Item_Identifier__c,lstags);
            }
            else{
                lstags = TagMap.get(ti.Item_Identifier__c);
                                                                lstags.add(ti.Tag_ID__r.Value__c);
                TagMap.put(ti.Item_Identifier__c,lstags);            
            }
        }


        
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
                       lrng.PracticeApprv=learningB.Learning_ID__r.Practice_Approved__c;
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        lrng.fileURLUpload=FileURLUpload;
                        lrng.hpsharedIcon=hpsharedIcon;
                        lrng.filePDFUpload=filePDFUpload;
                        lrng.filePPTUpload=filePPTUpload;
                        lrng.fileWordUpload=fileWordUpload;
                        lrng.HPCertification=HPCertification;
                        lrng.HPPublish=HPPublishIcon;


                        //lrng.fileURLUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
//                        lrng.hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
//system.debug('hpsharedIcon:'+lrng.hpsharedIcon);
//                        lrng.filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
//                        lrng.filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
//                        lrng.fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';

                        lrng.LId = learningB.Learning_ID__c;
                        lrng.ClientFacing=learningB.Learning_ID__r.ClientFacing__c;
                    
                        lrng.DocLnkXst=false; 
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        //List<string> strlst = AthenaUtility.getAssociatedTags(AthenaUtility.Learning,learningB.Learning_ID__r.id);

                        
                        List<string> strlst =new List<string>();
                        if(strlst.size() == 0)
                              strlst.add('No Tags Associated');        
                        
                        integer strSize = strlst.size();
                        
                        

                        system.debug('staticimage suman:'+ strSize);

                        system.debug('staticimage:'+learningB.Learning_ID__r.Default_Image_Name__c);

                    lrng.Tags=strlst;
                    if(TagMap.containskey(learningB.Learning_ID__r.id))
                    {                        
                     lrng.Tags=  TagMap.get(learningB.Learning_ID__r.id);    
                      
                    }

                    
                        
                        
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
//Temp Fix: Method call fro board image refresh
       LearningBoardDtls();
       
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
        public boolean PracticeApprv {get;set;}
        public string HPCertification {get;set;}
        public string HPPublish {get;set;}
        
       
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


public void CreateLearningAndAssociate()
{
   try
    {
            system.debug('TopicTags:'+TopicTags);
             system.debug('TopicName:'+CreateTopicName);
                system.debug('TopicDesc:'+CreateTopicDesc);
                system.debug('TopicPublish:'+CreateTopicPublish);
                system.debug('TopicClientFacing:'+CreateTopicClientFacing);
                system.debug('TopicPracticeApprv:'+CreateTopicPracticeApprv);
                system.debug('TypeOfTopic:'+CreateTypeOfTopic);
                system.debug('ImageSelectionTopic:'+CreateImageSelectionTopic);
                system.debug('TopicCtgryId:'+CreateTopicCtgryId);
system.debug('CreateTopicVideoURL:'+CreateTopicVideoURL);
system.debug('CreateTopicDefaultSelected:'+CreateTopicDefaultSelected);              

                                Learning__c learning= new Learning__c();
                                learning.Name__c = CreateTopicName;
                                learning.Description__c = CreateTopicDesc;
                                learning.Is_Active__c = CreateTopicPublish;
                                learning.Default_Image_Name__c = '';
                                learning.ClientFacing__c = CreateTopicClientFacing;
                                learning.Practice_Approved__c = CreateTopicPracticeApprv;
      

        if(CreateTypeOfTopic==AthenaUtility.LearningTypeText)
                                {
                                                //Text
                                                learning.Type__c=AthenaUtility.LearningTypeText;
                                }
        else if (CreateTypeOfTopic==AthenaUtility.LearningTypeVideo)
                                {
                                //Video
                                                learning.URL__c = CreateTopicVideoURL;
                                                learning.Type__c=AthenaUtility.LearningTypeVideo;
                                }
        else if(CreateTypeOfTopic=='LinkORDoc')
                                {//url or document
                                                learning.URL__c = CreateTopicVideoURL;
                                                learning.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
        }
        
        if(CreateTypeOfTopic!=AthenaUtility.LearningTypeVideo)
        {    
             if(CreateImageSelectionTopic=='UFC')
             {
                learning.Default_Image_Name__c='';
                insert learning;
                system.debug('learningid::'+learning.id);
                BoardTopicAttach.ParentId = learning.id;
                insert BoardTopicAttach ;
               
            }
            else  if(CreateImageSelectionTopic=='DI')
           {
                learning.Default_Image_Name__c = CreateTopicDefaultSelected;
                insert learning; 
            }
        }
        else if(learning.Type__c==AthenaUtility.LearningTypeVideo)
        {
                learning.Default_Image_Name__c='';
                insert learning;
        }

                                if (TopicTags!=null)
                                                {
                                                                  List<string> strLstTags=new List<string>();
                                                                  strLstTags=TopicTags.split(',');
                                                                  AthenaUtility.AssociateTags(strLstTags,AthenaUtility.Learning, learning.id);
                                                }
        system.debug('BoardId:'+BoardId);

                                List<Learning_Board_Learning__c> lstLrnBrdLrng=[SELECT id,Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:BoardId];
                                integer iMax=0;    
system.debug('lstLrnBrdLrng:'+lstLrnBrdLrng);
                                if(lstLrnBrdLrng.size()==0)
                                {
                                                iMax=1;
                                } 
                                else
                                {
                                                iMax= lstLrnBrdLrng.size()+1;
                                }          
                                 
                                system.debug('aResult: '+iMax);

                                Learning_Board_Learning__c lrngBrdLrng= new Learning_Board_Learning__c();
                                lrngBrdLrng.Learning_ID__c = learning.id;
                                lrngBrdLrng.Learning_Board_ID__c = BoardId;
                                lrngBrdLrng.Learning_Category_Id__c=CreateTopicCtgryId;//TopicCtgryId; //Category Id
                                lrngBrdLrng.Display_Sequence_Nbr__c =iMax;         
                                insert lrngBrdLrng;
        
    }

    catch (DMLException e) {
        } 
    finally {
         //Lrngattach= null; // clears the viewstate
         BoardTopicAttach=new Attachment();       
 CreateTopicName =''; 
 CreateTopicDesc=''; 
 CreateTopicPublish=false; 
 CreateTopicClientFacing=false; 
 CreateTopicPracticeApprv=false; 
 CreateTypeOfTopic='';
 CreateImageSelectionTopic ='';
 CreateTopicCtgryId ='';
        CreateTopicVideoURL='';
CreateTopicDefaultSelected='';
         }
               
    }

public void DeleteBoar(){
           system.debug('BoardId:'+BoardId);
 system.debug('LBAssociatedTags:'+hdnAddTag);
 
}


        public void UpdateBoard()
        {
            system.debug('BoardId:'+BoardId);
            system.debug('LBAssociatedTags:'+hdnAddTag);
            Learning_Board__c LearningBoards=[SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c,  Default_Image_Name__c FROM Learning_Board__c where id=:BoardId limit 1];

            LearningBoards.Name__c=BoardName;
            LearningBoards.description__c=BoardDescription;
            LearningBoards.Sub_Title__c=BoardSubTitle;
            LearningBoards.Learning_Board_Template_ID__c=BoardTemplateId;
            LearningBoards.Is_Active__c =BoardPublish;
            LearningBoards.Featured__c=BoardFeatured;
            update LearningBoards;
        
            List<string> strLst = new List<string>();
                    
            if(UserTags.trim() != '')
            {
                strLst = UserTags.split(',');
            }
            if (strLst != null && strLst.size() > 0 && UserTags.trim() != '')
            {
                AthenaUtility.AssociateTags(strLst, AthenaUtility.LearningBoard, BoardId);
            }
        }

// Suman Code Start Here

  public string contrId  {get;set;}   

 Public boolean IsBoardCreator(string userId)
        {
            AthenaUserAccess usrAccs=new AthenaUserAccess();
            if(usrAccs.IsModerator(userId) || usrAccs.IsProducer(userId))
            {
                return true;
            }                              
            else
            {
                return false;
            }
        }

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

public void testSuman()
{
system.debug('################Mahesh Babu###################');
}
    
    //Method used to add contributors for learning board
    public void AddContributor()
    {
system.debug('hdnNewContributorId:'+hdnNewContributorId);
system.debug('UserOwnerDetails:'+UserOwnerDetails.id);
        //If owner id and contributor id are no the same, get contributors
        if (UserOwnerDetails.id != hdnNewContributorId)
        {
            Learning_Board__Share lbContr= new Learning_Board__Share();
            lbContr.ParentId = BoardId;
            lbContr.AccessLevel = 'Edit';
            //lbContr.UserOrGroupId = contrId;       
        
            system.debug('####### suman contributor ##############' + hdnNewContributorId);
            lbContr.UserOrGroupId = hdnNewContributorId;
            insert lbContr;
        
            User usr=[Select Name,email from User where id =:hdnNewContributorId];
        
            Messaging.SingleEmailMessage mail;  
            string bodyString = '';
            string[] toAddresses;

            if(!IsBoardCreator(hdnNewContributorId))
            {
                mail = new Messaging.SingleEmailMessage();
                                                
                system.debug('#########contributor email#########'+ usr.Email);
                toAddresses = new String[] {usr.Email};                                    

                mail.setToAddresses(toAddresses);       
                mail.setSubject('Provide Access to  ' + usr.Name + ' for Producer access '); 
                mail.setCCAddresses( new String[]{'esds-athena-team@hp.com'});

                bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You have been added as a contributor, The team will provide user access and update.</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
             }
            else
            {
            
                //Adding Permission - Start

                List<Learning_Board_Learning__c> LrngBrdLrngs=[SELECT Learning_ID__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c=:BoardId];

                List<string> lstLrngs=New List<string>();


                for(Learning_Board_Learning__c lrng:LrngBrdLrngs)
                {
                    lstLrngs.add(lrng.Learning_ID__c);
                }
                List<Learning__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Learning__Share where UserOrGroupId =:hdnNewContributorId and ParentId IN:lstLrngs];

                Map<string,string> MapLrng= New Map<string,string>();
                for(Learning__Share lrngShare:lstLrngShare)
                {
                    MapLrng.put(lrngShare.ParentId,lrngShare.UserOrGroupId);            
                }

                lstLrngShare=new List<Learning__Share>();
                for(string lrng:lstLrngs)
                {
                    if(!MapLrng.containsKey(lrng))
                    {
                        Learning__Share lrngShare=new Learning__Share();
                        lrngShare.ParentId=lrng;
                        lrngShare.AccessLevel='Edit';
                        lrngShare.UserOrGroupId=hdnNewContributorId;         
                        lstLrngShare.add(lrngShare);
                    }
                }
                insert lstLrngShare;
                
                //Adding Permission - End
            
            
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new String[] {usr.Email};
                mail.setToAddresses(toAddresses);       
                mail.setSubject('You have been added as Contributor for the Learning Board - ' + BoardName); 
                //mail.setUseSignature(false);

                bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You have been added as Contributor for the Learning Board - '+BoardName+'</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';


                mail.setHtmlBody(bodyString);

                //Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
        }
    }
    
    public void RemoveContributor()
    {
        Learning_Board__Share lbContr=[SELECT UserOrGroupId FROM Learning_Board__Share where AccessLevel='Edit' and ParentId=:BoardId and UserOrGroupId=:ContributorId];
        delete lbContr;

        User usr=[Select Name,email from User where id=:ContributorId];
        
        //User user = GetLoggedinUserDtls();        

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {usr.Email};
        mail.setToAddresses(toAddresses);       
        mail.setSubject('You have been removed as Contributor for the Learning Board - ' + BoardName); 
        mail.setUseSignature(true);

        string bodyString = '';
        bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You have been removed as Contributor for the Learning Board - '+BoardName+'</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';

        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }

@RemoteAction
    global static List<Learning_Board__C> AddRelatedLB(string strSearch, string strLBID)
    {
        List<Learning_Board__C> relLBs = SearchRelatedLearningBoard(strSearch,strLBID);
        return relLBs;
    }

    //Related Learning Board - Start 
 
    Public static List<Learning_Board__c> SearchRelatedLearningBoard(string SearchStr, string strLBID)
    {
        
        String  SearchStrWithLike= '%'+ SearchStr + '%';
         
        SET<ID> lbBrdIds = new SET<ID>();
        SET<ID> lbBrdIdSet = new SET<ID>();
        List<Learning_Board__c> lbBrdSrchRslt = new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);
        
        
        LIST<Learning_Board__c> lstAlllbBrds = new LIST<Learning_Board__c>([select id from Learning_Board__c]);
        for (Learning_Board__c l :lstAlllbBrds)
        {
            lbBrdIds.add(l.id);
        }
        
        List<Tag_Item__c> tagItmLst=[
        SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: SearchStr) and Item_Name__c=:AthenaUtility.LearningBoard  and Item_Identifier__c IN :lbBrdIds];
        
        
        for(Tag_Item__c TagItm : tagItmLst)
        {
             lbBrdIdSet.add(TagItm.Item_Identifier__c);
        }
        system.debug('lbBrdIdSet1'+lbBrdIdSet);

        for(Learning_Board__c lb : lbBrdSrchRslt)
        {
             lbBrdIdSet.add(lb.id);
        }

        if(lbBrdIdSet.contains(strLBID))
        {
            lbBrdIdSet.remove(strLBID);
        }
        
        List<Related_learning_Board__c > rltdLrngBrdLst =[select id,Related_Learning_Board_ID__c from Related_learning_Board__c where Learning_Board_ID__c =:strLBID];
        boolean flag;
        set<ID> finalLrngBrdIds = new set<ID>();
        for(ID l : lbBrdIdSet)
        {
            flag=false;
            for(Related_learning_Board__c lbl : rltdLrngBrdLst)
            {
                if(lbl.Related_Learning_Board_ID__c == l)
                {
                    flag=true;
                }          
            }
            if(flag==false)
            {
                finalLrngBrdIds.add(l);
            }   
        }       
        List<Learning_Board__c> lbList = new List<Learning_Board__c>([SELECT Id,Name__c FROM Learning_Board__c where id IN:finalLrngBrdIds and Is_Active__c=true order by LastModifiedDate Desc]);

        return lbList;
    } 

    public void SaveRelatedLB()
    {
        list<Related_Learning_Board__c> groupedResults = [SELECT Id FROM Related_Learning_Board__c WHERE Learning_Board_ID__c =:this.BoardId];
        
        integer maxDsplySeqNo = 0;
         if(groupedResults==null)
         {
            maxDsplySeqNo=1;
         } 
         else
         {
            maxDsplySeqNo = groupedResults.size() + 1;
         }    

        List<Related_Learning_Board__c> rltdLrngBrdLst=new List<Related_Learning_Board__c>();
 
        String[] splitInput = hdnRelatedLB.split(',');
        List<String> LrngBrdIds = new List<String>( splitInput );
        system.debug('LrngBrdIds:' +LrngBrdIds);
        system.debug('splitInput:' +splitInput);
        system.debug('maxDsplySeqNo:' +maxDsplySeqNo);

 
        for(string LrnBrdId : LrngBrdIds)
        {
            Related_Learning_Board__c rltdLrngBrd = new Related_Learning_Board__c();
            rltdLrngBrd.Related_Learning_Board_ID__c = LrnBrdId;
            rltdLrngBrd.Learning_Board_ID__c = this.BoardId;
            rltdLrngBrd.Display_Sequence_Nbr__c = maxDsplySeqNo;
            rltdLrngBrdLst.add(rltdLrngBrd);
        }
        insert rltdLrngBrdLst;
//GetRelatedLB();
    }

        public List <RelatedLearningBoardCustomClass> RelatedLearningBoards
        {
            get {
                RelatedLearningBoards.clear();  
            
                list<id> lstRLBIds= new list<id>();
                list<Attachment> attachmentList = new List<Attachment>(); 
            
            
            List<Related_Learning_Board__c>  rLBs =[SELECT Display_Sequence_Nbr__c,Learning_Board_ID__c,Related_Learning_Board_ID__c 
            ,Related_Learning_Board_ID__r.name__c,Related_Learning_Board_ID__r.Owner.Name,            Related_Learning_Board_ID__r.description__c,Related_Learning_Board_ID__r.ID,Related_Learning_Board_ID__r.OwnerId
            FROM Related_Learning_Board__c where Learning_Board_ID__c=: this.BoardId and Related_Learning_Board_ID__r.Is_Active__c = True order by 
            Display_Sequence_Nbr__c ];
            
            
          /*  List<Related_Learning_Board__c>  rLBs =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, 
            CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Display_Sequence_Nbr__c, 
            Learning_Board_ID__c,Related_Learning_Board_ID__r.name__c,Learning_Board_ID__r.Owner.Name,
            Related_Learning_Board_ID__r.description__c,Learning_Board_ID__r.ID,Learning_Board_ID__r.OwnerId,
            Learning_Board_ID__r.IsDeleted,Learning_Board_ID__r.Name,Learning_Board_ID__r.CurrencyIsoCode,
            Learning_Board_ID__r.CreatedDate,Learning_Board_ID__r.LastModifiedDate,Learning_Board_ID__r.SystemModstamp,
            Learning_Board_ID__r.LastViewedDate,Learning_Board_ID__r.Name__c,Learning_Board_ID__r.Description__c,
            Learning_Board_ID__r.Featured__c,Learning_Board_ID__r.Is_Active__c from Related_Learning_Board__c where 
            Learning_Board_ID__r.Is_Active__c = True and Learning_Board_ID__r.id=: this.LearningBoardsid order by 
            Display_Sequence_Nbr__c];*/
              
            for (Related_Learning_Board__c rLB:rLBs) {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Related_Learning_Board__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                lbCustom.LBOwnerName=lb.Related_Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/gif')){
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
    
        Public void RemoveRelLearningBoard()
        {
            Related_Learning_Board__c rltdLrngBrd = [Select Id From Related_Learning_Board__c WHERE Related_Learning_Board_ID__c =: hdnRelBrdId AND Learning_Board_ID__c =:this.BoardId Limit 1];
            delete rltdLrngBrd;
        } 

        public void LBChangeOwnerId()
        {
            system.debug('Change :' +hdnChangeOwnerId);
            Learning_Board__c LBO = [SELECT OwnerId, Id, Name FROM Learning_Board__c where Id =:this.BoardId limit 1];
            LBO.OwnerId = hdnChangeOwnerId;
            update LBO;
        }


    public void UpdateTopic()
        {

   try
{
            system.debug('TopicId:'+TopicId);
             system.debug('TopicName:'+TopicName);
                system.debug('TopicDesc:'+TopicDesc);
                system.debug('TopicPublish:'+TopicPublish);
                system.debug('TopicClientFacing:'+TopicClientFacing);
                system.debug('TopicPracticeApprv:'+TopicPracticeApprv);
                system.debug('TypeOfTopic:'+TypeOfTopic);
                system.debug('ImageSelectionTopic:'+ImageSelectionTopic);
                system.debug('TopicCtgryId:'+TopicCtgryId);

        List<string> contype=new List<string>();
        contype.add('image/jpeg');
        contype.add('image/png');
        contype.add('image/jpg');

              

                Learning__c lrng=[SELECT Id, Name__c, Description__c, Is_Active__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Practice_Approved__c FROM Learning__c where id=:TopicId limit 1];

                lrng.Name__c= TopicName;
                lrng.Description__c=TopicDesc;
                lrng.Is_Active__c=TopicPublish;
                lrng.ClientFacing__c = TopicClientFacing;
                lrng.Type__c=TypeOfTopic;
                lrng.Practice_Approved__c = TopicPracticeApprv;
                

if(TypeOfTopic==AthenaUtility.LearningTypeText)
                                {
                                                //Text
                                                lrng.Type__c=AthenaUtility.LearningTypeText;
                                }
        else if (TypeOfTopic==AthenaUtility.LearningTypeVideo)
                                {
                                //Video
                                                lrng.URL__c = TopicVideoURL;
                                                lrng.Type__c=AthenaUtility.LearningTypeVideo;
                                }
        else if(TypeOfTopic=='LinkORDoc')
                                {//url or document
                                                lrng.URL__c = TopicVideoURL;
                                                lrng.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
        }
        
        if(TypeOfTopic!=AthenaUtility.LearningTypeVideo)
        {    
             if(ImageSelectionTopic=='UFC')
             {

                    if(BoardTopicAttach!=null)
                    {

        if (BoardTopicAttach.ContentType!='')
        {
            List<Attachment> lbatt=[select id from Attachment where ParentId =:TopicId ];
            delete lbatt;

            BoardTopicAttach.ParentId = TopicId;
            insert BoardTopicAttach;
            lrng.Default_Image_Name__c='';

        }

               
                     //update lrng;
                
                    }
               
               
            }
            else  if(ImageSelectionTopic=='DI')
           {
         if(dropTopicDefaultSelected!='selectImage'){
 List<Attachment> lbatt=[select id from Attachment where ParentId =:TopicId ];
            delete lbatt;
lrng.Default_Image_Name__c = dropTopicDefaultSelected;
}
                
                //update lrng; 
            }
        }
        else if(lrng.Type__c==AthenaUtility.LearningTypeVideo)
        {
                lrng.Default_Image_Name__c='';
                //update lrng;
        }



                update lrng;


                //List<string> strLst=new List<string>();
                //if ( hdnLBTag.trim() != '')
                //{
                //                strLst=hdnLBTag.split(',');
                //}
                //AthenaUtility.AssociateTags(strLst,AthenaUtility.Learning, this.BoardId);

}
 catch (DMLException e) 
{

}
 finally
    {
 
      BoardTopicAttach = new Attachment();
TopicName =''; 
 TopicDesc=''; 
 TopicPublish=false; 
 TopicClientFacing=false; 
TopicPracticeApprv=false; 
 TypeOfTopic='';
 ImageSelectionTopic ='';
 TopicCtgryId ='';
 TopicVideoURL='';
 
    }
}


    //Suman End Code - 

// Suman Start Code Today

        public void GetRelatedLB()
        {
            List<Related_Learning_Board__c> NonRelatedLearningBoard1 = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__r.name__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:this.BoardId and Related_Learning_Board_ID__r.Is_Active__c = true order by Display_Sequence_Nbr__c ];
            ChangeOrderRelatedLearningBoard = new List<SelectOption>();
        
            for ( Related_Learning_Board__c c : NonRelatedLearningBoard1 )
            {
                ChangeOrderRelatedLearningBoard.add(new SelectOption(c.Id, c.Related_Learning_Board_ID__r.name__c));
            }
        }

        //Method used to save the changed order of Related Boards
        Public PageReference SaveRelatedChangeOrder()
        {        
            integer dsplySeqNo = 1;
            List<Related_Learning_Board__c> rltdLrngBrdLst = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:this.BoardId];
            List<Related_Learning_Board__c> updtdRltdLrngBrdLst = new  List<Related_Learning_Board__c>();
            system.debug('ChangeOrderRelatedLearningBoard:' +ChangeOrderRelatedLearningBoard);
            for(SelectOption so : ChangeOrderRelatedLearningBoard)
            {
                for(Related_Learning_Board__c rltdLrngBrd: rltdLrngBrdLst)
                {
                    if(rltdLrngBrd.Id == so.getValue())
                    {
                        rltdLrngBrd.Display_Sequence_Nbr__c = dsplySeqNo; 
                        updtdRltdLrngBrdLst.add(rltdLrngBrd);   
                    }
                }
                dsplySeqNo++;
            }
            update updtdRltdLrngBrdLst;
            Return Null;
        }      

        // Method used to check if the user id is moderator or owner
        public void CheckIfModeratorOrOwner()
        {
            AthenaUserAccess usrAccs = new AthenaUserAccess();

            if(usrAccs.IsModerator(UserInfo.getUserId()) || UserOwnerDetails.id == UserInfo.getUserId())
                 IsBoardModeratorOrOwner = true;
            else
                IsBoardModeratorOrOwner = false;
        }
}