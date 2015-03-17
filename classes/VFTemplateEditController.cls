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

public with sharing class VFTemplateEditController {

		
	public PageReference toEdit() {
		String pname = System.currentPageReference().getParameters().get('vfpagename');
		ApexPage p;
		try {
			p = [select Id, Name from ApexPage where Name = :pname];
		}
		catch(Exception ex) {
			ApexPages.Message msg = new Apexpages.Message(Apexpages.Severity.ERROR, 'There is no VisualForce page associated with this Page Template.');
			ApexPages.addMessage(msg);
		}
		PageReference pr =null;
		if(p != null) pr = new PageReference('/'+p.Id+'/e');
		return pr;
	}
	
	public static testMethod void t1() {
		
		PageReference pr = Page.TestTemplate;
		pr.getParameters().put('vfpagename','TestTemplate');
		ApexPage p = [select Id, Name from ApexPage where Name = 'TestTemplate'];
		
		Test.setCurrentPage(pr);
		
		VFTemplateEditController vfc = new VFTemplateEditController();
		PageReference retpr = vfc.toEdit();
		
		System.assertEquals(retpr.getUrl() , '/'+p.Id+'/e');
		
		//try the error catching by feeding this page a non-existing visualforce page name
		pr.getParameters().put('vfpagename','nonexisting');
		VFTemplateEditController vfc2 = new VFTemplateEditController();
		
		PageReference retpr2 = vfc2.toEdit();
		
		System.assertEquals(retpr2 , null);
		
		
		
	}

}