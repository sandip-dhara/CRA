public class CreateNewLearningBoard {
    Public String LBDefaultImageName {get;set;}
    Public string TestCreate {get;set;}
    Public String LrngBrdId {get;set;}
    Public string LBName{get;set;}    
    Public string LBDescription{get;set;}
    Public string hdnTxtName {get;set;}
    Public string hdnTxtDesc {get;set;} 
    Public String optSelected {get;set;}
    Public string dropSelectedval {get;set;}
    Public string hdnAddTag {get;set;}
    Public string AvailTags{get;set;}
    Public String strSearchValue{get;set;}
    Public string LBCategory {get;set;}
    Public string LBSubTitle {get;set;}
    Public Attachment LBattach {get;set;}
    Public string[] ErrMsgs {get;set;}
    Public boolean chkAct {get;set;}
    Public boolean LBIsActive {get;set;}
    Public boolean LBFeatured {get;set;}    
    Public boolean hdnCheckActive {get;set;}
    Public boolean hdnCheckFeatured {get;set;}    
    
    public boolean IsUserRoleMappingVisible
    {
    get
    {
    
    string userId=UserInfo.getUserId();
    
    AthenaUserAccess UsrAcc=new AthenaUserAccess();
       
                   if (UsrAcc.IsModerator(userId))
                return true;
            else
                return false;        
    }
    }  

    
    Public String getStaticImagePath{
    get {
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/';
        }
    }
       
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public List<SelectOption> DefaultImagefilename{get{  
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
    
    Public boolean IsLearningBoardCreator{get{        
           AthenaUserAccess usrAccs=new AthenaUserAccess();
            if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId())  ){
                return true;
            
            }           
            else{return false;}
        }
    }
    
    //Constructor intialises attachment object.
    public CreateNewLearningBoard()
    {
        LBattach =new Attachment();
        LBattach.Name = 'Dummy Attachment';
        LBAttach.Body = Blob.valueOf('Dummy attachment');
        LBAttach.contentType = 'html/text';
        AvailTags = AthenaUtility.getAvailableTags();            
        
            system.debug('AvailTags:' + AvailTags);
        
        chkAct=true;
        ErrMsgs = new string[]{'No image was selected.', 'No image was uploaded.', 'Image option was not chosen'};
    }
    
    Public List<SelectOption> getLBcategories(){            
        List<SelectOption> LBCS= new List<SelectOption>();
        LBCS.add(new SelectOption('','--Select template--'));
        
        
        for(Learning_Board_Template__c LBC:[select id,Name__c from Learning_Board_Template__c where is_active__c = true]){
            LBCS.add(new SelectOption(LBC.id,LBC.name__c));    
        }

        LBCS.add(new SelectOption('NO','No template'));

        return LBCS;
    }       
 
    public PageReference  RedirectToSLP_GlobalSearch()
    {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
    
    /*Started by komala*/
    @RemoteAction
    Public static List<Learning_Category__c> GetLearningBoardCategories(string selectedOptionValue)
    {        
        system.debug('selected option: '+selectedOptionValue);
        List<Learning_Category__c> LCategory=new List<Learning_Category__c>();
        Lcategory=[select name__c from learning_category__c where id IN(SELECT Learning_category_Id__c FROM Required_Learning_Category__c where Learning_Board_Template_ID__r.id=:selectedOptionValue)];
        return Lcategory;
    }
    /*ended by komala*/    
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
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

        if(LBCategory != 'NO')
        {
            lrngBrd.Learning_Board_Template_ID__c = LBCategory;
        }
        else
        {
            lrngBrd.Learning_Board_Template_ID__c = null;
        }
        
        List<string> strLst = new List<string>();
        strLst = hdnAddTag.split(',');    
        system.debug('strLst:' + strLst);    
        system.debug('hdnAddTag:' + hdnAddTag);   

        if(optSelected=='optDefaultImage'){
            try{   
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
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Unique Board Title'));
                        return pRef;
                    }
                    catch (DMLException dmlex){
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Unique Board Title'));
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
        else if (optSelected=='optBrowseImage'){
            try{
                if (LBattach.Name == 'Dummy Attachment'){
                   throw new SLP_Exception();           
                }
                else{                   
                    lrngBrd.Default_Image_Name__c='';
                    try{                        
                        insert lrngBrd;
                    }
                    catch (SLP_Exception e){
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Unique Board Title'));
                        //ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                        return pRef;
                    }
                    catch (DMLException e){
                        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Unique Board Title'));
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
        else{                  
           ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsgs[2] )); 
           return pRef;
        } 
        if (strLst != null && strLst.size() > 0 && hdnAddTag.trim() != ''){
            system.debug('Create Board strLst:'+strLst);
            AthenaUtility.AssociateTags(strLst,AthenaUtility.LearningBoard, this.LrngBrdId);
        }        
        pRef = new PageReference('/apex/AthenaEditLearningBoardDtls?id=' + this.LrngBrdId);
        pRef.setRedirect(true);
        return pRef;
    }    

    private static String GetResourceURL(String resourceName){  
        //Fetching the resource 
        string resourcepath='';
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1){  
            //Getting namespace  
            String namespace = resourceList[0].NamespacePrefix;  
            //Resource URL          
            resourcepath= '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') +  resourceName;
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