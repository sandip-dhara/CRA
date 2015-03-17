public class muraliwrapper{
    List<Community__c> c= [SELECT Id, Name, Name__c, Description__c, Public__c, IsActive__c, Default_Image_Name__c, Short_Description__c FROM Community__c  where ownerid='005Z0000001RaOcIAK' and IsActive__c=true];
    List<Learning_Board__c> lb= [SELECT Id, Name, Name__c, Description__c, Featured__c, Is_Active__c, Short_Description__c, Sub_Title__c, Default_Image_Name__c, Learning_Board_Template_ID__c FROM Learning_Board__c where ownerid='005Z0000001RaOcIAK' and Is_Active__c=true];       
    Public class customLBComm{
        public id AttachmentId{get;set;}        
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public String LBOwnerName{get;set;}
        public String LBOwnerTitle{get;set;} 
        public String LBOwnerURL{get;set;}
        public Datetime LBCrtDate{get;set;}
        public integer LBNoOfLikes{get;set;}
        public integer LBNoOfComments{get;set;} 
        public boolean StaticImage{get;set;} 
        public string LBOwnerID{get;set;}  
        public String LBImgURL{get;set;}
        public String ServerPath{get;set;}
        public integer FeaIndex{get;set;}
        public string LikeIcon {get;set;}
        public string CommentIcon {get;set;}
        public String LBCreateDate{get;set;}
        public Integer TotalCount {get;set;}
        public boolean Active{get;set;}
        public boolean existing{get;set;}
        public string NavigationLink{get;set;}
        public Decimal AvgRating{get;set;}        
        Public boolean Community{get;set;}
    }
}