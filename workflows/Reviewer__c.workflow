<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DG_Reviewer_Email_Notification</fullName>
        <description>DG Reviewer Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/DG_Final_Approval_Request_Email_Reviewer</template>
    </alerts>
    <rules>
        <fullName>DG Final Email Notification for Reviewer</fullName>
        <actions>
            <name>DG_Reviewer_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Reviewer__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Reviewer__c.Approval_Record_Type__c</field>
            <operation>equals</operation>
            <value>Opportunity Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Reviewer__c.Do_not_email__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Deal Governance Email Notification for Reviewer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
