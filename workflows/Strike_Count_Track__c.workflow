<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_2_day_SLA_date_on_Strike_count_track</fullName>
        <description>Calculates ans sets the &apos;2 day SLA date&apos; on strike count track object</description>
        <field>Two_Day_SLA_Date__c</field>
        <formula>CASE 
( 
User_assignment_day__c , 
&quot;Sunday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +2, Queue_Assignment_Date__c +3)), 
&quot;Monday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +2, Queue_Assignment_Date__c +3)), 
&quot;Tuesday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +2, Queue_Assignment_Date__c +3)), 
&quot;Wednesday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +2, Queue_Assignment_Date__c +5)), 
&quot;Thursday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +4, Queue_Assignment_Date__c +5)), 
&quot;Friday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +4, Queue_Assignment_Date__c +5)), 
&quot;Saturday&quot;, (IF(ISBLANK(Queue_Assignment_Date__c), User_Assignment_Date__c +3, Queue_Assignment_Date__c +4)), 
null 
)</formula>
        <name>Set 2 day SLA date on Strike count track</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Strike count track - update 2 day SLA date</fullName>
        <actions>
            <name>Set_2_day_SLA_date_on_Strike_count_track</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Strike_Count_Track__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
