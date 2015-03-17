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

public class FormFieldController {
	
	public Form_Field__c field {get;set;}
	public List<SelectOption> picklistSelectOptions;
	//workaround for bug #W-638516
	public PageReference pagetemplatename {get;set;}
	
	//CONSTRUCTOR
	public FormFieldController() {
		//workaround for bug #W-638516
        pagetemplatename = new PageReference('/apex/'+System.currentPageReference().getParameters().get('pagetemplatename'));
	}

	public List<SelectOption> getPicklistSelectOptions() {
		//if this is a picklist field, set up the selectoptions for the drop down that needs to be rendered
		if(field.Type__c == 'PICKLIST' && field.PicklistEntries__c != null) {
			picklistSelectOptions = new List<SelectOption>();
			String[] values = field.PicklistEntries__c.split(',' , 0);
			for(String s:values) {
				SelectOption so = new SelectOption(s,s);
				picklistSelectOptions.add(so);
			}
		}
		return picklistSelectOptions;
	}

	
	
	//** TEST METHODS **/
	public static testMethod void t1() {
		FormFieldController controller = new FormFieldController();
		Form_Field__c field = new Form_Field__c();
		field.PicklistEntries__c = 'a,b,c';
		field.Type__c = 'PICKLIST';
		controller.field = field;
		List<SelectOption> selectlist = controller.getPicklistSelectOptions();
		System.assertEquals(3, selectlist.size());
	}

}