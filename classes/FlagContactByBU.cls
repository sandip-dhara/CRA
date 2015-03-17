/**
* Class Name: FlagContactByBU
* Author: Accenture
* Date: 23-JULY-2012 
* Requirement # Request Id: 1682
* Description: Contact's BU should be updated with Contact's Owners BU.
*/
    
public class FlagContactByBU{
    
    /**
    * @description - Set contact's BU with Owner's BU on insert. 
    */
    
        public static void insertBUInformation(Map<Id,Contact> tiggerNew){
            
            List<Contact> contactBUupdateList=new List<Contact>();
            List<Id> contactIdList=new List<Id>();
            List<Contact> contactBUupdateList1 = new List <Contact>();
            //Fetch Contact owner's Global Business Unit  & BU from contactBUupdateList
            try{ 
                    for(Contact cObj: [Select Owner.Global_Business_Unit__c,BU__c,Id,OwnerId from contact where Id IN : tiggerNew.keySet()] ){
                        //system.debug('**********cObj.BU__c***cObj.Owner.Global_Business_Unit__c***' + cObj.BU__c +cObj.Owner.Global_Business_Unit__c);
                        if (null!=cObj.Owner.Global_Business_Unit__c && cObj.Owner.Global_Business_Unit__c!=''){
                        cObj.BU__c=cObj.Owner.Global_Business_Unit__c;
                        //contactIdToOwnerIdMap.put(cObj.Id,cObj.OwnerId);
                        contactBUupdateList.add(cObj);
                        }
                    }
                    if (!contactBUupdateList.isEmpty())
                     update contactBUupdateList;
        }
        catch(Exception e){
            System.debug('Exception occured While inserting BU information' +e.getMessage());
            }
        }
    /**
    * @description - Set contact's BU with Owner's BU on Update. 
    */
        public static void updateBUInformation(List<Contact> tiggerNew,List<Contact> tiggerOld){
            List<Contact> contactBUupdateList=new List<Contact>();
            List<Id> contactIdList=new List<Id>();
            List<Contact> contactBUupdateList1 = new List <Contact>();
           
            try{
                    for (Integer i=0;i<tiggerNew.size();i++){
                    //Checking if Owner of Contact is changed or not
                        if (tiggerOld[i].OwnerId != tiggerNew[i].OwnerId){
                            contactIdList.add(tiggerNew[i].Id); 
                        }
                    }
                    system.debug('**********contactIdListc***' + contactIdList);
                    if(!contactIdList.isEmpty()){  
                     //Fetch Contact owner's Global Business Unit  & BU from Contact having changed owners
                        for (Contact cObj1:[Select BU__c,Owner.Global_Business_Unit__c from Contact where Id IN: contactIdList]){
                            // system.debug('**********cObj1.BU__c** cObj1.Owner.Global_Business_Unit__c*' + cObj1.BU__c +cObj1.Owner.Global_Business_Unit__c );
                             String temp=cObj1.BU__c;
                            // system.debug('**********temp***' + temp);
                             Set <String> splitBUPicklist=new Set <String>();
                             for (String BUObj:temp.split(';') ){
                                splitBUPicklist.add(BUObj);
                             }
                           // system.debug('**********split1***' + splitBUPicklist);    
                            if ((cObj1.Owner.Global_Business_Unit__c!= null) && (cObj1.Owner.Global_Business_Unit__c!='')){
                                if (!(splitBUPicklist.contains(cObj1.Owner.Global_Business_Unit__c))){
                                    cObj1.BU__c=cObj1.BU__c + ';' + cObj1.Owner.Global_Business_Unit__c;
                                    contactBUupdateList1.add(cObj1);
                                }
                            }
                        }
                        if(!contactBUupdateList1.isEmpty())
                        update contactBUupdateList1;
                    }
        }
      catch(Exception e){
            System.debug('Exception occured While updating BU information' +e.getMessage());
            }  
     }
}