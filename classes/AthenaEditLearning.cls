public class AthenaEditLearning {

    public AthenaEditLearning(ApexPages.StandardController controller) {
        this.LearningId= ApexPages.currentPage().getParameters().get('id');
        system.debug('This.LearningId in constructor'+This.LearningId);
        LearningDtls = new LearningDtlsCustomClass();
        RelatedLearningBoards=new list<RelatedLearningBoardCustomClass>();
        LBattach=new Attachment();
        AvailTags=AthenaUtility.getAvailableTags();
    }

    public String optSelected {get;set;}
    public string VideoPreview  {get;set;}
    //public string VideoUrl   {get;set;}
    public Attachment LBattach {get;set;}
    public string dropSelectedval {get;set;}
    Public String strSearchValue{get;set;}
    public string LearningLink {get;set;}
    public string AvailTags{get;set;}
    public string LearningTypeSelected {get;set;}
    public string hdnLearningTitle {get;set;}
    public string hdnLearningDesc {get;set;}
    public boolean hdnLearningActive {get;set;}
    public boolean hdnLearningClientFacing {get;set;}
    public string hdnLUrl {get;set;}
    public string hdnLBTag {get;set;}    
    public string LVideoURL {get;set;}
    Public String LearningId{get;set;}    

    Public class LearningDtlsCustomClass{
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public boolean StaticImage{get;set;}   
        public integer LikeCount{get;set;}   
        public boolean LikedOrNot{get;set;}  
        public boolean DocLnkXst{get;set;}  
        public boolean IsActive{get;set;} 
        public string DefaultImageName{get;set;}   
        public boolean ClientFacing{get;set;}
    }   
    
    Public List<SelectOption> DefaultImagefilename{
    get{     
        system.debug('Default'+ optSelected);
        List<string> ls=new List<string>();
        string filename = AthenaUtility.ApplicationSettingValue(AthenaUtility.LearningDefaultImages);
        ls = filename.split(',');
        List<SelectOption> options = new List<SelectOption>();
        integer i;
        options.add(new selectOption('SelectImage', '- Select Image -'));
        for(i=0;i<ls.size();i++){
            string strText=ls[i];
            options.add( new SelectOption(ls[i],strText.split('\\.')[0]));
        }
        return options;
    }
    set;    
    }

    Public String getStaticImagePath{
    get{
        return 'https://'+ URL.getSalesforceBaseUrl().getHost() + GetResourceURL('athena_images') +'/images/';
        }
    }
    
    //Search the Learning board: redirects to social learning page to display the search results
    public PageReference dosearch(){
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }             

    public string AssociatedTags
    {
    get{    
        List<string> strlst=AthenaUtility.getAssociatedTags(AthenaUtility.Learning,this.LearningId);
        string AssTags='';
        for(string str:strlst){
            AssTags+=str + ',';
        }
        if(AssTags.endsWith(','))
        {
            AssTags = AssTags.removeEnd(',');
        }
        return AssTags;
    }
    }    
 
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
            }
        }

    Public User GetLoggedinUserDtls(){
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    

    Public User getLearningOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email,u.Name  From User u where u.id in  (select ownerid from learning__c where id = :this.LearningId)];
        system.debug('This.LearningId in getLearningOwnerDtls'+This.LearningId);
        return U;
    }
    
    Public boolean IsOwner{
    get{
        AthenaUserAccess usrAccs=new AthenaUserAccess();
        if(usrAccs.IsModerator(UserInfo.getUserId())){
            return true;
        }
        else if(usrAccs.IsProducer(UserInfo.getUserId())){
            Learning__c learning =[SELECT Owner.Id,Owner.name FROM Learning__c where id = : this.LearningId limit 1];
            if(learning.Ownerid==UserInfo.getUserId()){
                return true;
            }
            else{return false;}   
        }
        else{return false;}
    }
    }
    
    private  String GetResourceURL(String resourceName)  
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
            resourcepath= '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        return resourcepath;
    } 
    
    Public LearningDtlsCustomClass LearningDtls{
        get {     
            
           Learning__c learning =[SELECT Default_Image_Name__c,Description__c,Id,Is_Active__c,Name__c,Type__c,URL__c,Owner.name,ClientFacing__c FROM Learning__c where id = : this.LearningId limit 1];
            system.debug('This.LearningId in LearningDtls'+This.LearningId);            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid=:this.LearningId]; 
            integer lrngLIkeCount=0;
            system.debug('this.LearningId'+this.LearningId);
            String  lrngId=  this.LearningId + '%';
            List<liked_item__C> LrngLikeCountResults = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C like :lrngId limit 1];
            if(LrngLikeCountResults.size()>0)
            {
                lrngLIkeCount=integer.valueof(LrngLikeCountResults[0].like_count__c);
            }
            LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
            lrng.LName=learning.Name__c;
            
            if(learning.Default_Image_Name__c!=''){                        
                lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + learning.Default_Image_Name__c;           
            }
            
            
            lrng.LDescription = learning.Description__c;
            lrng.IsActive=learning.Is_Active__c;
            lrng.ClientFacing = learning.ClientFacing__c;
            lrng.LOwnerName = learning.Owner.name; 
            lrng.LType= learning.type__c;   
            lrng.LURL= learning.URL__C; 
            lrng.LId = learning.id;
            lrng.LikeCount=lrngLIkeCount;
            lrng.DocLnkXst=false; 
            if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                  lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                lrng.LURL=lrng.LURL.replace('http:', 'https:');                    
            }
             if( lrng.LURL!=null)
            {   
                lrng.DocLnkXst=true;
                if(lrng.LURL.contains('.pdf'))
                {
                  lrng.DocType='PDF';
                }
                else if(lrng.LURL.contains('.ppt'))
                {
                  lrng.DocType='PPT';
                }                    
                else if(lrng.LURL.contains('.doc'))
                {
                  lrng.DocType='DOC';
                }
                else
                {
                  lrng.DocType='OTHER';
                }
            }
             lrng.StaticImage=true;
                    
                    
            if(lrng.LType!='Video')
            {        
                for(Attachment a: Att)
                {
                    system.debug('lrng.LId'+lrng.LId+'a.ParentId'+a.ParentId+'a.ContentType'+a.ContentType); 
                    if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg' || a.ContentType == 'image/gif') )
                    {
                        lrng.AttachmentId = a.Id;
                        lrng.StaticImage=false;
                    }                 
                }
            } 
            else
            {
                lrng.StaticImage=false;
            }
          return  lrng;         
         }           
                     
    set;    
    }
     Public class RelatedLearningBoardCustomClass{
        public id AttachmentId{get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
        public String DefaultImageName{get;set;} 
    }   
        public List <RelatedLearningBoardCustomClass> RelatedLearningBoards{
        get {
                       
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 
                       
            
            List<Learning_Board_Learning__c>  rLBs=[SELECT Learning_ID__c, Learning_Board_ID__c,Learning_Board_ID__r.Default_Image_Name__c,Learning_Board_ID__r.name__C,Learning_Board_ID__r.Owner.Name,Learning_Board_ID__r.Description__c,Learning_Board_ID__r.Is_Active__c,
            Learning_Board_ID__r.Featured__c FROM Learning_Board_Learning__c where Learning_ID__c=:this.LearningId and Learning_Board_ID__r.Is_Active__c=true];
            
            system.debug('This.LearningId in RelatedLearningBoards'+This.LearningId);
              
            for (Learning_Board_Learning__c rLB:rLBs) {
                lstRLBIds.add(rLB.Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Learning_Board_Learning__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Learning_Board_ID__r.Name__c; 
                if(lb.Learning_Board_ID__r.description__c!=null){
                    if(lb.Learning_Board_ID__r.description__c.length()>200){
                        
                        lbCustom.LBDescription = lb.Learning_Board_ID__r.description__c.substring(0,200) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.Learning_Board_ID__r.description__c;
                    }
                }
                
                lbCustom.LbId = lb.Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                 if(lb.Learning_Board_ID__r.Default_Image_Name__c!=''){                        
                    lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + lb.Learning_Board_ID__r.Default_Image_Name__c;          
                  }
                lbCustom.LBOwnerName=lb.Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage = false;
                    }  
                }
                RelatedLearningBoards.add(lbCustom);
            }                
        return RelatedLearningBoards;                
        }   
        set;    
    }
    
        Public integer LrngOwnerLikeCount{
        get{     
            Learning__C lrng=[select ownerid from learning__c where id = :this.LearningId];
            system.debug('This.LearningId in LrngOwnerLikeCount'+This.LearningId);            
            LrngOwnerLikeCount=LikedItemCount(lrng.ownerid);
            return LrngOwnerLikeCount;
        }
        set;
    }  
    
     Private integer LikedItemCount(string itemIdentifier){
        List<Liked_Item__C> LikdItms= [select like_count__c from liked_item__C where Item_identifier__C =:itemIdentifier];
        system.debug('itemIdentifier in LikedItemCount'+itemIdentifier);
        if(LikdItms.size()!=0)
        {
            return Integer.ValueOf(LikdItms[0].like_count__c);
        }
        return 0;
    }  
 
    Public integer LrngOwnerCommentCount{
    get{     
        Learning__C lrng=[select ownerid from learning__c where id = :this.LearningId]; 
        LrngOwnerCommentCount=getCommentCount(lrng.ownerid);
        //system.debug('this.LearningId in LrngOwnerCommentCount'+this.LearningId+'lrng.ownerid in LrngOwnerCommentCount'+lrng.ownerid);
        return LrngOwnerCommentCount;
    }
    set;} 
    
    
    Private Integer getCommentCount(string lid){
        List<FeedItem> feedItms = [Select id from FeedItem where parentID=:lid];
        return feedItms.size(); 
    }   

    public void SaveLearning()
    {
        Learning__c lrng=[SELECT Id, Name__c, Description__c, Is_Active__c,Type__c, Short_Description__c, URL__c,  Default_Image_Name__c FROM Learning__c where id=:this.LearningId limit 1];

        lrng.Name__c= hdnLearningTitle;
        lrng.Description__c=hdnLearningDesc;
        lrng.Is_Active__c=hdnLearningActive;
        lrng.ClientFacing__c = hdnLearningClientFacing;
        lrng.Type__c=LearningTypeSelected;
        if(hdnLUrl.trim()!='')
            lrng.URL__c=hdnLUrl;

        system.debug('hdnLearningTitle:'+hdnLearningTitle);
        system.debug('hdnLearningDesc:'+hdnLearningDesc);
        system.debug('hdnLearningActive:'+hdnLearningActive);
        system.debug('LearningTypeSelected:'+LearningTypeSelected);
        system.debug('hdnLUrl:'+hdnLUrl);
        system.debug('hdnLBTag:'+hdnLBTag);

        update lrng;
        List<string> strLst=new List<string>();

        if ( hdnLBTag.trim() != '')
        {
            strLst=hdnLBTag.split(',');
        }
        AthenaUtility.AssociateTags(strLst,AthenaUtility.Learning, this.LearningId);

    }

 
                
    public void LrngImageupload()
    {       
    try{
        List<string> contype=new List<string>();
        contype.add('image/jpeg');
        contype.add('image/png');
        contype.add('image/jpg');

        system.debug('dropSelectedval:'+dropSelectedval);

        if(optSelected=='option2'){
        if (dropSelectedval!='SelectImage')
        {
        Learning__c lb=[SELECT Default_Image_Name__c,Description__c,Id,Is_Active__c,Name FROM Learning__c Where id =: this.LearningId];
        lb.Default_Image_Name__c=dropSelectedval;
        update lb;

        List<Attachment> lbatt=[select id from Attachment where ParentId =:this.LearningId ];
        delete lbatt;
        }

        }
        else{

        if (LBattach!=null)
        { 
        if (LBattach.ContentType!='')
        {
            List<Attachment> lbatt=[select id from Attachment where ParentId =:this.LearningId ];
            delete lbatt;

            LBattach.ParentId = this.LearningId;
            insert LBattach ;
            Learning__c lb=[SELECT Default_Image_Name__c,Description__c,Id,Is_Active__c FROM Learning__c Where id =: this.LearningId];
            lb.Default_Image_Name__c='';
            update lb;
        }

        }

        }
    }
    catch (DMLException e) {

    }
    finally {
        LBattach = null; 
    }
    }
}