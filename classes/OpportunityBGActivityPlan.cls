public class OpportunityBGActivityPlan{

    
    /* @description : create the activities based on the opportunity slaes stage values
     when opportunity updated */
    public static boolean checkduplicates(Activity_Plan_Item__c act, List<Task> ts)
    {
        Activity_Plan_Item__c acplan = act;
        boolean tsflag = True;
        for(Task actcreated : ts)
        {
            if(acplan.Activity_Subject__c==actcreated.Subject)
                tsflag = False;
        }
        return tsflag;
    }
    

    public static void CreateActivityForOptyUpdation(List<opportunity> optyNewList, Integer type){
        if(type==0){
            List<Activity_Plan_Item__c> Actplanlist=new List<Activity_Plan_Item__c>();
            List<Activity_Plan_Item__c> ActplanlistES=new List<Activity_Plan_Item__c>();              
            List<Activity_Plan_Item__c> Actplanlist2=new List<Activity_Plan_Item__c>();
            List<OpportunityLineItem> oplineitemslist= new List<OpportunityLineItem>();
            List<Activity_Plan__c> Acttemplatelist=new List<Activity_Plan__c>();
            List<Activity_Plan_Item__c> taskcreation = new List<Activity_Plan_Item__c>();
            Set<String> setGBU= new Set<String>();
            List<String> regionlist = new List<String>();
            Map<String, Activity_Plan_Item__c> taskmap = new Map<String, Activity_Plan_Item__c>();
            string optyParam;
            string PrivateType;
            List<Task> tasklist =new List<Task>();
            List<Task> tasklist1 =new List<Task>();
            List<string> BgList = new List<string>();
            set<string> Bgset = new set<string>(); 
            String BGLabel;
             String strBG;
            
    
            system.debug('OptyName in Class'+optyNewList);
            for(opportunity op : optyNewList){
                system.debug('optynew'+optyNewList);
    
                system.debug('####Stage from Trigger####'+op.StageName);
                user userinfo=[select Business_Group__c from user where id=:op.ownerid];
    
                Account Actinfo=[select WorldRegion_Region__c, Confidential_Account__c, ShippingCountry from Account where Id=:op.AccountId];
                
                    privateType=Actinfo.ShippingCountry;
    
                system.debug('Private Type###'+privateType);
                oplineitemslist=[select GBU__c, Business_Group__c from opportunitylineitem where opportunityid= :op.Id];
                for(OpportunityLineItem opline : oplineitemslist)
                {
                    if(opline.Business_Group__c=='ES')
                    {
                    system.debug(' product line item gbu values' +opline.GBU__c);
                    setGBU.add(opline.GBU__c);
                    system.debug('GBUValues'+oplineitemslist[0].GBU__c);
                    }
                }
                system.debug('Regions '+Actinfo.WorldRegion_Region__c);
                //system.debug('GBUValues'+oplineitemslist[0].GBU__c);
    
                // list of Activity Templates
                if(Actinfo.Confidential_Account__c==True && Actinfo.ShippingCountry=='United States'){
                    system.debug('*****regionlist*****'+regionlist);
                    system.debug('*****setGBU*****'+setGBU);
                    system.debug('*****op.amount*****'+op.amount);
                    system.debug('*****op.amount*****'+op.amount);
                    system.debug('*****privateType*****'+privateType);
                    Acttemplatelist=[select Id from Activity_Plan__c where 
                                 TOV_Range_From__c < :op.amount
                                 and TOV_Range_To__c >= :op.amount
                                 and private_type__c=:Actinfo.ShippingCountry]; 

                }
                else{
                    if(setGBU.size() > 1 && setGBU.contains('Application Services'))
                    {
                      Acttemplatelist=[select Id from Activity_Plan__c where 
                                 Region__c = :Actinfo.WorldRegion_Region__c and GBU__c in :setGBU
                                 and TOV_Range_From__c < :op.amount and TOV_Range_To__c >= :op.amount
                                 and (GBU__c != 'Application Services' Or Param01__c='Add-on')
                                 ];       
                                 
                    }
                    else
                    {
                    system.debug('*****regionlist*****'+regionlist);
                    system.debug('*****setGBU*****'+setGBU);
                    system.debug('*****op.amount*****'+op.amount);
                    system.debug('*****op.amount*****'+op.amount);
                    system.debug('*****privateType*****'+privateType);
                    Acttemplatelist=[select Id from Activity_Plan__c where 
                                 Region__c = :Actinfo.WorldRegion_Region__c and GBU__c in :setGBU
                                 and TOV_Range_From__c < :op.amount and TOV_Range_To__c >= :op.amount
                                 and Param01__c!='Add-on'
                                 ];
                     }

                }
                system.debug('#####BG##'+userinfo.Business_Group__c);
                system.debug('#####BG Label##'+Label.BG_Label);
                BGLabel = Label.BG_Label;
                BgList = BGLabel.Split(',');
                for(string bgstring : BgList)
                {
                Bgset.add(bgstring);
                }
               
                if(Bgset.contains(userinfo.Business_Group__c))
                {
                Acttemplatelist=[select Id from Activity_Plan__c where 
                                    Business_Group__c=:userinfo.Business_Group__c and 
                                 (Region__c = :Actinfo.WorldRegion_Region__c or Region__c=null)
                                 and ((TOV_Range_From__c < :op.amount and TOV_Range_To__c >= :op.amount) or ((TOV_Range_From__c=null) and (TOV_Range_To__c=null)))
                                 ];
                }
                
                
                //system.debug('#####ACtivity Template#####'+Acttemplatelist[0]);
    
                if(userinfo.Business_Group__c =='TS')
                {
                    optyParam = op.Deal_Action_Plan_Type__c;
                    actplanlist=[select id, Activity_Subject__c, name, type__C from Activity_Plan_Item__c
                                 where Sales_Stage__c=:op.StageName and
                                 Activity_Plan__r.Business_Group__c=:userinfo.Business_Group__c
                                 and Activity_Plan__r.Automated__c = true 
                                 and Activity_Plan__r.Param01__c = :optyParam
                                 ];
                }
                
    
                if(userinfo.Business_Group__c =='ES' || Bgset.contains(userinfo.Business_Group__c))
                {
                    ActplanlistES = [select id, Activity_Subject__c, name, type__C from Activity_Plan_Item__c
                                     where Sales_Stage__c=:op.StageName and Activity_Plan__r.Id IN :Acttemplatelist
                                     and Activity_Plan__r.Business_Group__c=:userinfo.Business_Group__c
                                     and Activity_Plan__r.Automated__c = true ];
                }
                system.debug('#####number of Activities from the Template'+ActplanlistES.size());
    
    
                System.debug('Automatic Activity Creation'+op.StageName);
    
    
    
                if(actPlanlist.size()>0){
                    List<Task> createdTask = [select Subject from Task where Whatid = :op.id ];
                    boolean taskflag = True;
                    if(createdTask.size()>0)
                    {
                        for(Activity_Plan_Item__c ac : actplanlist)
                        {
                            if(checkduplicates(ac, createdTask))
                                taskcreation.add(ac);        
                        }
    
                    }
    
                    else
                    {
                        taskcreation = actPlanlist;
                    } 
                    for (Activity_Plan_Item__c ac : taskcreation){
    
    
                        Task Act=new Task();
                        act.Subject=ac.Activity_Subject__c;
                        act.Whatid=op.id;
                        act.type=ac.type__c;
                        act.sales_stage__c=op.StageName;
                        //act.who=ac.name;
                        tasklist.add(act);
                    }
                }
    
    
                if(actplanlistES.size()>0){
                    system.debug('Size of Activty template list##'+actplanlistES.size());
                    for(Activity_Plan_Item__c ac : actplanlistES)
                    {
                        taskmap.put(ac.Activity_Subject__c,ac);
                    }
                    system.debug('Map size from Templates##'+taskmap.size());
    
                    List<Task> createdTask = [select Subject from Task where Whatid = :op.id ];
                    boolean taskflag = True;
                    if(createdTask.size()>0)
                    {
                        for(Task ts : createdTask)
                        {
                            if(taskmap.containsKey(ts.Subject))
                            {
                                taskmap.remove(ts.Subject);
                                system.debug('Inside For loop of removing existing dups##');
                            }
                        }
                        system.debug('Map size after removing existing from Templates##'+taskmap.size());             
                    }
    
    
                    for (Activity_Plan_Item__c ac : taskmap.values()){
    
                        Task Act1=new Task();
                        act1.Subject=ac.Activity_Subject__c;
                        act1.Whatid=op.id;
                        act1.type=ac.type__c;
                        act1.sales_stage__c=op.StageName;
                        //act.who=ac.name;
                        tasklist1.add(act1);
                    }
    
                }
    
                try{
                    system.debug(' in the try black  activities list ='+ tasklist.size());
                    insert tasklist;
                    insert tasklist1;
                    System.debug('Task List01-'+Tasklist[0].Id);
                    System.debug('Task List01-'+Tasklist1[0].Id);
                }catch(Exception e){
    
                    system.debug('Error- Not Created Activities');
                }
    
            }
    }
    
    else if(type==1){
        List<Activity_Plan__c> activityPlanList = [Select id, Record_Type__c, Renewal_Type__c, Renewal_Sub_Type__c From Activity_Plan__c Where Record_Type__c = 'Renewal'];
        List<Activity_Plan_Item__c> activityPlanItemList = [Select id, Days__c, From__c, Sales_Stage__c, Activity_Subject__c, Comments__c, Activity_Plan__c From Activity_Plan_Item__c Where Activity_Plan__c IN :activityPlanList];
        Map<Id,Set<Activity_Plan_Item__c>> activityPlanIdactivityPlanItem = new Map<Id,Set<Activity_Plan_Item__c>>();
        List<Task> taskList = [Select id, Subject, WhatId From Task Where WhatId IN :optyNewList];
        //Map<Id,List<Task>> activityPlanIdTask = new Map<Id,List<Task>>();
        
        for(Activity_Plan__c ap : activityPlanList){
            Set<Activity_Plan_Item__c> activityPlanItemSet = new Set<Activity_Plan_Item__c>();
            for(Activity_Plan_Item__c apI : activityPlanItemList){
                if(apI.Activity_Plan__c == ap.Id)
                    activityPlanItemSet.add(apI);
            }
            activityPlanIdactivityPlanItem.put(ap.Id,activityPlanItemSet);
        }
        
        Set<Activity_Plan_Item__c> activityPlanItemSet = new Set<Activity_Plan_Item__c>();
        List<Task> TasktoInsert = new List<Task>();
        
        for(Opportunity opp: optyNewList){
            Activity_Plan__c activityPlan = new Activity_Plan__c();
            if(opp.SW_ELA__c && (opp.Renewal_Type__c == 'SW Renewal')){
                for(Activity_Plan__c ap : activityPlanList){
                    if((ap.Renewal_Type__c == opp.Renewal_Type__c) && (ap.Renewal_Sub_Type__c == 'ELA')){
                        for(Activity_Plan_Item__c apI : activityPlanIdactivityPlanItem.get(ap.Id)){
                            if(apI.Sales_Stage__c == opp.StageName){
                                activityPlanItemSet.add(apI);
                            }
                        }
                    }
                }
            }
            if(opp.SW_Push_To__c && (opp.Renewal_Type__c == 'SW Renewal')){
                for(Activity_Plan__c ap : activityPlanList){
                    if((ap.Renewal_Type__c == opp.Renewal_Type__c) && (ap.Renewal_Sub_Type__c == 'Push To')){
                        for(Activity_Plan_Item__c apI : activityPlanIdactivityPlanItem.get(ap.Id)){
                            if(apI.Sales_Stage__c == opp.StageName){
                                activityPlanItemSet.add(apI);
                            }
                        }
                    }
                }
            }
            if(opp.TS_PROP__c && (opp.Renewal_Type__c == 'TS Renewal') && (opp.Renewal_Sub_Type__c == 'Complex')){
                for(Activity_Plan__c ap : activityPlanList){
                    if((ap.Renewal_Type__c == opp.Renewal_Type__c) && (ap.Renewal_Sub_Type__c == 'PROP')){
                        for(Activity_Plan_Item__c apI : activityPlanIdactivityPlanItem.get(ap.Id)){
                            if(apI.Sales_Stage__c == opp.StageName){
                                activityPlanItemSet.add(apI);
                            }
                        }
                    }
                }
            }
            if(opp.TS_Multinational__c && (opp.Renewal_Type__c == 'TS Renewal') && (opp.Renewal_Sub_Type__c == 'Complex')){
                System.debug('???????Multinational');
                for(Activity_Plan__c ap : activityPlanList){
                    if((ap.Renewal_Type__c == opp.Renewal_Type__c) && (ap.Renewal_Sub_Type__c == 'Multinational')){
                        System.debug('???????Multinational2');
                        for(Activity_Plan_Item__c apI : activityPlanIdactivityPlanItem.get(ap.Id)){
                            if(apI.Sales_Stage__c == opp.StageName){
                                activityPlanItemSet.add(apI);
                            }
                        }
                    }
                }
            }
            if(opp.TS_Multi_BG__c && (opp.Renewal_Type__c == 'TS Renewal') && (opp.Renewal_Sub_Type__c == 'Complex')){
                for(Activity_Plan__c ap : activityPlanList){
                    if((ap.Renewal_Type__c == opp.Renewal_Type__c) && (ap.Renewal_Sub_Type__c == 'Multi BG')){
                        for(Activity_Plan_Item__c apI : activityPlanIdactivityPlanItem.get(ap.Id)){
                            if(apI.Sales_Stage__c == opp.StageName){
                                activityPlanItemSet.add(apI);
                            }
                        }
                    }
                }
            }
            
            List<Task> taskList2 = new List<Task>();
            for(Task t : taskList){
                if(t.WhatId == opp.Id)
                    taskList2.add(t);
                
            }
            
            List<Activity_Plan_Item__c> activityPlanItemtoInsert = new List<Activity_Plan_Item__c>(); 
            for(Activity_Plan_Item__c apI : activityPlanItemSet){
                if(checkduplicates(apI, taskList2))
                        activityPlanItemtoInsert.add(apI);
            }
            for(Activity_Plan_Item__c apI : activityPlanItemtoInsert){
                Task t = new Task();
                t.Subject = apI.Activity_Subject__c;
                t.Description = apI.Comments__c;
                Date duedate;
                Integer days = (Integer)apI.Days__c;
                if(apI.From__c == 'Date of Creation')
                    duedate = Date.Today().addDays(-days);
                    else if(apI.From__c == 'Expiration Date')
                        duedate = opp.CloseDate.addDays(-days);
                        
                System.debug('??????DueDate'+duedate);
                t.ActivityDate = duedate;
                t.Status = 'Not Started';
                t.Priority = 'Normal';
                t.OwnerId = opp.OwnerId;
                t.WhatId = opp.Id;
                taskToInsert.add(t);
            }
        } 
        
        insert tasktoInsert;
    
    }
        
    }

}