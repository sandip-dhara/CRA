@isTest
private class TestCMSForceTriggers {
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



	//test methods
	static testMethod void t1() {
		//set up a test web form
		Web_Form__c form = new Web_Form__c();
		form.Name = 'test webform';
		form.Object_Name__c = 'wrongAPIName';
		form.Return_URL__c = 'www.x.com';
		form.SavedByWebformeditor__c = true;
		
		try {
			insert form;
		}
		catch(DMLException dex) {
			System.assert(dex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
		}
		
		form.SavedByWebformeditor__c = false;
		try {
			insert form;
		}
		catch(DMLException dex) {			
			System.assert(dex.getMessage().contains('WebFormEditor'));
		}
	}


	//test cleanup unused contentblock items (those that don't have a pagetoitem pointing at them)
	private static testMethod void t2() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
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
        //use this content block in the page
        PageToItem__c pti = new PageToItem__c();
        pti.ContentBlockItem__c = cb.Id;
        pti.Page__c = pg.Id;
        insert pti;
        
        //delete the link, orphaning the contentblock
        delete pti;
        
        //the formula field updates async so I can't test for the deletion of the contentblock
        Exception ex;
        try{pti = [select Id from PageToItem__c where Id =:pti.Id];}catch(Exception ex1){ex=ex1;}
        System.assert(ex != null);	
	}
	
	//preventactive webform delete
	private static testMethod void t3() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
		//set up a webform folder
		CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
		insert webformfolder;
        //set up a test template
        PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', ContentBlockNames__c ='main,header', Folder__c = templatefolder.Id);
        insert template;
        //set up a test page
        Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
        insert pg;
        //set up a test web form
		Web_Form__c form = new Web_Form__c();
		form.Name = 'test webform';
		form.Object_Name__c = 'Account';
		form.Return_URL__c = 'www.x.com';
		form.SavedByWebformeditor__c = true;
		form.Folder__c = webformfolder.Id;
		insert form;
		//set up a test ContentBlockItem
        ContentBlockItem__c cb = new ContentBlockItem__c(Name='test content', Content__c='some content', Web_Form__c = form.Id);
        insert cb;
        PageToItem__c pti = new PageToItem__c();
        pti.Page__c = pg.Id;
        pti.ContentBlockItem__c = cb.Id;
        
        insert pti;
        //this should lock the webform from delete
        Exception ex;
        try{delete form;}catch(Exception ex1){ex = ex1;}
        System.assert(ex != null);
        
	}
	
	
	//prevent folder orphans
	private static testMethod void t4() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c pagefolder2 = new CMSFolder__c(Type__c = 'Page', Name='test', Parent_CMSFolder__c = pagefolder.Id);
		insert pagefolder2;
		Exception ex;
		try{delete pagefolder;}catch(Exception ex1){ex=ex1;}
		System.assert(ex != null);
	}
	
	//prevent delete of templates used on pages
	private static testMEthod void t5() {
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
		//set up a test page that uses the template
		Page__c pg = new Page__c(Name='testpage', PageTemplate__c = template.Id, Folder__c = pagefolder.Id);
		insert pg;
		//try to delete the template, it should fail
		Exception ex;
		try{delete template;}catch(Exception ex1){ex=ex1;}
		System.assert(ex != null);
	}

}