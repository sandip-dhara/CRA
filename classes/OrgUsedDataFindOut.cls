global class OrgUsedDataFindOut implements Schedulable{
   global void execute(SchedulableContext sc) {
       OrgFileSpaceLimit.fileParseMethod();     
   }
}