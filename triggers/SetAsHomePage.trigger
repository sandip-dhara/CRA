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

trigger SetAsHomePage on Page__c (after insert, after update) {

	private List<Page__c> tounflag {get;set;}

	//not bulkified - I don't expect people to be uploading home pages via the API right now.
	if(trigger.new.size() > 1) return;
	
	for(Page__c p:Trigger.new) {
		//only if the page has the home page flag set we need to do something
		if(!p.Home_Page__c) continue;
		
		//get all pages for this site that have the flag set (except for this one). Typically there should only be one other page as homepage
		//the correct site Id has already been set in the 'before' trigger
		tounflag = [select Id, Name from Page__c where Home_Page__c = true and Site_Id__c =:p.Site_Id__c and Id !=:p.Id];
		
		//if there aren't any pages already set as home page, do nothing
		if(tounflag.isEmpty()) continue;
		
		//however, if there are : unflag them
		for(Page__c pu:tounflag) {
			pu.Home_Page__c = false;
			pu.Site_Id__c = null;
		}		
		//and update the demoted homepage(s)...
		update tounflag;
	}

}