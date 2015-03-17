public with sharing class AthenaLearningBoard{
    Public ID LBID;
    Public string Name;
    Public string Description;
    Public string ShortDescription;
    Public boolean IsActive;
    Public boolean Featured;
    Public string DefaultImageName;
    Public List<Tag__c> tags;
    Public string AttachmentContent;
    Public string AttachmentURL;

    Public Learning_Board__c LB;
    Public List<Learning_Board__c> LBList;
    Public List<Learning__c> LList;

     
    Public AthenaLearningBoard(){}
    /*Public void SaveAttachment(){}
    Public void SaveTags(){}
    Public void Searchtags(string SearchStr){}  */
    
    
    public void Save(){
        if (LBID!=NULL){
            LB = [SELECT Id, Name__c, Description__c, Featured__c, Is_Active__c, Default_Image_Name__c FROM Learning_Board__c where id=:LBID Limit 1];
            LB.Name__c = Name;
            LB.Description__c = Description;
            LB.Is_Active__c = IsActive;
            LB.Featured__c = Featured;
            LB.Default_Image_Name__c = DefaultImageName;
            update LB;
        }           
    }
    
     Public static List<Learning_Board__c> SearchRelatedLearningBoard(String SearchStr){
        
        boolean alrdyPrsnt;
        String  StrnewSearchText= '%'+ SearchStr + '%'; 

        List<Learning_Board__c> lrngBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE Name__c like : StrnewSearchText]);//WHERE Name__c =:'%SearchStr%'   // WHERE Name__c ='Cloud'
        
        system.debug('Search Result:- ' + lrngBrdSrchRslt);
        List<Learning_board__c> lrngBrdIdsLst = new List<Learning_board__c>([Select Id from Learning_Board__c]);
        List<string> lrngBrdIds=new List<string>();
        for(Learning_board__c lrngBrdId:lrngBrdIdsLst)
        {
            lrngBrdIds.add(lrngBrdId.Id);
        }
        
        List<Tag_Item__c> tagItmLst = new List<Tag_Item__c>([SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: SearchStr) and Item_Name__c='Learning Board' and Item_Identifier__c IN :lrngBrdIds]);       
        system.debug('tagItmLst'+tagItmLst);
        List<ID> lbTagIds = new List<ID>();
        for (Tag_Item__c tagItm: tagItmLst){
            lbTagIds.add(tagItm.Item_identifier__c);
        }
        system.debug('Tag Ids:- ' + lbTagIds);
         
         
        List<Learning_Board__c> searchResult = new List<Learning_Board__c>();       
        for (Learning_Board__c lrngBrd :lrngBrdSrchRslt) {
            alrdyPrsnt  = false;              
            for(ID lrngId :lbTagIds){
                if(lrngBrd.id == lrngId ){
                    alrdyPrsnt = true;
                    break;
                }
            }
            if(alrdyPrsnt == false){
                searchResult.add(lrngBrd);
            }
        }
		system.debug('Total Search Result' + searchResult);

        
        List<Related_Learning_Board__c> rltdLrngBrdsLst= new List<Related_Learning_Board__c>([SELECT Id,Name,Related_Learning_Board_ID__c FROM Related_Learning_Board__c WHERE Learning_Board_ID__c ='a6tZ00000008RI0IAM']);
        system.debug('already related :-' + rltdLrngBrdsLst);
         List<Learning_board__c> finalSrchRslt = new List<Learning_board__c>();
        for (Learning_Board__c lrngBrd :searchResult) {
            alrdyPrsnt = false;              
            for(Related_Learning_Board__c rltdLrngBrd :rltdLrngBrdsLst){
                if(lrngBrd.id == rltdLrngBrd.Related_Learning_Board_ID__c){
                    alrdyPrsnt = true;
                    break;
                }
            }
            if(alrdyPrsnt == false){
                finalSrchRslt.add(lrngBrd);
            }
        }       
        system.debug('Final Result' +finalSrchRslt);
        return finalSrchRslt;
    }
    
     
    
    
    
    
    
    
    
    
    
    
    
    Public List<Learning__c> SearchLearning(String SearchStr){
        Integer l_flag;
        List<Learning__c> LSearch = new List<Learning__c>();
        List<Learning_Board_Learning__c> LBLSearch = new List<Learning_Board_Learning__c>();
        List<Learning__c> searchResult = new List<Learning__c>();
        LSearch = [SELECT Id,Name__c,Name FROM Learning__c WHERE Short_Description__c LIKE '%SearchStr%' OR Name__c LIKE '%SearchStr%'];
        LBLSearch = [SELECT Id,Name,Learning_ID__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:LBID];
        for (Learning__c l :LSearch ) {
            l_flag = 0;              
            for(Learning_Board_Learning__c l1 :LBLSearch ){
                if(l.id == l1.Learning_ID__c){
                    l_flag = 1;
                }
            }
            if(l_flag != 1){
                searchResult.add(l);
            }
        } 
               
        return SearchResult;
    }
    
    
    public void MapLearnings(ID LBID){
        AggregateResult[] groupedResults = [SELECT MAX(Display_Sequence_Nbr__c) Max FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:'LBID'];
        system.debug('groupedResults' +groupedResults[0].get('max'));
        integer i = integer.valueof(groupedResults[0].get('max'));
        
        List<Learning_Board_Learning__c> LBLList = new List<Learning_Board_Learning__c>();
        for(Learning__c LLst : LList){
            Learning_Board_Learning__c LBL = new Learning_Board_Learning__c();
            LBL.Learning_ID__c = LLst.id;
            LBL.Learning_Board_ID__c = LBID;
            LBL.Display_Sequence_Nbr__c =i+1;  
            LBLList.add(LBL);  
        }
        insert LBLList;    
    }
    
    public void ChangeLearningBoardLearningOrder(List<Learning__c> LList){
        integer i;
        List<Learning_Board_Learning__c> LBLList = [SELECT Id, Name ,Display_Sequence_Nbr__c,Learning_Board_ID__c FROM Learning_Board_Learning__c where Learning_Board_ID__C=:'LBID' order by Display_Sequence_Nbr__c ];     
        List<Learning_Board_Learning__c> UpdatedList=new  List<Learning_Board_Learning__c>();
        for (Learning__c L : LList){
            for (Learning_Board_Learning__c LBL : LBLList){
                if(LBL.Id== L.Id){
                    LBL.Display_Sequence_Nbr__c= i; 
                    UpdatedList.add(LBL);   
                }
            }
            i++;
        } 
        update UpdatedList;   
    }
    
    Public void RemoveLearning(ID LID){
        Learning_Board_Learning__c LBL = [Select Id FROM Learning_Board_Learning__c Where Learning_ID__c =: LID AND Learning_Board_ID__c =:LBID];
        delete LBL;
        
    }
    
    Public void ChangeOwner(ID UID){
        Learning_Board__c LBO = [SELECT OwnerId, Id, Name FROM Learning_Board__c where Id =:LBID];
        LBO.OwnerId = UID;
        update LBO;
    }
    
}