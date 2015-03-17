public with sharing class RLBSave {
    public SelectOption[] NonRelatedLearningBoard {get;set;}
    public string LBID{get;set;}
    Public String Id{get;set;}
    Public RLBSave(){}
    
    public RLBSave(ApexPages.StandardController controller) {
        LBID = ApexPages.currentPage().getParameters().get(ID);
        system.debug('@@'+LBID);
        List<Related_Learning_Board__c> NonRelatedLearningBoard1 = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__r.name__c FROM Related_Learning_Board__c where Learning_Board_ID__C='a6tZ00000008RHH' order by Display_Sequence_Nbr__c ];
        NonRelatedLearningBoard = new List<SelectOption>();
        
        for ( Related_Learning_Board__c c : NonRelatedLearningBoard1 ) {
            NonRelatedLearningBoard.add(new SelectOption(c.Id, c.Related_Learning_Board_ID__r.name__c));
        }
        
    }
    Public PageReference save(){
        
        integer i=1;
        List<Related_Learning_Board__c> RLB = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__c FROM Related_Learning_Board__c where Learning_Board_ID__C='a6tZ00000008RHH'];
        List<Related_Learning_Board__c> UpdatedList=new  List<Related_Learning_Board__c>();
        
        for(SelectOption so : NonRelatedLearningBoard){

            for(Related_Learning_Board__c lb: RLB ){
                system.debug('lb.Related_Learning_Board_ID__c    '+lb.Related_Learning_Board_ID__c+'so.getValue()' + so.getValue());
                if(lb.Id== so.getValue()){
                    lb.Display_Sequence_Nbr__c= i; 
                    UpdatedList.add(lb);   
                }
            }
            i++;
        }
        update UpdatedList;
        Return Null;
    }
    
}