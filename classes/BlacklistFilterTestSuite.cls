/**
 * Test Suite for testing Chatter blacklist app lifecycle events. As a result, all
 * Helper classes and sub routines will be exercised, therefor eliminating the need
 * to individually test each method of each class which aint real testing anyway as 
 * it isn't truly testing how an app/code will be used.
 * 
 * Author: Quinton Wall - qwall@salesforce.com
 */
@isTest
private class BlacklistFilterTestSuite
{
    
    
    static testMethod void testMatchWholeWords()
    {
        //setup
        String substitStr = '*****';
        String badword = 'foozle';
        disableExistingFilters();
        
        Blacklisted_Word__c blw = new Blacklisted_Word__c();
        blw.Word__c = badword;
        blw.Match_Whole_Words_Only__c = true;
        blw.Prevent_Post_on_Breach__c = false;
        blw.Substitution__c = substitStr;
        insert blw;
        
        //insert a dummy contact we can post on
        //Id cid = insertDummyContact();
        Id cid = BlacklistFilterTestSuite.getSysAdminUser().id;
        
        test.startTest();
        
        //insert a feeditem
        FeedItem p  = new FeedItem();
        p.parentId = cid;
        p.Body = badword+' is tasty';
        Database.SaveResult sr = Database.Insert(p);
        if(!sr.getErrors().isEmpty())
        {
            for(Database.Error er : sr.getErrors())
                System.debug('BLAH->'+er.getMessage());
        }
        System.assert(sr.isSuccess());
        
        //check to make sure that it was converted 
        FeedItem fi = [select Id, Body from FeedItem where Id = :sr.getId()];
        System.assert(fi.Body.contains(substitStr));
        
        //now let's try a comment
        FeedComment fc = new FeedComment();
        fc.feedItemId = fi.Id;
        fc.CommentBody = badword+' is the word';
        Database.SaveResult sr2 = Database.Insert(fc);
        System.assert(sr.isSuccess());
        
        //check to make sure that it was converted 
        List<UserFeed> fc2 = [select Id, (select id, CommentBody from FeedComments where Id = :sr2.getId()) from UserFeed where Id = :sr.getId()];
        System.assert(fc2.get(0).FeedComments.get(0).CommentBody.contains(substitStr));
        
        test.stopTest();
            
    }
    
    static testMethod void testMatchPartialWords()
    {
        //setup
        String substitStr = '*****';
        String badword = 'foozle';
        disableExistingFilters();
        
        Blacklisted_Word__c blw = new Blacklisted_Word__c();
        blw.Word__c = badword;
        blw.Match_Whole_Words_Only__c = false;
        blw.Prevent_Post_on_Breach__c = false;
        blw.Substitution__c = substitStr;
        insert blw;
        
        //insert a dummy contact we can post on
        //Id cid = insertDummyContact();
         //insert a dummy user we can post on
        Id cid = BlacklistFilterTestSuite.getSysAdminUser().id;
        
        test.startTest();
         
        //insert a feeditem
        FeedItem p  = new FeedItem();
        p.parentId = cid;
        p.Body = badword+'woozle is tasty';
        Database.SaveResult sr = Database.Insert(p);
        System.assert(sr.isSuccess());
        
        //check to make sure that it was converted 
        FeedItem fi = [select Id, Body from FeedItem where Id = :sr.getId()];
        System.assert(fi.Body.contains(substitStr));
        
        //now let's try a comment
        FeedComment fc = new FeedComment();
        fc.feedItemId = fi.Id;
        fc.CommentBody = badword+'woozle is the word';
        Database.SaveResult sr2 = Database.Insert(fc);
        System.assert(sr.isSuccess());
        
        //check to make sure that it was converted 
        List<UserFeed> fc2 = [select Id, (select id, CommentBody from FeedComments where Id = :sr2.getId()) from UserFeed where Id = :sr.getId()];
        System.assert(fc2.get(0).FeedComments.get(0).CommentBody.contains(substitStr));
        
        test.stopTest();
    }
    
    
    static testMethod void testMatchPreventBreaches()
    {
        //setup
        String substitStr = '*****';
        String badword = 'foozle';
        disableExistingFilters();
        
        Blacklisted_Word__c blw = new Blacklisted_Word__c();
        blw.Word__c = badword;
        blw.Prevent_Post_on_Breach__c = true;
        blw.Substitution__c = substitStr;
        insert blw;
        
        //insert a dummy contact we can post on
        //Id cid = insertDummyContact();
        Id cid = BlacklistFilterTestSuite.getSysAdminUser().id;
        
        test.startTest();
        
        //insert a feeditem, and check to make sure it fails.
        FeedItem p  = new FeedItem();
        p.parentId = cid;
        p.Body = badword+' is tasty';
        Database.SaveResult sr = Database.Insert(p, false);
        System.assert(!sr.isSuccess());
        
        //now add a good post so we can add a comment to it
        FeedItem p1 = new FeedItem();
        p1.parentId = cid;
        p1.Body = 'This will work';
        Database.SaveResult sr2 = Database.Insert(p1);
        System.assert(sr2.isSuccess());
        
        //now let's try a comment, and check to make sure if fails
        FeedComment fc = new FeedComment();
        fc.feedItemId = sr2.getId();
        fc.CommentBody = badword+' is the word';
        Database.SaveResult sr3 = Database.Insert(fc, false);
        System.assert(!sr3.isSuccess());
        
        test.stopTest();
    }
    
    static testMethod void testCurrentStatusUpdate()
    {
        //setup
        String substitStr = '*****';
        String badword = 'foozle';
        disableExistingFilters();
        
        Blacklisted_Word__c blw = new Blacklisted_Word__c();
        blw.Word__c = badword;
        blw.Match_Whole_Words_Only__c = true;
        blw.Prevent_Post_on_Breach__c = false;
        blw.Substitution__c = substitStr;
        insert blw;
        
        //get a user in the org that we can update a status on
        User u = getSysAdminUser();
        
        test.startTest();
        
        
        ////udate the user's current status, which should fail
        u.currentStatus = badword+' is tasty';
        Database.SaveResult sr = Database.Update(u);
        System.assert(sr.isSuccess());
        
        //check to make sure that it was converted 
        User u2 = [select Id, CurrentStatus from User where Id = :u.Id];
        System.assert(u2.CurrentStatus.contains(substitStr));
        
        test.stopTest();
            
    }
    
    static testMethod void testAddToAudit()
    {
        //setup
        String substitStr = '*****';
        String badword = 'foozle';
        disableExistingFilters();
        
        
        //get a count of how many audit entries are already in the table
        //at the end of our test, there should be two more
        List<Blacklist_Audit__c> auditsPre = [select id from Blacklist_Audit__c];
        Integer currAuditsPre = auditsPre.size();
        
        Blacklisted_Word__c blw = new Blacklisted_Word__c();
        blw.Word__c = badword;
        blw.Add_to_Compliance_Audit__c = true;
        blw.Prevent_Post_on_Breach__c = false;
        blw.Substitution__c = substitStr;
        insert blw;
        
        //insert a dummy contact we can post on
       // Id cid = insertDummyContact();
        Id cid = BlacklistFilterTestSuite.getSysAdminUser().id;
        
        test.startTest();
        
        //insert a feeditem
        FeedItem p  = new FeedItem();
        p.parentId = cid;
        p.Body = badword+' is tasty';
        Database.SaveResult sr = Database.Insert(p);
        System.assert(sr.isSuccess());
        
        //insert a feedcomment
        FeedComment fc = new FeedComment();
        fc.feedItemId = sr.getId();
        fc.CommentBody = badword+' is the word';
        Database.SaveResult sr2 = Database.Insert(fc);
        System.assert(sr2.isSuccess());
        
        List<Blacklist_Audit__c> auditsPost = [select id from Blacklist_Audit__c];
        
        //we should have 2 more entries in the audits table
        //System.assertEquals(currAuditsPre+2, auditsPost.size());
        
        test.stopTest();
    }
    
    /*
    static testMethod Id insertDummyContact()
    {
        Contact c = new Contact();
        c.LastName = 'TestLname';
        c.FirstName = 'TestFname';
        Database.SaveResult sr = Database.Insert(c);
        System.assert(sr.isSuccess());
        return sr.getId();
    }
    */
    
    
    
    static testMethod User getSysAdminUser()
    {
        Profile p = [select id from Profile where name = 'System Administrator'];
        
        User u = [select Id, CurrentStatus from User where ProfileId = :p.Id  LIMIT 1];
        u.email='test@hp.com';
        update u;
        return u;
    }
    
    /**
     * Because we can not guarantee what words are in a users
     * blacklist filter, let's set them all to inactive before running our tests
     */
    static void disableExistingFilters()
    {
        List<Blacklisted_Word__c> bwWordsToUpdate = new List<Blacklisted_Word__c>();
                                        
    
        for(Blacklisted_Word__c bwc : [select Id, is_Active__c from Blacklisted_Word__c])
        {
            bwc.is_Active__c = false;
            bwWordsToUpdate.add(bwc);
        }
        update bwWordsToUpdate;
    }
    
}