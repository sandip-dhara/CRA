<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_the_Submit_Request_Template_when_Record_is_s</fullName>
        <description>Send the Submit Request Template when Record is s</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Secondary_Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Submit_Support_Request_Email_Template</template>
    </alerts>
    <rules>
        <fullName>Submit Support Request Notification</fullName>
        <actions>
            <name>Send_the_Submit_Request_Template_when_Record_is_s</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Support_Request__c.Submitted_Status_Vertica__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Support_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vertica Support Request</value>
        </criteriaItems>
        <description>This is the Email that goes to Technical Support team and Assignee When Support Request is Submitted for Vertica Record Type.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
