<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Has_Product_Line_Field</fullName>
        <field>HasProductLine__c</field>
        <formula>0</formula>
        <name>Set Has Product Line Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Has_Product_Line_Field2</fullName>
        <field>HasProductLine__c</field>
        <formula>1</formula>
        <name>Set Has Product Line Field2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Has_Sub_Product_Line_Field</fullName>
        <field>HasSubProductLine__c</field>
        <formula>0</formula>
        <name>Set Has Sub Product Line Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Has_Sub_Product_Line_Field2</fullName>
        <field>HasSubProductLine__c</field>
        <formula>1</formula>
        <name>Set Has Sub Product Line Field2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Summation_Product_name_Field_update</fullName>
        <field>Summation_Product_Name__c</field>
        <formula>ProductName__c</formula>
        <name>Summation Product name Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Product Name Update - for License Summation</fullName>
        <actions>
            <name>Summation_Product_name_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.ProductName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Field used to create roll up field on Opportunity Header derived from Product Line</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Has Product Line</fullName>
        <actions>
            <name>Set_Has_Product_Line_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to set HasProductLine Field.</description>
        <formula>AND ($Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true,   ISBlank(Product_Line__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Has Product Line 2</fullName>
        <actions>
            <name>Set_Has_Product_Line_Field2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to set HasProductLine Field.</description>
        <formula>AND ($Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true,  NOT(ISBlank(Product_Line__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Has Sub Product Line</fullName>
        <actions>
            <name>Set_Has_Sub_Product_Line_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to set HasSubProductLine Field.</description>
        <formula>AND ($Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true,  ISBlank(Sub_Product_Line__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Has Sub Product Line2</fullName>
        <actions>
            <name>Set_Has_Sub_Product_Line_Field2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to set HasSubProductLine Field.</description>
        <formula>AND ($Setup.Global_Config__c.Mute_Workflow_Rule__c &lt;&gt; true,  NOT(ISBlank(Sub_Product_Line__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
