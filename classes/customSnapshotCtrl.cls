public class customSnapshotCtrl{

    public customSnapshotData oppData{get;set;}
    public List<opplineitemwrapper> opplineitemwrapperlist{get;set;}
    public string opportunitycurrencycode{get;set;}
    public string corporatecurrencycode{get;set;}
    public string usercurrencycode{get;set;}
    public Map<String,Double> conversionRatemap;
    public List<customSnapshotData> opportunitydetailswrapper{get;set;}
    public string opportunityid;
    public boolean oppPlanExists {get;set;}
    public List<Opportunity_Plan__c> oppPlanList;
    public oppPlanData oppplan {get;set;}
    public list<decision> relatedDecisions{get;set;}
    //Public List<Relationship_Suite> RelSuiteContacts;
    public id oppplanid;
    public String relmap {get;set;}
    Public Integer RelSuiteC;
    Public List<AggregateResult> RelSuiteMa;
    Public List<AggregateResult> RelSuiteSMa;
    Public List<AggregateResult> RelSuiteMi;
    //Public List<Relationship_Suite> RelStyleV1;
    //Public List<Relationship_Suite> RelStyleV2;
    //Public List<Relationship_Suite> RelStyleV3;
    //Public List<Relationship_Suite> RelStyleV4;
    public List<String> RelStringSplit;
    
    
        public customSnapshotCtrl() {
            oppData = new customSnapshotData();
            oppplan = new oppplandata();
            relatedDecisions =  new list<decision>();

            this.opportunityid = ApexPages.currentPage().getParameters().get('id');
            system.debug('##quang: opportunityid = ' + opportunityid);
            list<opportunity> tempopplist = [
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
                Won_Lost_Date__c,X06_Stage_Amount__c,X06_Stage_Count__c, account.name, owner.name FROM Opportunity where id = :opportunityid LIMIT 1
            ];
            if (tempopplist.size()>0){
                oppData.oppid= tempopplist[0].id;
                oppData.type = tempopplist[0].type;
                oppData.name = tempopplist[0].name;
                oppData.closedate = tempopplist[0].closedate ;
                oppData.accountname = tempopplist[0].account.name ;
                oppData.stagename = tempopplist[0].stagename;
                oppData.oppowner= tempopplist[0].owner.name;
                oppData.ownerbg= tempopplist[0].Business_Group2__c;
                oppData.oppdescription= tempopplist[0].description;
                oppData.oppvalue= tempopplist[0].amount;
                oppData.currencyisocode= tempopplist[0].currencyisocode;
                oppdata.hpoppid = tempopplist[0].Opportunity_ID__c;
                
                }
                
            usercurrencycode=userinfo.getDefaultCurrency();
            opportunitydetailswrapper=new List<customSnapshotData>();
            
            if(opportunityid!=null){
                system.debug('##quang: '+opportunityid);
                Opportunity opportunityvalues=[select id,Opportunity_ID__c,CurrencyIsoCode,Name,Opportunity.Account.Name, StageName,Value__c from Opportunity where id=:opportunityid];
                Opportunity oppuservalue=[Select convertcurrency(Value__c) from Opportunity where id=:opportunityid];
                
                opportunitycurrencycode=opportunityvalues.CurrencyIsoCode;  
                oppData.opportunityname=opportunityvalues.Name;
                oppData.opportunityid=opportunityvalues.Opportunity_ID__c;
                oppData.accountname=opportunityvalues.Account.Name;
                oppData.totaloppvalue=opportunityvalues.Value__c;
                oppData.totaluseroppvalue=oppuservalue.Value__c;
                oppData.salesstage=opportunityvalues.StageName;
                opportunitydetailswrapper.add(oppData);
                }
            Aggregatemethod();
            
            oppPlanList = [SELECT Client_Name__c,Combined_Buying_Potential__c,CreatedById,CreatedDate,
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
            opportunity__r.currencyisocode, opportunity__r.amount, opportunity__r.type FROM opportunity_plan__c where opportunity__c = :opportunityid LIMIT 1 ];
        
        if (oppplanlist.size() > 0) {
            oppPlanExists = true;
            oppplan.Client_Name_c =  oppPlanList[0].Client_Name__c;
            oppplan.Combined_Buying_Potential_c =  oppPlanList[0].Combined_Buying_Potential__c;
            oppplan.CreatedById =  oppPlanList[0].CreatedById;
            oppplan.CreatedDate =  oppPlanList[0].CreatedDate;
            oppplan.CR_Last_Modified_By_c =  oppPlanList[0].CR_Last_Modified_By__c;
            oppplan.CR_last_modified_c =  oppPlanList[0].CR_last_modified__c;
            oppplan.CR_last_updated_by_c =  oppPlanList[0].CR_last_updated_by__c;
            oppplan.CurrencyIsoCode =  oppPlanList[0].CurrencyIsoCode;
            oppplan.Description_c =  oppPlanList[0].Description__c;
            oppplan.DG_Compelling_Event_c =  oppPlanList[0].DG_Compelling_Event__c;
            oppplan.DG_Money_c =  oppPlanList[0].DG_Money__c;
            oppplan.DG_People_c =  oppPlanList[0].DG_People__c;
            oppplan.dg_resources_c =  oppPlanList[0].dg_resources__c;
            oppplan.DG_Time_c =  oppPlanList[0].DG_Time__c;
            oppplan.DHC_2_Buyer_experience_with_HP_c =  oppPlanList[0].DHC_2_Buyer_experience_with_HP__c;
            oppplan.DHC_2_Client_Decision_Process_c =  oppPlanList[0].DHC_2_Client_Decision_Process__c;
            oppplan.DHC_2_Client_Relationship_and_Insight_c =  oppPlanList[0].DHC_2_Client_Relationship_and_Insight__c;
            oppplan.DHC_2_Competitive_Position_c =  oppPlanList[0].DHC_2_Competitive_Position__c;
            oppplan.DHC_2_Deal_Shape_and_Pricing_c =  oppPlanList[0].DHC_2_Deal_Shape_and_Pricing__c;
            oppplan.DHC_2_Delivery_Leadership_Team_c =  oppPlanList[0].DHC_2_Delivery_Leadership_Team__c;
            oppplan.DHC_2_Differentiation_c =  oppPlanList[0].DHC_2_Differentiation__c;
            oppplan.DHC_2_Sales_Team_Staffing_c =  oppPlanList[0].DHC_2_Sales_Team_Staffing__c;
            oppplan.DHC_2_Solution_Scope_c =  oppPlanList[0].DHC_2_Solution_Scope__c;
            oppplan.DHC_2_Teaming_c =  oppPlanList[0].DHC_2_Teaming__c;
            oppplan.DHC_2_Terms_and_Conditions_c =  oppPlanList[0].DHC_2_Terms_and_Conditions__c;
            oppplan.DHC_2_Will_the_client_buy_c =  oppPlanList[0].DHC_2_Will_the_client_buy__c;
            oppplan.DHC_Color_Buyer_Experience_c =  oppPlanList[0].DHC_Color_Buyer_Experience__c;
            oppplan.DHC_Color_Client_Decision_Process_c =  oppPlanList[0].DHC_Color_Client_Decision_Process__c;
            oppplan.DHC_Color_Client_Relationship_c =  oppPlanList[0].DHC_Color_Client_Relationship__c;
            oppplan.DHC_Color_Competitive_Position_c =  oppPlanList[0].DHC_Color_Competitive_Position__c;
            oppplan.DHC_Color_Delivery_Leadership_Team_c =  oppPlanList[0].DHC_Color_Delivery_Leadership_Team__c;
            oppplan.DHC_Color_Differentiation_c =  oppPlanList[0].DHC_Color_Differentiation__c;
            oppplan.DHC_Color_Shape_and_Pricing_c =  oppPlanList[0].DHC_Color_Shape_and_Pricing__c;
            oppplan.DHC_Color_Solution_Scope_c =  oppPlanList[0].DHC_Color_Solution_Scope__c;
            oppplan.DHC_Color_Teaming_c =  oppPlanList[0].DHC_Color_Teaming__c;
            oppplan.DHC_Color_Team_Staffing_c =  oppPlanList[0].DHC_Color_Team_Staffing__c;
            oppplan.DHC_Color_Terms_and_Conditions_c =  oppPlanList[0].DHC_Color_Terms_and_Conditions__c;
            oppplan.DHC_Color_WTB_c =  oppPlanList[0].DHC_Color_WTB__c;
            oppplan.DHC_Comments_Buyer_Experience_c =  oppPlanList[0].DHC_Comments_Buyer_Experience__c;
            oppplan.DHC_Comments_Client_Decision_Process_c =  oppPlanList[0].DHC_Comments_Client_Decision_Process__c;
            oppplan.DHC_Comments_Client_Relationship_c =  oppPlanList[0].DHC_Comments_Client_Relationship__c;
            oppplan.DHC_Comments_Competitive_Position_c =  oppPlanList[0].DHC_Comments_Competitive_Position__c;
            oppplan.DHC_Comments_Deal_Shape_and_Pricing_c =  oppPlanList[0].DHC_Comments_Deal_Shape_and_Pricing__c;
            oppplan.DHC_Comments_Delivery_Leadership_Team_c =  oppPlanList[0].DHC_Comments_Delivery_Leadership_Team__c;
            oppplan.DHC_Comments_Differentiation_c =  oppPlanList[0].DHC_Comments_Differentiation__c;
            oppplan.DHC_Comments_Sales_Team_Staffing_c =  oppPlanList[0].DHC_Comments_Sales_Team_Staffing__c;
            oppplan.DHC_Comments_Solution_Scope_c =  oppPlanList[0].DHC_Comments_Solution_Scope__c;
            oppplan.DHC_Comments_Teaming_c =  oppPlanList[0].DHC_Comments_Teaming__c;
            oppplan.DHC_Comments_Terms_and_Conditions_c =  oppPlanList[0].DHC_Comments_Terms_and_Conditions__c;
            oppplan.DHC_Comments_WTB_c =  oppPlanList[0].DHC_Comments_WTB__c;
            oppplan.DHC_last_modified_c =  oppPlanList[0].DHC_last_modified__c;
            oppplan.DHC_Last_Updated_Lagacy_No_c =  oppPlanList[0].DHC_Last_Updated_Lagacy_No__c;
            oppplan.DHC_last_updated_c =  oppPlanList[0].DHC_last_updated__c;
            oppplan.DHC_Sales_Stage_Warning_c =  oppPlanList[0].DHC_Sales_Stage_Warning__c;
            oppplan.Down_Select_c =  oppPlanList[0].Down_Select__c;
            oppplan.Economic_Value_c =  oppPlanList[0].Economic_Value__c;
            oppplan.How_will_the_Exec_Sponsor_Support_You_c =  oppPlanList[0].How_will_the_Exec_Sponsor_Support_You__c;
            oppplan.Id =  oppPlanList[0].Id;
            oppplan.IsDeleted =  oppPlanList[0].IsDeleted;
            oppplan.LastActivityDate =  oppPlanList[0].LastActivityDate;
            oppplan.LastModifiedById =  oppPlanList[0].LastModifiedById;
            oppplan.LastModifiedDate =  oppPlanList[0].LastModifiedDate;
            oppplan.Name =  oppPlanList[0].Name;
            oppplan.OG_CBP_Number_c =  oppPlanList[0].OG_CBP_Number__c;
            oppplan.OG_CBP_S_c =  oppPlanList[0].OG_CBP_S__c;
            oppplan.OG_Date_c =  oppPlanList[0].OG_Date__c;
            oppplan.OG_Last_Modified_By_c =  oppPlanList[0].OG_Last_Modified_By__c;
            oppplan.OG_Last_Modified_Date_c =  oppPlanList[0].OG_Last_Modified_Date__c;
            oppplan.OG_WTBO_Q1_c =  oppPlanList[0].OG_WTBO_Q1__c;
            oppplan.OG_WTBO_Q2_c =  oppPlanList[0].OG_WTBO_Q2__c;
            oppplan.OG_WTBO_Q3_c =  oppPlanList[0].OG_WTBO_Q3__c;
            oppplan.OG_WTBO_Q4_c =  oppPlanList[0].OG_WTBO_Q4__c;
            oppplan.OG_WTB_Q1_c =  oppPlanList[0].OG_WTB_Q1__c;
            oppplan.OG_WTB_Q2_c =  oppPlanList[0].OG_WTB_Q2__c;
            oppplan.OG_WTB_Q3_c =  oppPlanList[0].OG_WTB_Q3__c;
            oppplan.OG_WTB_Q4_c =  oppPlanList[0].OG_WTB_Q4__c;
            oppplan.OG_WTB_Q5_c =  oppPlanList[0].OG_WTB_Q5__c;
            oppplan.Opportunity_ID_c =  oppPlanList[0].Opportunity_ID__c;
            oppplan.Opportunity_Name_c =  oppPlanList[0].Opportunity_Name__c;
            oppplan.Opportunity_c =  oppPlanList[0].Opportunity__c;
            oppplan.Opp_Close_Date_c =  oppPlanList[0].Opp_Close_Date__c;
            oppplan.Opp_Sales_Stage_c =  oppPlanList[0].Opp_Sales_Stage__c;
            oppplan.OP_Last_Modified_c =  oppPlanList[0].OP_Last_Modified__c;
            oppplan.Owner_c =  oppPlanList[0].Owner__c;
            oppplan.Price2Win_c =  oppPlanList[0].Price2Win__c;
            oppplan.Proposal_Due_Date_c =  oppPlanList[0].Proposal_Due_Date__c;
            oppplan.Reasons_For_Not_Closing_c =  oppPlanList[0].Reasons_For_Not_Closing__c;
            oppplan.Record_Open_Date_c =  oppPlanList[0].Record_Open_Date__c;
            oppplan.RFI_Date_c =  oppPlanList[0].RFI_Date__c;
            oppplan.RFP_Date_c =  oppPlanList[0].RFP_Date__c;
            oppplan.Sales_Stage_c =  oppPlanList[0].Sales_Stage__c;
            oppplan.SystemModstamp =  oppPlanList[0].SystemModstamp;
            oppplan.Total_Opportunity_Value_c =  oppPlanList[0].Total_Opportunity_Value__c;
            oppplan.Turn_Days_c =  oppPlanList[0].Turn_Days__c;
            oppplan.User_BG_c =  oppPlanList[0].User_BG__c;
            oppplan.VP_01_clients_most_important_problems_c =  oppPlanList[0].VP_01_clients_most_important_problems__c;
            oppplan.VP_02_how_do_they_show_up_c =  oppPlanList[0].VP_02_how_do_they_show_up__c;
            oppplan.VP_03_effects_of_issues_c =  oppPlanList[0].VP_03_effects_of_issues__c;
            oppplan.VP_04_who_is_affected_c =  oppPlanList[0].VP_04_who_is_affected__c;
            oppplan.VP_05_constraints_c =  oppPlanList[0].VP_05_constraints__c;
            oppplan.VP_06_alternatives_c =  oppPlanList[0].VP_06_alternatives__c;
            oppplan.VP_07_what_are_we_offering_c =  oppPlanList[0].VP_07_what_are_we_offering__c;
            oppplan.VP_08_what_will_it_take_c =  oppPlanList[0].VP_08_what_will_it_take__c;
            oppplan.VP_09_criteria_c =  oppPlanList[0].VP_09_criteria__c;
            oppplan.VP_Last_Modified_Date_c =  oppPlanList[0].VP_Last_Modified_Date__c;
            oppplan.VP_last_modified_c =  oppPlanList[0].VP_last_modified__c;
            oppplan.VP_last_updated_by_c =  oppPlanList[0].VP_last_updated_by__c;
            oppplan.VP_value_proposition_c =  oppPlanList[0].VP_value_proposition__c;
            oppplan.What_will_we_do_different_in_next_Closin_c =  oppPlanList[0].What_will_we_do_different_in_next_Closin__c;
            oppplan.WTBO_Advantage_c =  oppPlanList[0].WTBO_Advantage__c;
            oppplan.WTBO_CBP_c =  oppPlanList[0].WTBO_CBP__c;
            oppplan.WTBO_Total_c =  oppPlanList[0].WTBO_Total__c;
            oppplan.WTB_Agree_c =  oppPlanList[0].WTB_Agree__c;
            oppplan.WTB_CBP_c =  oppPlanList[0].WTB_CBP__c;
            oppplan.WTB_Total_c =  oppPlanList[0].WTB_Total__c;
            oppplan.opportunity_r_name =  oppPlanList[0].opportunity__r.name;
            oppplan.opportunity_r_account_name =  oppPlanList[0].opportunity__r.account.name;
            oppplan.opportunity_r_owner_c =  oppPlanList[0].opportunity__r.owner__c;
            oppplan.opportunity_r_business_group2_c =  oppPlanList[0].opportunity__r.business_group2__c;
            oppplan.opportunity_r_description =  oppPlanList[0].opportunity__r.description;
            oppplan.opportunity_r_currencyisocode =  oppPlanList[0].opportunity__r.currencyisocode;
            oppplan.opportunity_r_amount =  oppPlanList[0].opportunity__r.amount;
            oppplan.opportunity_r_type =  oppPlanList[0].opportunity__r.type;
            oppplanid = oppPlanList[0].id;
            
            for (Decision__c dec : [SELECT Criteria__c,Decision__c,Id,Step__c,When__c,Who__c, contact_id__c, Status__c, Opportunity_Plan__c  FROM Decision__c where Opportunity_Plan__c = :oppPlanList[0].id ORDER BY When__c asc] ){
                decision decisionitem = new decision();
                decisionitem.Criteria_c = dec.Criteria__c;
                decisionitem.Decision_c= dec.Decision__c;
                decisionitem.id = dec.Id;
                decisionitem.Step_c= dec.Step__c;
                decisionitem.When_c= dec.When__c;
                decisionitem.Who_c= dec.Who__c;
                decisionitem.contact_id_c= dec.contact_id__c;
                decisionitem.Status_c= dec.Status__c;
                decisionitem.Opportunity_Plan_c= dec.Opportunity_Plan__c;
                relatedDecisions.add(decisionitem);
                
            }
            


            }
    
        }
        
   
    
    Public void Aggregatemethod(){
    
        List<currencytype> currencytypelist=[SELECT conversionrate,IsoCode,IsCorporate FROM currencytype];
        conversionRatemap=new Map<String,Double>();
        for(currencytype currencytypevalue: currencytypelist){   
        if(currencytypevalue.IsCorporate){
        corporatecurrencycode=currencytypevalue.IsoCode;
        }
        conversionRatemap.put(currencytypevalue.IsoCode,currencytypevalue.conversionrate);
        }
        
        
        List<AggregateResult> aggregatelist= [SELECT PricebookEntry.Product2.Business_Group__c bg,PricebookEntry.Product2.GBU__c gbu, 
        sum(subtotal) Total FROM OpportunityLineItem WHERE  
        (OpportunityId =:opportunityid AND GBU__c!=null AND Business_Group__c!=null) 
        group by rollup (OpportunityId , PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c) 
        order by PricebookEntry.Product2.Business_Group__c ,PricebookEntry.Product2.GBU__c ];
        
        opplineitemwrapperlist=new List<opplineitemwrapper>();
        for(AggregateResult aggregateresultvalue: aggregatelist){
        
        if(aggregateresultvalue.get('gbu')==null && aggregateresultvalue.get('bg')!=null){
        
        opplineitemwrapper wrapper =new opplineitemwrapper();
        
        wrapper.businessgroup=String.valueof(aggregateresultvalue.get('bg'));
        
        if(corporatecurrencycode==opportunitycurrencycode){
        wrapper.totalcurrency=Double.valueof(aggregateresultvalue.get('Total'));
        wrapper.totalusercurrency=Double.valueof(aggregateresultvalue.get('Total'))*(conversionRatemap.get(usercurrencycode));
        }else if((usercurrencycode!=opportunitycurrencycode)&&(usercurrencycode!=corporatecurrencycode)){
        //wrapper1.opportunitycurrency=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));
        Double usercurrencyvalue=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')))*(conversionRatemap.get(usercurrencycode));
        //wrapper1.usercurrency=(usercurrencyvalue*(conversionRatemap.get(usercurrencycode)))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper.totalusercurrency=usercurrencyvalue/(conversionRatemap.get(opportunitycurrencycode));
        }
        
        else if(usercurrencycode!=opportunitycurrencycode){
        //wrapper.totalcurrency=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode)); 
        wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));                        
        Double usercurrencyvalue=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
        //wrapper.totalusercurrency=(usercurrencyvalue*(conversionRatemap.get(usercurrencycode)))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper.totalusercurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')))/(conversionRatemap.get(opportunitycurrencycode));
        
        }
        else if(usercurrencycode==opportunitycurrencycode){
        wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));                       
        wrapper.totalusercurrency=wrapper.totalcurrency;
        }
        wrapper.globalbunit=' ';
        wrapper.oppcurrencyisocodebg=opportunitycurrencycode;
        wrapper.usercurrencycodebg='('+usercurrencycode;   
        wrapper.bgconcatenator=')';                  
        opplineitemwrapperlist.add(wrapper);
        system.debug('&&opplineitemwrapperlist'+opplineitemwrapperlist);
        }
        
        if(aggregateresultvalue.get('gbu')!=null && aggregateresultvalue.get('bg')!=null){
        
        opplineitemwrapper wrapper1 =new opplineitemwrapper();
        wrapper1.businessgroup=' ';
        wrapper1.totalcurrency=null;
        
        if(corporatecurrencycode==opportunitycurrencycode){
        wrapper1.opportunitycurrency=Double.valueof(aggregateresultvalue.get('Total'));
        wrapper1.usercurrency=Double.valueof(aggregateresultvalue.get('Total'))*(conversionRatemap.get(usercurrencycode));
        }else if((usercurrencycode!=opportunitycurrencycode)&&(usercurrencycode!=corporatecurrencycode)){
        //wrapper1.opportunitycurrency=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
        Double usercurrencyvalue=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')))*(conversionRatemap.get(usercurrencycode));
        //wrapper1.usercurrency=(usercurrencyvalue*(conversionRatemap.get(usercurrencycode)))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper1.usercurrency=usercurrencyvalue/(conversionRatemap.get(opportunitycurrencycode));
        }
        
        else if(usercurrencycode!=opportunitycurrencycode){
        //wrapper1.opportunitycurrency=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
        Double usercurrencyvalue=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
        //wrapper1.usercurrency=(usercurrencyvalue*(conversionRatemap.get(usercurrencycode)))/(conversionRatemap.get(opportunitycurrencycode));
        wrapper1.usercurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')))/(conversionRatemap.get(opportunitycurrencycode));
        }
        
        
        else if(usercurrencycode==opportunitycurrencycode){
        wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
        wrapper1.usercurrency=wrapper1.opportunitycurrency;
        }
        wrapper1.globalbunit=String.valueof(aggregateresultvalue.get('gbu'));
        wrapper1.oppucurrencyisocodegbu=opportunitycurrencycode;
        wrapper1.usercurrencycodegbu='('+usercurrencycode;
        wrapper1.gbuconcatenator=')';
        opplineitemwrapperlist.add(wrapper1);
        }
        
        }
    }
    
    public Double Usergbucurrecy(String gbuvalue){
     Double usercurrency=0;
     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.GBU__c = :gbuvalue];

           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrency=usercurrency+(opplineitem.subtotal);           
           }     
     return usercurrency;
     
     }
     
     public Double Userbgcurrecy(String businessgroup){
     Double usercurrency=0;     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.Business_Group__c = :businessgroup];
           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrency=usercurrency+(opplineitem.subtotal);           
           }     
     return usercurrency;
     
     }
     
     
         
         public Integer RelSuiteMax {get
            {
            if (oppPlanExists == true){
                RelSuiteMa = [select MAX(PP_S__c) max from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId];
                
                return integer.valueOF(RelSuiteMa[0].get('max'));
                }
                else return null;
            }        
            set;
         }
         
         public Integer RelSuiteSMax {get
            {
            if (oppPlanExists == true){
            
                RelSuiteSMa = [select MAX(PP_S__c) max from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId and PP_S__c <> :RelSuiteMax];
                
                return integer.valueOF(RelSuiteSMa[0].get('max'));
                }
                else return null;
            }        
            set;
         }
         public Integer RelSuiteMin {get
            {
            if (oppPlanExists == true){
                RelSuiteMi = [select MIN(PP_S__c) min from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId];
                
                return integer.valueOf(RelSuiteMi[0].get('min'));
                }
                else return null;
            }        
            set;
         }
         
          
        
        //custom rel suite table class
         public class rsCustom {
            public String Cr_Name {get;set;}
            public String Cr_Title{get;set;}
            public String parent_contact{get;set;}
            public Double PPS{get;set;}
            public Double RMS{get;set;}
            public String relationship_map{get;set;}
            public Id id{get;set;}
            public Integer decision_count {get;set;}
            
        }
        
        public List<rsCustom> RelSuite2 {get
            {
            if (oppPlanExists == true){
            // query lists
            List<relationship_suite__c> RelSuiteContacts2 = [select Id,Contact__r.Name,Contact__r.Title,Contact__r.id,Parent_Contact__c,RM_S__c,PP_S__c,Relationship_map__c from Relationship_Suite__c where Opportunity_Plan__c = :OppPlanId ORDER BY PP_S__c DESC];
            List<Decision__c> decisions = new List<Decision__c>([SELECT Who__c FROM Decision__c WHERE Opportunity_Plan__c = :oppPlanId]);
            
            //list to be returned
            List<rsCustom> relsuitecon = new List<rsCustom>();
            
            for (Relationship_Suite__c rsc : RelSuiteContacts2){
                //new rsCustom object
                rsCustom rscustom = new rsCustom();
                //initialize decision count variable
                Integer decision_count = 0;
                
                rscustom.id= rsc.Id;
                rscustom.Cr_Name = rsc.Contact__r.Name;
                rscustom.Cr_Title = rsc.Contact__r.Title;
                rscustom.parent_contact = rsc.Parent_Contact__c;
                rscustom.PPS = rsc.PP_S__c;
                rscustom.RMS = rsc.RM_S__c;
                rscustom.relationship_map = rsc.Relationship_map__c;
                
                for (Decision__c dc : decisions){
                
                   if(dc.Who__c != null){
                   //if(dc.Who__c != null || dc.Who__c != ''){
                   String contactRName = rsc.Contact__r.Name;
                   if (contactRName == null) contactRName = '';
                    if (dc.Who__c.indexOf(contactRName,0)>-1){
                    //if (dc.Who__c.indexOf(rsc.Contact__r.Name,0)>-1){
                        decision_count = decision_count +1;
                        
                    }
                   } 
                    
                }
                
                rscustom.decision_count = decision_count;
                
                //add object to custom list
                relsuitecon.add(rscustom);
                
            }
            
            return relsuitecon;
            }
            else {
                    return null;
                }
            }        
            set;
         }
         
          public List<cspSummary> getCSPSummaries(){
            if (oppPlanExists == true){
            List<cspSummary> resultlist = new List<cspSummary>();
            
            for (competitive_sales_plan__c csp : [SELECT Id,Opportunity_Plan__c,competitor__c,frontal__c,flank__c,fractional__c,stall__c,disengage__c,stop__c,slow__c,silence__c,shame__c,
                (SELECT Activity_Created_On__c,CreatedById,CreatedDate,csp__c,CurrencyIsoCode,Id,
                    IsDeleted,LastModifiedById,LastModifiedDate,Name,
                    strength_customer_validated__c,strength_leveraged__c,strength_text__c,
                    SystemModstamp,tactic_owner__r.name,tactic_text__c,tactic_timing__c,
                    their_weakness_customer_validated__c,their_weakness_exploited__c,
                    their_weakness_text__c from CSP_Offensive_Strategies__r),
                (SELECT Activity_Created_On__c,CreatedById,CreatedDate,csp__c,
                    ct_countertactic__c,ct_owner__r.name,ct_timing__c,CurrencyIsoCode,Id,
                    IsDeleted,LastModifiedById,LastModifiedDate,Name,our_weakness_countered__c,
                    our_weakness_customer_validated__c,our_weakness_text__c,SystemModstamp,
                    their_strength_countered__c,their_strength_customer_validated__c,
                    their_strength_text__c from CSP_defensive_Strategies__r)
            FROM Competitive_Sales_Plan__c where opportunity_plan__c = :oppPlanId]){
                
                cspSummary cspitem = new cspSummary();
                cspitem.compname = csp.competitor__c;
                
                if (csp.frontal__c) cspitem.offensivestrat = 'Frontal';
                    else if (csp.flank__c) cspitem.offensivestrat = 'Flank';
                    else if (csp.fractional__c) cspitem.offensivestrat = 'Fractional';
                    else if (csp.stall__c) cspitem.offensivestrat = 'Stall';
                    else if (csp.disengage__c) cspitem.offensivestrat = 'Disengage';
                    else cspitem.offensivestrat = 'none';
                    
                if (csp.stop__c) cspitem.defensivestrat = 'Stop';
                    else if (csp.slow__c) cspitem.defensivestrat = 'Slow';
                    else if (csp.silence__c) cspitem.defensivestrat = 'Silence';
                    else if (csp.shame__c) cspitem.defensivestrat = 'Shame';
                     else cspitem.defensivestrat = 'none';
                    
                
                for (integer i=0; i<csp.csp_offensive_strategies__r.size();i++){
                    if (csp.CSP_Offensive_Strategies__r[i].strength_text__c != null)
                    cspitem.hpstrength += csp.CSP_Offensive_Strategies__r[i].strength_text__c + ' (Customer Validated: ' + csp.CSP_Offensive_Strategies__r[i].strength_customer_validated__c + ', Leveraged: '+csp.CSP_Offensive_Strategies__r[i].strength_leveraged__c +'); ';
                    
                    if (csp.CSP_Offensive_Strategies__r[i].tactic_owner__c != null){
                        if(csp.csp_offensive_strategies__r[i].tactic_timing__c != null)
                            cspitem.tactics += csp.csp_offensive_strategies__r[i].tactic_owner__r.name + ': ' + csp.csp_offensive_strategies__r[i].tactic_text__c+ ' - '+csp.csp_offensive_strategies__r[i].tactic_timing__c.format() +'; ';
                        else
                        cspitem.tactics += csp.csp_offensive_strategies__r[i].tactic_owner__r.name + ': ' + csp.csp_offensive_strategies__r[i].tactic_text__c +'; ';
                    }
                    
                    if (csp.CSP_Offensive_Strategies__r[i].their_weakness_text__c != null)
                    cspitem.compweakness += csp.csp_offensive_strategies__r[i].their_weakness_text__c + ' (Customer Validated: '+csp.csp_offensive_strategies__r[i].their_weakness_customer_validated__c+', Exploited: '+csp.csp_offensive_strategies__r[i].their_weakness_exploited__c+'); ';
                    
                
                }
                for (integer i=0; i<csp.csp_defensive_strategies__r.size();i++){
                    
                    if (csp.csp_defensive_strategies__r[i].our_weakness_text__c != null)
                    cspitem.hpweakness += csp.csp_defensive_strategies__r[i].our_weakness_text__c + ' (Customer Validated: ' + ifConvert(csp.csp_defensive_strategies__r[i].our_weakness_customer_validated__c) + ', Countered: '+ifConvert(csp.csp_defensive_strategies__r[i].our_weakness_countered__c)+'); ';
                    
                    if (csp.csp_defensive_strategies__r[i].their_strength_text__c != null)
                    cspitem.compstrength +=  csp.csp_defensive_strategies__r[i].their_strength_text__c + ' (Customer Validated: '+ifConvert(csp.csp_defensive_strategies__r[i].their_strength_customer_validated__c)+ ', Countered: '+ifConvert(csp.csp_defensive_strategies__r[i].their_strength_countered__c)+'); ';
                
                    if (csp.csp_defensive_strategies__r[i].ct_countertactic__c != null){
                        if(csp.csp_defensive_strategies__r[i].ct_timing__c!=null)
                        cspitem.countertactics += csp.csp_defensive_strategies__r[i].ct_owner__r.name + ': '+ csp.csp_defensive_strategies__r[i].ct_countertactic__c + ' - ' + csp.csp_defensive_strategies__r[i].ct_timing__c.format() + '; ';
                        else
                        cspitem.countertactics += csp.csp_defensive_strategies__r[i].ct_owner__r.name + ': '+ csp.csp_defensive_strategies__r[i].ct_countertactic__c + '; ';
                   } 
                }
                
                resultlist.add(cspitem);
                
            }
            
            return resultlist;
            }
            else {
                return null;
                }
    }

    public String ifConvert(boolean a){
        if (a == true) {return 'Yes';}
        else {return 'No';}
    }
    
    Public String getExecutiveSponsor()
        {
        List<OpportunityTeamMember> listOptyTeamMember = new List<OpportunityTeamMember>();
        listOptyTeamMember = [select User.Name from OpportunityTeamMember where Opportunityid = :OpportunityId and TeamMemberRole = 'Executive Sponsor'];
        string sExecutiveSponsorName = '';
        
        for (OpportunityTeamMember OTM: listOptyTeamMember)
            {
            sExecutiveSponsorName = sExecutiveSponsorName + OTM.User.Name + ', ';            
            }
        sExecutiveSponsorName = sExecutiveSponsorName.Left(sExecutiveSponsorName.length()-2);
        return sExecutiveSponsorName;
        }
    
     public class ParticipatingCountries{
      public String Region{get;set;}
      public String Country{get;set;}
      public Decimal EstOpportunityValue{get;set;}      
    }

    public List<ParticipatingCountries> getCountryList(){
       
       List<ParticipatingCountries> listcountries = new List<ParticipatingCountries>();
       List<MN_Opportunities_Information__c> participatingCountryList = [select Region__c,Country__c,Est_Opportunity_Value__c from MN_Opportunities_Information__c where Multinational_OppMultinational_Oortunity__c=:opportunityid];
       
       for(MN_Opportunities_Information__c pc : participatingCountryList){
        ParticipatingCountries listcountry = new ParticipatingCountries();
        listcountry.Region = pc.Region__c;
        listcountry.Country = pc.Country__c;
        listcountry.EstOpportunityValue = pc.Est_Opportunity_Value__c;  
       listcountries.add(listcountry);          
       } 
       
       return listcountries;
    }
    
    public List<opplineitem> getProductList(){
        list<opplineitem> opppl = new list<opplineitem>();
         for(opportunitylineitem oli : [SELECT Business_Group__c,GBU__c,HasSchedule,OpportunityId,
         Product_Line__c,Quantity,Quote_Number__c,RTS__c,ServiceDate,Subtotal,UnitPrice,
         Sub_Product_Line__c  FROM OpportunityLineItem WHERE OpportunityId = :opportunityid]){
             
             opplineitem oppplItem = new opplineitem();
             oppplItem.Business_Group_c = oli.Business_Group__c ;
             oppplItem.GBU_c = oli.GBU__c ;
             oppplItem.HasSchedule = oli.HasSchedule ;
             oppplItem.OpportunityId = oli.OpportunityId ;
             oppplItem.Product_Line_c = oli.Product_Line__c ;
             oppplItem.Quantity = oli.Quantity ;
             oppplItem.Quote_Number_c = oli.Quote_Number__c ;
             oppplItem.RTS_c = oli.RTS__c ;
             oppplItem.ServiceDate = oli.ServiceDate ;
             oppplItem.Subtotal = oli.Subtotal ;
             oppplItem.UnitPrice = oli.UnitPrice ;
             oppplItem.Sub_Product_Line_c = oli.Sub_Product_Line__c ;
             opppl.add(oppplItem);
         
         }
         
         return opppl ;
     }
        
    public class customSnapshotData{
        public string oppid{get;set;}
        public string type{get;set;}
        public string name{get;set;}
        public datetime closedate{get;set;}
        public string accountname{get;set;}
        public string stagename{get;set;}
        public string oppowner{get;set;}
        public string ownerbg{get;set;}
        public string oppdescription{get;set;}
        public decimal oppvalue{get;set;}
        public string CurrencyIsoCode{get;set;}
        public Double totaloppvalue{get;set;}
        public Double totaluseroppvalue{get;set;}
        public string opportunityid{get;set;}        
        public string opportunityname{get;set;}
        public string salesstage{get;set;}
        public string hpoppid{get;set;}
        
    }
    
    public class opplineitemwrapper{
        public string businessgroup{get;set;}
        public string globalbunit{get;set;}
        public Double totalcurrency{get;set;} 
        public Double totalusercurrency{get;set;} 
        public Double opportunitycurrency{get;set;} 
        public Double usercurrency{get;set;}
        public string usercurrencycodegbu{get;set;}
        public string usercurrencycodebg{get;set;}
        public string oppcurrencyisocodebg{get;set;}
        public string oppucurrencyisocodegbu{get;set;}
        public string bgconcatenator{get;set;}
        public string gbuconcatenator{get;set;}
       
    }
    
    public class oppPlanData{
        public string Client_Name_c {get;set;}
        public string Combined_Buying_Potential_c {get;set;}
        public string CreatedById {get;set;}
        public datetime CreatedDate {get;set;}
        public string CR_Last_Modified_By_c {get;set;}
        public datetime CR_last_modified_c {get;set;}
        public string CR_last_updated_by_c {get;set;}
        public string CurrencyIsoCode {get;set;}
        public string Description_c {get;set;}
        public string DG_Compelling_Event_c {get;set;}
        public string DG_Money_c {get;set;}
        public string DG_People_c {get;set;}
        public string dg_resources_c {get;set;}
        public string DG_Time_c {get;set;}
        public string DHC_2_Buyer_experience_with_HP_c {get;set;}
        public string DHC_2_Client_Decision_Process_c {get;set;}
        public string DHC_2_Client_Relationship_and_Insight_c {get;set;}
        public string DHC_2_Competitive_Position_c {get;set;}
        public string DHC_2_Deal_Shape_and_Pricing_c {get;set;}
        public string DHC_2_Delivery_Leadership_Team_c {get;set;}
        public string DHC_2_Differentiation_c {get;set;}
        public string DHC_2_Sales_Team_Staffing_c {get;set;}
        public string DHC_2_Solution_Scope_c {get;set;}
        public string DHC_2_Teaming_c {get;set;}
        public string DHC_2_Terms_and_Conditions_c {get;set;}
        public string DHC_2_Will_the_client_buy_c {get;set;}
        public string DHC_Color_Buyer_Experience_c {get;set;}
        public string DHC_Color_Client_Decision_Process_c {get;set;}
        public string DHC_Color_Client_Relationship_c {get;set;}
        public string DHC_Color_Competitive_Position_c {get;set;}
        public string DHC_Color_Delivery_Leadership_Team_c {get;set;}
        public string DHC_Color_Differentiation_c {get;set;}
        public string DHC_Color_Shape_and_Pricing_c {get;set;}
        public string DHC_Color_Solution_Scope_c {get;set;}
        public string DHC_Color_Teaming_c {get;set;}
        public string DHC_Color_Team_Staffing_c {get;set;}
        public string DHC_Color_Terms_and_Conditions_c {get;set;}
        public string DHC_Color_WTB_c {get;set;}
        public string DHC_Comments_Buyer_Experience_c {get;set;}
        public string DHC_Comments_Client_Decision_Process_c {get;set;}
        public string DHC_Comments_Client_Relationship_c {get;set;}
        public string DHC_Comments_Competitive_Position_c {get;set;}
        public string DHC_Comments_Deal_Shape_and_Pricing_c {get;set;}
        public string DHC_Comments_Delivery_Leadership_Team_c {get;set;}
        public string DHC_Comments_Differentiation_c {get;set;}
        public string DHC_Comments_Sales_Team_Staffing_c {get;set;}
        public string DHC_Comments_Solution_Scope_c {get;set;}
        public string DHC_Comments_Teaming_c {get;set;}
        public string DHC_Comments_Terms_and_Conditions_c {get;set;}
        public string DHC_Comments_WTB_c {get;set;}
        public datetime DHC_last_modified_c {get;set;}
        public string DHC_Last_Updated_Lagacy_No_c {get;set;}
        public string DHC_last_updated_c {get;set;}
        public string DHC_Sales_Stage_Warning_c {get;set;}
        public date Down_Select_c {get;set;}
        public decimal Economic_Value_c {get;set;}
        public string How_will_the_Exec_Sponsor_Support_You_c {get;set;}
        public string Id {get;set;}
        public boolean IsDeleted {get;set;}
        public date LastActivityDate {get;set;}
        public string LastModifiedById {get;set;}
        public datetime LastModifiedDate {get;set;}
        public string Name {get;set;}
        public decimal OG_CBP_Number_c {get;set;}
        public string OG_CBP_S_c {get;set;}
        public date OG_Date_c {get;set;}
        public string OG_Last_Modified_By_c {get;set;}
        public datetime OG_Last_Modified_Date_c {get;set;}
        public string OG_WTBO_Q1_c {get;set;}
        public string OG_WTBO_Q2_c {get;set;}
        public string OG_WTBO_Q3_c {get;set;}
        public string OG_WTBO_Q4_c {get;set;}
        public string OG_WTB_Q1_c {get;set;}
        public string OG_WTB_Q2_c {get;set;}
        public string OG_WTB_Q3_c {get;set;}
        public string OG_WTB_Q4_c {get;set;}
        public string OG_WTB_Q5_c {get;set;}
        public string Opportunity_ID_c {get;set;}
        public string Opportunity_Name_c {get;set;}
        public string Opportunity_c {get;set;}
        public date Opp_Close_Date_c {get;set;}
        public string Opp_Sales_Stage_c {get;set;}
        public string OP_Last_Modified_c {get;set;}
        public string Owner_c {get;set;}
        public decimal Price2Win_c {get;set;}
        public date Proposal_Due_Date_c {get;set;}
        public string Reasons_For_Not_Closing_c {get;set;}
        public date Record_Open_Date_c {get;set;}
        public date RFI_Date_c {get;set;}
        public date RFP_Date_c {get;set;}
        public string Sales_Stage_c {get;set;}
        public datetime SystemModstamp {get;set;}
        public decimal Total_Opportunity_Value_c {get;set;}
        public decimal Turn_Days_c {get;set;}
        public string User_BG_c {get;set;}
        public string VP_01_clients_most_important_problems_c {get;set;}
        public string VP_02_how_do_they_show_up_c {get;set;}
        public string VP_03_effects_of_issues_c {get;set;}
        public string VP_04_who_is_affected_c {get;set;}
        public string VP_05_constraints_c {get;set;}
        public string VP_06_alternatives_c {get;set;}
        public string VP_07_what_are_we_offering_c {get;set;}
        public string VP_08_what_will_it_take_c {get;set;}
        public string VP_09_criteria_c {get;set;}
        public datetime VP_Last_Modified_Date_c {get;set;}
        public date VP_last_modified_c {get;set;}
        public string VP_last_updated_by_c {get;set;}
        public string VP_value_proposition_c {get;set;}
        public string What_will_we_do_different_in_next_Closin_c {get;set;}
        public string WTBO_Advantage_c {get;set;}
        public string WTBO_CBP_c {get;set;}
        public decimal WTBO_Total_c {get;set;}
        public string WTB_Agree_c {get;set;}
        public string WTB_CBP_c {get;set;}
        public decimal WTB_Total_c {get;set;}
        public string opportunity_r_name {get;set;}
        public string opportunity_r_account_name {get;set;}
        public string opportunity_r_owner_c {get;set;}
        public string opportunity_r_business_group2_c {get;set;}
        public string opportunity_r_description {get;set;}
        public string opportunity_r_currencyisocode {get;set;}
        public decimal opportunity_r_amount {get;set;}
        public string opportunity_r_type {get;set;}

    
    }
    
    public class decision{
        public string Criteria_c{get;set;}
        public string Decision_c{get;set;}
        public string Id{get;set;}
        public string Step_c{get;set;}
        public date When_c{get;set;}
        public string Who_c{get;set;}
        public string contact_id_c{get;set;}
        public string Status_c{get;set;}
        public string opportunity_plan_c{get;set;}
    }
    
    public class cspSummary{
        public String compname{get;set;}
        public String hpstrength{get;set;}
        public String compstrength{get;set;}
        public String compweakness{get;set;}
        public String hpweakness{get;set;}
        public String tactics{get;set;}
        public String countertactics{get;set;}
        public String offensivestrat {get;set;}
        public String defensivestrat {get;set;}
        
        public cspSummary(){
            this.hpstrength = '';
            this.compname= '';
            this.compstrength= '';
            this.compweakness= '';
            this.hpweakness= '';
            this.tactics= '';
            this.countertactics= '';
            this.offensivestrat = '';
            this.defensivestrat = '';
            }
    
    }
    
    public class opplineitem{
    
        public string Business_Group_c{get;set;}
        public string GBU_c{get;set;}
        public boolean HasSchedule{get;set;}
        public string OpportunityId{get;set;}
        public string Product_Line_c{get;set;}
        public decimal Quantity{get;set;}
        public string Quote_Number_c{get;set;}
        public boolean RTS_c{get;set;}
        public date ServiceDate{get;set;}
        public decimal Subtotal{get;set;}
        public decimal UnitPrice{get;set;}
        public string Sub_Product_Line_c{get;set;}
    }
    
    /*public class relationship_suite{
        public string Contact_c {get;set;}
        public string Detractor_c {get;set;}
        public string Neutral_c {get;set;}
        public string Opportunity_Plan_c {get;set;}
        public string Partner_Ally_c {get;set;}
        public string Political_Advisory_c {get;set;}
        public string PP_Result_c {get;set;}
        public decimal PP_S_c {get;set;}
        public string PP_S1_c {get;set;}
        public string PP_S10_c {get;set;}
        public string PP_S11_c {get;set;}
        public string PP_S12_c {get;set;}
        public string PP_S2_c {get;set;}
        public string PP_S3_c {get;set;}
        public string PP_S4_c {get;set;}
        public string PP_S5_c {get;set;}
        public string PP_S6_c {get;set;}
        public string PP_S7_c {get;set;}
        public string PP_S8_c {get;set;}
        public string PP_S9_c {get;set;}
        public string Relationship_map_c {get;set;}
        public string relationship_map_string_c {get;set;}
        public decimal RM_S_c {get;set;}
        public string Parent_Contact_c {get;set;}
        public string Reports_To_Person_Not_in_List_c {get;set;}
        public string RM_S1_c {get;set;}
        public string RM_S10_c {get;set;}
        public string RM_S2_c {get;set;}
        public string RM_S3_c {get;set;}
        public string RM_S4_c {get;set;}
        public string RM_S5_c {get;set;}
        public string RM_S6_c {get;set;}
        public string RM_S7_c {get;set;}
        public string RM_S8_c {get;set;}
        public string RM_S9_c {get;set;}
        public string PowerMatrix_c {get;set;}
        public string Supporter_c {get;set;}
        public string Total_c {get;set;}
        public string id {get;set;}
        public string contact_r_name{get;set;}
        public string Contact_r_Title{get;set;}
        public string Contact_r_id{get;set;}

    }*/
    
}