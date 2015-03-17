<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DG_Final_Approval_Notification</fullName>
        <description>DG Final Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/DG_OR_Approval_Final_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>DG_Final_Rejection_Notification</fullName>
        <description>DG Final Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/DG_OR_Approval_Final_Rejection_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_0</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>0</formula>
        <name>Set Approval Level To 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_1</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>1</formula>
        <name>Set Approval Level To 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_3</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>3</formula>
        <name>Set Approval Level To 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_4</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>4</formula>
        <name>Set Approval Level To 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_5</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>5</formula>
        <name>Set Approval Level To 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_6</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>6</formula>
        <name>Set Approval Level To 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_7</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>7</formula>
        <name>Set Approval Level To 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_To_8</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>8</formula>
        <name>Set Approval Level To 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Level_to_2</fullName>
        <field>Current_Approval_Level__c</field>
        <formula>2</formula>
        <name>Set Approval Level to 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Rejected_Date</fullName>
        <field>Approved_Date__c</field>
        <formula>Now()</formula>
        <name>Update Approved/Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Open_When_Recall</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Update Status to Open When Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Date</fullName>
        <field>Submitted_Date__c</field>
        <formula>now()</formula>
        <name>Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
