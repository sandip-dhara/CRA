<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_short_description</fullName>
        <description>This field is to update short description with the description value for search purposes</description>
        <field>Short_Description__c</field>
        <formula>Description__c</formula>
        <name>Update short description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PopulateLearningBoardDescription</fullName>
        <actions>
            <name>Update_short_description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
