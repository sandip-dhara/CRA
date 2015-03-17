<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_Suppressfor_Marketing</fullName>
        <description>SFDC R3.0_Julalin_14/09/2012: New field Update to reset Suppress for Marketing</description>
        <field>Suppress_Marketing__c</field>
        <literalValue>0</literalValue>
        <name>Reset Suppressfor Marketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Suppressfor Marketing Flag</fullName>
        <actions>
            <name>Reset_Suppressfor_Marketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC R3.0_Julalin_03/10/2012: New WF Rule is created to reset Suppress for Marketing.</description>
        <formula>IF( ($Setup.Global_Config__c.Mute_Workflow_Rule__c==true) ,False,Suppression_End_Date__c  &lt; TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
