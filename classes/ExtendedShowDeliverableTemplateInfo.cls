public class ExtendedShowDeliverableTemplateInfo {

    public ExtendedShowDeliverableTemplateInfo(ApexPages.StandardController controller) {
       rdc = (Release_Deliverable__c)controller.getRecord();
       if(string.isNotEmpty(rdc.Id))
       {
           List<Release_Deliverable__c> c = [select Stage_Deliverable_ID__r.Deliverable_ID__r.id,Stage_Deliverable_ID__r.Deliverable_Name__c 
                   from Release_Deliverable__c where id=:rdc.Id];
           if(c.size() > 0)
           {
               Id parentId = c[0].Stage_Deliverable_ID__r.Deliverable_ID__r.id;
               myLabel  = c[0].Stage_Deliverable_ID__r.Deliverable_Name__c;
               Attachments = [select id, name, body from Attachment where ParentId = :parentId];
           }
           ShowFlag = true;
       }
       else
       {
           ShowFlag = false;
       }
    }
    Release_Deliverable__c rdc;
    public List<Attachment> Attachments{get;set;}
    public boolean ShowFlag{get;set;}
    public string myLabel{get;set;}
}