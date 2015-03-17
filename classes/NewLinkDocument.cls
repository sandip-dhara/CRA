public class NewLinkDocument {
    public string LBId = ApexPages.currentPage().getParameters().get('id');
    Public String SelectedState{get;set;}
    Public String SelectedCity{get;set;}
    Public List<SelectOption> filename{get{
        List<Learning_Image__c> filename1 = [Select value__c from Learning_Image__c WHERE Name LIKE '%testing%' Limit 1];
        List<string> ls=new List<string>();
        string filename = filename1[0].value__c;
        ls = filename.split(',');
        List<SelectOption> options = new List<SelectOption>();
        integer i;
        options.add(new selectOption('', '- None -'));
        for(i=0;i<ls.size();i++){
            options.add( new SelectOption(ls[i],ls[i]));
        }
        return options;
        }
        set;    
    }
    Public NewLinkDocument(){
        
    }
    public boolean IsChecked{get;set;}
    Public string temp{get;set;}
    public String Descrip{get;set;}
    public String Title{get;set;} 
    Public String URL{get;set;}
    
    Public String DocumentImage{get;set;}
    Public Attachment Attachment {
    get {
            if (Attachment == null) {
                Attachment = new Attachment();
            }
            return Attachment;
        }
        set;
    }
    Public PageReference Upload(){
        Learning__c LRecord = new Learning__c();
        LRecord.Name__c = Title;
        LRecord.Description__c = Descrip;
        try{
            insert LRecord;
            System.Debug('Learning ID = ' + LRecord.Id);
        }catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in Entering Learning Record'));            
        }
        //system.debug('LearnRecord id'+LBLRecord.id);
        
        Attachment Att =new Attachment();
       
        Att.parentID = LRecord.Id;
        Att.Name = Title;
        Att.OwnerId = UserInfo.getUserId();
        Att.Body = Attachment.body;
        try {
          insert Att;
          System.Debug('Attachment ID = ' + Att.Id);
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
          //return null;
        } 
        Finally {
            Att.body = null;
            Attachment = new Attachment();
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        
        if (IsChecked){
            Learning_Board_Learning__c LBLRecord = new Learning_Board_Learning__c();
            List<Learning_Board_Learning__c> MaxLB = new List<Learning_Board_Learning__c>();
            // Display Sequence Number
            MaxLB = [SELECT Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__r.Id = :LBId];
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
            system.debug('Display_Sequence_Nbr__c'+LBLRecord.Display_Sequence_Nbr__c);
            LBLRecord.Learning_Board_ID__c = LBId;
            system.debug('Learning_Board_ID__c '+LBLRecord.Learning_Board_ID__c );
            // Linking Learning Id
            LBLRecord.Learning_ID__c = LRecord.Id;
            system.debug('Learning_ID__c '+LBLRecord.Learning_ID__c);
            try {
                insert LBLRecord;
                System.Debug('Learning Board Learning ID = ' + LBLRecord.Id);
            } catch (DMLException e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
                return null;
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded & linked successfully'));
        }
        pageReference PageRef = new pageReference('https://hp--esit--c.cs11.visual.force.com/apex/NewLinkDocument?id='+LBId);
        return pageRef;
    }
    Public PageReference cancel(){return Null;}
    public pageReference Test() {
        string URLPreview = URL;
        PageReference pageRef = new PageReference(URL);
        pageRef.setRedirect(true);
        return pageRef;
    }   
}