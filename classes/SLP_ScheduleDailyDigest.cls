// Dialy Diggest Schedule
global class SLP_ScheduleDailyDigest implements Schedulable {
    public boolean IsDigestMsg {get;set;}
    public boolean IsbtnDigest {get;set;}
        public static  string Environment {get;set;}
    
    // Pre-defined execute  of schedulable
   global void execute(SchedulableContext SC) {
    GenerateDailyDiggest();
   }

    // Getting  Application setting value 
     public static string ApplicationSettingValue(string Name)
    {
        string AppValue='';
        List<Application_Setting__c> appSetnglst=[SELECT Name__c,Value__c FROM Application_Setting__c where Name__c=:Name and Is_Active__c=True];
        for(Application_Setting__c appSetng:appSetnglst)
        {
            AppValue=appSetng.Value__c;
        }         
        return AppValue;
    }
    
    // Feed Comment Wrapper class
    public class ClsFeedComment
    {
        //public string ParentId {get;set;}
        public string FeedItemId {get;set;}
        public Id CommentId {get;set;}
        public string CommentName {get;set;}
        public string Comment {get;set;}
        
        public string  CommentedUserId {get;set;}
        public string CommentedUserName {get;set;}
        public Datetime CommentedDate {get;set;}
         public integer  CommentedLikes {get;set;}
        public string CmtUsrPhoto {get;set;}
        public string CmtUserNm {get;set;}
        public string CommentBody {get;set;}
        public string CommentType {get;set;}
        public string LinkUrl {get;set;}
        public boolean IsLink {get;set;}
    }

    // Feed Post Wrapper Class 
    public class ClsFeedPost
    {
        //public string ParentId {get;set;}
        //public string ParentName {get;set;}
        public string PostId {get;set;}
        public string PostName {get;set;}
        public string PostedUserId {get;set;}
        public string PostedUserName {get;set;}
        public string PostedDate {get;set;}
        public integer  PostLikes {get;set;}
        public string Title {get;set;}
        public string LinkUrl {get;set;}
        public boolean IsLink {get;set;}
        public string Type {get;set;}
        //public list<clsfeedcomment> lstFeedCmt {get;set;}
        public List<FeedComment> lstFCmt {get;set;}
        public List<ClsFeedComment> lstPostComment {get;set;}
    }
    
    // Feed Post based on Community or board Wrapper
    public class ClsCommAndBoard
    {
      public string BoardOrCommId {get;set;}
      public string BoardOrCommNm {get;set;}
      public boolean IsCommunity {get;set;}
      public list<ClsFeedPost> ListFeedPost {get;set;}
    }

    // User and Feed post wrapper class
    public class MainData
    {
      public Id UserId {get;set;}
      public string UserName {get;set;}
     public List<ClsCommAndBoard> lstCommB {get;set;}
    }
     
    // Daily diggest function
    public static void getDailyDiggest()
    {
        Map<Id,string> lstDailyDiggest=new Map<Id,string>();
        //Getting HostName from Application setting 
        string hostName = ApplicationSettingValue('HostName');
        //Getting FileDownLoad from Application setting 
     string SSORedirect=ApplicationSettingValue('FileDownLoad');
          //Getting SSOUrl from Application setting 
    string SSORedirectUrl=ApplicationSettingValue('SSOUrl');
    string strAttachment='View File';
    DateTime d;
    string createdDate='';
    String fullFileURL = '';
    // Filter('TextPost','LinkPost','ContentPost') and LastModifiedDate the FeedItem 
    List<FeedItem> lstFeedItem= [SELECT Id, LinkUrl,RelatedRecordId,Type, ParentId, CreatedById, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost','ContentPost')  and LastModifiedDate>=N_DAYS_AGO:4  order by LastModifiedDate desc];
        //Filter CreatedDate from FeedComment
    List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where CreatedDate>=N_DAYS_AGO:4 order by CreatedDate];
    
    // list<FeedItem> lstFeedItem= [SELECT Id, LinkUrl,RelatedRecordId,Type, ParentId, CreatedById, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem where Type in ('TextPost','LinkPost','ContentPost') and LastModifiedDate=Yesterday   order by LastModifiedDate desc];
     //List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment where CreatedDate=Yesterday order by CreatedDate];
   
        //Set ParentIds
    set<ID> setParentIds=new set<ID>();
        //Set CreatedUserIds
    set<ID> setCreateIds=new set<ID>();
        //Map for Id,FeedItem
    Map<ID,List<FeedItem>> MapFeedItm=new Map<ID,List<FeedItem>>();
    //Map<ID,List<FeedComment>> MapFeedCmt=new Map<ID,List<FeedComment>>();

        // Iterate List FeedItem and set the ParentIds and CreatedBy,then Holding ParentId(Board Or Community) and List of FeedItem
    for(FeedItem FeedItm:lstFeedItem)
    {
        setParentIds.add(FeedItm.ParentId);
        setCreateIds.add(FeedItm.CreatedById);

        if(MapFeedItm.ContainsKey(FeedItm.ParentId))
        {
            List<FeedItem> lstFIs=MapFeedItm.get(FeedItm.ParentId);
            lstFIs.add(FeedItm);
            MapFeedItm.put(FeedItm.ParentId,lstFIs);
        }
        else
        {
            List<FeedItem> lstFI=new List<FeedItem>();
            lstFI.add(FeedItm);
            MapFeedItm.put(FeedItm.ParentId,lstFI);
        }        
      }
      lstFeedItem.clear();
      List<ClsFeedComment> lstFeedCmt=new List<ClsFeedComment>();
      ClsFeedComment CPC=null;

      for(FeedComment FeedCmt:lstFeedComment)
      {
            //setParentIds.add(FeedCmt.ParentId);
            CPC=new ClsFeedComment();
            setCreateIds.add(FeedCmt.CreatedById);
            CPC.FeedItemId=FeedCmt.FeedItemId;
            CPC.CommentId=FeedCmt.Id;
            CPC.CommentName=FeedCmt.CommentBody;
            CPC.CommentedUserId=FeedCmt.CreatedById;
            CPC.CommentedDate=FeedCmt.CreatedDate;
            //CPC.CommentedLikes=FeedCmt.Id;
            //CPC.CmtUsrPhoto=MapUsr.get(FeedCmt.CreatedById);
            CPc.CmtUserNm=FeedCmt.CreatedBy.name;  
            CPc.CommentType=FeedCmt.CommentType;
            if(CPc.CommentType=='ContentComment')
            {
                CPc.IsLink=true;
                CPc.LinkUrl=fullFileURL+FeedCmt.RelatedRecordId;
            }
            else
            {
                CPc.IsLink=false;
            }
            CPc.CommentBody=FeedCmt.CommentBody;
         
            lstFeedCmt.add(CPC);
                        
        }
        lstFeedComment.clear();
        
        Map<ID,List<ClsFeedComment>> MapCustomFeedCmt=new Map<ID,List<ClsFeedComment>>();
        for(ClsFeedComment CPComm: lstFeedCmt)
        {
            if(MapCustomFeedCmt.containsKey(CPComm.FeedItemId))
            {
                List<ClsFeedComment> lstCPost=new List<ClsFeedComment>();
                lstCPost=MapCustomFeedCmt.get(CPComm.FeedItemId);
                lstCPost.add(CPComm);
                MapCustomFeedCmt.put(CPComm.FeedItemId,lstCPost);

            }
            else
            {
            List<ClsFeedComment> lstCPost=new List<ClsFeedComment>();
            lstCPost.add(CPComm);
            MapCustomFeedCmt.put(CPComm.FeedItemId,lstCPost);
            }
        }
        
        Map<Id,string> MapCommNm=new Map<Id,string>();
        Map<Id,string> MapBoardNm=new Map<Id,string>();
            // SOQL Community filter by ParentId
        List<Community__c> lstComm=[select Id,Name__c From Community__c where Id in: setParentIds];        
        for(Community__c commc: lstComm)
        {
          MapCommNm.put(commc.Id,commc.Name__c);
        }
        lstComm.clear();
        
        // SOQL Board filter by ParentId
        List<Learning_Board__c> lstLB= [SELECT Id, Name__c FROM Learning_Board__c where Id in: setParentIds];
        for(Learning_Board__c LBC: lstLB)
        {
          MapBoardNm.put(LBC.Id,LBC.Name__c);
        }
        lstLB.Clear();
        
        //SOQL Contributors and Members from Board and Community
        List<Community__Share> lstCommunityShare=  [SELECT Id, ParentId, UserOrGroupId FROM Community__Share where ParentId in:setParentIds];
        list<Community_Member__c> lstCommunityMem =[SELECT Id, Community_Id__c, User_Id__c FROM Community_Member__c where Community_Id__c in: setParentIds and Status__c='Approved'];
        List<Learning_Board__Share> lstLearningShare =[SELECT Id, ParentId, UserOrGroupId FROM Learning_Board__Share where ParentId in: setParentIds];
        List<Learning_Board_Member__c> lstBoardMem=[SELECT Id, Learning_Board_ID__c, User_Id__c FROM Learning_Board_Member__c where Learning_Board_ID__c in:setParentIds and Status__c='Approved' ];
        
        // Keeping into Map contributors and members of Community and Board 
        Map<Id,List<Id>> MapUserCB=new Map<Id,List<Id>>();  
        set<Id> setUsersId=new set<Id>();
        for(Community__Share CShare:lstCommunityShare)
            {
                setCreateIds.add(CShare.UserOrGroupId);
                setUsersId.add(CShare.UserOrGroupId);
                if(MapUserCB.containsKey(CShare.UserOrGroupId))
                {
                    List<Id> listIDs= MapUserCB.get(CShare.UserOrGroupId);
                    listIDs.add(CShare.ParentId);
                    MapUserCB.put(CShare.UserOrGroupId,listIDs);
                }
                else
                {
                    List<Id> lstId=new  List<Id>();
                    lstId.add(CShare.ParentId);
                    MapUserCB.put(CShare.UserOrGroupId,lstId);
                }
            }
        lstCommunityShare.clear();
        
        for(Community_Member__c CMember:lstCommunityMem)
        {
            setCreateIds.add(CMember.User_Id__c);
            setUsersId.add(CMember.User_Id__c);
             if(MapUserCB.containsKey(CMember.User_Id__c))
             {
                List<Id> listIDs= MapUserCB.get(CMember.User_Id__c);
                listIDs.add(CMember.Community_Id__c);
                MapUserCB.put(CMember.User_Id__c,listIDs);
             }
             else
             {
                List<Id> lstId=new  List<Id>();
                lstId.add(CMember.Community_Id__c);
                MapUserCB.put(CMember.User_Id__c,lstId);
             }
         
        }
        lstCommunityMem.clear();
        
        for(Learning_Board__Share CShare:lstLearningShare)
        {
            setCreateIds.add(CShare.UserOrGroupId);
            setUsersId.add(CShare.UserOrGroupId);
             if(MapUserCB.containsKey(CShare.UserOrGroupId))
             {
                List<Id> listIDs= MapUserCB.get(CShare.UserOrGroupId);
                listIDs.add(CShare.ParentId);
                MapUserCB.put(CShare.UserOrGroupId,listIDs);
             }
             else
             {
                List<Id> lstId=new  List<Id>();
                lstId.add(CShare.ParentId);
                MapUserCB.put(CShare.UserOrGroupId,lstId);
             }
        }
        lstLearningShare.clear();
        
        for(Learning_Board_Member__c CMember:lstBoardMem)
        {
            setCreateIds.add(CMember.User_Id__c);
            setUsersId.add(CMember.User_Id__c);
            if(MapUserCB.containsKey(CMember.User_Id__c))
            {
                List<Id> listIDs= MapUserCB.get(CMember.User_Id__c);
                listIDs.add(CMember.Learning_Board_ID__c);
                MapUserCB.put(CMember.User_Id__c,listIDs);
            }
            else
            {
                List<Id> lstId=new  List<Id>();
                lstId.add(CMember.Learning_Board_ID__c);
                MapUserCB.put(CMember.User_Id__c,lstId);
            }
         
        }
        lstBoardMem.clear();
        
        //SOQL getting Users filter with set of createdIds
        list<user> lstuserst= [select id, name from user where id in: setcreateids ];
        setcreateids.clear();
         map<id,string> maplstuser=new map<id,string>();
        
        // Keeping UserId and Username into Map
         for(user users:lstuserst)
         {
            maplstuser.put(users.id,users.name);
         }
        
        Map<Id,ClsCommAndBoard> MapClsComm=new Map<Id,ClsCommAndBoard>();
        List<ClsCommAndBoard> GenerateHmtl=new List<ClsCommAndBoard>();
        
        // Looping ParentIds(Board Or communityIds) and adding values into GenerateHmtl (ClsCommAndBoard Wrapper class).
        for(Id pId : setParentIds)
        {
            ClsCommAndBoard clsComm=new ClsCommAndBoard();
            clsComm.BoardOrCommId=pId;
            if(MapCommNm.containsKey(pId))
            {
                clsComm.BoardOrCommNm=MapCommNm.get(pId);
                clsComm.IsCommunity=true;
            }
            else
            {
                clsComm.BoardOrCommNm=MapBoardNm.get(pId);
                clsComm.IsCommunity=false;
            }
            clsComm.ListFeedPost=new list<ClsFeedPost>();
            list<FeedItem> lstFI= MapFeedItm.get(pId);
            //DateTime d;
            string strRemoveTag='';
            for(FeedItem FI: lstFI)
            {
                ClsFeedPost cFPs=new ClsFeedPost();
                d = FI.CreatedDate;
                cFPs.PostId = FI.Id;
                strRemoveTag=FI.Body;
                If((strRemoveTag!='') && (strRemoveTag!=null))
                {
                    if(strRemoveTag.contains(']'))
                    {
                     strRemoveTag = strRemoveTag.split(']',2)[1];
                    }
                    else
                    {
                     strRemoveTag = strRemoveTag;
                    }
                    if(strRemoveTag.contains('#Rating'))
                    {
                     strRemoveTag = strRemoveTag.replace('#Rating','');
                    }
                    else
                    {
                     strRemoveTag = strRemoveTag;
                    }
                }                
                cFPs.PostName = strRemoveTag;
                cFPs.PostedUserId = FI.CreatedById;
                cFPs.Title=FI.Title;
                if(FI.type =='ContentPost')
                {
                  cFPs.LinkUrl=fullFileURL+FI.RelatedRecordId;
                }
                else
                {
                    cFPs.LinkUrl=FI.LinkUrl;
                }
                if((cFPs.LinkUrl!='' )&& (cFPs.LinkUrl!=null ))
                {
                    cFPs.IsLink=true;
                }
                else
                {
                    cFPs.IsLink=false;
                }
                cFPs.PostedUserName = MapLstUser.get(FI.CreatedById);
                cFPs.PostedDate = d.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                cFPs.Type=FI.Type;
                cFPs.PostLikes = FI.LikeCount;
                if(MapCustomFeedCmt.containsKey(FI.Id))
                {
                  cFPs.lstPostComment = MapCustomFeedCmt.get(FI.Id);
                }
                clsComm.ListFeedPost.add(cFPs);
            }
            MapClsComm.put(pId,clsComm);
            GenerateHmtl.add(clsComm);
        }
        MapFeedItm.clear();
        setParentIds.clear();
        
        MapCustomFeedCmt.clear();
        
        Map<Id,ClsCommAndBoard> MapClsCommResult=new Map<Id,ClsCommAndBoard>();
        //List<ClsCommAndBoard> GenerateHmtl=new List<ClsCommAndBoard>();
        Map<Id,string> mapGenerate=new Map<Id,string>();
        
        // Adding  Mail Body Header  and Footer
        string bodyString='';
         string mailContent='';
        string footerString='';
        string headerString='';
        string headerStringDynamic='';
        footerString +='<table id= "footer" style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="10" cellspacing="0">';
        footerString +='<tr><td colspan="2" align="center"><font size="2">';
        footerString +='This message was automatically generated and sent to all users. Please do not reply to this e-mail.</font></td></tr></table><br />';
        footerString +='</body></html>';    
                     
                    headerString +=' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
headerString +='<html xmlns="http://www.w3.org/1999/xhtml">';
headerString +='<head>';
headerString +='<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
headerString +='<title>Insight - Daily Digest</title>';
headerString +='<style>';
headerString +='body {margin:0;padding:0; font-family: "HP Simplified", Arial, Helvetica, sans-serif; color:#666;}';
//headerString +='b {margin:0;padding:0; font-family: "HPSimplifiedLight", Arial, Helvetica, sans-serif;}';
headerString +='span {font-family: "HP Simplified", Arial, Helvetica, sans-serif;}';
headerString +='h1 {font-size:36px;color:#000;margin:0;padding:0;line-height:36px;}';
headerString +='h2 {font-size:21px;color:#0096d6;margin:0;padding:0;line-height:32px;}';
headerString +='h4 {font-size:16px;color:#0096d6;margin:0;padding:0;line-height:20px;}';
headerString +='h5 {font-size:13px;color:#0096d6;margin:0;padding:15px 0 0 0;line-height:16px;}';
headerString +='p {font-size:13px; margin:5px 0 15px;padding:0;line-height:16px;}';
headerString +='ul {margin:15px 0 15px;padding:0 30px;}';
headerString +='li {list-style: url(images/arrow-blue.png);font-size:13px; margin:0 0 5px 0;padding:0;line-height:16px;}';
headerString +='span {font-size:12px;color:#0096d6;}';
headerString +='a {color:#0096d6;text-decoration:none}';
headerString +='a:hover {color:#777;text-decoration:underline;}';

headerString +='hr{border:0;border-bottom: 1px solid #ccc}';

/*-------------font-face configuration--------------*/
headerString +='@font-face {font-family:"HP Simplified";src:url("fonts/hpsimplified_w01_regular.eot"); src:url("fonts/hpsimplified_w01_regular.eot?#iefix") format("embedded-opentype"), url("fonts/hpsimplified_w01_regular.woff") format("woff"), url("fonts/hpsimplified_w01_regular.ttf") format("truetype");font-weight:normal;font-style:normal;}';
headerString +='@font-face{font-family: "HPSimplifiedBd";src: url("fonts/HPSimplifiedAS_W_Bd.eot");src: url("fonts/HPSimplifiedAS_W_Bd.eot?#iefix") format("embedded-opentype"),url("fonts/HPSimplifiedAS_W_Bd.ttf") format("truetype"),url("fonts/HPSimplifiedAS_W_Bd.woff") format("woff") ;font-weight: bold;font-style: normal;   }';
headerString +='@font-face {font-family: "HPSimplifiedLight";  src: url("fonts/HPSimplifiedAS_W_Lt.eot");src: url("fonts/HPSimplifiedAS_W_Lt.eot?#iefix") format("embedded-opentype"), url("fonts/HPSimplifiedAS_W_Lt.woff") format("woff"), url("fonts/HPSimplifiedAS_W_Lt.ttf") format("truetype");font-weight: normal;font-style: normal; }';
headerString +='</style>';
headerString +='</head><body>';

        headerString +=' <table id="top-header" width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#0096d6"><tr> <td>';
        headerString += '<table style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="10" cellspacing="0"> ';
        headerString += ' <tr><td><span style="color: #fff">HP Enterprise Services</span></td></tr></table>';
        headerString +='</td></tr></table>';
        headerString += '<table id="header" style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="10" cellspacing="0"><tr><td><h1><font color="#0096d6">in</font>sight</h1></td></tr></table>';

        //Loop through GenerateHmtl Generate Mail Body 
        for(ClsCommAndBoard clsCBAdd:GenerateHmtl)
        {
                bodyString='';
                
                bodyString +='<table style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="10" cellspacing="2" bgcolor="#efefef" style="border: 2px solid #efefef; margin: 10px; margin-left: auto; margin-right: auto;"><tr>';
                bodyString +='<td bgcolor="#0096d6" style="font-size:1.4em; color:#fff;">';
                    
                 if(clsCBAdd.IsCommunity == true)
                 {
                 system.debug('Environment:'+Environment);
                
                    if(Environment=='.esit')
                     {
                     bodyString +='<span style="margin:0;padding:0; font-family: HP Simplified;color:#fff;font-size:24px;">Community: </span> <a href="'+ SSORedirectUrl +'SLP_ViewCommunity?id='+clsCBAdd.BoardOrCommId +'"  style="color:#fff;font-family:HP Simplified; text-decoration:none;">'+clsCBAdd.BoardOrCommNm+'</a>';
                     //bodyString += '<span style="margin:0;padding:0; font-family: HP Simplified;color:#fff;font-size:24px;">Community:  </span> <a style="color:#fff;font-family:HPSimplifiedLight; text-decoration:none;" href="'+ SSORedirectUrl +'SLP_ViewCommunity?id='+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+'</a>';
                     
                     //bodyString += '<span >Community:</span> <a style="color:#fff; text-decoration:none;" href="'+ SSORedirectUrl +'SLP_ViewCommunity?id='+clsCBAdd.BoardOrCommId +'">'+clsCBAdd.BoardOrCommNm+'</a>';
                     }
                     else
                     {
                     bodyString +='<span style="margin:0;padding:0; font-family:HP Simplified;color:#fff;font-size:24px;">Community: </span><a href="'+ SSORedirectUrl +'SLP_ViewCommunity?id%3D'+clsCBAdd.BoardOrCommId +'" style="color:#fff;font-family:HP Simplified; text-decoration:none;">'+clsCBAdd.BoardOrCommNm+'</a>';
                       //bodyString += '<span style="margin:0;padding:0; font-family: HP Simplified;color:#fff;font-size:24px;">Community:</span> <a style="color:#fff;font-family:HPSimplifiedLight; text-decoration:none;" href="'+ SSORedirectUrl +'SLP_ViewCommunity?id%3D'+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+'</a>';
                     }
                    //bodyString += '<b>Community:</b> <a style="color:#fff;" href="'+ SSORedirectUrl +'SLP_ViewCommunity?id%3D'+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+'</a>';
                    //bodyString += '<b>Community:</b> <a style="color:#fff; text-decoration:none" href="'+ SSORedirectUrl +'SLP_ViewCommunity?id='+clsCBAdd.BoardOrCommId +'"> '+clsCBAdd.BoardOrCommNm+'</a>';
                 }
                 else if(clsCBAdd.IsCommunity == false)
                 {    
                 system.debug('Environment:'+Environment);
                   if(Environment=='.esit')
                    {
                        bodyString +='<span style="margin:0;padding:0; font-family: HP Simplified;color:#fff;font-size:24px;">Learning Board: </span> <a href="'+ SSORedirectUrl +'AthenaLearningBoardDtls?id='+clsCBAdd.BoardOrCommId +'"  style="color:#fff;font-family:HP Simplified; text-decoration:none;">'+clsCBAdd.BoardOrCommNm+'</a>';
                    }       
                    else
                    {
                        bodyString +='<span style="margin:0;padding:0; font-family:HP Simplified;color:#fff;font-size:24px;">Learning Board: </span><a href="'+ SSORedirectUrl +'AthenaLearningBoardDtls?id%3D'+clsCBAdd.BoardOrCommId +'" style="color:#fff;font-family:HP Simplified; text-decoration:none;">'+clsCBAdd.BoardOrCommNm+'</a>';
                    }                    

                 }
                 bodyString +='</td></tr>';
                if(clsCBAdd.ListFeedPost!=null)
                {
                    for(ClsFeedPost clsFP: clsCBAdd.ListFeedPost)
                    {
                     bodyString +='<tr><td bgcolor="#ffffff">';
                     bodyString +='<table style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="10" cellspacing="3" bgcolor="white">';
                     bodyString +='<tr><td valign="top" colspan="2">';
                        if(clsFP.Title!=null && (clsFP.LinkUrl!=null))
                        {
                        string lurl=clsFP.LinkUrl;
                        if(clsFP.Type=='ContentPost')
                        {
                          lurl=SSORedirect + lurl;                    
                        
                        }
                        else
                        {                       
                        lurl=lurl.split('/',5)[4];
                        system.debug('Environment:'+Environment);
                        if(Environment=='.plmesit')
                        {
                            lurl=lurl.replace('=','%3D');
                            lurl=lurl.replace('&','%26'); 
                        }
                          lurl=SSORedirectUrl + lurl;
                        }
                       bodyString +='<h4 style="font-weight: normal;"><a href="'+lurl+'" >'+clsFP.Title+'</a></h4>';                   
                       }
                        if(clsFP.PostName!=null && clsFP.PostName!='')
                        {
                        system.debug('Environment:'+Environment);
                        if(Environment=='.plmesit')
                        {
                            bodyString += clsFP.PostName+'<br/> <font size="2" >by <a href="'+ SSORedirectUrl +'AthenaUserProfile?id%3D'+ clsFP.PostedUserId +'" >'+clsFP.PostedUserName+'</a></font>';
                        }
                        else
                        {
                          bodyString += clsFP.PostName+'<br/> <font size="2" >by <a href="'+ SSORedirectUrl +'AthenaUserProfile?id='+ clsFP.PostedUserId +'" >'+clsFP.PostedUserName+'</a></font>';
                        }
                        }
                        bodyString += '</td></tr>';
                     if(clsFP.lstPostComment!=null)
                      {
                
                          for(ClsFeedComment FCmt:clsFP.lstPostComment)
                          { 
                                bodyString +='<tr><td width="30" valign="top" style="padding:10px 0px 10px;"></td>';
                                
                                bodyString +='<td style="padding:0px;"><table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" bgcolor="white"><tr>';
                                if(FCmt.CommentBody!=null && FCmt.CommentBody!='')
                                {
                                bodyString +='<td width="2%"> &nbsp; </td><td style="background:#EFEFEF; padding:10px;">'+FCmt.CommentBody; 

                                }
                                if(FCmt.IsLink)
                                {
                                //bodyString +='<td><table width="100%" border="0" align="center" cellpadding="5" cellspacing="3" bgcolor="white"><tr>';
                                //bodyString +='<td width="30" valign="top" style="padding:10px 0px 10px;"></td><td style="background:#EFEFEF; padding:10px;">'+FCmt.CommentBody;
                                bodyString +='<br/><font size="2" ><a href="'+ SSORedirect +  FCmt.LinkUrl+'">'+strAttachment+'</a></font>';
                                }

                                if(Environment=='.plmesit')
                                {
                                bodyString +='<br/><font size="2" >by <a href="'+ SSORedirectUrl +'AthenaUserProfile?id%3D'+ FCmt.CommentedUserId +'">'+FCmt.CmtUserNm+'</a></font></td></tr></table></td></tr>';
                                }
                                else
                                {
                                bodyString +='<br/><font size="2" >by <a href="'+ SSORedirectUrl +'AthenaUserProfile?id='+ FCmt.CommentedUserId +'">'+FCmt.CmtUserNm+'</a></font></td></tr></table></td></tr>';
                                }
                          }
                      }
                      // bodyString +='</td></tr></table>';    
                      bodyString +='</td></tr></table>';  
                    }
                }
                 bodyString +='</table>';   
                 mapGenerate.put(clsCBAdd.BoardOrCommId,bodyString);
        }
        
        
        //MapLstUser.clear();
        list<user> lstActiveUsers= [select id, name from user where id in: setUsersId and IsActive=true];
        
        setUsersId=new set<Id>();
        for(user u:lstActiveUsers)
        {
        setUsersId.add(u.id);
        }
        
        
        Integer mapSize = setUsersId.size();            
        Messaging.SingleEmailMessage[] mails=new Messaging.SingleEmailMessage[mapSize]; 
        integer iCount=0;
        
        
        List<MainData> lstClsComm=new List<MainData>();
        Map<Id,string> strSendBody=new Map<Id,string>();
    
    
        for( Id UIds:setUsersId)
        {
            MainData mData=new MainData();
            mData.UserId=UIds;
            mData.lstCommB=new List<ClsCommAndBoard>();
            List<ClsCommAndBoard> lstBords=new List<ClsCommAndBoard>();
            mData.UserName = MapLstUser.get(UIds);
            List<Id> lstCBId=MapUserCB.get(UIds);
            for(Id CBIds: lstCBId)
            {
                ClsCommAndBoard clsComm=new ClsCommAndBoard();
                clsComm= MapClsComm.get(CBIds);
                lstBords.add(clsComm);
            }
            mData.lstCommB=lstBords;
            lstClsComm.add(mData);
        }
        MapUserCB.clear();
        setUsersId.clear();
       
        string strSSOurl='';
        integer iLoop=0;
        boolean IsAlreadysend=false;
 
        integer SntMailCnt=0; 
        fullFileURL='';
        strAttachment='';
        string HeapData='';
        // Finding the Heap Size
     HeapData=HeapData + ' Before Sending Mail:- '+string.valueof(Limits.getHeapSize());  
 
        // Constructing Mail body Content upto reaching the Heap size
    for( integer icnt=0;icnt<=lstClsComm.size()-1;icnt++)
    {
                    IsAlreadysend=false;
                    bodyString = '';
                   headerStringDynamic = '';
                    DateTime currentDateTime= Datetime.now();
                    string DisplayCurrentDate = currentDateTime.format('EEEE, MMMMM dd, yyyy hh:mm:ss a');
                    headerStringDynamic += '<table style="width:900px; margin:0 auto;" border="0" align="center" cellpadding="5" cellspacing="3">';
                    headerStringDynamic += '<tr><td> <strong style="font:HP Simplified,sans-serif; font-weight:bold;">Daily Digest for  </strong> <strong style="font-family: HPSimplifiedLight;"> <span  style="font-size: 100%;">'+ lstClsComm[icnt].UserName +' </span></strong></td>';
                    headerStringDynamic += '<td style="color:#777;" align="right"><font size="2" >'+DisplayCurrentDate+'- PST</font></td></tr><tr>';
                    headerStringDynamic += '<td style="color:#777;" colspan="2"><font size="2" >Here is what is happening in your communities & boards. You’ll find a summary of all activity for the past 24 hours below.</font></td></tr></table>';
               
                    if(lstClsComm[icnt].lstCommB!=null)
                     {
                         for(ClsCommAndBoard ComB:lstClsComm[icnt].lstCommB)
                         {
                             if(mapGenerate.containsKey(ComB.BoardOrCommId))
                             {
                               bodyString+=  mapGenerate.get(ComB.BoardOrCommId);
                             }
                         }                                   
                      } 
                    mailContent=headerString+headerStringDynamic+bodyString+footerString;
                    strSendBody.put(lstClsComm[icnt].UserId,mailContent);               
               SntMailCnt=icnt;
        // Once it will cross heap Size we need to send the Mails
               if (Limits.getHeapSize() > 6186598) 
               {
                   
                    BulkEmailSend(strSendBody);
                    //HeapData=HeapData + ' Before Clear'+string.valueof(Limits.getHeapSize());            
                    strSendBody.clear();
                    //HeapData=HeapData + ' After Clear:- ' + string.valueof(Limits.getHeapSize()); 
                    HeapData=HeapData + ' Mail Sent :- ' + SntMailCnt ;                     
               }            
    
}
    
     if(strSendBody.size()>0)
    {       
        // Sending Bulk Emails
        BulkEmailSend(strSendBody);
    //  HeapData=HeapData + ' Before Clear'+string.valueof(Limits.getHeapSize());   
        strSendBody.clear();
        //HeapData=HeapData + ' After Clear:- ' + string.valueof(Limits.getHeapSize());
        HeapData=HeapData + ' Mail Sent :- ' + SntMailCnt ;
        HeapData= HeapData + 'Users:- ' + lstClsComm.size();
    }
        //SLP_DailyDigestLog__c slpDD=new SLP_DailyDigestLog__c();
    //slpDD.logEntry__c= HeapData;
    //insert slpDD;

    
    }
    
    // Asyn sending Daily Diggest Mail
    @future
    public static void GenerateDailyDiggest()
    {
    Environment = AthenaUtility.ApplicationSettingValue(AthenaUtility.Environment);
        Map<Id,string> MapBulkDiggest=new Map<Id,string>();
        getDailyDiggest();
        //MapBulkDiggest = getDailyDiggest();
        //BulkEmailSend(MapBulkDiggest);
    }
    
    // Sending Constructing Mail content to the Users
    public static void BulkEmailSend(Map<Id,string> MapSendMails)
   {
     Integer mapSize = MapSendMails.size();            
       system.debug('mapSize---------------'+mapSize);
       Messaging.SingleEmailMessage[] mails=new Messaging.SingleEmailMessage[mapSize]; 
        integer iCount=0;
       for(string UserId : MapSendMails.keyset()) 
       {
      
        string strUID='005Z0000001hUd9IAE';
        //mails[iCount]=SendMail(strUID,MapSendMails.get(UserId));
        
        mails[iCount]=SendMail(UserId,MapSendMails.get(UserId));
        
        //mails[iCount]=SendMail(UserId,MapSendMails.get(UserId));
        iCount++;
       }
       Messaging.sendEmail(mails); 
       //IsDigestMsg=true;
       //IsbtnDigest=false;
   }
   
    public static Messaging.SingleEmailMessage SendMail( string id,string MailBody)
    {
       Messaging.SingleEmailMessage mail;  
       
 //       String instance = 'https://hp--esit--c.cs11.visual.force.com';        
        string[] toAddresses;
        mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);       
        mail.setTargetObjectId(id.left(15)); 
        mail.setSubject('insight Daily Digest' ); 
            
        mail.setHtmlBody(MailBody);
        return mail;
        
    }
    
    
}