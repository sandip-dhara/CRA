public class ContractOnCaseController{
    public static void ContractOnCase(List<case> caselist){
    
        if(!caselist.isEmpty()){
        List<Related_Contracts__c> casecontractlist=new List<Related_Contracts__c>();
        
            for(Case caserecord: caselist){
                if(caserecord.SelectedContracts__c!=null&&caserecord.SelectedContracts__c!=''){
                String [] contractrefrenceid=caserecord.SelectedContracts__c.split(',');
                
                    for(String contarctid: contractrefrenceid){
                    Related_Contracts__c casecontract=new Related_Contracts__c();        
                    casecontract.Case__c=caserecord.id;
                    casecontract.Contract_Reference__c=contarctid;
                    casecontractlist.add(casecontract);
                    }
                }
            }
            insert casecontractlist;
           
        }
     }
    
}