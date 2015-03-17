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

public with sharing class PageTemplateEditController {

	public PageTemplate__c template {get;set;}
	public List<ApexPage> vfpages {get;set;}
	public List<SelectOption> pageoptions {get;set;}
	
	
	public PageTemplateEditController(ApexPages.StandardController con) {		
		template = (PageTemplate__c)con.getRecord();
		//get the visualforce page names in this org, except for the ones used by CMSForce itself
		vfpages = [select Id, Name from ApexPage where Name not in 
			('page','VFTemplateEdit','PageTemplateEdit','ContentBlockEdit','ContentBlockItemPreview','DocumentBrowser',
			 'DocumentManager','PageBrowser','HomePage','PageItemEdit','PageItemInclude','PreviewError','WebFormEditor','Form','FormItemInclude',
			 'ContentBlockItemSitePreview','CMSConsoleActions','CMSForceSetup','ViewPage','CMSForceConsole','CMSSiteDetail',
			 'CMSFolders','CMSFolderDetail')];
		System.debug(vfpages);
		pageoptions = new List<SelectOption>();
		for(ApexPage p:vfpages) {
			SelectOption s = new  SelectOption(p.Name,p.Name);
			pageoptions.add(s);
		}
		//when called from the console, it will pass in a Folder id
		if(System.currentPageReference().getParameters().get('folderid') != null) {			
			template.Folder__c = System.currentPageReference().getParameters().get('folderid');
		}
	}
	
	//This will save the template and extract the contentblocknames to be kept in the ContentBlockNames__c field.
	//This will be usefull when users create pages : they won't have to remember these names.
	public PageReference save() {
		String contentblocknames = '';
		//empty the current names list
		template.ContentBlockNames__c = '';
		
		//go find the content of the template by rendering it, pass the 'register' param to create {{ ... }} strings (see contentblockcomponentcontroller)
		PageReference pr = new PageReference('/apex/'+template.VisualForce_Page_Name__c + '?register=1');
		Blob content = pr.getContent();
		//System.debug(content.toString());
		
		// First, instantiate a new Pattern object "MyPattern"
		Pattern MyPattern = Pattern.compile('\\{\\{.+\\}\\}'); // we're looking for {{.....}} substrings in the rendered page
		Matcher MyMatcher = MyPattern.matcher(content.toString());
		
		while(!MyMatcher.hitEnd()) {

			try {
				MyMatcher.find();
				//System.debug('GROUP : '+MyMatcher.group());
				contentblocknames = contentblocknames + MyMatcher.group().substring(2, MyMatcher.group().length()-2)+',';
			}
			catch(System.Stringexception ex) {
				//this always happens, after the matcher hits the end of the content string. Do nothing.
			}
		}
		if(contentblocknames.length() > 1) template.ContentBlockNames__c = contentblocknames.substring(0,contentblocknames.length()-1); //take of the trailing ',''
		upsert template;
		//when called from the console, a folder id will have been passed. Just return to it.
		if(System.currentPageReference().getParameters().get('folderid') != null) return new PageReference('/apex/CMSForceConsole');
		return new PageReference('/'+template.Id);
	}


	private static testMethod void t1() {
		//set up a template folder
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
		//set up a test template
		PageTemplate__c template = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate', Folder__c = templatefolder.Id);
		insert template;
		
		ApexPages.StandardController stdcon = new ApexPages.StandardController(template);
		PageTemplateEditController ptcon = new PageTemplateEditController(stdcon);
		
		
		PageReference pr = new PageReference('/'+template.Id);
		System.assertEquals(pr.getUrl(), ptcon.save().getUrl());
		
		//set up a test template without a folder
		PageTemplate__c template2 = new PageTemplate__c(Name='test', VisualForce_Page_Name__c='TestTemplate');
		
		Apexpages.currentPage().getParameters().put('folderid', templatefolder.Id);
		ApexPages.StandardController stdcon2 = new ApexPages.StandardController(template);
		PageTemplateEditController ptcon2 = new PageTemplateEditController(stdcon);
		
		
		PageReference pr2 = new PageReference('/'+template.Id);
		System.assertEquals('/apex/CMSForceConsole', ptcon.save().getUrl());
	}
	
	

}