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

public with sharing class WebFormEditorController {


    //Web Form
    public Web_Form__c webform {get;set;}
    //Map that holds all the object names and tokens in your org
    Map<String, Schema.SObjectType> gd;
    //List with just these tokens
    public List<SObjectType> tokens = new List<SObjectType>();
    public List<String> objectlabels {get;set;}
    public List<SelectOption> objectSelectOptions {get;set;}
    public SObjectType sot {get;set;} //holds the selected object's token
    public String selectedObject {get;set;} //holds the name of the selected SObject, bound to the SelectList
    public String selectedObjectLabel {get;set;} //holds the label of the selected SObject


    //List to hold the selected object's field information, based on the Form_Field__c custom object
    public List<Form_Field__c> objectFields {get;set;}
    //List to hold the selected form fields information
    public List<Form_Field__c> formFields {get;set;}
    //Counter that keeps track of the number of CUSTOMTEXT fields.
    public Integer nrcustomtextfields = 0;
    //variable to track step 1,2
    public String step {get;set;}
    //booleans to register console / fullscreen / the page that was being edited
    private Boolean console = false;
    private Boolean fullscreen = false;
    private String currentpage;


    //CONSTRUCTOR
    public WebFormEditorController(ApexPages.StandardController stdController) {
        //start in step 1
        step = '1';
        //register console and/or fullscreen mode
        if(System.currentPageReference().getParameters().get('console') == 'true') console = true;
        if(System.currentPageReference().getParameters().get('fullscreen') == 'true') fullscreen = true;
        if(System.currentPageReference().getParameters().get('currentpage') != null) currentpage = System.currentPageReference().getParameters().get('currentpage');
        //get a full list of all objecttokens
        gd = Schema.getGlobalDescribe();
        
        tokens = gd.values(); //get the tokens from this map
        objectlabels = new List<String>();
        objectSelectOptions = new List<SelectOption>();
        //get the tokens from the global describe map and drop their names and labels in the drop down list
        objectSelectOptions.add(new SelectOption('-- None --', '-- None --'));
        for(SObjectType s:gd.values()) {
            //don't add all objects to the list (there's a lot of internal objects that user's don't need or can use)
            //System.debug(' **************************** ' + s.getDescribe().getName() + ' ** ' + s.getDescribe().getLabel());
            if(!acceptedObject(s)) continue;
            
            objectlabels.add(s.getDescribe().getLabel());
            SelectOption so = new SelectOption(s.getDescribe().getName(), s.getDescribe().getLabel());
            objectSelectOptions.add(so);
        }
        //initialize the formFields & objectFields lists
        formFields = new List<Form_Field__c>();
        objectFields = new List<Form_Field__c>();
        
        //get the existing webform if there's an id in the url, or create a new one if not
        String webformid = System.currentPageReference().getParameters().get('id');
        
        //we're editing an existing one
        if(webformid != null && webformid != 'null') {
            try {
                //get the web form
                webform = [select Id, Name, Object_Name__c, Object_Label__c, Return_URL__c, Description__c, Folder__c, Title__c, Background_Color__c, Save_Button_Text__c, Text_Color__c from Web_Form__c where Id = :webformid];           
                //get the object fields
                selectedObject = webform.Object_Name__c;
                selectObject();
                //get the form fields
                formFields = [Select f.Web_Form__c, f.Type__c, f.Required__c, f.APIRequired__c, f.PicklistEntries__c, f.Order__c, f.Name, f.Label__c, f.Hidden__c, f.Width__c, f.Id, 
                                f.Text_Value__c, f.Date_Value__c, f.Email_Value__c, f.DateTime_Value__c, f.Boolean_Value__c, 
                                f.Currency_Value__c, f.Number_Value__c, f.Percent_Value__c, f.Phone_Value__c,f.Text_Area_Value__c,
                                f.Text_Area_Long_Value__c, f.URL_Value__c, f.Picklist_Value__c From Form_Field__c f where f.Web_Form__c = :webform.Id order by f.Order__c];
                //and remove the fields already in the form from the object fields. No use in putting them on the form twice
                for(Form_Field__c formfield:formFields) {
                    //count the custom text fields. Gotta keep those names unique
                    if(formfield.Type__c == 'CUSTOMTEXT') nrcustomtextfields++;
                    for(Integer i = 0; i < objectFields.size();i ++) {
                        Form_Field__c objectField = objectFields.get(i);
                        if(formField.Name == objectField.Name) objectFields.remove(i);
                    }
                }
            } catch(Exception ex) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            }                   
        }
        //create a new webform if no id is passed in the url
        else {
            webform = new Web_Form__c();
            webform.Background_Color__c = '#FFFFFF';
            webform.Text_Color__c = '#000000';
            webform.Save_Button_Text__c = 'Save';
            //when called from the console, it will pass in a Folder id
            if(System.currentPageReference().getParameters().get('folderid') != null) {         
                webform.Folder__c = System.currentPageReference().getParameters().get('folderid');
            }
        }
        //flag the webform as created by the webformeditor. If people don't override the edit/new buttons this will be missing and a trigger will complain when trying to save via the normal pages
        if(webform != null) webform.SavedByWebformEditor__c = true;
    }

    //let's make this an extension -> allows to use this as an extension on the standardcontroller
    //public WebFormEditorController(ApexPages.StandardController stdController) {
    //  this(); //call the original constructor.
    //} 
    
    //When an object is selected, get all the fields
    public PageReference selectObject() {
        //if none selected, stop here
        if(selectedObject == '-- None --') return null;
        //find out which object got selected        
        sot = gd.get(selectedObject);
        //drop it's label in the selected object field, for display purposes
        selectedObjectLabel = sot.getDescribe().getLabel();
        webform.Object_Name__c = sot.getDescribe().getName();
        webform.Object_Label__c = sot.getDescribe().getLabel();
        
        //if a new object gets selected clear all field lists
        objectFields.clear();
        formFields.clear();
        
        //get the field tokens map
        Map<String, SObjectField> fields = sot.getDescribe().fields.getMap();
        //and drop those tokens in a List
        List<SObjectField> fieldtokens = fields.values();

        objectfields = new List<Form_Field__c>();

        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();
            
            //skip fields we can't create anyway, or system fields
            if(!dfr.isCreateable()) continue; // || dfr.isDefaultedOnCreate()
            if((dfr.getName() == 'CreatedDate') || (dfr.getName() == 'LastModifiedDate') || (dfr.getName() == 'CreatedById') || (dfr.getName() == 'LastModifiedById')) continue;
            //No REFERENCE FIELDS (for the time being)
            //if(dfr.getType().name() == 'REFERENCE') continue;
            if(dfr.getName() == 'OwnerId') continue;
            //Next 2 lines handle the 'required' flag in the web form editor. We just want to exclude this flag for booleans since they always show up as not nillable
            Boolean required;
            if(!(dfr.getType().name() == 'BOOLEAN')) required = !dfr.isNillable(); //Booleans are always 'isNillable = false' but it doesn't matter since any boolean will always have a value of true or false. Let's not show that to the user. It's confusing
            if(dfr.getType().name() == 'BOOLEAN') required = false;
            //required = !dfr.isNillable();
            
            //instantiate the form field with all the values
            Form_Field__c field = new Form_Field__c(Name = dfr.getName(), Label__c = dfr.getLabel(),Type__c = dfr.getType().name(), Required__c = required, APIRequired__c = required, Hidden__c = false, Width__c = 250); //PicklistEntries__c = picklistvalues,
            objectFields.add(field);
        }
        objectfields = WebformUtil.sortByLabel(objectfields);
        return null;
    }
    
    
    //adds an object's field to this web form
    public PageReference addField() {
        String fieldname = ApexPages.currentPage().getParameters().get('fieldname');
        System.debug('Adding field : ' + fieldname + ' from ' + selectedObject);
        //get the Form_Field__c that was selected and move it to the selected form fields list
        for(Integer i = 0; i < objectFields.size();i++) {
            Form_Field__c ff = objectFields.get(i);
            if(ff.Name == fieldname) {
                //if it's a picklist, go find the values and put them in the Form_Field__c
                DescribeFieldResult dfr = sot.getDescribe().fields.getMap().get(fieldname).getDescribe();
                String picklistvalues = '';
                if(dfr.getType().name() == 'PICKLIST') {
                    List<PicklistEntry> entries = dfr.getPicklistValues();
                    //loop over the found values and add them to the picklistvalues string, comma separated
                    for(Integer j=0; j < entries.size();j++) {
                        PicklistEntry pe = entries.get(j);
                        picklistvalues = picklistvalues + pe.getValue();
                        //add a comma, except after the last values
                        if(j < entries.size()-1) picklistvalues += ',';
                    }
                }
                //REFERENCE fields need to be hidden, we'll tick this box already - one less click for the user
                if(ff.Type__c == 'REFERENCE') ff.Hidden__c = true;
                //add the found picklist values to the form field
                Form_Field__c field = objectFields.remove(i);
                field.PicklistEntries__c = picklistvalues;
                //move the field over to the form fields
                ff.Order__c = 1000; //give this a very high order to make sure the reorder puts it add the end of the list. Jquery will then give them correct sequential numbers in the interface anyway.
                formFields.add(field);
                break;
            }
        }       
        reOrderFormFields();
        return null;
    }
    
    //add a CUSTOMTEXT field in the form
    public PageReference addCustomField() {
        nrcustomtextfields++; //for keeping the name unique, needed for move up/down. These rely on the fieldname
        Form_Field__c f = new Form_Field__c(Name = 'CUSTOM Text'+nrcustomtextfields, Label__c = '* CUSTOM Text *', Type__c = 'CUSTOMTEXT', Width__c = 250);             
        formFields.add(f);
        reOrderFormFields();
        return null;
    }
    
    //remove an object's field from this web form
    public PageReference removeField() {
        String fieldname = System.currentPageReference().getParameters().get('fieldname');
        //get the Form_Field__c that was selected and move it to the object fields list
        System.debug('Field to delete : ' + fieldname);
        for(Integer i = 0; i < formFields.size();i++) {
            Form_Field__c ff = formFields.get(i);
            //special case : custom text
            if(ff.Name == fieldname && ff.Type__c == 'CUSTOMTEXT') {
                System.debug('Custom Text field to remove : ' + ff);
                ff.Order__c = null;
                formFields.remove(i); 
                break;
            }
            //normal case : move the field back 
            if(ff.Name == fieldname) {
                ff.Order__c = null;
                objectFields.add(formFields.remove(i));
                break;
            }
        }
        reOrderFormFields();
        objectfields = WebformUtil.sortByLabel(objectfields);   
        return null;
    }
    
    
    
    //save the webform and it's fields
    public PageReference save() {
        //if this page doesn't have all the needed info, stop right here
        if(!validate()) return null;
        
        try {
            //Save the web form     
            upsert webform;
            
            //attached all the form fields to the correct Web Form
            for(Integer i = 0; i < formFields.size();i++) {
                Form_Field__c ff = formFields.get(i);
                if(ff.Web_Form__c == null) ff.Web_Form__c = webform.Id;             
            }
            System.debug(formfields);
            upsert formfields;
            
            //and delete the form fields that are no longer in the List
            List<ID> formFieldIds = new List<ID>();
            for(Form_Field__c field:formFields) {
                formFieldIds.add(field.Id);             
            }
            List<Form_Field__c> todelete = [select Id from Form_Field__c where Web_Form__c =:webform.Id and Id not in :formFieldIds];
            delete todelete;
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        //if we save in the console, go back to it, or the the full preview window
        PageReference pr = new PageReference('/'+webform.Id);
        if(console) pr = new PageReference('/apex/CMSForceConsole');
        //if we're working from the console and in fullscreen preview, return to the page itself
        if(fullscreen && CMSForceDomain__c.getAll().get('cmsforcedomain') != null) pr = new PageReference('/apex/PreviewPage?pageid='+currentpage+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c); 
        return pr;      
    }
    
    
    //cancel
    public PageReference cancel() {
        PageReference pr = new Apexpages.Standardcontroller(webform).cancel();
        //if we save in the console, go back to it, or the full preview window
        if(console) pr = new PageReference('/apex/CMSForceConsole');
        //if we're working from the console and in fullscreen preview, return to the page itself
        if(fullscreen && CMSForceDomain__c.getAll().get('cmsforcedomain') != null) pr = new PageReference('/apex/PreviewPage?pageid='+currentpage+'&console=true&fullscreen=true&pod='+CMSForceDomain__c.getAll().get('cmsforcedomain').Url__c); 
        return pr;
    }
    

    //save and preview the form
    public PageReference preview() {
        PageReference saveref = save();
        System.debug('WebForm Id : '+webform.Id);
        //if the form doesn't validate, this returns null, no use in previewing then
        if(saveref == null) return Page.PreviewError;
        //else, show the Form       
        PageReference pr = Page.Form;
        pr.setRedirect(true);
        pr.getParameters().put('id', webform.Id);
        return pr;
    }


    //method that will recalculate the order of the form fields when one has been removed or order changed
    private void reOrderFormFields() {
        if(formFields.size() == 0) return;
        //first put the list in the correct order.
        //The drag and drop functionality might have made the list completely different 
        //from the order they're in the formFields List (and because of the 'remove', some order values might be missing
        formFields = WebformUtil.sortByOrder(formFields);
        //and now fill them up with ascending values, this will remove the 'gaps' if there are any
        for(Integer i=0; i < formFields.size();i++) {
            Form_Field__c ff = formFields.get(i);
            ff.Order__c = i + 1;            
        }
    }
    
    //method that is a pseudo variable to return the formfields' size to the page, usefull for the up / down links
    public Integer getFormFieldsSize() {
        return formFields.size();
    }
    
    //validate the page on save
    private Boolean validate() {
        Boolean valid = true;
        
        if(webform.Object_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an object this form needs to fill'));
            valid = false;
        }
        if(webform.Folder__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a folder'));
            valid = false;
        }
        if(formFields.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select fields for this form'));
            valid = false;
        }
        if(webform.Return_URL__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a return url for this form.'));
            valid = false;
        }
        //check if the user didn't forget any required fields
        for(Form_Field__c field:objectFields) {
            if(field.Required__c == true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add the required field '+field.Label__c+' to your form.'));
                valid = false;
            }
        }
        //check that all hidden fields have default values
        //check if reference fields point to an exising object
        for(Form_Field__c field:formFields) {
            if(field.Hidden__c == true) {               
                if(Webformutil.getFormFieldValue(field) == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'If you make the field \''+field.Label__c+'\' hidden, you need to provide a default value.'));
                    valid = false;
                }               
            }
            if(field.Type__c == 'REFERENCE') {
                try {
                    if(sot.getDescribe().fields.getMap().get(field.Name).getDescribe().isNamePointing()) continue; //skip the WhoId/WhatId fields for now       
                    //get the SObject this reference field points to                
                    List<Schema.Sobjecttype> referenceobjectlist = sot.getDescribe().fields.getMap().get(field.Name).getDescribe().getReferenceTo();
                    Schema.Sobjecttype referencesot;
                    if(referenceobjectlist != null && referenceobjectlist.size() > 0) referencesot = referenceobjectlist.get(0);
                    //try to find the object with this id           referencesot.getDescribe().getName()
                    String qry = 'select Id from ' + referencesot.getDescribe().getName() + ' where Id = \'' + field.Text_Value__c + '\'';
                    System.debug('REFERENCE Check Query : ' + qry);
                    List<SObject> foundobjects = Database.query(qry);
                    System.debug('Result : ' + foundobjects);
                    foundobjects.get(0); //this will throw an exception if no object was found
                } catch(Exception ex) {
                    ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'The reference ' + field.Text_Value__c +' for field '+ field.Name + ' is not valid. Reference fields need to be hidden and have a correct Id value. '+ex.getMessage()));
                    valid = false;  
                }   
            }
        }
        return valid;
    }
    
    //validate step 1
    public Boolean validate1() {
        Boolean valid = true;
        
        if(webform.Object_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an object this form needs to fill'));
            valid = false;
        }
        if(webform.Folder__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a folder'));
            valid = false;
        }
        if(webform.Return_URL__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a return url for this form.'));
            valid = false;
        }
        return valid;
    }
    
    //method that serves as action for the 'hidden' checkbox.
    public PageReference hiddenField() {
        //when unchecked after a value would have been defined already, the value field will disappear
        //we need to make sure that these selected values don't 'stick' in the form field
        String fieldname = System.currentPageReference().getParameters().get('fieldname');
        
        for(Form_Field__c f:formFields) {
            if(f.Name != fieldname) continue;
            //String ft = f.Type__c;
            f.Email_Value__c = null;        //if(ft == 'EMAIL') 
            f.URL_Value__c = null;          //if(ft == 'URL') 
            f.Boolean_Value__c = false;     //if(ft == 'BOOLEAN') 
            f.Date_Value__c = null;         //if(ft == 'DATE') 
            f.DateTime_Value__c = null;     //if(ft == 'DATETIME') 
            f.Currency_Value__c = null;     //if(ft == 'CURRENCY') 
            f.Text_Value__c = null;         //if(ft == 'STRING') 
            f.Number_Value__c = null;       //if(ft == 'DOUBLE')        
            f.Percent_Value__c = null;      //if(ft == 'PERCENT') 
            f.Text_Area_Value__c = null;    //if(ft == 'TEXTAREA') 
            f.Phone_Value__c = null;        //if(ft == 'PHONE') 
            f.Picklist_Value__c = null;     //if(ft == 'PICKLIST') 
            //if(ft == 'REFERENCE') f.Text_Value__c = null;
        }
        reOrderFormFields();
        return null;
    }
    
    //method to move to step 2
    public void step2() {
        //selectObject();
        if(validate1()) {           
            step = '2';
        }
    }
    
    //method to move to step 1
    public void step1() {
        step = '1'; 
    }
    
    
    //method used to clean out all the internal objects we don't want the users to create
    public Boolean acceptedObject(SObjectType s) {
        DescribeSObjectResult r = s.getDescribe();
        //skip the non createable ones, standard or custom
        if(!r.isCreateable()) return false;
        //do not accept the web form and form fields themselves
        String refusedobjects = 'Web_Form__c Form_Field__c Page__c PageToItem__c PageTemplate__c CMSFolder__c ContentBlockItem__c CMSForceSites__c CMSForceDomain__c';
        //if(r.getName() == 'Web_Form__c' || r.getName() == 'Form_Field__c') return false;
        if(refusedobjects.contains(r.getName())) return false;
        //other then that, we'll accepted all custom objects
        if(r.isCustom()&& r.getName() != 'Test__c' ) return true; //&& r.getName() != 'Test__c'
                
        //we're left with just the standard objects, just accept the common ones.
        String acceptedobjects = 'Case Lead Opportunity Account Contact CampaignMember';
        if(acceptedobjects.contains(r.getName())) return true;        
        
        //everything else is denied
        return false;
    }
    
    
    //*************
    // TEST METHODS
    //*************
    public static testMethod void t1() {
        CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
        insert webformfolder;
        
        //* Construct the standard controller for Web_Form__c. *//
        ApexPages.StandardController stdcon = new ApexPages.StandardController(new Web_Form__c());
        ApexPages.currentPage().getParameters().put('folderid', webformfolder.Id);
        
        WebFormEditorController controller = new WebFormEditorController(stdcon);
        //validate1 needs to complain about everything now
        //System.assertEquals(false,controller.validate1());
        //simulate an object select
        controller.selectedObject = 'Test__c';
        controller.selectObject();
       // System.assertEquals('Test', controller.selectedObjectLabel);
        //fill in the fields
        Web_Form__c form = controller.webform;
        form.Name = 'Test';
        form.Return_URL__c = 'http://www.salesforce.com';
        form.SavedByWebformeditor__c = true;
        form.Folder__c = webformfolder.Id;
        //add some fields from the object to the form
        ApexPages.currentPage().getParameters().put('fieldname', 'Checkbox__c');
        controller.addField();
        //System.assertEquals(1, controller.formFields.size());
        ApexPages.currentPage().getParameters().put('fieldname', 'Text__c');
        controller.addField();
        //System.assertEquals(2, controller.formFields.size());
        ApexPages.currentPage().getParameters().put('fieldname', 'Picklist__c');
        controller.addField();
        //System.assertEquals(3, controller.formFields.size());
        //move a field up
        //System.assertEquals('Text__c', controller.formFields.get(1).Name);
        ApexPages.currentPage().getParameters().put('fieldname', 'Text__c');
        //remove a field
        ApexPages.currentPage().getParameters().put('fieldname', 'Picklist__c');
        controller.removeField();
        //System.assertEquals(2, controller.formFields.size());
        //preview the form
        PageReference previewref = controller.preview();
        //System.assertEquals('/apex/form', Page.Form.getUrl());
        //save the webform
        PageReference ref = controller.save();
        //System.assertNotEquals(null, ref);
        
        //create an empty webform that doesn't validate
        Web_Form__c form2 = new Web_Form__c();
        controller.webform = form2;
        form2.SavedByWebformeditor__c = true;
        //preview the none-validating web form
        PageReference previewnull = controller.preview();
       // System.assertEquals('/apex/previewerror', Page.PreviewError.getUrl());
        PageReference ref2 = controller.save();
       // System.assertEquals(null, ref2);
        
        //call some of the remaining methods
        controller.getFormFieldsSize();
        
        //empty the form fields list
        controller.formFields.clear();
        controller.reOrderFormFields();
        controller.save();
        
        //cancel the edit
        //controller.cancel();
    }
    
    
    //Test of an edit
    public static testMethod void t2() {
        CMSFolder__c webformfolder = new CMSFolder__c(Type__c = 'WebForm', Name='test');
        insert webformfolder;
        //Create a webform, fields and save it
        Web_Form__c form = new Web_Form__c();
        form.Name = 'Test';
        form.Object_Name__c = 'Test__c';
        form.Object_Label__c = 'Test';      
        form.Return_URL__c = 'http://www.salesforce.com';
        form.SavedByWebformeditor__c = true;
        form.Folder__c = webformfolder.Id;
        insert form;
        
        //create test form fields for this web form
        Form_Field__c f1 = new Form_Field__c(Type__c = 'STRING', Name = 'Text__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = 'EMAIL', Name = 'Email__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f3 = new Form_Field__c(Type__c = 'URL', Name = 'URL__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f4 = new Form_Field__c(Type__c = 'BOOLEAN', Name = 'Checkbox__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f5 = new Form_Field__c(Type__c = 'DATE', Name = 'Date__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f6 = new Form_Field__c(Type__c = 'DATETIME', Name = 'DateTime__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f7 = new Form_Field__c(Type__c = 'CURRENCY', Name = 'Currency__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f8 = new Form_Field__c(Type__c = 'DOUBLE', Name = 'Number__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f9 = new Form_Field__c(Type__c = 'PERCENT', Name = 'Percent__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f10 = new Form_Field__c(Type__c = 'TEXTAREA', Name = 'Text_Area__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f11 = new Form_Field__c(Type__c = 'PHONE', Name = 'Phone__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f12 = new Form_Field__c(Type__c = 'PICKLIST', Name = 'Picklist__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f13 = new Form_Field__c(Type__c = 'UNSUPPORTED', Name = 'Text__c', Web_Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f14 = new Form_Field__c(Type__c = 'CUSTOMTEXT', Name = 'CUSTOM Text1', Web_Form__c = form.Id, Label__c = '* CUSTOM Text *',  Width__c = 250);
        
        insert f1;
        insert f2;
        insert f3;
        insert f4;
        insert f5;
        insert f6;
        insert f7;
        insert f8;
        insert f9;
        insert f10;
        insert f11;
        insert f12;
        insert f13;
        insert f14;
        
        //now go to the editor in edit mode (the id url param exists)
        PageReference pageRef = Page.WebFormEditor;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', form.Id);
        
        //* Construct the standard controller for Web_Form__c. *//
        ApexPages.StandardController stdcon = new ApexPages.StandardController(new Web_Form__c());
        WebFormEditorController controller = new WebFormEditorController(stdcon);
        //System.assertEquals(14, controller.formFields.size());
        //add a custom field
        controller.addCustomField();
        //System.assertEquals(15, controller.formFields.size());
        //remove a custom field
        ApexPages.currentPage().getParameters().put('fieldname', 'CUSTOM Text2');
        controller.removeField();
        //System.assertEquals(14, controller.formFields.size());
        //now save with less field than when it was originally retrieved
        controller.save();
        //give the object a dummy required field
        Form_Field__c f15 = new Form_Field__c(Type__c = 'STRING', Name = 'Text__c', Web_Form__c = form.Id, Label__c = 'lbl', Required__c = true);
        controller.objectFields.add(f15);
        //System.assertEquals(controller.validate(), false);
        f15.Required__c = false;
        //System.assertEquals(controller.validate(), true);
        //System.assertEquals(controller.validate1(), true);
        //check if 'hidden field needs value' validation works
        Form_Field__c f16 = new Form_Field__c(Type__c = 'STRING', Name = 'Text__c2', Web_Form__c = form.Id, Label__c = 'lbl', Hidden__c = true);
        controller.formFields.add(f16);
        //System.assertEquals(controller.validate(), false);      
        f16.Text_Value__c = 'now it has a value';
        //System.assertEquals(controller.validate(), true);
        //hide a field 'in the interface', this should reset any previously defined value back to null
        ApexPages.currentPage().getParameters().put('fieldname', 'Text__c2');
        controller.hiddenField();
        //System.assertEquals(webFormUtil.getFormFieldValue(f16), null);
        //does the reference check work correctly (reference Id's are stored in the Text_Value__c field)
        Form_Field__c f17 = new Form_Field__c(Type__c = 'REFERENCE', Text_Value__c = 'wrong value', Name = 'Web_Form__c', Web_Form__c = form.Id, Label__c = 'lbl');
        controller.formFields.add(f17);
        //System.assertEquals(false, controller.validate());
        controller.step2();
        //System.assertEquals(controller.step, '2');
        controller.step1();
        //System.assertEquals(controller.step, '1');
    }
}