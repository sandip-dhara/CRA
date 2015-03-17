public with sharing class RelExtnController {
public Relationship_Suite__c RelSuite{get;set;}
public String retURL {get;set;}
public String returnOptyid {get;set;}

Public String oppPlanId{get;set;}
Public String OppConRole;

public Id OppPId;

    //string OppPlanId;
    public RelExtnController(ApexPages.StandardController controller) {
        //RelSuite.Parent_Contact__c='Deepak';
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        OppId = ApexPages.currentPage().getParameters().get('OppId');
        system.debug('***OppID***'+ OppId);
        this.RelSuite = (Relationship_Suite__c)controller.getRecord();
        this.OppPId = RelSuite.Opportunity_Plan__c;
        
        System.debug('$$$$OppPlanId$$$$' + this.RelSuite.id);
        OppPlanId = ApexPages.currentPage().getParameters().get('OppPlanId');
        //Opportunity_Plan__c OpPlan = [Select Id, Opportunity__c from Opportunity_Plan__c where id =:OppPlanId];
        //OppId = OpPlan.Opportunity__c;
        system.debug('####OppPlanId####'+OppPlanId);
    }
    
    public Relationship_Suite__c getRelSuite()
    {
    return RelSuite;
    }

    
    Public PageReference initialize()
    {
    this.RelSuite.Opportunity_plan__c = OppPlanId;
            system.debug(OppPlanId);
    return null;
    }
    
    Public PageReference Save()
    {
    try { 

            ApexPages.StandardController controller = new ApexPages.StandardController(RelSuite);
            
            //controller.save();
            upsert this.RelSuite;
            pageReference pr = cancel();
            return pr;
            
            }
            catch (DmlException dmlEx) {
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            ApexPages.addMessages(dmlEx);
            return null;
            }
            
    }
            
   // }
    
     public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
        
    }
    
     public List<SelectOption> OppContacts {get
        {List<Relationship_Suite__c> ContactList = new List<Relationship_Suite__c>();
        //String OppPId = string.valueof(Opportunity_plan__c.id);
        system.debug(OppId);
        //system.debug(OppPId);
        //system.debug([select Contact__r.Name from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId]);
        ContactList = [select Contact__r.Id,Contact__r.Name from Relationship_Suite__c  where Opportunity_Plan__c = :OppPId and Contact__c <> :this.relsuite.contact__c];
        List<SelectOption> options= new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        for (Relationship_Suite__c option:ContactList)
            {
            options.add(new SelectOption(option.Contact__r.name,option.Contact__r.name));
            
            }
            return options;
        }
        set;
     }
     
     public String OppContactRole {get
        {
        for (OpportunityContactRole RoleList:[select Role from OpportunityContactRole where OpportunityId = :OppId and ContactId=:this.relsuite.contact__c])
            {
            OppConRole = RoleList.Role;
            }
        return OppConRole;
        }
        set;
     }
     
     Public Id OppId {get
        {
           system.debug('**OppId**'+OppId);
           return OppId;
          
        }
        set;
     } 
     
    
}