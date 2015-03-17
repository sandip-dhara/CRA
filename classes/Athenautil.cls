public class Athenautil {
    Public string searchText{get;set;}
    Public pageReference Search(){
        Pagereference pageref = new Pagereference('https://hp--esit--c.cs11.visual.force.com/apex/learningsearch');
        return pageref;
    }
    public List<cLearnings> learningsList {get; set;}
    public List<cLearnings> getLearnings() {
        if(learningsList == null) {
            learningsList = new List<cLearnings>();
            for(Learning__c c: [select Name,name__c from learning__c where name__c like '%Big%']) {
                learningsList.add(new cLearnings(c));
            }
        }
        return learningsList;
    }
    
    public PageReference add() {
        system.debug('hi add butoon called');
        return null;
    }

    public class cLearnings {
        public Learning__c learning {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cLearnings(Learning__c c) {
            learning = c;
            selected = false;
        }
    }

    


    public PageReference processSelected() {

        List<Learning_Board_Learning__c> selectedLearnings = new List<Learning_Board_Learning__c>();

        for(cLearnings c: getLearnings()) {
            if(c.selected == true) {
                Learning_Board_Learning__c lbl = new Learning_Board_Learning__c();
                lbl.Learning_ID__c = c.learning.id;
                lbl.Learning_Board_ID__c = 'a6tZ00000008RVY';
                lbl.Display_Sequence_Nbr__c =1;
                selectedLearnings.add(lbl);
            }

        }
        insert selectedLearnings;

        return null;
    }


}