/******************
Author: Abrar
Date: 27-09-2012
Description: Class for 
Blacklisting of Words for UKPS oppties
******************/

Public class FeedItemBlacklisting
{

     public static List<PatternHelper> patterns {set; get;} 
     public static Map<Id, PatternHelper> matchedPosts {set; get;}
     String FieldDes = null;
     String OpName = null;
     String OpUpdate = null;
     String strOld;
     String strName;
     String strUpdate;
     Boolean PreventPost=False;
     //public Opportunity op;
     List<Opportunity> UpdatedOpty= new List<Opportunity>();
    
     public FeedItemBlacklisting()
     {

        system.debug('inside the constructor');
        patterns = new List<PatternHelper>();
        matchedPosts = new Map<Id, PatternHelper>();
        /*map<Id, Account> AccountInfo=new Map<Id, Account>();
        List<Id> AccountIds = new List<Id>();
        List<Blacklisted_Word__c> bwWordsUKPS;
        List<Blacklisted_Word__c> bwWordsUSPS;
        List<Blacklisted_Word__c> bwWordsGeneral; */
        
        preparePatterns();
 
        }
        public void preparePatterns()
        {
            

            List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                            Add_to_Compliance_Audit__c, Custom_Expression__c,
                                            Prevent_Post_on_Breach__c, Type__c
                                            from Blacklisted_Word__c where is_Active__c = true
                                            ];
            for(Blacklisted_Word__c bwc : bwWords)
            {
                patterns.add(new PatternHelper(bwc));
                system.debug('PatternValue'+patterns[0].blacklistedWord);
            }

        }
        
        Public void BlacklistingLogic(SObject op, String country)
        {
  
            string varcountry = country;
            List<SObject> updatedSobjs = new List<SObject>();
            system.debug('VarCountry'+varcountry);
            Matcher m;
            String body = null;
            boolean preventPost = false;
                
            if(op instanceOf FeedItem)
              body = ((FeedItem)op).Body;
              system.debug('body in logic'+body);
              
            if(op instanceOf FeedComment)
              body = ((FeedComment)op).CommentBody;
              system.debug('body in logic'+body);
              
            boolean foundMatch = false;
            String strOld = '';
            
            for(PatternHelper ph : patterns)
            {
               system.debug('## in for Loop country '+varcountry);           
                if(ph.RecType==varcountry || ph.RecType==null)
                {                       
                    foundMatch = false;
                      
                    if(body == null)
                        body = '';
                    strOld = body;
                    system.debug('feedbody'+strOld);
                    body = body.replaceAll(ph.regexValue, ph.substitutionValue);
                    system.debug('body in for loop logic'+body);
                    if(strOld.compareTo(body) != 0)
                        foundMatch = true;
                        
                    if(foundMatch)
                    {
                        if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                        {
                            if(op instanceOf FeedItem)
                            {
                                     ph.origPostBody = ((FeedItem)op).Body;
                                     ph.postCreatedById = ((FeedItem)op).createdById;
                                     matchedPosts.put(ph.blacklistedWord.id, ph);
                            }
                            else if(op instanceOf FeedComment)
                            {
                                     ph.origPostBody = ((FeedComment)op).CommentBody;
                                     ph.postCreatedById = ((FeedComment)op).createdById;
                                     matchedPosts.put(ph.blacklistedWord.id, ph);
                            }
                            
                        }       
                        if(ph.preventPostOnMatch)
                        preventPost = true;
                        system.debug('PreventPostOnMatch'+ph.preventPostOnMatch);
                          
      
      
                    }
            }
            
            if(preventPost)   //note: should we display the blacklisted word to inform user of what they did?
            op.addError('Post prevented due to use of a blacklisted word.');
            else
            {
                if(op instanceOf FeedItem)
                {
                   
                        FeedItem fi = (FeedItem)op;
                        fi.Body = body;
                        system.debug('before updating feed  ' +fi.body);
                        updatedSobjs.add(fi);
                        system.debug('@@in the list'+updatedSobjs);
                } 
                else if(op instanceOf FeedComment)  
                {
                        FeedComment fi = (FeedComment)op;
                        
                        
                            fi.CommentBody = body;
                            system.debug('before updating feed  ' +fi.Commentbody);
                            updatedSobjs.add(fi);
                             system.debug('@@in the listcomment'+updatedSobjs);
                        
                        
                }
                                    
            }
        }
         
     }   
        
       
    public void filterwords(SObject Oblist)
    {
        system.debug('OptyList'+Oblist);
        Matcher m;
        string feedParentId;
        opportunity feedOp;
        SObject opfeed = Oblist;
        String body;
        Account actinfo;

            if(opfeed instanceof FeedItem )
            {
                body = ((FeedItem)opfeed).Body;
                feedParentId = ((FeedItem)opfeed).ParentId;
                if(feedParentId.StartsWith('006'))
                 feedOp =[select id,name,accountid, account_blacklist__c,Account.Confidential_Account__c from opportunity where id= :((FeedItem)opfeed).parentid];
                system.debug('AccountCtry'+feedOp.account_blacklist__c);
                 //actinfo = [select id,Confidential_Account__c from Account where Id=:feedOp.Id];
                system.debug('Account privateflag'+feedOp.Account.Confidential_Account__c);
                if(feedOp.Account.Confidential_Account__c == False)
                {
                BlacklistingLogic(opfeed, null);
                system.debug('Inside logic##');
                }
                Else
                {
                BlacklistingLogic(Opfeed, feedOp.account_blacklist__c); 
                 system.debug('inside logic ELSE##');
                 }    
            }
            else
            {
                body = ((FeedComment)opfeed).CommentBody;
                feedParentId = ((FeedComment)opfeed).ParentId;
                if(feedParentId!=null && feedParentId.StartsWith('006'))
                 feedOp = [select id,name,accountid, account_blacklist__c, Account.Confidential_Account__c from opportunity where id= :((FeedComment)opfeed).parentid];
                //system.debug('AccountCtry'+feedOp.account_blacklist__c);
                 if(feedOp!=null && feedOp.Account.Confidential_Account__c == false)
                BlacklistingLogic(opfeed, null);
               Else
               {
                //System.debug('Inside Else of Logic' +feedOp.account_blacklist__c);
                if(feedOp!=null){BlacklistingLogic(Opfeed, feedOp.account_blacklist__c);}
                else {BlacklistingLogic(opfeed, null);}
                } 
            }
        

    }
}