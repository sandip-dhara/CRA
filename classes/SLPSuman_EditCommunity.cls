global class SLPSuman_EditCommunity
{

    public static string PersistTab {get;set;}
    public String CommunityId {get;set;}
    public String CommunityName{get;set;}
    public String CommunityDescription{get;set;}
    public boolean CommunityPublish{get;set;}
    public string CommunityDefaultImageName{get;set;} 
    public boolean CommunityStaticImage{get;set;} 
    public id AttachmentId{get;set;}
    public string CreateTopicCtgryId {get;set;}
    public string CreateTypeOfTopic {get;set;}
    public string UploadAppPath {get;set;} 
    public string CreateTopicName {get;set;}
    public string CreateTopicDesc {get;set;}
    public boolean CreateTopicPublish {get;set;}
    public string EditCategoryId {get;set;}
    public boolean CreateTopicClientFacing {get;set;}
    public boolean CreateTopicPracticeApprv {get;set;}
    public boolean IsModerator {get;set;}
    public string DTopicId  {get;set;}
    public boolean IsProducerOrModerator{get;set;}
    public string EditCategoryNm {get;set;}
    public String strSearchValue{get;set;}
    public string DeleteCategoryId {get;set;}
    public string OrderCommunityCategoryName {get;set;}
    public string OrderCommunityCategoryId {get;set;}
    public string CommCategoryChangeOrder {get;set;}
    public string hdnRelBrdId {get;set;}
    public Attachment BoardAttach {get;set;}
    public string dropDefaultSelected {get;set;}
    public string OrderTopicCategoryId { get;set; }
    public string OrderTopicCategoryName { get; set; }        
    public string CategoryChangeOrderTopicId  { get; set; }

    public string PrivateMembersAccess {get;set;}
    public string CommApproved {get;set;}
{
   CommApproved=  AthenaUtility.Approved;
}
    public string CommReject {get;set;}
{
    CommReject=AthenaUtility.Rejected;
}


    //Edit Topic
    public string TopicId {get;set;}
        public string TopicName {get;set;}
        public string TopicDesc {get;set;}
        public string dropTopicDefaultSelected {get;set;}
        
    public string ImageSelectionOption {get;set;}
    {
        ImageSelectionOption='UFC';
    }

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




    //Category
    public string CategoryName {get;set;}
    public string CategoryDesc {get;set;}
    public string hdnTopicCatId {get;set;}
    public boolean CommunityPublic{get;set;}
    public string CreateTopicVideoURL {get;set;}

    public User UserOwnerDetails { get; set; }
    public string hdnNewContributorId { get; set;}
    public User OwnerDetails {get;set;}
    public User LoggedInUserDetails {get;set;}
    public boolean IsCommunityModeratorOrOwner { get; set; }
    public string ContributorId {get;set;}
    public  string  hdnChangeOwnerId {get;set;}
    public static string ImageStaticPath {get;set;}
    public string hdnRelatedLB {get;set;} 
    public List<RelatedLearningBoardCustomClass> RelatedLearningBoards { get; set;}
    Public List<RelatedBoardOwner> CommunityMembers{get;set;}

     public string hdnTopicCatName {get;set;}
     public string hdnLURL {get;set;}
     public string hdnPendingFileUploadTopicId {get;set;}
    public SLPSuman_EditCommunity(ApexPages.StandardController controller)
    {
        CommunityId = ApexPages.currentPage().getParameters().get('id');
        CommunityDtls();
        UploadAppPath=AthenaUtility.ApplicationSettingValue(AthenaUtility.UploadAppURL);
        OwnerDetails = getCommunityOwnerDetails();
        CheckIfModeratorOrOwner();
        
        LoggedInUserDetails = GetLoggedinUserDetails();
        FetchStaticPathImage();
        RelatedLearningBoards=new List<RelatedLearningBoardCustomClass>();
        GetRelatedLearningBoards();
        CommunityMembers=new List<RelatedBoardOwner>(); 
        GetMembers();
        CheckIsProducerOrModerator();
    }

    global  Class CommunityDtlsWithCategory{
       public string CategoryId{get;set;}  
       public string CategoryName{get;set;}  
       public List<CategoryDtlsCustomClass> lstlrngs{get;set;}  
    }

    global  class  TopicUserDtls
    {
        public string TopicUserId { get; set; }
        public string TopicUserName { get; set; }
        public string TopicUserPhotoUrl { get; set; }
    }

    global class CollateralBoard
    {
        public string ID { get; set; }
        public string Name { get; set; }
        public string CategoryId { get; set; }
    }

Public  class CategoryDtlsCustomClass
{
public string TopicOwnerId {get;set;}
        public string OwnerPhoto {get;set;}
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public String LShortDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;} 
        public boolean IsActive{get;set;} 
        public boolean ClientFacing{get;set;}     
        public string hpsharedIcon {get;set;}       
        public string fileURLUpload  {get;set;}
        public string filePDFUpload {get;set;} 
        public string filePPTUpload {get;set;} 
        public string fileWordUpload {get;set;} 
        public string fileExcelUpload { get; set;}
        public string fileTextUpload {get;set;}
public string fileVideoUpload {get;set;}
        public boolean PracticeApprv {get;set;}
        public string HPCertification {get;set;}
        public string HPPublish {get;set;}
        public integer StrDescLength {get;set;}
    public string DocId{get;set;} 
    public Decimal AvgRating {get;set;}
        public string RatersCount {get;set;}
}

    global class RelatedLearningBoardCustomClass
    {
        public string AttachmentId{get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
        public boolean LB_Active{get;set;}
        public boolean LB_Featured{get;set;}
        public string DefaultImageName{get;set;} 
        public string OwnerPhotoUrl { get; set; }
        public DateTime LBCrtDate{get;set;}
        public Integer LBNoOfComments{get;set;}  
        public string LBOwnerID{get;set;}  
        public String LBOwnerTitle{get;set;} 
        public Decimal AvgRating{get;set;} 
        public string RatersCount {get;set;}
     }       

    global class RelatedBoardOwner
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
        public string SmallPhotoUrl { get; set; }
        public string Email { get; set; }
    }

    public Void GetMembers()
    {
        List<User> FollowersUsers =  [Select id, Name,Title,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT User_Id__C FROM Community_Member__c where Community_ID__c =: CommunityId and Status__c =: AthenaUtility.Approved)];
        
        for(User usr:FollowersUsers)
        {
            RelatedBoardOwner ownerDetails = new RelatedBoardOwner();
            ownerDetails.Id = usr.Id;
            ownerDetails.Name = usr.Name;
            ownerDetails.SmallPhotoUrl = usr.SmallPhotoUrl;
            if((usr.Title!=null) &&(usr.Title!='')){
            ownerDetails.Title = usr.Title;
            }
            else{
            ownerDetails.Title = '';
            }
            
            CommunityMembers.add(ownerDetails);
        }       
    }

    // Method used to fetch community owner details
    public User getCommunityOwnerDetails()
    {
        User user = [Select usr.id, usr.Title, usr.SmallPhotoUrl, usr.FullPhotoUrl, usr.CompanyName, usr.AboutMe, usr.Name, usr.Division, usr.Department, 
        usr.Email, usr.Phone, usr.MobilePhone, usr.Employee_Country__c, usr.Manager.Name  From User usr where usr.id in (select ownerid from Community__c where id = : CommunityId)];

        return user;
    }

    public User GetLoggedinUserDetails()
    {
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
    public static void FetchStaticPathImage()
    {
        ImageStaticPath = 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
    }

    // Method used to check if the user id is moderator or owner
    public void CheckIfModeratorOrOwner()
    {
        AthenaUserAccess usrAccs = new AthenaUserAccess();
        
        if(usrAccs.IsModerator(UserInfo.getUserId()) || OwnerDetails.id == UserInfo.getUserId())
        {
            system.debug('IsCommunityModeratorOrOwner:'+ IsCommunityModeratorOrOwner);
            IsCommunityModeratorOrOwner = true;
        }
        else
        {
            system.debug('IsCommunityModeratorOrOwner:'+ IsCommunityModeratorOrOwner);
            IsCommunityModeratorOrOwner = false;
        }
    }

    //Method used to fetch Contributors
    public List<User> GetContributors()
    {
        List<User> ContributorsUsers =  [Select id, Name, SmallPhotoUrl, FullPhotoUrl, email From User where id IN (SELECT UserOrGroupId FROM Community__Share where AccessLevel = 'Edit' and ParentId=: CommunityId)];
        return  ContributorsUsers;
    }

public List<SelectOption> getLearningType() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('TopicType','Select type of Topic')); 
        options.add(new SelectOption('Text','Text')); 
options.add(new SelectOption('Video','Video')); 
options.add(new SelectOption('LinkORDoc','Link')); 
options.add(new SelectOption('UploadDoc','Upload Document'));

        return options; 
    }

 Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

  Public User GetLoggedinUserDtls(){
        User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
        return U;
    }

     Public void CommunityDtls()
    {
         list<Attachment> attachmentList = new List<Attachment>();  
         attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :CommunityId];

        Community__c community=   [SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where Id=:CommunityId];
        CommunityName=community.Name__c;
        CommunityDescription=community.description__c;
        CommunityPublish=community.IsActive__c ;
CommunityPublic=community.Public__c;
        if(community.Default_Image_Name__c!='')
            {                        
                CommunityDefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + community.Default_Image_Name__c;          
            }
                        
            CommunityStaticImage = true;
            for(Attachment att: attachmentList)
            {
                if(CommunityId == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    AttachmentId = att.Id;                
                    CommunityStaticImage = false;
                }  
            }

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

public void UpdateCommunity()
    {
        Community__c ECommunity=[SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where id=:CommunityId limit 1];
        ECommunity.Name__c=CommunityName;
        ECommunity.description__c=CommunityDescription;
        ECommunity.IsActive__c =CommunityPublish;
        ECommunity.Public__c = CommunityPublic;
        update ECommunity;

        if(CommunityPublic)
        {
            List<Community_Member__c> lstApprvRjct = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Community_Id__c=: CommunityId  AND Status__c !=: AthenaUtility.Approved];

            List<Community_Member__c> lstUpdate = new List<Community_Member__c>();
            List<EntitySubscription> lstEntitySubc=new  List<EntitySubscription>();
            for(Community_Member__c memberItem : lstApprvRjct)
            {
                EntitySubscription entitySub=new EntitySubscription();
                entitySub.ParentId=CommunityId; 
                entitySub.SubscriberID=memberItem.User_Id__c;
                memberItem.Status__c = AthenaUtility.Approved;
                
                lstUpdate.add(memberItem);
                lstEntitySubc.add(entitySub);
            }
            update lstUpdate;
            insert lstEntitySubc;
            GetMembers();
        }
    }


    public PageReference DoCommunityCancel()
        {
            PageReference pRef = new PageReference('/apex/SLP_ViewCommunity');
            pRef.getParameters().put('id', CommunityId);
            pRef.setRedirect(true);
            return pRef;
        }

        public void CreateCategory()
        {
            List<Community_Category__c> lstCommunityCtgry=[SELECT Id,Display_Sequence_Nbr__c FROM Community_Category__c ];
            integer iMaxCtgry=0;    
            system.debug('lstCommunityCtgry:'+lstCommunityCtgry);
                if(lstCommunityCtgry.size()==0)
                {
                    iMaxCtgry=1;
                } 
                else
                {
                    iMaxCtgry= lstCommunityCtgry.size()+1;
                } 

            Community_Category__c CommunityCtgry=new Community_Category__c();
            CommunityCtgry.Name__c=CategoryName;
            CommunityCtgry.Community_ID__c=CommunityId;
            CommunityCtgry.Display_Sequence_Nbr__c=iMaxCtgry;
            CommunityCtgry.IsActive__c =true;
            insert CommunityCtgry;

            PersistTab = 'Collateral';
        }


public void EditCategory()
{

   List<Community_Category__c> EditCommunityCtgry=[SELECT Id,Name__c,Community_ID__c,Display_Sequence_Nbr__c,IsActive__c  FROM Community_Category__c where Id=:EditCategoryId  AND  Community_ID__c=:CommunityId ];
system.debug('EditCategoryNm:'+EditCategoryNm);

if (EditCommunityCtgry.size()>0)
    {
         EditCommunityCtgry[0].Name__c=EditCategoryNm;
        update EditCommunityCtgry[0];
    }
    //Community_Category__c CommunityCtgry=new Community_Category__c();
    
    //EditCommunityCtgry.Community_ID__c=CommunityId;
    //CommunityCtgry.Display_Sequence_Nbr__c=iMaxCtgry;
    //CommunityCtgry.IsActive__c =true;
    PersistTab='Collateral';
 
}



@RemoteAction
    global static List<CommunityDtlsWithCategory> getCommunityWithCat(string CommId)
    {
List<Community_Category__c> CommunityCatlst= [select Name__c,Id from Community_Category__c  where Community_ID__c=:CommId];
  List<CommunityDtlsWithCategory> lsWithCat=new List<CommunityDtlsWithCategory>();
                for(Community_Category__c lcc :CommunityCatlst)
                {
                   CommunityDtlsWithCategory dtlsWithCat=new CommunityDtlsWithCategory();
                   dtlsWithCat.CategoryId=lcc.id;
                   dtlsWithCat.CategoryName=lcc.Name__c;
                   lsWithCat.add(dtlsWithCat);
                }

List<CommunityDtlsWithCategory> lstLearningBrdCat=GenerateCommunityCtgry(lsWithCat,CommId);
            system.debug('lstLearningBrdCat:'+lstLearningBrdCat.size());
            return lstLearningBrdCat;

//CategoryDtlsCustomClass
        }
 
public static List<CommunityDtlsWithCategory> GenerateCommunityCtgry(List<CommunityDtlsWithCategory> communityDetails, string CommunityID)
{

    string FileURLUpload= 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
    string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
    string  filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
    string filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
    string fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';
    string fileExcelUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileExcelUpload.png';
    string fileTextUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileTextUpload.png';
    string fileVideoUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileVideo.png';
    string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
    string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';

    List<CommunityDtlsWithCategory> lstContainer=new List<CommunityDtlsWithCategory>();


    List<Collateral__c> lstTopicCategory=[SELECT Id, Name__c,ownerid, Description__c, URL__c, Sharepoint_Document_ID__c,  Type__c, IsActive__c, Client_Facing__c, Practice_Approved__c, Community_Category_ID__c FROM Collateral__c  order by Display_Sequence_Nbr__c asc];
    list<id> lstLearningIds= new list<id>();
    list<id> lstCommCatIds= new list<id>();
    for (Collateral__c l:lstTopicCategory ) {
    lstLearningIds.add(l.Id);
    lstCommCatIds.add(l.Community_Category_ID__c);
    }


List<User> lstTopicUsers=[Select id,Name,SmallPhotourl from user where id in (Select ownerid from Collateral__c where Community_Category_ID__c in : lstCommCatIds)];
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


    List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id,Nbr_of_Users_Rated__c  FROM Rated_Item__c where Item_Identifier__c in : lstCommCatIds];
        map<id,string> RatedItemMap = new map<id,string>();        

        for (Rated_Item__c rtdItm :RatedItemLst)
        {
            string AvgRatingAndCnt;
            AvgRatingAndCnt = rtdItm.Rating_Average__c + ',' + rtdItm.Nbr_of_Users_Rated__c;
            RatedItemMap.put(rtdItm.Item_identifier__C, AvgRatingAndCnt);  
        }

for(CommunityDtlsWithCategory LCL:communityDetails)
{
 CommunityDtlsWithCategory lngCat=new CommunityDtlsWithCategory();
                lngCat.CategoryId=LCL.CategoryId;
                lngCat.CategoryName=LCL.CategoryName;
                lngCat.lstlrngs=new List<CategoryDtlsCustomClass>();

            for(Collateral__c learningB:lstTopicCategory)
                {
                    if(learningB.Community_Category_ID__c==LCL.CategoryId)
                    {
                        CategoryDtlsCustomClass lrng = new CategoryDtlsCustomClass();
                        lrng.LName=learningB.Name__c;
                        lrng.LDescription = learningB.Description__c;
                        lrng.LType= learningB.Type__c;   
                        lrng.LURL= learningB.URL__C; 
             lrng.DocId= learningB.Sharepoint_Document_ID__c;
                        lrng.PracticeApprv=learningB.Practice_Approved__c;
                        lrng.IsActive=learningB.IsActive__c;
                        lrng.fileURLUpload=FileURLUpload;
                        lrng.hpsharedIcon=hpsharedIcon;
                        lrng.filePDFUpload=filePDFUpload;
                        lrng.filePPTUpload=filePPTUpload;
                        lrng.fileWordUpload=fileWordUpload;
                        lrng.fileExcelUpload = fileExcelUpload;
                        lrng.HPCertification=HPCertification;
                        lrng.HPPublish=HPPublishIcon;
                        lrng.fileTextUpload=fileTextUpload;
                    lrng.fileVideoUpload=fileVideoUpload;
    if(MapUserDetails.containskey(learningB.OwnerId))
        {
            TopicUserDtls topicUserDetails=new TopicUserDtls();
            topicUserDetails=MapUserDetails.get(learningB.OwnerId);
            lrng.TopicOwnerId=topicUserDetails.TopicUserId;
            lrng.LOwnerName=topicUserDetails.TopicUserName;
            lrng.OwnerPhoto=topicUserDetails.TopicUserPhotoUrl;
        }

 if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                              lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                              lrng.LURL=lrng.LURL.replace('http:', 'https:');
                        }
                        else if(lrng.LType=='Video' && lrng.LURL.contains('www.brainshark.com')){
                              lrng.LURL=lrng.LURL+'&dm=5&pause=1&nrs=1';
                              
                        }

                if(RatedItemMap.containskey(learningB.id))
                {
                                string ratingAvgCount=RatedItemMap.get(learningB.id);
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


                if( lrng.LURL!=null)
                        {   
                            //lrng.DocLnkXst=true;
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



                        lrng.LId = learningB.Id;
                        lrng.ClientFacing=learningB.Client_Facing__c;
                    if(lrng.LDescription.length()>900){
                            lrng.StrDescLength=1;
                            lrng.LShortDescription = lrng.LDescription.substring(0,900) + '...';
                        }
                        else{
lrng.StrDescLength=0;
                            lrng.LShortDescription=lrng.LDescription;
                        }
                        lngCat.lstlrngs.add(lrng);
}
}

lstContainer.add(lngCat);
}

return lstContainer;
}


Public List<SelectOption> getTopicCategory(){
            
        List<SelectOption> LstCategories= new List<SelectOption>();
        LstCategories.add(new SelectOption('selectCategory','--Select Category--'));

        List<Community_Category__c> CommunityCatlst= [select Name__c,Id from Community_Category__c  where Community_ID__c=:CommunityId];
        for(Community_Category__c rlc:CommunityCatlst)
            {
               LstCategories.add(new SelectOption(rlc.Id,rlc.Name__c));    
            }
               return LstCategories;
     }

@RemoteAction
global static integer VerifyDuplicateTopicName(string TopicName)
{
string TName=TopicName.trim();
 Integer TCount=0;
 List<Collateral__c> Lstlrng=[SELECT Id, Name__c FROM Collateral__c where name__C=:TName];

 TCount=Lstlrng.size();
return TCount;
}


public Void CreateCommunityTopic()
{

    List<Collateral__c> lstCollateral=[SELECT id,Display_Sequence_Nbr__c FROM Collateral__c WHERE Community_Category_ID__c =:CreateTopicCtgryId];
                                integer iCMax=0;    

                                if(lstCollateral.size()==0)
                                {
                                                iCMax=1;
                                } 
                                else
                                {
                                                iCMax= lstCollateral.size()+1;
                                }  
                                Collateral__c Collateral= new Collateral__c();
                                Collateral.Name__c = CreateTopicName;
                                Collateral.Description__c = CreateTopicDesc;
                                Collateral.IsActive__c = CreateTopicPublish;
                                
                                Collateral.Client_Facing__c = CreateTopicClientFacing;
                                Collateral.Practice_Approved__c = CreateTopicPracticeApprv;
                                Collateral.Display_Sequence_Nbr__c=iCMax;
Collateral.Community_Category_ID__c =CreateTopicCtgryId;
                    if(CreateTypeOfTopic==AthenaUtility.LearningTypeText)
                                {
                                                //Text
                                                Collateral.Type__c=AthenaUtility.LearningTypeText;
                                }
        else if (CreateTypeOfTopic==AthenaUtility.LearningTypeVideo)
                                {
                                //Video
                                                Collateral.URL__c = CreateTopicVideoURL;
                                                Collateral.Type__c=AthenaUtility.LearningTypeVideo;
                                }
        else if(CreateTypeOfTopic=='LinkORDoc')
                                {//url or document
                                                Collateral.URL__c = CreateTopicVideoURL;
                                                Collateral.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
        }
   else if(CreateTypeOfTopic=='UploadDoc')
                                {

                                                Collateral.Type__c='Upload Document';
                
        }

insert Collateral;

if(CreateTypeOfTopic=='UploadDoc') {
    hdnPendingFileUploadTopicId = Collateral.id;
}
PersistTab='Collateral';

}
 public void CancelUploadClick(){
    hdnPendingFileUploadTopicId = '';
}

    public boolean IsCommunityCreator(string userId)
    {
        system.debug('IsCommunityCreator:' + userId);
        AthenaUserAccess usrAccs = new AthenaUserAccess();
        if(usrAccs.IsModerator(userId) || usrAccs.IsProducer(userId))
        {
            return true;
        }                              
        else
        {
            return false;
        }
    }

    //Method used to add contributors for learning board
    public void AddContributor()
    {
        //If owner id and contributor id are no the same, get contributors
        if (OwnerDetails.id != hdnNewContributorId)
        {
            User usr = [Select Name,email from User where id =: hdnNewContributorId];
        
            Messaging.SingleEmailMessage mail;  
            string bodyString = '';
            string[] toAddresses;
            string stringURL = '';
            string formatURL = '';

            if(IsCommunityCreator(hdnNewContributorId))
            {
                Community__Share lbContr = new Community__Share();
                lbContr.ParentId = CommunityId;
                lbContr.AccessLevel = 'Edit';
            
                lbContr.UserOrGroupId = hdnNewContributorId;
                insert lbContr;
                
                //Adding Permission - Start
                
                List<Collateral__c> CollIds=[SELECT Id FROM Collateral__c Where Community_Category_ID__c=:CommunityId];
                
                List<string> lstLrngs=New List<string>();

                for(Collateral__c lrng:CollIds)
                {
                    lstLrngs.add(lrng.Id);
                }
                List<Collateral__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Collateral__Share where UserOrGroupId =:hdnNewContributorId and ParentId IN:lstLrngs];

                Map<string,string> MapLrng= New Map<string,string>();
                for(Collateral__Share lrngShare:lstLrngShare)
                {
                    MapLrng.put(lrngShare.ParentId,lrngShare.UserOrGroupId);            
                }

                lstLrngShare=new List<Collateral__Share>();
                for(string lrng:lstLrngs)
                {
                    if(!MapLrng.containsKey(lrng))
                    {
                        Collateral__Share lrngShare=new Collateral__Share();
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
                mail.setSubject('You have been added as Contributor for the Community - ' + CommunityName); 
                stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, CommunityId};
                formatURL = String.format(stringURL, subjectArguments);
                bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'You have been added as Contributor for the Community - <a href='+formatURL+'>'+CommunityName+'</a></span>';
                bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
                bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+LoggedInUserDetails.Name+'</span></h3></td></tr></tbody></table>';

                mail.setHtmlBody(bodyString);

                //Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            }
            else
            {           
                mail = new Messaging.SingleEmailMessage();
                toAddresses = new String[] {usr.Email};                                    
                mail.setToAddresses(toAddresses);       
                mail.setSubject('You have been added as a contributor, You will get Access soon for the Community ' + CommunityName); 
                string pdl = 'es_slp_user_access@hp.com';
                mail.setCCAddresses( new String[]{UserOwnerDetails.email,pdl});
                stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, CommunityId};
                formatURL = String.format(stringURL, subjectArguments);

                bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 1200px;">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
                bodyString += 'You have been added as a contributor for the Community - <a href='+formatURL+'>'+CommunityName+'</a><br/><br/>';
                bodyString += 'Hi Team ' + ',<br/><br/>';
                bodyString += 'Please provide access to ' + usr.Name + ' for the Community -' + CommunityName +' and update the user.<br/><br/>';
                bodyString += 'Hi ' + OwnerDetails.Name +',<br/><br/>';
                bodyString += 'Until team provide access you will not be able to see ' + usr.Name + ' as contributor for your Board ' + CommunityName + '</span>';
                bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
                bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+LoggedInUserDetails.Name+'</span></h3></td></tr></tbody></table>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
             }
            
        }
    }
    
    // Method used to remove a contributor for a community
    public void RemoveContributor()
    {
       List<Community__Share> lbContr = [SELECT UserOrGroupId FROM Community__Share where AccessLevel='Edit' and ParentId=:CommunityId and UserOrGroupId=: ContributorId];

    if(lbContr.size()>0)
    {

        delete lbContr;
        User usr=[Select Name,email from User where id=:ContributorId];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {usr.Email};
        mail.setToAddresses(toAddresses);       
        mail.setSubject('You have been removed as Contributor for the Community - ' + CommunityName); 
        //mail.setUseSignature(true);

        string bodyString = '';
        bodyString = bodyString + '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;"> You have been removed as Contributor for the Community - '+CommunityName+'</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+LoggedInUserDetails.Name+'</span></h3></td></tr></tbody></table>';

        mail.setHtmlBody(bodyString);

        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
    }
}

    public void CommunityChangeOwner()
    {
        User usr=[Select Name, email from User where id=: hdnChangeOwnerId];
        Messaging.SingleEmailMessage mail;
        string[] toAddresses;
        string stringURL = '';
        string formatURL = '';
        string bodyString = '';

        if(IsCommunityCreator(hdnChangeOwnerId))
        {
            List<User> ContributorsUsers =  [Select id From User where id IN (SELECT UserOrGroupId FROM Community__Share where AccessLevel='Edit' and ParentId=: CommunityId)];
            Community__c communityObj = [SELECT OwnerId, Id, Name FROM Community__c where Id =: CommunityId limit 1];
            communityObj.OwnerId = hdnChangeOwnerId;
            update communityObj;
      
            List<Community__Share> lstCommunityshare = new List<Community__Share>();

            for (User u:ContributorsUsers)
            {
                if (hdnChangeOwnerId != u.id)
                {
                      Community__Share communityShare = new Community__Share();
                      communityShare.UserOrGroupId = u.id;
                      communityShare.ParentId = CommunityId;
                      communityShare.AccessLevel = 'Edit';
                  
                      lstCommunityshare.add(communityShare);
                }
            }
            insert lstCommunityshare;
    
                //Adding Permission - Start
                
                List<Collateral__c> CollIds=[SELECT Id FROM Collateral__c Where Community_Category_ID__c=:CommunityId];
                
                List<string> lstLrngs=New List<string>();

                for(Collateral__c lrng:CollIds)
                {
                    lstLrngs.add(lrng.Id);
                }
                List<Collateral__Share> lstLrngShare=[SELECT ParentId,UserOrGroupId FROM Collateral__Share where UserOrGroupId =:hdnChangeOwnerId and ParentId IN:lstLrngs];

                Map<string,string> MapLrng= New Map<string,string>();
                for(Collateral__Share lrngShare:lstLrngShare)
                {
                    MapLrng.put(lrngShare.ParentId,lrngShare.UserOrGroupId);            
                }

                lstLrngShare=new List<Collateral__Share>();
                for(string lrng:lstLrngs)
                {
                    if(!MapLrng.containsKey(lrng))
                    {
                        Collateral__Share lrngShare=new Collateral__Share();
                        lrngShare.ParentId=lrng;
                        lrngShare.AccessLevel='Edit';
                        lrngShare.UserOrGroupId= hdnChangeOwnerId;         
                        lstLrngShare.add(lrngShare);
                    }
                }
                insert lstLrngShare;
                
                //Adding Permission - End

            
    
            getCommunityOwnerDetails();
    
            mail = new Messaging.SingleEmailMessage();
            toAddresses = new String[] {usr.Email};
            mail.setToAddresses(toAddresses);       
            mail.setSubject('You are the new owner of this Community - ' + CommunityName); 
            mail.setUseSignature(false);
            stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
            string[] subjectArguments = new String[] { getSfInstance, CommunityId};
            formatURL = String.format(stringURL, subjectArguments);
            bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
            bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
            bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
            bodyString += 'You are the new owner of this Community - <a href='+formatURL+'>'+CommunityName+'</a></span>';
            bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
            bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+LoggedInUserDetails.Name+'</span></h3></td></tr></tbody></table>';
            mail.setHtmlBody(bodyString);

            //Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
         }
         else
         {       
            mail = new Messaging.SingleEmailMessage();
            toAddresses = new String[] {usr.Email};                                    
            mail.setToAddresses(toAddresses);       
            mail.setSubject('You have been added as a contributor, You will get Access soon for the Learning Board ' + CommunityName); 
            string pdl='esds-athena-team@hp.com';
            mail.setCCAddresses( new String[]{OwnerDetails.Email, pdl});
            stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
            string[] subjectArguments = new String[] { getSfInstance, CommunityId};
            formatURL = String.format(stringURL, subjectArguments);

            bodyString += '<table align="left" border="0" cellpadding="1" cellspacing="1" style="width: 1200px;">';
            bodyString += '<tbody><tr><td><h3><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
            bodyString += 'Hi '+usr.Name+',</span><br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">';
            bodyString += 'You have been added as a owner for the Community - <a href='+formatURL+'>'+CommunityName+'</a><br/><br/>';
            bodyString += 'Hi Team ' + ',<br/><br/>';
            bodyString += 'Please provide access to ' + usr.Name + ' for the Community -' + CommunityName +' and update the user.<br/><br/>';
            bodyString += 'Hi ' + OwnerDetails.Name +',<br/><br/>';
            bodyString += 'Until team provide access you will not be able to see ' + usr.Name + ' as contributor for your Board ' + CommunityName + '</span>';
            bodyString += '<br/><br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">Thanks & Regards,</span>';
            bodyString += '<br/><span style="font-size:16px; font-family:Trebuchet MS; font-weight:normal;">'+LoggedInUserDetails.Name+'</span></h3></td></tr></tbody></table>';

            mail.setHtmlBody(bodyString);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                           
          }                     
       }
    
    @RemoteAction
    global static List<RelatedLearningBoardCustomClass> AddRelatedCommunityBoards(string strSearch, string strLBID)
    {
        List<RelatedLearningBoardCustomClass> relLBs = SearchRelatedLearningBoard(strSearch,strLBID);

        return relLBs;
    }

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
        
        List<Tag_Item__c> tagItmLst=[SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: SearchStr) and Item_Name__c=:AthenaUtility.LearningBoard  and Item_Identifier__c IN :lbBrdIds];
        
        for(Tag_Item__c TagItm : tagItmLst)
        {
             lbBrdIdSet.add(TagItm.Item_Identifier__c);
        }

        for(Learning_Board__c lb : lbBrdSrchRslt)
        {
             lbBrdIdSet.add(lb.id);
        }

        if(lbBrdIdSet.contains(strLBID))
        {
            lbBrdIdSet.remove(strLBID);
        }

        List<Community_Learning_Board__c > rltdLrngBrdLst = [SELECT Id, Community_ID__c, Learning_Board_ID__c, Display_Sequence_Nbr__c, Is_Active__c FROM Community_Learning_Board__c where Community_ID__c =: strLBID  ];

        boolean flag;
        set<ID> finalLrngBrdIds = new set<ID>();
        for(ID l : lbBrdIdSet)
        {
            flag=false;
            for(Community_Learning_Board__c lbl : rltdLrngBrdLst)
            {
                if(lbl.Learning_Board_ID__c == l)
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
    try{
        list<Community_Learning_Board__c> groupedResults = [SELECT Id FROM Community_Learning_Board__c WHERE Community_ID__c =: CommunityId];
        
        integer maxDsplySeqNo = 0;
         if(groupedResults==null)
         {
            maxDsplySeqNo = 1;
         } 
         else
         {
            maxDsplySeqNo = groupedResults.size() + 1;
         }    

        List<Community_Learning_Board__c> rltdLrngBrdLst = new List<Community_Learning_Board__c>();
 
        String[] splitInput = hdnRelatedLB.split(',');
        List<String> LrngBrdIds = new List<String>( splitInput );

        system.debug('LrngBrdIds:' +LrngBrdIds);
        system.debug('splitInput:' +splitInput);
        system.debug('maxDsplySeqNo:' +maxDsplySeqNo);

 
        for(string LrnBrdId : LrngBrdIds)
        {
            Community_Learning_Board__c rltdLrngBrd = new Community_Learning_Board__c();

            rltdLrngBrd.Community_ID__c = CommunityId;
            rltdLrngBrd.Learning_Board_ID__c = LrnBrdId;
            rltdLrngBrd.Display_Sequence_Nbr__c = maxDsplySeqNo;
            rltdLrngBrdLst.add(rltdLrngBrd);
        }
        insert rltdLrngBrdLst;
        GetRelatedLearningBoards();
        }
        finally
        {
        PersistTab='Boards';
        }
    }

    public void GetRelatedLearningBoards()
    {
            RelatedLearningBoards.clear();  
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 

            List<Community_Learning_Board__c>  rLBs = [SELECT Id, Learning_Board_ID__r.CreatedDate, Learning_Board_ID__r.Default_Image_Name__c, Community_ID__c, Learning_Board_ID__c, Display_Sequence_Nbr__c, Learning_Board_ID__r.OwnerId, Is_Active__c, Learning_Board_ID__r.Name__C,
                                                       Learning_Board_ID__r.description__c FROM Community_Learning_Board__c where Community_ID__c =: CommunityId
                                                       and Learning_Board_ID__r.Is_Active__c = True order by Display_Sequence_Nbr__c];
            List<string> lstOwnerIds=new List<String>();
            for (Community_Learning_Board__c rLB: rLBs)
            {
                lstRLBIds.add(rLB.Learning_Board_ID__c);
                lstOwnerIds.add(rLB.Learning_Board_ID__r.OwnerId);
            }
    
            List<User> lstBoardOwner=[Select Id, Name, Title, SmallPhotoUrl from User where id in: lstOwnerIds];
            Map<id, RelatedBoardOwner> MapOwnerDetails =new Map<id, RelatedBoardOwner>();
            
            for(User userDtls :lstBoardOwner)
            {
                if(!MapOwnerDetails.containskey(userDtls.id))
                {
                    RelatedBoardOwner ownerDetails = new RelatedBoardOwner();
                    ownerDetails.Id = userDtls.Id;
                    ownerDetails.Name = userDtls.Name;
                    ownerDetails.SmallPhotoUrl = userDtls.SmallPhotoUrl;
                    ownerDetails.Title = userDtls.Title;

                    MapOwnerDetails.put(userDtls.id, ownerDetails);
                }
            }

           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :lstRLBIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      

           List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :lstRLBIds];
           map<id,decimal> RatedItemMap = new map<id,decimal>();        
        
           for (Rated_Item__c rtdItm :RatedItemLst)
           {
                RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
           }

            string typeComm = '\'' + 'TextPost' + '\'';

            List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :lstRLBIds];

            Map<String,Integer> CmntCntMap = new Map<String,Integer>();
            system.debug('FI##'+feeddItmlst);

            for (FeedItem feedItm : feeddItmlst)
            {            
              if(!CmntCntMap.containskey(feedItm.ParentId))
              {
                  CmntCntMap.put(feedItm.ParentId,1);
              }
              else
              {
                  integer i = CmntCntMap.get(feedItm.parentId);
                  CmntCntMap.put(feedItm.parentId,i+1);            
              }
            }  
            attachmentList = [SELECT Id,Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Community_Learning_Board__c lb: rLBs)
            {
                RelatedLearningBoardCustomClass  lbCustom = new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Learning_Board_ID__r.Name__c; 
                lbCustom.LbId = lb.Learning_Board_ID__c;
                lbCustom.DefaultImageName = ImageStaticPath + lb.Learning_Board_ID__r.Default_Image_Name__c;
                lbCustom.LBOwnerID = lb.Learning_Board_ID__r.OwnerId;
                lbCustom.LBCrtDate = lb.Learning_Board_ID__r.CreatedDate;

                if(lb.Learning_Board_ID__r.Name__c != null) 
                { 
                    if(lb.Learning_Board_ID__r.Name__c.length() > 35) 
                    { 
                        lbCustom.LBName = lb.Learning_Board_ID__r.Name__c.substring(0, 35) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBName = lb.Learning_Board_ID__r.Name__c; 
                    } 
                }

                if(lb.Learning_Board_ID__r.description__c != null)
                { 
                    if(lb.Learning_Board_ID__r.description__c.length()>75)
                    { 
                        lbCustom.LBDescription = lb.Learning_Board_ID__r.Description__c.substring(0,75) + '...'; 
                    } 
                    else
                    { 
                        lbCustom.LBDescription=lb.Learning_Board_ID__r.description__c; 
                    } 
                }

                if(RatedItemMap.containskey(lbCustom.LbId)) 
                { 
                    lbCustom.AvgRating = RatedItemMap.get(lbCustom.LbId); 
                } 
                else 
                { 
                    lbCustom.AvgRating=0; 
                }

                if (MapOwnerDetails.containskey(lb.Learning_Board_ID__r.OwnerId))
                {
                    RelatedBoardOwner relatedBoardOwner = new RelatedBoardOwner();
                    
                    relatedBoardOwner = MapOwnerDetails.get(lb.Learning_Board_ID__r.OwnerId);
                    lbCustom.LBOwnerName = relatedBoardOwner.Name;
                    lbCustom.LBOwnerTitle = relatedBoardOwner.Title;
                    lbCustom.OwnerPhotoUrl = relatedBoardOwner.SmallPhotoUrl;
                }

                if(lbCustom.LBOwnerName != null) 
                { 
                    lbCustom.LBOwnerName = lbCustom.LBOwnerName; 
                    if(lbCustom.LBOwnerName.length() > 15) 
                    { 
                        lbCustom.LBOwnerName = lbCustom.LBOwnerName.substring(0, 16) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBOwnerName = lbCustom.LBOwnerName; 
                    } 
                }

                if(lbCustom.LBOwnerTitle != null) 
                { 
                    lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle; 
                    if(lbCustom.LBOwnerTitle.length() > 25) 
                    { 
                        lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle.substring(0, 25) + '...'; 
                    } 
                    else 
                    { 
                        lbCustom.LBOwnerTitle = lbCustom.LBOwnerTitle; 
                    } 
                }

                if(CmntCntMap.containskey(lbCustom.LbId)) 
                { 
                    lbCustom.LBNoOfComments = CmntCntMap.get(lbCustom.LbId); 
                } 
                else 
                { 
                    lbCustom.LBNoOfComments=0; 
                }

                //public boolean LB_Active{get;set;}

                lbCustom.StaticImage = true;
                
                if(AttMap.containsKey(lbCustom.LbId))
               {
                    lbCustom.AttachmentId = AttMap.get(lbCustom.LbId);
                   lbCustom.StaticImage = false;
                }              

               
                RelatedLearningBoards.add(lbCustom);
            }                
    }

public void CancelTopic()
    {
    }
public void UpdateTopic()
{
try
{
                      
    system.debug('TopicVideoURL:'+TopicVideoURL);
    system.debug('TopicId:'+TopicId);
    system.debug('TopicName:'+TopicName);
    system.debug('TopicDesc:'+TopicDesc);
    system.debug('TopicPublish:'+TopicPublish);
    system.debug('TopicClientFacing:'+TopicClientFacing);
    system.debug('TopicPracticeApprv:'+TopicPracticeApprv);
    system.debug('TypeOfTopic:'+TypeOfTopic);
    //system.debug('ImageSelectionTopic:'+ImageSelectionTopic);
    system.debug('TopicCtgryId:'+TopicCtgryId);


//List<string> contype=new List<string>();
//contype.add('image/jpeg');
//contype.add('image/png');
//contype.add('image/jpg');

Collateral__c lrng=[SELECT Id, Name__c,ownerid, Description__c, URL__c, Type__c, IsActive__c, Client_Facing__c, Practice_Approved__c, Community_Category_ID__c FROM Collateral__c  where Id=:TopicId limit 1];

//Collateral__c lrng=[SELECT Id, Name__c,  Description__c, Is_Active__c, Type__c, Short_Description__c, URL__c, Default_Image_Name__c, ClientFacing__c, Practice_Approved__c FROM Learning__c where id=:TopicId limit 1];

lrng.Name__c= TopicName;
lrng.Description__c=TopicDesc;
lrng.Community_Category_ID__c=TopicCtgryId;
lrng.IsActive__c=TopicPublish;
lrng.Client_Facing__c = TopicClientFacing;
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
{
//upload
    lrng.Type__c='Upload Document';
                
}
        
update lrng;

}
catch (DMLException e) 
{
system.debug('DMLException ' + e.getMessage());
}
finally
{
 
//BoardTopicAttach = new Attachment();
TopicName =''; 
TopicDesc=''; 
TopicPublish=false; 
TopicClientFacing=false; 
TopicPracticeApprv=false; 
TypeOfTopic='';
//ImageSelectionTopic ='';
TopicCtgryId ='';
TopicVideoURL='';
 
    PersistTab='Collateral';
}
}

 public List<SelectOption> getImageOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('UFC','Upload from Computer')); 
        options.add(new SelectOption('DI','Default Image')); 
        return options; 
    }



public void DeleteTopic()
{
system.debug('DTopicId:'+DTopicId);
List<Collateral__c>  DeleteColl =[SELECT Id, Name__c FROM Collateral__c  where Id=:DTopicId ];
if(DeleteColl.size()>0)
{
    delete DeleteColl;
}
    PersistTab='Collateral';
}

@RemoteAction
public static List<RelatedBoardOwner> GetRequestedMembers(string CmtyId)
{       
    List<User> lstUsr = [Select Id,Name,Title,SmallPhotoUrl from User where Id in (SELECT User_Id__C FROM Community_Member__c where Community_ID__c=:CmtyId and Status__c =: AthenaUtility.Requested)];
    List<RelatedBoardOwner> lstReqMem=new List<RelatedBoardOwner>();
    for(User usr :lstUsr )
    {
        RelatedBoardOwner ownerDetails = new RelatedBoardOwner();
        ownerDetails.Id = usr.Id;
        ownerDetails.Name = usr.Name;
        ownerDetails.SmallPhotoUrl = usr.SmallPhotoUrl;
        system.debug('UTitle:'+usr.Title);
        if(usr.Title==null)
        {
          ownerDetails.Title ='';
        }
        else
        {
        ownerDetails.Title = usr.Title;
        }
        lstReqMem.add(ownerDetails);
    }

return lstReqMem;                                                 
}

                               
public void UpdateRequestedMembersStatus()
{
   List<Community_Member__c> lstCommMember = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Community_ID__c=:CommunityId and Status__c =: AthenaUtility.Requested];
                                                                                
    for(Community_Member__c comm :lstCommMember )
    {
    //AthenaUtility.Requested
    //AthenaUtility.Approved
    //AthenaUtility.Rejected
        comm.Status__C='';
    }                              
                                
}
             
public void DeleteCommunityCategory()
{
   List<Community_Category__c> DelCommunityCtgry = [SELECT Id,Name__c,Community_ID__c,Display_Sequence_Nbr__c,IsActive__c  FROM Community_Category__c where Id=:DeleteCategoryId  AND  Community_ID__c=:CommunityId ];

   List<Collateral__c> lstCollateral = [SELECT Community_Category_ID__c, Id FROM Collateral__c where Community_Category_ID__c =: DeleteCategoryId];

    system.debug('EditCategoryNm:'+DelCommunityCtgry);

    if (DelCommunityCtgry.size()>0)
    {
        delete DelCommunityCtgry[0];
    }

    if (lstCollateral.size() > 0)
       {
           delete lstCollateral;  
       }
       PersistTab = 'Collateral';
}

                   


public void SavePrivateMemberAccess()
{

    system.debug('PrivateMembersAccess:'+ PrivateMembersAccess);
    String[] splitInput = PrivateMembersAccess.split(',');
    List<String> LrngBrdIds = new List<String>( splitInput );
    system.debug('LrngBrdIds:'+LrngBrdIds);

    List<Community_Member__c> lstCommunityMem = new List<Community_Member__c>();
    List<Community_Member__c> lstApprvRjct = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where Community_Id__c=: CommunityId  AND Status__c=:AthenaUtility.Requested];

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

         for(Community_Member__c CMC : lstApprvRjct)
         {
            if (MapComm.containsKey(CMC.User_Id__c))
            {
                string strGet = MapComm.get(CMC.User_Id__c);
                CMC.Status__c = strGet;
                lstCommunityMem.add(CMC);
            }
         }

        update lstCommunityMem;

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

        for(Community_Member__c cmntyMember: lstCommunityMem)
        {
            mail = new Messaging.SingleEmailMessage(); 
            
            if(MapMemberDetails.containskey(cmntyMember.User_Id__c))
            {
                RelatedBoardOwner boardOwner = new RelatedBoardOwner();

                boardOwner = MapMemberDetails.get(cmntyMember.User_Id__c);

                system.debug('Provide Member Access:' + boardOwner.email);
                
                string[] toAddresses = new String[] { boardOwner.email };

                string stringURL = 'https://{0}/apex/SLP_ViewCommunity?id={1}';
                string[] subjectArguments = new String[] { getSfInstance, CommunityId};
                string formatURL = String.format(stringURL, subjectArguments);
                string bodyString = '';

                mail.setToAddresses(toAddresses); 
                mail.setCCAddresses( new String[]{ LoggedInUserDetails.email });    
                mail.setUseSignature(false);      
                mail.setSubject(LoggedInUserDetails.Name + ' has ' + cmntyMember.Status__c + ' your membership for '+ CommunityName + ' Community.'); 
                                                                                                
                bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+ boardOwner.name +',&nbsp;</span></span></p>';
                bodyString += '<p> <p><span style="font-size:16px;">You have been '+ cmntyMember.Status__c +' as a member to the community</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Community Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityName +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Community Description</td><td style="';
                bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityDescription +'</td>';
                bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ LoggedInUserDetails.email +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL +'>here</a> to view the Community. </span></p>';
                bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+LoggedInUserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString += '</body></html>';

                mail.setHtmlBody(bodyString);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                PersistTab='ProvideMemAccess';
            }  
        }
    }
}



    public void RemoveCommunityBoard()
    {
        List< Community_Learning_Board__c>  rltdLrngBrd = [Select Id From Community_Learning_Board__c WHERE Learning_Board_ID__c =: hdnRelBrdId AND Community_ID__c =: CommunityId ];
        if(rltdLrngBrd.size()>0)
        {
            delete rltdLrngBrd;
            GetRelatedLearningBoards();
        }
}

    @RemoteAction
    global static List<CollateralBoard> GetCollateralBoardOrder(string OrderTopicCategoryId)
    {
        CollateralBoard collateralBoard;

        List<CollateralBoard> lstCollateralBoard = new List<CollateralBoard>();

        List<Collateral__c> lstCollateralObj = [SELECT Id, Name__c, Community_Category_ID__c, Display_Sequence_Nbr__c FROM Collateral__c
                                              where Community_Category_ID__c =: OrderTopicCategoryId order by Display_Sequence_Nbr__c];

        for(Collateral__c collateralItem: lstCollateralObj)
        {
            collateralBoard = new CollateralBoard();

            collateralBoard.ID = collateralItem.Id;
            collateralBoard.Name = collateralItem.Name__c;
            collateralBoard.CategoryId = collateralItem.Community_Category_ID__c;

            lstCollateralBoard.add(collateralBoard);
        }

        return lstCollateralBoard;
    }

    // Method used to save change order for topics
    Public PageReference SaveCollateralChangeOrder()
    {
    
        system.debug('SaveCollateralChangeOrder:' + OrderTopicCategoryId);

        integer i = 1;
        List<Collateral__c> UpdatedList = new  List<Collateral__c>();

        List<Collateral__c> LBLList = [SELECT Id, Name__c, Community_Category_ID__c, Display_Sequence_Nbr__c FROM Collateral__c where
                                        Community_Category_ID__c =: OrderTopicCategoryId order by Display_Sequence_Nbr__c ];     

        string[] CategorytopicId = CategoryChangeOrderTopicId.split(',');
        List<String> lstCategoryId = new List<String>( CategorytopicId );

        for(string topicItem : lstCategoryId)
        {
            for (Collateral__c LBL : LBLList)
            {
                    if(LBL.Id== topicItem)
                    {
                        LBL.Display_Sequence_Nbr__c= i; 
                        UpdatedList.add(LBL);   
                    }
            }
            i++;
        }

        update UpdatedList; 
        PersistTab='Collateral';
        Return Null;
    }

public void SaveCommunityChangeOrder()
{
  
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
                    Community__c community =[SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where Id=:CommunityId];
                    community.Default_Image_Name__c=dropDefaultSelected;
                    update community;
                    List<Attachment> lbatt=[select id from Attachment where ParentId =:CommunityId ];
                    delete lbatt;
                }
 
            }
            else if(ImageSelectionOption=='UFC'){

                If(BoardAttach!=null)
                {
                    If(BoardAttach.contenttype!='')
                    {
                        List<Attachment> lbatt=[select id from Attachment where ParentId =:CommunityId ];
                        delete lbatt;
                        BoardAttach.ParentId =CommunityId;
                        insert BoardAttach;
                        Community__c communityL =[SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where Id=:CommunityId];
                        communityL.Default_Image_Name__c='';
                        update communityL;

                    }
                }
            
        
            }
//Temp Fix: Method call fro board image refresh
       CommunityDtls();
       
}
catch (DMLException e) 
{

}
 finally
    {
 
      BoardAttach = new Attachment();
 
    }
}

 Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
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

  public PageReference doSearch()
    {
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal', strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }

@RemoteAction
global static integer VerifyDuplicateCategoryName(string CategoryName,string CommunityId )
{
string CtrgyNm=CategoryName.trim();
 Integer TCount=0;
 
list<Community_Category__c> lstCommunityCtgry =[SELECT Id, Name__c, Description__c, Display_Sequence_Nbr__c, IsActive__c, Community_ID__c FROM Community_Category__c where name__C=:CtrgyNm AND Community_ID__c=:CommunityId];

 TCount=lstCommunityCtgry.size();
return TCount;
}

@RemoteAction
global static integer VerifyDuplicateCategoryTopicName(string TopicName,string CCId )
{
string TNm=TopicName.trim();
 Integer TCount=0;
 
list<Collateral__c> lstCollateral =[SELECT Id, Name__c, Description__c, Type__c, URL__c, IsActive__c, Community_Category_ID__c FROM Collateral__c where Community_Category_ID__c =:CCId AND Name__c=:TNm];

 TCount=lstCollateral.size();
return TCount;
}

public void CheckIsProducerOrModerator()
    {
       AthenaUserAccess UsrAcc=new AthenaUserAccess();
       if ( UsrAcc.IsModerator(UserInfo.getUserId()) || UsrAcc.IsProducer(UserInfo.getUserId()))
       {
            IsProducerOrModerator= true;
       }
       else
       {   
            IsProducerOrModerator=false;
       }
    }

}