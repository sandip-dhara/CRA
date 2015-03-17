// -------------------------------------------------------------------------------------------
//This is a common class for the methods and constants used across the application 
// Version#   Date            Author                Description
// -------------------------------------------------------------------------------------------
// 1.0         14-Aug-2012    Prateek Kataria       Initial Version
// -------------------------------------------------------------------------------------------
public class hpCommon 
{

    // --------------------------------------------------------------------------------------
    // Validates whether string is empty or null
    //
    // Input Parameters:
    //                  - strValue: String
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         14-Aug-2012     Prateek Kataria           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsNullOrEmpty(string strValue)
    {
        return (strValue == null || strValue == '' || strValue.replace('&nbsp;','').trim() == '' || strValue.replace('<br/>','').trim() == '' || strValue.replace('</br>','').trim() == '' || strValue.replace('&nbsp;','').trim() == '' || strValue.replace('&lt;br/&gt;','').trim() == '');
    }

    // --------------------------------------------------------------------------------------
    // Validates whether ID is null
    //
    // Input Parameters:
    //                  - strValue: String
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         14-Aug-2012     Prateek Kataria           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsNull(ID value)
    {
        return value == null;
    }
    
    // --------------------------------------------------------------------------------------
    // Validates whether Integer value is null
    //
    // Input Parameters:
    //                  - intValue: Integer
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         16-Aug-2012     Kamendra Singh           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsNull(Integer value)
    {
        return value == null;
    }
    
    // --------------------------------------------------------------------------------------
    // Validates whether Integer value is null
    //
    // Input Parameters:
    //                  - intValue: Integer
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         18-Aug-2012    Vishnu Kant           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsNull(date value)
    {
        return value == null;
    }
    
    // --------------------------------------------------------------------------------------
    // Validates whether Integer value is null
    //
    // Input Parameters:
    //                  - intValue: Integer
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         18-Aug-2012    Vishnu Kant           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsNull(Decimal value)
    {
        return value == null;
    }
        
    // --------------------------------------------------------------------------------------
    // Validates email-id
    //
    // Input Parameters:
    //                  - strEmail: String
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         16-Aug-2012     Vishnu Kant           Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsEmailValid(string strEmail)
    {
        boolean isValid = false;
        
        // validate email
        if(!IsNullOrEmpty(strEmail))
        {
            string emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(strEmail);
            if(MyMatcher.matches())
            {
                isValid = true;
            }
        }
        return isValid;
    }
    
    // --------------------------------------------------------------------------------------
    // Validates Password
    //
    // Input Parameters:
    //                  - strPassword: String
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0        30-Aug-2012     Vishnu Kant               Initial Version
    // --------------------------------------------------------------------------------------
    public static boolean IsPasswordValid(string strPassword)
    {
        boolean isValid = false;
        
        if(!IsNullOrEmpty(strPassword))
        {
            // validate password
            string strPasswordRegex = '(^(?=.*[0-9])(?=.*[A-Z]).{10,}$)';
            Pattern MyPattern = Pattern.compile(strPasswordRegex);
            Matcher MyMatcher = MyPattern.matcher(strPassword);
            if(MyMatcher.matches())
            {
                isValid = true;
            }
        }
        return isValid;
    }
    
    // --------------------------------------------------------------------------------------
    // get url of any page by its vf page name
    //
    // Input Parameters:
    //                  - string: strVFPageName
    // Returns: 
    //                  - string: strUrl
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         22-Aug-2012     Vishnu Kant           Initial Version
    // --------------------------------------------------------------------------------------
    public static string GetPageUrlByVFTemplateName(string strVFPageName)
    {
        string strUrl = '';
        string getSiteName = '';
        string PageId = '';
        getSiteName = Site.getName();
        // get ISV member Login page record
        List<Page__c> lstSitePage = [Select PageTemplate__c,
                                                Page_URL__c, 
                                                Id 
                                         from Page__c
                                         where PageTemplate__r.VisualForce_Page_Name__c = :strVFPageName
                                         limit 1];
        system.debug('lstSitePage----'+lstSitePage);
        if(lstSitePage != null && lstSitePage.size() > 0)
        {
            PageId = lstSitePage[0].id;
            system.debug('PageId----'+PageId);
            system.debug('getSiteName$$$$$$$'+getSiteName);
            if(getSiteName ==null || getSiteName =='')
            {
                strUrl = './page?pageid='+PageId;
            }
            else
            {
                strUrl = lstSitePage[0].Page_URL__c;
                system.debug('strUrl!!!!!!!!!!'+strUrl);
            }
            system.debug('strUrl**********'+strUrl);
            
        }
        return strUrl;
        return null;
    }
    
    // --------------------------------------------------------------------------------------
    // get url of login page
    //
    // Input Parameters:
    //                  - None
    // Returns: 
    //                  - string: strUrl
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0         22-Aug-2012     Vishnu Kant           Initial Version
    // --------------------------------------------------------------------------------------
    public static string GetLoginPageUrl()
    {
        //return GetPageUrlByVFTemplateName('hpTemplateMemberLogin');
        return getURL('memberlogin');
    }
    
    // --------------------------------------------------------------------------------------
    // Validates is user logged in or not.
    //
    // Input Parameters:
    //                  - none
    // Returns: 
    //                  - true or false : boolean
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0        17-Aug-2012    Neeraj Chauhan             Initial Version
    // --------------------------------------------------------------------------------------
    
    public boolean IsUserLoggedIn(){
         
        Cookie cookie = ApexPages.currentPage().getCookies().get('conid');
        System.Debug('cookie: ' + cookie);
        if(Site.getName() == null)
            return true;
        
        if(cookie == null || cookie.getValue() == null || cookie.getValue() == '')
            return false; 
           
        else
            return true;
    }
    
    // --------------------------------------------------------------------------------------
    // Returns Logged in User Id
    //
    // Input Parameters:
    //                  - none
    // Returns: 
    //                  - string (User Id)
    //
    // Version#   Date            Author                    Description
    // --------------------------------------------------------------------------------------
    // 1.0        17-Aug-2012    Neeraj Chauhan             Initial Version
    // --------------------------------------------------------------------------------------
    
    public string GetLoggedInContactId()
    {
        Cookie cookie = ApexPages.currentPage().getCookies().get('conid');
        
        if(cookie == null || cookie.getValue() == null || cookie.getValue() == '')
            return null;
        else
            return cookie.getValue();
        
    }
    public static string GetLoginType()
    {
       string LoginUserType = ''; 
        if(Site.getName() != null || userinfo.getusertype() == 'Guest')
        {
            LoginUserType = 'siteuser';
        }else{
            LoginUserType = 'internaluser';
        }

      return LoginUserType;
    }
    
    public static string getURL(String pageName){
        
        String url ='';
        try{
            if(GetLoginType() == 'internaluser'){           
                List<Page__c> obPage = [select id from Page__c where FriendlyUrl__c = :pageName limit 1];
                if(obPage.size() > 0){
                    url = '/apex/page?pageid='+obPage[0].id;
                }
            }else{
                url = '/'+pageName;
            }
        }catch(Exception e){
            system.debug('Error: '+e);
        }
        return url;
    }
}