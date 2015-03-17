global class SumanEditLearningBoardDtls
{
    public boolean BoardPublic {get; set;}
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
    public string UploadAppPath{get;set;}          
    public string ImageSelectionOption {get;set;}
    public string hdnAddTag {get;set;}
    public  string  hdnChangeOwnerId {get;set;}
    public string PrivateMembersAccess {get;set;}
    public string BoardRatersCount { get; set; }
    public string userRatingComment { get; set; }
    public Decimal AvgRating {get;set;}
    public string RatersCount {get;set;}
    //<!--Suman Friday Code Start -->
    public string EditCategoryNm {get;set;}
    public string EditCategoryId {get;set;}
    public string DeleteCategoryId {get;set;}
    //<!--Suman Friday Code End -->
    public string EditCategoryType { get; set;}

 public string CommApproved {get;set;}
{
   CommApproved=  AthenaUtility.Approved;
}
    public string CommReject {get;set;}
{
    CommReject=AthenaUtility.Rejected;
}

         public string CategoryId  {get;set;}
        public string AvailTags{get;set;}
 public decimal UserBoardRating { get; set; }
    //public string BoardRatersCount { get; set; }

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
    
 public Document document {    
        get {
          if (document == null)
            document = new Document();
          return document;
        }
        set;
   }
          
        //Topic 
//Topic Create
public string EditTagValues {get;set;}
Public string[] ErrMsgs {get;set;}  
Public string ErrMsg {get;set;}
Public string hdnUploadDocErrMsg {get;set;}  
public string  hdnPendingFileUploadTopicId {get;set;}  
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
public boolean IsModerator {get;set;}
public static boolean IsModeratorStatic {get;set;}
 public static Integer TopicResultCount {get;set;} 
 public   Integer ExternalResultCount {get;set;} 


public string GlobalSearchTags {get;set;}
public string CreateImageTopicUrl {get;set;}
public string RTopicName {get;set;}
public string RTopicDescription {get;set;}
public string RTopicTags {get;set;}
 public string RLink {get;set;}
public boolean RTopicPublish {get;set;}
public boolean RTopicClientFacing {get;set;}
public boolean RTopicPracticeApprv {get;set;}
public Attachment RBoardTopicAttach {get;set;} 
public string SearchRTopicDefaultSelected {get;set;}
public string CreateSearchTopicCtgryId {get;set;}


 private static string DATABASE;
        private static string SERVER;
        private static integer PAGE_SIZE;
        private static integer MAX_HITS;
        public integer CurrentItem {get; private set;}
        public static integer MaxItem {get; private set;}
        public integer Hits {get; private set;}
        public string SearchValue {get; set;}
        public static List<SLP_IdolQueryResponse> SearchResults {get; private set;}

        public string CategoryName {get;set;}
        public string CategoryType { get; set; }

 global  class  TopicUserDtls
    {
        public string TopicUserId { get; set; }
        public string TopicUserName { get; set; }
        public string TopicUserPhotoUrl { get; set; }
    }


public void VerifyModerator()
{

  AthenaUserAccess usrAccs = new AthenaUserAccess();
  IsModerator=usrAccs.IsModerator(UserInfo.getUserId());
 system.debug('IsModerator:'+IsModerator);
}

public static void VerifyIsModerator()
{

  AthenaUserAccess usrAccs = new AthenaUserAccess();
  IsModeratorStatic=usrAccs.IsModerator(UserInfo.getUserId());
 system.debug('IsModeratorStatic:'+IsModeratorStatic);
}

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

//Suman Start Code Friday
        public boolean IsBoardModerator { get;set; }
        public static string ImageStaticPath {get;set;}

        public string BoardTemplateName {get;set;}
        
        // Suman Start Code Saturday 03152014
        public string OrderTopicCategoryId { get;set; }
        public string OrderTopicCategoryName { get; set; }        
        public string CategoryChangeOrderTopicId  { get; set; }
        public string RelatedChangedOrderId { get; set; }

        global class ChangeLearningBoardOrder
        {
            public string LearningID { get; set; }
            public string LearningName { get; set; }
            public string LearningCategoryId { get; set; }
        }
        
        global class RelatedLearningBoard
        {
            public string LearningID { get; set; }
            public string LearningName { get; set; }
        }

        // Suman End Code Saturday 03152014     

        global class RelatedLearningBoardCustomClass
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
        options.add(new SelectOption('TopicType','Select type of Topic')); 
        options.add(new SelectOption('Text','Text/Image')); 
options.add(new SelectOption('Video','Video')); 
options.add(new SelectOption('LinkORDoc','Link')); 
options.add(new SelectOption('UploadDoc','Upload Document'));

        return options; 
    }

public static void FetchStaticPathImage()
    {
        ImageStaticPath = 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
    }

   Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
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
        //mail.setUseSignature(true);

        string bodyString = '';
        string stringURL = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
        string[] subjectArguments = new String[] { getSfInstance, BoardId};
        string formatURL = String.format(stringURL, subjectArguments);

        bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
        bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
        bodyString += 'You are the new owner of this Learning Board - <a href='+formatURL+'>'+BoardName+'</a></span>';
        bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
        bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';


        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }


public SumanEditLearningBoardDtls(ApexPages.StandardController controller) {
        ErrMsgs = new string[]{'No file was selected.', 'File has no extension.'};
        BoardId = ApexPages.currentPage().getParameters().get('id');
        BoardAttach = new Attachment();
        BoardTopicAttach=new Attachment();
        TopicAttach=new Attachment();
RBoardTopicAttach=new Attachment();
        RelatedLearningBoards = new list<RelatedLearningBoardCustomClass>();
        VerifyModerator();
VerifyIsModerator();
GetAverageRating();

        // Suman Added code
        UserOwnerDetails = getLearningBoardOwnerDtls();
        UserDetails = GetLoggedinUserDtls();
        CheckIfModeratorOrOwner();
        
        // Suman Start Code Friday        
        AthenaUserAccess usrAccs = new AthenaUserAccess();
        if(usrAccs.IsModerator(UserInfo.getUserId()))
            IsBoardModerator = true;
        else
            IsBoardModerator = false;

        FetchStaticPathImage();
        // Suman End Code Friday

        // Suman Start Code Saturday
        //GetRelatedLB();
        // Suman End Code Saturday

        LearningBoardDtls();

        AvailTags=AthenaUtility.getAvailableTags();  
        UploadAppPath=AthenaUtility.ApplicationSettingValue(AthenaUtility.UploadAppURL);
system.debug('UploadAppPath:'+UploadAppPath);
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

 
    // Suman Start Code Friday
    
    @RemoteAction
    global static List<RelatedLearningBoardCustomClass> LearningSearch(string strSearch, string LearningBrdId)
    {
        List<RelatedLearningBoardCustomClass> relLBs = SearchLearning(strSearch, LearningBrdId);

        return relLBs;
    }

    global static List<RelatedLearningBoardCustomClass> SearchLearning(string SearchStr, string LearningBrdId)
    {

        List<RelatedLearningBoardCustomClass> lstRelatedLearningBoard = new List<RelatedLearningBoardCustomClass>();
        RelatedLearningBoardCustomClass relatedLearningBoard;

        String  SearchStrWithLike= '%'+ SearchStr+ '%';
        SET<ID> lrngIds = new SET<ID>();
        SET<ID> LrngIdsSet = new SET<ID>();
           
        List<Learning__c> lrngSrchRslt= new List<Learning__c>([SELECT Id, Name__c, Name, Default_Image_Name__c, Owner.name FROM Learning__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);//stroing list of learing boards where name like cloud

        LIST<Learning__c> lstLrng = new LIST<Learning__c>([select id from Learning__c]);
        for (Learning__c l :lstLrng)
        {
            lrngIds.add(l.id);
        }
        List<Tag_Item__c> tagItmLst=[
        SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c = : SearchStr) and Item_Name__c=:AthenaUtility.Learning and Item_Identifier__c IN :lrngIds];

        for(Tag_Item__c TagItm : tagItmLst)
        {
            LrngIdsSet.add(TagItm.Item_Identifier__c);
        }

        for(Learning__c Lrng : lrngSrchRslt)
        {
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

            List<Learning__c> lstLearnings = [SELECT Id, Name__c, Default_Image_Name__c, Owner.name FROM Learning__c Where id IN:finalLrngIds and Is_Active__c=true order by LastModifiedDate Desc];

           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :finalLrngIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      
            
            FetchStaticPathImage();

        for (Learning__c learningItem : lstLearnings)
        {
            relatedLearningBoard = new RelatedLearningBoardCustomClass();
            
            relatedLearningBoard.LBid = learningItem.Id;
            relatedLearningBoard.LBName = learningItem.Name__c;
            relatedLearningBoard.LBOwnerName = learningItem.Owner.name;

            if (learningItem.Default_Image_Name__c != null)
            {
                relatedLearningBoard.DefaultImageName = ImageStaticPath + learningItem.Default_Image_Name__c;
                relatedLearningBoard.StaticImage = true; 
            }
            else
            {
                if(AttMap.containskey(learningItem.id))
                {
                    relatedLearningBoard.AttachmentId = AttMap.get(learningItem.id);

                    relatedLearningBoard.DefaultImageName = 'https://' +URL.getSalesforceBaseUrl().getHost() +'/servlet/servlet.FileDownload?file='+ relatedLearningBoard.AttachmentId;
                    relatedLearningBoard.StaticImage = false;
                }
            }

            lstRelatedLearningBoard.add(relatedLearningBoard);
        }
        TopicResultCount = lstRelatedLearningBoard.size();
        return lstRelatedLearningBoard;
    }

    // Suman End Code Friday
@RemoteAction
 global static void RemoveTopic(string TopicId, string TopicName,string BoardId){
        Learning_Board_Learning__c LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =:TopicId AND Learning_Board_ID__c =:BoardId Limit 1];
        delete LBL;
 
    } 

public void DeleteTopic()
{
  system.debug('DTopicId:'+DTopicId);
   List<Learning_Board_Learning__c> LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =:DTopicId AND Learning_Board_ID__c =:BoardId];
   if(LBL.size()>0)
   {
        delete LBL;
   }
}

    Public List<SelectOption> getTopicCategory()
    {
            
        List<SelectOption> LstCategories= new List<SelectOption>();
        LstCategories.add(new SelectOption('','--Select Category--'));
        
        Learning_Board__c  lngBoard= [SELECT Id, Name__c, Is_Active__c, Featured__c, Learning_Board_Template_ID__c FROM Learning_Board__c where id =: BoardId];
        system.debug('Learninglb:'+lngBoard.Learning_Board_Template_ID__c);
        string strLBTemplate=lngBoard.Learning_Board_Template_ID__c;
    
        List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Name__c, Display_Sequence_Nbr__c FROM User_Learning_Category__c where Learning_Board_ID__c =: BoardId ];

        if(strLBTemplate==null)
        {
            List<Learning_category__c> lrngCatlst= [select Name__c,id from Learning_category__c where Is_Active__c=True order by Display_Sequence_Nbr__C];               
                            
            for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
            {
                LstCategories.add(new SelectOption(userLrngCtgry.Id, userLrngCtgry.name__c));    
            }
       
            for(Learning_category__c lc:lrngCatlst)
            {
                LstCategories.add(new SelectOption(lc.id,lc.name__c));    
            }
        }
        else
        {
                                
            List<Required_Learning_Category__c> rlcatlst=[SELECT Learning_Category_Id__c,Learning_Category_Id__r.Name__c, Is_Active__c, Learning_Board_Template_ID__c, Display_Sequence_Nbr__c FROM Required_Learning_Category__c where Learning_Category_Id__r.Is_Active__c=true and Is_Active__c=true and Learning_Board_Template_ID__c=:strLBTemplate order by Display_Sequence_Nbr__c];
            
            for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
            {
                LstCategories.add(new SelectOption(userLrngCtgry.Id, userLrngCtgry.name__c));    
            }                       
            
            for(Required_Learning_Category__c rlc:rlcatlst)
            {
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
    string fileExcelUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileExcelUpload.png';
string fileTextUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileTextUpload.png';

    string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
    string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';




        list<id> lstLearningIds= new list<id>();
      List<LrngDtlsWithCategory> lstContainer=new List<LrngDtlsWithCategory>();

      List<Learning_Board_Learning__c> lstBoardLearning=[select Learning_ID__c,Learning_ID__r.Name__c, User_Learning_Category_ID__c,
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
                              Map<String,String> AssTopicTagMap = new Map<String,string>();
                
                                List<string> lstags=new List<string>();
                                for (Tag_Item__c ti : tagItmlst){            
            if(!TagMap.containskey(ti.Item_Identifier__c)){
                                                                lstags=new List<string>();
                                                                lstags.add(ti.Tag_ID__r.Value__c);
                TagMap.put(ti.Item_Identifier__c,lstags);
                AssTopicTagMap.Put(ti.Item_Identifier__c,ti.Tag_ID__r.Value__c);
            }
            else{
                lstags = TagMap.get(ti.Item_Identifier__c);
                lstags.add(ti.Tag_ID__r.Value__c);
                TagMap.put(ti.Item_Identifier__c,lstags);    
                string assTags=AssTopicTagMap.get(ti.Item_Identifier__c) + ti.Tag_ID__r.Value__c;
                AssTopicTagMap.Put(ti.Item_Identifier__c,assTags);              
            }
        }
// Edit Topic Business Logic

List<Learning_Board__Share> lstlbshare=[SELECT UserOrGroupId FROM Learning_Board__Share where parentId=:LrngBoardId];
    Map<string,boolean> mapBrdOwner=new Map<string,boolean>();
for(Learning_Board__Share lbshare:lstlbshare)
{
                mapBrdOwner.put(lbshare.UserOrGroupId,true);
}

List<Learning__Share> lstlrngShare=[SELECT UserOrGroupId,parentId FROM Learning__Share where parentId IN (Select learning_Id__c from learning_Board_learning__c where learning_Board_Id__c=:LrngBoardId) and AccessLevel='All'];
Map<string,boolean> mapLrngEdit=new Map<string,boolean>();


for(Learning__Share lrngShare:lstlrngShare)
{
   
    
        if(mapBrdOwner.containskey(lrngShare.UserOrGroupId))
        {
                        mapLrngEdit.put(lrngShare.parentId,true);
        }
        else
        {
                        mapLrngEdit.put(lrngShare.parentId,false);
        }
  
}

List<User> lstTopicUsers=[Select id,Name,SmallPhotourl from user where id in (Select ownerid from learning__c where id in : lstLearningIds)];
Map<id,TopicUserDtls> MapUserDetails =new Map<id,TopicUserDtls>();

for( User userDtls :lstTopicUsers)
{
  if(!MapUserDetails.containskey(userDtls.id))
        {
        
        TopicUserDtls topicUserDetails=new TopicUserDtls();
        topicUserDetails.TopicUserId=userDtls.id;
        topicUserDetails.TopicUserName=userDtls.Name;
        topicUserDetails.TopicUserPhotoUrl=userDtls.SmallPhotourl;        
        MapUserDetails.put(userDtls.id,topicUserDetails);
        }
}

//
//Before Loop
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id,Nbr_of_Users_Rated__c  FROM Rated_Item__c where Item_Identifier__c in :lstLearningIds];
        map<id,string> RatedItemMap = new map<id,string>();        

        for (Rated_Item__c rtdItm :RatedItemLst) {
                        string AvgRatingAndCnt;
                        AvgRatingAndCnt=rtdItm.Rating_Average__c + ',' + rtdItm.Nbr_of_Users_Rated__c;
                        RatedItemMap.put(rtdItm.Item_identifier__C,AvgRatingAndCnt);  
        }

        
        for(LrngDtlsWithCategory LCL:LrngDetails)
        {
                LrngDtlsWithCategory lngCat=new LrngDtlsWithCategory();
                lngCat.CategoryId=LCL.CategoryId;
                lngCat.CategoryName=LCL.CategoryName;
                lngCat.CategoryType = LCL.CategoryType;
                lngCat.lstlrngs=new List<LearningDtlsCustomClass>();
            

                for(Learning_Board_Learning__c learningB:lstBoardLearning)
                {
                    if(learningB.Learning_Category_Id__c == LCL.CategoryId || learningB.User_Learning_Category_ID__c == LCL.CategoryId)
                    {
                        LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                        lrng.LName=learningB.Learning_ID__r.Name__c;
                        lrng.LDescription = learningB.Learning_ID__r.Description__c;
                        
                        if(lrng.LDescription.length()>150){
                            lrng.StrDescLength=1;
                            lrng.LShortDescription = lrng.LDescription.substring(0,150) + '...';
                        }
                        else{
lrng.StrDescLength=0;
                            lrng.LShortDescription=lrng.LDescription;
                        }

                        
                        lrng.LType= learningB.Learning_ID__r.type__c;   
                        lrng.LURL= learningB.Learning_ID__r.URL__C; 
                       lrng.PracticeApprv=learningB.Learning_ID__r.Practice_Approved__c;
                        lrng.IsActive=learningB.Learning_ID__r.Is_Active__c;
                        lrng.fileURLUpload=FileURLUpload;
                        lrng.hpsharedIcon=hpsharedIcon;
                        lrng.filePDFUpload=filePDFUpload;
                        lrng.filePPTUpload=filePPTUpload;
                        lrng.fileWordUpload=fileWordUpload;
                        lrng.fileExcelUpload = fileExcelUpload;
                        lrng.HPCertification=HPCertification;
                        lrng.HPPublish=HPPublishIcon;

if(MapUserDetails.containskey(learningB.Learning_ID__r.Owner.Id))
        {
            TopicUserDtls topicUserDetails=new TopicUserDtls();
            topicUserDetails=MapUserDetails.get(learningB.Learning_ID__r.Owner.Id);
            lrng.TopicOwnerId=topicUserDetails.TopicUserId;
            lrng.LOwnerName=topicUserDetails.TopicUserName;
            lrng.OwnerPhoto=topicUserDetails.TopicUserPhotoUrl;
        }
lrng.fileTextUpload=fileTextUpload;


 if(mapLrngEdit.get(learningB.Learning_ID__r.id))
{
lrng.BtnshowHideEdit=true;
}
else
{
lrng.BtnshowHideEdit=false;
}

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

                    if(AssTopicTagMap.containskey(learningB.Learning_ID__r.id))
                    {                        
                     lrng.AssociatedTopicTags=  AssTopicTagMap.get(learningB.Learning_ID__r.id);   
                      
                    }                        
                        
                        if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                              lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                              lrng.LURL=lrng.LURL.replace('http:', 'https:');
                        }
                        else if(lrng.LType=='Video' && lrng.LURL.contains('www.brainshark.com')){
                              lrng.LURL=lrng.LURL+'&dm=5&pause=1&nrs=1';
                              
                        }
                        
 If(RatedItemMap.containskey(learningB.Learning_ID__r.id))
                {
                                string ratingAvgCount=RatedItemMap.get(learningB.Learning_ID__r.id);
                                list<string> lstrtngAvg =  ratingAvgCount.split(',');
                                String myNumber = lstrtngAvg[0];
                                String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+2);
                                Decimal AvgRtng = Decimal.valueOf(myTruncatedNumber);
                                lrng.AvgRating=AvgRtng;
                                lrng.RatersCount=lstrtngAvg[1];                               
                }
                else
                {
                                lrng.AvgRating=0;
                                lrng.RatersCount= '0';
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
                            else if(lrng.LURL.contains('.xls'))
                            {
                              lrng.DocType='XLS';
                            }
                            else if(lrng.LURL.contains('.txt'))
                            {
                              lrng.DocType='TXT';
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

 Public List<SelectOption> DefaultTopicImage{
     get{
            List<string> lstImgFileName=new List<string>();
            string imageFileNames = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningDefaultImages);
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

Public List<SelectOption> DefaultBoardImage{
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
        public string TopicOwnerId {get;set;}
        public string OwnerPhoto {get;set;}
        public boolean BtnshowHideEdit {get;set;}
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public String LShortDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public Decimal AvgRating {get;set;}
        public string RatersCount {get;set;}
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
        public string fileExcelUpload { get; set;}
        public string fileTextUpload {get;set;}
        public boolean PracticeApprv {get;set;}
        public string HPCertification {get;set;}
        public string HPPublish {get;set;}
        public string AssociatedTopicTags{get;set;}   
       public integer StrDescLength {get;set;}
    }

  global  Class LrngDtlsWithCategory{
       public string CategoryId{get;set;}  
       public string CategoryName{get;set;}  
       public string CategoryType { get; set; } 
       public List<LearningDtlsCustomClass> lstlrngs{get;set;}  
    }

    Public void LearningBoardDtls()
    {
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :BoardId];
        
        Learning_Board__c  LearningBoards= [select id,Name__c,Sub_Title__c ,Learning_Board_Template_ID__c,Public__c ,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,
        CreatedDate from Learning_Board__c where ID =:BoardId ];

        BoardName=LearningBoards.Name__c;
        BoardDescription=LearningBoards.description__c;
        BoardSubTitle=LearningBoards.Sub_Title__c;
        BoardTemplateId=LearningBoards.Learning_Board_Template_ID__c;
        BoardPublish=LearningBoards.Is_Active__c ;
        BoardFeatured=LearningBoards.Featured__c;
        BoardPublic=LearningBoards.Public__c;
        
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
if (BoardTemplateId  != null)
                    {
            Learning_Board_Template__c brdtm = [SELECT Id, Name__c, Description__c, Is_Active__c FROM Learning_Board_Template__c where id=: BoardTemplateId Limit 1];
                                     BoardTemplateName = brdtm.Name__c;
                    }
        else
        {
            BoardTemplateName = 'Not Selected';
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
            List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Name__c, Display_Sequence_Nbr__c FROM User_Learning_Category__c where Learning_Board_ID__c =: BoardId ];
                
            for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
            {
                LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();

                dtlsWithCats.CategoryId = userLrngCtgry.Id;
                dtlsWithCats.CategoryName = userLrngCtgry.Name__c;
                dtlsWithCats.CategoryType = 'Custom';
                lsWithCat.add(dtlsWithCats);
            }

            for(Learning_category__c lcc :lrngCatlst)
            {
                LrngDtlsWithCategory dtlsWithCat=new LrngDtlsWithCategory();
                dtlsWithCat.CategoryId=lcc.id;
                dtlsWithCat.CategoryName=lcc.Name__c;
                dtlsWithCat.CategoryType = 'Default';
                lsWithCat.add(dtlsWithCat);
            }
        }
        else
        {
            List<Required_Learning_Category__c> lstRequiredLCat =[SELECT Learning_Category_Id__c, Id, Name, Is_Active__c, Learning_Board_Template_ID__c,Learning_Category_Id__r.Name__C FROM Required_Learning_Category__c where Learning_Board_Template_ID__c =:strLBTemplate];
            List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Name__c, Display_Sequence_Nbr__c FROM User_Learning_Category__c where Learning_Board_ID__c =: BoardId ];

            for(User_Learning_Category__c userLrngCtgry : lstUserLearningCategory)
            {
                LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();

                dtlsWithCats.CategoryId = userLrngCtgry.Id;
                dtlsWithCats.CategoryName = userLrngCtgry.Name__c;
                dtlsWithCats.CategoryType = 'Custom';
                lsWithCat.add(dtlsWithCats);
            }

            for(Required_Learning_Category__c RqrdL :lstRequiredLCat)
            {
                LrngDtlsWithCategory dtlsWithCats=new LrngDtlsWithCategory();
                dtlsWithCats.CategoryId=RqrdL.Learning_Category_Id__c;
                dtlsWithCats.CategoryName=RqrdL.Learning_Category_Id__r.Name__C;
                dtlsWithCats.CategoryType = 'Default';
                lsWithCat.add(dtlsWithCats);
            }
        }
        
        //If Learning Board have Template
        List<LrngDtlsWithCategory> lstLearningBrdCat=GenerateLearningCtgry(lsWithCat,BoardId);
        system.debug('lstLearningBrdCat:'+lstLearningBrdCat.size());
        return lstLearningBrdCat;
    }

@RemoteAction
global static integer VerifyDuplicateTopicName(string TopicName)
{
string TName=TopicName.trim();
 Integer TCount=0;
 List<Learning__c> Lstlrng=[SELECT Id, Name__c FROM Learning__c where name__C=:TName];

 TCount=Lstlrng.size();
return TCount;
}


public void CreateSearchURL()
{
   try
    {
             
system.debug('@@@@Entered Create Search URL');
system.debug('RTopicName:'+RTopicName);
system.debug('RTopicDescription:'+RTopicDescription);
system.debug('RTopicPublish:'+RTopicPublish);
system.debug('RTopicClientFacing:'+RTopicClientFacing);
system.debug('RTopicPracticeApprv:'+RTopicPracticeApprv);
system.debug('RLink:'+RLink);
system.debug('CreateImageTopicUrl:'+CreateImageTopicUrl);
system.debug('SearchRTopicDefaultSelected:'+SearchRTopicDefaultSelected);
system.debug('CreateSearchTopicCtgryId:'+CreateSearchTopicCtgryId);
system.debug('GlobalSearchTags:'+GlobalSearchTags);
system.debug('SearchRTopicDefaultSelected:'+SearchRTopicDefaultSelected);


                                Learning__c learning= new Learning__c();
                                learning.Name__c = RTopicName;
                                learning.Description__c = RTopicDescription ;
                                learning.Is_Active__c = RTopicPublish ;
                                learning.Default_Image_Name__c = '';
                                learning.ClientFacing__c = RTopicClientFacing ;
                                learning.Practice_Approved__c = RTopicPracticeApprv ;
      
                                                learning.URL__c = RLink; //CreateTopicVideoURL;
                                                learning.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
           
             if(CreateImageTopicUrl=='UFC')
             {
                learning.Default_Image_Name__c='';
                insert learning;
                system.debug('learningid::'+learning.id);
                RBoardTopicAttach.ParentId = learning.id;
                insert RBoardTopicAttach ;
               
            }
            else  if(CreateImageTopicUrl=='DI')
           {
                learning.Default_Image_Name__c = SearchRTopicDefaultSelected;//CreateTopicDefaultSelected;
                insert learning; 
            }
           

        
       

                                if (GlobalSearchTags!=null && GlobalSearchTags != '')
                                                {
                                                                  List<string> strLstTags=new List<string>();
                                                                  strLstTags=GlobalSearchTags.split(',');
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
                                lrngBrdLrng.Learning_Category_Id__c= CreateSearchTopicCtgryId;// CreateTopicCtgryId;//TopicCtgryId; //Category Id
                                lrngBrdLrng.Display_Sequence_Nbr__c =iMax;         
                                insert lrngBrdLrng;

                        //Add Permission to existing Contributors - Start
                            string lrngId=learning.id;
                            List<Learning_Board__Share> lstBoardShare=[SELECT UserOrGroupId FROM Learning_Board__Share where ParentId=:BoardId];
                            List<string> lstContr=New List<string>();

                            for(Learning_Board__Share BoardShare:lstBoardShare)
                            {
                                lstContr.add(BoardShare.UserOrGroupId);
                            }

                            List<Learning__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Learning__Share where UserOrGroupId In :lstContr and ParentId =:lrngId];
                            Map<string,string> MapLrng= New Map<string,string>();

                            for(Learning__Share lrngShare:lstLrngShare)
                            {
                                MapLrng.put(lrngShare.UserOrGroupId,lrngShare.ParentId);            
                            }

                            lstLrngShare=new List<Learning__Share>();

                            for(string cont:lstContr)
                            {
                                if(!MapLrng.containsKey(cont))
                                {
                                    Learning__Share lrngShare=new Learning__Share();
                                    lrngShare.ParentId=lrngId;
                                    lrngShare.AccessLevel='Edit';
                                    lrngShare.UserOrGroupId=cont;               
                                    lstLrngShare.add(lrngShare);
                                }
                            }
                            insert lstLrngShare;
                        //Add Permission to existing Contributors - End 

                                
    }

    catch (DMLException e) {
            system.debug('DMLException ' + e.getMessage());
        } 
    finally {
         //Lrngattach= null; // clears the viewstate
         RBoardTopicAttach=new Attachment();       

         }
               
    }




public Void CreateLearningAndAssociate()
{
//PageReference pRef = new PageReference('http://localhost:48681/Default.aspx');
   try
    {
hdnUploadDocErrMsg = '';   
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
   else if(CreateTypeOfTopic=='UploadDoc')
                                {//upload
                                                learning.Type__c='Upload Document';
                
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
            if(CreateTypeOfTopic=='UploadDoc')   {             
                hdnPendingFileUploadTopicId = learning.id;
            }

        }
        else if(learning.Type__c==AthenaUtility.LearningTypeVideo)
        {
                learning.Default_Image_Name__c='';
                insert learning;
        }

                                if (TopicTags!=null && TopicTags != '')
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

                                //system.debug('Suman CreateTopicCtgryId:'+ CreateTopicCtgryId);

                                if(CategoryType == 'Default')
                                {
                                    lrngBrdLrng.Learning_Category_Id__c = CreateTopicCtgryId;//TopicCtgryId; //Category Id
                                }
                                else if(CategoryType == 'Custom')
                                {
                                    lrngBrdLrng.User_Learning_Category_ID__c = CreateTopicCtgryId; 
                                }

                                lrngBrdLrng.Display_Sequence_Nbr__c =iMax;         
                                insert lrngBrdLrng;

                        //Add Permission to existing Contributors - Start
                            string lrngId=learning.id;
                            List<Learning_Board__Share> lstBoardShare=[SELECT UserOrGroupId FROM Learning_Board__Share where ParentId=:BoardId];
                            List<string> lstContr=New List<string>();

                            for(Learning_Board__Share BoardShare:lstBoardShare)
                            {
                                lstContr.add(BoardShare.UserOrGroupId);
                            }

                            List<Learning__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Learning__Share where UserOrGroupId In :lstContr and ParentId =:lrngId];
                            Map<string,string> MapLrng= New Map<string,string>();

                            for(Learning__Share lrngShare:lstLrngShare)
                            {
                                MapLrng.put(lrngShare.UserOrGroupId,lrngShare.ParentId);            
                            }

                            lstLrngShare=new List<Learning__Share>();

                            for(string cont:lstContr)
                            {
                                if(!MapLrng.containsKey(cont))
                                {
                                    Learning__Share lrngShare=new Learning__Share();
                                    lrngShare.ParentId=lrngId;
                                    lrngShare.AccessLevel='Edit';
                                    lrngShare.UserOrGroupId=cont;               
                                    lstLrngShare.add(lrngShare);
                                }
                            }
                            insert lstLrngShare;
                        //Add Permission to existing Contributors - End 

                                
 
            //pRef.getParameters().put('tid', learning.id);
            //pRef.setRedirect(true);
//system.debug(pRef);
           
    }

    catch (DMLException e) {
            system.debug('DMLException ' + e.getMessage());
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
TopicTags='';
         }
            //return pRef;    
    }



public PageReference CreateTopicUploadDoc()
{
PageReference pRef = new PageReference(UploadAppPath);
   try
    {
hdnUploadDocErrMsg = '';   
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
   else if(CreateTypeOfTopic=='UploadDoc')
                                {//upload
                                                learning.Type__c='Upload Document';
                
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
            if(CreateTypeOfTopic=='UploadDoc')   {             
                hdnPendingFileUploadTopicId = learning.id;
            }

        }
        else if(learning.Type__c==AthenaUtility.LearningTypeVideo)
        {
                learning.Default_Image_Name__c='';
                insert learning;
        }

                                if (TopicTags!=null && TopicTags != '')
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

                        //Add Permission to existing Contributors - Start
                            string lrngId=learning.id;
                            List<Learning_Board__Share> lstBoardShare=[SELECT UserOrGroupId FROM Learning_Board__Share where ParentId=:BoardId];
                            List<string> lstContr=New List<string>();

                            for(Learning_Board__Share BoardShare:lstBoardShare)
                            {
                                lstContr.add(BoardShare.UserOrGroupId);
                            }

                            List<Learning__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Learning__Share where UserOrGroupId In :lstContr and ParentId =:lrngId];
                            Map<string,string> MapLrng= New Map<string,string>();

                            for(Learning__Share lrngShare:lstLrngShare)
                            {
                                MapLrng.put(lrngShare.UserOrGroupId,lrngShare.ParentId);            
                            }

                            lstLrngShare=new List<Learning__Share>();

                            for(string cont:lstContr)
                            {
                                if(!MapLrng.containsKey(cont))
                                {
                                    Learning__Share lrngShare=new Learning__Share();
                                    lrngShare.ParentId=lrngId;
                                    lrngShare.AccessLevel='Edit';
                                    lrngShare.UserOrGroupId=cont;               
                                    lstLrngShare.add(lrngShare);
                                }
                            }
                            insert lstLrngShare;
                        //Add Permission to existing Contributors - End 

                                User user = GetLoggedinUserDtls(); 
 
            pRef.getParameters().put('tid', learning.id);
            pRef.getParameters().put('BoardId', BoardId);
            pRef.getParameters().put('UserName', user.Name);
            pRef.setRedirect(true);
system.debug('pRef:'+pRef);
           
    }

    catch (DMLException e) {
            system.debug('DMLException ' + e.getMessage());
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
TopicTags='';
         }
            return pRef;    
    }


public void DeleteBoar(){
           system.debug('BoardId:'+BoardId);
 system.debug('LBAssociatedTags:'+hdnAddTag);
 
}


        public void UpdateBoard()
        {
            system.debug('UserTags:'+ UserTags);
            hdnUploadDocErrMsg = '';
            system.debug('BoardId:'+BoardId);
            system.debug('LBAssociatedTags:'+hdnAddTag);
            Learning_Board__c LearningBoards=[SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c,Public__c,  Default_Image_Name__c,Learning_Board_Template_ID__c FROM Learning_Board__c where id=:BoardId limit 1];

            LearningBoards.Name__c=BoardName;
            LearningBoards.description__c=BoardDescription;
            LearningBoards.Sub_Title__c=BoardSubTitle;
           // LearningBoards.Learning_Board_Template_ID__c=BoardTemplateId;
            LearningBoards.Is_Active__c =BoardPublish;
            LearningBoards.Featured__c=BoardFeatured;
            LearningBoards.Public__c= BoardPublic;

            update LearningBoards;
        
            List<string> strLst = new List<string>();
                    
            if(UserTags.trim() != '')
            {
                strLst = UserTags.split(',');
            }
            
                AthenaUtility.AssociateTags(strLst, AthenaUtility.LearningBoard, BoardId);

if(BoardPublic)
        {
            List<Learning_Board_Member__c> lstApprvRjct = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Learning_Board_ID__c=: BoardId  AND Status__c !=: AthenaUtility.Approved];

            List<Learning_Board_Member__c> lstUpdate = new List<Learning_Board_Member__c>();
List<EntitySubscription> lstEntitySubc=new  List<EntitySubscription>();
//[select SubscriberID from EntitySubscription where ParentId =:BoardId];

            for(Learning_Board_Member__c memberItem : lstApprvRjct)
            {
        EntitySubscription entitySub=new EntitySubscription();
        entitySub.ParentId=BoardId; 
        entitySub.SubscriberID=memberItem.User_Id__c;
                memberItem.Status__c = AthenaUtility.Approved;
                lstUpdate.add(memberItem);
        lstEntitySubc.add(entitySub);
            }
            update lstUpdate;
insert lstEntitySubc;
            GetFollowers();
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
        system.debug('hdnNewContributorId'+ hdnNewContributorId);
        system.debug('UserOwnerDetails.id'+ UserOwnerDetails.id);

        //If owner id and contributor id are no the same, get contributors
        if (UserOwnerDetails.id != hdnNewContributorId)
        {
            
            User usr=[Select Name,email from User where id =:hdnNewContributorId];
        
            Messaging.SingleEmailMessage mail;  
            string bodyString = '';
            string[] toAddresses;
            string stringURL = '';
            string formatURL = '';

            if(IsBoardCreator(hdnNewContributorId))
            {
                Learning_Board__Share lbContr= new Learning_Board__Share();
                lbContr.ParentId = BoardId;
                lbContr.AccessLevel = 'Edit';
                //lbContr.UserOrGroupId = contrId;       
            
                lbContr.UserOrGroupId = hdnNewContributorId;
                insert lbContr;
            
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
                        lrngShare.UserOrGroupId= hdnNewContributorId;         
                        lstLrngShare.add(lrngShare);
                    }
                }
                insert lstLrngShare;
                
                //Adding Permission - End
            
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new String[] {usr.Email};
                mail.setToAddresses(toAddresses);       
                mail.setSubject('You have been added as Contributor for the Learning Board - ' + BoardName); 
                stringURL = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, BoardId};
                formatURL = String.format(stringURL, subjectArguments);
                bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'You have been added as Contributor for the Learning Board - <a href='+formatURL+'>'+BoardName+'</a></span>';
                bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
                bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';

                mail.setHtmlBody(bodyString);

                //Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
            else
            {           
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new String[] {usr.Email};                                    
                mail.setToAddresses(toAddresses);       
                mail.setSubject('You have been added as a contributor, You will get Access soon for the Learning Board ' + BoardName); 
                string pdl='esds-athena-team@hp.com';
                mail.setCCAddresses( new String[]{UserOwnerDetails.email,pdl});
                stringURL = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, BoardId};
                formatURL = String.format(stringURL, subjectArguments);

                bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 1200px;">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'You have been added as a contributor for the Board - <a href='+formatURL+'>'+BoardName+'</a><br/><br/>';
                bodyString += 'Hi Team ' + ',<br/><br/>';
                bodyString += 'Please provide access to ' + usr.Name + ' for the Board -' + BoardName +' and update the user.<br/><br/>';
                bodyString += 'Hi ' + UserOwnerDetails.Name +',<br/><br/>';
                bodyString += 'Until team provide access you will not be able to see ' + usr.Name + ' as contributor for your Board ' + BoardName + '</span>';
                bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
                bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';

                mail.setHtmlBody(bodyString);
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
        //mail.setUseSignature(true);

        string bodyString = '';
        bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You have been removed as Contributor for the Learning Board - '+BoardName+'</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+UserDetails.Name+'</span></h3></td></tr></tbody></table>';

        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }

@RemoteAction
    global static List<RelatedLearningBoardCustomClass> AddRelatedLB(string strSearch, string strLBID)
    {
        List<RelatedLearningBoardCustomClass> relLBs = SearchRelatedLearningBoard(strSearch,strLBID);

        return relLBs;
    }

    //Related Learning Board - Start 
 
    global static List<RelatedLearningBoardCustomClass> SearchRelatedLearningBoard(string SearchStr, string strLBID)
    {
        
        List<RelatedLearningBoardCustomClass> lstRelatedLearningBoard = new List<RelatedLearningBoardCustomClass>();
        RelatedLearningBoardCustomClass relatedLearningBoard;

        String  SearchStrWithLike= '%'+ SearchStr + '%';
         
        SET<ID> lbBrdIds = new SET<ID>();
        SET<ID> lbBrdIdSet = new SET<ID>();
        List<Learning_Board__c> lbBrdSrchRslt = new List<Learning_Board__c>([SELECT Id, Name__c, Name, Default_Image_Name__c, Owner.name FROM Learning_Board__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);
        
        
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
        List<Learning_Board__c> lbList = new List<Learning_Board__c>([SELECT Id, Name__c, Default_Image_Name__c, Owner.name FROM Learning_Board__c where id IN:finalLrngBrdIds and Is_Active__c=true order by LastModifiedDate Desc]);
        

           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :finalLrngBrdIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      

        FetchStaticPathImage();

        for (Learning_Board__c relatedBoardItem : lbList)
        {
            relatedLearningBoard = new RelatedLearningBoardCustomClass();
            
            relatedLearningBoard.LBid = relatedBoardItem.Id;
            relatedLearningBoard.LBName = relatedBoardItem.Name__c;
            relatedLearningBoard.LBOwnerName = relatedBoardItem.Owner.name;

            if (relatedBoardItem.Default_Image_Name__c != null)
            {
                
                relatedLearningBoard.DefaultImageName = ImageStaticPath + relatedBoardItem.Default_Image_Name__c;
                relatedLearningBoard.StaticImage = true; 
            }
            else
            {
                if(AttMap.containskey(relatedBoardItem.id))
                {
                    relatedLearningBoard.AttachmentId = AttMap.get(relatedBoardItem.id);

                    relatedLearningBoard.DefaultImageName = 'https://' +URL.getSalesforceBaseUrl().getHost() +'/servlet/servlet.FileDownload?file='+ relatedLearningBoard.AttachmentId;
                    relatedLearningBoard.StaticImage = false;
                }
            }

            lstRelatedLearningBoard.add(relatedLearningBoard);
        }

        return lstRelatedLearningBoard;
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

 public void CancelUploadClick(){
    hdnUploadDocErrMsg = '';
    hdnPendingFileUploadTopicId = '';
}

public void ProcessFileUpload()
 {
   try
    {        
         hdnUploadDocErrMsg = '';
        //
        // call web service to upload doc to Sharepoint
        // 
        String strBody = EncodingUtil.base64Encode( document.body );
     

        document.body = null;       // set to null to ensure that the blob is not included automatically in the viewstate.
        
        if (document.name == null || document.name.trim() == '')
        {
            ErrMsg = ErrMsgs[0];
            throw new SLP_Exception();
        }
        integer lastPos = document.name.lastIndexOf('.');
        if (lastPos == -1)
        {
            ErrMsg = ErrMsgs[1];
            throw new SLP_Exception();
        }
        document.name = document.name.substring(0,lastPos) + '_' + hdnPendingFileUploadTopicId + document.name.substring(lastPos);
        // 
        // if (((n * 1.37) + 184 + j) > 2.5 MB) { say ”too big”; } // gateway
        // if (((n * 1.37) + 184 + j) > (3 MB – h) { say ”too big”; } // salesforce
        // Where n is the size of file in bytes and j is the json string without the data value (j is small enough to make into a constant)
        // h would be whatever constant we estimate a header would be.
        // 
        // Test Gateway limit as it is smaller - the string is already base64 so no conversion needed
        // 
        Double result = strBody.length() + document.name.length();
        system.debug('length result ' + result);
        if (result > 2500000)
        {
            ErrMsg = 'File is too large to upload. It is > 2.5MB';
            throw new SLP_Exception();
        }
        // 
        // call the web service 
        // calling this synchronously as we need the response data to continue
        // 
        SLP_FileUploadClasses.FileRequest fsreq  = new SLP_FileUploadClasses.FileRequest();  
            SLP_FileUploadClasses.FileResponse fsresp  = new SLP_FileUploadClasses.FileResponse(); 
        fsreq.Name = document.name;
        fsreq.Base64Data = strBody;
     
            fsresp = SLP_JSONParserUtil.parseJSONResponse(fsreq); 
        if (fsresp.Success == null || !fsresp.Success) {
            ErrMsg = fsresp.Error;
            throw new SLP_Exception();
        }

        // set the returned values below
        Learning__c learning = [SELECT Id, Name FROM Learning__c where Id =:hdnPendingFileUploadTopicId];
            learning.URL__c = fsresp.InternalUrl.replace(' ', '%20');
            learning.Type__c='Upload Document';  // UPLOADDOC - update AthenaUtility
            learning.Doc_Id__c = fsresp.DocId;
        update learning;
        hdnPendingFileUploadTopicId = '';    
    }
    catch (SLP_Exception e)     
            {
                hdnPendingFileUploadTopicId = '';
                hdnUploadDocErrMsg = ErrMsg;
            }
    catch (DMLException e) {
        }            
    } 


    public void UpdateTopic()
    {
        system.debug('UpdateTopic:');
        try
        {
            hdnUploadDocErrMsg = '';
            if(TypeOfTopic=='UploadDoc')
            {
                hdnPendingFileUploadTopicId = TopicId;
                system.debug('hdnPendingFileUploadTopicId' + hdnPendingFileUploadTopicId);
                system.debug('document name ' + document.name);

                if (document.name != null && document.name != '')
                {
                    ProcessFileUpload();
                }    

                hdnPendingFileUploadTopicId = '';
            }
           
            system.debug('TopicVideoURL:'+TopicVideoURL);
            system.debug('TopicId:'+TopicId);
            system.debug('TopicName:'+TopicName);
            system.debug('TopicDesc:'+TopicDesc);
            system.debug('TopicPublish:'+TopicPublish);
            system.debug('TopicClientFacing:'+TopicClientFacing);
            system.debug('TopicPracticeApprv:'+TopicPracticeApprv);
            system.debug('TypeOfTopic:'+TypeOfTopic);
            system.debug('ImageSelectionTopic:'+ImageSelectionTopic);
            system.debug('TopicCtgryId:'+TopicCtgryId);
            system.debug('EditTagValues:'+EditTagValues);
            system.debug('CategoryType:'+CategoryType);
            system.debug('EditCategoryType:'+EditCategoryType);


            List<string> contype=new List<string>();
            contype.add('image/jpeg');
            contype.add('image/png');
            contype.add('image/jpg');

            Learning__c lrng=[SELECT Id, Name__c,  Description__c, Is_Active__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Practice_Approved__c FROM Learning__c where id=:TopicId limit 1];

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
                if ( (TopicVideoURL!=null) && (TopicVideoURL!=''))
                {
                lrng.URL__c = TopicVideoURL;
                }
                //lrng.URL__c = TopicVideoURL;
                lrng.Type__c=AthenaUtility.LearningTypeVideo;
            }
            else if(TypeOfTopic=='LinkORDoc')
            {
                //url or document
                if ((TopicVideoURL!=null) && (TopicVideoURL!=''))
                {
                    lrng.URL__c = TopicVideoURL;
                }
                lrng.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
            }
            else if(TypeOfTopic=='UploadDoc')
            {
                //upload
                lrng.Type__c='Upload Document';
            }
        
            if(TypeOfTopic!=AthenaUtility.LearningTypeVideo)
            {    
                if(ImageSelectionTopic=='UFC')
                {
                    system.debug('BoardTopicAttach:'+BoardTopicAttach);
                    system.debug('BoardTopicAttachContentType:'+BoardTopicAttach.ContentType);

                    if(BoardTopicAttach!=null)
                    {
                        if (BoardTopicAttach.ContentType!='' && (BoardTopicAttach.ContentType!=null))
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
                    if(dropTopicDefaultSelected!='selectImage')
                    {
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

            Learning_Board_Learning__c lstLrnBrdLrng=[SELECT id,Learning_Category_Id__c,Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:BoardId and Learning_ID__c=:lrng.id limit 1];

            List<User_Learning_Category__c> lstuserLearningCategoryObj = [SELECT Id, Name__c FROM User_Learning_Category__c where Id =: TopicCtgryId ];

            List<Learning_category__c> lstlearningcategoryObj = [select Name__c, id from Learning_category__c where Is_Active__c=True and id =: TopicCtgryId ];
            
            string CategoryTypeEdit = '';

            if(lstlearningcategoryObj.size() > 0 )
            {
                CategoryTypeEdit = 'Default';
            }
            else if(lstuserLearningCategoryObj.size() > 0 )
            {
                CategoryTypeEdit = 'Custom';
            }
            
            if (CategoryTypeEdit == 'Custom')
            {
                lstLrnBrdLrng.User_Learning_Category_ID__c = TopicCtgryId; 
                lstLrnBrdLrng.Learning_Category_Id__c = null;
            }
            else if (CategoryTypeEdit == 'Default')
            {
                lstLrnBrdLrng.Learning_Category_Id__c = TopicCtgryId;
                lstLrnBrdLrng.User_Learning_Category_ID__c = null;
            }

            update lstLrnBrdLrng;

            List<string> strLstTags=new List<string>();
            if (EditTagValues!=null && EditTagValues != '')
            {
                strLstTags=EditTagValues.split(',');
            }
            AthenaUtility.AssociateTags(strLstTags,AthenaUtility.Learning, lrng.id);
        }
        catch (DMLException e) 
        {
            system.debug('DMLException ' + e.getMessage());
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



public PageReference UpdateTopicDocumentUpload()
        {
PageReference pRefDocUpload = new PageReference(UploadAppPath);
   try
{
            hdnUploadDocErrMsg = '';
            if(TypeOfTopic=='UploadDoc') {
                 hdnPendingFileUploadTopicId = TopicId;
                    system.debug('hdnPendingFileUploadTopicId' + hdnPendingFileUploadTopicId);
                    system.debug('document name ' + document.name);
                    if (document.name != null && document.name != '') {
                        ProcessFileUpload();
                    }    
                    hdnPendingFileUploadTopicId = '';
            }
           
    system.debug('TopicVideoURL:'+TopicVideoURL);
            system.debug('TopicId:'+TopicId);
             system.debug('TopicName:'+TopicName);
                system.debug('TopicDesc:'+TopicDesc);
                system.debug('TopicPublish:'+TopicPublish);
                system.debug('TopicClientFacing:'+TopicClientFacing);
                system.debug('TopicPracticeApprv:'+TopicPracticeApprv);
                system.debug('TypeOfTopic:'+TypeOfTopic);
                system.debug('ImageSelectionTopic:'+ImageSelectionTopic);
                system.debug('TopicCtgryId:'+TopicCtgryId);
system.debug('EditTagValues:'+EditTagValues);

        List<string> contype=new List<string>();
        contype.add('image/jpeg');
        contype.add('image/png');
        contype.add('image/jpg');

              

                Learning__c lrng=[SELECT Id, Name__c,  Description__c, Is_Active__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Practice_Approved__c FROM Learning__c where id=:TopicId limit 1];

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
                if ( (TopicVideoURL!=null) && (TopicVideoURL!=''))
                    {
                         lrng.URL__c = TopicVideoURL;
                    }
                                                //lrng.URL__c = TopicVideoURL;
                                                lrng.Type__c=AthenaUtility.LearningTypeVideo;
                                }
        else if(TypeOfTopic=='LinkORDoc')
                                {//url or document
        if ((TopicVideoURL!=null) && (TopicVideoURL!=''))
                    {
                                                lrng.URL__c = TopicVideoURL;
                    }
                                                lrng.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
        }
         else if(TypeOfTopic=='UploadDoc')
                                {//upload
                                                lrng.Type__c='Upload Document';
                
        }
        
        if(TypeOfTopic!=AthenaUtility.LearningTypeVideo)
        {    
             if(ImageSelectionTopic=='UFC')
             {
system.debug('BoardTopicAttach:'+BoardTopicAttach);
system.debug('BoardTopicAttachContentType:'+BoardTopicAttach.ContentType);

                    if(BoardTopicAttach!=null)
                    {

        if (BoardTopicAttach.ContentType!='' && (BoardTopicAttach.ContentType!=null))
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

Learning_Board_Learning__c lstLrnBrdLrng=[SELECT id,Learning_Category_Id__c,Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:BoardId and Learning_ID__c=:lrng.id limit 1];
lstLrnBrdLrng.Learning_Category_Id__c =TopicCtgryId;
update lstLrnBrdLrng;
 List<string> strLstTags=new List<string>();
if (EditTagValues!=null && EditTagValues != '')
                                                {
                                                                 
                                                                  strLstTags=EditTagValues.split(',');
                                                                  
                                                }
AthenaUtility.AssociateTags(strLstTags,AthenaUtility.Learning, lrng.id);
 User user = GetLoggedinUserDtls(); 
pRefDocUpload.getParameters().put('tid', lrng.id);
            pRefDocUpload.getParameters().put('BoardId', BoardId);
            pRefDocUpload.getParameters().put('UserName', user.Name);
            pRefDocUpload.setRedirect(true);
}
 catch (DMLException e) 
{
    system.debug('DMLException ' + e.getMessage());
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
return pRefDocUpload;
}


    //Suman End Code - 

        // Suman Start Code Saturday 03152014

        @RemoteAction
        global static List<RelatedLearningBoard> GetRelatedLB(string boardID)
        {
            RelatedLearningBoard relatedLearningBoard;
            List<RelatedLearningBoard> lstrelatedLearningBoard = new List<RelatedLearningBoard>();

            List<Related_Learning_Board__c> relatedLearningBoardObj = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__r.name__c FROM Related_Learning_Board__c where Learning_Board_ID__C=: boardID and Related_Learning_Board_ID__r.Is_Active__c = true order by Display_Sequence_Nbr__c ];

            for(Related_Learning_Board__c LBLC: relatedLearningBoardObj)
            {
                relatedLearningBoard = new relatedLearningBoard();
                relatedLearningBoard.LearningID = LBLC.Id;
                relatedLearningBoard.LearningName = LBLC.Related_Learning_Board_ID__r.name__c;

                lstrelatedLearningBoard.add(relatedLearningBoard);
            }

            return lstrelatedLearningBoard;
        }

        //Method used to save the changed order of Related Boards
        Public PageReference SaveRelatedChangeOrder()
        {        
            hdnPendingFileUploadTopicId = '';

            integer dsplySeqNo = 1;
            List<Related_Learning_Board__c> updtdRltdLrngBrdLst = new  List<Related_Learning_Board__c>();

            List<Related_Learning_Board__c> rltdLrngBrdLst = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:this.BoardId];

            string[] RelatedChangeOrderId = RelatedChangedOrderId.split(',');
            List<String> lstRelatedBoardId = new List<String>( RelatedChangeOrderId );

            for(string topicItem : lstRelatedBoardId)
            {
                for (Related_Learning_Board__c rltdLrngBrd : rltdLrngBrdLst)
                {
                     if(rltdLrngBrd.Id == topicItem)
                     {
                        rltdLrngBrd.Display_Sequence_Nbr__c= dsplySeqNo; 
                        updtdRltdLrngBrdLst.add(rltdLrngBrd);   
                     }
                }
                dsplySeqNo++;
            }
            update updtdRltdLrngBrdLst;
            Return Null;
        }      

        // Suman End Code Saturday - 03152014

        // Method used to check if the user id is moderator or owner
        public void CheckIfModeratorOrOwner()
        {
            AthenaUserAccess usrAccs = new AthenaUserAccess();

            if(usrAccs.IsModerator(UserInfo.getUserId()) || UserOwnerDetails.id == UserInfo.getUserId())
                 IsBoardModeratorOrOwner = true;
            else
                IsBoardModeratorOrOwner = false;
        }



        // Suman Start Code Saturday 03152014
        // Method used to fetch all the topic details filtered by category for change order
        
        @RemoteAction
        global static List<ChangeLearningBoardOrder> GetLearningBoardOrder(string boardID, string OrderTopicCategoryId)
        {
            ChangeLearningBoardOrder changeLearningBoardOrder;
            List<ChangeLearningBoardOrder> lstChangeLearningBoardOrder = new List<ChangeLearningBoardOrder>();

            List<Learning_Board_Learning__c> LearningBoard =[SELECT Learning_ID__c, Learning_ID__r.name__c, Display_Sequence_Nbr__c ,Learning_Category_Id__c FROM Learning_Board_Learning__c where Learning_Board_ID__C =: boardID and Learning_Category_Id__c =: OrderTopicCategoryId order by Display_Sequence_Nbr__c];

            for(Learning_Board_Learning__c LBLC:LearningBoard)
            {
                changeLearningBoardOrder = new changeLearningBoardOrder();
                changeLearningBoardOrder.LearningID = LBLC.Learning_ID__c;
                changeLearningBoardOrder.LearningName = LBLC.Learning_ID__r.name__c;
                changeLearningBoardOrder.LearningCategoryId = LBLC.Learning_Category_Id__c;

                lstChangeLearningBoardOrder.add(changeLearningBoardOrder);
            }

            return lstChangeLearningBoardOrder;
        }

        // Method used to save change order for topics
        Public PageReference SaveLearningChangeOrder()
        {
            integer i = 1;
            List<Learning_Board_Learning__c> UpdatedList = new  List<Learning_Board_Learning__c>();

            List<Learning_Board_Learning__c> LBLList = [SELECT Learning_ID__c,Learning_ID__r.name__c, Display_Sequence_Nbr__c FROM Learning_Board_Learning__c where Learning_Board_ID__C=: this.BoardId order by Display_Sequence_Nbr__c ];     

            string[] CategorytopicId = CategoryChangeOrderTopicId.split(',');
            List<String> lstCategoryId = new List<String>( CategorytopicId );

            for(string topicItem : lstCategoryId)
            {
                for (Learning_Board_Learning__c LBL : LBLList)
                {
                     if(LBL.Learning_ID__c== topicItem)
                     {
                        LBL.Display_Sequence_Nbr__c= i; 
                        UpdatedList.add(LBL);   
                     }
                }
                i++;
            }

            update UpdatedList; 
            Return Null;
        }

        // Suman End Code Saturday 03152014


        @RemoteAction
    global static List<SLP_IdolQueryResponse> externalsearch(string strSearch, string LearningBrdId)
    {
        SearchResults = search(strSearch, 1, -1, 10);
        return SearchResults;
        //return strSearch;
    }
public static List<SLP_IdolQueryResponse> search(string searchText, integer startItem, integer endItem, integer pageSize)
    {
        boolean endIsUnknown = (endItem == -1);
        
        SLP_IDOL_Settings__c s = SLP_IDOL_Settings__c.getOrgDefaults();      
        PAGE_SIZE = s.Page_Size__c.intValue();
        MAX_HITS = s.Maximum_Hits__c.intValue();
        DATABASE = s.Database__c;
        SERVER = s.Server_URL__c;
        
        SLP_IdolQuery idol = new SLP_IdolQuery(
            SERVER, 
            DATABASE, 
            searchText, 
            pageSize, 
            MAX_HITS, 
            endItem);
        
        //this.Hits = idol.Hits; // side-effect: populate count  
        
        if(endIsUnknown)
        {
            endItem = idol.Hits;
            MaxItem = endItem; // now the end is known
        }
        
        List<SLP_IdolQueryResponse> results = idol.Fetch(startItem);
        
        endItem = ((startItem + pageSize) > endItem) ? endItem : startItem + pageSize;
        System.debug('Search: items ' + startItem + ' to ' + endItem + ' (of ' + endItem + '.)');
        for(SLP_IdolQueryResponse r: results)
        {
            System.debug('url: ' + r.Url + '; weight: ' + r.Weight + '; title: ' + r.Title + '; summary: ' + r.Summary);
        }
       // ExternalResultCount = results.size();
        return results;
    }
public void GetAverageRating()
    {
        string ratingAvgCount = AthenaUtility.getRatingAvg(AthenaUtility.LearningBoard, BoardId);
        if(ratingAvgCount != '')
        {
            list<string> lstrtngAvg =  ratingAvgCount.split(',');

            String myNumber = lstrtngAvg[0];
            String myTruncatedNumber = myNumber.subString(0,myNumber.indexOf('.')+2);
            Decimal d = Decimal.valueOf(myTruncatedNumber);
            System.debug(d);

            UserBoardRating = d;
            BoardRatersCount = lstrtngAvg[1];
            
            //Get rating's history
            //lstRatingHistory = GetRatingHistory();
        }
    }

    @RemoteAction
    global static integer VerifyDuplicateCategoryName(string CategoryName,string learningBoarId)
    {
        string CtrgyNm = CategoryName.trim();
        Integer TCount = 0;
 
        list<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Name__c, Display_Sequence_Nbr__c, Is_Active__c,  Learning_Board_ID__c FROM User_Learning_Category__c where Name__c =: CtrgyNm And Learning_Board_ID__c =: learningBoarId];

        TCount = lstUserLearningCategory.size();
        return TCount;
    }

    public void CreateCategory()
    {
        List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Display_Sequence_Nbr__c FROM User_Learning_Category__c ];
        integer iMaxCtgry = 0;   
        
        system.debug('CreateCategory Method' + lstUserLearningCategory.size()); 
        
        system.debug('lstCommunityCtgry:'+ lstUserLearningCategory);

        if(lstUserLearningCategory.size() == 0)
        {
            iMaxCtgry = 1;
        } 
        else
        {
            iMaxCtgry = lstUserLearningCategory.size() + 1;
        } 

        User_Learning_Category__c userLearningcategory = new User_Learning_Category__c();
        userLearningcategory.Name__c = CategoryName;
        userLearningcategory.Learning_Board_ID__c = BoardId;
        userLearningcategory.Display_Sequence_Nbr__c = iMaxCtgry;
        userLearningcategory.Is_Active__c = true;

        insert userLearningcategory;
    }

@RemoteAction
public static List<RelatedBoardOwner> GetRequestedMembers(string BrdId)
{       
    List<User> lstUsr = [Select Id,Name,Title,SmallPhotoUrl from User where Id in (SELECT User_Id__C FROM Learning_Board_Member__c where Learning_Board_ID__c=:BrdId and Status__c =: AthenaUtility.Requested)];
    List<RelatedBoardOwner> lstReqMem=new List<RelatedBoardOwner>();
    for(User usr :lstUsr )
    {
        RelatedBoardOwner ownerDetails = new RelatedBoardOwner();
        ownerDetails.Id = usr.Id;
        ownerDetails.Name = usr.Name;
        ownerDetails.SmallPhotoUrl = usr.SmallPhotoUrl;
        ownerDetails.Title = usr.Title;
        lstReqMem.add(ownerDetails);
    }

return lstReqMem;                                                 
}

  global class RelatedBoardOwner
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
        public string SmallPhotoUrl { get; set; }
        public string Email { get; set; }
    }

public void LBSavePrivateMemberAccess()
{

    system.debug('PrivateMembersAccess:'+ PrivateMembersAccess);
    String[] splitInput = PrivateMembersAccess.split(',');
    List<String> LrngBrdIds = new List<String>( splitInput );
    system.debug('LrngBrdIds:'+LrngBrdIds);

    List<Learning_Board_Member__c> lstCommunityMem = new List<Learning_Board_Member__c>();
    List<Learning_Board_Member__c> lstApprvRjct = [SELECT Id, Learning_Board_ID__c, User_Id__c, Status__c FROM Learning_Board_Member__c where Learning_Board_ID__c=: BoardId  AND Status__c=:AthenaUtility.Requested];

    if(PrivateMembersAccess != '')
    {
        Map<string,string> MapComm=new Map<string,string>();

        List<string> lstUserIds = new List<string>();

         for(string LrnBrdId : LrngBrdIds)
         {
            string[] splitUnderscore=LrnBrdId.split('_');
            string sTxtUserId= splitUnderscore[0];
            system.debug('sTex:'+sTxtUserId);
            string spApprvRjct= splitUnderscore[1];
            system.debug('sText:'+spApprvRjct);

            MapComm.put(sTxtUserId, spApprvRjct);
            
            lstUserIds.add(sTxtUserId);
         }

         List<EntitySubscription> lstEntitySubc=new  List<EntitySubscription>();
         
         for(Learning_Board_Member__c CMC : lstApprvRjct)
         {
            if (MapComm.containsKey(CMC.User_Id__c))
            {
            
                    EntitySubscription entitySub=new EntitySubscription();
        entitySub.ParentId=BoardId; 
        entitySub.SubscriberID=CMC.User_Id__c;
lstEntitySubc.add(entitySub);
                string strGet = MapComm.get(CMC.User_Id__c);
                CMC.Status__c = strGet;
                lstCommunityMem.add(CMC);
                
            }
         }

        update lstCommunityMem;
        insert lstEntitySubc;
        List<User> lstUser = [select id, name, email from User where id in : lstUserIds];

        Map<string, RelatedBoardOwner> MapMemberDetails = new Map<string, RelatedBoardOwner>();
        
        for(User userItem : lstUser)
        {
            RelatedBoardOwner boardOwner = new RelatedBoardOwner();

            boardOwner.Id = userItem.id;
            boardOwner.Name = userItem.name;
            boardOwner.Email = userItem.email;

            MapMemberDetails.put(userItem.id, boardOwner);
        }

        Messaging.SingleEmailMessage mail;

        for(Learning_Board_Member__c cmntyMember: lstCommunityMem)
        {
            mail = new Messaging.SingleEmailMessage(); 
            
            if(MapMemberDetails.containskey(cmntyMember.User_Id__c))
            {
                RelatedBoardOwner boardOwner = new RelatedBoardOwner();

                boardOwner = MapMemberDetails.get(cmntyMember.User_Id__c);

                system.debug('Provide Member Access:' + boardOwner.email);
                
                string[] toAddresses = new String[] { boardOwner.email };

                string stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, BoardId};
                string formatURL = String.format(stringURL, subjectArguments);
                string bodyString = '';

                mail.setToAddresses(toAddresses); 
                mail.setCCAddresses( new String[]{ UserDetails.email });    
                mail.setUseSignature(false);      
                mail.setSubject(UserDetails.Name + ' has ' + cmntyMember.Status__c + ' your membership for '+ BoardName + ' Board.'); 
                                                                                                
                bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+ boardOwner.name +',&nbsp;</span></span></p>';
                bodyString += '<p> <p><span style="font-size:16px;">You have been '+ cmntyMember.Status__c +' as a member to the Board</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Board Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ BoardName +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Board Description</td><td style="';
                bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ BoardDescription +'</td>';
                bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ UserDetails.email +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL +'>here</a> to view the Board. </span></p>';
                bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+UserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString += '</body></html>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            }  
        }
    }

}

    //<!--Suman Friday Code Start -->

    public void EditCategory()
    {
        List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Learning_Board_ID__c, Name__c, Display_Sequence_Nbr__c, Is_Active__c FROM User_Learning_Category__c where Id=:EditCategoryId  AND  Learning_Board_ID__c =: BoardId ];
        system.debug('EditCategoryNm:'+lstUserLearningCategory);

        if (lstUserLearningCategory.size()>0)
        {
            lstUserLearningCategory[0].Name__c = EditCategoryNm;
            update lstUserLearningCategory[0];
        }
    }

    public void DeleteCommunityCategory()
    {
        List<User_Learning_Category__c> lstUserLearningCategory = [SELECT Id, Learning_Board_ID__c, Name__c, Display_Sequence_Nbr__c, Is_Active__c FROM User_Learning_Category__c where Id=: DeleteCategoryId  AND  Learning_Board_ID__c =: BoardId ];

        system.debug('EditCategoryNm:'+ lstUserLearningCategory);

        if (lstUserLearningCategory.size() > 0)
        {
            delete lstUserLearningCategory[0];
        }
    }
                   
    //<!--Suman Friday Code End -->

}