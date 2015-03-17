public with sharing class ContactCustomLookupController { 
    public List<OpportunityContactRole> listContact2{get;set;}
    public List<ContactWrapper> listContact{get;set;}
    public String searchText {get;set;}
    public String Text;
    Public String OptyId;
    public String OppPlanId;
    
    /**
    * @description: return flag is Search Result Empty or not
    * @return: boolean True if list is empty
    * 
    */
    
    public class ContactWrapper{
        public String ContactName{get;set;}
        public OpportunityContactRole OpportunityContact{get;set;}
        
        public ContactWrapper(String s, OpportunityContactRole con){
            ContactName=s;
            OpportunityContact=con;
        
        }
    }
  
    public Boolean getIsResultEmpty(){
        Boolean returnBoolean = false;
        if(listContact==null || listContact.size()<1){
        returnBoolean=true;
        }
        return returnBoolean;
    }
    
    /**
    * @description: Method Used by page, on page load to initalize start data
    * 
    * 
    */
    public void initialize() {
        Text = System.currentPageReference().getParameters().get('lksrch');
        List<string> parts = Text.split(',');
        searchText = parts[0];
        OptyId = parts[1];
        OppPlanId = parts[2];
        system.debug('**********Opty Id ******'+ OptyId); 
        listContact= new List<ContactWrapper>();
        listContact2= new List<OpportunityContactRole>();
        searchContacts();                      
        system.debug('-->listContact : ' + listContact);   
        
        }
    
    /**
    * @description: run the search and return the records found. 
    * 
    * 
    */
    public void searchContacts() {
       Id RecordTypeId=null;
       List<Id> contactIds = new List<Id>();
       List<Relationship_Suite__c> relList = [Select id , Contact__c From Relationship_Suite__c Where Opportunity_Plan__c = :oppPlanId];
       for(Relationship_Suite__c rel : relList){
           contactIds.add(rel.Contact__c);
       }
       String soql = 'select contact.id,Contact.name,isPrimary,Role,OpportunityId from OpportunityContactRole';
       //String soql = 'select contact.id,Contact.name,isPrimary,Role,OpportunityId from OpportunityContactRole Where ContactId NOT IN :contactIds ';
       String whereCondition = '';
       whereCondition = whereCondition + ' OpportunityId = \''+ OptyId + '\' and ';
       whereCondition = whereCondition + ' ContactId NOT IN :' + 'contactIds' + ' and ' ;
       system.debug('-->searchText : ' + searchText ); 
       String tmpSearchText = searchText;
       if (tmpSearchText != null && tmpSearchText != '') {
           system.debug('-->before query : '); 
           tmpSearchText = tmpSearchText.replaceAll('\\*','%');
           whereCondition = whereCondition +  ' Contact.Name LIKE \'' + tmpSearchText +'%\' and';
           system.debug('***whereCondition***'+whereCondition);
           }
       if(whereCondition!=null && whereCondition.length()>0 ){
           whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
           }
       else{
            whereCondition = '';
           }
       soql = soql + whereCondition + 'limit  200';
       system.debug('***whereCondition***'+whereCondition);
       System.debug('query>>>'+soql);
       
       listContact2 = database.query(soql); 
       
       for(OpportunityContactRole l : listContact2){
           String contactname =String.escapeSingleQuotes(l.Contact.Name);
           //String contactname =l.Contact.Name.replace('\'','Z');
           listContact.add(new ContactWrapper(contactname,l));
           
       }
       
       
       system.debug('-->listContact : ' + listContact2);
    }

    /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    * 
    */
    public String getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
        }

    /**
    * @description: sed by the visualforce page to send the link to the right dom element for the text box
    * @return: String returns url lknm paramter value
    * 
    */
    public String getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
        } 
}