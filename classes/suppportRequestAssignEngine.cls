/**********************************************************
* Class Name: suppportRequestAssignEngine
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Contains methods for Assign Support Request & punchOut for Support_Request__c object
***********************************************************/
global class suppportRequestAssignEngine{
    //Extention class for custom exception
    public class applicationException extends Exception {}
    
    /**
    * @description: webService Method used by submit support Request button to start Assignment engine
    * @param: Support Request ID
    * @return: return Success or Error Message to display as an alert Message.  
    */
    WebService Static String StartEngine(String srID){
        try{
            Boolean isSuccess = startAssignment(srID);
            if(isSuccess)
                return Label.SupportRequestAssign_Success;
            else
                return Label.SupportRequestAssign_Error+':'+Label.SupportRequest_Engine_Error;
        }
        catch(Exception e){
            return 'Error:'+e.getMessage();
        }
    }
    
    /**
    * @description: webService Method used by punchOut Request button to search puchout url
    * @param: Support Request ID
    * @return: return URL or Error Message to display as an alert Message.  
    */
    /*WebService Static String StartPunchOut(String srID){
        try{
            String punchOutUrl = searchPunchOutURL(srID);
            if(punchOutUrl!=null && punchOutUrl!='')
                return punchOutUrl;
            else
                return Label.SupportRequestAssign_Error+':'+Label.SupportRequest_Engine_Error;
        }catch(Exception e){
            return Label.SupportRequestAssign_Error+':'+e.getMessage();
        }
    }*/
    
    /**
    * @description: webService Method used by punchOut Request button to search puchout url
    * @param: Support Request ID
    * @return: return URL or Error Message to display as an alert Message.  
    */
    /*public Static String searchPunchOutURL(String srID){
        String returnPunchOutURL = '';
        Support_Request__c srReqDetail = qrySupportRequestDetail(srID);
        //System.debug('########srReqDetail #########'+srReqDetail );
        List<SupportRequest_Routing_Rules__c> matchedRules = searchAssignmentRules(srReqDetail);
        //System.debug('########matchedRules#########'+matchedRules);
        if(matchedRules==null)
            throw new applicationException(Label.SupportRequest_PunchOut_NoRuleMatched);
        //for punch out
        SupportRequest_Routing_Rules__c genericMatchedRule = getGenericMatchedRule(srReqDetail,matchedRules);
        //System.debug('########genericMatchedRule #########'+genericMatchedRule );
        if(genericMatchedRule==null)
            throw new applicationException(Label.SupportRequest_PunchOut_NoRuleMatched);

        returnPunchOutURL = getPunchOutURL(srReqDetail,genericMatchedRule);
        if(returnPunchOutURL!=null && returnPunchOutURL!=''){
            Support_Request__c requestToUpdate = new Support_Request__c(id=srReqDetail.id);
            requestToUpdate.punchOut_URL__c =returnPunchOutURL;
            updateSupportRequest(requestToUpdate);
        }
        return returnPunchOutURL;
    }*/
    
    /**
    * @description: webService Method used by submit support Request button to start Assignment engine
    * @param: Support Request ID
    * @return: return Success or Error Message to display as an alert Message.  
    */
    public Static Boolean startAssignment(String srID){
        String returnPunchOutURL = '';
        Support_Request__c srReqDetail = qrySupportRequestDetail(srID);
        String BypassRecorTypes = Label.Bypass_Partial_Match_BGs;
        
        //System.debug('########srReqDetail #########'+srReqDetail );
        List<SupportRequest_Routing_Rules__c> matchedRules = searchAssignmentRules(srReqDetail);
        //System.debug('########matchedRules#########'+matchedRules);
        if(matchedRules==null)
           throw new applicationException(Label.SupportRequest_AssignEngine_NoRuleMatched);
        //for assignment
        SupportRequest_Routing_Rules__c exactMatchedRule = getExactMatchedRule(srReqDetail,matchedRules);
        System.debug('########exactMatchedRule #########'+exactMatchedRule );
        if(exactMatchedRule==null && srReqDetail.RecordType.Name != BypassRecorTypes){
          //checking for all Country rules
            //Country exception we have to check rules of country blank even if country is populated on support request
            String country = null;
            SupportRequest_Routing_Rules__c partialMatchedRule = getPartialMatchedRule(srReqDetail.BG__c,
                                                                                        srReqDetail.Routing_Region__c,
                                                                                        srReqDetail.Routing_Sub_Region__c,
                                                                                        country,
                                                                                        srReqDetail.Request_Type__c, srReqDetail.Segment__c, matchedRules);
            //checking is rule found if not then checking is support request contains email address for notification
            if(partialMatchedRule ==null){
                throw new applicationException(Label.SupportRequest_AssignEngine_NoRuleMatched);
            }else{
                    exactMatchedRule = partialMatchedRule;
                    System.debug('########exactMatchedRule #########'+exactMatchedRule );
            }
        }
        else if(exactMatchedRule==null && srReqDetail.RecordType.Name == BypassRecorTypes){
        throw new applicationException(Label.SupportRequest_AssignEngine_NoRuleMatched);
        System.debug('########exactMatchedRule #########'+exactMatchedRule );
        }
        
        boolean isSuccess = reAssignSupportRequest(srReqDetail,exactMatchedRule);
        if(isSuccess){
            List<String> emailAddress = new List<String>();
            if(exactMatchedRule!=null && exactMatchedRule.NotificationToEmail__c!=null){
                Set<String> splitEmailIds = SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(',',exactMatchedRule.NotificationToEmail__c);
                emailAddress.addAll(splitEmailIds);
            }
            sendNotification(srReqDetail.id,emailAddress,exactMatchedRule.Email_Template__c);
        }
        return isSuccess;
    }
    
    /**
    * @description: fetch punchout url from matched rule
    * @param: Support Request & Matched Routing rule
    * @return: return PunchOut URL.  
    */
    /*private Static String getPunchOutURL(Support_Request__c srReqDetail,SupportRequest_Routing_Rules__c rule){
        String retPunchOutURL=null;
        if(rule.URL_For_PunchOut__c!=null){
            retPunchOutURL = replaceValuesInPunchOutURL(rule.URL_For_PunchOut__c,srReqDetail);
        }
        return retPunchOutURL;
    }*/
    
    /**
    * @description: replace API Names with Actual values in punchOut URL
    * @param: Support Request & Punchout URL
    * @return: return PunchOut URL.  
    */
    /*private Static String replaceValuesInPunchOutURL(String punchOutURL,Support_Request__c srReqDetail){
        String retPunchOutURL = punchOutURL;
        boolean isFirst = true;
        Map<String,String> fieldsApiNamesValueMap = new Map<String,String>();
        List<String> startTagSpliturlValues = punchOutURL.split('<',0);
        for(String strtTagSplitArr: startTagSpliturlValues){
            if(isFirst){
                isFirst = false;
            }else{
                List<String> endTagSpliturlValues = strtTagSplitArr.split('>',0);
                if(endTagSpliturlValues.size()>0){
                    if(srReqDetail.get(endTagSpliturlValues[0])!=null)
                        fieldsApiNamesValueMap.put(endTagSpliturlValues[0],(String)srReqDetail.get(endTagSpliturlValues[0]));
                }else{
                    //System.debug('Parsing Error');
                }
            }
        }
        //System.debug('@@@@@@@@@fieldsApiNamesValueMap@@@@@@@@@@'+fieldsApiNamesValueMap);
        if(fieldsApiNamesValueMap.size()>0){
            for(String key : fieldsApiNamesValueMap.keySet()){
                retPunchOutURL = retPunchOutURL.replace(key,fieldsApiNamesValueMap.get(key));
            }
        }
        retPunchOutURL = retPunchOutURL.replace('<','');
        retPunchOutURL = retPunchOutURL.replace('>','');
        //System.debug('@@@@@@@@@retPunchOutURL@@@@@@@@@@'+retPunchOutURL);
        return retPunchOutURL;
    }*/
    
    /**
    * @description: reassign support request to user/Queue based on matched rule
    * @param: Support Request & matched routing rule
    * @return: return isSuccess assignment.  
    */
    private Static Boolean reAssignSupportRequest(Support_Request__c srReqDetail,SupportRequest_Routing_Rules__c rule){
        Support_Request__c requestToUpdate = new Support_Request__c(id=srReqDetail.id);
        Boolean isReAssigned=false;
        if(rule!=null){
            if(rule.AssignTo__c!=null){
                //System.debug('@@@@@@@@@@@@@@@'+rule.AssignTo__c);
                requestToUpdate.Ownerid = rule.AssignTo__c;
                isReAssigned = true;
            }
            if(rule.AssignToQueue__c!=null && isReAssigned!=true){
                requestToUpdate.Ownerid = getQueueIdByName(rule.AssignToQueue__c);
                isReAssigned = true;
            }
            if(rule.NotificationToEmail__c!=null)
                isReAssigned = true;
            if(isReAssigned){
                requestToUpdate.Submitted_Date__c=system.today();
                requestToUpdate.isRequestSubmitted__c=true;
                updateSupportRequest(requestToUpdate);
            }
        }
        return isReAssigned;
    }
        
    /**
    * @description: Perform DML operation on support Request
    * @param: Support Request
    * @return: return is update Success .  
    */
    private Static Boolean updateSupportRequest(Support_Request__c requestToUpdate){
        boolean isUpdateStatus = false;
        try{
            update requestToUpdate;
            isUpdateStatus = true;
        }catch (DMLException e){
            throw new applicationException(Label.SupportRequest_Update_Failed);
        }
        return isUpdateStatus;
    }
    
    /**
    * @description: returns queue id based on name
    * @param: Queue name
    * @return: return queue id .  
    */
    private Static Id getQueueIdByName(String queueName){
        QueueSobject queue = [Select QueueId from QueueSobject q where q.Queue.Name =:queueName];
        return queue.QueueId;
    }
    
    /**
    * @description: fetch support Request Detail
    * @param: Support request ID
    * @return: return Support Request detail .  
    */
    private Static Support_Request__c qrySupportRequestDetail(String srID){
        String queryFields = Label.SupportRequest_Fields_ToQuery;
        String query = 'Select '+ queryFields + ' From Support_Request__c where id=\''+srID+'\'';
        Support_Request__c srReqDetail = Database.query(query);
        return srReqDetail;
    }
    
    /**
    * @description: fetch support Request routing rule Detail
    * @param: Support request Detail
    * @return: return Request routing rule Detail.  
    */
    private Static List<SupportRequest_Routing_Rules__c> searchAssignmentRules(Support_Request__c srReqDetail){
        //System.debug('#######RecordTypeid########'+srReqDetail.RecordTypeid);
        String formName = SupportRequestRoutingRulesTriggerUtil.getRecordTypeNameById(srReqDetail.RecordTypeid);
        //System.debug('###############'+formName );
        String queryFields = Label.SupportRequestRules_Fields_ToQuery;
        
        /* query modified on 13-05-2013 
                CR for this change: GSB Site Survey : 8276 
                    Sorting the query to find an exact match for a blank (null) segment. 
        */
       // String query = 'Select '+ queryFields + ' From SupportRequest_Routing_Rules__c where Form_Name_RecordType_Name__c like\''+formName+'%\'';
        String query = 'Select '+ queryFields + ' From SupportRequest_Routing_Rules__c where Form_Name_RecordType_Name__c like\''+formName+'%\' ORDER BY SEGMENT__C ASC';
        List<SupportRequest_Routing_Rules__c> matchedRules = Database.query(query);
        return matchedRules;
    }
    
    /**
    * @description: match support Request fields with matched rule fields
    * @param: Support request & matched routing rule
    * @return: return Request routing rule Detail.  
    */
    private Static SupportRequest_Routing_Rules__c getExactMatchedRule(Support_Request__c srReqDetail,List<SupportRequest_Routing_Rules__c> matchedRules){
        SupportRequest_Routing_Rules__c exactMatchRule = null;
        for(SupportRequest_Routing_Rules__c rule : matchedRules){
       
            //System.debug('######Request########'+srReqDetail.Routing_Region__c+'='+rule.Region__c+'#######Rule#######');
            //System.debug('######Request########'+srReqDetail.Routing_Sub_Region__c +'='+rule.Sub_Region__c+'#######Rule#######');
            //System.debug('######Request########'+srReqDetail.Routing_Country__c +'='+rule.Country__c+'#######Rule#######');
            //System.debug('######Request########'+srReqDetail.Request_Type__c +'='+rule.Workshop_Type__c +'#######Rule#######');
            if(srReqDetail.BG__c.equalsIgnorecase(rule.Business_Group__c)
                && (srReqDetail.Routing_Region__c !=null? srReqDetail.Routing_Region__c.equalsIgnorecase(rule.Region__c) : true)
                    && (srReqDetail.Routing_Sub_Region__c !=null? srReqDetail.Routing_Sub_Region__c.equalsIgnorecase(rule.Sub_Region__c) : true)
                        && (srReqDetail.Routing_Country__c !=null? srReqDetail.Routing_Country__c.equalsIgnoreCase(rule.Country__c) : true)
                            && (srReqDetail.Request_Type__c!=null? srReqDetail.Request_Type__c.equalsIgnoreCase(rule.Workshop_Type__c) : true)
                                && (srReqDetail.Segment__c!=null? srReqDetail.Segment__c.equalsIgnoreCase(rule.Segment__c) : true)){
                      //  System.debug('$$$$$$$$$$$Rule Matched$$$$$$$$$$$');
                        
                        exactMatchRule = rule;
                        break;
            }
        }
        return exactMatchRule;
    }
    
    /**
    * @description: match support Request fields with matched rule fields
    * @param: Support request & matched routing rule
    * @return: return Request routing rule Detail.  
    */
    private Static SupportRequest_Routing_Rules__c getPartialMatchedRule(String BgParam,String regionParam,String subRegionParam,String countryParam,String worKshopType ,String segment, List<SupportRequest_Routing_Rules__c> matchedRules){
        SupportRequest_Routing_Rules__c partialMatchRule = null;
        for(SupportRequest_Routing_Rules__c rule : matchedRules){
         //   System.debug('######Request########'+ regionParam +'='+rule.Region__c+'#######Rule#######');
         //   System.debug('######Request########'+ subRegionParam +'='+rule.Sub_Region__c+'#######Rule#######');
         //   System.debug('######Request########'+ countryParam +'='+rule.Country__c+'#######Rule#######');
         //   System.debug('######Request########'+ worKshopType +'='+rule.Workshop_Type__c +'#######Rule#######');
         //   System.debug('######Request########'+ Segment +'='+rule.Segment__c +'#######Rule#######');
            if((BgParam !=null? BgParam.equalsIgnorecase(rule.Business_Group__c): true)
                && (regionParam !=null? regionParam.equalsIgnorecase(rule.Region__c): true)
                    && (subRegionParam !=null? subRegionParam.equalsIgnorecase(rule.Sub_Region__c): true)
                        && (countryParam !=null? countryParam.equalsIgnoreCase(rule.Country__c): true)
                            && (worKshopType !=null? worKshopType .equalsIgnoreCase(rule.Workshop_Type__c): true)
                                && (segment !=null? segment .equalsIgnoreCase(rule.Segment__c): true)){
                  //      System.debug('$$$$$$$$$$$partial Rule Matched$$$$$$$$$$$');
                        partialMatchRule = rule;
                        break;
            }
        }
        return partialMatchRule;
    }
    
    /**
    * @description: match support Request fields with matched rule fields
    * @param: Support request & matched routing rule
    * @return: return Request routing rule Detail.  
    */
    /*private Static SupportRequest_Routing_Rules__c getGenericMatchedRule(Support_Request__c srReqDetail,List<SupportRequest_Routing_Rules__c> matchedRules){
        SupportRequest_Routing_Rules__c GenericMatchRule = null;
        for(SupportRequest_Routing_Rules__c rule : matchedRules){
            if(rule.Region__c == null && rule.Sub_Region__c==null && rule.Country__c==null){
                GenericMatchRule = rule;
            }
        }
        return GenericMatchRule;
    }*/
    
    /**
    * @description: Send Email notification to email address mentioned in matched rule with email template
    * @param: Support request ID, emailID's & Template Name
    * @return: return void.  
    */
    public static void sendNotification(String sRequestID, List<String> paramEmails,String templateName){
        EmailTemplate et = [select id from EmailTemplate where developername=:templateName];
        if(et!=null){
            SupportRequestNotifications.sendNotification(sRequestID,paramEmails,et.id);
        }
    }
}