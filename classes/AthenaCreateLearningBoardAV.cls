public class AthenaCreateLearningBoardAV {

    public AthenaCreateLearningBoardAV() {
    LBattach =new Attachment();

    }   
    Public String LearningBoardsid {get;set;}
    public string LBName{get;set;}    
    public string LBDescription{get;set;}
    Public String strSearchValue{get;set;}
    Public boolean LBIsActive {get;set;}
    Public boolean LBFeatured {get;set;}
    Public String LBDefaultImageName {get;set;}
    public Attachment LBattach {get;set;}    
    public string hdnTxtName {get;set;}
    public string hdnTxtDesc {get;set;}
    public boolean hdnCheckActive {get;set;}
    public boolean hdnCheckFeatured {get;set;} 
  public String optSelected {get;set;}
   public string dropSelectedval {get;set;}
        
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
 Public List<SelectOption> DefaultImagefilename{get{
     
     //AthenaUtility athenaUtil=new AthenaUtility();
             system.debug('Default'+ optSelected);
        List<string> ls=new List<string>();
        string filename = AthenaUtility.ApplicationSettingValue('LrngBrdDefaultImages');
        ls = filename.split(',');
        List<SelectOption> options = new List<SelectOption>();
        integer i;
        options.add(new selectOption('', '- Select Image -'));
        for(i=0;i<ls.size();i++){
        string strText=ls[i];
            
            options.add( new SelectOption(ls[i],strText.split('\\.')[0]));
        }
        return options;
        }
        set;    
    }
    

    public PageReference SaveLB()
    {
        Learning_Board__c learningBoard=new Learning_Board__c();
        learningBoard.Name__c = LBName;
        learningBoard.Description__c = LBDescription;
        learningBoard.Is_Active__c = hdnCheckActive;
        learningBoard.Featured__c = hdnCheckFeatured;

         system.debug('BName:' +LBName);
         system.debug('BNameDes:' +LBDescription);
         system.debug('BNameAc:' +hdnCheckActive);
         system.debug('BNameFe:' +hdnCheckFeatured);
         system.debug('BNameDI:' +optSelected);

     if(optSelected=='option2'){
        learningBoard.Default_Image_Name__c = dropSelectedval;
        insert learningBoard; 
        this.LearningBoardsid =learningBoard.id;
     }
    else
        {
        learningBoard.Default_Image_Name__c='';
        insert learningBoard;
        this.LearningBoardsid =learningBoard.id;
        LBattach.ParentId = this.LearningBoardsid;
        insert LBattach;
      
        }

         



        //learningBoard.Default_Image_Name__c = LBDefaultImageName;
        //insert learningBoard;
        //this.LearningBoardsid =learningBoard.id;
        ////After checking the condition whether the Image is uploaded then use below code 
        //LBattach.ParentId = this.LearningBoardsid;
        //insert LBattach;
        
        PageReference pRef = new PageReference('/apex/athenaEditLBMahesh?id=' + this.LearningBoardsid);
        pRef.setRedirect(true);
        return pRef;
     }   
}