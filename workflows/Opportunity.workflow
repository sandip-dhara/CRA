<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_Reg_Expiration_Notification_before_15_days</fullName>
        <description>Deal Reg Expiration Notification before 15 days</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Deal_Registration_Expiration_Notification_Email</template>
    </alerts>
    <alerts>
        <fullName>Deal_Reg_Expiration_Notification_before_30_days</fullName>
        <description>Deal Reg Expiration Notification before 30 days</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Deal_Registration_Expiration_Notification_Email</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Approval_Notification</fullName>
        <description>Opportunity Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Opportunity_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>SendEmail_WhenOpportunityOwnerChanged</fullName>
        <description>SendEmail-WhenOpportunityOwnerChanged</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/OpportunityChangeOwner</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Partner_upon_Deal_Submission</fullName>
        <description>Send Notification to Partner upon Deal Submission</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/DealReg_Request_Submitted_Acknowledgement</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Source_Derived_Value_Lead</fullName>
        <field>Deal_Source__c</field>
        <literalValue>Lead</literalValue>
        <name>Deal Source Derived Value - Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submission_Date</fullName>
        <field>Deal_Submission_Date__c</field>
        <formula>NOW()</formula>
        <name>Deal Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fiscal_Quarter_Year_of_Deal_Slipped</fullName>
        <field>Original_Slipped_Quarter__c</field>
        <formula>IF( ISBLANK(Original_Slipped_Quarter__c),(CASE(MONTH (PRIORVALUE(CloseDate)),1,&quot;Q1&quot;,2,&quot;Q2&quot;,3,&quot;Q2&quot;,4,&quot;Q2&quot;,5,&quot;Q3&quot;,6,&quot;Q3&quot;,7,&quot;Q3&quot;,8,&quot;Q4&quot;,9,&quot;Q4&quot;,10,&quot;Q4&quot;,11,&quot;Q1&quot;,12,&quot;Q1&quot;,&quot;0&quot;)) &amp;&quot; FY&quot; &amp; RIGHT(TEXT(YEAR(PRIORVALUE( CloseDate ))),2),
 PRIORVALUE(Original_Slipped_Quarter__c)
)</formula>
        <name>Fiscal Quarter &amp; Year of Deal Slipped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Close_Date_Push_Counter</fullName>
        <field>Close_Date_Push_Counter__c</field>
        <formula>IF( 
ISBLANK(Close_Date_Push_Counter__c), 
1, 
Close_Date_Push_Counter__c + 1)</formula>
        <name>Increment Close Date Push Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Capture_Last_Modified_by_Partner</fullName>
        <description>It captures &apos;Last Modified by Partner&apos; date on opportunity.</description>
        <field>Last_Modified_by_Partner__c</field>
        <formula>LastModifiedDate</formula>
        <name>Oppty - Capture Last Modified by Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Sales_Stage</fullName>
        <field>Previous_Sales_Stage__c</field>
        <formula>Text(PRIORVALUE(StageName))</formula>
        <name>Previous Sales Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Premier_Type</fullName>
        <field>Premier_Type__c</field>
        <literalValue>Uplift</literalValue>
        <name>Set Premier Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Renewal_Record_Type</fullName>
        <description>Set Renewal Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Renewal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Renewal Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Slip_Deal_Counter</fullName>
        <field>Slipped_Deal_Counter__c</field>
        <formula>IF(ISNULL( Slipped_Deal_Counter__c ), 1, Slipped_Deal_Counter__c + 1 )</formula>
        <name>Slipped Deal Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOpportunityWon_LostDate</fullName>
        <description>Caturing the Won/Lost stage change Date</description>
        <field>Won_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>UpdateOpportunityWon-LostDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Date_Delta_field</fullName>
        <field>Close_Date_Delta__c</field>
        <formula>IF( 
ISBLANK(Close_Date_Delta__c), 
( CloseDate - PRIORVALUE(CloseDate )), 
PRIORVALUE(Close_Date_Delta__c) + ( CloseDate - PRIORVALUE(CloseDate )))</formula>
        <name>Update Close Date Delta field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Opty</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Standard</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type - Opty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_type_NAme</fullName>
        <description>Updates the record type to HPFS</description>
        <field>Record_Type_Name__c</field>
        <formula>&apos;HPFS&apos;</formula>
        <name>Update Record type NAme</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Route1</fullName>
        <description>Update Route to Market Field = Indirect</description>
        <field>Route_To_Market__c</field>
        <literalValue>Indirect</literalValue>
        <name>Update Route</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Change_Date</fullName>
        <field>Last_Stage_Change_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Stage Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_closed_date_to_30_days_from_today</fullName>
        <field>CloseDate</field>
        <formula>TODAY() + 30</formula>
        <name>Update closed date to 30 days from today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WonLost_PriorSalesStage</fullName>
        <description>Update PriorSalesStage field</description>
        <field>Prior_Sales_Stage__c</field>
        <formula>TEXT( PRIORVALUE(  StageName ) )</formula>
        <name>WonLost-PriorSalesStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deal Reg Expiration notifications before 30 and 15 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Deal_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This WF will send notifications to Partners before 30 days and 15 days of deal expiry date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deal_Reg_Expiration_Notification_before_15_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Deal_Expiration_Date__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deal_Reg_Expiration_Notification_before_30_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Deal_Expiration_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deal Source Derived Value - Lead</fullName>
        <actions>
            <name>Deal_Source_Derived_Value_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Converted_From_Lead__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>Derive the value of deal source based upon &quot;true&quot; condition of &quot;converted by lead&quot; field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Submission Date Population</fullName>
        <actions>
            <name>Send_Notification_to_Partner_upon_Deal_Submission</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Deal_Submission_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Deal_Registration_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Deal Submitted date will be populated with the current date when the Deal Request is submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Hyperscale Task Creation</fullName>
        <actions>
            <name>Create_Task_for_Hyperscale_Opty</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HP_Solution__c</field>
            <operation>equals</operation>
            <value>Hyperscale</value>
        </criteriaItems>
        <description>Creates a new Task and Notifies the user with the email, if HP Solution equal to Hyperscale.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Managed By Partner and Sales Sge Validation</fullName>
        <actions>
            <name>Update_Route1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Managed_By__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>If manged By Partner = &apos;Partner&apos;, and sales stage &gt; 3rd stage, Route = Indirect</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Approval Notification</fullName>
        <actions>
            <name>Opportunity_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Deal_Registration_Status__c</field>
            <operation>equals</operation>
            <value>Partially Approved,Rejected,Approved</value>
        </criteriaItems>
        <description>This workflow will fire when the opportunity status changed to Approved/Rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Close Date Statistics Calculations</fullName>
        <actions>
            <name>Increment_Close_Date_Push_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Close_Date_Delta_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculates the Opportunity Close Date Changes</description>
        <formula>ISCHANGED(CloseDate)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Set Premier Type Default for Renewal Type Opp</fullName>
        <actions>
            <name>Set_Premier_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to set default value for Premier Type field on Opportunity whenever a Standard opportunity gets converted to Renewal Opportunity.</description>
        <formula>$Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; True  &amp;&amp; ISPICKVAL(Type,&apos;Renewal&apos;) &amp;&amp;   RecordTypeId &lt;&gt; $Label.HPFS_Opportunity_Record_Type_Id &amp;&amp;  Business_Group2__c &lt;&gt; &apos;ES&apos; &amp;&amp;  ISPICKVAL( Premier_Type__c, &apos;&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Update Renewal Record Type</fullName>
        <actions>
            <name>Set_Renewal_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the record type as &quot;Renewal&quot; if Opportunity Type = &quot;Renewal&quot;and Opportunity Record Type not equal to HPFS- Update Record Type</description>
        <formula>$Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; True  &amp;&amp; ISPICKVAL(Type,&apos;Renewal&apos;) &amp;&amp;   RecordTypeId &lt;&gt; $Label.HPFS_Opportunity_Record_Type_Id &amp;&amp;  (Business_Group2__c &lt;&gt; &apos;ES&apos;  &amp;&amp; Business_Group2__c &lt;&gt; &apos;PPS&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Update Standard Record Type</fullName>
        <actions>
            <name>Update_Record_Type_Opty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(  AND( $Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true, $RecordType.Name &lt;&gt; &apos;HPFS&apos;, $RecordType.Name &lt;&gt; &apos;Partner Deal&apos;,  NOT(IsPickVal(Type, &apos;Renewal&apos;)) ),  AND( $Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true, $RecordType.Name &lt;&gt; &apos;HPFS&apos;, $RecordType.Name &lt;&gt; &apos;Partner Deal&apos;,  IsPickVal(Type, &apos;Renewal&apos;), Business_Group2__c =&apos;ES&apos; )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Update by partner</fullName>
        <actions>
            <name>Oppty_Capture_Last_Modified_by_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule captures the &apos;Last Modified by Partner&apos; date on opportunity if the partner user is making any changes to the opportunity.</description>
        <formula>CONTAINS( UPPER($User.User_Type_Text__c ), &apos;PARTNER&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity-Won%2FLost-WonLostDate</fullName>
        <actions>
            <name>UpdateOpportunityWon_LostDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Capturing the date when Stage is changed to Won or Lost</description>
        <formula>AND( ISCHANGED( StageName ) , OR( ISPICKVAL( StageName , &apos;06 - Won, Deploy &amp; Expand&apos;),ISPICKVAL( StageName , &apos;Lost&apos;), ISPICKVAL( StageName , &apos;HP Not Pursued&apos;), ISPICKVAL( StageName , &apos;Error&apos;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opporunity-WonLost-PreSalesStage</fullName>
        <actions>
            <name>WonLost_PriorSalesStage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For capturing PreSalesStage on Opportunity object for Won/Lost Analysis</description>
        <formula>ISCHANGED( StageName )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SendEmailNotification-WhenOpportunityOwnerChange</fullName>
        <actions>
            <name>SendEmail_WhenOpportunityOwnerChanged</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.SendEmailNotification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Slipped Deal WorkFlow Rule</fullName>
        <actions>
            <name>Fiscal_Quarter_Year_of_Deal_Slipped</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Slip_Deal_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculation WF that drives Slipped Deal Incrementor and Text Flag when true.</description>
        <formula>AND(    (IF( CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)  ),   OR(  ISPICKVAL(ForecastCategoryName ,&quot;Commit&quot;),   ISPICKVAL(PRIORVALUE(ForecastCategoryName),&quot;Commit&quot;)  ),   OR ( IF(AND(MONTH(TODAY())=1,MONTH(PRIORVALUE( CloseDate ))&gt;=11,MONTH(PRIORVALUE( CloseDate ))&lt;=1),TRUE, IF(AND(MONTH(TODAY())=4,MONTH(PRIORVALUE( CloseDate ))&gt;=2,MONTH(PRIORVALUE( CloseDate ))&lt;=4),TRUE, IF(AND(MONTH(TODAY())=7,MONTH(PRIORVALUE( CloseDate ))&gt;=5,MONTH(PRIORVALUE( CloseDate ))&lt;=7),TRUE, IF(AND(MONTH(TODAY())=10,MONTH(PRIORVALUE( CloseDate ))&gt;=8,MONTH(PRIORVALUE( CloseDate ))&lt;=10),TRUE, FALSE)))) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type Name</fullName>
        <actions>
            <name>Update_Record_type_NAme</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>HPFS</value>
        </criteriaItems>
        <description>This workflow updates the field &quot;Record Type Name&quot; with record type &quot;HPFS&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage Change Date and Stage Name</fullName>
        <actions>
            <name>Update_Stage_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For update &quot;Last Stage Change Date&quot; &amp; Stage Name</description>
        <formula>ISCHANGED( StageName )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Create_Task_for_Hyperscale_Opty</fullName>
        <assignedToType>owner</assignedToType>
        <description>Customer Intent Document(CID) needed:You have flagged this as a Hyperscale opportunity.In order to expedite the quote response time, a CID is required prior to requesting a quote.A task has been created to ensure a CID is created by the Solution Architect</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Customer Intent Document(CID) Needed</subject>
    </tasks>
</Workflow>
