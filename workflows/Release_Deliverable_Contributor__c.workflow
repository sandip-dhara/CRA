<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contributor_Assigned</fullName>
        <description>Contributor Assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Contributor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/Athena_Deliverable_Contributor_Assigned</template>
    </alerts>
</Workflow>
