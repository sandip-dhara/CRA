public class orgUsedspaceCallout{
    public static string hTTPMethod(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://hp--esit.cs11.my.salesforce.com/00DZ000000N9IbI'); 
        req.setMethod('GET');
        req.setHeader('Cookie','sid='+UserInfo.getSessionId()); 
        
        HTTPResponse res = http.send(req);  
         return res.getBody();  
    }
}