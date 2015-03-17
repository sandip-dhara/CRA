trigger ODP_Trigger_TeamMemberAddConReview on Core_Team_Member__c (after insert , after update) {
    if(Trigger.isInsert )    {
        for(Core_Team_Member__c ctmcTemp : Trigger.new)
        {
            try        
            {    
                Release_Role__c rrc = [select Offering_Release__c,Role_ID__c,Role_Name__c from Release_Role__c where id =: ctmcTemp.Release_Role__c ];                        
                Role__c processRole = [select id,Role_Name__c, Name from Role__c where Role_Name__c =: rrc.Role_Name__c];
                if(ctmcTemp.Contributor__c == true){
                    List<Contributor__c> updateContributorList = new List<Contributor__c>();
                    List<Contributor__c> insertContributorList = new List<Contributor__c>();
                    List<Contributor__c> contributorList = [select id,Stage_Work_Element__c,Team_Members__c
                            from Contributor__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c =:rrc.Offering_Release__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                    for(Contributor__c contributor:contributorList)
                    {
                        if(contributor.Team_Members__c == null)
                        {
                            contributor.Team_Members__c = ctmcTemp.id;
                            updateContributorList.add(contributor);
                        }
                        else
                        {
                            Contributor__c newContributor = new Contributor__c(
                                Team_Members__c = ctmcTemp.id,
                                Stage_Work_Element__c = contributor.Stage_Work_Element__c,
                                Role__c = processRole.id
                            );
                            insertContributorList.add(newContributor);
                        }
                        
                    }
                    if(updateContributorList.size() > 0)
                    {
                        update updateContributorList;
                    }
                    if(insertContributorList.size() > 0)
                    {
                        insert insertContributorList;
                    }
                }
                
                if(ctmcTemp.Reviewer__c == true){
                    List<Review__c> updateReviewerList = new List<Review__c>();
                    List<Review__c> insertReviewerList = new List<Review__c>();
                    List<Review__c> reviewList = [select id,Stage_Work_Element__c,Team_Member__c
                            from Review__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c =:rrc.Offering_Release__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                    for(Review__c review:reviewList)
                    {
                        if(review.Team_Member__c == null)
                        {
                            review.Team_Member__c = ctmcTemp.id;
                            updateReviewerList.add(review);
                        }
                        else
                        {
                            Review__c newReview = new Review__c(
                                Team_Member__c = ctmcTemp.id,
                                Stage_Work_Element__c = review.Stage_Work_Element__c,
                                Role__c = processRole.id
                            );
                            insertReviewerList.add(newReview);
                        }
                    }
                    if(updateReviewerList.size() > 0)
                    {
                        update updateReviewerList;
                    }
                    if(insertReviewerList.size() > 0)
                    {
                        insert insertReviewerList;
                    }
                }
                
                /*for(Stage_Work_Element__c sweTemp : sweList )
                {      
                    if(ctmcTemp.Contributor__c == true){            
                        contributorList = [select id 
                            from Contributor__c where Stage_Work_Element__c =:sweTemp.id and Team_Members__r.User__c =: ctmcTemp.User__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                        if(contributorList.size() == 0)
                        {
                            List<Contributor__c> contributorValidateTMList = [select id 
                                from Contributor__c where Stage_Work_Element__c =:sweTemp.id and Team_Members__c = '' and Role_Name__c =: ctmcTemp.Role_Name__c];                        
                            if(contributorValidateTMList.size() > 0 ){
                                Contributor__c contributorTemp = new Contributor__c();
                                contributorTemp = contributorValidateTMList[0]; 
                                contributorTemp.Team_Members__c = ctmcTemp.id;                                 
                                update contributorTemp;                             
                            }
                            else{
                                List<Contributor__c> contributorValidateRoleList = [select id 
                                    from Contributor__c where Stage_Work_Element__c =:sweTemp.id  and Role_Name__c =: ctmcTemp.Role_Name__c]; 
                                if(contributorValidateRoleList.size() > 0){
                                    Contributor__c contributorTemp = new Contributor__c();
                                    contributorTemp.Team_Members__c = ctmcTemp.id; 
                                    contributorTemp.Stage_Work_Element__c = sweTemp.id; 
                                    contributorTemp.Role__c = rrc.Role_ID__c;
                                    //contributorTemp.Is_Active__c = ctmcTemp.Is_Active__c;
                                    insert  contributorTemp; 
                                }                            
                            }                                              
                        }                        
                    }
                    if(ctmcTemp.Reviewer__c == true){ 
                        reviewList = [select id 
                            from Review__c where Stage_Work_Element__c =:sweTemp.id and Team_Member__r.User__c =: ctmcTemp.User__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                        if(reviewList.size() == 0)
                        {
                            List<Review__c>  reviewTMList = [select id 
                                from Review__c where Stage_Work_Element__c =:sweTemp.id and Team_Member__c = '' and Role_Name__c =: ctmcTemp.Role_Name__c];
                            if(reviewTMList.size() > 0 ){
                                Review__c reviewTemp = new Review__c();
                                reviewTemp = reviewTMList[0]; 
                                reviewTemp.Team_Member__c = ctmcTemp.id; 
                                update reviewTemp;    
                            }                   
                            else{
                                List<Review__c>  reviewRoleList = [select id 
                                from Review__c where Stage_Work_Element__c =:sweTemp.id and Role_Name__c =: ctmcTemp.Role_Name__c];                         
                                if(reviewRoleList.size() > 0){
                                    Review__c reviewTemp = new Review__c();
                                    reviewTemp.Team_Member__c = ctmcTemp.id; 
                                    reviewTemp.Stage_Work_Element__c = sweTemp.id; 
                                    reviewTemp.Role__c = rrc.Role_ID__c;
                                    //reviewTemp.Is_Active__c = ctmcTemp.Is_Active__c;
                                    insert  reviewTemp;
                                }                            
                            }                                                                
                        }
                    }
                }*/          
            }
            catch(exception e)
            {                
                System.debug(e.getMessage());             
            }              
        }
    }
    else if(Trigger.isUpdate ){
        System.debug('why did into this brunch for add new team member');
        for(Core_Team_Member__c ctmcTemp : Trigger.new)
        {
            try        
            {
                
                /*Release_Role__c rrc = [select Offering_Release__c,Role_ID__c from Release_Role__c where id =: ctmcTemp.Release_Role__c ];                        
                List<Stage_Work_Element__c> sweList = [select id
                    from Stage_Work_Element__c where Release_Deliverable_ID__r.Offering_Release__c =: rrc.Offering_Release__c ];                                    
                List<Contributor__c> contributorList = new List<Contributor__c>();
                List<Review__c> reviewList = new List<Review__c>();
                for(Stage_Work_Element__c sweTemp : sweList )
                {
                    if(ctmcTemp.Contributor__c == true){            
                        contributorList = [select id 
                            from Contributor__c where Stage_Work_Element__c =:sweTemp.id and Team_Members__r.User__c =: ctmcTemp.User__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                        if(contributorList.size() == 0)
                        {
                            List<Contributor__c> contributorValidateTMList = [select id 
                                from Contributor__c where Stage_Work_Element__c =:sweTemp.id and Team_Members__c =: '' and Role_Name__c =: ctmcTemp.Role_Name__c];                        
                            if(contributorValidateTMList.size() > 0 ){
                                Contributor__c contributorTemp = new Contributor__c();
                                contributorTemp = contributorValidateTMList[0]; 
                                contributorTemp.Team_Members__c = ctmcTemp.id;                                 
                                update contributorTemp;                             
                            }
                            else{
                                List<Contributor__c> contributorValidateRoleList = [select id 
                                    from Contributor__c where Stage_Work_Element__c =:sweTemp.id  and Role_Name__c =: ctmcTemp.Role_Name__c]; 
                                if(contributorValidateRoleList.size() > 0){
                                    Contributor__c contributorTemp = new Contributor__c();
                                    contributorTemp.Team_Members__c = ctmcTemp.id; 
                                    contributorTemp.Stage_Work_Element__c = sweTemp.id; 
                                    contributorTemp.Role__c = rrc.Role_ID__c;
                                    //contributorTemp.Is_Active__c = ctmcTemp.Is_Active__c;
                                    insert  contributorTemp; 
                                }                            
                            }                                            
                        }                        
                    }
                    if(ctmcTemp.Reviewer__c == true){ 
                        reviewList = [select id 
                            from Review__c where Stage_Work_Element__c =:sweTemp.id and Team_Member__r.User__c =: ctmcTemp.User__c and Role_Name__c =: ctmcTemp.Role_Name__c];
                        if(reviewList.size() == 0)
                        {
                            List<Review__c>  reviewTMList = [select id 
                                from Review__c where Stage_Work_Element__c =:sweTemp.id and Team_Member__c =: '' and Role_Name__c =: ctmcTemp.Role_Name__c];
                            if(reviewTMList.size() > 0 ){
                                Review__c reviewTemp = new Review__c();
                                reviewTemp = reviewTMList[0]; 
                                reviewTemp.Team_Member__c = ctmcTemp.id; 
                                update reviewTemp;    
                            }
                            else{                         
                                List<Review__c>  reviewRoleList = [select id 
                                from Review__c where Stage_Work_Element__c =:sweTemp.id and Role_Name__c =: ctmcTemp.Role_Name__c];                         
                                if(reviewRoleList.size() > 0){
                                    Review__c reviewTemp = new Review__c();
                                    reviewTemp.Team_Member__c = ctmcTemp.id; 
                                    reviewTemp.Stage_Work_Element__c = sweTemp.id; 
                                    reviewTemp.Role__c = rrc.Role_ID__c;
                                    //reviewTemp.Is_Active__c = ctmcTemp.Is_Active__c;
                                    insert  reviewTemp;
                                }                                 
                            }                
                        }
                    }
                }*/          
            }
            catch(exception e)
            {                
                System.debug(e.getMessage());             
            }              
        }
    }        
}