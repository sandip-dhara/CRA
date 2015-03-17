/***********************************************************
* Trigger Name: TDSFDCUpdateCaseCommentsonCase 
* Author: HP (Sreedhar Jagannath)
* Date: 25-AUG-2013 
* Requirement # Request Id: 
* Description: Update Case Comments and Case Comment Creator On Case Fields for Case Admin Support Record Type
***********************************************************/
trigger TDSFDCUpdateCaseCommentsonCase on CaseComment (after insert,after update,after delete) {
    Set<ID> caseids = new Set<ID>();
    List<Case> casestoupdate = new List<Case>();    
    Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Admin Support').getRecordTypeId();

    List<User> users = [select id,Name from User where isActive = True AND id =:Userinfo.getUserId()];
    Map<Id,String> usermapname = new Map<Id,String>();

    for(User u : users){
        usermapname.put(u.id,u.Name);
    }
    
    if(Trigger.isInsert){

        for(CaseComment casecomment : trigger.new){
            if(casecomment.parentid <> NULL){
                caseids.add(casecomment.parentid);
            }
        }
        Map<Id,Case> mapCase=new Map<Id,Case>([Select Id,Case_Comments__c,Status from Case where Id IN :caseids AND RecordTypeid =: caseRecordTypeId]);  
        for (CaseComment t: Trigger.new){
            if(mapCase.containskey(t.ParentId)){
                if(mapCase.get(t.ParentId).Status<>'Closed' && t.CommentBody <> NULL){ 
                    if(mapCase.get(t.ParentId).Case_Comments__c <> NULL && (!mapCase.get(t.ParentId).Case_Comments__c.contains(t.CommentBody))){
                        mapCase.get(t.ParentId).Case_Comments__c = mapCase.get(t.ParentId).Case_Comments__c+'(' +usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate;  
                    } 
                    else if(mapCase.get(t.ParentId).Case_Comments__c == NULL ){                       
                        mapCase.get(t.ParentId).Case_Comments__c = '('+usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate;    
                    }               
                }
                casestoupdate.add(mapCase.get(t.ParentId));
            }   
            if(casestoupdate.size() > 0){
                try{
                    Database.update(casestoupdate,false);
                }
                catch(Exception e){
                    System.debug('Exception'+e);
                }
            }
        }
    }

    if(Trigger.isUpdate){  
        for(CaseComment casecomment2 : trigger.old){
            if(casecomment2.parentid <> NULL){
                caseids.add(casecomment2.parentid);
            }
        }
        Map<Id,Case> mapCase2=new Map<Id,Case>([Select Id,Case_Comments__c,Status from Case where Id IN :caseids AND RecordTypeid =: caseRecordTypeId]);   
        for (CaseComment t: Trigger.old){
        CaseComment tnew = Trigger.NewMap.get(t.Id);
            if(mapCase2.containskey(t.ParentId)){
                if(mapCase2.get(t.ParentId).Status<>'Closed' && t.CommentBody <> NULL){ 
                    if(mapCase2.get(t.ParentId).Case_Comments__c <> NULL && (mapCase2.get(t.ParentId).Case_Comments__c.contains(t.CommentBody))){
                        mapCase2.get(t.ParentId).Case_Comments__c = mapCase2.get(t.ParentId).Case_Comments__c.remove('('+usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate).trim();  
                        mapCase2.get(t.ParentId).Case_Comments__c = mapCase2.get(t.ParentId).Case_Comments__c+'('+usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate;     
                    }
                    else if(mapCase2.get(t.ParentId).Case_Comments__c <> NULL && (!mapCase2.get(t.ParentId).Case_Comments__c.contains(t.CommentBody))){
                        mapCase2.get(t.ParentId).Case_Comments__c = mapCase2.get(t.ParentId).Case_Comments__c+'('+usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate;  
                    } 
                }
            }
            casestoupdate.add(mapCase2.get(tnew.ParentId));
        }

        if(casestoupdate.size() > 0){
            try{
                Database.update(casestoupdate,false);
            }
            catch(Exception e){
                System.debug('Exception'+e);
            }
        }
    }

    if(Trigger.isDelete){ 
        for(CaseComment casecomment1 : trigger.old){
            if(casecomment1.parentid <> NULL){
                caseids.add(casecomment1.parentid);
            }
        }
        Map<Id,Case> mapCase1=new Map<Id,Case>([Select Id,Case_Comments__c,Status from Case where Id IN :caseids AND RecordTypeid =: caseRecordTypeId]);   
        for (CaseComment t: Trigger.old){
            if(mapCase1.containskey(t.ParentId)){
                if(mapCase1.get(t.ParentId).Status<>'Closed' && t.CommentBody <> NULL){ 
                    if(mapCase1.get(t.ParentId).Case_Comments__c <> NULL && (mapCase1.get(t.ParentId).Case_Comments__c.contains(t.CommentBody))){
                        mapCase1.get(t.ParentId).Case_Comments__c = mapCase1.get(t.ParentId).Case_Comments__c.remove('('+usermapname.get(t.CreatedById) + ' '+' '+' - '+t.CommentBody+' '+''+' '+t.CreatedDate).trim();  
                    }            
                }
            }
            casestoupdate.add(mapCase1.get(t.ParentId));
        }

        if(casestoupdate.size() > 0){
            try{
                Database.update(casestoupdate,false);
            }
            catch(Exception e){
                System.debug('Exception'+e);
            }
        }    
    }
}