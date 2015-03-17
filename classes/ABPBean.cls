/**********************************************************
* Page Name:ABPBean Class 
* Author: HP  
* Date: 17-JULY-2012 
* Requirement # Request Id: 
* Description:Bean
**********************************************************/

public class ABPBean{
public List<Strategic_Initiative__c> stategic;
public List<Customer_Business_Priority__c> customPriority;
public List<Competitive_Landscape__c> competitive;
public List<Customer_Relationship_Map__c> influencer;
public List<Business_Unit_Plan__c> optyst;


public void setinfluencer(List<Customer_Relationship_Map__c>influncer){
this.influencer=influncer;
}
public List<Customer_Relationship_Map__c> getinfluencer(){
return influencer;
}
public void setcompetitive(List<Competitive_Landscape__c> comp){
this.competitive=comp;
}
public List<Competitive_Landscape__c> getcompetitive(){
return competitive;
}
public void setcustomPriority(List<Customer_Business_Priority__c> cs){
this.customPriority=cs;
}
public List<Customer_Business_Priority__c> getcustomPriority(){
return customPriority;
}

public void setoptyst(List<Business_Unit_Plan__c> list1){
this.optyst=list1;
}
public void setstategic(List<Strategic_Initiative__c> si){
this.stategic=si;
 }
 public List<Strategic_Initiative__c> getstategic(){
 return stategic;
 }
 public List<Business_Unit_Plan__c> getoptyst(){
 return this.optyst;
 }


 
 }