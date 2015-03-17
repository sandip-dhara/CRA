// Global so that it can be used by @RemoteAction
global class SLP_IdolQueryResponse
{
    public SLP_IdolQueryResponse (string url, decimal weight, string title, string summary)
    {
        this.Url = url;
        this.Weight = weight;
        this.Title =  string.isNotEmpty(title) ? title : url.substringAfterLast('/');
        this.Summary = summary; // This is a "short" summary defined by IDOL.        
    }
    
    // Critical Attributes
    public string Url {get; private set;}
    public decimal Weight {get; private set;}
    public string Title {get; private set;}
    public string Summary {get; private set;}
    
    // Additional Attributes: will be blank for now
    public string FileType {get; set;}
    public string MimeType {get; set;}
    public long SizeInBytes {get; set;}
    public string LastUpdated {get; set;} // probably date or datetime but using string for now
    public string Language {get; set;}
}