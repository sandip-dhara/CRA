public class LearningBoardSearch1 {

    public PageReference cancel() {
        return null;
    }

    Public string searchText{get;set;}
    Public pageReference Search(){
        Pagereference pageref = new Pagereference('https://hp--esit--c.cs11.visual.force.com/apex/learningBoardsearch1');
        return pageref;
    }
    public List<sLearningBoard> LearningBoardList {get; set;}
    public List<sLearningBoard> getLearningBoards() {
        if(LearningBoardList == null) {
            LearningBoardList = new List<sLearningBoard>();
            for(Learning_Board__c s: [select Name,name__c from learning_Board__c where name__c like '%cloud%' AND id!='a6tZ00000008RVY']) {
                LearningBoardList.add(new sLearningBoard(s));
            }
        }
        return LearningBoardList;
    }
    
    public PageReference add() {
        system.debug('hi add butoon called');
        return null;
    }

    public class sLearningBoard {
        public Learning_Board__c learningBoard {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public sLearningBoard(Learning_Board__c s) {
            LearningBoard = s;
            selected = false;
        }
    }

    public PageReference processSelected() {

        List<Related_Learning_Board__c> selectedLearningBoards = new List<Related_Learning_Board__c>();

        for(sLearningBoard s: getLearningBoards()) {
            if(s.selected == true) {
                Related_Learning_Board__c rlb = new Related_Learning_Board__c();
                //rbl.id=
                rlb.Learning_Board_ID__c= s.learningBoard.id;
                //rbl.Learning_Board_ID__c = 'a6tZ00000008RVY';
                rlb.Related_Learning_Board_ID__c='a6tZ00000008RVY';
                rlb.Display_Sequence_Nbr__c =1;
                selectedLearningBoards.add(rlb);
            }

        }
        insert selectedLearningBoards;

        return null;
    }


}