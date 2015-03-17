public with sharing class hp_portal_class { 

public hp_portal_url__c url3{get; set;}
public string getid{get;set;}
public List<List<hp_portal_url__c>> searchList{get;set;}
public string s3{get; set;}

public hp_portal_class(ApexPages.StandardController controller){
  this.getid = ApexPages.currentPage().getParameters().get('id');
url3=[select protal_url__c from hp_portal_url__c where id=:this.getid];
//List<List<hp_portal_url__c>> searchList = [FIND 'flashVars*'  IN ALL FIELDS RETURNING hp_portal_url__c (protal_url__c)];
//System.debug('searchlist>>>>>>>>>>'+searchList[0]);
//String s1=String.valueOf(searchList[0]);
String s1=String.valueOf(url3);
Integer i1=s1.indexOf('videoId',0);
Integer i2=s1.indexOf('dynamicStreaming=true',0);
String s2=s1.substring(i1,i2);
System.debug('i1>>>>>>>>>'+i1);
System.debug('i2>>>>>>>>>'+i2);
System.debug('s2>>>>>>>>>'+s2);
s3=s2+'dnamicStreaming=true';
System.debug('s3>>>>>>>>>>>>>'+s3);
}
}