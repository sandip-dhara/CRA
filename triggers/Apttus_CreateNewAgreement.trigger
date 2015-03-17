trigger Apttus_CreateNewAgreement on Apttus__APTS_Agreement__c (before update) 
{
    List<Apttus__APTS_Agreement__c> aptlist;
    Apttus__APTS_Agreement__c newAgmt;
    Attachment t;
    //static boolean flag;
    ID rt;
    QueueSobject qs = [Select QueueId from QueueSobject where SobjectType = 'Apttus__APTS_Agreement__c' AND Queue.Name = 'ACO'];
    ID record = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeId();
    //List<Attachment> att = new List<Attachment>([Select id, Name, body, ParentId from Attachment ]);
    System.debug('***@1@***Entered the trigger');
    for(Apttus__APTS_Agreement__c agmt: trigger.new)
    {
        //if(lstAgreement.size() > 0)
        if(agmt.External_Agreement_Id__c != NULL){           
            System.debug('***@1@***If list size is more than 1');
            //Apttus__APTS_Agreement__c agmt = lstAgreement[0];
            system.debug('@@@@@ refresh is @@@@ '+agmt.Axiom_Refresh__c);
            system.debug('@@@@@ refresh new value is @@@ '+Trigger.new[0].Axiom_Refresh__c);
            system.debug('@@@@@ record type is @@@@ '+agmt.Axiom_Record_Type__c);
            system.debug('@@@@@ status is @@@@ '+agmt.Apttus__Status__c);
          //  if(agmt.Axiom_Refresh__c == true && agmt.Axiom_Record_Type__c != NULL && (agmt.Apttus__Status__c == 'Fully Signed' || agmt.Apttus__Status__c == 'Completed' || agmt.Apttus__Status__c == 'Abandoned' ))
          if(agmt.Axiom_Refresh__c == true && agmt.Axiom_Record_Type__c != NULL && ((agmt.Apttus__Status_Category__c =='In Signatures' && agmt.Apttus__Status__c == 'Fully Signed') || ( agmt.Apttus__Status_Category__c =='Completed' && agmt.Apttus__Status__c == 'Completed') || (agmt.Apttus__Status_Category__c == 'Abandoned' && agmt.Apttus__Status__c == 'Abandoned' )))
             {
                System.debug('***@1@***frist level of validation');
                // check if it is an agreement request
                
                if(agmt.RecordTypeId == record)    
                {
                    System.debug('***@1@***When record type matched');
                    if(agmt.Apttus__Status__c!='Abandoned'){
                        System.debug('***@1@***When status is abandoned');
                        newAgmt = new Apttus__APTS_Agreement__c();
                        newAgmt = agmt.clone(false,true,false,false);
                        try
                        {
                                //rt = [Select id, name from RecordType where Name = :agmt.Axiom_Record_Type__c];
                                rt = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(agmt.Axiom_Record_Type__c).getRecordTypeId();
                        }
                        catch(Exception e)
                        {
                             return;
                        }
                    
                        //newAgmt.RecordTypeId = rt.id;
                        newAgmt.RecordTypeId = rt;
                        newAgmt.Apttus__Parent_Agreement__c = agmt.Id;
                        
                        
                            newAgmt.Apttus__Status_Category__c = 'In signatures';
                            newAgmt.Apttus__Status__c = 'Ready for signatures';
                        if(agmt.Apttus__Status__c == 'Completed'){
                            newAgmt.OwnerId = qs.QueueId;
                        }
                        newAgmt.Name = agmt.Contract_Type_Abbreviation__c + '-' + agmt.Apttus__Account__r.Name;
                        newAgmt.External_Agreement_Id__c = agmt.External_Agreement_Id__c;
                        insert newAgmt;
                        //insert newAgmt;  moving insert out of for loop
                        system.debug('@@@@@@ new inserted record is@@@ '+newAgmt.id);
                        // Insert Attachment
                        List<Attachment> att = [Select id, Name, body, ParentId, LastModifiedDate from Attachment where ParentId =: agmt.id Order By LastModifiedDate ASC];
                        for(Attachment a: att)
                        {                        
                            //if(a.ParentId == agmt.id){
                               t = new Attachment();
                                t.Body = a.Body;
                                t.ParentId = newAgmt.Id;
                                t.Name = a.Name;
                                insert t;    
                            //}                           
                        }
                        
                        // if the agreement request is fully signed, send the newly created agreement for activation
                        if(agmt.Apttus__Status__c == 'Fully Signed')
                        {
                            String sessionID = UserInfo.getSessionId();
                            Apttus_ActivateAgreement.activate(newAgmt.Id, sessionID);
                            System.debug('***@1@***Request fully signed, sent for activation');
                        }
                    }
                    
                    // update the status for the agreement request
                    agmt.Apttus__Status_Category__c = 'Request';
                    agmt.Apttus__Status__c = 'Completed';
                    System.debug('***@2@***Request: change status');
                                    
                }     
                else // if it is an agreement     
                {
                     if(agmt.Apttus__Status__c =='Abandoned'){
                        System.debug('Abandoned');
                        agmt.Apttus__Status_Category__c = 'Agreement';
                        agmt.Apttus__Status__c = 'Abandoned';
                        System.debug('***@3a@***Agreement: Abandoned= '+ agmt.Apttus__Status_Category__c);
                     }
                
                    if(agmt.Apttus__Status__c == 'Completed')
                    {
                        agmt.Apttus__Status_Category__c = 'In signatures';
                        agmt.Apttus__Status__c = 'Ready for signatures';
                        agmt.OwnerId = qs.QueueId;
                        System.debug('***@4@***Agreement: completed = '+ agmt.Apttus__Status_Category__c);
                    }
                    if(agmt.Apttus__Status__c == 'Fully Signed')
                    {
                        // send the agreement for activation
                        System.debug('send the agreement for activation');
                        String sessionID = UserInfo.getSessionId();
                        Apttus_ActivateAgreement.activate(agmt.Id, sessionID);
                        System.debug('***@5@***Agreement: completed');                        
                    }
                }
            }
        }
    }
    
}