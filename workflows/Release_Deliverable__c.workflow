<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Release_Deliverable_approval_workflow_recall_email_alert</fullName>
        <description>Release Deliverable approval workflow recall email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Release_Deliverable_Recall_action_email_template</template>
    </alerts>
    <alerts>
        <fullName>Release_Deliverables_Final_Approval_Email_Alert</fullName>
        <description>Release Deliverables Final Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Release_Deliverable_Final_Approval_EmailTemplate</template>
    </alerts>
    <alerts>
        <fullName>Release_Deliverables_Rejection_Email_Alert</fullName>
        <description>Release Deliverables Rejection Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cust_Release_Deliverable_Final_Rejection_EmailTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>AthenaODPRelDelUniqueControlFU</fullName>
        <field>Duplicate_Release_Deliverable__c</field>
        <formula>Release_Name__c &amp; &apos;-&apos; &amp;  Release_Deliverable_Name__c</formula>
        <name>AthenaODPRelDelUniqueControlFU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ODP_WF_RelDelUniqueControl</fullName>
        <actions>
            <name>AthenaODPRelDelUniqueControlFU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISBLANK( Duplicate_Release_Deliverable__c ),  ISCHANGED( Release_Name__c ),  ISCHANGED( Release_Deliverable_Name__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
