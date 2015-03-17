public class AVCreateLearningBoard {
    public string TestCreate {get;set;}
    Public Boolean IsModerator{get{
        ID usrId = UserInfo.getUserId();
        String usrProfileName = [select u.Profile.Name,User.SmallPhotoUrl from User u where u.id = :usrID].Profile.Name;
    
        if(usrProfileName=='ES IT Administrator' || usrProfileName=='IT Administrator')
            Return True;
        else If(usrProfileName=='ES Base Profile'){
            List<PermissionSet> usrAsgndPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:usrID)];
            for(PermissionSet permSet: usrAsgndPermSet){
                If(permSet.Name=='ES_Social_Learning_Moderator')
                    return true;             
            }
            return false;            
        }
        else  
            return false;
    }set;}
    public AVCreateLearningBoard() {
        LBattach =new Attachment();
        LBattach.Name = 'Dummy Attachment';
        LBAttach.Body = Blob.valueOf('Dummy attachment');
        LBAttach.contentType = 'html/text';
        AvailTags=AthenaUtility.getAvailableTags();            
        chkAct=true;
        ErrMsgs = new string[]{'No image was selected.', 'No image was uploaded.', 'Image option was not chosen'};
    }   
    
    Public string[] ErrMsgs {get;set;}
    Public boolean chkAct {get;set;}
    Public String LrngBrdId {get;set;}
    public string LBName{get;set;}    
    public string LBDescription{get;set;}    
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
    public string hdnAddTag {get;set;}
    public string AvailTags{get;set;}
    Public String strSearchValue{get;set;}
    Public string LBCategory {get;set;}
    Public string LBSubTitle {get;set;}
     
     
    public PageReference  RedirectToSLP_GlobalSearch()
    {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
       
    Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
    }
    /*added by komala*/
    @RemoteAction
    Public static List<Learning_Category__c> GetLearningBoardCategories(string selectedOptionValue)
    {
        //MuraliCreateLearningBoard obj=new MuraliCreateLearningBoard();
        //string selectedOptionValue=obj.GetLBCategoryName();
        system.debug('selected option: '+selectedOptionValue);
        List<Learning_Category__c> LCategory=new List<Learning_Category__c>();
        Lcategory=[select name__c from learning_category__c where id IN(SELECT Learning_category_Id__c FROM Required_Learning_Category__c where Learning_Board_Template_ID__r.id=:selectedOptionValue)];
        return Lcategory;
    }
    /*added by komala*/    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }
    
    Public boolean IsLearningBoardCreator{
        get{
               AthenaUserAccess usrAccs=new AthenaUserAccess();
                if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId())  ){
                    return true;
                }           
                else{return false;}
            }
        }
    /*public String getLBCategory() {
        return Categorylist;
    }
    
    
    public void setLBCategory(String Categorylist) {
        this.Categorylist= Categorylist;
    }*/
     
     Public List<SelectOption> getLBcategories(){
            
        List<SelectOption> LBCS= new List<SelectOption>();
        LBCS.add(new SelectOption('','--Select template--'));
        
        for(Learning_Board_Template__c LBC:[select id,Name__c from Learning_Board_Template__c where is_active__c=true]){
            LBCS.add(new SelectOption(LBC.id,LBC.name__c));    
        }
        return LBCS;
     }
     
     Public List<SelectOption> DefaultImagefilename{
     get{
            List<string> lstImgFileName=new List<string>();
            string imageFileNames = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningBoardDefaultImages);
            lstImgFileName = imageFileNames.split(',');
            List<SelectOption> options = new List<SelectOption>();
            integer index;
            options.add(new selectOption('', '- Select Image -'));
            for(index=0;index<lstImgFileName.size();index++){
                string strText=lstImgFileName[index];               
                options.add( new SelectOption(lstImgFileName[index],strText.split('\\.')[0]));
            }
            return options;
        }
    set;    
    }        
 
    public PageReference CreateLrngBrd()
    {
        system.debug('testDebug:'+TestCreate);
        PageReference pRef = ApexPages.currentPage();
        
        Learning_Board__c lrngBrd=new Learning_Board__c();        
        lrngBrd.Name__c = LBName;
        lrngBrd.Sub_Title__c = LBSubTitle;
        lrngBrd.Description__c = LBDescription;
        lrngBrd.Is_Active__c = hdnCheckActive;//LBIsActive ;//
        lrngBrd.Featured__c = hdnCheckFeatured;//LBFeatured ;//
         system.debug('&&&&&&&&&&&&&isactive'+LBFeatured);
         system.debug('&&&&&&&&&&&&&featured'+hdnCheckActive);
         system.debug('&&&&&&&&&&&&&featured'+lrngBrd.Is_Active__c);
        lrngBrd.Learning_Board_Template_ID__c = LBCategory;
        List<string> strLst=new List<string>();
        strLst=hdnAddTag.split(',');
        
        if(optSelected=='optDefaultImage'){
            try
            {   
                if (dropSelectedval == '' || dropSelectedval == null)
                {
                    throw new SLP_Exception(); 
                }
                else
                {
                    lrngBrd.Default_Image_Name__c = dropSelectedval;
                    system.debug('***********isactive'+lrngBrd.Is_Active__c);
                    system.debug('***********featured'+lrngBrd.Featured__c);
                    try{
                        insert lrngBrd; 
                        }
                    catch (SLP_Exception e)
                    {
                        //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter unique names'));
                        return pRef;
                    }
                    catch (DMLException dmlex){
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter unique names'));
                        return pRef;
                    }
                    this.LrngBrdId =lrngBrd.id;
                }
            }
            catch (SLP_Exception e)
            {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsgs[0] ));
                return pRef;
            }
        }
        else if (optSelected=='optBrowseImage')
        {
            try
            {
                if (LBattach.Name == 'Dummy Attachment')
                {
                   throw new SLP_Exception();           
                }
                else
                {
                   
                    lrngBrd.Default_Image_Name__c='';
                    try{
                    system.debug('//////////////////isactive'+lrngBrd.Is_Active__c);
                    system.debug('//////////////////featured'+lrngBrd.Featured__c);
                    
                        insert lrngBrd;
                        }
                    catch (SLP_Exception e)
                        {
                            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter unique names'));
                            //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                            return pRef;
                        }
                    catch (DMLException e)
                        {
                            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter unique names'));
                            //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                            return pRef;
                        }
                    this.LrngBrdId =lrngBrd.id;
                    LBattach.ParentId = this.LrngBrdId;
                    insert LBattach;
                }
            }
            catch (SLP_Exception e)
            {
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsgs[1] ));
                return pRef;
            }
            catch (DMLException dmlex){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload small resolution images'));
            }
        }
        else
        {                  
           ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsgs[2] )); 
           return pRef;
        }
 
        if (strLst != null && strLst.size() > 0 && hdnAddTag.trim() != '')
        {
            AthenaUtility.AssociateTags(strLst,AthenaUtility.LearningBoard, this.LrngBrdId);
        }
        
        pRef = new PageReference('/apex/AthenaEditLearningBoardDtls?id=' + this.LrngBrdId);
        pRef.setRedirect(true);
        return pRef;
     }   
    
      private static String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        string resourcepath='';
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL          
           resourcepath= '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;
        }  
        return resourcepath;  
       }
       
    //Search the Learning board: redirects to social learning page to display the search results
    public PageReference dosearch(){
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
}