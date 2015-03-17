public class SLP_GatewaySessionTk
{
    public SLP_GatewaySessionTk()
    {
        MAP<string, System.Cookie> cookies = ApexPages.currentPage().getCookies();
        Cookie SiteMinderSession = cookies.get('SMSESSION');
        if(SiteMinderSession == null || String.isEmpty(SiteMinderSession.getValue()))
        {
             Authenticate('https://it-services-gw-itg.external.hp.com/sec-gw/login', 
                     '', // no callback
                     'unsecured-plm', 
                     'Dog$101$Cat$Sat');        
        }        
    }

    public void Authenticate(string formUrl, string callbackUrl, string user, string pass)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');   
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setEndpoint(formUrl);
        
        string params = String.Format(
            'interactive=0&user={0}&password={1}&idpid={2}&target={3}', 
            new string[] {
            EncodingUtil.urlEncode(user, 'UTF-8'),
            pass,
            'sm.at_hp',
            callbackUrl
        });        
        req.setBody(params);
        
        Http h = new Http();
        HttpResponse response = h.send(req);
        
        System.debug('body:' + response.getBody());
        System.debug('status:' + response.getStatus());
        System.debug('status code:' + response.getStatusCode());
        System.debug('SMSESSION:' + response.getHeader('SMSESSION'));        
    }
}