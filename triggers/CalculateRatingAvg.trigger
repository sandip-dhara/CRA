trigger CalculateRatingAvg on User_Rated_Item__c (after insert,after update){
    if(trigger.isinsert || trigger.isupdate){
        if(trigger.isafter){
            List<User_Rated_Item__c> UsrRtdItmLst = Trigger.new;
            system.debug('@#$%'+UsrRtdItmLst[0].Rated_Item_Id__c);
            integer count = 0;
            decimal sum = 0;
            if(UsrRtdItmLst.size()<=0){
                return;
            }        
            else{
                List<User_Rated_Item__c> URI = [SELECT Rated_Item_Id__c,Rating_Nbr__c,User_Id__c FROM User_Rated_Item__c where Rated_Item_Id__c =:UsrRtdItmLst[0].Rated_Item_Id__c];
                system.debug('%$#@'+URI);
                for(User_Rated_Item__c u : URI){
                    sum += u.rating_Nbr__c;
                    count ++; 
                }       
            }
            system.debug('*&^'+sum);
            system.debug('*&^'+count);
            decimal avg = sum/count;
            system.debug('*&^'+avg);
            
            Rated_Item__c RI = [SELECT Item_identifier__c,Item_Name__c,Rating_Average__c FROM Rated_Item__c where Id=:UsrRtdItmLst[0].Rated_Item_Id__c limit 1];
            RI.Rating_Average__c = avg;
            RI.Nbr_of_Users_Rated__c=count;
            update RI;
        }
    }
}