public class datacleanup {
    Public String LearningID{get;set;}
    Public String LearningBoardID{get;set;}
        
    Public List<Learning_Board_Learning__c> LBLList{get;set;}
    Public Learning__c LearningName{get;set;}
    Public List<Tag_Item__c> TagList{get;set;}        
    
    Public integer flag{get;set;}
    Public List<Learning_Board_Learning__c> LearningBoardList{get;set;}
    Public void deleteLearning(){
        LBLList= [select id,name,Learning_Board_ID__r.name,Learning_ID__r.name,Learning_Category_ID__r.name from learning_Board_Learning__c where Learning_ID__r.name =:LearningID];
        TagList = [SELECT name,Item_Name__c,Tag_ID__c,Item_Identifier__c FROM Tag_Item__c];
        system.debug('###'+LBLList); 
        system.debug('###'+TagList); 
        flag=1;       
    }
    Public void LearningBoard(){
        LearningBoardList= [select id,name,Learning_Board_ID__r.name,Learning_Category_ID__r.name from learning_Board_Learning__c where Learning_Board_ID__r.name=:LearningBoardID];
        system.debug('$$$'+LearningBoardList);
        flag=2;        
    }
}