<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UserData_Full_Name_Search_Update</fullName>
        <field>User_Name_Search__c</field>
        <formula>User__r.FirstName &amp; &quot; &quot; &amp; User__r.LastName</formula>
        <name>UserData - Full Name Search Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UserData_eMail_Search_Update</fullName>
        <field>User_eMail_Search__c</field>
        <formula>User__r.Email_Address__c</formula>
        <name>UserData - eMail Search Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UserData - Search Field Updates</fullName>
        <actions>
            <name>UserData_Full_Name_Search_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UserData_eMail_Search_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR 
( 
ISNEW(), 
ISCHANGED( User__c ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
