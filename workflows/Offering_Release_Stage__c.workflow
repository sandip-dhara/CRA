<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Offering_Release_Stage_Recall_Notification</fullName>
        <description>Offering Release Stage Recall Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>PLMAdminGroup</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Offering_Release_stage_recall_notification</template>
    </alerts>
    <alerts>
        <fullName>Offering_release_Stage_Final_approval_notification</fullName>
        <description>Offering release Stage Final approval notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Offering_release_stage_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>Offering_release_Stage_Final_rejection_notification</fullName>
        <description>Offering release Stage Final rejection notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Offering_release_stage_Final_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_to_Complete</fullName>
        <description>Change to In Progress</description>
        <field>Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Change to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_InReview</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Change to  InReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_In_Progress</fullName>
        <description>Change to Not Started</description>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Change to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_to_In_Review</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Change to In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_offering_release_stage_to_In_Rev</fullName>
        <field>Status__c</field>
        <literalValue>In Review</literalValue>
        <name>Update offering release stage to &quot;In Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
