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

public with sharing class PageItemEditExtension {

    public ContentBlockItem__c contentblock {get;set;}
    public PageToItem__c pagetoitem {get;set;}
    public List<SelectOption> blocknameselect {get;set;}
    private Boolean console = false;
    private Boolean fullscreen = false;
    private String currentpage = '';
    
    //CONSTRUCTOR
    public PageItemEditExtension(Apexpages.Standardcontroller con) {
        this.pagetoitem = (PageToItem__c)con.getRecord();
        //register console and/or fullscreen mode
		if(System.currentPageReference().getParameters().get('console') == 'true') console = true;
		if(System.currentPageReference().getParameters().get('fullscreen') == 'true') fullscreen = true;
		if(System.currentPageReference().getParameters().get('currentpage') != null) currentpage = System.currentPageReference().getParameters().get('currentpage');
    }
    
    //this method is called in the apex action attribute. It will redirect to the webformeditor if the content is a form instead of HTML
    public PageReference checkType() {
        String ptid = System.currentPageReference().getParameters().get('id');
        String contentblocknames;
        //new pagetoitem
        if(ptid == null ) {
            ID masterpage = pagetoitem.Page__c;
            //compensate for 'new item button' in the console where the fields are not prefilled as they are from the standard page
            //and a link doesn't exist to a Page__c object
            Boolean console = false;
            if(masterpage == null) {
            	masterpage = System.currentPageReference().getParameters().get('masterpage');
            	console = true;
            }
            //Find the right pagetemplate id and contentblock names via the page
            Page__c p = [Select p.Id, p.PageTemplate__r.ContentBlockNames__c, p.PageTemplate__c From Page__c p where Id =:masterpage];
            if(console) pagetoitem.Page__c = p.Id;
            contentblocknames = p.PageTemplate__r.ContentBlockNames__c;
            contentblock = new ContentBlockItem__c();
        }
        
        
        
        //existing pagetoitem edit
        if(ptid != null) {
            pagetoitem = [Select p.Page__r.PageTemplateVFPage__c, p.Page__r.PageTemplate__c, p.Page__r.Name, p.Page__r.Id, p.Order__c, 
                            p.Page__c, p.Id, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Content__c,
                            p.ContentBlockItem__r.LastActivityDate, p.ContentBlockItem__r.SystemModstamp, p.ContentBlockItem__r.LastModifiedById, 
                            p.ContentBlockItem__r.LastModifiedDate, p.ContentBlockItem__r.CreatedById, p.ContentBlockItem__r.CreatedDate, 
                            p.ContentBlockItem__r.Name, p.ContentBlockItem__r.Id, p.ContentBlockItem__r.Type__c, p.ContentBlockItem__r.Web_Form__c, p.ContentBlockItem__c,
                            p.Page__r.PageTemplate__r.VisualForce_Page_Name__c,p.Page__r.PageTemplate__r.ContentBlockNames__c
                            From PageToItem__c p where Id =: ptid];
            //set the correct contentblock
            contentblock = pagetoitem.ContentBlockItem__r;
            contentblocknames = pagetoitem.Page__r.PageTemplate__r.ContentBlockNames__c;
        }

        
        //set up the select options for the contentblock names where the user can choose to display the content
        if(contentblocknames != null) {
            List<String> splitnames = contentblocknames.split(',');
            blocknameselect = new List<Selectoption>();
            for(String s:splitnames) {
                Selectoption so = new Selectoption(s,s);
                blocknameselect.add(so);
            }
            //the console editor will already pass on the contentblock based on where the user clicked in the page
            String cbname = System.currentPageReference().getParameters().get('cbname');
            if(cbname != null) pagetoitem.Display_in_Contentblock__c = cbname;
        }
        if(pagetoitem.ContentBlockItem__r.Type__c == 'WebForm') {
        	String redirectto = '/apex/WebFormEditor?id='+pagetoitem.ContentBlockItem__r.Web_Form__c;
        	if(console) redirectto = redirectto + '&console=true';
        	if(fullscreen) redirectto = redirectto + '&fullscreen=true';
        	if(currentpage != null) redirectto = redirectto + '&currentpage='+currentpage;
            return new PageReference(redirectto);
        }
        else {
            return null;
        }
    }
    
    public PageReference save() {
        try {
            upsert contentblock;
            if(pagetoitem.ContentBlockItem__c == null) pagetoitem.ContentBlockItem__c = contentblock.Id;
            upsert pagetoitem;
            PageReference pr = new PageReference('/'+pagetoitem.Page__c);
            //the above is the default : return to the page after a contentblock save, below is when we're working from the console
            if(System.currentPageReference().getParameters().get('console') == 'true') pr = new PageReference('/apex/CMSForceConsole');
            //if we're working from the console and in fullscreen preview, return to the page itself
            if(System.currentPageReference().getParameters().get('fullscreen') == 'true') pr = new PageReference('/apex/PreviewPage?pageid='+pagetoitem.Page__c+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c); 
            return pr;
        }
        catch(Exception ex) {
            String message = ex.getMessage();
            if(ex.getMessage().contains('data value too large')) message = 'Content is too large. Please use no more than 32000 characters.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, 'Could not save content : ' + message));
            return null;
        }        
    }
    
    
    public PageReference cancel() {
    	//if we cancel in the console, go back to it, or the the full preview window
    	PageReference pr = new PageReference('/'+pagetoitem.Page__c);
    	if(System.currentPageReference().getParameters().get('console') == 'true') pr = new PageReference('/apex/CMSForceConsole');
        //if we're working from the console and in fullscreen preview, return to the page itself
        if(System.currentPageReference().getParameters().get('fullscreen') == 'true' && CMSForceDomain__c.getAll().get('cmsforcedomain') != null) pr = new PageReference('/apex/PreviewPage?pageid='+pagetoitem.Page__c+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c); 
		return pr;
    }
    
    
    //TEST METHODS
    public static testMethod void t1() {
    	Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c pagefolder2 = new CMSFolder__c(Type__c = 'Page', Name='test', Parent_CMSFolder__c = pagefolder.Id);
		insert pagefolder2;
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c ='main,header', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
        insert pg;
        //set up a test ContentBlockItem
        ContentBlockItem__c cb = new ContentBlockItem__c(Name='test content', Content__c='some content');
        insert cb;
        
        //new pagetoitem & contentblock
        PageItemEditExtension pie = new PageItemEditExtension(new Apexpages.Standardcontroller(new PageToItem__c(Page__c = pg.Id)));
        System.assertEquals(pie.checkType(), null);
        pie.save();
        
        //edit existing pagetoitem
        PageToItem__c pti = new PageToItem__c(Page__c = pg.Id, ContentBlockItem__c = cb.Id);
        insert pti;
        
        PageReference pr = Page.PageItemEdit;
        pr.getParameters().put('id', pti.Id);
        Test.setCurrentPageReference(pr);
        
        PageItemEditExtension pie2 = new PageItemEditExtension(new Apexpages.Standardcontroller(pti));
        pie2.checkType();
        pie2.save();
        
        
        //new pagetoitem & contentblock, but now in fullscreen, console mode
        Test.setCurrentPage(Page.PageItemEdit);
        Apexpages.currentPage().getParameters().put('console','true');
        Apexpages.currentPage().getParameters().put('fullscreen','true');
        Apexpages.currentPage().getParameters().put('cbname','testcbname');
        Apexpages.currentPage().getParameters().put('masterpage',pg.Id);
        PageItemEditExtension pie3 = new PageItemEditExtension(new Apexpages.Standardcontroller(new PageToItem__c()));
        System.assertEquals(pie3.checkType(), null);
        pie3.save();
        
        //edit existing pagetoitem
        PageToItem__c pti2 = new PageToItem__c(Page__c = pg.Id, ContentBlockItem__c = cb.Id);
        insert pti2;
        
        PageReference pr2 = Page.PageItemEdit;
        pr2.getParameters().put('id', pti.Id);
        pr2.getParameters().put('console','true');
        pr2.getParameters().put('fullscreen','true');
        pr2.getParameters().put('cbname','testcbname');        
        Test.setCurrentPageReference(pr2);
        
        PageItemEditExtension pie4 = new PageItemEditExtension(new Apexpages.Standardcontroller(pti));
        pie4.checkType();
        pie4.cancel();
        pie4.save();
    }

}