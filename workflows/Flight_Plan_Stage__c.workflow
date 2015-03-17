<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AthenaODPFPStgUniqueControl</fullName>
        <field>Duplicate_Flight_Plan_Stage__c</field>
        <formula>Flight_Plan_Name__c &amp; &apos;-&apos; &amp; Stage_Name__c</formula>
        <name>AthenaODPFPStgUniqueControl</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ODP_WF_FPStgUniqueControl</fullName>
        <actions>
            <name>AthenaODPFPStgUniqueControl</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( ISBLANK( Duplicate_Flight_Plan_Stage__c ),  ISCHANGED( Flight_Plan_Name__c ),  ISCHANGED( Stage_Name__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
