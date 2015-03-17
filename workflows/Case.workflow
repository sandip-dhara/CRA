<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AMS_UVA_eMail_Notification</fullName>
        <description>AMS UVA eMail Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>AMS_Frontline_UVA_Notification_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>HP_Templates/AMS_Frontline_Unverified_Account_eMail</template>
    </alerts>
    <alerts>
        <fullName>Account_Request_Notification_to_Submitter_on_Case_Creation</fullName>
        <description>Account Request Notification to Submitter on Case Creation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Admin_Account_Request_Case_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Account_Request_Notification_to_Submitter_on_Case_Creation_Web</fullName>
        <description>Account Request Notification to Submitter on Case Creation (Web)</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Admin_Account_Request_Case_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Admin_Assignment_Notification_Action</fullName>
        <description>Case - Admin Assignment Notification Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Admin_Case_Assignment_Notification_eMail_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Assigned</fullName>
        <description>Case Assigned</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>hpcustomeroperations@external.groups.hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Operations/Case_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Case_Close_Notification</fullName>
        <description>Case Close Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations/Case_Completed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Created_Assigned_User_Template</fullName>
        <description>Case Created - Assigned User Template</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>hpcustomeroperations@external.groups.hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Operations/Case_Created_Assigned_to_User_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_notification_to_case_submitter_of_the_closed_case</fullName>
        <description>Case:Email notification to case submitter of the closed case</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Customer_Satisfaction_Survey_for_Closed_CASES</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_notification_to_case_submitter_of_the_closed_email_case</fullName>
        <description>Case : Email notification to case submitter of the closed email case</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Customer_Satisfaction_Survey_for_Closed_CASES</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_on_Case_Assignment_to_Web_Email</fullName>
        <description>Case - Email on Case Assignment to Web Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Case_Assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Notification_to_Owner</fullName>
        <description>Case Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/New_CaseNotification_for_Account_creation</template>
    </alerts>
    <alerts>
        <fullName>Case_waiting_to_close</fullName>
        <ccEmails>mohammed-ismail@hp.com</ccEmails>
        <description>Case waiting to close</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/ALERT_Case_Waiting_to_Close</template>
    </alerts>
    <alerts>
        <fullName>Close_Case_email_notification_2_days_after_7_day_email_notification_has_been_sen</fullName>
        <ccEmails>mohammed-ismail@hp.com</ccEmails>
        <description>Close Case email notification 2 days after 7-day email notification has been sent to customer</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/SUPPORT_Case_Close_Communication</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_when_case_is_closed_for_vertica_users</fullName>
        <description>Email Alert when case is closed for vertica users</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/Close_Case_Notification_for_vertica</template>
    </alerts>
    <alerts>
        <fullName>Email_Warning</fullName>
        <description>Email Warning</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Admin_Email_Template_for_Milestone_Warning</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_if_case_is_critical_or_becomes_escalated</fullName>
        <ccEmails>mohammed-ismail@hp.com</ccEmails>
        <description>Email alert if case is critical or becomes escalated</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/SUPPORT_Critical_or_Escalated_case</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Vertica_Case_Creator</fullName>
        <description>Email to Vertica Case Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>vertica.techsupport@hp.com.esit</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>verticahelp@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Vertica_Template/SUPPORT_Email_to_Case_email_response</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Vertica_Case_Submitter</fullName>
        <description>Email to Vertica Case Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/SUPPORT_Email_to_Case_email_response</template>
    </alerts>
    <alerts>
        <fullName>Email_to_case_submitter1</fullName>
        <description>Email to case submitter1</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Notification_to_case_submitter</template>
    </alerts>
    <alerts>
        <fullName>Email_to_submitter_on_Case_Assignment</fullName>
        <description>Email to submitter on Case Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Case_Assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Email_to_the_case_creator</fullName>
        <description>Email to the case creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Notification_to_case_submitter</template>
    </alerts>
    <alerts>
        <fullName>Email_to_the_case_submitter</fullName>
        <description>Email to the case submitter</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Notification_to_case_submitter</template>
    </alerts>
    <alerts>
        <fullName>Internal_Notification_Case_Opened_from_one_of_your_Accounts</fullName>
        <description>Internal Notification - Case Opened from one of your Accounts</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/SUPPORT_Account_owner_new_case_notification</template>
    </alerts>
    <alerts>
        <fullName>New_Internal_Change_Mgmt_Case_Creation_Notification</fullName>
        <description>New Internal Change Mgmt Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/Internal_Change_Mgmt_Case_New</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_requestor_on_Case_Reassignment</fullName>
        <description>Notification to requestor on Case Reassignment</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Operations/R5_CO_Case_Creation_Reassignment_Requestor_Notification_Template_Generic_for_All</template>
    </alerts>
    <alerts>
        <fullName>SendEmailtoallSupportinternwhenacasehasebeencreated</fullName>
        <ccEmails>susmita.satpathy@hp.com</ccEmails>
        <ccEmails>mohammed-ismail@hp.com</ccEmails>
        <description>Send E-mail to all Support intern when a case hase been created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/SUPPORT_New_assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Case_Acceptance_Notification_to_Creator</fullName>
        <description>Send Case Acceptance Notification to Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Case_Acceptance_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Case_Rejection_Notification_to_Creator</fullName>
        <description>Send Case Rejection Notification to Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Case_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_E_mail_to_all_Support_intern_when_a_case_hase_been_created</fullName>
        <description>Send E-mail to all Support intern when a case hase been created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>vertica.techsupport@hp.com.esit</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Send_Support_Case_Survey</fullName>
        <description>Send Support Case Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/Send_using_Workflow_HP_Vertica_Technical_Support_Survey</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_for_pending_request</fullName>
        <description>Send notification for pending request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Case_Send_Notification_for_pending_request</template>
    </alerts>
    <alerts>
        <fullName>Support_case_needs_updating</fullName>
        <description>Support case needs updating</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/ALERT_Case_Needs_updating</template>
    </alerts>
    <alerts>
        <fullName>Update_Case_owner_case_is_in_Updated_by_Customer_status</fullName>
        <ccEmails>Mohammed-ismail@hp.com</ccEmails>
        <description>Update Case owner case is in Updated by Customer status</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>HP_Templates/INTERNAL_Case_Updated_by_Customer_ALERT</template>
    </alerts>
    <alerts>
        <fullName>Vertica_Email_to_Vertica_Case_Creator</fullName>
        <description>Vertica Email to Vertica Case Creator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>vertica.techsupport@hp.com.esit</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>verticahelp@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Vertica_Template/SUPPORT_Email_to_Case_email_response</template>
    </alerts>
    <alerts>
        <fullName>Vertica_Email_to_Vertica_Case_Submitter</fullName>
        <description>Vertica Email to Vertica Case Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Vertica_Template/SUPPORT_Email_to_Case_email_response</template>
    </alerts>
    <fieldUpdates>
        <fullName>Add_Comment_to_Close_2_days_no_response</fullName>
        <description>Add comment that the case was closed after 2 days of no customer response.</description>
        <field>Work_Status__c</field>
        <formula>&quot;Case closed after no response in 2 days&quot;</formula>
        <name>Add Comment to Close 2 days no response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_comment_to_close</fullName>
        <description>Add a reminder comment to close case in 2 days if no response</description>
        <field>Work_Status__c</field>
        <formula>&quot;Close case if no response in 2 days&quot;</formula>
        <name>Add comment to close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_New_Reg</fullName>
        <description>Case owner set to Round Robin queue for MyVertica</description>
        <field>OwnerId</field>
        <lookupValue>MyVerticaRequests</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner New Reg</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Resolution_Summary_Update</fullName>
        <description>Update the Case Resolution Summary field if blank when closing a case automatically.</description>
        <field>Case_Resolution_Summary__c</field>
        <formula>&quot;Case CaseNumber has been automatically closed by the HP Vertica Tech Support Team&quot;</formula>
        <name>Case Resolution Summary Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Resolution_Summary_Update3</fullName>
        <field>Case_Resolution_Summary__c</field>
        <formula>&quot;Case closed after 7 days of waiting to close and 2 day warning&quot;</formula>
        <name>Case Resolution Summary Update3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Single_Account_Field_Update</fullName>
        <field>Number_of_Accounts__c</field>
        <formula>1</formula>
        <name>Case - Single Account Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_case</fullName>
        <description>This case has been marked as escalated</description>
        <field>Is_Escalated__c</field>
        <formula>&quot;Escalated&quot;</formula>
        <name>Escalated case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_set_to_False</fullName>
        <field>IsEscalated</field>
        <literalValue>0</literalValue>
        <name>Escalated set to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_set_to_True</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>Escalated set to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HPSW_Case_Create_Name</fullName>
        <field>Subject</field>
        <formula>TEXT( Reason ) &amp;&quot; - &quot;&amp; Requested_Folder_Name__c</formula>
        <name>HPSW Case Create Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Change_Mgmt_Case_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>SFDC_Admins_Case_Mgmt</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Internal Change Mgmt Case Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Internal_Change_Mgmt_Case_Record_Type</fullName>
        <description>Update Internal Change Mgmt case to record type</description>
        <field>RecordTypeId</field>
        <lookupValue>Vertica_Internal_Change_Management</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Internal Change Mgmt Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_updated_field_to_close</fullName>
        <description>Update the last updated field</description>
        <field>Last_Updated__c</field>
        <formula>NOW()</formula>
        <name>Last updated field to close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Missed_Turnaround_Time_Field_Update</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Missed Turnaround Time Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Modify_Case_Name_Report_Folder</fullName>
        <field>Subject</field>
        <formula>TEXT( Reason ) &amp;&quot; - &quot;&amp; Existing_Folder_Name__c</formula>
        <name>Modify Case Name Report Folder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MyVertica_Cases_Case_Record_Type</fullName>
        <description>Update Case Record Type to Customer Support Case</description>
        <field>RecordTypeId</field>
        <lookupValue>Vertica_Customer_Support_Cases</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>MyVertica Cases - Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MyVertica_Portal_Users_Case_Record_Type</fullName>
        <description>Update Case Record Type for case submission by Portal Users</description>
        <field>RecordTypeId</field>
        <lookupValue>Vertica_Portal_Case_Management</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>MyVertica Portal Users Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Case_Origins_Case_Record_Type</fullName>
        <description>Update to all other Support Cases with Customer Support Cases Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Vertica_Customer_Support_Cases</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Other Case Origins Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Sold_to_Party</fullName>
        <field>Sold_to_Party__c</field>
        <formula>Account.Name</formula>
        <name>Populate Sold to Party</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PortalOwner</fullName>
        <description>Change portal owner to Standard Queue</description>
        <field>OwnerId</field>
        <lookupValue>Standard_Support_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PortalOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_to_Admin_Support</fullName>
        <description>Field update that changes Case Record Type to &quot;Admin Support&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Admin_Support</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT to Admin Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Close_case_if_no_response</fullName>
        <description>If Work Status = Close case if no response in 2 days, close case.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Status - Close case if no response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date</fullName>
        <field>Due_Date__c</field>
        <formula>Now()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date1</fullName>
        <field>Due_Date__c</field>
        <formula>NoW()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date2</fullName>
        <field>Due_Date__c</field>
        <formula>now()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date3</fullName>
        <field>Due_Date__c</field>
        <formula>Now()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date4</fullName>
        <field>Due_Date__c</field>
        <formula>NOw()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date5</fullName>
        <field>Due_Date__c</field>
        <formula>Now()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Due_Date6</fullName>
        <field>Due_Date__c</field>
        <formula>Now()</formula>
        <name>Update Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time</fullName>
        <description>To update Update Missed Turn Around Time Checkbox if SLA is Missed</description>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time001</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time002</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time003</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time004</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time005</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time006</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missed_Turn_Around_Time007</fullName>
        <field>Missed_Turnaround_Time__c</field>
        <literalValue>1</literalValue>
        <name>Update Missed Turn Around Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Escalated</fullName>
        <description>Update Status to Escalated</description>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Update Status to Escalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CO Case- Populate Sold to Party</fullName>
        <actions>
            <name>Populate_Sold_to_Party</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CO Case</value>
        </criteriaItems>
        <description>This is to update a field Sold to Party whenever Account is populated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CO Case- Reassignment Notification to Requestor</fullName>
        <actions>
            <name>Notification_to_requestor_on_Case_Reassignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISNEW()) &amp;&amp;  ISBLANK( Parent.CaseNumber )  &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; ISCHANGED(OwnerId) &amp;&amp; ( ISPickVal( Origin, &apos;CSIF&apos;) || ISPickVal( Origin, &apos;Salesforce&apos;) || ISPickVal( Origin, &apos;SRT&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CO Case-Assignment Notification to Owner</fullName>
        <actions>
            <name>Case_Assigned</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_OAE_Fallout_Queue)),  
((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_TS_China_CSIF)),  
((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_TS_Hong_Kong_CSIF)),  
((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_TS_South_Korea_CSIF)),  
((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_TS_Taiwan_CSIF)),    
((ISNEW() ) &amp;&amp; RecordType.Name == &apos;CO Case&apos; &amp;&amp; (OwnerId &lt;&gt; $Label.CO_TS_United_States_PWB)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CO Case-creation From CSIF%2FSRT</fullName>
        <actions>
            <name>Case_Created_Assigned_User_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CO Case,TS Contact Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Express,SPA,SCA,PWB</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>workflow to send mail to requestors</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - AMS Frontline Unverified Account Workflow</fullName>
        <actions>
            <name>AMS_UVA_eMail_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Scenario__c</field>
            <operation>equals</operation>
            <value>UVA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>AMS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Frontline</value>
        </criteriaItems>
        <description>A workflow process to email specific users when an unverified account case is received in the AMS queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Account Request Notification to Submitter on Case Creation</fullName>
        <actions>
            <name>Account_Request_Notification_to_Submitter_on_Case_Creation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Request_Notification_to_Submitter_on_Case_Creation_Web</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request</value>
        </criteriaItems>
        <description>Workflow process to send an email to the case submitter on case creation for &apos;Account Request&apos; cases.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Admin Assignment Notification Workflow</fullName>
        <actions>
            <name>Case_Admin_Assignment_Notification_Action</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR
(
ISCHANGED( OwnerId ),
ISNEW()
)
&amp;&amp;
OwnerId &lt;&gt; $Label.CO_OAE_Fallout_Queue
&amp;&amp;
$RecordType.Name = &quot;Admin Support&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Email on Case Assignment</fullName>
        <actions>
            <name>Case_Email_on_Case_Assignment_to_Web_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_to_submitter_on_Case_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send an email to case submitter when case is assigned to a owner.</description>
        <formula>IF( ($Setup.Global_Config__c.Mute_Workflow_Rule__c==true) ,false,  IF( !ISNEW()  &amp;&amp;  ISCHANGED(OwnerId)  &amp;&amp; OwnerId &lt;&gt;  $Label.Front_Line  &amp;&amp; OR ( $RecordType.Name = &quot;Account Request&quot;, $RecordType.Name = &quot;Admin Support&quot; ) , true, false))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Notification of new case to submitter</fullName>
        <actions>
            <name>Email_to_case_submitter1</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_to_the_case_creator</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Support</value>
        </criteriaItems>
        <description>Send an email back to the submitter stating that their request has been received along with a Case number and link to the case</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Notification to case submitter of close case</fullName>
        <actions>
            <name>Case_Email_notification_to_case_submitter_of_the_closed_case</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Email_notification_to_case_submitter_of_the_closed_email_case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request,Admin Support</value>
        </criteriaItems>
        <description>Notification to case submitter of close cased.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Single Account Field Update</fullName>
        <actions>
            <name>Case_Single_Account_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Request_Type__c</field>
            <operation>equals</operation>
            <value>Single Record</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request</value>
        </criteriaItems>
        <description>Update the # of Accounts field to be &apos;1&apos; if the &apos;Request Type&apos; is &apos;Single Record&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Close Notification</fullName>
        <actions>
            <name>Case_Close_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CO Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Express,SPA,SCA,PWB</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed Survey</fullName>
        <actions>
            <name>Send_Support_Case_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Rule to fire Timba survey on close of a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closed email for Vertica</fullName>
        <actions>
            <name>Email_Alert_when_case_is_closed_for_vertica_users</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Rule to fire When Vertica case is closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case needs Updating</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,Escalated to Engineering</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Case has not been updated for 5 days, please update.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Support_case_needs_updating</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case opend to account owner</fullName>
        <actions>
            <name>Internal_Notification_Case_Opened_from_one_of_your_Accounts</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Email will be sent to Account owner when a case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case_Revised Due Date_Rule</fullName>
        <actions>
            <name>Missed_Turnaround_Time_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>((Revised_Due_Date__c &lt; NOW() &amp;&amp; Due_Date__c &lt; NOW())||(Revised_Due_Date__c &lt; NOW()&amp;&amp; ISBLANK( Due_Date__c ))||(Due_Date__c &lt; NOW() &amp;&amp; ISBLANK(Revised_Due_Date__c)))&amp;&amp;( Missed_Turnaround_Time__c = False)&amp;&amp;( RecordType.Name = &apos;CO Case&apos;||RecordType.Name = &apos;TS Contact Center&apos;)&amp;&amp; ($Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; True)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalate Case Workflow</fullName>
        <actions>
            <name>Escalated_set_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated To IT,Escalated To Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request,Admin Support</value>
        </criteriaItems>
        <description>When status = Escalated sets Escalate Checkbox to True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalated or Critical case</fullName>
        <actions>
            <name>Email_alert_if_case_is_critical_or_becomes_escalated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Escalated_case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Case_Escalated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Has a case been escalated or critical during life of case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HPSW Create Folder Case Name</fullName>
        <actions>
            <name>HPSW_Case_Create_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Request New Folder</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BG Admin Services</value>
        </criteriaItems>
        <description>Rename the Subject for a new Case to align to Function and User</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HPSW Modify Folder Case Name</fullName>
        <actions>
            <name>Modify_Case_Name_Report_Folder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Modify Existing Folder,Remove Existing Folder,Add/Remove User Access</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>BG Admin Services</value>
        </criteriaItems>
        <description>Rename the Subject for a new Case to align to Function and User</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MyVertica Cases - Case Record Type</fullName>
        <actions>
            <name>MyVertica_Cases_Case_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>MyVertica Access Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Update to Customer Support Cases record type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify all Tech support internal</fullName>
        <actions>
            <name>Send_E_mail_to_all_Support_intern_when_a_case_hase_been_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Notify all Tech support internal for Vertica Cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Other Case Origins Case Record Type</fullName>
        <actions>
            <name>Other_Case_Origins_Case_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Phone,Email,Web,FE/Impl Engr,Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Update to all other Support Cases with Customer Support Cases Record Type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PortalRule</fullName>
        <actions>
            <name>PortalOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.UserType</field>
            <operation>equals</operation>
            <value>Customer Portal Manager,Customer Portal User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Workflow rule to assign portal cases to queues.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to Case Owner</fullName>
        <actions>
            <name>Case_Notification_to_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsPortalEnabled</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Case Request</value>
        </criteriaItems>
        <description>When partner created a account case should be created and routed to operation team.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Un-escalate Case Workflow</fullName>
        <actions>
            <name>Escalated_set_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Escalated To IT,Escalated To Business</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Request,Admin Support</value>
        </criteriaItems>
        <description>When status not Escalated sets Escalate Checkbox to False</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update RT to Admin Support</fullName>
        <actions>
            <name>Set_RT_to_Admin_Support</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>Add me to account team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Scenario__c</field>
            <operation>equals</operation>
            <value>Account exists in SFDC</value>
        </criteriaItems>
        <description>Case Reason is populated with &quot;Add me to account team&quot; change record type to &quot;Admin Support&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update customer status</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Updated by Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_owner_case_is_in_Updated_by_Customer_status</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Vertica Case - Notification of new case to submitter For Vertica</fullName>
        <actions>
            <name>Vertica_Email_to_Vertica_Case_Creator</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Vertica_Email_to_Vertica_Case_Submitter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>This Rule is Created for Vertica</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Waiting to Close_7</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting to Close</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Customer Support Cases,Vertica Internal Change Management,Vertica Portal Case Management</value>
        </criteriaItems>
        <description>Case has been in waiting to close status for a week.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case_email_notification_2_days_after_7_day_email_notification_has_been_sen</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Add_Comment_to_Close_2_days_no_response</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Case_Resolution_Summary_Update3</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Close_case_if_no_response</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Last_Status_Change__c</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_waiting_to_close</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Add_comment_to_close</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Last_updated_field_to_close</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
