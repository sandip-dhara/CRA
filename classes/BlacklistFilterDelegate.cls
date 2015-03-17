/**
 * Blacklist filter delegate contains all of the logic to implement keyword filtering
 * based on the Blacklisted_Word__c entity
 * Author: qwall@salesforce.com
 * 6/7/2013: patched version for Dell.
 */
public class BlacklistFilterDelegate
{
    public static Integer FEED_POST = 1;
    public static Integer FEED_COMMENT = 2;
    public static Integer USER_STATUS = 3;
    FeedItemBlacklisting feedObj = new FeedItemBlacklisting();
        
    List<PatternHelper> patterns {set; get;} 
    Map<Id, PatternHelper> matchedPosts {set; get;}
    
    public BlacklistFilterDelegate()
    {
         patterns = new List<PatternHelper>();
         matchedPosts = new Map<Id, PatternHelper>(); 
         preparePatterns();
    }
    
    private void preparePatterns()
    {
         //fetch the blacklisted words
        List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                            Add_to_Compliance_Audit__c, Custom_Expression__c,
                                            Prevent_Post_on_Breach__c,type__c
                                         from Blacklisted_Word__c where is_Active__c = true];
    
        for(Blacklisted_Word__c bwc : bwWords)
        {
            patterns.add(new PatternHelper(bwc));
        }
        
    }
    
    /**
     * Given a list of FeedItems, filter them against the blacklisted words
     */
    public List<FeedItem> filterFeedItems(List<FeedItem> fi)
    {
        return filterBodyForFeedItems(fi);
    }
    
    /**
     * Given a list of FeedComments, filter them against the blacklisted words
     */
    public List<FeedComment> filterFeedComments(List<FeedComment> fc)
    {
        return filterBodyForFeedComments(fc);
    }
    
    /**
     * Given a list of Users, filter them against the blacklisted words
     */
    public List<User> filterUserStatus(List<User> users)
    {
        return filterBodyForUserStatus(users);
    }
    
    
    
    
    
     private List<FeedItem> filterBodyForFeedItems(List<FeedItem> sobjs)
    {
        
        List<FeedItem> updatedSobjs = new List<FeedItem>();
        
         Matcher m;
        String body = null;
        string feedParentId;
    
         for (FeedItem f : sobjs)
         {
                boolean preventPost = false;
                String matchedWord = 'REGEX';
                body = f.Body;
                feedParentId = ((FeedItem)f).ParentId;
                
                if(feedParentId.StartsWith('006')){
                    feedObj.filterwords(f);
                    }
                else{
                for(PatternHelper ph : patterns)
                {
                    //System.debug('PH: WORD:'+ph.blacklistedWord.Word__c);
                    //System.debug('PH PREVENT ON BREACH:'+ph.blacklistedWord.Prevent_Post_on_Breach__c);
                    //System.debug('PH ADD TO AUDIT:'+ph.blacklistedWord.Add_to_Compliance_Audit__c);
                     //System.debug('POST IS:'+body + 'AND DOES IT MATCH WORD:'+ph.blacklistedWord.Word__c+'-->' +myMatcher.matches());
                     
                     if(body != null &&  body != '')
                     {
                     Matcher myMatcher = ph.p.matcher(body);
                      
                       if(myMatcher.find())
                       {
                             body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                             
                              if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                              {
                                          ph.origPostBody = f.Body;
                                          //System.debug('ADDING ORIG POST BODY:'+ph.origPostBody);
                                          ph.postCreatedById = f.createdById;
                                          matchedPosts.put(ph.blacklistedWord.id, ph);
                              }
                              
                             //only need to set one message per breach - on the first breach
                             if(ph.preventPostOnMatch)
                             {
                                //System.debug('PH PREVENTING WITH WORD:'+ph.blacklistedWord.Word__c);
                                 if(!String.isEmpty(ph.blacklistedWord.Custom_Expression__c))
                                        matchedWord = 'Custom Regular Expression';
                                  else
                                        matchedWord = ph.blacklistedWord.Word__c;   
                                  preventPost = true; 
                                  break;
                             }
                       }
                       
                 }
                }
               
                  
                if(preventPost)  
                    f.addError('xxPost prevented due to use of a blacklisted word: '+matchedWord);
                else
                {
                        f.Body = body;          
                }
                updatedSobjs.add(f);
            }
            
         }
         
          doAudit();
         
         return updatedSobjs;
    }
    
    private List<User> filterBodyForUserStatus(List<User> sobjs)
    {
        
        List<User> updatedSobjs = new List<User>();
        
         Matcher m;
        String body = null;
    
         for (User f : sobjs)
         {
                boolean preventPost = false;
                String matchedWord = '';
                body = f.CurrentStatus;
                
                for(PatternHelper ph : patterns)
                {
                        Matcher myMatcher = ph.p.matcher(body);
                      
                       if(myMatcher.find())
                       {
                             body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                             
                          if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                          {
                                      ph.origPostBody = f.CurrentStatus;
                                      ph.postCreatedById = f.Id;
                                      matchedPosts.put(ph.blacklistedWord.id, ph);
                          }
                          
                         //only need to set one message per breach - on the first breach
                          if(!preventPost)
                          {
                            if(ph.preventPostOnMatch)
                            {
                              preventPost = true;
                              matchedWord = ph.blacklistedWord.Word__c;
                            }
                          }
                          String postBodyCheck = ph.origPostBody;
                          if (postBodyCheck.contains('HPFS Engagement has been triggered'))
                              preventPost = false;
                       }
                 }
                 
                if(preventPost)   //note: should we display the blacklisted word to inform user of what they did?
                     f.addError('Post prevented due to use of a blacklisted word: '+matchedWord);
                else
                {
                        f.CurrentStatus = body; 
                        updatedSobjs.add(f);
                }
         }
         
         doAudit();
         
         return updatedSobjs;
    }
    
     private List<FeedComment> filterBodyForFeedComments(List<FeedComment> sobjs)
    {
        
        List<FeedComment> updatedSobjs = new List<FeedComment>();
        
         Matcher m;
        String body = null;
        string feedParentId;
    
         for (FeedComment f : sobjs)
         {
                boolean preventPost = false;
                String matchedWord = '';
                body = f.CommentBody;
                feedParentId = ((FeedComment)f).ParentId;
                if(feedParentId.StartsWith('006')){
                    feedObj.filterwords(f);
                    }
                else{
                for(PatternHelper ph : patterns)
                {
                        Matcher myMatcher = ph.p.matcher(body);
                      
                       if(myMatcher.find())
                       {
                             body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                             
                          if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                          {
                                      ph.origPostBody = f.CommentBody;
                                      ph.postCreatedById = f.CreatedById;
                                      matchedPosts.put(ph.blacklistedWord.id, ph);
                          }
                          
                         //only need to set one message per breach - on the first breach
                          if(!preventPost)
                          {
                                if(ph.preventPostOnMatch)
                                {
                                  preventPost = true;
                                  matchedWord = ph.blacklistedWord.Word__c;
                                }
                          }
                       }
                 }
                
                if(preventPost)   //note: should we display the blacklisted word to inform user of what they did?
                     f.addError('Post prevented due to use of a blacklisted word: '+matchedWord);
                else
                {
                        f.CommentBody = body; 
                        updatedSobjs.add(f);
                }
            }
         }
         
         doAudit();
         
         return updatedSobjs;
    }
   
    
    //END TEST
  
  
    /**
     * Take the matched posts, serialize them (so we can send them to a future method), and async to insert into audit table
     * This allows us to insert audits even if the feeditem transaction rollsback.
     * 6/13/2013 - Added qwall@salesforce.com
     */
    private void doAudit()
    {
        List<String> serializedPH = new List<String>();
    
        for(PatternHelper p : matchedPosts.values())
        {
            serializedPH.add(JSON.serialize(p.getSerializable()));
        }
        //System.debug('FIRING FUTURE WITH THIS MANY RECORDS:'+serializedPH.size());
        doAuditFuture(serializedPH);
    }
    
    /**
     * If a blacklisted word is flagged as save to audit, lets write it to the blacklist audit list.
     * Accepts a serialized list of pattern helpers.
     */
     @future
    static void doAuditFuture(List<String> mposts)
    {
        //System.debug('IN AUDIT FUTURE');
        List< Blacklist_Audit__c> audits = new List<Blacklist_Audit__c>();
        Blacklist_Audit__c blaudit = null;
        PatternHelperSerializable p = null;
     
       //deserialize and work with pattern helper
       for (String ser : mposts)
       {
        //System.debug('JSON:'+ser);
          p = (PatternHelperSerializable) JSON.deserialize(ser, PatternHelperSerializable.class);
           
           //check for audit actions
            if(p.blacklistedWord.Add_to_Compliance_Audit__c)
            {
                //System.debug('FOUND AN AUDIT MATCH. ORIG POST:'+p.origPostBody);
               blaudit = new Blacklist_Audit__c();
               blaudit.Breached_By__c = p.postCreatedById;
               blaudit.Unscrubbed_Post__c = p.origPostBody;
             
               if(p.blacklistedWord.Custom_Expression__c != NULL)
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Custom_Expression__c;
               else
                   blaudit.Blacklisted_Word__c = p.blacklistedWord.Word__c;
              
               audits.add(blaudit);
            }
            
            //check for notifier actions
            //TODO
        }
        
        if(!audits.isEmpty())
        {
            //System.debug('GOT SOME AUDITS TO ADD');
            Database.SaveResult[] srList = Database.insert(audits);
            
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Blacklist fields that affected this error: ' + err.getFields());
                    }
                }
            }
             
        }     
    }
}