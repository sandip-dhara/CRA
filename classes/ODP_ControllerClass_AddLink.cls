public class ODP_ControllerClass_AddLink {

    public ODP_ControllerClass_AddLink() {
        RenderSaveButton = false;
        Id = ApexPages.currentPage().getParameters().get('id');
        if(String.IsEmpty(Id))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invaild parameter.'));
            return;
        }
        List<Stage_Work_Element__c> swe = [select Name__C from Stage_Work_Element__c where Id=:Id];
        if(swe.size() < 1)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Invaild parameter.'));
            return;
        }
        RenderSaveButton = true;
        link = new Link__c();
        link.Stage_Work_Element_ID__c = Id;
    }


    public Link__c link {get;set;}
    
    string Id;
    public Boolean RenderSaveButton{get;set;}
    public void Save()
    {
        try{
            if(string.IsEmpty(link.Name__c) || string.IsEmpty(link.Link__c))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'must provide the link name link url.'));
                return;
            }
            insert link;
            callfunc='<script> func(); </script>';
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()+'Please Check your input before saving.'));
            return;
        }  
    }
    public String callfunc{get;set;}

}