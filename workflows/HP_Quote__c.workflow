<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>HP_Quote_Expiration_Email</fullName>
        <description>HP Quote Expiration Email to Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/HP_Quote_Expiration_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Quote_Complete_Notification</fullName>
        <description>Quote Complete Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/HP_Quote_Complete_Notification</template>
    </alerts>
    <alerts>
        <fullName>Quote_Pricing_Escalation_Notification</fullName>
        <description>Quote Pricing Escalation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sfdc.support@hp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HP_Templates/HP_Quote_Pricing_Escalation_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Compass_ES</fullName>
        <description>Updates the Record type from HP Quote to Compass ES</description>
        <field>RecordTypeId</field>
        <lookupValue>Compass_ES</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Compass ES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eclipse</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Eclipse</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Eclipse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HP_Quot_for_SAP_O_C</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAP_O_C</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HP Quot for SAP O&amp;C</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HP_Quote_Header_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Quote_Header</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HP Quote Header Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HP_Quote_Summary_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Quote_Summary</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HP Quote Summary Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HP_Quote_for_BMI</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BMI_Quote</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>HP Quote for BMI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAP_Compass</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAP_Compass</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAP Compass</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Requester_Email_Filed_Update</fullName>
        <description>Support Requester Email filed is updated to send the email notification to the sales rep befor the quote end dat</description>
        <field>Requestor_Email__c</field>
        <formula>Support_Request__r.Requestor_email__c</formula>
        <name>Support Requester Email Filed Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Watson_OR_CCA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Watson_CCA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Watson OR CCA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HP Detail Quote for SAP O%26C</fullName>
        <actions>
            <name>HP_Quot_for_SAP_O_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>SAP O&amp;C</value>
        </criteriaItems>
        <description>Change record type of HP Quote to SAP O&amp;C when Originating System = SAP O&amp;C.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote Complete Notification</fullName>
        <actions>
            <name>Quote_Complete_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Quote_Status_Update_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HP_Quote__c.Quote_Status__c</field>
            <operation>equals</operation>
            <value>Quote Complete</value>
        </criteriaItems>
        <description>Send notification email to the sales rep when quote is completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote Expiration Email Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Synced_To_Opportunity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HP_Quote__c.Hide_Record__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>HP Not Pursued,&quot;06 - Won, Deploy &amp; Expand&quot;,Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>HP_Quote__c.Quote_End_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Send an email to the opportunity owner on the quote to send an email 7 days before quote end date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HP_Quote_Expiration_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HP_Quote__c.Quote_End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HP Quote Header Status Update</fullName>
        <actions>
            <name>HP_Quote_Header_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>HP_Quote__c.Quote_Status__c</field>
            <operation>notEqual</operation>
            <value>Quote Complete</value>
        </criteriaItems>
        <description>Change record type of HP Quote to Quote Header when Status &lt;&gt; Quote Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote Pricing Escalation Notification</fullName>
        <actions>
            <name>Quote_Pricing_Escalation_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Quote_Status__c</field>
            <operation>equals</operation>
            <value>Special Pricing Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Quote_Status_Update_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>‎If status is Special pricing and notification flag is true than opty owner and requestor will get the email notification.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote Requestor Email Update</fullName>
        <actions>
            <name>Support_Requester_Email_Filed_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Requestor email Id</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote Summary Status Update</fullName>
        <actions>
            <name>HP_Quote_Summary_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>HP_Quote__c.Quote_Status__c</field>
            <operation>equals</operation>
            <value>Quote Complete</value>
        </criteriaItems>
        <description>Change record type of HP Quote to Quote Summary when Status =  Quote Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for BMI</fullName>
        <actions>
            <name>HP_Quote_for_BMI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>BMI</value>
        </criteriaItems>
        <description>Change record type of HP Quote to BMI Quote when Originating System  =  BMI</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for Compass ES</fullName>
        <actions>
            <name>Compass_ES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>Compass ES</value>
        </criteriaItems>
        <description>Change record type of HP Quote to Compass ES when Originating System = Compass ES</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for Eclipse</fullName>
        <actions>
            <name>Eclipse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>Eclipse</value>
        </criteriaItems>
        <description>Change the record type from HP Quote to Eclipse when Originating System = Eclipse</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for O %26 C</fullName>
        <actions>
            <name>SAP_Compass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>O &amp; C</value>
        </criteriaItems>
        <description>Change record type of HP Quote to O &amp; C when Originating System = O &amp; C</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for SAP Compass</fullName>
        <actions>
            <name>SAP_Compass</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>EG SAP</value>
        </criteriaItems>
        <description>Change record type of HP Quote to SAP Compass when Originating System = EG SAP</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HP Quote for Watson or CCA</fullName>
        <actions>
            <name>Watson_OR_CCA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>Watson</value>
        </criteriaItems>
        <criteriaItems>
            <field>HP_Quote__c.Originating_Quote_System__c</field>
            <operation>equals</operation>
            <value>ePrime</value>
        </criteriaItems>
        <description>Change the record type from HP Quote to Watson &amp; CCA when Originating System = Watson or ePrime</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
