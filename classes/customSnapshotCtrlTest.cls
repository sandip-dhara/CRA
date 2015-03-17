@istest(SeeAllData=true)
private class customSnapshotCtrlTest {


static testMethod void myTest() {
        
            list<opportunity> testOppList = new list<opportunity>( [
                    SELECT AccountId,Account_Billing_Country__c,
                    account_blacklist__c,Account_Private_Opportunity__c,Account_Region__c,
                    Account_Shipping_City__c,Account_Shipping_Country__c,Account_Shipping_PostalCode__c,
                    Account_Shipping_State__c,Account_Shipping_Street__c,Action_1__c,Action_2__c,
                    Activity_Plan__c,Alliance_Channel_Partner_Count__c,Alliance_Partners_Count__c,Amount,
                    Assigned_to_partner_date__c,BigMachines__Line_Items__c,Business_Group2__c,CampaignId,
                    Case_Safe_ID__c,CloseDate,Close_Date_Delta__c,Close_Date_Push_Counter__c,
                    Competitors_Added__c,Confidential__c,Converted_by_Partner__c,Converted_From_Lead__c,
                    CountOfOppLineItem__c,CountOfQuoteSyncOppLineItem__c,Country__c,CreatedById,
                    CreatedDate,CurrencyIsoCode,Current_Stage_days__c,Current_User_BG__c,
                    Customer_Budget_Amount__c,Customer_Engagement__c,Days_Since_Partner_Last_Modified__c,
                    Deal_Action_Plan_Type__c,Deal_Checklist__c,Deal_Expiration_Date__c,Deal_Id__c,
                    Deal_Registration_Status__c,Deal_Submission_Date__c,Description,DynamicUrl__c,
                    Error_Stage_Amount__c,Estimated_Multi_Country_Value__c,Finance_Type__c,Fiscal,
                    FiscalQuarter,FiscalYear,ForecastCategory,ForecastCategoryName,Fulfillment__c,
                    GRM_ID__c,HasOpportunityLineItem,HasProductLineSum__c,HasQuoteSyncProductLineSum__c,
                    HasQuoteSyncSubProductLineSum__c,HasSubProductLineSum__c,Has_Campaign__c,
                    has_Multi_BG_Products__c,HPFS_Needed__c,HP_Financing_Indicator_Code__c,
                    HP_Not_Pursued_Stage_Amount__c,HP_Not_Pursued_Stage_Count__c,HP_Solution__c,
                    Id,Incumbent_Competitor__c,IsClosed,IsDeleted,IsOwnerAssigned__c,isResubmitted__c,
                    IsWon,Is_Opportunity__c,LastActivityDate,LastModifiedById,LastModifiedDate,
                    Last_Modified_by_Partner__c,Last_Modified_Full_Name__c,Last_Stage_Change_Date__c,
                    LeadSource,Lead_Created_Date__c,Lease_Type__c,Legacy_ref_Id__c,List_Code__c,
                    List_Id__c,List_Name__c,Lost_Or_HP_Not_Pursed_Not_123_Amount__c,
                    Lost_Or_HP_Not_Pursed_Not_123_Count__c,Lost_Stage_Amount__c,Lost_Stage_Count__c,
                    Managed_By__c,Min_Book_Ship_Date__c,MultiGBU__c,Multi_Country_Type__c,Name,
                    NextStep,Non_standard_Opportunity__c,Non_standard_t_c_s__c,No_Alliance_Partner__c,
                    OpportunityGroup__c,Opportunity_Detail__c,Opportunity_ID__c,
                    Opportunity_Outside_Owner_s_Terr__c,Opportunity_Sales_Stage__c,
                    Opportunity_Total_Amount__c,Opportunity_Update__c,OwnerId,Owner_s_Global_Business_Unit__c,
                    Owner__c,ParticipatingRegionAMS__c,ParticipatingRegionAPJ__c,
                    ParticipatingRegionEMEA__c,Partner_acknowledged__c,Placeholder_Status_1__c,
                    Premier_Type__c,Previous_Sales_Stage__c,Pricebook2Id,Primary_Campaign_Name__c,
                    Primary_Competitor__c,Primary_Partner__c,Prior_Sales_Stage__c,
                    Probability,Product_Last_Modified__c,Qualification_Team_ID__c,
                    Qualification_Team_Name__c,Quote_Status_Update_Notification__c,
                    Quote_Sync_Count__c,RecordTypeId,Record_Type_Name__c,Related_Opportunity__c,
                    Renewal_Sub_Type__c,Renewal_Type__c,Route_To_Market__c,Sales_Stage2__c,
                    SAP_Feed__c,SendEmailNotification__c,Source_System_Lead_ID__c,StageName,
                    Stage_1_2_Values__c,Strategic_Initiative__c,Submitted_Date__c,Sub_Type__c,
                    SW_ELA__c,SW_Premier__c,SW_Push_To__c,SW_RTS__c,SW_Uplift__c,SW_Upsell__c,
                    SW_Win_Back__c,SystemModstamp,Tactic_Code__c,Tactic_ID__c,Tactic_Name__c,
                    Term_Credit_Line3__c,Term_Credit_Line__c,Term_Credit_Request_Status__c,
                    Total_Contract_Length_In_Months__c,Total_First_12_Month_Value__c,
                    Total_First_Fiscal_Yr_Value__c,Total_Margin_Amount__c,Total_Margin_Percentage__c,
                    TS_Multinational__c,TS_Multi_BG__c,TS_PROP__c,Type,Value__c,Velocity__c,
                    Win_Loss_Reason__c,Within_Rolling_6_Months__c,Within_Rolling_12_Months__c,
                    Won_Lost_Date__c,X06_Stage_Amount__c,X06_Stage_Count__c, account.name, owner.name FROM Opportunity LIMIT 1
                ]);
            
            if (testOppList.size()>0){
                
                list<opportunity_plan__c> testOppPlanList = new list<opportunity_plan__c>(
            [SELECT Client_Name__c,Combined_Buying_Potential__c,CreatedById,CreatedDate,
            CR_Last_Modified_By__c,CR_last_modified__c,CR_last_updated_by__c,CurrencyIsoCode,
            Description__c,DG_Compelling_Event__c,DG_Money__c,DG_People__c,dg_resources__c,
            DG_Time__c,DHC_2_Buyer_experience_with_HP__c,DHC_2_Client_Decision_Process__c,
            DHC_2_Client_Relationship_and_Insight__c,DHC_2_Competitive_Position__c,
            DHC_2_Deal_Shape_and_Pricing__c,DHC_2_Delivery_Leadership_Team__c,DHC_2_Differentiation__c,
            DHC_2_Sales_Team_Staffing__c,DHC_2_Solution_Scope__c,DHC_2_Teaming__c,
            DHC_2_Terms_and_Conditions__c,DHC_2_Will_the_client_buy__c,DHC_Color_Buyer_Experience__c,
            DHC_Color_Client_Decision_Process__c,DHC_Color_Client_Relationship__c,
            DHC_Color_Competitive_Position__c,DHC_Color_Delivery_Leadership_Team__c,
            DHC_Color_Differentiation__c,DHC_Color_Shape_and_Pricing__c,DHC_Color_Solution_Scope__c,
            DHC_Color_Teaming__c,DHC_Color_Team_Staffing__c,DHC_Color_Terms_and_Conditions__c,
            DHC_Color_WTB__c,DHC_Comments_Buyer_Experience__c,DHC_Comments_Client_Decision_Process__c,
            DHC_Comments_Client_Relationship__c,DHC_Comments_Competitive_Position__c,
            DHC_Comments_Deal_Shape_and_Pricing__c,DHC_Comments_Delivery_Leadership_Team__c,
            DHC_Comments_Differentiation__c,DHC_Comments_Sales_Team_Staffing__c,
            DHC_Comments_Solution_Scope__c,DHC_Comments_Teaming__c,DHC_Comments_Terms_and_Conditions__c,
            DHC_Comments_WTB__c,DHC_last_modified__c,DHC_Last_Updated_Lagacy_No__c,DHC_last_updated__c,
            DHC_Sales_Stage_Warning__c,Down_Select__c,Economic_Value__c,How_will_the_Exec_Sponsor_Support_You__c,
            Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,Name,OG_CBP_Number__c,
            OG_CBP_S__c,OG_Date__c,OG_Last_Modified_By__c,OG_Last_Modified_Date__c,
            OG_WTBO_Q1__c,OG_WTBO_Q2__c,OG_WTBO_Q3__c,OG_WTBO_Q4__c,OG_WTB_Q1__c,OG_WTB_Q2__c,
            OG_WTB_Q3__c,OG_WTB_Q4__c,OG_WTB_Q5__c,Opportunity_ID__c,Opportunity_Name__c,Opportunity__c,
            Opp_Close_Date__c,Opp_Sales_Stage__c,OP_Last_Modified__c,Owner__c,Price2Win__c,
            Proposal_Due_Date__c,Reasons_For_Not_Closing__c,Record_Open_Date__c,RFI_Date__c,
            RFP_Date__c,Sales_Stage__c,SystemModstamp,Total_Opportunity_Value__c,Turn_Days__c,
            User_BG__c,VP_01_clients_most_important_problems__c,VP_02_how_do_they_show_up__c,
            VP_03_effects_of_issues__c,VP_04_who_is_affected__c,VP_05_constraints__c,
            VP_06_alternatives__c,VP_07_what_are_we_offering__c,VP_08_what_will_it_take__c,
            VP_09_criteria__c,VP_Last_Modified_Date__c,VP_last_modified__c,VP_last_updated_by__c,
            VP_value_proposition__c,What_will_we_do_different_in_next_Closin__c,WTBO_Advantage__c,
            WTBO_CBP__c,WTBO_Total__c,WTB_Agree__c,WTB_CBP__c,WTB_Total__c, 
            opportunity__r.name, opportunity__r.account.name, opportunity__r.owner__c, 
            opportunity__r.business_group2__c, opportunity__r.description, 
            opportunity__r.currencyisocode, opportunity__r.amount, opportunity__r.type FROM opportunity_plan__c where opportunity__c = :testOppList[0].id LIMIT 1 ]);
            
                if (testOppPlanList.size()<1){
                    opportunity_plan__c testoppplan = new opportunity_plan__c();
                    testoppplan.opportunity__c = testOppList[0].id;
                    insert testoppplan;
                    testOppPlanList.add(testoppplan);
                }
            
            }
        
        
        PageReference pageRef = new pagereference('/apex/dg_snapshot');
        Test.setCurrentPage(pageRef);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', testOppList[0].id);
        customSnapshotCtrl controller = new customSnapshotCtrl();
        controller = new customSnapshotCtrl();
        controller.opportunityid = testOppList[0].id;
        system.assert(true,controller.opportunityid!=null);

        //String nextPage = controller.save().getUrl();

        // Verify that page fails without parameters
        //System.assertEquals('/apex/failure?error=noParam', nextPage);

        
      
        // Instantiate a new controller with all parameters in the page
        

        

        // Verify that the success page displays
        //System.assertEquals('/apex/success', nextPage);
        //Lead[] leads = [select id, email from lead where Company = 'acme'];
        //System.assertEquals('firstlast@acme.com', leads[0].email);
        
        
     }






}