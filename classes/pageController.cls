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

public with sharing class pageController {

    public Page__c page {get;set;}
    public Integer expires {get;set;}
    public String pagetemplatename {get;set;}
    public String instance {get;set;}
    public String SiteName{get;set;}
    public List<String> MyList = new List<String>();
    public List<String> MyList2 = new List<String>();
    public Page__c objpage{get;set;}
    public string ids{get;set;}
    public string pageid{get;set;}
    public  pageController() {
        
        if(System.currentPageReference().getParameters().get('pagename') != null){
            String temp = System.currentPageReference().getParameters().get('pagename');
            List<Page__c> lst = [select id from Page__c where FriendlyUrl__c =:temp limit 1];
            if(lst.size() > 0){
                pageid = lst[0].id;    
            }
        }
        if(System.currentPageReference().getParameters().get('pageid') != null){
            pageid = System.currentPageReference().getParameters().get('pageid');    
        }
        
        if(System.currentPageReference().getParameters().get('tab') != null){
            if(System.currentPageReference().getParameters().get('tab') == 'true'){
                Cookie objCookie = new Cookie('tab', 'true', null, -1, false);
                ApexPages.currentPage().setCookies(new Cookie[]{objCookie});                
            }    
        }
        
        if(pageid == null){
            List<Page__c> lst = [select id from Page__c where FriendlyUrl__c = 'Home' limit 1];
            if(lst.size() > 0){
                pageid = lst[0].id;    
            }
        }   
        
        SiteName = '';
        try {
            if(pageid != null && pageid != ''){
                page = [Select  p.PageTemplate__r.VisualForce_Page_Name__c, p.PageTemplate__c, p.PageTemplate__r.Name, p.Name, p.Cache_expires__c, p.Id
                From Page__c p where id =:pageid];  //IsSecurePage__c  //remove for unsecure to secure
            }else{
                page = [Select  p.PageTemplate__r.VisualForce_Page_Name__c, p.PageTemplate__c, p.PageTemplate__r.Name, p.Name, p.Cache_expires__c, p.Id
                From Page__c p where Home_Page__c = true LIMIT 1];  //IsSecurePage__c  //remove for unsecure to secure
            }
            
            pagetemplatename = page.PageTemplate__r.VisualForce_Page_Name__c;           
            system.debug('pageid****' +page.id);
            
            //set the caching expiry
            if(page.Cache_expires__c != null) {
                Double dexp = page.Cache_expires__c;
                expires = dexp.intValue();
            }
            else {
                expires = 600;
            }
            if(CMSForceDomain__c.getAll().get('cmsforcedomain') != null) instance = Encodingutil.urlEncode(CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c, 'UTF-8');
            //workaround for bug #W-638516
            System.currentPageReference().getParameters().put('pagetemplatename', pagetemplatename);
            SiteName = Site.getname();
           
        }
        catch(QueryException qe) {
            pagetemplatename = 'Id error :';
            Apexpages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR, 'No page found for page id ' + pageid));
        }
        
        
       // return null;
        
    }
    
    public pagereference RedirectURL(){
        
        if(!new hpCommon().IsUserLoggedIn()){
            if(pageid != null){
                String url = '';
                List<Page__c> ob = new List<Page__c>();
                ob = [select id, FriendlyUrl__c from Page__c where id =:pageid limit 1]; //IsSecurePage__c  
                if(ob.size() > 0){
                   /* if(ob[0].IsSecurePage__c){
                        if(ob[0].FriendlyUrl__c == 'Home'){
                            url = hpCommon.getURL('default');
                            system.debug('url************');
                        }else{
                            if(hpCommon.GetLoginType() == 'siteuser')
                                url = hpCommon.getURL('memberlogin')+'?rurl='+hpCommon.getURL(ob[0].FriendlyUrl__c);
                            else
                                url = hpCommon.getURL('memberlogin')+'&rurl='+hpCommon.getURL(ob[0].FriendlyUrl__c);
                        }
                        if(url != ''){
                            pagereference page = new pagereference(url);
                            page.setRedirect(true);
                            return page;
                        }
                    }    */ //comment in case of secure to secure
                }
            }
        } 
        return null;  
    }
    
   
    
    
   
    
   private static testMethod void t1() {
        Site site = [select Id from Site limit 1];
        String siteid = site.Id;        
        //set up page and template folders
        CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
        insert pagefolder;
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
        insert templatefolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage',FriendlyUrl__c ='unique', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
        insert pg;
        
        PageReference pr = Page.page;
        pr.getParameters().put('pageid', pg.Id);
        pr.getParameters().put('pagename', 'unique');
        pr.getParameters().put('tab', 'true');
        Test.setCurrentPageReference(pr);
        
        pageController pc = new pageController();
         pc.RedirectURL();
        System.assertEquals(pc.pagetemplatename, 'TestTemplate');       
        
        //create a controller with no pageid parameter
        pr.getParameters().remove('pageid');
         pr.getParameters().remove('pagename');
        pageController pc2 = new pageController();
       // System.assertEquals(pc2.pagetemplatename, 'Id error :');
        
        pc2.RedirectURL();
        
    } 

}