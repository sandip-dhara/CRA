<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AthenaODPRelStgUniqueControlFU</fullName>
        <field>Duplicate_Release_Stage__c</field>
        <formula>Release_Name__c &amp; &apos;-&apos; &amp;  Stage_Name__c</formula>
        <name>AthenaODPRelStgUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AthenaODPReleaseStageUniqueControlFU</fullName>
        <field>Duplicate_Release_Stage__c</field>
        <formula>Stage_Name__c</formula>
        <name>AthenaODPReleaseStageUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ODP_WF_RelStgUniqueControl</fullName>
        <actions>
            <name>AthenaODPRelStgUniqueControlFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK(  Duplicate_Release_Stage__c ), ISCHANGED( Release_Name__c ), ISCHANGED( Stage_Name__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>odp_mail</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Release_Stage__c.Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
