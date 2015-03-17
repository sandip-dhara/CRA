Public Class AthenaLearning{
    Public ID LID;
    Public ID LUID =  UserInfo.getUserId();
    Public string Name;
    Public string Description;
    Public string ShortDescription;
    Public boolean IsActive;
    Public boolean Featured;
    Public String URL;
    Public string DefaultImageName;
    Public List<String> Type;
    
    Public Learning__c L;
    Public List<Tag__c> tags;
    
    Public List<Learning__c> MyLearnings(){
        
        if (LUID!=NULL){
            List<Learning__c> L = [SELECT Id,Default_Image_Name__c,Description__c,Is_Active__c,Name__c,Short_Description__c,Type__c,URL__c FROM Learning__c WHERE OwnerId=:LUID];// where id=:'LID' Limit 1];
            return L;
        }
        else 
            return Null;
    }

    Public List<Learning__c> SearchLearning(String SearchStr){
        Integer l_flag;
        System.debug('SearchStr##'+SearchStr);
        
        List<Learning__c> LSearch = new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE Name__c ='Cloud Data']);//WHERE Name__c =:'%SearchStr%'   // WHERE Name__c ='Cloud'
        List<Learning_Board_Learning__c> LBLSearch = new List<Learning_Board_Learning__c>([SELECT Id,Name,Learning_Board_ID__c FROM Learning_Board_Learning__c WHERE Learning_Board_ID__c =:LID]);
        List<Learning__c> searchResult = new List<Learning__c>();
        
        System.debug('LSearch'+LSearch);
        system.debug('LBLSearch'+LBLSearch);
        for (Learning__c l :LSearch ) {
            l_flag = 0;              
            for(Learning_Board_Learning__c l1 :LBLSearch ){
                if(l.id == l1.Learning_Board_ID__c){
                    l_flag = 1;
                    break;
                }
            }
            if(l_flag != 1){
                searchResult.add(l);
            }
        }
        List<Tag_Item__c> TIList = new List<Tag_Item__c>([SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c = 'Cloud') and Item_Name__c='Learning']);       
        List<ID> SID = new List<ID>();
        for (Tag_Item__c TI : TIList){
            SID.add(TI.Item_identifier__c);
        }
        List<Learning__c> LList = new List<Learning__c>([Select Id from Learning__c where Id=:SID]);
        Integer sl_flag;
        List<Learning__c> FList = new List<Learning__c>();
        for (Learning__c l :searchResult) {
            sl_flag = 0;              
            for(Learning__c  l1 :LList){
                if(l.id == l1.Id){
                    sl_flag= 1;
                    break;
                }
            }
            if(sl_flag!= 1){
                FList.add(l);
            }
        }
        return FList;
    }
    Public String AssociatedTags(){
        String Str='';
        List<Tag_Item__c> TIList = new List<Tag_Item__c>();
        system.debug('LID'+LID);
        String str1 = '%'+LID+'%';
        system.debug('str1'+str1);
        TIList = [SELECT Id,Item_Identifier__c,Item_Name__c,Name,Tag_ID__r.Value__c FROM Tag_Item__c WHERE Item_Identifier__c LIKE:str1];// 
        system.debug('TIList'+TIList);
        for (Tag_Item__c TI : TIList){
            string S ='\'sAcc\''+',' ;
            S = S.replace('sAcc',string.valueOf(TI.Tag_ID__r.Value__c)); 
            Str += S; 
        }
        str = str.removeEnd(',');
        system.debug('str' +str);
        return str;
    }
    
    public void Save(){
        if (LID!=NULL){
            L = [SELECT Id,Default_Image_Name__c,Description__c,Is_Active__c,Name__c,Short_Description__c,Type__c,URL__c FROM Learning__c];// where id=:'LID' Limit 1];
            L.Name__c = Name;
            L.Description__c = Description;
            L.Is_Active__c = IsActive;
            L.Short_Description__c = ShortDescription;
            L.Default_Image_Name__c = DefaultImageName;
            L.URL__c = URL;
            update L;
        }
        else{
            Learning__c NL = new Learning__c();
            L.Name__c = Name;
            L.Description__c = Description;
            L.Is_Active__c = IsActive;
            L.Short_Description__c = ShortDescription;
            L.Default_Image_Name__c = DefaultImageName;
            L.URL__c = URL;
            insert NL;
        }        
    }
}