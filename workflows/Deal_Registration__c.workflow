<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HiddenAuto_Approve</fullName>
        <field>Hidden_Auto_Approve__c</field>
        <literalValue>1</literalValue>
        <name>HiddenAuto Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Submitted</fullName>
        <description>Status changed to submitted when the user click on submit for approval on Deal Registration</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Expired</fullName>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Update Status to Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_ReviewInitiated</fullName>
        <description>Update the status to Review Initiated when the first level user approves</description>
        <field>Status__c</field>
        <literalValue>Review Initiated</literalValue>
        <name>Update Status to ReviewInitiated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Date</fullName>
        <field>Submission_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deal Registration Expiration</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deal_Registration__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>91</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deal Registration Expiration Temporary</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deal_Registration__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deal_Registration__c.XX_Temp_For_WF_Update__c</field>
            <operation>equals</operation>
            <value>ForWFUpdate</value>
        </criteriaItems>
        <description>This is a temporary workflow to update the &apos;Status&apos; to &apos;Expired&apos; of the existing deal_reg records and this workflow is valid till 7th, August,2013 after which it will be deleted along with the temporary custom field - &apos;XX_Temp_For_WF_Update__c&apos;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status_to_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Deal_Registration__c.Expiration_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DealReg Auto Approve</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deal_Registration__c.Status__c</field>
            <operation>equals</operation>
            <value>Review Initiated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deal_Registration__c.Level_2_Approval_Deadline__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HiddenAuto_Approve</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Deal_Registration__c.Level_2_Approval_Deadline__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
