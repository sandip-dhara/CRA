public with sharing class PLMAdminClass {
    
    //Properties for Service Lines
    public String ServiceLineName{get;set;} 
    public User ServiceLineUser{get;set;} 
    public String ServiceLineShortDesc{get;set;} 
    public Boolean ServiceLineIsActive{get;set;}    
    public PageReference DoSave() {
        try{    
            SLObject = new Service_Line__c();
            SLObject.Name__c = ServiceLineName; 
            //SLObject.User__c = ServiceLineUser;  
            SLObject.Is_Active__c = ServiceLineIsActive;            
            SLObject.Short_Description__c = ServiceLineShortDesc; 
            upsert SLObject;    
            return ApexPages.CurrentPage();
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception:' + e.getMessage()));
            return null;            
        }        
    }
    public Service_Line__c SLObject;
    public Service_Line__c getSLObject(){
        return new Service_Line__c();
    }    
    public List<Service_Line__c> SLc{
        get{
            return [select Name__c,Leader_User__c,Is_Active__c, Short_Description__c from Service_Line__c];
        }
        set;        
    }
    
    public Role__c RoleObject;
    public Role__c getRoleObject(){
        return new Role__c();
    }    
    public List<Role__c> RolesList{
        get{
            return [select Role_Name__c, Is_Active__c from Role__c];
        }
        set;        
    }    
}