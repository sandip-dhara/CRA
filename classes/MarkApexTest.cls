public class MarkApexTest {

    public String datData() {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://import.gameffectiveapplication.com:8443/pushservice/json/auqerwfhos1nnl4/oracle');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('GET');
        req.setBody('[{"type":"FeedItem","operation":"delete","data":{"attributes":{"type":"FeedItem","url":"/services/data/v32.0/sobjects/FeedItem/0D5Z000000SHEmEKAX"},"RawBody":"To see the landing page/dashboard click on this link:\nhttps://hp--esit--gef.cs11.visual.force.com/apex/GamEffectiveVFPage?sfdc.tabName=01rZ0000000DLP1","Body":"To see the landing page/dashboard click on this link:\nhttps://hp--esit--gef.cs11.visual.force.com/apex/GamEffectiveVFPage?sfdc.tabName=01rZ0000000DLP1","FeedPostId":"0F7Z0000001c0hYKAQ","LikeCount":0,"ParentId":"005Z0000002CBCaIAO","SystemModstamp":"2014-11-07T16:58:02.000+0000","Type":"TextPost","CreatedById":"005Z0000002CBCaIAO","CreatedDate":"2014-11-07T16:58:01.000+0000","IsDeleted":false,"LastModifiedDate":"2014-11-07T16:58:01.000+0000","Id":"0D5Z000000SHEmEKAX","CommentCount":0},"additionalData":{}}]');
        //req.setCompressed(true); // otherwise we hit a limit of 32000

        try {
            res = http.send(req);
            return res.getBodyAsBlob().toString();
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        
        return '';
   }
   
   public String getDatResponse() {
       String s = datData();
       return s;
   }
}