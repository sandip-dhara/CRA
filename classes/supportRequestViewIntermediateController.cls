public with sharing class supportRequestViewIntermediateController {
    public Support_Request__c objSupportRequest{get;set;}
    public Boolean showStandardPage{get;set;}
    public supportRequestViewIntermediateController(ApexPages.StandardController controller) {
        this.objSupportRequest = (Support_Request__c )controller.getRecord();
        objSupportRequest = [select id,Request_Submitted_From__c,isRequestSubmitted__c,Type_of_Request__c,Parent_Support_Request_Number__c from Support_Request__c where id=:objSupportRequest.id];
        showStandardPage = false;
    }
    public PageReference redirect() {
        system.debug(objSupportRequest.Request_Submitted_From__c);
        if(objSupportRequest.Request_Submitted_From__c == null){
            showStandardPage= true;
            return null;
        }
        else if(objSupportRequest.Request_Submitted_From__c == 'Standard Layout'){
            showStandardPage= true;
            return null;
        }
        else{
            string redirectURL;
            if(!objSupportRequest.isRequestSubmitted__c){
                if(objSupportRequest.Type_of_Request__c == 'Revision'){
                    redirectURL='/apex/'+objSupportRequest.Request_Submitted_From__c +'?id='+objSupportRequest.id+'&pageMode=Revision&parentRequest='+objSupportRequest.Parent_Support_Request_Number__c;
                }
                else{
                    List<Support_Request_FS_CS__c> listRequestMapping = [select id,Visualforce_Page_Name__c from Support_Request_FS_CS__c where View_VF_Page_Name__c=:objSupportRequest.Request_Submitted_From__c];
                    if(!listRequestMapping.isEmpty()){
                        redirectURL='/apex/'+listRequestMapping[0].Visualforce_Page_Name__c +'?id='+objSupportRequest.id+'&pageMode=ViewFromList&savedRequest=True';
                    }
                }
                
                
            }
            else{
                redirectURL='/apex/'+objSupportRequest.Request_Submitted_From__c +'?id='+objSupportRequest.id+'&pageMode=ViewFromList';
            }
            PageReference Page=new PageReference(redirectURL);
            page.setRedirect(true);
            return page;        
        }
    }

}