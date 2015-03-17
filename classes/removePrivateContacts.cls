public class removePrivateContacts {
    
    private final PageReference fromPage;
    private transient ApexPages.Message currentMsg;
    
    public Contact[] arryContact;
    public PageReference pgReturnPage;
  
  // Constructor
    public removePrivateContacts(ApexPages.StandardSetController 
                                   cntlr){
    arryContact = cntlr.getSelected();
              
    
    // Build the return page 
    try{
        String returnUrl = ApexPages.currentPage().getParameters().get('retUrl');
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
       }
    catch(exception e){}
    }
    
    public pageReference deleteContacts(){
        
         if(arryContact==null ||(arryContact!=null && arryContact.isempty()) )
            {
                //Throws error if no record is selected in the list view and ChangeOwner button is clicked. 
                String msg = 'Please select at least one contact.';
                currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
                ApexPages.addMessage(currentMsg);
                
            }
        
        Contact[] contacts = [Select id, Accountid from Contact where id in :arryContact and Accountid!=null];
        system.debug('arryContact '+arryContact );
         if (contacts.size()>0){
            String msg ='You cannot select Contacts associated with Accounts';
            currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
                ApexPages.addMessage(currentMsg);
            }
         
        List<Contact> contactstodelete = new List<Contact>();
        
        for(Contact c: [Select id, Accountid from Contact where id in :arryContact and AccountId=null]){
                if (contacts.size()<1){
                Contact cDel = new Contact(Id=c.Id);
                contactstodelete.add(cDel);
                }
        }
        if(arryContact==null ||(arryContact!=null && arryContact.isempty()) )
            {
                return null;
            }
        if(contactstodelete.size()<1 && contacts.size()>0){
                return null;
        }
        else{
        Database.delete(contactstodelete);
        String msg = 'Number of Contacts Deleted: '  + contactstodelete.size()+'</br>';
        msg = msg + '<br><b>Please go to Outlook and remove Contact from Sync Folder in Outlook, or mark Contact as private in Outlook. </b></br>';
        currentMsg = new ApexPages.Message(ApexPages.severity.INFO, msg);
                ApexPages.addMessage(currentMsg);
        return null;
        }
    }
  
    public PageReference returnPage(){
        return pgReturnPage;
    }

}