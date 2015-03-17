public with sharing class phLearningsController {

public list<Learning__c> listLearning;
public list<Learning__c> getLearningsList()
{
list<Learning__c> listLearning = [Select id,Name__c from Learning__c];
//,Description__c
system.debug('!@'+listLearning);
return ListLearning;
}

}