trigger SupportReqUpdateToQuote on HP_Quote__c (before Update) {
    if(Trigger.isUpdate){
            List<String> BMIDList=new List<String>();
            for(HP_Quote__c hq: Trigger.new){
                if(hq.BMI_ID__c != null && hq.BMI_ID__c!=''){
                    BMIDList.add(hq.BMI_ID__c);
                }
            }
            //supportReqList=[select id,Name from Support_Request__c where BMI_ID__c =:BMIDList];
            if(!BMIDList.isEmpty()){
                for(Support_Request__c supReqList:[select Id,Name,BMI_Quote_Id__r.Name,CreatedDate from Support_Request__c where BMI_Quote_Id__r.Name IN :BMIDList order by CreatedDate desc Limit 1])
                {
                    for(HP_Quote__c hQuote:trigger.new)
                    {
                        if(supReqList.BMI_Quote_Id__r.Name==hQuote.BMI_ID__c)
                        {
                            hQuote.Support_Request__c= supReqList.Id;
                            hQuote.Quote_Request_Sent_Submitted_DT__c= supReqList.CreatedDate;
                        }   
                    }
                }       
            }
            
    }
}