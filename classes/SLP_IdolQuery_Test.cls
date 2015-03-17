@isTest
private class SLP_IdolQuery_Test
{
    // INTERNAL SERVER: http://c0004793.itcs.hp.com:9000
    // EXTERNAL GATEWAY: https://it-services-gw-csc-itg.external.hp.com/gw/esit/sfdc/idol
    private final static string DATABASE = 'GSS_SIC';
    private final static string SERVER = 'https://it-services-gw-csc-itg.external.hp.com/gw/esit/sfdc/idol';
    private final static integer PAGE_SIZE = 10;
    private final static integer MAX_HITS= 5000;
    private final static string SEARCH_TEXT = 'Barcelona';    
    private static string BASE_QUERY_MOCK;
    
    static
    {
        BASE_QUERY_MOCK = string.format('{0}/Action=query&Databasematch={1}&Text={2}&', new string[] {SERVER, DATABASE, SEARCH_TEXT});        
        system.debug('PAGE_SIZE: ' + PAGE_SIZE);
        system.debug('MAX_HITS: ' + MAX_HITS);
        system.debug('DATABASE: ' + DATABASE);
        system.debug('SERVER: ' + SERVER);
        system.debug('BASE_QUERY: ' + BASE_QUERY_MOCK);
    }

    static testMethod void searchForKeyword_validateHits()
    {  
        // Setup Mock
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock(); 
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'text/xml');
        multimock.setStaticResource(BASE_QUERY_MOCK + 'Print=noresults&Predict=false&MaxResults=5000', 'SLP_IdolTestStep1');
        multimock.setStaticResource(BASE_QUERY_MOCK + 'Summary=context&Highlight=Terms+SummaryTerms&Start=1&MaxResults=10', 'SLP_IdolTestStep2');
        multimock.setStaticResource(BASE_QUERY_MOCK + 'Summary=context&Highlight=Terms+SummaryTerms&Start=11&MaxResults=20', 'SLP_IdolTestStep3');
		Test.setMock(HttpCalloutMock.class, multimock);
        
        // Run Test
        SLP_IdolQuery idol = new SLP_IdolQuery(SERVER, DATABASE, SEARCH_TEXT, PAGE_SIZE, MAX_HITS);
        
        for(integer i = 1; i < idol.Hits; i += PAGE_SIZE)
        {
            List<SLP_IdolQueryResponse> results = idol.Fetch(i);
            for(SLP_IdolQueryResponse r: results)
            {
                System.debug('url: ' + r.Url + '; weight: ' + r.Weight + '; title: ' + r.Title + '; summary: ' + r.Summary);
                // TO DO: validate/assert            
            }            
        }
        
        // Validate Results: fail if we don't get the expected 20 rows
        integer expectedHits = 20;
        string msg = string.format('Expected {0} hits but got {1} instead.', new string[] {string.valueof(expectedHits), string.valueof(idol.Hits)});
        System.assertEquals(expectedHits, idol.Hits, msg);
    }   
}