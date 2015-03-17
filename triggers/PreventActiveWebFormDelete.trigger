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
trigger PreventActiveWebFormDelete on Web_Form__c (before delete) {

	//see if there are contentblocks that point to the webforms
	List<ContentBlockItem__c> contentblockitems = [Select c.Web_Form__c, c.Type__c, c.Name, c.Id From ContentBlockItem__c c where c.Times_Used__c > 0 and c.Web_Form__c in :Trigger.oldMap.keySet()];
	
	//drop the id's of the used web forms in a Set
	Set<Id> usedforms = new Set<Id>();
	
	for(ContentBlockItem__c cbi:contentblockitems) {
		usedforms.add(cbi.Web_Form__c);
	}
	
	//fail those that are used
	for(Web_Form__c wf:Trigger.old) {
		if(usedforms.contains(wf.Id)) wf.addError('You can not delete a web form that is still used on a page.');
	}

}