<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Completion_Date</fullName>
        <field>Completion_Date__c</field>
        <formula>Today()</formula>
        <name>Populate Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completion_Date</fullName>
        <description>To Update Completion date for task if Status = Compelte</description>
        <field>Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>populate_completion_time</fullName>
        <field>Completion_Time__c</field>
        <formula>Now()</formula>
        <name>populate completion time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CO Case- Task Completion Date Population</fullName>
        <actions>
            <name>Populate_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>populate_completion_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(RecordType.Name == &apos;CO Task&apos;) &amp;&amp;(ISPickVal(Status,&apos;Closed&apos;)||ISPickVal(Status,&apos;Cancelled&apos;)||ISPickVal(Status,&apos;Completed&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task_Update</fullName>
        <actions>
            <name>Update_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Completion_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
