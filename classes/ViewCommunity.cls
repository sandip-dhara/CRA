global class ViewCommunity
{
public static string PersistTab {get;set;}
    public String CommunityId { get; set; }
    public String CommunityName { get; set; }
    public String CommunityShortName { get; set; }
    public String CommunityDescription { get; set; }
    public string CommunityShortDescription { get; set; }
    public boolean CommunityPublish { get; set; }
    public string CommunityDefaultImageName { get; set; }
    public boolean CommunityStaticImage { get; set; } 
    public boolean CommunityPublic{get;set;}
    public id AttachmentId{get;set;}
    public static string ImageStaticPath {get;set;}
    Public string BoardId{get;set;}
    Public string BoardName{get;set;}
    public boolean IsBoardExist { get; set; }
    public string SLPRegistrationUrl { get; set;}
    public string SSOUrl { get; set;}
    public string SelectedUsrs {get;set;}
    public string hdnSharecmt {get;set;}
    public string ShareTopicId { get; set; }
    public string hdnTopicCatName { get; set; }
    //public string ContentFlag { get; set; }
    public string ShareTopicName { get; set; }
    public string ShareTopicDesc { get; set; }
    public string hdnShareContentFlag { get; set;}
    public static List<CustomContributorAndMember> lstContributorMember {get;set;}
    public integer ContributorMemCount {get;set;}
    public class CustomContributorAndMember
  {
    public Id UserId {get;set;}
    public string UserName {get;set;}
    public string RoleName {get;set;}
    public string Userphoto {get;set;}
    public boolean IsContributor {get;set;}
    public string Region {get;set;}
    public string BusinessGroup {get;set;}
    public boolean IsExperts {get;set;}
  }
    
    public boolean IsUserRoleMappingVisible
    {
    get
    {
    
    string userId=UserInfo.getUserId();
    
    AthenaUserAccess UsrAcc=new AthenaUserAccess();
       
                   if (UsrAcc.IsModerator(userId))
                return true;
            else
                return false;        
    }
    }
    public User OwnerDetails {get;set;}
    public User LoggedInUserDetails {get;set;}
    public boolean IsProducerOrModerator{get;set;}

    public List<RelatedLearningBoardCustomClass> RelatedLearningBoards { get; set;}
    public List<RelatedBoardOwner> CommunityMembers{get;set;}

    public boolean IsOwnerOrContributor { get; set; }  
    public static boolean IsUserOwnerOrContributor { get; set; }  
    public boolean IsMember { get; set; }  
    public boolean IsOwnerOrContrOrMember { get; set; } 

    public string InviteUserEmail { get; set;}
    public string LBOwnerId {get;set;} 
    public boolean isloggedUser { get; set; }
    public String strSearchValue{get;set;}
    public string CategoryName {get;set;}

    public boolean IsRequested { get; set;}
    public boolean IsModeratorAccess { get; set; }
    public boolean DescriptionLimit;

    public integer UserTopicRating { get; set; }
    public string userTopicRatingComment { get; set;}
    public string CommunityTopicID { get; set;}
    public Decimal AvgRating {get;set;}
        public string RatersCount {get;set;}
        public boolean BtnshowHideEdit { get; set; }


    global  Class CommunityDtlsWithCategory
    {
       public string CategoryId {get;set;}  
       public string CategoryName {get;set;}  
       public List<CategoryDtlsCustomClass> lstlrngs {get;set;}  
    }
    
    global class TopicUserDtls
    {
        public string TopicUserId { get; set; }
        public string TopicUserName { get; set; }
        public string TopicUserPhotoUrl { get; set; }
    }

global class UserRatingHistory
    {
        public string UserHistoryId { get; set; }
        public string UserHistoryName { get; set; }
        public string UserHistoryPhotoUrl { get; set; }
        public decimal UserHistoryRating { get; set; }
        public string UserHistoryComment { get; set; }
        public DateTime UserHistoryDateTime { get; set; }
        public string UserDate { get; set;}
    }

    public  class CategoryDtlsCustomClass
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
        public string fileVideoUpload { get; set;}
        public string fileTextUpload {get;set;}
        public boolean PracticeApprv {get;set;}
        public string HPCertification {get;set;}
        public string HPPublish {get;set;}
        public integer StrDescLength {get;set;}
        public Decimal AvgRating {get;set;}
        public string RatersCount {get;set;}
        public boolean BtnshowHideEdit { get; set; }
        public string PreviewRequired { get; set; } 
        
    }

    public class RelatedLearningBoardCustomClass
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
     }       

    public class RelatedBoardOwner
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Title { get; set; }
        public string SmallPhotoUrl { get; set; }
    }
    
    public void InserSession()
    {
      //AthenaUtility.InsertUserSession(UserInfo.getSessionId(),UserInfo.getUserId());
    }

    // ViewCommunity Constructor
    public ViewCommunity(ApexPages.StandardController controller)
    {
    
        //AthenaUtility.InsertUserSession(UserInfo.getSessionId(),UserInfo.getUserId());
    
        CommunityId = ApexPages.currentPage().getParameters().get('id');
        BoardId=ApexPages.currentPage().getParameters().get('boardid');
        BoardName=ApexPages.currentPage().getParameters().get('boardname');
        CommunityDtls();
        CheckIsProducerOrModerator();
        //Get CommunityOwnerDetails
        OwnerDetails = getCommunityOwnerDetails();

        LBOwnerId = OwnerDetails.id;
                
        //Get Loggedinuser Details
        LoggedInUserDetails = GetLoggedinUserDetails();

        if (LoggedInUserDetails.id == LBOwnerId)
            isloggedUser = true;
         else
            isloggedUser = false;

        //Get StaticImagePath
        FetchStaticPathImage();

        //Get Board Details
        RelatedLearningBoards = new List<RelatedLearningBoardCustomClass>();
        GetRelatedLearningBoards();

        //Get Community Members
        CommunityMembers = new List<RelatedBoardOwner>(); 
        GetMembers();

        //Set "IsOwnerOrContributor" Property if Owner or Contributor
        CheckIsOwnerOrContributor();

        //Set "IsMember" Property if Member is of Community
        CheckIsMember();

        CheckIsOwnerOrContrOrMember();

        CheckIsRequested();

        CheckIsModerator();

        SLPRegistrationUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SLPRegistrationUrl);
        SSOUrl = AthenaUtility.ApplicationSettingValue(AthenaUtility.SSOUrl);
        
        system.debug('Constructor IsRequested:' + IsRequested);
    }

    public PageReference doSearch()
    {
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal', strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
    
    public void CommunityDtls()
    {
        list<Attachment> attachmentList = new List<Attachment>();  
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :CommunityId];

        Community__c community =  [SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where Id=:CommunityId];
        CommunityName = community.Name__c;
        CommunityDescription = community.description__c; 

        if(community.Name__c != null) 
        { 
            if(community.Name__c.length() > 50) 
            { 
                CommunityShortName = community.Name__c.substring(0, 50) + ' ...'; 
            } 
            else 
            { 
                CommunityShortName = community.Name__c; 
            } 
        }

        if(community.description__c != null) 
        { 
            if(community.description__c.length() > 300) 
            { 
                CommunityShortDescription = community.description__c.substring(0, 300) + ' ...'; 
                DescriptionLimit = true;
            } 
            else 
            { 
                CommunityShortDescription = community.description__c; 
                DescriptionLimit = false;
            } 
        }

        CommunityPublish = community.IsActive__c ;
        CommunityPublic = community.Public__c;
        
        if(community.Default_Image_Name__c!='')
        {                        
            CommunityDefaultImageName = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + community.Default_Image_Name__c;          
        }
        
        CommunityStaticImage = true;
        
        for(Attachment att: attachmentList)
        {
            if(CommunityId == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif'))
            {
                AttachmentId = att.Id;                
                CommunityStaticImage = false;
            }  
        }
     }

    public boolean IsReadMore
    {
        get
        {
            return DescriptionLimit;
        }
    }
     
     // Method used to fetch community owner details
    public User getCommunityOwnerDetails()
    {
        User user = [Select usr.id, usr.SmallPhotoUrl, usr.FullPhotoUrl, usr.CompanyName, usr.AboutMe, usr.Name, usr.Division, usr.Department, usr.Title,
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
   
    public String getSfInstance
    {
        get
        {
            return ApexPages.currentPage().getHeaders().get('Host');
        }
        
        set {}
    }

    private static String GetResourceURL(String resourceName)  
    {  
        //Fetching the resource 
        List<StaticResource> resourceList = new List<StaticResource>();
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
     
    //Method used to fetch Contributors
    public List<User> GetContributors()
    {
        List<User> ContributorsUsers =  [Select id, Name, SmallPhotoUrl, FullPhotoUrl, email From User where id IN (SELECT UserOrGroupId FROM Community__Share where AccessLevel = 'Edit' and ParentId=: CommunityId)];
        return  ContributorsUsers;
    }

    //Method used to fetch Related learning Board
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

                lbCustom.StaticImage = true;
                
                if(AttMap.containsKey(lbCustom.LbId))
               {
                    lbCustom.AttachmentId = AttMap.get(lbCustom.LbId);
                   lbCustom.StaticImage = false;
                }              
                RelatedLearningBoards.add(lbCustom);
            }
            

            if(RelatedLearningBoards.size() > 0)
            {
                IsBoardExist = true;
            }
            else
            {
                IsBoardExist = false;
            }

    }
    
    //Method used to fetch community members
    public Void GetMembers()
    {
        CommunityMembers = new List<RelatedBoardOwner>(); 

        List<User> FollowersUsers =  [Select id, Name,Title,SmallPhotoUrl, FullPhotoUrl,email From User where id IN (SELECT User_Id__C FROM Community_Member__c where Community_ID__c =: CommunityId and Status__c =: AthenaUtility.Approved)];

        system.debug('GetMembers:' + FollowersUsers.size());

        for(User usr:FollowersUsers)
        {
            RelatedBoardOwner ownerDetails = new RelatedBoardOwner();

            ownerDetails.Id = usr.Id;
            ownerDetails.Name = usr.Name;
            ownerDetails.SmallPhotoUrl = usr.SmallPhotoUrl;
            ownerDetails.Title = usr.Title;

            CommunityMembers.add(ownerDetails);
        }       
    }
    
    public void CheckIsOwnerOrContributor()
    {
        List<Community__Share> lstContr = [SELECT ParentId FROM Community__Share where parentId=:CommunityId and UserOrGroupId=:UserInfo.getUserId()];

        system.debug('suman lstContr:' + lstContr.size());

        if(lstContr.size() == 0)
        {
            IsOwnerOrContributor = false;
            IsUserOwnerOrContributor = false;
        }
        else
        {
            IsOwnerOrContributor = true;
            IsUserOwnerOrContributor = true;
        }                           
    }
    
    public void CheckIsMember()
    {
       //Status we need to check whether Approved or Not 
        List<Community_Member__c> lstContr = [SELECT User_Id__C FROM Community_Member__c where Community_ID__c=:CommunityId and User_Id__C=: UserInfo.getUserId() and Status__c =: AthenaUtility.Approved];
        if(lstContr.size()==0)
        {
            IsMember = false;
        }
        else
        {
            IsMember = true;
        }                           
    }

    public void JoinCommunity() 
    { 
        if(!IsMember)
        {   
            if(CommunityPublic)
            {
                List<Community_Member__c> lstCommMemb = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c=: LoggedInUserDetails.Id and Community_Id__c =: CommunityId];                      

                if (lstCommMemb.size() == 0)
                {
                    Community_Member__c commMemb = new Community_Member__c();
         
                    commMemb.Community_Id__c = CommunityId;
                    commMemb.User_Id__c = UserInfo.getUserId();
                    commMemb.Status__c = AthenaUtility.Approved;
                    
                    insert commMemb;
                }                                                                            

                EntitySubscription follow = new EntitySubscription (); 
                follow.parentId = CommunityId;
                follow.subscriberid = LoggedInUserDetails.Id;
                insert follow; 

                CheckIsMember();
                CheckIsOwnerOrContrOrMember();
                GetMembers();
                
                 AthenaUtility.AddToChatterComment(CommunityId,'Add Member','I joined as a Member');
            }
            else
            {
                List<Community_Member__c> lstCommMemb = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c=: LoggedInUserDetails.Id and Community_Id__c =: CommunityId];                      

                if (lstCommMemb.size() == 0)
                {
                    Community_Member__c commMemb = new Community_Member__c();
         
                    commMemb.Community_Id__c = CommunityId;
                    commMemb.User_Id__c = UserInfo.getUserId();
                    commMemb.Status__c = AthenaUtility.Requested;
                    
                    insert commMemb;

                    //Send Mail to Owner and CC requestor
                    Messaging.SingleEmailMessage mail;  
                    string bodyString = '';
                    string[] toAddresses;
                    mail = new Messaging.SingleEmailMessage();
                    toAddresses = new String[] { OwnerDetails.email };
                    mail.setToAddresses(toAddresses); 
                    mail.setCCAddresses( new String[]{ LoggedInUserDetails.email });    
                    mail.setUseSignature(false);      
                    mail.setSubject(LoggedInUserDetails.Name + ' requesting to add as member to the Community'+ CommunityName ); 
                                 
                    string stringURL1 = SSOUrl + 'ViewCommunity?id%3d{1}';
                    string[] subjectArguments1 = new String[] { getSfInstance, CommunityId};
                    string formatURL1 = String.format(stringURL1, subjectArguments1);
                                                                                                
                    bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                    bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>insight<br /><small>Information – on your terms</small></strong></span></span></h3>';
                    bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+OwnerDetails.Name+',&nbsp;</span></span></p>';
                    bodyString += '<p> <p><span style="font-size:16px;">Please add me as a member to the below Community.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                    bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Community Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityName +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Community Description</td><td style="';
                    bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityDescription +'</td>';
                    bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                    bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ LoggedInUserDetails.email +'</td></tr></table></p><p><span>If you are new to the insight, please click <a href='+ SLPRegistrationUrl +'>here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Community. </span></p>';
                    bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+LoggedInUserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                    bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                    bodyString += '</body></html>';

                    mail.setHtmlBody(bodyString);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                }                                                                            
           }   

                CheckIsMember();
                CheckIsOwnerOrContrOrMember();
                GetMembers();
                CheckIsRequested();         
                
                system.debug('Join Community IsRequested:' + IsRequested);
        }
    }

    public void LeaveCommunity() 
    { 
        if(IsMember)
        {
            //Delete from new Object
            List<Community_Member__c> lstcommMemb = [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c=:UserInfo.getUserId() and Community_Id__c =: CommunityId ];                                 

            system.debug('LeaveCommunity Community_Member__c:' + lstcommMemb.size());

            if (lstcommMemb.size() != 0)
            {
                delete lstcommMemb[0];
            }
            
            List<EntitySubscription> lstSubscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : CommunityId AND SubscriberId = : LoggedInUserDetails.Id ]; 

            system.debug('LeaveCommunity EntitySubscription:' + lstSubscription.size());

            if (lstSubscription.size() != 0)
            {
                Delete lstSubscription[0];
            }

            CheckIsMember();
            CheckIsOwnerOrContrOrMember();
            GetMembers();
        }
    }

    public void InviteToCommunity()
    {
        Community__c community = [SELECT Id, Name__c, Description__c, Public__c, IsActive__c FROM Community__c where Id =: CommunityId limit 1];

        User usr=[Select Name,email from User where id =:UserInfo.getUserId()];

        //string HeaderShareEmail = 'suman.sathyanandam@hp.com';

        List<User> Shareusr=[Select Name,email from User where email =:InviteUserEmail Limit 1];
        boolean isOwnerNotificationReq=false;
        //boolean isOwnerNotificationReq = AthenaUtility.NotifyMyStatus(AthenaUtility.ShareBoardEvent, OwnerDetails.id);
  
        string ShareUserName='';
        if(Shareusr.size() == 0)
        {
            ShareUserName='';
        }
        else
        {
            ShareUserName=Shareusr[0].Name;
        }

        Messaging.SingleEmailMessage mail;  
        string bodyString = '';
        string[] toAddresses;
        mail = new Messaging.SingleEmailMessage();
        toAddresses = new String[] { InviteUserEmail };
        mail.setToAddresses(toAddresses); 
        mail.setUseSignature(false);      
        mail.setSubject(LoggedInUserDetails.Name + ' thought you might be interested be in the '+ CommunityName + ' Community.'); 
        
        if (isOwnerNotificationReq)
        {
            mail.setCCAddresses( new String[]{ OwnerDetails.email });    
        }
        
        string stringURL1 = SSOUrl +'ViewCommunity?id%3d{1}';
        string[] subjectArguments1 = new String[] { getSfInstance, CommunityId};
        string formatURL1 = String.format(stringURL1, subjectArguments1);
        
        bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
        bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>insight<br /><small>Information – on your terms</small></strong></span></span></h3>';
        bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+ShareUserName+',&nbsp;</span></span></p>';
        bodyString += '<p> <p><span style="font-size:16px;">I found an interesting Community on ES insight. You should take a look.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Community Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityName +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Community Description</td><td style="';
        bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ CommunityDescription +'</td>';
        bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Community Owner</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ OwnerDetails.name +'</td></tr></table></p><p><span>If you are new to the insight, please click <a href='+ SLPRegistrationUrl +'>here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Community. </span></p>';
        bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+LoggedInUserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
        bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        bodyString += '</body></html>';

        mail.setHtmlBody(bodyString);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    }
    
    
    public Void CheckIsOwnerOrContrOrMember() 
    { 
        if(IsMember || IsOwnerOrContributor) 
        { 
            IsOwnerOrContrOrMember=true; 
        } 
        else 
        { 
            IsOwnerOrContrOrMember=false; 
        } 
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

    public void followOwner() 
    { 
        if(!IsFollowOwner)
        {
            EntitySubscription follow = new EntitySubscription (); 
            follow.parentId = LBOwnerId;
            follow.subscriberid = LoggedInUserDetails.id;
            insert follow; 

            FeedItem post = new FeedItem(); 
            post.ParentId = LBOwnerId; 
            string tag ='Follower'; 
            string comment = LoggedInUserDetails.Name +' is now following ' + OwnerDetails.Name; 
            post.Body = '#[' + tag + ']' + ' ' + comment; 

            insert post;
        }            
    } 
        
    public void unfollowOwner() 
    { 
        EntitySubscription subscription = [ SELECT ID FROM EntitySubscription WHERE ParentId = : LBOwnerId AND SubscriberId = : LoggedInUserDetails.id Limit 1]; 
        Delete subscription; 
    }
    
    public boolean IsFollowOwner
    {
        get 
        {
            List<EntitySubscription> entsub=[select SubscriberID from EntitySubscription where ParentId =:LBOwnerId and SubscriberID =: LoggedInUserDetails.id];         

            if(entsub.size() >0 ) 
                return true;
            else
                return false;
        }
    }
    
    //Remote method to fetch Community category for collateral tab.
    @RemoteAction
    global static List<CommunityDtlsWithCategory> getCommunityWithCat(string CommId)
    {
        List<Community_Category__c> CommunityCatlst = [select Name__c, Id from Community_Category__c  where Community_ID__c =: CommId];

        List<CommunityDtlsWithCategory> lsWithCat = new List<CommunityDtlsWithCategory>();

        for(Community_Category__c lcc :CommunityCatlst)
        {
            CommunityDtlsWithCategory dtlsWithCat = new CommunityDtlsWithCategory();
            dtlsWithCat.CategoryId = lcc.id;
            dtlsWithCat.CategoryName = lcc.Name__c;
            lsWithCat.add(dtlsWithCat);
        }

        List<CommunityDtlsWithCategory> lstLearningBrdCat = GenerateCommunityCtgry(lsWithCat,CommId);
        system.debug('lstLearningBrdCat:' + lstLearningBrdCat.size());

        return lstLearningBrdCat;
    }

    public static List<CommunityDtlsWithCategory> GenerateCommunityCtgry(List<CommunityDtlsWithCategory> communityDetails, string CommunityID)
    {
        // string FileURLUpload= 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileURLUpload.png';
        // string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
        // string  filePDFUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePDFUpload.png';
        // string filePPTUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/filePPTUpload.png';
        // string fileWordUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileWordUpload.png';
        // string fileExcelUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileExcelUpload.png';
        // string fileTextUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileTextUpload.png';
        // string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
        // string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';
        // string fileVideoUpload='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileVideo.png';
        
        string FileURLUpload= 'icon-link testIcon1 pull-right';
        string  hpsharedIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpsharedIcon.png';
        string  filePDFUpload='icon-dload-pdf testIcon1 pull-right';
        string filePPTUpload='icon-dload-powerpoint testIcon1 pull-right';
        string fileWordUpload='icon-dload-word testIcon1 pull-right';
        string fileExcelUpload = 'icon-dload-excel testIcon1 pull-right';
        string fileTextUpload = 'icon-dload-text testIcon1 pull-right';
        string HPCertification='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpCertificateIcon.png';
        string HPPublishIcon='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/hpPublishIcon.png';
        string fileVideoUpload='icon-video-camera testIcon1 pull-right';
    
        string previewRequiredVal = AthenaUtility.ApplicationSettingValue(AthenaUtility.PreviewRequired);
        
        List<CommunityDtlsWithCategory> lstContainer = new List<CommunityDtlsWithCategory>();

        List<Collateral__c> lstTopicCategory = [SELECT Id, Name__c, ownerid, Description__c, URL__c, Type__c, IsActive__c, Client_Facing__c, Practice_Approved__c, Community_Category_ID__c FROM Collateral__c  order by Display_Sequence_Nbr__c asc];
        list<id> lstLearningIds = new list<id>();
        list<id> lstCommCatIds = new list<id>();
        
        for (Collateral__c l:lstTopicCategory ) 
        {
            lstLearningIds.add(l.Id);
            lstCommCatIds.add(l.Community_Category_ID__c);
        }


 List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id,Nbr_of_Users_Rated__c  FROM Rated_Item__c where Item_Identifier__c in :lstLearningIds];
        map<id,string> RatedItemMap = new map<id,string>();        

        for (Rated_Item__c rtdItm :RatedItemLst) {
                        string AvgRatingAndCnt;
                        AvgRatingAndCnt=rtdItm.Rating_Average__c + ',' + rtdItm.Nbr_of_Users_Rated__c;
                        RatedItemMap.put(rtdItm.Item_identifier__C,AvgRatingAndCnt);  
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

        List<Community__Share> lstContr = [SELECT ParentId FROM Community__Share where parentId=:CommunityId and UserOrGroupId=:UserInfo.getUserId()];

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

                //if(learningB.Description__c != null)
                //{
                //    system.debug('learningB.Description__c.length:' + learningB.Description__c.length());

                //    if(learningB.Description__c.length() > 300)
                //    {
                //        lrng.LDescription = learningB.Description__c.substring(0, 300) + '...';
                //    }
                //    else
                //    {
                //        lrng.LDescription = learningB.Description__c;
                //    }
                //}

                lrng.LType= learningB.Type__c;   
                lrng.LURL= learningB.URL__C; 
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
                lrng.fileVideoUpload = fileVideoUpload;
                lrng.fileTextUpload = fileTextUpload;
                //lrng.PreviewRequired = previewRequiredVal;
                lrng.PreviewRequired = 'NO';

                if(RatedItemMap.containskey(learningB.Id))
                {
                    string ratingAvgCount=RatedItemMap.get(learningB.Id);
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

           
            if(MapUserDetails.containskey(learningB.OwnerId))
            {
                TopicUserDtls topicUserDetails=new TopicUserDtls();
                topicUserDetails=MapUserDetails.get(learningB.OwnerId);
                lrng.TopicOwnerId=topicUserDetails.TopicUserId;
                lrng.LOwnerName=topicUserDetails.TopicUserName;
                lrng.OwnerPhoto=topicUserDetails.TopicUserPhotoUrl;
            }

            //if (lrng.TopicOwnerId == UserInfo.getUserId() || IsUserOwnerOrContributor == true)
            //{
            //    lrng.BtnshowHideEdit = true;
            //}
            //else if (lrng.TopicOwnerId != UserInfo.getUserId() && IsUserOwnerOrContributor == false)
            //{
            //    lrng.BtnshowHideEdit = false;
            //}
            //lrng.BtnshowHideEdit = true;

            //testing - suman 


            if (lrng.TopicOwnerId == UserInfo.getUserId())
            {
                lrng.BtnshowHideEdit = true;
            }
            else
            {
                lrng.BtnshowHideEdit = false;
            }


            //if (lstContr.size() > 0 )
            //{
            //    lrng.BtnshowHideEdit = true;
            //}
            //else
            //{
            //    lrng.BtnshowHideEdit = false;
            //}


            if(lrng.LURL!=null)
            {
                if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v='))
                {
                    lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                    lrng.LURL=lrng.LURL.replace('http:', 'https:');
                }
                else if(lrng.LType=='Video' && lrng.LURL.contains('www.brainshark.com'))
                {
                    lrng.LURL=lrng.LURL+'&dm=5&pause=1&nrs=1';
                }
            }
            if( lrng.LURL!=null)
            {   
            //lrng.DocLnkXst=true;
            if(lrng.LURL.toLowerCase().contains('.pdf'))
            {
                lrng.DocType='PDF';
            }
            else if(lrng.LURL.toLowerCase().contains('.ppt'))
            {
                lrng.DocType='PPT';
            }                    
            else if(lrng.LURL.toLowerCase().contains('.doc'))
            {
                lrng.DocType='DOC';
            }
            else if(lrng.LURL.toLowerCase().contains('.xls'))
            {
                lrng.DocType='XLS';
            }
            else if(lrng.LURL.toLowerCase().contains('.txt'))
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
            if(lrng.LDescription.length() > 900)
            {
                lrng.StrDescLength=1;
                lrng.LShortDescription = lrng.LDescription.substring(0, 900) + ' ...';
            }
            else
            {
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
    
    public void CheckIsRequested()
    {
       //Status we need to check whether Approved or Not 
        List<Community_Member__c> lstContr = [SELECT User_Id__C FROM Community_Member__c where Community_ID__c=:CommunityId and User_Id__C=: UserInfo.getUserId() and Status__c =: AthenaUtility.Requested];

        if(lstContr.size() == 0)
        {
            IsRequested = false;
        }
        else
        {
            IsRequested = true;
        }                           
    }

    public void CheckIsModerator()
    {
        AthenaUserAccess UsrAcc = new AthenaUserAccess();

        if(UsrAcc.IsModerator(UserInfo.getUserId()))
        {
            IsModeratorAccess = true;
        }
        else
        {
            IsModeratorAccess = false;
        }                          

    }


    public void SaveTopicUserRating()
    {
        

        string loggedInUserId = UserInfo.getUserId();
        string comment = '';

        if(userTopicRatingComment == null)
            comment = '';
        else
            comment = userTopicRatingComment;

system.debug('CommunityId:'+CommunityId);
system.debug('SaveTopicUserRating:'+ CommunityTopicID);
        system.debug('userTopicRatingComment:'+ userTopicRatingComment);
system.debug('loggedInUserId:'+ loggedInUserId);

        string ratingAvgCount = AthenaUtility.RateObject(AthenaUtility.Collateral, CommunityTopicID, UserTopicRating, loggedInUserId, comment ,this.CommunityId );
        PersistTab='Collateral';
        
        //if(ratingAvgCount != '')
        //{
        //    Collateral__c learningObj = [SELECT Id, Name__c,owner.email, ownerid, Description__c, URL__c, Type__c, IsActive__c, Client_Facing__c, Practice_Approved__c, Community_Category_ID__c FROM Collateral__c  where id =: CommunityTopicID limit 1];


        //    boolean isNotificationRequired = AthenaUtility.NotifyMyStatus(AthenaUtility.RateTopicEvent, learningObj.ownerid);

        //    system.debug('SaveUserRating isNotificationRequired:' + isNotificationRequired);

        //    string ratingNumber = '';

        //    if(UserTopicRating == 1)
        //        ratingNumber = '* (1 Star)';
        //    else if(UserTopicRating == 2)
        //        ratingNumber = '** (2 Stars)';
        //    else if(UserTopicRating == 3)
        //        ratingNumber = '*** (3 Stars)';
        //    else if(UserTopicRating == 4)
        //        ratingNumber = '**** (4 Stars)';
        //    else if(UserTopicRating == 5)
        //        ratingNumber = '***** (5 Stars)';

        //    if (isNotificationRequired)
        //    {
        //        Messaging.SingleEmailMessage mail;  
        //        string bodyString = '';
        //        string[] toAddresses;
        //        mail = new Messaging.SingleEmailMessage();

        //        toAddresses = new String[] { learningObj.owner.email };
        //        mail.setToAddresses(toAddresses);       
        //        mail.setSubject(LoggedInUserDetails.Name + ' Topic Rating Notification For '+ learningObj.Name__c + ' topic.'); 
        //        mail.setUseSignature(false);
        //        string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}&topicid={2}';
        //        string[] subjectArguments1 = new String[] { getSfInstance, CommunityId, CommunityTopicID};
        //        string formatURL1 = String.format(stringURL1, subjectArguments1);
        
        //        bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
        //        bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
        //        bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+learningObj.Owner.name+',&nbsp;</span></span></p>';
        //        bodyString += '<p> <p><span style="font-size:16px;">Please find the rating details for your Topic.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
        //        bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Rating</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ ratingNumber +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Comment</td><td style="';
        //        bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ comment +'</td>';
        //        bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Rated By</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
        //        bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ LoggedInUserDetails.Name +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href='+ SLPRegistrationUrl +'>here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the learning board. </span></p>';
        //        bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+LoggedInUserDetails.Name+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
        //        bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        //        bodyString += '</body></html>';

        //        mail.setHtmlBody(bodyString);
        //        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        //    }
        //}
    }

    @RemoteAction
    global static List<UserRatingHistory> GetTopicRatingHistory(string BoardTopicId)
    {
        system.debug('GetTopicRatingHistory:'+ BoardTopicId);

        List<UserRatingHistory> lstRatingHistory1 = new List<UserRatingHistory>();
        //and Item_Name__c= 'Learning'
        List<User_Rated_Item__c> userRatedItems = [SELECT id, User_Id__r.Name, User_Id__r.smallphotourl, Rated_Item_Id__c, Rating_Nbr__c, comment__C, LastModifiedDate FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=: BoardTopicId ) order by LastModifiedDate desc];

        for(User_Rated_Item__c rItem: userRatedItems)
        {
            UserRatingHistory userRatingHistory = new UserRatingHistory();

            userRatingHistory.UserHistoryId = rItem.id;
            userRatingHistory.UserHistoryName = rItem.User_Id__r.Name;
            userRatingHistory.UserHistoryPhotoUrl = rItem.User_Id__r.smallphotourl;
            userRatingHistory.UserHistoryRating = rItem.Rating_Nbr__c;
            userRatingHistory.UserHistoryComment = rItem.comment__C;
            userRatingHistory.UserHistoryDateTime = rItem.LastModifiedDate;
            userRatingHistory.UserDate = rItem.LastModifiedDate.format('dd-MMM-yyyy hh:mm');

            lstRatingHistory1.add(userRatingHistory);
        }
        return  lstRatingHistory1;
    }

public string ContributorMember{
   get
   {
       lstContributorMember=GetCommunityContributorAndMember();
     system.debug('lstsize:'+lstContributorMember.size());
     system.debug('lst:'+lstContributorMember);
     
     string jsonString=JSON.serialize(lstContributorMember);
      return jsonString;
   }
   set;
   }
  public List<CustomContributorAndMember> GetCommunityContributorAndMember()
  {
    List<CustomContributorAndMember> lstContributorMem=new List<CustomContributorAndMember>();
    List<Community__Share > lstCommunityShare= [SELECT UserOrGroupId FROM Community__Share where ParentId=:CommunityId and AccessLevel='Edit' ];

    system.debug('s:'+lstCommunityShare.size());
    List<Community_Member__c> lstCommMember= [SELECT  User_Id__c FROM Community_Member__c where Community_Id__c=:CommunityId and Status__c ='Approved'];
    system.debug('c:'+lstCommMember.size());
    system.debug('d:'+lstCommMember);

    Map<Id,boolean> MapUser=new Map<Id,boolean>();
    set<Id> setUserIds=new set<Id>();

    for(Community__Share CommContrib: lstCommunityShare)
    {
      MapUser.put(CommContrib.UserOrGroupId,true);
      setUserIds.add(CommContrib.UserOrGroupId);
    }

    for(Community_Member__c CommMem: lstCommMember)
    {
    if(!(MapUser.containsKey(CommMem.User_Id__c)))
    {
     MapUser.put(CommMem.User_Id__c,false);
     setUserIds.add(CommMem.User_Id__c);
     }
    }


    list<ES_User__c> lstEsuser= [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c,Region_Id__r.Region_Name__c,Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in :setUserIds ];
     Map<Id,string> MapExpertUserRole=new Map<Id,string>();
     Map<Id,string> MapBusinessGrp=new Map<Id,string>();
     Map<Id,string> MapRegion=new Map<Id,string>();
    for(ES_User__c esUser:lstEsuser )
    {
         string RoleName=esUser.Role_ID__r.Role_Name__c;
         string RegionName=esUser.Region_Id__r.Region_Name__c;
         string BsnGrp=esUser.Business_Group_Id__r.Business_Group_Name__c;
         MapExpertUserRole.put(esUser.User_Id__c,RoleName);
         MapBusinessGrp.put(esUser.User_Id__c,BsnGrp);
         MapRegion.put(esUser.User_Id__c,RegionName);
    }
    
    set<Id> SetExperts=new set<Id>();

    List<SLP_Expert__c> lstExperts= [SELECT Id,Is_Expert__c,ES_User_ID__r.User_ID__c FROM SLP_Expert__c where ES_User_ID__r.User_ID__c in:setUserIds and Is_Expert__c=true];

    for(SLP_Expert__c slp:lstExperts)
    {
     SetExperts.add(slp.ES_User_ID__r.User_ID__c);  
    }
    
    List<User> ListUsers = [Select id, Name,Title,SmallPhotoUrl, FullPhotoUrl From User where IsActive = true and id IN : setUserIds order by FirstName];
    
    for(User usr:ListUsers )
    {
        CustomContributorAndMember contributorMem=new CustomContributorAndMember();
        contributorMem.UserId=usr.id;
        /*    
        if(usr.Name!='' &&(usr.Name!=null))
        {
            string strNm = usr.Name;
           contributorMem.UserName = strNm.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
        }
        */
        contributorMem.UserName = (usr.Name).replace('\'','').replace('\"','');

        contributorMem.Userphoto=usr.SmallPhotoUrl;
        
        if(MapUser.containsKey(usr.id))
        {
         contributorMem.IsContributor=MapUser.get(usr.id);
     
        }
        if(SetExperts.contains(usr.id))
        {
        contributorMem.IsExperts=true;
        }
        if(MapExpertUserRole.containsKey(usr.id))
        {
           //contributorMem.RoleName = MapExpertUserRole.get(usr.id);

            string strName = MapExpertUserRole.get(usr.id);
            if(strName != null && strName != '')
            {
               contributorMem.RoleName = (strName).replace('\'','').replace('\"','');
            }
        }
        if(MapRegion.containsKey(usr.id))
        {
            //contributorMem.Region=MapRegion.get(usr.id);

            string strName = MapRegion.get(usr.id);
            if(strName != null && strName != '')
            {
               contributorMem.Region = (strName).replace('\'','').replace('\"','');
            }
        }
        if(MapBusinessGrp.containsKey(usr.id))
        {
            //contributorMem.BusinessGroup=MapBusinessGrp.get(usr.id);

            string strName = MapBusinessGrp.get(usr.id);
            if(strName != null && strName != '')
            {
               contributorMem.BusinessGroup = (strName).replace('\'','').replace('\"','');
            }  
        }
        
        lstContributorMem.add(contributorMem);
    }
    
    return lstContributorMem;
    
    }   
    
    @RemoteAction
    public static List<User> GetNetworkUsersList(string CommunityId)
    {
        string UserID = UserInfo.getUserId();
        set<Id> UserIds = new set<Id>();

        List<EntitySubscription> lstFollowers = [SELECT SubscriberId FROM EntitySubscription WHERE ParentId =: UserID];

        for(EntitySubscription user : lstFollowers)
        {
            UserIds.add(user.SubscriberId);
        }

        List<EntitySubscription>  lstFollowing = [SELECT ParentId FROM EntitySubscription WHERE SubscriberId =: UserID];

        for(EntitySubscription user : lstFollowing)
        {
            UserIds.add(user.ParentId);
        }

        //User commuityOwner = [Select usr.id From User usr where usr.id in (select ownerid from Community__c where id = : CommunityId)];

        //List<Community_Member__c> memberUserId = [SELECT User_Id__C FROM Community_Member__c where Community_ID__c =: CommunityId and User_Id__C =: UserInfo.getUserId() and Status__c =: AthenaUtility.Approved];

        //List<Community__Share> contributorUserId = [SELECT ParentId FROM Community__Share where parentId=:CommunityId and UserOrGroupId =: UserInfo.getUserId()];
        
        //for(Community_Member__c member : memberUserId)
        //{
        //    UserIds.add(member.User_Id__C);
        //}

        //for(Community__Share share : contributorUserId)
        //{
        //    UserIds.add(share.ParentId);
        //}
        
        //UserIds.add(commuityOwner.id);

        List<user> listOfFollowers = [SELECT Id, Name,Email, SmallPhotoUrl FROM User WHERE Id IN : UserIds order by Name];

        return listOfFollowers;
    }

    public void SaveNetworkUsers()
    {
        List<FeedItem> lstFI=new List<FeedItem>();
        string contentDescription = '';
        String[] splitInput = SelectedUsrs.split(',');
        List<String> UsrIds = new List<String>(splitInput);
        Map<string, boolean> MapOwnerorContrDetails =new Map<string, boolean>();
        Map<string, boolean> MapMemberDetails =new Map<string, boolean>();

        List<User> lstUsers = [Select id, Name From User  where id in : UsrIds];

        //Community__c community =  [SELECT Name__c, Id, Description__c, Public__c, IsActive__c, Default_Image_Name__c FROM Community__c where Id=:CommunityId];
        //string CommunityName = community.Name__c;
        //boolean IsPublic = community.Public__c;

        //IsOwner or Contributor
        List<Community__Share> lstCommunityShare = [SELECT UserOrGroupId FROM Community__Share where parentId=:CommunityId];

        //IsMember
        List<Community_Member__c> lstCommunityMember = [SELECT User_Id__C FROM Community_Member__c where Community_ID__c=:CommunityId and Status__c =: AthenaUtility.Approved];

        Collateral__c learningObj = [SELECT Id, Name__c, Description__c FROM Collateral__c  where id =: ShareTopicId limit 1];
    
        if(learningObj != null)
        {
            if(learningObj.Description__c.length() > 500)
            {
                contentDescription = learningObj.Description__c.subString(0, 500)+ ' ...';
            }
            else
            {
                contentDescription = learningObj.Description__c;
            }
        }
        
        for(Community__Share shareItem : lstCommunityShare)
        {
            MapOwnerorContrDetails.put(shareItem.UserOrGroupId, true);
        }

        for(Community_Member__c memberItem : lstCommunityMember)
        {
            MapOwnerorContrDetails.put(memberItem.User_Id__C, true);
        }

        for(User usr : lstUsers)
        {
             string BodyContent ='';   
    
             if(hdnSharecmt !='' && hdnSharecmt !=null)
             {
                BodyContent = UserInfo.getName() +' has shared with ' + usr.Name + ' ' + '<br />' + ' Comment:- ' + hdnSharecmt;
             }
             else
             {
                BodyContent = UserInfo.getName()+' has shared with '+ usr.Name + ' ' ;
             }
   
             BodyContent += '<br />' + contentDescription;
             
            if((!MapOwnerorContrDetails.containskey(usr.id)))
            {
                BodyContent += '<br />' + 'Note:- Please join to view '+ learningObj.Name__c;
            }
            
             BodyContent = BodyContent.replaceAll('<br />','\n');
            
            FeedItem FeedItm = new FeedItem();
       
            FeedItm.LinkUrl = 'https://' + URL.getSalesforceBaseUrl().getHost()+'/apex/ViewCommunity?id='+ CommunityId +'&topicId='+ ShareTopicId;
            FeedItm.Title = learningObj.Name__c;
                
            FeedItm.ParentId = usr.id;
            FeedItm.Body = BodyContent;
                    
            lstFI.add(FeedItm);
        }
        insert lstFI;
        
        PersistTab = 'Collateral';
    }
}