<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Offering_Release_Final_Approval_Email_Alert</fullName>
        <description>Offering Release Final Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/ODP_ET_EmailNotificationOfferingReleaseApproveApproved</template>
    </alerts>
    <alerts>
        <fullName>Offering_Release_Recall_Notification</fullName>
        <description>Offering Release Recall Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>PLMAdminGroup</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Cust_Offering_Release_recall_notification</template>
    </alerts>
    <alerts>
        <fullName>Offering_Release_Rejectionl_Email</fullName>
        <description>Offering Release Rejectionl Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/ODP_ET_EmailNotificationOfferingReleaseApproveReject</template>
    </alerts>
    <fieldUpdates>
        <fullName>Offering_Release_Status_Under_Review</fullName>
        <description>Whe the offering release is submitted for approval. the status will be changed to under review</description>
        <field>Status__c</field>
        <literalValue>Under Review</literalValue>
        <name>Offering Release Status Under Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recall_Action_Field_Update_To_Draft</fullName>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Recall Action Field Update To Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Draft_on_Not_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Status to Draft on Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_In_Development_on_Approval</fullName>
        <description>When the offering release is approved, the status will be set to In Development from Draft</description>
        <field>Status__c</field>
        <literalValue>In Development</literalValue>
        <name>Status to In Development on Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
