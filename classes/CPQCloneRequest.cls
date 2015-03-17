/**
* Class Name: CPQCloneRequest
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Revision for Support request used for CPQ
*/
global class CPQCloneRequest{

   Webservice static String CPQCloneRequestForRevision(String requestId,String HPQuoteId,String clickedFrom){
        String redirectVFPageName = '';
        String redirectToEditVFPageName = '';
        Boolean showDirectVisualforcePage = false;
        String returnURLorErrorMessage = '';
        User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        //Support_Request__c objSupportRequest = [select id,Support_Category__c,Support_Sub_Type__c from Support_Request__c where id=:requestId];
        List<Support_Request_FS_CS__c>  listSupportRequestMapping = [select Eligible_BG__c,isVisualforce__c,Non_Eligible_Countries__c,punchOut_BG__c,Request_SubType__c,SupportReqType__c,Visualforce_Page_Name__c,View_VF_Page_Name__c from Support_Request_FS_CS__c where isVisualforce__c=true];
        for(Support_Request_FS_CS__c requestType : listSupportRequestMapping){
            if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(objUser.Business_Group__c) || ((objUser.Business_Group__c == 'ES' || objUser.Business_Group__c == 'SW') && SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains('ESSN'))){
                if(requestType.isVisualforce__c && requestType.Visualforce_Page_Name__c != null && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Country) && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Quote_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){
                    showDirectVisualforcePage = true;
                    redirectToEditVFPageName = requestType.Visualforce_Page_Name__c;
                    redirectVFPageName = requestType.View_VF_Page_Name__c;
                }
            }
        }
        system.debug('******redirectVFPageName****'+redirectVFPageName+'#######showDirectVisualforcePage#####'+showDirectVisualforcePage);
        if(redirectVFPageName != '' && showDirectVisualforcePage && redirectToEditVFPageName != ''){
            String soql = getCreatableFieldsSOQL('Support_Request__c','Id=\''+requestId+'\'');
            Support_Request__c objOldRequest = (Support_Request__c)Database.query(soql);
            if(objOldRequest.Request_Submitted_From__c == redirectVFPageName){
                Support_Request__c  objNewRequest = objOldRequest.clone(false, true);
                objNewRequest.Parent_Support_Request_Number__c = objOldRequest.id;
                objNewRequest.Submitted_Date__c = null;
                objNewRequest.CPQ_Submitted_Date__c = null;
                objNewRequest.isRequestSubmitted__c = false;
                objNewRequest.Status__c ='New';
                if(HPQuoteId != '' && HPQuoteId != null)
                    objNewRequest.HP_Quote__c = HPQuoteId;
                insert objNewRequest;
                if(clickedFrom != '' && clickedFrom != null){
                    if(clickedFrom == 'Special Pricing'){
                        returnURLorErrorMessage =  '/apex/'+redirectVFPageName+'?id='+objNewRequest.id+'&pageMode=SpecialRevision&parentRequest='+objOldRequest.id;
                    }
                    else if(clickedFrom == 'Pricing Escalation'){
                        returnURLorErrorMessage =  '/apex/'+redirectToEditVFPageName+'?id='+objNewRequest.id+'&pageMode=PricingRevision&parentRequest='+objOldRequest.id;
                    }
                }
                else{
                    returnURLorErrorMessage =  '/apex/'+redirectVFPageName+'?id='+objNewRequest.id+'&pageMode=Revision&parentRequest='+objOldRequest.id;       
                }
            }
            else{
                returnURLorErrorMessage = Label.CPQCloneErrorWithDifferentBG;
            }
            
            return returnURLorErrorMessage;
        }
        else{
            returnURLorErrorMessage = Label.CPQCloneErrorNotSupportedBG;
            return returnURLorErrorMessage;
        }
        
   }
   public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
    
    //Delete Support Request
    Webservice static String CPQDeleteSupportRequest(String requestId){
        Support_Request__c objDeleteRequest = [select id from Support_Request__c where id =: requestId];
        //delete objDeleteRequest;
        Database.DeleteResult deleteResult = Database.delete(objDeleteRequest,false);
        return 'Deleted';
    }
    
}