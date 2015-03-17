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
trigger PreventFolderOrphans on CMSFolder__c (before delete) {

	//count the child folders for each of the Folders passed in this trigger
	List<AggregateResult> countedfolders = [
			select Parent_CMSFolder__c, COUNT(Id) from CMSFolder__c where Parent_CMSFolder__c in :Trigger.oldMap.keySet()
			GROUP BY Parent_CMSFolder__c 
		];
	
	//drop 'm in a Map
	Map<ID, Integer> folderswithchildren = new Map<ID, Integer>();
	for(AggregateResult a:countedfolders) {
		//if the id sits in the Map, the folder has child folders (folders with no children aren't returned because of the WHERE clause)
		folderswithchildren.put((ID)a.get('Parent_CMSFolder__c'), (Integer)a.get('expr0'));		
	}
	
	//do the same to check for child pages
	List<AggregateResult> countedpages = [
			select Folder__c, COUNT(Id) from Page__c where Folder__c in :Trigger.oldMap.keySet() 
			GROUP BY Folder__c 
		];
	Map<ID, Integer> folderswithpages = new Map<ID, Integer>();
	for(AggregateResult a:countedpages) {
		//if the id sits in the Map, the folder has child pages (folders with no children aren't returned because of the WHERE clause)
		folderswithpages.put((ID)a.get('Folder__c'), (Integer)a.get('expr0'));		
	}
	
	//do the same to check for child pagetemplates
	List<AggregateResult> countedtemplates = [
			select Folder__c, COUNT(Id) from PageTemplate__c where Folder__c in :Trigger.oldMap.keySet() 
			GROUP BY Folder__c 
		];
	Map<ID, Integer> folderswithtemplates = new Map<ID, Integer>();
	for(AggregateResult a:countedtemplates) {
		//if the id sits in the Map, the folder has child templates (folders with no children aren't returned because of the WHERE clause)
		folderswithtemplates.put((ID)a.get('Folder__c'), (Integer)a.get('expr0'));		
	}
	
	//do the same to check for child webforms
	List<AggregateResult> countedwebforms = [
			select Folder__c, COUNT(Id) from Web_Form__c where Folder__c in :Trigger.oldMap.keySet() 
			GROUP BY Folder__c 
		];
	Map<ID, Integer> folderswithwebforms = new Map<ID, Integer>();
	for(AggregateResult a:countedwebforms) {
		//if the id sits in the Map, the folder has child web forms (folders with no children aren't returned because of the WHERE clause)
		folderswithwebforms.put((ID)a.get('Folder__c'), (Integer)a.get('expr0'));		
	}
	
	//see if we find any with children
	for(CMSFolder__c f:Trigger.old) {
		if(folderswithchildren.get(f.Id) != null) f.addError('A folder with child folders can not be deleted.');
		if(folderswithpages.get(f.Id) != null) f.addError('A folder with child pages can not be deleted.');
		if(folderswithtemplates.get(f.Id) != null) f.addError('A folder with child templates can not be deleted.');
		if(folderswithwebforms.get(f.Id) != null) f.addError('A folder with child web forms can not be deleted.');
	}

}