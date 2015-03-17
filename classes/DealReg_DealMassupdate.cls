/**********************************************************
* Class Name: DealReg_DealMassupdate
* Author: HP Release 3
* Date: 15-Oct-2012 
* Requirement # Request Id:
* Description: Used to get the Approver List and set the Approver Owner
***********************************************************/
public class DealReg_DealMassupdate {


public List<Deal_Registration__c> queryList= new List<Deal_Registration__c>();
public List<Deal_Registration__c> dealIdList =new List<Deal_Registration__c>();
public Set <string> dealSet = new Set<string>();
public string approver{get;set;}
public static ID dealRegId;

  public ID getdealRegId(){ return dealRegId; }
  
  public void setdealRegId(ID dealId){
            dealRegId= dealId;
     }
   
    public DealReg_DealMassupdate () {
    }
    
    public DealReg_DealMassupdate (ApexPages.StandardSetController controller) {
    }
    
     /**
    * @description: Once save the records redirect back to parent page 
    * 
    */
    public PageReference redirecDealRegPage(){
        pagereference page=new pagereference('/apex/DealRegistrationsTab?save_new=1&sfdc.override=1');
        page.setRedirect(true);
        return page;
    }
   
       /*
    *@description: Following getter method will return the Approver List
    */
   public List<SelectOption> getApproverList(){
    
    List<SelectOption> optionsDealList = new List<SelectOption>();
    
    for(Deal_Registration__c dealList:[select Level_1_Approver_1__r.name,Level_1_Approver_2__r.name,Level_1_Approver_3__r.name,
                                    Level_1_Approver_4__r.name,Level_1_Approver_5__r.name,Level_1_Approver_6__r.name,
                                    Level_1_Approver_7__r.name,Level_1_Approver_8__r.name,Level_1_Approver_9__r.name,
                                    Level_1_Approver_10__r.name,Level_1_Approver_11__r.name,Level_1_Approver_12__r.name
                                    from Deal_Registration__c where Id=:dealRegId]){
       queryList.add(dealList);
       
    if(dealList.Level_1_Approver_1__r.name != null && dealList.Level_1_Approver_1__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_1__r.name);
       }
    if(dealList.Level_1_Approver_2__r.name != null && dealList.Level_1_Approver_2__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_2__r.name);
       }
    if(dealList.Level_1_Approver_3__r.name != null && dealList.Level_1_Approver_3__r.name != ''){
        dealSet.add(DealList.Level_1_Approver_3__r.name);
       }
    if(DealList.Level_1_Approver_4__r.name != null && DealList.Level_1_Approver_4__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_4__r.name);
       }
    if(dealList.Level_1_Approver_5__r.name != null && dealList.Level_1_Approver_5__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_5__r.name);
       }
    if(dealList.Level_1_Approver_6__r.name != null && dealList.Level_1_Approver_6__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_6__r.name);
       }
    if(dealList.Level_1_Approver_7__r.name != null && dealList.Level_1_Approver_7__r.name != ''){
        dealSet.add(DealList.Level_1_Approver_7__r.name);
       }
    if(DealList.Level_1_Approver_8__r.name != null && DealList.Level_1_Approver_8__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_8__r.name);
       }
    if(dealList.Level_1_Approver_9__r.name != null && dealList.Level_1_Approver_9__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_9__r.name);
       }
    if(dealList.Level_1_Approver_10__r.name != null && dealList.Level_1_Approver_10__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_10__r.name);
       }
    if(dealList.Level_1_Approver_11__r.name != null && dealList.Level_1_Approver_11__r.name != ''){
        dealSet.add(DealList.Level_1_Approver_11__r.name);
       }
    if(DealList.Level_1_Approver_12__r.name != null && DealList.Level_1_Approver_12__r.name != ''){
        dealSet.add(dealList.Level_1_Approver_12__r.name);
       }
    }

      optionsDealList.add(new SelectOption('-- Select --', '-- Select --'));
    
    for (String allDealList: dealSet){

            if (allDealList!= null){ 
                optionsDealList.add(new SelectOption(allDealList,allDealList));
                 }    
            }
         return optionsDealList;
     }
}