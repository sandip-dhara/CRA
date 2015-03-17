/**
 * Convenience wrapper for Blacklist filter processing
 * Author: Quinton Wall - qwall@salesforce.com
 */
public class PatternHelper
{
    public String regexValue {set; get;}
    public Pattern p {set; get;}
    public String substitutionValue {set; get;}
    public boolean preventPostOnMatch {set; get;}
    public Blacklisted_Word__c blacklistedWord {set; get;}
    public String origPostBody {set; get;}
    public String postCreatedById {set; get;}
    public String RecType{set; get;}
    //public ConnectApi.FeedItemInput feedItemI {set; get;}
    

    public PatternHelper(Blacklisted_Word__c bwc)
    {
        regexValue = bwc.RegexValue__c;
        p = Pattern.compile(bwc.RegexValue__c);
        substitutionValue =  bwc.Substitution__c;
        preventPostOnMatch = bwc.Prevent_Post_on_Breach__c;
        RecType = bwc.Type__c;
        blacklistedWord = bwc;
     
    }
    
    /**
     * return a serializable version of the patternhelper
     */
    public PatternHelperSerializable getSerializable()
    {
      //note: postCreatedById will always be null as we dont have access to this in the before insert context
      return new PatternHelperSerializable(blacklistedWord, p.pattern(), origPostBody, postCreatedById);
    }

}