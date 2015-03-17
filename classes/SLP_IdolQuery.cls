public class SLP_IdolQuery
{
    private string baseQueryUrl;
        
    public SLP_IdolQuery(string idolServerUrl, string idolDatabase, string query, integer pageSize, integer maxResults)
    {
        this(idolServerUrl, idolDatabase, query, pageSize, maxResults, -1);
    }
    
    public SLP_IdolQuery(string idolServerUrl, string idolDatabase, string unencodedQueryText, integer pageSize, integer maxResults, integer knownHitCount)
    {
        this.IdolServerUrl = idolServerUrl;        
        this.IdolDatabase = idolDatabase;
        this.Query = unencodedQueryText;
        this.PageSize = pageSize;
        this.MaxResults = maxResults;
        this.baseQueryUrl = string.format(
            '{0}/Action=query&Databasematch={1}&Text={2}',
            new string[] {this.IdolServerUrl, this.IdolDatabase, EncodingUtil.urlEncode(this.Query, 'UTF-8')});
        
        // Note that this constructor makes a search to get a hit count if it is not known.
        // If a caller is paging through results, we know what the hitcount will be from previous calls.
        this.Hits = (knownHitCount == -1) ? getHitCount() : knownHitCount;
    }
    
    //Added by Muthu
   
     public SLP_IdolQuery()
    {       
    }
     public SLP_IdolQuery(string idolServerUrl, string idolDatabase, string unencodedQueryText)
    {
        this.IdolServerUrl = idolServerUrl;        
        this.IdolDatabase = idolDatabase;
        this.Query = unencodedQueryText;
        this.baseQueryUrl = string.format(
            '{0}/Action=query&Databasematch={1}&Text={2}',
            new string[] {this.IdolServerUrl, this.IdolDatabase, EncodingUtil.urlEncode(this.Query, 'UTF-8')});
        
        // Note that this constructor makes a search to get a hit count if it is not known.
        // If a caller is paging through results, we know what the hitcount will be from previous calls.

    }
    
    public string IdolServerUrl{ get; private set; }    
    public string IdolDatabase { get; private set; }    
    public string Query{ get; private set; }    
    public string ErrorText { get; private set; }
    public integer PageCount { get { return (integer) Math.Ceil(this.Hits / this.PageSize); } }    
    public integer PageSize { get; private set; }     
    public integer MaxResults { get; private set; }    
    public integer Hits { get; private set; }
    
    public List<SLP_IdolQueryResponse> Fetch(integer startItem)
    {
        string q = string.format(
            '{0}&Summary=context&Highlight=Terms+SummaryTerms&Start={1}&MaxResults={2}',
            new string[]
            {
                this.baseQueryUrl, 
                string.valueof(startItem), 
                string.valueof(startItem + this.PageSize - 1)
            });        
        System.debug('Fetch url: ' + q);
        Dom.Document doc = getXmlFromWebService(q);
        return parseXmlHits(doc.getRootElement());
    }    
    //Added by Muthu
    
    public List<SLP_IdolQueryResponse> FetchAll(string unencodedQueryText,integer pageNo,integer knownHitCount,string URLName)
    {
        SLP_IDOL_Settings__c objSLPIDOLSettings = [SELECT Id, Name,Maximum_Hits__c, Page_Size__c,Database__c,Server_URL__c FROM SLP_IDOL_Settings__c where Name =:URLName];
        List<SLP_IdolQueryResponse> lstSLPIdolQueryResponse=new List<SLP_IdolQueryResponse>();
         boolean isCountZero=false;
        integer startItem=1;
       integer pageCount=0;

         	this.IdolServerUrl = objSLPIDOLSettings.Server_URL__c;   
        	//this.IdolDatabase = objSLPIDOLSettings.Database__c;
			this.IdolDatabase = 'sharepoint,SLP,ES';
        	this.Query = unencodedQueryText;
            this.MaxResults=objSLPIDOLSettings.Page_Size__c.intValue();
            if(pageNo>1)
            {
                pageCount=pageNo-1;
                startItem=(pageCount*this.MaxResults)+1;
            }
        
        this.baseQueryUrl = string.format(
            '{0}/Action=query&Databasematch={1}&Text={2}',
            new string[] {this.IdolServerUrl, this.IdolDatabase, EncodingUtil.urlEncode(this.Query, 'UTF-8')});
            
            System.debug('baseQueryUrl: ' + this.baseQueryUrl);
        
         this.Hits = getHitCount();
        
             string q = string.format(
            '{0}&Summary=context&Highlight=Terms+SummaryTerms&Start={1}&MaxResults={2}',
            new string[]
            {
                this.baseQueryUrl,
                string.valueof(startItem), 
                string.valueof(this.MaxResults)
            });   
        
        	System.debug('Fetch url: ' + q);
        
              Dom.Document doc = getXmlFromWebService(q);
             for(SLP_IdolQueryResponse currentResponseItem: parseXmlHits(doc.getRootElement()))
        	{
               lstSLPIdolQueryResponse.add(currentResponseItem);
        	}
        
        return lstSLPIdolQueryResponse;
    }    
    
    public List<SLP_IdolQueryResponse> FetchAll(string unencodedQueryText,integer pageNo,integer knownHitCount)
    {
        List<SLP_IDOL_Settings__c> lstSLPIDOLSettings = [SELECT Id, Name,Maximum_Hits__c, Page_Size__c,Database__c,Server_URL__c FROM SLP_IDOL_Settings__c];
        List<SLP_IdolQueryResponse> lstSLPIdolQueryResponse=new List<SLP_IdolQueryResponse>();
               boolean isCountZero=false;
        integer startItem=1;
       integer pageCount=0;
        if(knownHitCount == -1)
        {
        isCountZero=true;
            this.Hits=0;
        }

         System.debug('lstSLPIDOLSettings: ' + lstSLPIDOLSettings.size());
        
         for(SLP_IDOL_Settings__c currentItem: lstSLPIDOLSettings)
        {
             this.IdolServerUrl = currentItem.Server_URL__c;   

        	this.IdolDatabase = currentItem.Database__c;
            this.Query = unencodedQueryText;
 			this.baseQueryUrl = string.format(
            '{0}/Action=query&Databasematch={1}&Text={2}',
            new string[] {this.IdolServerUrl, this.IdolDatabase, EncodingUtil.urlEncode(this.Query, 'UTF-8')});
            
            System.debug('baseQueryUrl: ' + this.baseQueryUrl);
        	
            this.MaxResults=currentItem.Page_Size__c.intValue();
            if(pageNo>1)
            {
                pageCount=pageNo-1;
                startItem=(pageCount*this.MaxResults)+1;
            }
            if(isCountZero)
            {
                
                this.Hits += getHitCount();
            }
            string q = string.format(
            '{0}&Summary=context&Highlight=Terms+SummaryTerms&Start={1}&MaxResults={2}',
            new string[]
            {
                this.baseQueryUrl,
                string.valueof(startItem), 
                string.valueof(this.MaxResults)
            });        
        	System.debug('Fetch url: ' + q);
            Dom.Document doc = getXmlFromWebService(q);
             for(SLP_IdolQueryResponse currentResponseItem: parseXmlHits(doc.getRootElement()))
        	{
               lstSLPIdolQueryResponse.add(currentResponseItem);
        	}
        }
        return lstSLPIdolQueryResponse;
    }    
    
    private Dom.Document getXmlFromWebService(string requestUrl)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(requestUrl);
        req.setMethod('GET');
        
        // The Gateway (Secure Reverse Proxy) to our IDOL instance requires its clients to 
        // present a system Digital Badge (certificate issued by the HP Level 2 CA).
        try 
        {
            req.setClientCertificateName('SFDC_Certificate'); // This name is consistent across our saleforce instances
        }
        catch (System.CalloutException e)
        {
            System.debug(Logginglevel.ERROR, 'Unable to find or set SFDC_Certificate.');
        }
        
        Http h = new Http();
        HttpResponse response = h.send(req);
        return response.getBodyDocument();
    }
    
    private integer getHitCount()
    {
        string q = this.baseQueryUrl + '&Print=noresults&Predict=false&MaxResults=' + this.MaxResults;                
        Dom.Document doc = getXmlFromWebService(q);
        integer hits = parseXmlHitCount(doc.getRootElement());
        System.debug('searchHits: ' + hits);
        return hits;
    }
    
    
    // To cut down on class sprawl we'll bend the Single Responsibility Principle (SRP) 
    // and also implement parsing within this class
    
    private static final string AUTN = 'http://schemas.autonomy.com/aci/';
    
    private integer parseXmlHitCount(Dom.XmlNode root)
    {
       Dom.XmlNode response = root.getChildElement('response', null); 
        
       //Added below null condition check, even else part also - DS-India   
       if(response!=null)
       {        
            Dom.XmlNode responseData = root.getChildElement('responsedata', null);
            if('ERROR' == response.getText())
            {
                this.ErrorText = parseResponseDataError(responseData);
                return -1;
            }                        
                
            Dom.XmlNode autnNumHits = responseData.getChildElement('numhits', AUTN);
            return integer.valueof(autnNumHits.getText());
        }
        else
        {
           return -1;
        }
    }
    
    private string parseResponseDataError(Dom.XmlNode responseData)
    {
        Dom.XmlNode autnError = responseData.getChildElement('error', null);
        if(autnError == null)
        {
            return ''; // are you sure this is an error?
        }
        Dom.XmlNode autnErrorString = autnError.getChildElement('errorstring', null);
        Dom.XmlNode autnErrorDescription = autnError.getChildElement('errordescription', null);
        return autnErrorString.getText() + ': ' + autnErrorDescription.getText();        
    }
    
    private List<SLP_IdolQueryResponse> parseXmlHits(Dom.XmlNode root)
    {
        Dom.XmlNode response = root.getChildElement('response', null);
        Dom.XmlNode responseData;
         List<SLP_IdolQueryResponse> responses = new List<SLP_IdolQueryResponse>();
        if(response != null)
        {
            responseData = root.getChildElement('responsedata', null);
            
            //Below code we placed within response null check condition - DS-India          
            if('ERROR' == response.getText())
            {
                this.ErrorText = (responseData == null) ? 'Server did not return response data.' : parseResponseDataError(responseData);
                return new List<SLP_IdolQueryResponse>(); // fail: return empty list
            }
            
            for(Dom.XMLNode autnHit : responseData.getChildElements())
            {
                //Removed by Muthu && 'hit' == autnHit.getName()
                if(AUTN == autnHit.getNamespace() )
                {
                    string url = getChildElementStringValue(autnHit, 'reference', AUTN);
                    string title = getChildElementStringValue(autnHit, 'title', AUTN);  // Title may not always be available
                    string summary = getChildElementStringValue(autnHit, 'summary', AUTN);
                    decimal weight = getChildElementDecimalValue(autnHit, 'weight', AUTN);                
                    SLP_IdolQueryResponse queryResponse = new SLP_IdolQueryResponse(url, weight, title, summary);
                    
                    // TO DO: These extended fields do not really exist yet... we have to make another call to
                    // GetContent for all the document IDs returned by the first query.
                    Dom.XmlNode autnContent = autnHit.getChildElement('content', AUTN);
                    if(autnContent != null)
                    {
                        Dom.XmlNode autnDoc = autnContent.getChildElement('DOCUMENT', null);
                        if(autnDoc != null)
                        {
                            queryResponse.FileType = getChildElementStringValue(autnDoc, 'IMPORTMAGICEXTENSION', null);
                            queryResponse.MimeType = getChildElementStringValue(autnDoc, 'CONTENT-TYPE', null);
                            queryResponse.SizeinBytes = getChildElementLongValue(autnDoc, 'DOCUMENT_SIZE', null);
                            queryResponse.LastUpdated = getChildElementStringValue(autnDoc, 'ATHP_DATE_MODIFIED', null);
                            queryResponse.Language = getChildElementStringValue(autnDoc, 'ATHP_LANGUAGE', null);                        
                        }
                    }                
                    
                    responses.add(queryResponse);
                }
            }
        }
        return responses;
    }
    
    private string getChildElementStringValue(Dom.XMLNode parent, string name, string namespace)
    {
        Dom.XMLNode child = parent.getChildElement(name, namespace);
        return (child == null) ? '' : child.getText();   
    }
    
    private decimal getChildElementDecimalValue(Dom.XMLNode parent, string name, string namespace)
    {
        Dom.XMLNode child = parent.getChildElement(name, namespace);
        return (child == null) ? 0.0 : decimal.valueof(child.getText());
    }
    
    private long getChildElementLongValue(Dom.XMLNode parent, string name, string namespace)
    {
        Dom.XMLNode child = parent.getChildElement(name, namespace);
        return (child == null) ? 0L : long.valueof(child.getText());
    }
}