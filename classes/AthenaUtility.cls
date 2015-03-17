public class AthenaUtility{    
    Public static string LearningBoard='Learning_Board';
    Public static string Learning='Learning';
    Public static string Community='Community';
    Public static string Collateral='Collateral';
    Public static string LearningBoardDefaultImages='LrngBrdDefaultImages';
    Public static string LearningDefaultImages='LrngDefaultImages';
    Public static string UserAccessPDL='UserAccessPdl';
    Public static string UploadAppURL='UploadAppURL';
    Public static string LearningTypeText='Text';  
    Public static string LearningTypeVideo='Video';  
    Public static string LearningTypeUrlOrDocument='Link or Document';  
    Public static string MostCommentedTrendDays='MostCommentedLrngBrdTrendDays';  
    Public static string MostLikedTrendDays='MostLikedLrngBrdTrendDays'; 
    Public static string FeedBackLike='FeedBackLike'; 
    Public static string FeedBackImprovement='FeedBackImprovement'; 
    Public static string RatingComment='Rating';
    Public static final string RateLearningBoard='Rate Learning Board';
    Public static final string ShareTopic='Share Topic'; 
    Public static final string ShareLearningBoard='Share Learning Board';
    Public static final string RateTopic='Rate Topic';
    
    Public static final string ShareBoardEvent='Share Learning Board';
    Public static final string ShareTopicEvent='Share Topic';
    Public static final string RateBoardEvent='Rate Learning Board';
    Public static final string RateTopicEvent='Rate Topic';
    Public static final string Requested='Requested Membership';
    Public static final string Approved='Approved';
    Public static final string Rejected='Rejected'; 
    Public static final string PreviewRequired = 'PreviewRequired'; 
    Public static final string SLPRegistrationUrl = 'SLPRegistrationUrl';
    Public static final string SSOUrl = 'SSOUrl';
    Public static final string Environment = 'Environment';
    Public static final string DefaultBoardId = 'DefaultBoardId';
    
    Public static List<string> ContentType()
    {
           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif'); 
           return contype;
     }  
    
    //If we pass Application setting Name it will return respective value (Name Value pair)
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
    
    //Fetch all available in the Tag object and return in a string format each tag with single quote seperated by comma 
    public static String getAvailableTags()
    {
        List<Tag__c> tags=[SELECT Value__c FROM Tag__c order by Value__c];        

        string AvlbleTags = '';

        for(Tag__c tag:tags)
        {           
            //AvlbleTags += '\'' + string.valueOf(tag.Value__c) +  '\'' + ',';             
            
            AvlbleTags += '\'' + string.valueOf(tag.Value__c).replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '') +  '\'' + ',';             

        }

        return AvlbleTags;
    }    
    
    //Fetch associated tags in list of string format for the perticular object's record id 
    public static List<string> getAssociatedTags(string ObjectName,string ObjectId)
    {
        List<string> lstTags=new List<string>(); 
        List<Tag_Item__c> tagItmlst = new List<Tag_Item__c>();
        tagItmlst = [SELECT Id,Item_Identifier__c,Item_Name__c,Name,Tag_ID__r.Value__c FROM Tag_Item__c WHERE Item_Name__c=:ObjectName and Item_Identifier__c LIKE:ObjectId];// 
        for (Tag_Item__c tagitm : tagItmlst){
           lstTags.add(string.valueOf(tagitm.Tag_ID__r.Value__c));
        }
        return lstTags;
    }
    
    //It will Associate tags to perticualr object's record  
    public static void AssociateTags(List<string> strlst,string ObjectName,string ObjectId)
    {
        system.debug('strlst:'+ strlst[0]);  

        If(strlst==null || strlst.size()==0)
        {
          List<Tag_Item__c> tagItms= [SELECT Id, Item_Name__c, Tag_ID__c, Item_Identifier__c FROM Tag_Item__c where Item_Name__c=:ObjectName and Item_Identifier__c=:ObjectId];
          delete tagItms;   
        }
        else
        {
            for (string strtag:strlst)
            {
                system.debug('strtag:'+ strtag);  

                List<Tag_Item__c> remtagItms=[SELECT Id FROM Tag_Item__c WHERE Item_Name__c=:ObjectName and Item_Identifier__c LIKE:ObjectId and Tag_ID__r.Value__c Not IN:strlst]; 
                delete remtagItms;
                
                List<Tag__c> lsttag=[SELECT Value__c, Id FROM Tag__c Where Value__c=:strtag];   
                boolean isTagxst=false;
                Tag__c tag=new Tag__c();     
                for(Tag__c t:lsttag)
                {
                    isTagxst=true;  
                    tag.id=t.id;  
                }
    
                if(!isTagxst)
                {
                    tag.Value__c=strtag;
                    insert tag;                        
                }
    
                List<Tag_Item__c> tagItms= [SELECT Id, Item_Name__c, Tag_ID__c, Item_Identifier__c FROM Tag_Item__c where Tag_ID__c=:tag.id and Item_Identifier__c=:ObjectId];
    
                if(tagItms.size()==0)
                {
                    system.debug('tagItms:'+ strtag);  

                    Tag_Item__c tagitm= new Tag_Item__c();
                    tagitm.Item_Name__c=ObjectName;
                    tagitm.Item_Identifier__c=ObjectId;
                    tagitm.Tag_ID__c=tag.id;
                    insert tagitm;
                }    
            }        
        }
    }
    
        //It will be used to rate either Learning Board or Learning
    public static string  RateObject(string ObjectName,string ObjectId,Integer RatingNbr,String UserId,string RatingCmnt,string BoardId)
    {         
           List<Rated_Item__c> ratedItmlst=[SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c=:ObjectId];   
        
            system.debug('!!!!'+ratedItmlst);
            system.debug('!!!!'+ratedItmlst.size());
            boolean isRatedItmxst=false;
            Rated_Item__c rtdItm=new Rated_Item__c();     
            for(Rated_Item__c rt:ratedItmlst)
            {
                isRatedItmxst=true;  
                rtdItm.id=rt.id;  
            }
            system.debug('@@@'+isRatedItmxst);
            if(!isRatedItmxst)
            {
                rtdItm.Item_Name__c=ObjectName;
                rtdItm.Item_Identifier__c=ObjectId;
                system.debug('i am inserting rated item here'+rtdItm.Item_Identifier__c);
                insert rtdItm;                        
            }

            List<User_Rated_Item__c> usrRatdItmLst= [SELECT Id, User_Id__c, Rated_Item_Id__c, Rating_Nbr__c,Comment__c FROM User_Rated_Item__c where Rated_Item_Id__c=:rtdItm.id and User_Id__c=:UserId];
            system.debug('###'+usrRatdItmLst.size());
            if(usrRatdItmLst.size()==0)
            {
                User_Rated_Item__c usrRatdItm= new User_Rated_Item__c();
                system.debug('!@#$'+rtdItm.id);
                usrRatdItm.Rated_Item_Id__c=rtdItm.id;
                usrRatdItm.User_Id__c=UserId;
                usrRatdItm.Rating_Nbr__c=RatingNbr;
                usrRatdItm.Comment__c=RatingCmnt;
                system.debug('i am inserting user rated item');
                Insert usrRatdItm;              
            }
            else
            {
                for (User_Rated_Item__c usrRatdItm:usrRatdItmLst)
                {
                    usrRatdItm.Rating_Nbr__c=RatingNbr;
                    usrRatdItm.Comment__c=RatingCmnt;
                    system.debug('i am updating rating number here'+ratingNbr);             
                    update usrRatdItm; 
                    
                }
            }
            Decimal RatingAvg;
            RatingAvg=0;
            ratedItmlst=[SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c=:ObjectId];  
            system.debug('%%%%'+ratedItmlst);
             for(Rated_Item__c rt:ratedItmlst)
            {
                RatingAvg=rt.Rating_Average__c;
                system.debug('$$$ i am assigning average number'+rt.Rating_Average__c);
            }  
            User lgdInUsr=[Select Name from User where id=:UserId Limit 1];
            string ratingStar='';
            if(ObjectName==LearningBoard)
            {
                ratingStar='I have rated this Board as ';       
            }
            else if(ObjectName==Learning)
            {
                Learning__C lrng=[Select Name__c from Learning__C where id=:ObjectId Limit 1];
                ratingStar='I have rated the Topic ' + lrng.Name__C +' as ';       
            }
            else if(ObjectName==Collateral)
            {
                Collateral__c coll=[Select Name__C from Collateral__c where id=:ObjectId Limit 1];              
                ratingStar='I have rated the Topic ' + coll.Name__C +' as ';       
            }
            
            if(RatingNbr==1)
            {
                ratingStar= ratingStar + ' * (1 Star)';
            }
            else if(RatingNbr==2)
            {
                ratingStar=ratingStar + ' ** (2 Stars)';
            }
            else if(RatingNbr==3)
            {
                ratingStar=ratingStar + ' *** (3 Stars)';
            }
            else if(RatingNbr==4)
            {
                ratingStar= ratingStar + ' **** (4 Stars)';
            }
            else if(RatingNbr==5)
            {
                ratingStar=ratingStar + ' ***** (5 Stars)';
            }
            
        
            FeedItem post = new FeedItem();     
            post.ParentId = BoardId; 
            post.Body = '#[' + RatingComment + ']' + ' ' + ratingStar + '\n' +  RatingCmnt;
            insert post;
            
            
            
            
            List<User_Rated_Item__c> usrRtdItms=[SELECT User_Id__c, Rated_Item_Id__c, Rating_Nbr__c, Id FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=:ObjectId and Item_Name__c=:ObjectName)];          
            
            string AvgRtngCount='';
            AvgRtngCount = RatingAvg + ',' + usrRtdItms.size();
            return AvgRtngCount;                            
    }
     
    //Fetch associated Ratings for the perticular Record
    public static string getRatingAvg(string ObjectName,string ObjectId)
    {
            string AvgRtngCount='';
            Decimal RatingAvg;
            RatingAvg=0;
            List<Rated_Item__c> ratedItmlst=[SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c=:ObjectId and Item_Name__c=:ObjectName];  
             for(Rated_Item__c rt:ratedItmlst)
            {
                RatingAvg=rt.Rating_Average__c;
            }    


            List<User_Rated_Item__c> usrRtdItms=[SELECT User_Id__c, Rated_Item_Id__c, Rating_Nbr__c, Id FROM User_Rated_Item__c where rated_Item_Id__c IN (Select Id from Rated_Item__c where Item_Identifier__c=:ObjectId and Item_Name__c=:ObjectName)];          
            
            AvgRtngCount=RatingAvg + ',' + usrRtdItms.size();
            return AvgRtngCount;        
    }
    
    //Insert FeedBackLike,FeedBackImprovement and Rating Comment
    public static Void AddToChatterComment(string ObjectId,string tag,string comment)
    {
        FeedItem post = new FeedItem();     
        post.ParentId = ObjectId; 
        post.Body = '#[' + tag + ']' + ' ' +  comment;
        insert post;
        system.debug('$$$$'+post.id);
        system.debug('$$$$'+post.Body);
        system.debug('$$$$'+post.ParentId);
    }
    
    
     public static Void AddToChatterLink(string ObjectId,string tag,string comment,string Title,string LinkUrl)
    {
        FeedItem post = new FeedItem();     
        post.ParentId = ObjectId; 
        post.Body = '#[' + tag + ']' + ' ' +  comment;
        post.Title=Title;
        post.LinkUrl=LinkUrl;
        insert post;
        system.debug('$$$$'+post.id);
        system.debug('$$$$'+post.Body);
        system.debug('$$$$'+post.ParentId);
    }
    
    //will give the notification setting status whether true or false
    public static boolean NotifyMyStatus(String Event,String USERID){        
        List<User_Notification_Subscription__c> UNS = [select id,isactive__c,Subscriber_User_ID__c,Notification_Event_ID__r.name__c,Notification_Event_ID__r.isactive__c from User_Notification_Subscription__c where Notification_Event_ID__r.name__c=:Event AND Subscriber_User_ID__c=:USERID AND isActive__c=true AND Notification_Event_ID__r.isactive__c=true];
        if(UNS.size()==0){
            system.debug('!!');
            return false;
        }
        else {
            system.debug('##');
            return true;
        }
    }
    
  /*  public static void InsertUserSession(string SessionId,string UserId)
    {
      list<SLP_UserSession__c> lstSlpSession= [SELECT Id FROM SLP_UserSession__c where Session_Id__c=:SessionId and User_Id__c=:UserId];
      //list<SLP_UserSession__c> lstSlpSession= [SELECT Id FROM SLP_UserSession__c where createddate>Yesterday and User_Id__c=:UserId];
      if(lstSlpSession.size()==0)
      {
          SLP_UserSession__c slpUserSession=new SLP_UserSession__c();
            slpUserSession.Session_Id__c =SessionId;
            slpUserSession.User_Id__c=UserId;
            insert slpUserSession;
      }
    
    }
    
    public static void InsertMetricAction(string UId,string PPathNm,string ActionTyp, string PHref,string postAchorId, string PostAcHref,string AchorText,string submitId,string submitVal, string LinkHref,string LInvoke)
    {
      Metrics_Action__c merticAction=new Metrics_Action__c();
      merticAction.Email_Id__c=UId;
      merticAction.Page_Pathname__c=PPathNm;
      merticAction.Action__c=DateTime.Now();
      merticAction.Action_Type__c=ActionTyp;
      merticAction.Page_Display_HREF__c=PHref;
      merticAction.Postback_Anchor_Id__c=postAchorId;
      merticAction.Postback_Anchor_HREF__c=PostAcHref;
      merticAction.Postback_Anchor_Invoking_Text__c=AchorText;
      merticAction.Postback_Submit_Id__c=submitId;
      merticAction.Postback_Submit_Value__c=submitVal;
      merticAction.Link_HREF__c=LinkHref;
      merticAction.Link_Invoking__c =LInvoke;
      insert merticAction;
      
    }*/

// START By Komala    
    public static String parseResponseDom(String url,String SMSession){
        String filePath='';

        Http h = new Http();
        HttpRequest req = new HttpRequest();        
        //String sessionId=UserInfo.getSessionId();
        // url that returns the XML in the response body
        req.setEndpoint('https://it-services-itg.external.hp.com/auth/loginform.html');
        req.setMethod('POST');    
        //req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        //req.setHeader('Cookie','SMSESSION='+sessionId);
        //system.debug('SMSession :'+sessionid);
        //req.setHeader('Cookie','SMSESSION='+'Jsvo9NoF3rjF/xRq4quauNPXXPku7Eao4hXqVwSb3j9k1eH0F5zlYPLpkNWgEERjIJrbHykuX0YrXHFtNH0yMCouNT62cI2p6xoIj7aq/bvTQBdiTdw/Pz83TntPQIcu/lPgjo3hl6ioFq9teJUXxPN1wzQZfOo/Anyf8AzxPj6uUKtW7Qwmf5jjO3puUFTM+Gf+XqrxN00vwJA+NiBEfmrryQLSe2e+zl1PJZIA5CIXNCPZrhCQPmoEYxUp+px9jKYSDZdP2Z/vSmwJw8dNmbZGg1fnGUtvDcABPpr7YFxwY6jxnjDMHXqfL7glFD/2i4x0o4P6f1bjoYTWpSJRdwgJNC05imLQ5uwALCRN8YtjCZifzn7wdmDmAa5R88ZL0SQC1wVWW2yEP5cmqdkjTj70n8J4atdW4DAoHxZx8ungadyLVGWgK9lCEl1DI5D8Jmuklr4rZMc/cB/mgpYmLaMGcjJbJDBpoMsr2r3GwQFLZukK74KbIoj42twhpb9U6mumXS0mM1h8izq+mAktmYrLFt2PoikZsuHfJyzjbHrlyuR1xeu1J6gT8DPSqCST+USZJMy9c5rA7/MxQZ/Ij6pS1L/kQ8rWpIOQinXMfOzXnhqeYLSfbgQXego1zAImdr/NusOEhTdCcqa/FkvHHeoieKIbHgXwuta0zWKY5CuDqB91UDi0ac2xQuhWIszxY3kbhhlUzegQixhQNvrPJE39plbHHafWH/l5DsqZb79kQ3ZHcTy9hF4hWczhsmLfE496/3sjed9+LWuQRrt8uUewc3SfdDiLySOGXda66pzw/2ctV1n7JRWmUVlKJznvcDTKTTRvqKSRWAJulpvq44zp0kieLWfje6qaaBM2MXmexHF2tRUyUmMd0KuHX6azo4Y1e/+ULzocc5XaB/1eTCBg0cRPmddIiT8SDovy1MMjHMc0JzcSUG/9xNwbqZCnKvlQHM0NyEQzDWkUVuVLk9HL+0NwDFHx5iELvUs8jhPsrlJoqFOQPPYoD/kRxvSA5gfcH1LfRIH+wrPJcg9sEB7a1HX+OLdUMPGHfcoOAwdgSOUPaNHp68ZNAs1rTsXT0Cc5R+DncyuqsPOam1qW30YwieIs9x6e');
        system.debug('URL: '+url);
        string params = String.Format(
            'interactive=0&user={0}&password={1}&idpid={2}&target={3}', 
            new string[] {
            EncodingUtil.urlEncode('unsecured-plm', 'UTF-8'),
            'Dog$101$Cat$Sat',
            'sm.at_hp',
            '' //callbackurl
        }); 
        req.setBody(params);
        HttpResponse res = h.send(req);
        string responseData=res.getBody();
        system.debug('body :'+responseData);
JSONParser parser = JSON.createParser(responseData);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'smsession')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                SMSession= parser.getText();
            }
        }

        system.debug('Response: '+res);
        system.debug('Response: '+res.getBody());
        SMSession=res.getHeader('SMSESSION');
        system.debug('SMSession :'+SMSession);
        
        Http http = new Http();
        HttpRequest req1 = new HttpRequest();        
        //String sessionId=UserInfo.getSessionId();
        // url that returns the XML in the response body
        req1.setEndpoint(url);
        req1.setMethod('GET');    
        //req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        //req.setHeader('Cookie','SMSESSION='+sessionId);
        //system.debug('SMSession :'+sessionid);
        req1.setHeader('Cookie','SMSESSION='+SMSession);
        HttpResponse response = http.send(req1);
        // Generate the HTTP response as an XML stream
    XmlStreamReader reader = response.getXmlStreamReader();

    // Read through the XML
    while(reader.hasNext()) {
      System.debug('Event Type:' + reader.getEventType());
      if (reader.getEventType() == XmlTag.START_ELEMENT) {
        System.debug(reader.getLocalName());
        if(reader.getLocalName()=='DREFILENAME')
        {
        while(reader.hasNext())
        {
        if (reader.getEventType() == XmlTag.CHARACTERS)
        {
        filePath=reader.getText();
        }
        reader.next();
        }
        }
      }
      reader.next();
    }
    return filePath;
    }
    
        
  public String GetOSName(String data)
  {
  String osName='';
  
  if(data.indexOf('Windows 95')!=-1) osName='Windows 95';
                                     
  else if(data.indexOf('Windows 98')!=-1) osName='Windows 98';

  else if(data.indexOf('Windows NT 5.0')!=-1 || data.indexOf('Windows 2000')!=-1) osName='Windows 2000';

  else if(data.indexOf('Windows NT 5.1')!=-1 || data.indexOf('Windows XP')!=-1) osName='Windows XP';

  else if(data.indexOf('Windows NT 5.2')!=-1) osName='Windows Server 2003';
  
  else if(data.indexOf('Windows NT 6.0')!=-1) osName='Windows Vista';

  else if(data.indexOf('Windows NT 6.1')!=-1) osName='Windows 7';
 
  else if(data.indexOf('Windows NT 6.2')!=-1) osName='Windows 8';

  else if(data.indexOf('Windows NT 4.0')!=-1 || data.indexOf('WinNT4.0')!=-1 || data.indexOf('WinNT')!=-1) osName='Windows NT 4.0';

  else if(data.indexOf('Windows ME')!=-1) osName='Windows ME';
  
  else if(data.indexOf('OpenBSD')!=-1) osName='Open BSD';
  
  else if(data.indexOf('SunOS')!=-1) osName='Sun OS';
  
  else if(data.indexOf('Linux')!=-1 || data.indexOf('X11')!=-1) osName='Linux';
  
  else if(data.indexOf('Mac_PowerPC')!=-1 || data.indexOf('Macintosh')!=-1) osName='Mac OS';
  
  else if(data.indexOf('QNX')!=-1) osName='QNX';
  
  else if(data.indexOf('BeOS')!=-1) osName='BeOS';
  
  else if(data.indexOf('OS/2')!=-1) osName='OS/2';
  
  else if(data.indexOf('iPhone')!=-1 || data.indexOf('iPad')!=-1) osName='iOS';

  else if(data.indexOf('Android')!=-1) osName='Android';

   else 
   {
       osName= data;
   }
  return osName;
  
  }
    
    
    
    
  
// END By Komala
    
}