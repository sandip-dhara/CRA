/***********************************************************
* Class Name: WonLostPickListDescription
* Author: HPIT
* Date: 19-July-2012 
* Requirement # Request Id: 
* Description: This controller class place the description in the visualforce page
***********************************************************/


public with sharing class WonLostPickListDescription {

        public WonLostPickListDescription(ApexPages.StandardController controller) {
            wonlostvals= new List<Won_Lost_Analysis__c>();
            returnlist();
        }
        
        public List<Won_Lost_Analysis__c> wonlostvals{get;set;}
        public List<SelectOption> getPicklistValues(){
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Won_Lost_Analysis__c.Reason_Selection_Options__c.getDescribe();
            List<Schema.PicklistEntry> wonlostpicks = fieldResult.getPicklistValues();
                    for (Schema.PicklistEntry wonlostpick : wonlostpicks) {
                options.add(new SelectOption(wonlostpick.getLabel(), wonlostpick.getValue()));
            }
            return options;  
        }
        
        //Getting one by one value form the pick list
        public Void returnlist(){
            System.debug('inside method before calling another method ');
            Won_Lost_Analysis__c wl;
            List<SelectOption> soplist=getPickListValues();
            System.debug('inside method after calling another method ');
            System.debug('inside method ');
            for(SelectOption sop: soplist){
            System.debug('inside for loop ');
            System.debug('PickList Value='+sop.getValue());
            
            //Getting the value form specific lables if  picklist value returned is matched with the if conditions
            If(sop.getValue()== 'Teaming / Partnering'){
                wl=new Won_Lost_Analysis__c();
                wl.Selection__c='Teaming / Partnering';
                wl.Description__c=Label.Slection1_Definition;
                wonlostvals.add(wl);
            }
            If(sop.getValue()== 'Client relationship'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Client relationship';
                    wl.Description__c=Label.Slection2_Definition;
                    wonlostvals.add(wl);
            }
            If(sop.getValue()== 'Value proposition'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Value proposition';
                    wl.Description__c=Label.Slection3_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Terms & Conditions'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Terms & Conditions';
                    wl.Description__c=Label.Slection4_Definition;
                    wonlostvals.add(wl);
            }
            If(sop.getValue()== 'Solution alignment and fit'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Solution alignment and fit';
                    wl.Description__c=Label.Slection5_Definition;
                    wonlostvals.add(wl);
                    }
             If(sop.getValue()== 'Transition plan and transformation'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Transition plan and transformation';
                    wl.Description__c=Label.Slection6_Definition;
                    wonlostvals.add(wl);
            }
            If(sop.getValue()== 'Competitive pricing'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Competitive pricing';
                    wl.Description__c=Label.Slection7_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Differentiation'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Differentiation';
                    wl.Description__c=Label.Slection8_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Expertise & knowledge'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Expertise & knowledge';
                    wl.Description__c=Label.Slection9_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Timeliness / Responsiveness'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Timeliness / Responsiveness';
                    wl.Description__c=Label.Slection10_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Pursuit & Sales team effectiveness'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Pursuit & Sales team effectiveness';
                    wl.Description__c=Label.Slection11_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Delivery Team'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Delivery Team';
                    wl.Description__c=Label.Slection12_Definition;
                    wonlostvals.add(wl);
            }
            
            If(sop.getValue()== 'Executive Engagement'){
                    wl=new Won_Lost_Analysis__c();
                    wl.Selection__c='Executive Engagement';
                    wl.Description__c=Label.Slection13_Definition;
                    wonlostvals.add(wl);
            }
            

       
    }
    // return wonlostvals;
    }   
        

    }