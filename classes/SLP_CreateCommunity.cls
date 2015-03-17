public class SLP_CreateCommunity{
    Public String strSearchValue{get;set;}
    public string CommunityName {get;set;}
    public string CommunityDescription {get;set;}
    public boolean IsProducerOrModerator{get;set;}
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
    public string ImageSelectionOption {get;set;}{
        ImageSelectionOption='UFC';
    }
    Public String CommunityId {get;set;}
    public string dropSelectedval {get;set;}
    public Attachment Communityattach {get;set;}   
    //Public string[] ErrMsgs {get;set;}
    Public List<SelectOption> DefaultImagefilename{
    get{
            List<string> lstImgFileName=new List<string>();
            string imageFileNames = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningBoardDefaultImages);
            lstImgFileName = imageFileNames.split(',');
            List<SelectOption> options = new List<SelectOption>();
            integer index;
            options.add(new selectOption('SelectImage', '- Select Image -'));
            for(index=0;index<lstImgFileName.size();index++){
                string strText=lstImgFileName[index];               
                options.add( new SelectOption(lstImgFileName[index],strText.split('\\.')[0]));
            }
            return options;
        }
    set;    
    }
    public SLP_CreateCommunity (){
        Communityattach=new Attachment();
        Communityattach.Name = 'Dummy Attachment';
        Communityattach.Body = Blob.valueOf('Dummy attachment');        
        Communityattach.contentType = 'html/text';
        CheckIsProducerOrModerator();
        //ErrMsgs = new string[]{'No image was selected.', 'No image was uploaded.', 'Image option was not chosen'};
    }

    public PageReference  RedirectToSLP_GlobalSearch(){            
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
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    Public User GetLoggedinUserDtls(){
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }

    public List<SelectOption> getImageOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('UFC','Upload from Computer')); 
        options.add(new SelectOption('DI','Default Image')); 
        return options; 
    }

    public void CheckIsProducerOrModerator(){
       AthenaUserAccess UsrAcc=new AthenaUserAccess();
       if ( UsrAcc.IsModerator(UserInfo.getUserId()) || UsrAcc.IsProducer(UserInfo.getUserId()))
       {
            IsProducerOrModerator= true;
       }
       else
       {   
            IsProducerOrModerator=false;
       }
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

    public PageReference CreateCommunity(){ 
        PageReference pRef = ApexPages.currentPage();
        try{ 
            system.debug('dropSelectedval:'+dropSelectedval);
            Community__c community =new Community__c();
            community.Name__c=CommunityName.trim();
            community.Description__c=CommunityDescription;
            community.Public__c=false;
            community.IsActive__c=false;

            system.debug('ImageSelectionOption:'+ImageSelectionOption);

            List<Community__c> LstCommunity=new  List<Community__c>();
            List<Community__c> LstCommunity1 =new List<Community__c>();
            LstCommunity1 = [SELECT Id, Name__c FROM Community__c];
            
            LstCommunity=[SELECT Id, Name__c FROM Community__c where name__C=:CommunityName.trim()];
            system.debug('CommunityName'+CommunityName+'LstCommunity1' +LstCommunity1);
            if (LstCommunity.size()>0){
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Community Name'));
                pRef.setRedirect(false);
                return pRef;
            }
            else{
                if (ImageSelectionOption==null){            
                    ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Commnunity option'));
                    pRef.setRedirect(false);
                    return pRef;
                }
                else{
                    if(ImageSelectionOption=='DI'){
system.debug('ImageSelectionOption==DI:');
                        if (dropSelectedval =='SelectImage'){
                            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Upload Image'));
                            pRef.setRedirect(false);
                            return pRef;
                        }   
                        else{
                            If(dropSelectedval!='SelectImage'){
                                system.debug('dropSelectedvalSelectImage1:');
                                community.Default_Image_Name__c = dropSelectedval;
                                insert community; 
                                this.CommunityId =community.id;
                                system.debug('dropSelectedvalSelectImage2:' + community.id);
                            }
                        }
                    }
                    else if(ImageSelectionOption=='UFC'){

                        community.Default_Image_Name__c='';
                        if((Communityattach.Name == 'Dummy Attachment')){
                            system.debug(' Dummy:');
                            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Upload Image'));
                            pRef.setRedirect(false);
                            return pRef;
                        }
                        else{
                            system.debug('Communityattach:'+Communityattach);
                            If(Communityattach!=null ){
                                insert community; 
                                this.CommunityId =community.id;
                                Communityattach.ParentId = this.CommunityId;
                                insert Communityattach;
                                
                                
                                system.debug('community.id:'+community.id);
                                //After creating the community we need add owner in Entity Subscription object
                                EntitySubscription entitySubscription = new EntitySubscription();
                                entitySubscription.SubscriberId = UserInfo.getUserId();
                                entitySubscription.ParentId = this.CommunityId;
                                insert entitySubscription;
                            }
                        }
                    }
                }
            }
        }
        catch (SLP_Exception e){
            /*ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            pRef.setRedirect(false);
            return pRef;*/
        }
        catch (DMLException dmlex){
            /*ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR, dmlex.getMessage()));
            pRef.setRedirect(false);
            return pRef;*/
        }
        finally{}

system.debug('this.CommunityId:'+this.CommunityId);

        pRef = new PageReference('/apex/SLP_EditCommunity?id=' + this.CommunityId);
        pRef.setRedirect(true);
        return pRef;
    }
}