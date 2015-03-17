<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateWonLost_PriorSalesStage</fullName>
        <description>Updating PriorSalesStage from Oppotunity</description>
        <field>Prior_Sales_Stage__c</field>
        <formula>Opportunity__r.Prior_Sales_Stage__c</formula>
        <name>UpdateWonLost-PriorSalesStage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateWon_Lost_Won_LostDate</fullName>
        <description>Update the field with Opportunity Won/Lost Field</description>
        <field>Won_Lost_Date__c</field>
        <formula>Opportunity__r.Won_Lost_Date__c</formula>
        <name>UpdateWon/Lost-Won-LostDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Won%2FLost-WonLostDate</fullName>
        <actions>
            <name>UpdateWon_Lost_Won_LostDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_ID__c</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <description>Capturing the Won/Lost Date from Opportunity Won/Lost Date field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WonLost-PriorSalesStage</fullName>
        <actions>
            <name>UpdateWonLost_PriorSalesStage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_ID__c</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <description>Capturing PriorSalesStage form Opportunity prior sales stage field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
