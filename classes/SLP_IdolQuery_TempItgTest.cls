public class SLP_IdolQuery_TempItgTest
{
    // INTERNAL SERVER: http://c0004793.itcs.hp.com:9000
    // EXTERNAL GATEWAY: https://it-services-gw-csc-itg.external.hp.com/gw/esit/sfdc/idol
    private static final SLP_IDOL_Settings__c appSettings; // SalesForce Custom Settings object (application global)
    private static final string DATABASE;
    private static final string SERVER;
    private static final integer PAGE_SIZE;
    private static final integer MAX_HITS;    

    static // cool... Apex supports static CTORs
    {
        // Note that by default SalesForce won't let you access pre-defined data (such as Custom Settings) 
        // so this is one reason this class cannot markled as a unit test.
        appSettings = SLP_IDOL_Settings__c.getOrgDefaults();
        
        PAGE_SIZE = appSettings.Page_Size__c.intValue();
        MAX_HITS = appSettings.Maximum_Hits__c.intValue();
        DATABASE = appSettings.Database__c;
        SERVER = appSettings.Server_URL__c;
        system.debug('PAGE_SIZE: ' + PAGE_SIZE);
        system.debug('MAX_HITS: ' + MAX_HITS);
        system.debug('DATABASE: ' + DATABASE);
        system.debug('SERVER: ' + SERVER);
    }
   
    public static void go()
    {         
        // Run Test
        string test = 'Barcelona and \"Big Data\"';        
        //string test = 'I me we'; //stop words only
        SLP_IdolQuery idol = new SLP_IdolQuery(SERVER, DATABASE, test, PAGE_SIZE, MAX_HITS);
        if(idol.ErrorText != '')
        {
             System.debug('ErrorText: ' + idol.ErrorText);
        }
        
        // Page through the results
        final integer MAX_CALLOUTS_ALLOWED = 10;
        integer checkLimit = 1;
        for(integer i = 1; i < idol.Hits && checkLimit < MAX_CALLOUTS_ALLOWED; i += PAGE_SIZE) 
        {
            checkLimit++;
            System.debug(string.format('page frame: item #{0}, page size: {1}; total hits: {2}',
                 new string[] {string.valueof(i), string.valueof(PAGE_SIZE), string.valueof(idol.Hits)}));
            
            List<SLP_IdolQueryResponse> results = idol.Fetch(i);
            for(SLP_IdolQueryResponse r: results)
            {
                // Until we build a UI to consume, dump results for informal test
                System.debug('url: ' + r.Url + '; weight: ' + r.Weight + '; title: ' + r.Title + '; summary: ' + r.Summary);
            }            
        }
        
        if(checkLimit == MAX_CALLOUTS_ALLOWED)
        {
            System.debug('We hit the callout limit per transaction so we stopped early');
        }
        
        // Validate Results... NOTE: if content changes we may need to adjust
        // ...that's another reason why this isn't a true unit test.
        integer minimalHits = 20;
        string msg = string.format('Expected at least {0} hits but got {1} instead.', 
                                   new string[] {string.valueof(minimalHits), string.valueof(idol.Hits)});
        System.assert(idol.hits > minimalHits, msg);
    }   
}