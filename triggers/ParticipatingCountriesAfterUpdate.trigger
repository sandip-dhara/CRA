/**
* Class Name: ParticipatingCountriesAfterInsertUpdate
* Author: HP
* Date: 03-April-2013
* Requirement # Request Id: 
* Description: Contains Before Insert & Update action methods for trigger on MN_Opportunities_Information__c object
*/

trigger ParticipatingCountriesAfterUpdate on MN_Opportunities_Information__c (after insert, after update, after delete) {
    
    set<Id> opptyIDs = new Set<ID>(); 
    boolean isdelete=false;
    Map<ID,MN_Opportunities_Information__c> opptyNoPCountryMap=new Map<ID,MN_Opportunities_Information__c>();
    if(Trigger.isDelete)
    {
       for (MN_Opportunities_Information__c c: Trigger.old) {
        opptyIDs.add(c.Multinational_OppMultinational_Oortunity__c);
        opptyNoPCountryMap.put(c.Multinational_OppMultinational_Oortunity__c,c);
      }
      isdelete=true;
    }
      else
      {
      for (MN_Opportunities_Information__c c: Trigger.new) {
        opptyIDs.add(c.Multinational_OppMultinational_Oortunity__c);
      }
      }
      
      
    Map<ID,List<MN_Opportunities_Information__c>> oppIDOICMap=new Map<ID,List<MN_Opportunities_Information__c>>();
    Map<ID,Opportunity> opptyMap=new Map<ID,Opportunity>([select id,Account_Region__c ,Multi_Country_Type__c,name from Opportunity where id in :opptyIDs]);
    for(MN_Opportunities_Information__c c : [Select ID , Region__c,Country__c,Multinational_OppMultinational_Oortunity__c from MN_Opportunities_Information__c where Multinational_OppMultinational_Oortunity__c in:opptyIDs])
    {
         if(oppIDOICMap.containsKey(c.Multinational_OppMultinational_Oortunity__c)){
            List<MN_Opportunities_Information__c> tempcList=new List<MN_Opportunities_Information__c>();
            tempcList=oppIDOICMap.get(c.Multinational_OppMultinational_Oortunity__c);
            tempcList.add(c);
            oppIDOICMap.put(c.Multinational_OppMultinational_Oortunity__c, tempcList);
        }
        
         else{
            List<MN_Opportunities_Information__c> tempcList=new List<MN_Opportunities_Information__c>();
            tempcList.add(c);
            oppIDOICMap.put(c.Multinational_OppMultinational_Oortunity__c, tempcList);
        }
    }
    
    List<Opportunity> opptylistToUpdate=new List<Opportunity>();
    for(ID optyid : oppIDOICMap.keySet()){
        integer AMSCount=0;
        integer APJCount=0;
        integer EMEACount=0;
        if(opptyNoPCountryMap.containsKey(optyid))
        opptyNoPCountryMap.remove(optyid);
      ////The below code added by Vinay Suryadevara to include driving Opportunity Region  
      
        //opportunity  OptyRegions = [select id, Account_Region__c from Opportunity where Id =: optyid ];          
        Opportunity opptyobj=opptyMap.get(optyid);
         If (opptyobj.Account_Region__c == 'Americas'){
                AMSCount= AMSCount+1;
          }
            Else If (opptyobj.Account_Region__c == 'Asia Pacific'){
                APJCount= APJCount+1;
             }
            Else if (opptyobj.Account_Region__c == 'EMEA'){
                EMEACount= EMEACount+1;
               }               
   ////The above code added by Vinay Suryadevara to include driving Opportunity Region  
   
        for( MN_Opportunities_Information__c pcon : oppIDOICMap.get(optyid)){
           If(pcon.Region__c == 'Americas'){
               AMSCount= AMSCount+1;
           }
           Else if (pcon.Region__c == 'Asia Pacific'){
               APJCount= APJCount+1;
           }
           Else if(pcon.Region__c =='EMEA'){
               EMEACount= EMEACount+1;
           }
         }
        
             
            
           if((AMSCount>=1 && APJCount>=1) || (AMSCount>=1 && EMEACount>=1) ||(APJCount>=1 && EMEACount>=1)){
               opptyobj.Multi_Country_Type__c  = 'Global';
            }
            else if((AMSCount>1 || APJCount>1||EMEACount>1))
            {   
                opptyobj.Multi_Country_Type__c = 'Multi Country';
            }
            else{
               opptyobj.Multi_Country_Type__c = 'Single Country';
              
            }
         
        opptylistToUpdate.add(opptyobj);
    }
    if(isDelete==true && opptyNoPCountryMap.size()>0)
    {   
        for(ID optyid : opptyNoPCountryMap.keySet()){
            Opportunity opptyobj=opptyMap.get(optyid);
            opptyobj.Multi_Country_Type__c = 'Single Country';
            opptylistToUpdate.add(opptyobj);
        }
    }
    
    
    try{
        if(opptylistToUpdate.size()>0){
            DataBase.SaveResult[] saveresult=database.update(opptylistToUpdate);
            for(Database.SaveResult result : saveresult){
              if(!result.isSuccess())  
             opptyNoPCountryMap.get(result.getID()).addError(Result.errors[0].message); 
            } 
        }
      }catch(Exception e){
      
      } 
}