<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_When_Load_fails</fullName>
        <ccEmails>sfdcbatchinterface@hp.com</ccEmails>
        <description>Send Email When Load fails</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Batch_Interface</template>
    </alerts>
    <rules>
        <fullName>Email_when_Load_failed</fullName>
        <actions>
            <name>Send_Email_When_Load_fails</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>SFDC_Batch_Interface__c.Load_Startus__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SFDC_Batch_Interface__c.Load_Startus__c</field>
            <operation>equals</operation>
            <value>Warning</value>
        </criteriaItems>
        <description>Send email when load fails</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
