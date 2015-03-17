public class SLP_SearchCustomComponentController{
public string strSearchValue{get;set;}
public string strSelectedOptions{get;set;}
public string ReceivedString{get;set;}
public string OperatingSystem{get;set;}
public string Browser{get;set;}
Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
}

      public PageReference  RedirectToSLP_GlobalSearch()
      {
        AthenaUtility athUtlObj=new AthenaUtility();
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Global Search Button Click';
        metricsObj.ActionPath__c=getSfInstance+'/apex/SLP_GlobalSearch'+'?SearchOptions='+strSelectedOptions+'&SearchVal='+strSearchValue;
        metricsObj.PageName__c=ReceivedString;
        metricsObj.DeviceType__c='Desktop';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=athUtlObj.GetOSName(OperatingSystem);
        metricsObj.Browser__c=Browser;
        Insert(metricsObj);
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.getParameters().put('SearchOptions',strSelectedOptions);
        pRef.setRedirect(true);
        return pRef;
      }
      
}