<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BU_Plan_Approved_Final</fullName>
        <description>BU Plan Approved Final</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BU_Plan_is_Approved_Final</template>
    </alerts>
    <alerts>
        <fullName>BU_Plan_Rejected_Final</fullName>
        <description>BU Plan Rejected Final</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BU_Plan_Rejected_Final</template>
    </alerts>
    <alerts>
        <fullName>Your_Business_Unit_Plan_is_Approved</fullName>
        <description>Your Business Unit Plan is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BU_Plan_After_Approval</template>
    </alerts>
    <alerts>
        <fullName>Your_Business_Unit_Plan_is_Rejected</fullName>
        <description>Your Business Unit Plan is Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BU_Plan_After_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>BU_Plan_status_Change_on_Approval</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>BU Plan status Change on Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BU_Plan_status_Change_on_Recall_Reject</fullName>
        <field>Plan_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>BU Plan status Change on Recall/Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BU_Plan_status_Change_on_Submission</fullName>
        <field>Plan_Status__c</field>
        <literalValue>Submitted – Pending Review</literalValue>
        <name>BU Plan status Change on Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
