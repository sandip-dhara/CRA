<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AthenaEmailAlertTeamMember</fullName>
        <description>AthenaEmailAlertTeamMember</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/ODP_ET_EmailNotificationForTeamMemberAssigned</template>
    </alerts>
    <alerts>
        <fullName>CTM_Email_alert</fullName>
        <description>CTM Email alert</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/CTM_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>CTM_Email_alert1</fullName>
        <description>CTM Email alert1</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/CTM_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Core_Team_Member_Added</fullName>
        <description>Core Team Member Added</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Athena_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Core_Team_Member_Deleted</fullName>
        <description>Core Team Member Deleted</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Athena_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>AthenODPTeamMUniqueControlFU</fullName>
        <field>Duplicate_Team_Member__c</field>
        <formula>Release_Name__c &amp; &apos;-&apos; &amp;  User__c &amp; &apos;-&apos; &amp; Role_Name__c</formula>
        <name>AthenODPTeamMUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ODP_WF_EmailNotificationForTeamMemberAssigned</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Core_Team_Member__c.User__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ODP_WF_TeamMUniqueControl</fullName>
        <actions>
            <name>AthenODPTeamMUniqueControlFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK( Duplicate_Team_Member__c ), ISCHANGED( Release_Name__c ), ISCHANGED( Role_Name__c ) , ISCHANGED( User__c )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ODP_WF_TeamMemberNotification</fullName>
        <actions>
            <name>AthenaEmailAlertTeamMember</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Core_Team_Member__c.User__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>