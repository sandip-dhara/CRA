global class Scheduler_class implements Schedulable{

    public static String sched = '0 04 17 ? * MON-FRI';  
    global static String scheduleMe() {
        Scheduler_class SC = new Scheduler_class(); 
        return System.schedule('My batch Job', sched, SC);
    }

    global void execute(SchedulableContext sc) {
       OrgFileSpaceLimit.fileParseMethod();
    }
}