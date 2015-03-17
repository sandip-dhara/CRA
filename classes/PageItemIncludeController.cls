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

public with sharing class PageItemIncludeController {

	public List<PageToItem__c> items {get;set;}
	private String pageid {get;set;}
	public List<Selectoption> blocknameselect {get;set;}
	public PageToItem__c p {get;set;}
	public CMSFolder__c currentfolder {get;set;}
	public List<CMSFolder__c> folders {get;set;}
	public List<Page__c> pages {get;set;}
	public String previewurl {get;set;}
	
	public PageItemIncludeController(Apexpages.Standardcontroller con) {
		p = new PageToItem__c(Page__c = System.currentPageReference().getParameters().get('pageid'));
		//items = [Select p.Page__r.Name, p.Page__c, p.Order__c, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Name, p.ContentBlockItem__c From PageToItem__c p order by p.Page__r.Name limit 1000];
		
		//Find the right pagetemplate id via the page
		Page__c page;
		try {
			page = [Select p.PageTemplate__r.ContentBlockNames__c, p.PageTemplate__c From Page__c p where Id =:System.currentPageReference().getParameters().get('pageid')];

			String contentblocknames = page.PageTemplate__r.ContentBlockNames__c;
			
			List<String> splitnames = contentblocknames.split(',');
			blocknameselect = new List<Selectoption>();
			for(String s:splitnames) {
				Selectoption so = new Selectoption(s,s);
				blocknameselect.add(so);
			}
			
			//the console editor will already pass on the contentblock based on where the user clicked in the page
            String cbname = System.currentPageReference().getParameters().get('cbname');
            if(cbname != null) p.Display_in_Contentblock__c = cbname;
			getFolders();
		}	
		catch(QueryException qex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Error, 'Include page item error : Could not a find reference to the page. Please make sure that the new/edit button overrides on all objects are set up correctly'));
		}
				
	}
	
	
	//select a folder to drill down into
	public void selectFolder() {
		String folderid = System.currentPageReference().getParameters().get('folderid');
		currentfolder = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Type__c = 'Page' and Id =:folderid];
		getFolders();
	}
	
	public void selectPage() {
		String pid = System.currentPageReference().getParameters().get('pid');
		String siteid = CMSForceUtils.findRootFolder(currentfolder.Id).Site_Id__c;
		if(CMSForceSites__c.getAll().get(siteid) != null) previewurl = CMSForceSites__c.getAll().get(siteid).Site_Url__c;
		items = [Select p.Page__r.Name, p.Page__c, p.Order__c, p.Display_in_Contentblock__c, p.ContentBlockItem__r.Name, p.ContentBlockItem__c From PageToItem__c p where p.Page__c =:pid order by p.Page__r.Name limit 1000];		
	}
	
	//gets the folders in the current selected folder
	private void getFolders() {
		//find the folders
		if(currentfolder == null) {
			//only show folders from the site this page is in
			Page__c p = [select Id, Folder__c from Page__c where Id =: System.currentPageReference().getParameters().get('pageid')];
			String siteid = CMSForceUtils.findRootFolder(p.Folder__c).Site_Id__c;
			folders = [select Id, Name from CMSFolder__c where Type__c = 'Page' and Parent_CMSFolder__c = null and Site_Id__c =:siteid];
		}
		else {folders = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Type__c = 'Page' and Parent_CMSFolder__c =:currentfolder.Id];}
		if(currentfolder != null) pages = [select Id, Name from Page__c where Folder__c =:currentfolder.Id];
	}
	
	//go back one folder
	public void back() {
		items = null;
		if(currentfolder == null) return;
		if(currentfolder.Parent_CMSFolder__c != null) {
			currentfolder = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Id=:currentFolder.Parent_CMSFolder__c]; }
		else {
			currentfolder = null;
		}
		getFolders();
	}
	
	
	public PageReference selectItem() {
		String itemid = System.currentPageReference().getParameters().get('itemid');
		p.ContentBlockItem__c = itemid;
		
		try {
			insert p;
			
			PageReference pr = new PageReference('/'+p.Page__c);
            //the above is the default : return to the page after an include, below is when we're working from the console
            if(System.currentPageReference().getParameters().get('console') == 'true') pr = new PageReference('/apex/CMSForceConsole');
            //if we're working from the console and in fullscreen preview, return to the page itself
            if(System.currentPageReference().getParameters().get('fullscreen') == 'true') pr = new PageReference('/apex/PreviewPage?pageid='+p.Page__c+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c);
			
			return pr;
		}
		catch(Exception ex) {
			Apexpages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR, ex.getMessage());
			Apexpages.addMessage(msg);
			return null;
		}
	}
	
		//cancel
	public PageReference cancel() {
		//if we cancel in the console, go back to it, or the the full preview window
    	PageReference pr = new PageReference('/'+System.currentPageReference().getParameters().get('pageid'));
    	if(System.currentPageReference().getParameters().get('console') == 'true') pr = new PageReference('/apex/CMSForceConsole');
        //if we're working from the console and in fullscreen preview, return to the page itself
        if(System.currentPageReference().getParameters().get('fullscreen') == 'true' && CMSForceDomain__c.getAll().get('cmsforcedomain') != null) pr = new PageReference('/apex/PreviewPage?pageid='+System.currentPageReference().getParameters().get('pageid')+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c); 
		return pr;
	}
	
	
	//TEST METHODS
	private static testMethod void t1() {
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
		//set up an existing pagetoitem
		PageToItem__c pti = new PageToItem__c(Page__c = pg.Id, ContentBlockItem__c = cb.Id);
		insert pti;
		
		PageReference pr = Page.PageItemInclude;
		pr.getParameters().put('pageid', pg.Id);
		Test.setCurrentPageReference(pr);
		
		pr.getParameters().put('cbname', 'testcbname');
		PageItemIncludeController piic = new PageItemIncludeController(new Apexpages.Standardcontroller(pti));
		
		pr.getParameters().put('folderid', pagefolder.Id);
		piic.selectFolder();
		System.assertEquals(pagefolder.Id, piic.currentfolder.Id);
		
		pr.getParameters().put('folderid', pagefolder2.Id);
		piic.selectFolder();
		System.assertEquals(pagefolder2.Id, piic.currentfolder.Id);
		
		piic.back();
		System.assertEquals(pagefolder.Id, piic.currentfolder.Id);
		
		pr.getParameters().put('pid', pg.Id);
		piic.selectPage();
		
		pr.getParameters().put('console', 'true');
		pr.getParameters().put('fullscreen', 'true');
		pr.getParameters().put('itemid', cb.Id);
		piic.selectItem();
		
		List<PageToItem__c> ptilist = [select Id from PageToItem__c where ContentBlockItem__c =:cb.Id];
		System.assert(ptilist != null);
		
		piic.back();
		System.assertEquals(null, piic.currentfolder);
		
		piic.cancel();
		
	}

}