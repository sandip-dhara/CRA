global class ResetSuppressFieldsSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        ResetSuppressFieldsBatch b = new ResetSuppressFieldsBatch(); 
        database.executebatch(b);
    }
}