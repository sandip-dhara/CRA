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

public with sharing class contentblockcomponentController {

    public String name {get;set;} //the name attribute of this component. This is passed as an attribute from the template. See setter method below
    //public Page__c page; //which page are we in ?
    public List<PageToItem__c> pagetoitems; //what items are we displaying
    public List<ContentBlockItem__c> items;//the content that should appear on the page in this content block
    
    public PageReference pagetemplatename {get;set;}
    
    
    public List<ContentBlockItem__c> getItems() {
        System.debug(System.currentPageReference().getParameters());
        System.debug('Name : ' + name);
        String pageid = System.currentPageReference().getParameters().get('pageid');


        //for template preview mode: if there's no page id, just give back sample content items to show their position
        if(pageid == null) {
            //check if it's a preview of a 'get the contentblock call' ... see the save trigger on contentblockitem
            String register = System.currentPageReference().getParameters().get('register');
            items = new List<ContentBlockItem__c>();
            //normal preview
            String sample;
            if(register == null) sample = '<span id="contentblockitem" name="'+name+'" style="color:red; font-weight:bold;">{'+name+'}</span>';
            //we're telling the page that we need it's content for registering the contentblock names by passing it a 'register' url param
            //get the contentblock names, showing double {{...}} here in order for the parser to pick up the contentblock names (and not javascript methods etc ...)
            if(register != null) sample = '<span id="contentblockitem" name="'+name+'" style="color:red; font-weight:bold;">{{'+name+'}}</span>';
            items.add(new ContentBlockItem__c(Name = name, Content__c = sample));
            return items;
        }       

        //this part is when the content block needs to show the HTML
        pagetoitems = [Select p.Page__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c, p.ContentBlockItem__r.PageToItemId__c,
                     p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                     p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                     p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c, p.ContentBlockItem__r.Web_Form__c, p.ContentBlockItem__c 
                     From PageToItem__c p where Display_in_ContentBlock__c =:name and Page__c =:pageid order by Order__c];
                     
        //System.debug('Pageitems : ' + pagetoitems);
        items = new List<ContentBlockItem__c>();
        for(PageToItem__c pi:pagetoitems) {
            ContentBlockItem__c cbi = pi.ContentBlockItem__r;
            cbi.PageToItemId__c = pi.Id;
            items.add(cbi);
        }
        //workaround
        String pageName = [Select  p.PageTemplate__r.VisualForce_Page_Name__c, p.PageTemplate__c, p.PageTemplate__r.Name, p.Name, p.Id
                From Page__c p where id =:pageid].PageTemplate__r.VisualForce_Page_Name__c;
                
        pagetemplatename = new PageReference('/apex/'+pageName);
        return items;
    }
    
    
    public static testMethod void t1() {
        contentblockcomponentController cbc = new contentblockcomponentController();
        Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
        //template folder
        CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c = 'a,b,c', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
        insert pg;
        
        PageReference pr = Page.page;
        
        Test.setCurrentPageReference(pr);
        //without params : preview mode
        cbc.getItems();
        System.assert(cbc.items != null);
        //with the register param : contentblockname discovery mode
        pr.getParameters().put('register','1');             
        cbc.getItems();
        //with a real pageid : page serving mode
        pr.getParameters().put('pageid',pg.Id);
        cbc.getItems();
        
    }

}