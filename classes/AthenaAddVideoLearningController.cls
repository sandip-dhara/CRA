public with sharing class AthenaAddVideoLearningController 
{

    public boolean IsChecked { get; set; }
    public String Descrip { get; set; }
    public String Title { get; set; }
    public String queryString {get;set;}
    public String urlatvideoinput {get;set;}
    Public String LearningBoardsid {get;set;}
    
    
    public AthenaAddVideoLearningController() 
    {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        urlatvideoinput='';
    }

    public void testOrPreview()
    {

        if(urlatvideoinput.contains('youtube.com') && urlatvideoinput.contains('watch?v='))
        {
            urlatvideoinput=urlatvideoinput.replace('watch?v=', 'embed/');
        }
    }
    
    public PageReference cancel() {
        return null;
    }


    public PageReference Upload() {
       Learning__c LRecord = new Learning__c();
        LRecord.Name__c = Title;
        LRecord.Description__c = Descrip;
        LRecord.URL__c=urlatvideoinput;
        try{
            insert LRecord;
            System.Debug('Learning ID = ' + LRecord.Id);
            System.Debug('Learning ID = ' + LRecord.Name__c);
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in saving Learning Record'));            
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File saved successfully'));
        
        pageReference PageRef = new pageReference('https://hp--esit--c.cs11.visual.force.com/apex/Athena_AddVideoLearning?id='+LearningBoardsid);
        System.Debug('PageRef = ' + PageRef);
        System.Debug('IsChecked = ' + IsChecked);
        if (IsChecked){
            Learning_Board_Learning__c LBLRecord = new Learning_Board_Learning__c();
            List<Learning_Board_Learning__c> MaxLB = new List<Learning_Board_Learning__c>();
            // Display Sequence Number
            MaxLB = [SELECT Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__r.Id = :LearningBoardsid];
            if(MaxLB.size()>0){
                integer max=0;
                for(Learning_Board_Learning__c MaxDSN : MaxLB){
                    if(max<integer.valueof(MaxDSN.Display_Sequence_Nbr__c)){
                        max=integer.valueof(MaxDSN.Display_Sequence_Nbr__c);
                    }
                }
                LBLRecord.Display_Sequence_Nbr__c = max+1;
            }           
            else{
                LBLRecord.Display_Sequence_Nbr__c = 1;
            }
            
            // Linking Learning Board Id
            LBLRecord.Learning_Board_ID__c = LearningBoardsid;
            // Linking Learning Id
            LBLRecord.Learning_ID__c = LRecord.Id;
            try {
                insert LBLRecord;
                System.Debug('Learning Board Learning ID = ' + LBLRecord.Id);
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error mapping file'));
                return null;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File saved & mapped successfully'));
        }
        return pageRef;
    }
}