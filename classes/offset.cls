public class offset {
    Public integer min =5;
    Public integer max =2;
    Public offset(){
        records = [select id,name from user limit :min offset :max];
    }
    Public List<user> records{get;set;}
    Public Pagereference totalrecords(){
        max = min+max;
        List<user> templst;
        tempLst = [select id,name from user limit :min offset :max];
        records.addall(tempLst);
        return Null;
    
    }
}