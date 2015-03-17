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

public with sharing class DocumentBrowserController {

	public List<Selectoption> folderoptions {get;set;}
	public ID folderid {get;set;}
	public List<Document> documents {get;set;}
	
	public String uploadfilename {get;set;}
	public Blob uploadfile {get;set;}
	
	public DocumentBrowserController() {
		//get the folders
		List<Folder> folders = [Select f.Type, f.Name, f.Id, f.DeveloperName From Folder f where f.Type = 'Document'];
		folderoptions = new List<Selectoption>();
		for(Folder f:folders) {
			if(f.Name == null) continue;
			SelectOption s = new SelectOption(f.Id, f.Name);
			folderoptions.add(s);
		}
		//if there are folders, set the first one and fetch the documents
		if(!folders.isEmpty()) {
			Folder f = folders[0];
			folderid = f.Id;
			selectFolder();
		}
	}
	
	
	public PageReference selectFolder() {
		documents = [Select d.Url, d.Type, d.Name, d.Id, d.FolderId, d.Description, d.ContentType, d.BodyLength, d.LastModifiedDate From Document d where d.FolderId =:folderid];
		return null;
	}


	public static testMethod void t1() {
		
		PageReference pr = Page.DocumentBrowser;
		
		
		pr.getParameters().put('folderid', 'xxxx');
		Test.setCurrentPage(pr);
		
		DocumentBrowserController dbc = new DocumentBrowserController();
		
		dbc.selectFolder();
		System.assert(dbc.folderoptions != null);
	}	

}