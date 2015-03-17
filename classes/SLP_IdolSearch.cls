public class SLP_IdolSearch
{
    private string DATABASE;
    private string SERVER;
    private integer PAGE_SIZE;
    private integer MAX_HITS;
    
    public SLP_IdolSearch()
    {
        SLP_IDOL_Settings__c s = SLP_IDOL_Settings__c.getOrgDefaults();      
        this.PAGE_SIZE = s.Page_Size__c.intValue();
        this.MAX_HITS = s.Maximum_Hits__c.intValue();
        this.DATABASE = s.Database__c;
        this.SERVER = s.Server_URL__c;
        this.Hits = -1; // -1 sentinel value meaning 'not searched'
        this.CurrentItem= this.PAGE_SIZE; //Added by Muthu
        system.debug('PAGE_SIZE: ' + this.PAGE_SIZE);
        system.debug('MAX_HITS: ' + this.MAX_HITS);
        system.debug('DATABASE: ' + this.DATABASE);
        system.debug('SERVER: ' + this.SERVER);
    }
    
    public integer CurrentItem {get; private set;}
    public integer MaxItem {get; private set;}
    public integer Hits {get; private set;}
    public string SearchValue {get; set;}
    public string ErrorText {get; set;}
    
    public List<SLP_IdolQueryResponse> SearchResults {get; private set;}
    
    public User LoggedinUserDetails
    {
        get
        {
            User u = [Select Name From User where User.id= :UserInfo.getUserId()];
            return u;
        }    
    }

    public string SfInstance
    {
        get
        {
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    public PageReference search() 
    {        
        search(this.SearchValue, 1, -1, this.PAGE_SIZE);
        return null; // return ApexPages.currentPage();        
    }    
    
    public PageReference next() 
    {
        integer endItem = this.CurrentItem + PAGE_SIZE;
        if(endItem > this.MaxItem)
        {
            return ApexPages.currentPage();        
        }
        
        this.CurrentItem += this.PAGE_SIZE;
        search(this.SearchValue, this.CurrentItem, endItem, this.PAGE_SIZE);        
        return ApexPages.currentPage();
    }
    
    public PageReference previous() 
    {
        if(0 > (this.CurrentItem - this.PAGE_SIZE))
        {
            return ApexPages.currentPage();        
        }
        
        this.CurrentItem -= this.PAGE_SIZE;
        integer endItem = this.CurrentItem + this.PAGE_SIZE;
        search(this.SearchValue, this.CurrentItem, endItem, this.PAGE_SIZE);        
        return ApexPages.currentPage();
    }
    
    private void search(string searchText, integer startItem, integer endItem, integer pageSize)
    {
        boolean endIsUnknown = (endItem == -1);
        
      /*  SLP_IdolQuery idol = new SLP_IdolQuery(
            this.SERVER, 
            this.DATABASE, 
            searchText,
            pageSize, 
           this.MAX_HITS, 
            endItem
            );
        
         SLP_IdolQuery idol1 = new SLP_IdolQuery(
            this.SERVER, 
            'SLP', 
            searchText,
            pageSize, 
           this.MAX_HITS, 
            endItem
            );
            */
             SLP_IdolQuery idol = new SLP_IdolQuery();
             
integer pageNo=1;
        
        List<SLP_IdolQueryResponse> results = idol.FetchAll(searchText,pageNo,endItem,'GlobalSearch');
        
         if(endIsUnknown)
        {
            endItem = idol.Hits;
            this.MaxItem = endItem; // now the end is known
        }
        
        
        //List<SLP_IdolQueryResponse> results = idol.Fetch(startItem);
        // List<SLP_IdolQueryResponse> results1 = idol1.Fetch(startItem);
        //List<SLP_IdolQueryResponse> results = idol.FetchAll();
        
       // endItem = ((startItem + pageSize) > endItem) ? endItem : startItem + pageSize;
       // System.debug('Search: items ' + startItem + ' to ' + endItem + ' (of ' + endItem + '.)');
       /*  for(SLP_IdolQueryResponse r: results)
        {
            System.debug('Veeresh url: ' + r.Url + '; weight: ' + r.Weight + '; title: ' + r.Title + '; summary: ' + r.Summary);
            System.debug('fileType: ' + r.FileType + '; mimeType: ' + r.MimeType + '; sizeInBytes: ' + r.SizeInBytes + '; lastUpdated: ' + r.LastUpdated + '; language: ' + r.Language);
        }
        
       for(SLP_IdolQueryResponse r: results1)
        {
           results.add(r);
           }*/
        // Set results
        this.Hits = idol.Hits;
        this.ErrorText = idol.ErrorText;
        this.SearchResults = results;
    }

}