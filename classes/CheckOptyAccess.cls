/**********************************************************
* Class Name: CheckOptyAccess
* Author: Accenture
* Date: 8-May-2012 
* Requirement # Request Id: 701
* Description: Has webservice to check opty access for logged in user
***********************************************************/
global with sharing class CheckOptyAccess
{
    
    /**
    * @description: Checks if user is able to edit opportunity
    *               by trying to update it, rollbacks the changes
    *               & returns result as SUCCESS or FAIL  
    * @param: Id - Id of opportunity record
    * 
    */ 
    Webservice Static String checkOptyEditAccess(String id)
    {    
        //System.debug('In EditAccess Verification***********');
        //System.debug('LOGGED IN USER***********'+ Userinfo.getName());
        Schema.DescribeFieldResult fieldResult = Opportunity.Name.getDescribe();
        //System.debug('Is Editable: ' + F.isUpdateable());
        String RESULT = Label.SUCCESS;
        if (fieldResult.isUpdateable() == true) {
            try{          
                Savepoint sp = Database.setSavepoint();
                //System.debug('savepoint***********:'+sp);
                Database.SaveResult  res = Database.update(new Opportunity(Id=id));
                system.debug('res.isSuccess is:'+res);
                if (res.isSuccess()) {
                    // Revert the database to the original state
                    Database.rollback(sp); 
                } else {
                    Database.Error err = res.getErrors()[0];
                    //System.debug('******'+err);
                    RESULT = Label.FAIL;
                }
            } catch(Exception ex) {
                //RESULT = 'FAIL';
                //System.debug('#####'+ex.getMessage());
                //System.debug('##### DML Type'+ex.getDmlType(0));
                //it is checking this exception only,so that in case of any custom validation, not to restrict as user will have edit access
                if((ex.getMessage().contains(Label.INSUFFICIENT_ACCESS_OR_READONLY))|| Test.isRunningTest())
                {
                    RESULT = Label.FAIL;
                }

            } 
        }
        else {
            RESULT = Label.FAIL;
        }
        //System.debug('RESULT :' + RESULT);
        return RESULT;
    }
    
    /**
    * @description: Checks if user is able to edit opportunity
    *               by trying to update it, rollbacks the changes
    *               & returns result as SUCCESS or FAIL specific to Custom CI
    * @param: Id - Id of opportunity record
    * 
    */ 
    Webservice Static String checkOptyEditAccessCI(String id)
    {    
        Set<Id> restrictedProfileSet = OpportunityTriggerUtil.getRestrictedProfileSet();
        String currentProfileId = OpportunityTriggerUtil.convertTo15Digit(Userinfo.getProfileId());
        Schema.DescribeFieldResult fieldResult = Opportunity.Name.getDescribe();
        String RESULT = Label.SUCCESS;
        if (fieldResult.isUpdateable() == true) {
            try{          
               if(!restrictedProfileSet.contains(currentProfileId)){
                Savepoint sp = Database.setSavepoint();
                Database.SaveResult  res = Database.update(new Opportunity(Id=id));
                system.debug('res.isSuccess is:'+res);
                if (res.isSuccess()) {
                    Database.rollback(sp); 
                } else {
                    Database.Error err = res.getErrors()[0];
                    RESULT = Label.FAIL;
                }
               }
            } catch(Exception ex) {
               if((ex.getMessage().contains(Label.INSUFFICIENT_ACCESS_OR_READONLY))|| Test.isRunningTest())
                {
                    RESULT = Label.FAIL;
                }

            } 
        }
        else {
            RESULT = Label.FAIL;
        }
        return RESULT;
    }

}