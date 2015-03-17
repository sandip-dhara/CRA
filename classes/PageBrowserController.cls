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

public with sharing class PageBrowserController {

	public List<Page__c> pages {get;set;}
	public CMSFolder__c currentfolder {get;set;}
	public String selectedsiteid {get;set;}
	public List<CMSFolder__c> folders {get;set;}
	public List<Selectoption> siteselect {get;set;}
	
	
	public PageBrowserController() {
		List<Site> sites = [select Id, MasterLabel from Site where Status = 'Active' limit 25];
		siteselect = new List<Selectoption>();
		siteselect.add(new Selectoption('-- None --','-- None --'));
		for(Site s:sites) {
			String ids = s.Id;
			siteselect.add(new Selectoption(ids.substring(0,15), s.MasterLabel));
		}
		//if there's only one active site, switch to it immediately
		if(sites != null && sites.size() == 1) {
			String sid = sites[0].Id;
			selectedsiteid = sid.substring(0,15);
			getFolders();
		}
	}
	
	
	//select a folder to drill down into
	public void selectFolder() {
		String folderid = System.currentPageReference().getParameters().get('folderid');
		currentfolder = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Type__c = 'Page' and Id =:folderid];
		getFolders();
		pages = [Select p.Name, p.LastModifiedBy.Name, p.LastModifiedDate, p.LastModifiedById, p.Id From Page__c p where p.Folder__c = :currentfolder.Id order by p.Name limit 1000];
	}
	
	//select a site to drill down into
	public void selectSite() {
		currentfolder = null;
		pages = null;	
		getFolders();
	}
	
	//gets the folders in the current selected folder
	private void getFolders() {
		//find the folders
		if(currentfolder == null) {		
			folders = [select Id, Name from CMSFolder__c where Type__c = 'Page' and Parent_CMSFolder__c = null and Site_Id__c =:selectedsiteid];
		}
		else {folders = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Type__c = 'Page' and Parent_CMSFolder__c =:currentfolder.Id];}
		if(currentfolder != null) pages = [select Id, Name from Page__c where Folder__c =:currentfolder.Id];
	}
	
	//go back one folder
	public void back() {
		pages = null;
		if(currentfolder == null) return;
		if(currentfolder.Parent_CMSFolder__c != null) {
			currentfolder = [select Id, Name,Parent_CMSFolder__c from CMSFolder__c where Id=:currentFolder.Parent_CMSFolder__c]; }
		else {
			currentfolder = null;
		}
		getFolders();
	}

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
		PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
		insert template;
		//set up a test page
		Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
		insert pg;
		
		Test.setCurrentPage(Page.PageBrowser);
		PageBrowserController pbc = new PageBrowserController();
		System.assert(pbc.siteselect.size() > 0);
		//select a site
		pbc.selectedsiteid = siteid;
		pbc.selectSite();
		System.assert(pbc.folders != null);
		ApexPages.currentPage().getParameters().put('folderid',pagefolder.Id);
		pbc.selectFolder();
		System.assertEquals(pbc.pages[0].Id, pg.Id);
		ApexPages.currentPage().getParameters().put('folderid',pagefolder2.Id);
		pbc.selectFolder();
		System.assertEquals(pbc.currentfolder.Id, pagefolder2.Id);
		pbc.back();
		System.assertEquals(pbc.currentfolder.Id, pagefolder.Id);
	}


}