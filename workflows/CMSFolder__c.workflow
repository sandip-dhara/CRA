<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CMSForce_folder_clear_Site_Id</fullName>
        <description>This field update will clear the site id</description>
        <field>Site_Id__c</field>
        <name>CMSForce folder clear Site Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Site_Id_to_Parent_Site_Id</fullName>
        <field>Site_Id__c</field>
        <formula>Parent_CMSFolder__r.Site_Id__c</formula>
        <name>Set Site Id to Parent Site Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CMSForce clear Site Id on non root folder</fullName>
        <actions>
            <name>CMSForce_folder_clear_Site_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will clear the Site Id if a folder is not a root folder in a Site</description>
        <formula>NOT( ISBLANK(Parent_CMSFolder__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
