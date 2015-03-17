public class athenaEditLBMahesh {
public Attachment LBattach {get;set;}
   public Attachment Lrngattach {get;set;}
     public Attachment LrngLinkattach  {get;set;}
    public athenaEditLBMahesh(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        
        Learningid='';
        LearningDtls = new list<LearningDtlsCustomClass>();
        LearningBoardDtls=new RelatedLearningBoardCustomClass();
        RelatedLearningBoards=new list<RelatedLearningBoardCustomClass>();
         LBattach = new Attachment();
        Lrngattach=new Attachment();
        LrngLinkattach=new Attachment();
        GetRelatedLB();
        GetLearningBoardOrder();
                AvailTags=AthenaUtility.getAvailableTags();   
    }

    public string hdnLBTag {get;set;}
    public string AvailTags{get;set;}
    public string hdnRelBrdId {get;set;}
    public String optSelected {get;set;}
   public string dropSelectedval {get;set;}
   public string LBDescription{get;set;}
    Public String strSearchValue{get;set;}
    Public String LearningBoardsid {get;set;}
    public string hdnTxt {get;set;}
    public string hdnTxtArea {get;set;}
    public boolean hdnChkActive {get;set;}
    public boolean hdnChkFeatured {get;set;}
    public string hdnLearnings {get;set;}
    public SelectOption[] ChangeOrderRelatedLearningBoard {get;set;}
 public SelectOption[] ChangeLearningBoardOrder {get; set;}
    public  string  hdnChangeOwnerId {get;set;}
  public string  hdnLearningId {get;set;}
   public string LearningTitle {get;set;}
   public string LearningDesc {get;set;}
   public string hdnLearningAddTags {get;set;}
   public boolean hdnLearningActive {get;set;}
   public boolean hdnAddCurrentLearning {get;set;}
  public string LrngDefaultImageSelectedval {get;set;}
  public string LrngDefaultImageSelecteddoc {get;set;}
 public string hdnOptionSelected {get;set;}
public string LearningType {get;set;}
public string hdnLearningDesc  {get;set;}
public string hdnLearningTitle  {get;set;}
public string hdnRadioL  {get;set;}
public string hdnLearningType {get;set;}
public string LVideoURL {get;set;} 
public string LVideoDocURL {get;set;} 
 
    Public class RelatedLearningBoardCustomClass{
        public id AttachmentId{get;set;}
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public boolean StaticImage{get;set;} 
        public String LBOwnerName{get;set;} 
        public boolean LB_Active{get;set;}
        public boolean LB_Featured{get;set;}
        public string DefaultImageName{get;set;} 
 
    }       
    
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
        public List<string> Tags{get;set;}   
        public string DefaultImageName{get;set;}      
    }       
 
   Public string Learningid{
    get{
        return ApexPages.currentPage().getParameters().get('id');
    }
    set;}
    public static string LearningBID {get
    {
    return ApexPages.currentPage().getParameters().get('id');
    }
    set;}
    public string hdnSearch {get;set;}
    public string hdnRelatedLB {get;set;} 
    public string LBAssociatedTags{
    get{    
    List<string> strlst=AthenaUtility.getAssociatedTags(AthenaUtility.LearningBoard,this.LearningBoardsid);
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
    
    
      public void LBImageupload()
        {       
 
    try{
           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           //and ContentType=:contype
        List<Attachment> lbatt=[select id from Attachment where ParentId =:this.LearningBoardsid ];
        delete lbatt;
       
//        system.debug('debugTesti: '+ optSelected);
              
//system.debug('debugTesting '+ dropSelectedval);
            if(optSelected=='option2'){
 
                   Learning_Board__c lb=[SELECT Default_Image_Name__c,Description__c,Featured__c,Id,Is_Active__c,Name FROM Learning_Board__c Where id =: this.LearningBoardsid];
        lb.Default_Image_Name__c=dropSelectedval;
        update lb;
 
            }
            else{
 
            LBattach.ParentId = this.LearningBoardsid;
            insert LBattach;
            Learning_Board__c lb=[SELECT Default_Image_Name__c,Description__c,Featured__c,Id,Is_Active__c,Name FROM Learning_Board__c Where id =: this.LearningBoardsid];
        lb.Default_Image_Name__c='';
        update lb;
        
            }
       
}
catch (DMLException e) {
 
    } finally {
 
      LBattach.body = null; // clears the viewstate
      //LBattach = new LBattach();
 
    }
            
            
        }
    
 
 
public void CreateLearningAndAssociate(){
   try{
        Learning__c learning= new Learning__c();
        learning.Name__c = hdnLearningTitle;
        learning.Description__c = hdnLearningDesc;
        learning.Is_Active__c = hdnLearningActive;
        learning.Default_Image_Name__c = '';
 
        system.debug('Title: '+LearningTitle);
        system.debug('LearningDesc: '+LearningDesc);
        system.debug('hdnLearningActive: '+hdnLearningActive);
        system.debug('hdnLearningAddTags: '+hdnLearningAddTags);
        system.debug('hdnLearningType: '+hdnLearningType);
        system.debug('optSelected: '+optSelected);
        system.debug('hdnAddCurrentLearning: '+hdnAddCurrentLearning);
        system.debug('LVideoURL: '+LVideoDocURL);
        system.debug('LType: '+AthenaUtility.LearningTypeUrlOrDocument);
            system.debug('hdnLearningDesc:' +hdnLearningDesc);        
system.debug('hdnLearningTitle:' +hdnLearningTitle);        

        if(hdnLearningType==AthenaUtility.LearningTypeText)
{
//Text
            learning.Type__c=AthenaUtility.LearningTypeText;
}
        else if (hdnLearningType==AthenaUtility.LearningTypeVideo)
                {
                //Video
                learning.URL__c = LVideoURL;
                learning.Type__c=AthenaUtility.LearningTypeVideo;
                }
        else if(hdnLearningType==AthenaUtility.LearningTypeUrlOrDocument)
{//url or document
            learning.URL__c = LVideoDocURL;
            learning.Type__c=AthenaUtility.LearningTypeUrlOrDocument;
                }
        
        if(hdnLearningType!=AthenaUtility.LearningTypeVideo)
        {    
             if(optSelected=='option1')
             {
 learning.Default_Image_Name__c='';
                insert learning;
                Lrngattach.ParentId = learning.id;
                insert Lrngattach ;
               
            }
            else
            {
                learning.Default_Image_Name__c = LrngDefaultImageSelectedval;
                insert learning; 
            }
        }
        else if(learning.Type__c==AthenaUtility.LearningTypeVideo)
        {
                learning.Default_Image_Name__c='';
                insert learning;
        }
 
            if (hdnLearningAddTags!=null)
                {
                      List<string> strLst=new List<string>();
                      strLst=hdnLearningAddTags.split(',');
                      AthenaUtility.AssociateTags(strLst,AthenaUtility.Learning, learning.id);
                }
        
        
        if(hdnAddCurrentLearning)//Add to current Learning Board
        {

            List<Learning_Board_Learning__c> lstLrnBrdLrng=[SELECT id,Display_Sequence_Nbr__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:this.LearningBoardsid];
             integer iMax=0;    
            if(lstLrnBrdLrng==null)
            {
            iMax=1;
            } 
            else
            {
             iMax= lstLrnBrdLrng.size()+1;
            }          
             
             system.debug('aResult: '+iMax);

            Learning_Board_Learning__c lrngBrdLrng= new Learning_Board_Learning__c();
            lrngBrdLrng.Learning_ID__c = learning.id;
            lrngBrdLrng.Learning_Board_ID__c = this.LearningBoardsid;
            lrngBrdLrng.Display_Sequence_Nbr__c =iMax;         
            insert lrngBrdLrng;
        }
    }

    catch (DMLException e) {
        } 
    finally {
         Lrngattach.body = null; // clears the viewstate
         LearningTitle='';
         LearningDesc='';
         
         }
               
    }
 
 
public void LBChangeOwnerId(){
system.debug('Change :' +hdnChangeOwnerId);
  Learning_Board__c LBO = [SELECT OwnerId, Id, Name FROM Learning_Board__c where Id =:this.LearningBoardsid limit 1];
        LBO.OwnerId = hdnChangeOwnerId;
        update LBO;
}
public void GetRelatedLB()
{
        List<Related_Learning_Board__c> NonRelatedLearningBoard1 = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__r.name__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:this.LearningBoardsid and Related_Learning_Board_ID__r.Is_Active__c=true order by Display_Sequence_Nbr__c ];
        ChangeOrderRelatedLearningBoard = new List<SelectOption>();
        
        for ( Related_Learning_Board__c c : NonRelatedLearningBoard1 ) {
            ChangeOrderRelatedLearningBoard.add(new SelectOption(c.Id, c.Related_Learning_Board_ID__r.name__c));
        }
}
 
public void GetLearningBoardOrder()
{
List<Learning_Board_Learning__c> LearningBoard =[SELECT  Learning_ID__c,Learning_ID__r.name__c, Display_Sequence_Nbr__c FROM Learning_Board_Learning__c where Learning_Board_ID__C=:this.LearningBoardsid order by Display_Sequence_Nbr__c ];
ChangeLearningBoardOrder=new List<SelectOption>();
 
for(Learning_Board_Learning__c LBLC:LearningBoard){
ChangeLearningBoardOrder.add(new SelectOption(LBLC.Learning_ID__c, LBLC.Learning_ID__r.name__c));
}
}
 
public PageReference  NavigateCreateLearningBoard(){
    PageReference pRef = new PageReference('/apex/AthenaCreateLearningBoard');
pRef.setRedirect(true);
            return pRef;
}
 
Public PageReference SaveLearningChangeOrder(){
        
        integer i=1;
        List<Learning_Board_Learning__c> LBLList = [SELECT Learning_ID__c,Learning_ID__r.name__c, Display_Sequence_Nbr__c FROM Learning_Board_Learning__c where Learning_Board_ID__C=:this.LearningBoardsid order by Display_Sequence_Nbr__c ];     
        List<Learning_Board_Learning__c> UpdatedList=new  List<Learning_Board_Learning__c>();
        for (SelectOption L : ChangeLearningBoardOrder){
            for (Learning_Board_Learning__c LBL : LBLList){
                if(LBL.Learning_ID__c== L.getValue()){
                    LBL.Display_Sequence_Nbr__c= i; 
                    UpdatedList.add(LBL);   
                }
            }
            i++;
        } 
        update UpdatedList; 
        Return Null;
    }
 
 
    public List<SelectOption> DisplayRadioButton {
    get {
        List<SelectOption> options = new List<SelectOption>();
            options.add( new SelectOption('U','Upload from Computer'));
                        options.add( new SelectOption('D','Default Image'));
                                return options;
    }
    set;
    }
    
      public PageReference save(){
       return null;
       }
    

Public List<SelectOption> LrngDefaultImagefilLink{get{
     
     //AthenaUtility athenaUtil=new AthenaUtility();
             system.debug('Default'+ optSelected);
        List<string> ls=new List<string>();
        string filename = AthenaUtility.ApplicationSettingValue('LrngDefaultImages');
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
 

Public List<SelectOption> LrngDefaultImagefilename{get{
     
     //AthenaUtility athenaUtil=new AthenaUtility();
             system.debug('Default'+ optSelected);
        List<string> ls=new List<string>();
        string filename = AthenaUtility.ApplicationSettingValue('LrngDefaultImages');
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
    
    Public List<SelectOption> DefaultImagefile(){
     
system.debug('Default'+ optSelected);
     //AthenaUtility athenaUtil=new AthenaUtility();
             
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
     
    
    
    public void SaveLB()
    {
           Learning_Board__c lrngBrd=[SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c,  Default_Image_Name__c FROM Learning_Board__c where id=:this.LearningBoardsid limit 1];
                   
                    lrngBrd.Name__c= hdnTxt;
                    lrngBrd.Description__c=hdnTxtArea;
                    lrngBrd.Is_Active__c=hdnChkActive;
                    lrngBrd.Featured__c=hdnChkFeatured;                   
                   update lrngBrd;
                  

                     List<string> strLst=new List<string>();
                   strLst=hdnLBTag.split(',');
                if (strLst != null && strLst.size() > 0 && hdnLBTag.trim() != '')
        {
            AthenaUtility.AssociateTags(strLst,AthenaUtility.LearningBoard, this.LearningBoardsid);
        }

    }
 
 
    @RemoteAction
    public static List<Learning__c> LearningSearch(string strSearch,string LearningBrdId)
    {
                        List<Learning__c> relLBs=SearchLearning(strSearch,LearningBrdId);
                          return relLBs;
    }
 
     Public static List<Learning__c> SearchLearning(String SearchStr,string LearningBrdId){
            String  SearchStrWithLike= '%'+ SearchStr+ '%';
            SET<ID> lrngIds = new SET<ID>();
            SET<ID> LrngIdsSet = new SET<ID>();
           
            List<Learning__c> lrngSrchRslt= new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);//stroing list of learing boards where name like cloud

           LIST<Learning__c> lstLrng = new LIST<Learning__c>([select id from Learning__c]);
            for (Learning__c l :lstLrng){
            lrngIds.add(l.id);
            }
            List<Tag_Item__c> tagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c = : SearchStr) and Item_Name__c=:AthenaUtility.Learning and Item_Identifier__c IN :lrngIds];

            for(Tag_Item__c TagItm : tagItmLst){
            LrngIdsSet.add(TagItm.Item_Identifier__c);
            }

            for(Learning__c Lrng : lrngSrchRslt){
            LrngIdsSet.add(Lrng.id);
            }

            List<learning_Board_Learning__c> LrngBrdLrngLst =[select id,learning_ID__c from learning_Board_Learning__c where Learning_Board_ID__c =:LearningBrdId];
            boolean flag;
            set<ID> finalLrngIds  = new set<ID>();
            for(ID l : LrngIdsSet){
                flag=false;
                for(learning_Board_Learning__c lbl : LrngBrdLrngLst){
                    if(lbl.Learning_ID__c == l){
                        flag=true;
                    }          
                }
                if(flag==false){
                    finalLrngIds.add(l);
                }   
            }

            List<Learning__c> lstLearnings = [SELECT Id,Name__c FROM Learning__c Where id IN:finalLrngIds and Is_Active__c=true order by LastModifiedDate Desc];
            return lstLearnings;
     }


 
  public void SaveLearnings(){
        List<Learning_Board_Learning__c> groupedResults = [SELECT Id FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:this.LearningBoardsid];

         integer maxDsplySeqNo = 0;
         if(groupedResults==null)
            {
               maxDsplySeqNo=1;
            } 
            else
            {
               maxDsplySeqNo = groupedResults.size() + 1;
            }    
        List<Learning_Board_Learning__c> LBLList=new  List<Learning_Board_Learning__c>();
 
        String[] splitInput = hdnLearnings.split(',');
        List<String> LBvalues = new List<String>( splitInput );
 
        for(string LLst : LBvalues){
            Learning_Board_Learning__c LBL = new Learning_Board_Learning__c();
            LBL.Learning_ID__c = LLst;
            LBL.Learning_Board_ID__c = this.LearningBoardsid;
            LBL.Display_Sequence_Nbr__c =maxDsplySeqNo;  
            LBLList.add(LBL);  
        }
        insert LBLList;    
    } 
    
    
    @RemoteAction
    public static List<Learning_Board__C> AddRelatedLB(string strSearch,string strLBID)
    {
                        List<Learning_Board__C> relLBs=SearchRelatedLearningBoard(strSearch,strLBID);
                          return relLBs;
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
    
    Public User getLearningBoardOwnerDtls(){
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe,u.Name, u.Division, u.Department, 
        u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id in 
        (select ownerid from learning_board__c where id = :this.LearningBoardsid)];
        return U;
    }
    
    Public void getLBComCount(){  
        LBCommentCount=getCommentCount(this.LearningBoardsid);
    }
    
    Private Integer getCommentCount(string lid){
        List<FeedItem> feedItms = [Select id from FeedItem where parentID=:lid];
        return feedItms.size(); 
    }   
    
    Public integer LBLikeCount{
        get{     
            LBLIkeCount=LikedItemCount(this.LearningBoardsid);
            return LBLIkeCount;
        }
        set;
    }
 
    Public integer LBOwnerLikeCount{
        get{     
            Learning_board__C lrngBrd=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
            LBOwnerLikeCount=LikedItemCount(lrngBrd.ownerid);
            return LBOwnerLikeCount;
        }
        set;
    }   
    
    Public integer LBCommentCount{
    get{     
        LBCommentCount=getCommentCount(this.LearningBoardsid);
        return LBCommentCount;
    }
    set;}
    
    Public integer LBOwnerCommentCount{
    get{     
        Learning_board__C lrngBrd=[select ownerid from learning_board__c where id = :this.LearningBoardsid];            
        LBOwnerCommentCount=getCommentCount(lrngBrd.ownerid);
        return LBOwnerCommentCount;
    }
    set;}
    
    Private integer LikedItemCount(string itemIdentifier){
        List<Liked_Item__C> LikdItms= [select like_count__c from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(LikdItms.size()!=0)
        {
            return Integer.ValueOf(LikdItms[0].like_count__c);
        }
        return 0;
    }  
    
  Public void RemoveLearningBoard(){
        Learning_Board_Learning__c LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =:hdnLearningId AND Learning_Board_ID__c =:this.LearningBoardsid Limit 1];
        delete LBL;
 
    } 
 
 
 
    Public List <LearningDtlsCustomClass> LearningDtls{
        get {
            LearningDtls.clear();            
            list<id> lstLearningIds= new list<id>();
            
            List<Learning_Board_Learning__c> learnings=[select Learning_ID__c,Learning_ID__r.Name__c,
            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.Default_Image_Name__c ,Learning_ID__r.Is_Active__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name 
            from Learning_Board_Learning__c where 
            Learning_Board_ID__c= : this.LearningBoardsid order by Display_Sequence_Nbr__c asc];
            
            for (Learning_Board_Learning__c l:learnings ) {
                lstLearningIds.add(l.Learning_ID__c);
            }
            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds]; 
            
            
            List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :lstLearningIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        
            
            
            //system.debug('@#$'+commCount.CommentCount);    
            for (Id LBId :lstLearningIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            }
                                            
            for (Learning_Board_Learning__c l:learnings ) {
                    LearningDtlsCustomClass lrng = new LearningDtlsCustomClass();
                    
                    lrng.LName=l.Learning_ID__r.Name__c;
                    lrng.LDescription = l.Learning_ID__r.Description__c;
                    lrng.LOwnerName = l.Learning_ID__r.Owner.name; 
                    lrng.LType= l.Learning_ID__r.type__c;   
                    lrng.LURL= l.Learning_ID__r.URL__C; 
                    lrng.LId = l.Learning_ID__c;
                    lrng.LikedOrNot=LikedOrNotLearn(l.Learning_ID__r.id);
                    lrng.LikeCount=integer.valueof( LBLikeCountMap.get(l.Learning_ID__r.id));
                    lrng.DocLnkXst=false; 
                    lrng.IsActive=l.Learning_ID__r.Is_Active__c;
                    List<string> strlst=AthenaUtility.getAssociatedTags(AthenaUtility.Learning,l.Learning_ID__r.id);
                    if(strlst.size()==0)
                          strlst.add('No Tags Associated');        
 
                     if(l.Learning_ID__r.Default_Image_Name__c!=''){                        
                            lrng.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + l.Learning_ID__r.Default_Image_Name__c;
                       }

                    lrng.Tags=strlst;    
                    if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                          lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                    }
                    //lrng.LType=='Link Or Document' &&
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
                 
                    if(l.Learning_ID__r.type__c!='Video')
                    {        
                        for(Attachment a: Att)
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
                return LearningDtls;                
            }   
    set;    
    }
    
    public List <RelatedLearningBoardCustomClass> RelatedLearningBoards{
        get {
            RelatedLearningBoards.clear();  
            
            list<id> lstRLBIds= new list<id>();
            list<Attachment> attachmentList = new List<Attachment>(); 
            
            
            List<Related_Learning_Board__c>  rLBs =[SELECT Display_Sequence_Nbr__c,Learning_Board_ID__c,Related_Learning_Board_ID__c 
,Related_Learning_Board_ID__r.name__c,Related_Learning_Board_ID__r.Owner.Name,            Related_Learning_Board_ID__r.description__c,Related_Learning_Board_ID__r.ID,Related_Learning_Board_ID__r.OwnerId
FROM Related_Learning_Board__c where Learning_Board_ID__c=: this.LearningBoardsid and Related_Learning_Board_ID__r.Is_Active__c = True order by 
            Display_Sequence_Nbr__c ];
            
            
          /*  List<Related_Learning_Board__c>  rLBs =[SELECT Id, IsDeleted, Name, CurrencyIsoCode, CreatedDate, 
            CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Display_Sequence_Nbr__c, 
            Learning_Board_ID__c,Related_Learning_Board_ID__r.name__c,Learning_Board_ID__r.Owner.Name,
            Related_Learning_Board_ID__r.description__c,Learning_Board_ID__r.ID,Learning_Board_ID__r.OwnerId,
            Learning_Board_ID__r.IsDeleted,Learning_Board_ID__r.Name,Learning_Board_ID__r.CurrencyIsoCode,
            Learning_Board_ID__r.CreatedDate,Learning_Board_ID__r.LastModifiedDate,Learning_Board_ID__r.SystemModstamp,
            Learning_Board_ID__r.LastViewedDate,Learning_Board_ID__r.Name__c,Learning_Board_ID__r.Description__c,
            Learning_Board_ID__r.Featured__c,Learning_Board_ID__r.Is_Active__c from Related_Learning_Board__c where 
            Learning_Board_ID__r.Is_Active__c = True and Learning_Board_ID__r.id=: this.LearningBoardsid order by 
            Display_Sequence_Nbr__c];*/
              
            for (Related_Learning_Board__c rLB:rLBs) {
                lstRLBIds.add(rLB.Related_Learning_Board_ID__c);
            }
                
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstRLBIds];   
    
            for(Related_Learning_Board__c lb: rLBs){
                RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            
                lbCustom.LBName = lb.Related_Learning_Board_ID__r.Name__c; 
                
                lbCustom.LbId = lb.Related_Learning_Board_ID__r.id;
                lbCustom.StaticImage = true;
                lbCustom.LBOwnerName=lb.Related_Learning_Board_ID__r.Owner.Name; 
                for(Attachment att: attachmentList){
                    if(lb.Related_Learning_Board_ID__r.id  == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
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
    
    
     private String GetResourceURL(String resourceName)  
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
    
    Public RelatedLearningBoardCustomClass LearningBoardDtls{
        get {
    
        list<Attachment> attachmentList = new List<Attachment>();         
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :LearningBoardsid];
        
        List<Learning_Board__c>  lrngbrds= [select id,Name__c,description__c,Default_Image_Name__c, Owner.name,Owner.Id, Featured__c,Is_Active__c,
        CreatedDate from Learning_Board__c where ID =:LearningBoardsid ];
        //Is_Active__c = True and                            
         
        for(Learning_Board__c lb: lrngbrds){
            RelatedLearningBoardCustomClass  lbCustom= new RelatedLearningBoardCustomClass ();
            LBDescription=lb.description__c;
            lbCustom.LB_Active=lb.Is_Active__c;
            system.debug('IsActive' + lb.Is_Active__c );
            lbCustom.LB_Featured=lb.Featured__c;
             system.debug('IsFeatured' + lb.Featured__c);
            lbCustom.LBName = lb.Name__c; 
            lbCustom.LBDescription=lb.description__c;           
            if(lb.Default_Image_Name__c!=''){                        
                lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + lb.Default_Image_Name__c;          
            }
            lbCustom.LbId = lb.Id;            
            lbCustom.StaticImage = true;
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg')){
                    lbCustom.AttachmentId = att.Id;                
                    lbCustom.StaticImage = false;
                }  
            }
            LearningBoardDtls=lbCustom;
        }                
        return LearningBoardDtls;                
    }   
    set;    
    }
    
    
    Public boolean LikedOrNotLB{
    get{
            boolean isLiked=false;    
            List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
            for(Liked_Item__c LikdItm:LikdItms)
            {            
                list<User_Liked_Item__c> UsrlikdItms=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c=:UserInfo.getUserId()and Liked_Item_ID__c=:LikdItm.Id];
 
                for(User_Liked_Item__c UsrlikdItm:UsrlikdItms)
                {                       
                     isLiked=true;                                                    
                }
                return isLiked;
            }  
            return isLiked;    
    }    
    set;}
    
    Public void LearningBoardLike(){
        List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
        boolean isLikedItem=false;
        Liked_Item__c litm=new Liked_Item__c();           
        for(Liked_Item__c lb:lbdtls)
        {
            isLikedItem=true;  
            litm.id=lb.id;  
        }
        
        if(!isLikedItem)
        {
            litm.Item_Identifier__c=LearningBoardsid;
            litm.Item_Name__c='Learning Board';
            insert litm;                        
        }
        
        List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
        if(UsrlikdItms.size()==0)
        {
            User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
            UsrlikdItm.Liked_Item_ID__C=litm.ID;
            UsrlikdItm.User_ID__C=UserInfo.getUserId();                
            insert UsrlikdItm;            
        }

        
    }    
    
    Public void LearningBoardUnLike(){        
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:LearningBoardsid ];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where 
            Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C UsrlikdItm:UsrlikdItms)
                {
                    delete UsrlikdItm;            
                }
            }
        }
    } 
    
    Public void LearningLike(){
        List<Liked_Item__c> lbdtls = [select Id,Name from Liked_Item__c where Item_Identifier__c=:Learningid];
        boolean isLikedItem=false;
        Liked_Item__c litm=new Liked_Item__c();           
        for(Liked_Item__c lb:lbdtls)
        {
            isLikedItem=true;  
            litm.id=lb.id;  
        }
    
        if(!isLikedItem)
        {
            litm.Item_Identifier__c=Learningid;
            litm.Item_Name__c='Learning';
            insert litm;                        
        }
        
        
        List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
        if(UsrlikdItms.size()==0)
        {
            User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
            UsrlikdItm.Liked_Item_ID__C=litm.ID;
            UsrlikdItm.User_ID__C=UserInfo.getUserId();                
            insert UsrlikdItm;            
        }       
                   
    } 
    
    Public void LearningUnLike(){    
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c=:Learningid];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where 
            Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C UsrlikdItm:UsrlikdItms)
                {
                    delete UsrlikdItm;            
                }
            }
        }         
    } 
            
    Private boolean LikedOrNotLearn(string lrngID){
        boolean isLiked = false;    
        List<Liked_Item__c> LikdItms = [select Id,Name from Liked_Item__c where Item_Identifier__c = :lrngID];
        for(Liked_Item__c LikdItm:LikdItms)
        {
            list<User_Liked_Item__c> UsrlikdItms=[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c = :UserInfo.getUserId() and Liked_Item_ID__c = :LikdItm.Id];
    
            for(User_Liked_Item__c UsrlikdItm :UsrlikdItms)
            {                       
                 isLiked=true;                                                    
            }
            return isLiked;                
        }  
        return isLiked;    
    }   
      
    //Learning Board Search: redirects to the social learning page to display the search results
    Public PageReference dosearch(){
        PageReference pRef = new PageReference('/apex/athenaSocialLearning');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
     
 
 
//Related Learning Board - Start 
 
    Public static List<Learning_Board__c> SearchRelatedLearningBoard(String SearchStr,String strLBID){
        
        String  SearchStrWithLike= '%'+ SearchStr + '%';
         
        SET<ID> lbBrdIds = new SET<ID>();
        SET<ID> lbBrdIdSet = new SET<ID>();
        List<Learning_Board__c> lbBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)]);
        
        
        LIST<Learning_Board__c> lstAlllbBrds = new LIST<Learning_Board__c>([select id from Learning_Board__c]);
        for (Learning_Board__c l :lstAlllbBrds){
           lbBrdIds.add(l.id);
        }
        
        List<Tag_Item__c> tagItmLst=[
        SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: SearchStr) and Item_Name__c=:AthenaUtility.LearningBoard  and Item_Identifier__c IN :lbBrdIds];
        
        
        for(Tag_Item__c TagItm : tagItmLst){
             lbBrdIdSet.add(TagItm.Item_Identifier__c);
        }
        system.debug('lbBrdIdSet1'+lbBrdIdSet);
        for(Learning_Board__c lb : lbBrdSrchRslt){
             lbBrdIdSet.add(lb.id);
        }
        
        List<Related_learning_Board__c > rltdLrngBrdLst =[select id,Related_Learning_Board_ID__c from Related_learning_Board__c where Learning_Board_ID__c =:strLBID];
        boolean flag;
        set<ID> finalLrngBrdIds = new set<ID>();
        for(ID l : lbBrdIdSet){
            flag=false;
            for(Related_learning_Board__c lbl : rltdLrngBrdLst){
                if(lbl.Related_Learning_Board_ID__c == l){
                    flag=true;
                }          
            }
            if(flag==false){
                finalLrngBrdIds.add(l);
            }   
        }
        List<Learning_Board__c> lbList = new List<Learning_Board__c>([SELECT Id,Name__c FROM Learning_Board__c where id IN:finalLrngBrdIds and Is_Active__c=true order by LastModifiedDate Desc]);

        
        return lbList;
    } 
  
        public void SaveRelatedLB()
         {
        list<Related_Learning_Board__c> groupedResults = [SELECT Id FROM Related_Learning_Board__c WHERE Learning_Board_ID__c =:this.LearningBoardsid];
        
        integer maxDsplySeqNo = 0;
         if(groupedResults==null)
            {
               maxDsplySeqNo=1;
            } 
            else
            {
               maxDsplySeqNo = groupedResults.size() + 1;
            }    

        List<Related_Learning_Board__c> rltdLrngBrdLst=new List<Related_Learning_Board__c>();
 
        String[] splitInput = hdnRelatedLB.split(',');
        List<String> LrngBrdIds = new List<String>( splitInput );
 system.debug('LrngBrdIds:' +LrngBrdIds);
system.debug('splitInput:' +splitInput);
system.debug('maxDsplySeqNo:' +maxDsplySeqNo);

 
        for(string LrnBrdId : LrngBrdIds){
            Related_Learning_Board__c rltdLrngBrd = new Related_Learning_Board__c();
            rltdLrngBrd.Related_Learning_Board_ID__c = LrnBrdId;
            rltdLrngBrd.Learning_Board_ID__c = this.LearningBoardsid;
            rltdLrngBrd.Display_Sequence_Nbr__c = maxDsplySeqNo;
            rltdLrngBrdLst.add(rltdLrngBrd);
        }
        insert rltdLrngBrdLst;
//GetRelatedLB();
    }
 
Public PageReference SaveRelatedChangeOrder(){        
        integer dsplySeqNo=1;
        List<Related_Learning_Board__c> rltdLrngBrdLst= [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c, Related_Learning_Board_ID__c FROM Related_Learning_Board__c where Learning_Board_ID__C=:this.LearningBoardsid];
        List<Related_Learning_Board__c> updtdRltdLrngBrdLst=new  List<Related_Learning_Board__c>();
        system.debug('ChangeOrderRelatedLearningBoard:' +ChangeOrderRelatedLearningBoard);
        for(SelectOption so : ChangeOrderRelatedLearningBoard){
            for(Related_Learning_Board__c rltdLrngBrd: rltdLrngBrdLst){
                if(rltdLrngBrd.Id== so.getValue()){
                    rltdLrngBrd.Display_Sequence_Nbr__c= dsplySeqNo; 
                    updtdRltdLrngBrdLst.add(rltdLrngBrd);   
                }
            }
            dsplySeqNo++;
        }
        update updtdRltdLrngBrdLst;
        Return Null;
    }
 
 
  Public void RemoveRelLearningBoard(){
        Related_Learning_Board__c rltdLrngBrd= [Select Id From Related_Learning_Board__c WHERE Related_Learning_Board_ID__c =: hdnRelBrdId AND Learning_Board_ID__c =:this.LearningBoardsid Limit 1];
        delete rltdLrngBrd;
    } 
 
 
    
    // Related Learning Board - End
 
 
}