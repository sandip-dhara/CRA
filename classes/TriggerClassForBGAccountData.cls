/**
* Class Name: TriggerClassForBGAccountData 
* Author: Accenture
* Date: 19-JULY-2012 
* Requirement # Request Id: 1577
* Description: This Class drives the logic for populating BG Information from BG Account Data to Account level
*/

public class TriggerClassForBGAccountData {


   
    //Set RAD,Customer Segment,Named Account from BG Account Data to Account level in concatenated form.Works on insertion on BG Account Data object
    public static void bgAccountInsertUpdate(List<BG_Account_Data__c> triggerNew){
        
        List<Account> accList1= new List<Account>();
        Set<Id> accIdSet=new Set<Id>();
        
        for(BG_Account_Data__c bgAccDataObj : triggerNew){
                accIdSet.add(bgAccDataObj.Account__c);
                
        }
        try {
            //Query all child BG Account Data Records for Account
            List<Account> accList=[Select RAD__c,Coverage_Segmentation__c,BG_Target_Segments__c,Named_Account__c,
                                  (Select BG__c, RAD__c,Coverage_Segment__c,Target_Segment__c,Named_Account__c  From BG_Account_Data__r) 
                                    From Account where Id  IN : accIdSet];
            
           
            for(Account accObj:accList ){
                
               
                String concRAD='';
                String concCustSeg='';
                String concMarkSeg = '';
                String concNamedAccount='';
                for(BG_Account_Data__c bgAccDataObj1 :accObj.BG_Account_Data__r ){
                    
                    //storing values for RAD,Coverage Segment, Named Account in temporary string
                    if (null!=bgAccDataObj1.RAD__c)
                    concRAD =(concRAD +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.RAD__c));
                    if (null!=bgAccDataObj1.Coverage_Segment__c)
                    concCustSeg=(concCustSeg +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Coverage_Segment__c));
                    if (null!=bgAccDataObj1.Target_Segment__c)
                    concMarkSeg=(concMarkSeg+'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Target_Segment__c));
                    if (null!=bgAccDataObj1.Named_Account__c)
                    concNamedAccount=(concNamedAccount +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Named_Account__c));
                    
                                        
                }
                //Updating values of all 3 fields from BG Account Data to Account
                accObj.RAD__c = (concRAD==''?'' : concRAD.substring(1,concRAD.length()));
                accObj.Coverage_Segmentation__c= (concCustSeg==''?'' : concCustSeg.substring(1,concCustSeg.length()));
                accObj.BG_Target_Segments__c= (concMarkSeg==''?'' : concMarkSeg.substring(1,concMarkSeg.length()));
                accObj.Named_Account__c=(concNamedAccount==''?'' : concNamedAccount.substring(1,concNamedAccount.length()));
                
                system.debug('***** '+accObj.RAD__c.length() );
                    
                              
                if(accObj.RAD__c.length() > 255)
                    accObj.RAD__c = '';
                if(accObj.Coverage_Segmentation__c.length() > 255)
                    accObj.Coverage_Segmentation__c = '';
                if(accObj.BG_Target_Segments__c.length() > 255)
                    accObj.BG_Target_Segments__c = '';
                if(accObj.Named_Account__c.length() > 255)
                    accObj.Named_Account__c = '';                   
                                 
                accList1.add(accObj);
                
            }
            system.debug('****accList1******************'+accList1);
            if(!accList1.isEmpty()){
                //Updating the Account with values from BG Account Data
                update accList1;
            }
            
        }catch (Exception e){
            system.debug('*****Exception in populateFromBGAccountToAccount ****' + e.getMessage());
        }
    }
    
    public static void bgAccountDelete(List<BG_Account_Data__c> triggerOld){
        
        List<Account> accList2= new List<Account>();
        List<Account> accList3= new List<Account>();
        Set<Id> accIdSet=new Set<Id>();
        Set<Id> bgAccDataDelSet=new Set<Id>();
        
        try{ 
            for(BG_Account_Data__c bgAccDataObj:triggerOld) {
                    accIdSet.add(bgAccDataObj.Account__c);  
                    bgAccDataDelSet.add(bgAccDataObj.Id);
                    
            }
            
            //Query all child BG Account Data Records for Account excpet whixh is getting deleted
            accList2 = [Select RAD__c,Coverage_Segmentation__c,BG_Target_Segments__c,Named_Account__c,
                        (Select BG__c, RAD__c,Coverage_Segment__c,Target_Segment__c,Named_Account__c
                             From BG_Account_Data__r where Id NOT IN:bgAccDataDelSet AND Account__c IN :accIdSet  ) 
                        From Account where Id  IN : accIdSet];
                        
                for(Account accObj : accList2 ){
                    
                                        
                    String concRAD = '';
                    String concCustSeg = '';
                    String concMarkSeg = '';
                    String concNamedAccount = '';
                    
                    for(BG_Account_Data__c bgAccDataObj1 :accObj.BG_Account_Data__r ){
                        
                        //storing values for RAD,Coverage Segment, Named Account in temporary string
                        if (null!=bgAccDataObj1.RAD__c)
                        concRAD =(concRAD +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.RAD__c));
                        if (null!=bgAccDataObj1.Coverage_Segment__c)
                        concCustSeg=(concCustSeg +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Coverage_Segment__c));
                        if (null!=bgAccDataObj1.Target_Segment__c)
                        concMarkSeg=(concMarkSeg+'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Target_Segment__c));
                        if (null!=bgAccDataObj1.Named_Account__c)
                        concNamedAccount=(concNamedAccount +'|'+ ( bgAccDataObj1.BG__c+'='+ bgAccDataObj1.Named_Account__c));
                                                
                    }
                    //Updating values of all 3 fields from BG Account Data to Account
                    accObj.RAD__c = (concRAD==''?'' : concRAD.substring(1,concRAD.length()));
                    accObj.Coverage_Segmentation__c= (concCustSeg==''?'' : concCustSeg.substring(1,concCustSeg.length()));
                    accObj.BG_Target_Segments__c= (concMarkSeg==''?'' : concMarkSeg.substring(1,concMarkSeg.length()));
                    accObj.Named_Account__c=(concNamedAccount==''?'' : concNamedAccount.substring(1,concNamedAccount.length()));
                    
                       
                        
                    if(accObj.RAD__c.length() > 255)
                        accObj.RAD__c = '';
                    if(accObj.Coverage_Segmentation__c.length() > 255)
                        accObj.Coverage_Segmentation__c = '';
                    if(accObj.BG_Target_Segments__c.length() > 255)
                        accObj.BG_Target_Segments__c = '';
                    if(accObj.Named_Account__c.length() > 255)
                        accObj.Named_Account__c = '';
                    
                    accList3.add(accObj);
                    
                }
                    if(!accList3.isEmpty()){
                    update accList3;
                }
            }
            catch (Exception e){
                system.debug('*****Exception in populateFromBGAccountToAccount ****' + e.getMessage());
            }
        
    }

}