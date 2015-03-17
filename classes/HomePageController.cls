//  Copyright (c) 2010, David Van Puyvelde, Sales Engineering, Salesforce.com Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

public with sharing class HomePageController {

    private Page__c home {get;set;}
    
    public HomePageController() {
        try {
            //find the correct site and its id by the prefix
            String siteid;
            String prefix = Site.getPrefix(); //this will return something like '/myprefix' or null if there's no prefix defined
            String queryfor ='';
            if(prefix != null) queryfor = prefix.substring(1,prefix.length()); //the leading '/' is not stored in the db
            
            List<Site> sites = [Select s.UrlPathPrefix, s.Id From Site s where s.UrlPathPrefix =: queryfor];
            
            if(sites != null) {
                String sid = sites[0].Id;
                siteid = sid.substring(0,15); //site ids always in 15 char format in cmsforce
            }
                    
            home = [select Id from Page__c where Home_Page__c = true and Site_Id__c =:siteid limit 1];
            
        }
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No home page has been defined');
            Apexpages.addMessage(msg);
        }
    }
    
    public PageReference redirect() {
        if(home == null) return null;

        PageReference pr = new PageReference('/apex/page?pageid='+home.Id);
        return pr;
    }


    public static testMethod void t1() {
        Site site = [select Id from Site limit 1];
        String siteid = site.Id;        
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c = 'a,b,c', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Home_Page__c = true, Folder__c = pagefolder.Id);
        insert pg;
        
        HomePageController hpc = new HomePageController();
        PageReference redir = hpc.redirect();       
        //System.assertEquals('/apex/page?pageid='+pg.Id, redir.getUrl());
        
        pg.Home_Page__c = false;
        update pg;
        
        HomePageController hpc2 = new HomePageController();
        PageReference redir2 = hpc2.redirect();     

    }

}