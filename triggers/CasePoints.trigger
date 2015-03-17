trigger CasePoints on Case (after insert, after update) {
    List<Case> oChangeCases;
    Map<Id,Decimal> newIDMap = new Map<Id,Decimal>();
    Map<Id,Decimal> oldIDMap = new Map<Id,Decimal>();
    List<UserData__c> UserDataList = new List<UserData__c>();
    Map<ID,UserData__c> UDMap = new Map<ID,UserData__c>();       

    InUseRoster__c fieldProperties = InUseRoster__c.getInstance('case');
    if (fieldProperties == null) return;    //no field to incrememnt

    String UD_FieldStr = fieldProperties.UD_WorkloadField__c;
    String Case_FieldStr = fieldProperties.WorkloadIncrementField__c;

    if (UD_FieldStr != null) {
    
        if (trigger.isUpdate) {
            oChangeCases = new List<Case>();
            for(Case caseObj : trigger.new){
                Id oldOwnerId = trigger.oldMap.get(caseObj.Id).OwnerId;
                Id newOwnerId = caseObj.OwnerId;
                if((newOwnerId != oldOwnerId)){ 
                    system.debug('debtesting');
                    Decimal newD = newIDMap.get(newOwnerId);
                    Decimal oldD = oldIDMap.get(oldOwnerId);
    
                    Decimal thisCasePoints;
                    if (Case_FieldStr == null) thisCasePoints = 1;
                    else thisCasePoints = (Decimal)caseObj.get(Case_FieldStr);
    
                    if (thisCasePoints == null) thisCasePoints = 0;
    
                    if (newD == null)
                        newD = 0;
                    newIDMap.put(newOwnerID, newD + thisCasePoints);
    
                    if (oldD == null)
                        oldD = 0;
                    oldIDMap.put(oldOwnerId ,oldD + thisCasePoints);
    
                    oChangeCases.add(caseObj);               
                }else if((caseObj.Status != trigger.oldMap.get(caseObj.Id).Status) && caseObj.Status == 'Closed'){
                    //Id presentOwnerId = caseObj.OwnerId;
                    Decimal oldD = oldIDMap.get(newOwnerId);
                    
                    Decimal thisCasePoints;
                    if (Case_FieldStr == null) thisCasePoints = 1;
                    else thisCasePoints = (Decimal)caseObj.get(Case_FieldStr);
                    
                    if (thisCasePoints == null) thisCasePoints = 0;
                    
                    if(oldD == null)
                        oldD = 0;
                    
                    oldIDMap.put(newOwnerId,oldD + thisCasePoints);
                    system.debug('debcheckstatus1' + oldIDMap);
                }else if(Case_FieldStr != null && caseObj.get(Case_FieldStr) != null && trigger.oldMap.get(caseObj.Id).get(Case_FieldStr) != null){ 
                    if(caseObj.get(Case_FieldStr) != trigger.oldMap.get(caseObj.Id).get(Case_FieldStr)){
                        system.debug('debtesting');
                        Decimal newD = newIDMap.get(newOwnerId);
                        
                        Decimal thisCasePoints;
                        thisCasePoints = (Decimal)caseObj.get(Case_FieldStr) - (Decimal)trigger.oldMap.get(caseObj.Id).get(Case_FieldStr);
                        
                        if (thisCasePoints == null) thisCasePoints = 0;
                        
                        if(newD == null)
                            newD = 0;
                        
                        newIDMap.put(newOwnerID, newD + thisCasePoints);
                    }
                }
            }
        } else {
            for(Case caseObj : trigger.new){
                Id newOwnerId = caseObj.OwnerId;
                Decimal newD = newIDMap.get(newOwnerId);
    
                Decimal thisCasePoints;
                if (Case_FieldStr == null) thisCasePoints = 1;
                else thisCasePoints = (Decimal)caseObj.get(Case_FieldStr);
    
                if (thisCasePoints == null) thisCasePoints = 0;
    
                if (newD == null)
                    newD = 0;
                    
                newIDMap.put(newOwnerId, newD + thisCasePoints);
            }
            oChangeCases = trigger.new;
        }
    
        Set<ID> queryIDs = newIdMap.keyset().clone();
        queryIDs.addAll(oldIdMap.keyset());
        
        //query user data
        //construct query string
        String qStr = 'Select id, User__c, User__r.username, ' + UD_FieldStr + ' From UserData__c ' +
            'where User__c IN :queryIDs';
    
        //query with this string
        SObject[] qRes = Database.query(qStr);
        for (sObject o : qRes) {
            UserData__c oUD = (UserData__c)o;
            UDMap.put(oUD.User__c,oUD);
        }
        // decrementing the WorkLoadPoints for old Owner
        
        UserData__c userDataObj;
    
        for(Id userID :oldIdMap.keyset()){
            userDataObj= UDMap.get(userId);
            if(userDataObj != null) {
                Decimal currentPts = (Decimal)userDataObj.get(UD_FieldStr);
                if (currentPts != null) {
                    userDataObj.put(UD_FieldStr, currentPts - oldIdMap.get(userID));
                } else {
                    userDataObj.put(UD_FieldStr, -1 * oldIdMap.get(userID));
                }
            }
        }
        
        // incrementing the WorkLoadPoints for new Owner
        for(Id userID :newIdMap.keyset()){
            userDataObj= UDMap.get(userId);
            if(userDataObj != null) {
                Decimal currentPts = (Decimal)userDataObj.get(UD_FieldStr);
                if (currentPts != null) {
                    userDataObj.put(UD_FieldStr, currentPts + newIdMap.get(userID));
                } else {
                    userDataObj.put(UD_FieldStr, newIdMap.get(userID));
                }
            }
        }
    update(UDMap.values());
    }

}