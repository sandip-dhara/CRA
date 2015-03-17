public class learnings {

   public learnings(ApexPages.StandardController controller) 
        {
            accountRecords = new List<Account>();

            accountRecords = [select id,Name,OwnerId,Owner.name from Account];
        }
        String recordId;
        public List<Account> accountRecords{get;set;}
}