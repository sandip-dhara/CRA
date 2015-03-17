<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AthenaODPRelRoleUniqueControlFU</fullName>
        <field>DuplicateAvoid__c</field>
        <formula>Release_Name__c &amp; &apos;-&apos; &amp;  Role_Name__c</formula>
        <name>AthenaODPRelRoleUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AthenaODPReleaseRoleUniqueControlFU</fullName>
        <field>DuplicateAvoid__c</field>
        <formula>Role_Name__c</formula>
        <name>AthenaODPReleaseRoleUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ODP_WF_ReleaseRoleUniqueControl</fullName>
        <actions>
            <name>AthenaODPRelRoleUniqueControlFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK( DuplicateAvoid__c ),  ISCHANGED( Role_Name__c), ISCHANGED( Release_Name__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
