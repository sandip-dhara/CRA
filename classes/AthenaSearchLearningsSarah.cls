public class AthenaSearchLearningsSarah {

  
    Public String strSearchValueLrng{get;set;}
    Public boolean ShowSearchLrng{get;set;}

    Private Integer MyLrngsConIndex;

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
        public List<string> AssociatedTags{get;set;}   
    } 
    
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    


Public AthenaSearchLearningsSarah() {
            MyLearningsList = new List<LearningDtlsCustomClass>();
            MyLrngsConIndex=0;
            //LearningDetails();
     }
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
            }
        }
        
        
    Public boolean CheckAddLearning{
        get{
            AthenaUserAccess usrAccs=new AthenaUserAccess();
             if((usrAccs.IsModerator(UserInfo.getUserId())) || (usrAccs.IsProducer(UserInfo.getUserId())) ){
                return true;
            }
            else{return false;}

            }
        }

 private  String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       } 

 Public ApexPages.standardSetController MyLrngsCon{    
    get{
        if(MyLrngsCon== null){
            MyLrngsCon= new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Default_Image_Name__c,Description__c,Id,Is_Active__c,Name__c,Type__c,URL__c,Owner.name FROM Learning__c where Owner.id=:UserInfo.getUserId() order by LastModifiedDate Desc]));                      
            MyLrngsCon.setPageSize(6);
        }        
        return MyLrngsCon;   
    }    
    set;}  
    Public void MyLrngsNext(){
        MyLrngsCon.next();
        MyLrngsConIndex=0;
    }       
    
    Public void MyLrngsPrevious(){
        MyLrngsCon.previous();
        MyLrngsConIndex=0;       
    }  
    Public List<LearningDtlsCustomClass> MyLearningsList {
    get{
        if(MyLrngsConIndex== 0){
            MyLrngsConIndex=1;
            MyLearningsList.clear();
            LearningDetails();                     
        }                
        return MyLearningsList;
    }                 
    set;
    }
    
     Public List<String> FetchAssociatedTags(string LearningId)
     {
        List<String> strlst=new List<String>();
        strlst=AthenaUtility.getAssociatedTags(AthenaUtility.Learning,LearningId);
        
        If(strlst.Size()==0){
           strlst.Add('No Tags Associated');
        }         
        return strlst;
   }
    
    public void LearningDetails()
    {
           // LearningDtls.clear();
           List<LearningDtlsCustomClass> LearningDtls   = new List<LearningDtlsCustomClass>();          
            list<id> lstLearningIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>();         
            List<Learning__c> Learnings = new List<Learning__c>();
                        
            Learnings = (List<Learning__c>)MyLrngsCon.getRecords();
           
            for (Learning__c lrng: Learnings )
            {
                lstLearningIds.add(lrng.id);
            }
    
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds];
            
             List<liked_item__C> LrngLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :lstLearningIds];
            map<id,decimal> LrngLikeCountMap = new map<id,decimal>();        

            for (Id LrngId :lstLearningIds) {
                for (Liked_Item__c LkdItm :LrngLikeCountList) {
                    if(LkdItm.Item_identifier__C== LrngId) {
                        LrngLikeCountMap.put(LrngId,LkdItm.like_count__c);
                    }
                }                            
            }
                                            
            for (Learning__c learning:learnings ) {
            LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                    
            lrng.LName=learning.Name__c;
            
            if(learning.Default_Image_Name__c!=''){                        
                lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + learning.Default_Image_Name__c;           
            }                    
            lrng.LDescription = learning.Description__c;
            lrng.IsActive=learning.Is_Active__c;
            lrng.LOwnerName = learning.Owner.name; 
            lrng.LType= learning.type__c;   
            lrng.LURL= learning.URL__C; 
            lrng.LId = learning.id;
            lrng.LikeCount=integer.valueof(LrngLikeCountMap.get(learning.id));
            lrng.DocLnkXst=false; 
            lrng.AssociatedTags=FetchAssociatedTags(learning.id);
          
            if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                  lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
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
                for(Attachment a: attachmentList)
                { 
                    if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg') )
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
            LearningDtls.add(lrng);
        }           
        
        MyLearningsList=LearningDtls;                
    }  

}