public with sharing class ExistingRenwalOptyLookup { 
    public List<opportunity> listRenewalopportunities{get;set;}
    public String searchText {get;set;}
    public String myUserID;
    
    /**
    * @description: return flag is Search Result Empty or not
    * @return: boolean True if list is empty
    * 
    */
    public Boolean getIsResultEmpty(){
        Boolean returnBoolean = false;
        if(listRenewalopportunities==null || listRenewalopportunities.size()<1){
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
        searchText = System.currentPageReference().getParameters().get('lksrch');
        searchopportunities();                      
        system.debug('-->listRenewalopportunities : ' + listRenewalopportunities); 
        
    }
    
    /**
    * @description: run the search and return the records found. 
    * 
    * 
    */
    public void searchopportunities() {
       Id RecordTypeId=null;
       myUserID = UserInfo.getUserId();
       system.debug('----> userid:' +myUserID);
       try{
           RecordTypeId = RecordTypeId = RecordTypeIdHelper.getRecordTypeId ('opportunity','Renewal');
          }
       Catch(Exception ex){
          System.debug('Exception:'+ex.getMessage());
          }       
       String soql = 'select id, name,account.name, type from opportunity';
       String whereCondition = '';
       if(RecordTypeId!=null){
           whereCondition = whereCondition + ' RecordTypeId = \''+ RecordTypeId + '\' and Owner.id = \'' + myUserID + '\' and ';
           }
       system.debug('-->searchText : ' + searchText ); 
       String tmpSearchText = searchText;
       if (tmpSearchText != null && tmpSearchText != '') {
           system.debug('-->before query : '); 
           tmpSearchText = tmpSearchText.replaceAll('\\*','%');
           whereCondition = whereCondition +  ' name LIKE \'' + tmpSearchText +'%\' and';
           }
       if(whereCondition!=null && whereCondition.length()>0 ){
           whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
           }
       else{
            whereCondition = '';
           }
       soql = soql + whereCondition + 'Order by Name limit  200';
       System.debug('query>>>'+soql);
       listRenewalopportunities = database.query(soql); 
       system.debug('-->listRenewalopportunities : ' + listRenewalopportunities);
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