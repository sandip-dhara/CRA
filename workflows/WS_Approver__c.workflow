<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DG_Final_Email_Approver</fullName>
        <description>DG Final Email Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/DG_Final_Approval_Request_Email_Approver</template>
    </alerts>
    <rules>
        <fullName>DG Final Email Notification for Approver</fullName>
        <actions>
            <name>DG_Final_Email_Approver</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WS_Approver__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>WS_Approver__c.Do_not_email__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Deal Governance Email Notification for Approver</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
