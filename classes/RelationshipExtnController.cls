public class RelationshipExtnController {
    public Opportunity_Plan__c OppPlan;
    Public List<Relationship_Suite__c> RelSuiteContacts;
    public String relmap {get;set;}
    Public String OppPlanId;
    Public Integer RelSuiteC;
    Public List<AggregateResult> RelSuiteMa;
    Public List<AggregateResult> RelSuiteSMa;
    Public List<AggregateResult> RelSuiteMi;
    //Public AggregateResult RelSuiteMa;
    //Public AggregateResult RelSuiteMi;
    Public List<Relationship_Suite__c> RelStyleV1;
    Public List<Relationship_Suite__c> RelStyleV2;
    Public List<Relationship_Suite__c> RelStyleV3;
    Public List<Relationship_Suite__c> RelStyleV4;
    public List<String> RelStringSplit;
    public List<OpportunityContactRole> listContact2{get;set;}
    Public String OptyId;
    public Opportunity_Plan__c opplan;
    public String searchText;
    List<Relationship_Suite__c> relshiplist{get; set;}
    public List<Relationship_Suite__c> relshiplistmaxval;
    List<Relationship_Suite__c> maxinmedlist;
    public integer RelSuiteMin{get; set;}
    public string contactcolorcodestr;

    public RelationshipExtnController(ApexPages.StandardController controller) {
        this.OppPlan = (Opportunity_Plan__c)controller.getRecord();
        OppPlanId = this.OppPlan.Id;
        listContact2=new List<OpportunityContactRole>();
        opplan= [Select Opportunity__c from Opportunity_Plan__c where id= :OppPlanId] ;
        OptyId=opplan.Opportunity__c;
        relshiplist = new List<Relationship_Suite__c>();
        relshiplistmaxval=new List<Relationship_Suite__c>();
        maxinmedlist=new List<Relationship_Suite__c>();
        maxmedRelationshipPPr();
    }


    /********************************************************************************
      //Get the max Consecutive and Med Consecutive and Min Value from the List-Added as part of Release 6 by Mousumi Panda
     **********************************************************************************/

    public void maxmedRelationshipPPr(){

        List<Relationship_Suite__c> relshiplistmedval=new List<Relationship_Suite__c>();
        RelSuiteMa = [select MAX(PP_S__c) max from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId];
        system.debug('*******RelSuiteMa******'+RelSuiteMa);
        integer maxval=integer.valueOF(RelSuiteMa[0].get('max'));
        relshiplist=[Select PP_S__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId AND PP_S__c>0 ORDER BY PP_S__c DESC];


        If(relshiplist.size()>=4){
            for(integer i=0;i<relshiplist.size();i++)
            {
                if(relshiplist[i].PP_S__C <= maxval)
                {
                    integer difference= maxval-Integer.valueOf(relshiplist[i].PP_S__C);
                    system.debug('*******difference******'+difference);
                    if(difference ==1 || difference ==0){
                        relshiplistmaxval.add(relshiplist[i]);
                        maxval=Integer.valueOf(relshiplist[i].PP_S__C);
                        system.debug('*******maxval******'+maxval);
                        system.debug('*******relshiplistmaxval******'+relshiplistmaxval);
                    }
                    else{
                        relshiplistmedval.add(relshiplist[i]);
                        system.debug('*******relshiplistmedval******'+relshiplistmedval);
                    }
                }

            }
            if(relshiplistmedval.size() > 0){
                integer maxinmed=integer.valueof(relshiplistmedval[0].PP_S__C);
                system.debug('*******maxinmed+Before finding the max******'+maxinmed);
                for(integer i=0;i<relshiplistmedval.size();i++){
                    if(relshiplistmedval[i].PP_S__C >= maxinmed)
                        maxinmed=integer.valueof(relshiplistmedval[i].PP_S__C);
                    system.debug('*******maxinmed+After comparing relshiplistmedval[i].PP_S__C******'+relshiplistmedval[i].PP_S__C);
                    system.debug('*******maxinmed+After finding the max******'+maxinmed);
                }

                for(integer i=0;i<relshiplistmedval.size();i++){
                    if(relshiplistmedval[i].PP_S__C <= maxinmed){
                        integer diffmed= maxinmed-Integer.valueOf(relshiplistmedval[i].PP_S__C);
                        if(diffmed ==1 || diffmed ==0)
                            maxinmedlist.add(relshiplistmedval[i]);
                    }
                }
            }
            RelSuiteMinfun();

        }

    }

    public void RelSuiteMinfun ()
    {
        RelSuiteMi = [select MIN(PP_S__c) min from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId AND PP_S__c<>0];
        RelSuiteMin= integer.valueOf(RelSuiteMi[0].get('min'));
    }

    public List<Relationship_Suite__c> RelSuite {get
        {
        RelSuiteContacts = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId ORDER BY PP_S__c DESC];


        return RelSuiteContacts;
        }        
    set;
    }

    public integer RelSuiteCount {get
        {
        RelSuiteC = [select count() from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId];
        return RelSuiteC;
        }        
    set;
    }

    public integer RelSuiteQ1 {get
        {
        RelSuiteQ1= [select count() from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Analytical'];
        return RelSuiteQ1;
        }        
    set;
    }
    public integer RelSuiteQ2 {get
        {
        RelSuiteQ2= [select count() from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Amiable'];
        return RelSuiteQ2;
        }        
    set;
    }
    public integer RelSuiteQ3 {get
        {
        RelSuiteQ3 = [select count() from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Expressive'];
        return RelSuiteQ3;
        }        
    set;
    }
    public integer RelSuiteQ4 {get
        {
        RelSuiteQ4 = [select count() from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Driving'];
        return RelSuiteQ4;
        }        
    set;
    }



    public List<Relationship_Suite__c> RelStyle1 {get
        {
        RelStyleV1 = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c, relationship_map_string__c 
                      from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Analytical'];
        try{
            for (Relationship_Suite__c rs: RelStyleV1){
                string str=(String)rs.Relationship_map__c;
                list<String> str1;
                list<String> str3;
                list<String> str4;
                if(str!=Null)
                    str1= str.Split(';');
                if(str1!=Null)
                    str3 = str1[0].Split('-');
                if(str1[1]!=Null)
                    str4 = str1[1].Split('-');
                rs.relationship_map_string__c = str3[1] + str4[1];
                system.debug('Relation Map String'+rs.relationship_map_string__c);
            }
        }
        catch(Exception e)
        {
        }    
        return RelStyleV1;
        }        
    set;
    }

    public List<Relationship_Suite__c> RelStyle2 {get
        {
        RelStyleV2 = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c, relationship_map_string__c from Relationship_Suite__c
                      where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Amiable'];
        try{
            for (Relationship_Suite__c rs: RelStyleV2){
                string str=(String)rs.Relationship_map__c;
                list<String> str1;
                list<String> str3;
                list<String> str4;
                if(str!=Null)
                    str1= str.Split(';');
                if(str1!=Null)
                    str3 = str1[0].Split('-');
                if(str1[1]!=Null)
                    str4 = str1[1].Split('-');
                rs.relationship_map_string__c = str3[1] + str4[1];
                system.debug('Relation Map String'+rs.relationship_map_string__c);
            }
        }
        catch(Exception e){}
        return RelStyleV2;
        }        
    set;
    }

    public List<Relationship_Suite__c> RelStyle3 {get
        {
        RelStyleV3 = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c, relationship_map_string__c 
                      from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Expressive'];
        Try{
            for (Relationship_Suite__c rs: RelStyleV3){
                string str=(String)rs.Relationship_map__c;
                list<String> str1;
                list<String> str3;
                list<String> str4;
                if(str!=Null)
                    str1= str.Split(';');
                if(str1!=Null)
                    str3 = str1[0].Split('-');
                if(str1[1]!=Null)
                    str4 = str1[1].Split('-');
                rs.relationship_map_string__c = str3[1] + str4[1];
                system.debug('Relation Map String'+rs.relationship_map_string__c);
            } 
        }
        catch(Exception e){}      
        return RelStyleV3;
        }        
    set;
    }

    public List<Relationship_Suite__c> RelStyle4 {get
        {
        RelStyleV4 = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c, relationship_map_string__c 
                      from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and    PowerMatrix__c='Driving'];
        try{
            for (Relationship_Suite__c rs: RelStyleV4){
                string str=(String)rs.Relationship_map__c;
                list<String> str1;
                list<String> str3;
                list<String> str4;
                if(str!=Null)
                    str1= str.Split(';');
                if(str1!=Null)
                    str3 = str1[0].Split('-');
                if(str1[1]!=Null)
                    str4 = str1[1].Split('-');
                rs.relationship_map_string__c = str3[1] + str4[1];
                system.debug('Relation Map String'+rs.relationship_map_string__c);
            }   
        }
        catch(Exception e){}
        return RelStyleV4;
        }        
    set;
    }

    Public string getcontactcolorcodestr()
    {
        // RelSuiteContacts = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId ORDER BY PP_S__c DESC];
        List<Relationship_Suite__c> contacts1 = [Select Contact__r.Name,Contact__r.Title,RM_S__c,PP_S__c,Relationship_Map__c,Parent_Contact__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId ];
        List<String> ContactColorCode = new List<String>();
        integer i=0;
        for(Relationship_Suite__c rsc : contacts1){

            if(rsc.RM_S__c<16){
                ContactColorCode.add('data.setRowProperty(' + i +', \'style\', \'border: 4px '+ 'solid #E31C19' + '\''+');');
            }
            if(rsc.RM_S__c>15 &&rsc.RM_S__c<23){
                ContactColorCode.add('data.setRowProperty(' + i +', \'style\', \'border: 4px '+ 'solid  #F29900' + '\''+');');
            }
            if(rsc.RM_S__c>20 && rsc.RM_S__c<30){
                ContactColorCode.add('data.setRowProperty(' + i +', \'style\', \'border: 4px '+ 'solid #8F8F8F' + '\''+');');
            }
            if(rsc.RM_S__c>29 && rsc.RM_S__c<37){
                ContactColorCode.add('data.setRowProperty(' + i +', \'style\', \'border: 4px '+ 'solid #00A144' + '\''+');');
            }
            if(rsc.RM_S__c>36){
                ContactColorCode.add('data.setRowProperty(' + i +', \'style\', \'border: 4px '+ 'solid #007FC4' + '\''+');');
            }
            i++;
        }
        system.debug(ContactColorCode);
        contactcolorcodestr = String.join( ContactColorCode, '');
        return contactcolorcodestr;
    }


    Public String getContactdata()
    {
        List<Relationship_Suite__c> contacts = [Select Contact__r.Name,Contact__r.Title,Relationship_Map__c,Parent_Contact__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId];
        String datastr='' ;
        String dataname = '';
        String datatitle = '';
        String dataparent='';
        for (integer i=0;i<contacts.size();i++)
        {
            If(contacts[i].Contact__r.Title == null)
            {
                datatitle='';
            }
            else 
            {
                datatitle = contacts[i].Contact__r.Title;
            }
            If(contacts[i].Parent_Contact__c == null)
            {
                dataparent='';
            }
            else
            {
                dataparent=contacts[i].Parent_Contact__c;
            }

            dataname = '{v:\''+ contacts[i].Contact__r.Name +'\',f:\''+ contacts[i].Contact__r.Name +'<br/><font color=\"blue\"><i>'+ contacts[i].Contact__r.Title +'<i></font>\'' + '}';
            datastr += '[' + dataname;
            datastr += ',\'';
            datastr += dataparent;
            datastr += '\',\'';
            datastr += datatitle;
            datastr += '\'],';
            system.debug('***google****'+datastr);


        } 

        if(  datastr != ''){
            //datastr= datastr.substring(0,datastr.length()-1);// }
            datastr = datastr.substring(0,datastr.length()-1);
            system.debug('***google****'+datastr);
        }
        return datastr;
    }

    //custom rel suite table class
    public class rsCustom {
        public String Cr_Name {get;set;}
        public String Cr_Title{get;set;}
        public String parent_contact{get;set;}
        public Double PPS{get;set;}
        public Double RMS{get;set;}
        public String relationship_map{get;set;}
        public Id id{get;set;}
        public Integer decision_count {get;set;}
        public String colorcode {get;set;}
        //maxinmedlist
        //relshiplistmaxval

    }

    public List<rsCustom> RelSuite2 {get
        {
        // query lists
        RelSuiteContacts = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId ORDER BY PP_S__c DESC];
        List<Decision__c> decisions = new List<Decision__c>([SELECT Who__c FROM Decision__c WHERE Opportunity_Plan__c = :oppPlanId]);

        //list to be returned
        List<rsCustom> relsuitecon = new List<rsCustom>();

        for (Relationship_Suite__c rsc : RelSuiteContacts){
            //new rsCustom object
            rsCustom rscustom = new rsCustom();
            //initialize decision count variable
            Integer decision_count = 0;

            rscustom.id= rsc.Id;
            rscustom.Cr_Name = rsc.Contact__r.Name;
            rscustom.Cr_Title = rsc.Contact__r.Title;
            rscustom.parent_contact = rsc.Parent_Contact__c;
            if(rsc.PP_S__c ==0){
                rsc.PP_S__c=null;
            }
            rscustom.PPS = rsc.PP_S__c;
            rscustom.RMS = rsc.RM_S__c;
            rscustom.relationship_map = rsc.Relationship_map__c;

            for (Decision__c dc : decisions){

                if(dc.Who__c != null){

                    String contactRName = rsc.Contact__r.Name;
                    if (contactRName == null) contactRName = '';
                    if (dc.Who__c.indexOf(contactRName,0)>-1){

                        decision_count = decision_count +1;

                    }
                } 

            }
            rscustom.decision_count = decision_count;
            if(relshiplistmaxval != null){
                for(Relationship_Suite__c rs : relshiplistmaxval){
                    if(rs.id==rsc.Id)
                        rscustom.colorcode='Green';
                }
            }

            if(maxinmedlist != null){
                for(Relationship_Suite__c rsm : maxinmedlist){
                    if(rsm.id==rsc.Id)
                        rscustom.colorcode='Blue';
                }
            }
            //add object to custom list
            relsuitecon.add(rscustom);

        }

        return relsuitecon;
        }        
    set;
    }


    /********************************************************************************
    //Code for Sync Contact functionality-Added as part of Release 6 by Mousumi Panda
     **********************************************************************************/

    public PageReference addRemaingContacts() {
        Id RecordTypeId=null;
        List<Id> contactIds = new List<Id>();
        List<Relationship_Suite__c> relList = [Select id , Contact__c From Relationship_Suite__c Where Opportunity_Plan__c = :oppPlanId];
        for(Relationship_Suite__c rel : relList){
            contactIds.add(rel.Contact__c);
        }
        String soql = 'select contact.id,Contact.name,isPrimary,Role,OpportunityId from OpportunityContactRole';
        //String soql = 'select contact.id,Contact.name,isPrimary,Role,OpportunityId from OpportunityContactRole Where ContactId NOT IN :contactIds ';
        String whereCondition = '';
        whereCondition = whereCondition + ' OpportunityId = \''+ OptyId + '\' and ';
        whereCondition = whereCondition + ' ContactId NOT IN :' + 'contactIds' + ' and ' ;
        system.debug('-->searchText : ' + searchText ); 
        String tmpSearchText = searchText;
        if (tmpSearchText != null && tmpSearchText != '') {
            system.debug('-->before query : '); 
            tmpSearchText = tmpSearchText.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' Contact.Name LIKE \'' + tmpSearchText +'%\' and';
            system.debug('***whereCondition***'+whereCondition);
        }
        if(whereCondition!=null && whereCondition.length()>0 ){
            whereCondition = ' where'+whereCondition.substring(0,whereCondition.length()-4);
        }
        else{
            whereCondition = '';
        }
        soql = soql + whereCondition + 'limit  200';
        system.debug('***whereCondition***'+whereCondition);
        System.debug('query>>>'+soql);

        listContact2 = database.query(soql); 


        system.debug('-->listContact : ' + listContact2);


        try{
            If(listContact2.size() >0){

                List<Relationship_Suite__c> contactlistInsert = new List<Relationship_Suite__c>();
                for(OpportunityContactRole conrole : listContact2){
                    Relationship_Suite__c rs= new Relationship_Suite__c(); 
                    rs.Opportunity_Plan__c= OppPlanId;
                    rs.Contact__c=conrole.Contact.Id;
                    rs.PP_S__c=0;
                    contactlistInsert.add(rs); 
                    system.debug('******rs.Contact__c***'+rs.Contact__c);                       
                }

                if(!contactlistInsert.isEmpty())
                    insert contactlistInsert;
                maxmedRelationshipPPr();
            }   

            return null;

        }

        catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }

    }

}