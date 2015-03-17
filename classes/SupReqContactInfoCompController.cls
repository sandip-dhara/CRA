public class SupReqContactInfoCompController
 {
  public string SupportRequestId {get;set;}

  public Boolean isOpportunityTeamMembersListEmpty{get; set;}
  
    public List<Contact> getContactEmail() {
        Support_Request__c oSupportRequest=[Select Id,Contact__c from Support_Request__c where Id=:this.SupportRequestId ];
          
        List<Contact>  lstContacts = [select c.Name, c.MobilePhone,c.Phone, c.Email , c.Job_Role__c , c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingCountry,  c.MailingCity From Contact c where Id=:oSupportRequest.Contact__c]; 
        
        
         
        return lstContacts;
    }
}