public with sharing class RelatedLearningBoardNewOverride {
    public SelectOption[] RelatedLearningBoard {get;set;}
    public SelectOption[] NonRelatedLearningBoard {get;set;}
    public string LBID{get;set;}
    Public String Id{get;set;}
    Public List<selectoption> Sv {get;set;}
    
    Public List<selectoption> getValues(){
        list<selectoption> ls = new list<selectoption>();
        
        for (Related_Learning_Board__c RLB : [SELECT Id, Name, Learning_Board_ID__c, Related_Learning_Board_ID__c,Related_Learning_Board_ID__r.Name__c FROM Related_Learning_Board__c where Learning_Board_ID__C!=:LBID])
        {
            ls.add(new selectoption(RLB.id,RLB.Related_Learning_Board_ID__r.Name__c));
        }
        return ls;
    }
    
    //public string 
    public RelatedLearningBoardNewOverride(ApexPages.StandardController controller) {
        //RelatedLearningBoard = controller.getrecord();
        system.debug('%%%'+ ApexPages.currentPage().getParameters().get(System.Label.LBLookup));
        LBID = ApexPages.currentPage().getParameters().get(System.Label.LBLookup);
        system.debug('@@'+LBID);
        
        List<Related_Learning_Board__c> RelatedLearningBoard1 = [SELECT Id, Name, Learning_Board_ID__c, Related_Learning_Board_ID__c,Related_Learning_Board_ID__r.Name__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:LBID];
        
        List<Related_Learning_Board__c> NonRelatedLearningBoard1 = [SELECT Id, Name ,Learning_Board_ID__c, Related_Learning_Board_ID__c FROM Related_Learning_Board__c where Learning_Board_ID__C!=:LBID];
        NonRelatedLearningBoard = new List<SelectOption>();
        RelatedLearningBoard = new List<SelectOption>();
        for ( Related_Learning_Board__c c : NonRelatedLearningBoard1 ) {
            NonRelatedLearningBoard.add(new SelectOption(c.Id, c.Name));
        }
        for ( Related_Learning_Board__c c1 : RelatedLearningBoard1 ) {
            RelatedLearningBoard.add(new SelectOption(c1.Id, c1.Name));
        }
        
        system.debug('###' +RelatedLearningBoard);
    }
    Public RelatedLearningBoardNewOverride(){
        
    }
}