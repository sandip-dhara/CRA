<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Your_Account_Plan_is_Approved</fullName>
        <description>Your Account Plan is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_After_Approval</template>
    </alerts>
    <alerts>
        <fullName>Your_Account_Plan_is_Approved_Final</fullName>
        <description>Your Account Plan is Approved Final</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Approved_vf</template>
    </alerts>
    <alerts>
        <fullName>Your_Account_Plan_is_Rejected</fullName>
        <description>Your Account Plan is Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Your_Account_Plan_is_Rejected_Final</fullName>
        <description>Your Account Plan is Rejected Final</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Rejected_vf</template>
    </alerts>
    <fieldUpdates>
        <fullName>Plan_status_Change_on_Approval</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Plan status Change on Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Plan_status_Change_on_Recall_Reject</fullName>
        <field>Plan_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Plan status Change on Recall/Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Plan_status_Change_on_submission</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Submitted – Pending Review</literalValue>
        <name>Plan status Change on submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
