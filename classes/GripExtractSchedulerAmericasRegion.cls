/**********************************************************************************
Name:  GripExtractSchedulerAmericasRegion
Copyright © 2012  HP
===================================================================================
===================================================================================
Purpose:
-------
Scheduled Class to Extract Opportunity Activites and send mail as an Attacahment
for Americas Region
===================================================================================
===================================================================================
History
-------
VERSION      AUTHOR                DATE             DETAIL              
1.0 -       Pradeep Kumar L.G          23/10/2012      INITIAL DEVELOPMENT
**********************************************************************************/
global class GripExtractSchedulerAmericasRegion implements Schedulable { 
public List<Task> tasklist;
public static Boolean isTestrun=false;
    global void execute(SchedulableContext sc) {
        try{

                 GripExtractadapterController adapter=new GripExtractadapterController();
                 
                 if(!isTestrun){
                     adapter.Extractopptyacivities(null,'Americas');
                 }
                 else{
                         adapter.Extractopptyacivities(tasklist,'Americas');
                 }            
        }catch(Exception e){
        
        }
    }
}