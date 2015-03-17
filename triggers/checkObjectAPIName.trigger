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


//Since people sometimes don't setup the WebForm button overrides with the VF Web Editor
//we're going to make sure that nobody can save a webform with an inexisting object API Name.
//Trigger is not bulkified but for the time being I don't see admin's inserting forms in bulk

trigger checkObjectAPIName on Web_Form__c (before insert, before update) {

	//Map that holds all the object names and tokens in your org
	Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

	for(Web_Form__c form:Trigger.New) {
        //just for other tests, provide a bypass to this one
        if(form.Object_Name__c.contains('testbypassx')) continue;
        //get a reference to the token related to the object referenced in the webform
        SObjectType sot = gd.get(form.Object_Name__c);
        //instantiate an object of this type
        try {
        	SObject sobjectInstance = sot.newSObject();
        }
        //this happens when the object's API name doesn't exist, or has been removed from the profile access settings
        //Typically when admin's don't setup the webform editor correctly
        catch(System.NullPointerException ex) {
        	form.addError('The Object API name is not correct.');        	
        }
        
        //check if the webform was saved by the VF webformeditorpage
		if(!form.SavedByWebformeditor__c) {
			form.addError('Please check the setup guide. You need to override the New and Edit buttons of the Web Form object with the WebFormEditor VisualForce page');
		}
	}

}