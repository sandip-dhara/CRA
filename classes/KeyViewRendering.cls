public class KeyViewRendering {

    public string searchText{get;set;}
    public Cookie counter;
    
    public KeyViewRendering() {
        searchText= ApexPages.currentPage().getParameters().get('SearchVal');
        counter = ApexPages.currentPage().getCookies().get('it-services-gw-itg.external.hp.com');

    }
    
    public String getLink {
        get
        {
            //parseResponseDom('https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/a=query&text=*&printfields=drefilename&matchreference=https://ensv.hp.com/sales/sam/docs/sam-1-2944/en/c03905835.docx');
            return 'Hello ' + searchText + ', cookie: ' + getCookie();
            //return parseResponseDom(searchText);
        }
    }
    
    public String getCookie() {
        //get
        //{
            return counter.getDomain();
        //}
    }
   
    public void parseResponseDom(String url){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        // url that returns the XML in the response body
        req.setEndpoint(url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        Dom.Document doc = res.getBodyDocument();
        
        //Retrieve the root element for this document.
        Dom.XMLNode address = doc.getRootElement();
        
        String name = address.getChildElement('response', null).getText();
        //String state = address.getChildElement('state', null).getText();
        // print out specific elements
        System.debug('Response: ' + name);
        //System.debug('State: ' + state);
        
        // Alternatively, loop through the child elements.
        // This prints out all the elements of the address
        for(Dom.XMLNode child : address.getChildElements()) {
           System.debug(child.getText());
        }
    }
}