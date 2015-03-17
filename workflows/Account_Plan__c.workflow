<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>You_are_the_owner</fullName>
        <description>You are the owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_owner_change_email_alert</template>
    </alerts>
    <alerts>
        <fullName>Your_Account_Plan_is_Approved</fullName>
        <description>Your Account Plan is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_After_Approval</template>
    </alerts>
    <alerts>
        <fullName>Your_Account_Plan_is_Rejected</fullName>
        <description>Your Account Plan is Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>check_flag_off</fullName>
        <field>Owner_change_email__c</field>
        <literalValue>0</literalValue>
        <name>check flag off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Plan Owner change email alert</fullName>
        <actions>
            <name>You_are_the_owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>check_flag_off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.Owner_change_email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
