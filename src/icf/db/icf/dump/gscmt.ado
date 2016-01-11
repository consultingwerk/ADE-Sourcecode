<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="12"><dataset_header DisableRI="yes" DatasetObj="1007600130.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCMT" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<dataset_code>GSCMT</dataset_code>
<dataset_description>gsc_manager_type - Manager Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600131.08</dataset_entity_obj>
<deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>manager_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_manager_type</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_manager_type</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_manager_type,1,0,0,manager_type_code,0</index-1>
<index-2>XIE1gsc_manager_type,0,0,0,manager_type_name,0</index-2>
<index-3>XPKgsc_manager_type,1,1,0,manager_type_obj,0</index-3>
<field><name>manager_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Manager Type Obj</label>
<column-label>Manager Type Obj</column-label>
</field>
<field><name>manager_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Manager Type Code</label>
<column-label>Manager Type Code</column-label>
</field>
<field><name>manager_type_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Manager Type Name</label>
<column-label>Manager Type Name</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>write_to_config</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Write to Config</label>
<column-label>Write to Config</column-label>
</field>
<field><name>static_handle</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Static Handle</label>
<column-label>Static Handle</column-label>
</field>
<field><name>manager_narration</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Manager Narration</label>
<column-label>Manager Narration</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947362.09" record_version_obj="13753.0766" version_number_seq="1.09" secondary_key_value="ConnectionManager" import_version_number_seq="1.09"><manager_type_obj>1004947362.09</manager_type_obj>
<manager_type_code>ConnectionManager</manager_type_code>
<manager_type_name>Connection Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration>This Manager is responsible for establishing and maintaining connections to 
services, such as AppServers, JMS Servers, Databases and others.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947428.09" record_version_obj="13760.0766" version_number_seq="1.09" secondary_key_value="SessionManager" import_version_number_seq="1.09"><manager_type_obj>1004947428.09</manager_type_obj>
<manager_type_code>SessionManager</manager_type_code>
<manager_type_name>Session Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>SM</static_handle>
<manager_narration>This Manager maintains context between requests for session wide properties 
such as user login information, to support a stateless environment.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947429.09" record_version_obj="13759.0766" version_number_seq="1.09" secondary_key_value="SecurityManager" import_version_number_seq="1.09"><manager_type_obj>1004947429.09</manager_type_obj>
<manager_type_code>SecurityManager</manager_type_code>
<manager_type_name>Security Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>SEM</static_handle>
<manager_narration>This manager is used for performing security checks supported by Dynamics.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947430.09" record_version_obj="13756.0766" version_number_seq="1.09" secondary_key_value="ProfileManager" import_version_number_seq="1.09"><manager_type_obj>1004947430.09</manager_type_obj>
<manager_type_code>ProfileManager</manager_type_code>
<manager_type_name>Profile Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>PM</static_handle>
<manager_narration>This Manager controls user profile functions/procedures supported by the 
framework.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947431.09" record_version_obj="13757.0766" version_number_seq="1.09" secondary_key_value="RepositoryManager" import_version_number_seq="1.09"><manager_type_obj>1004947431.09</manager_type_obj>
<manager_type_code>RepositoryManager</manager_type_code>
<manager_type_name>Repository Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>RM</static_handle>
<manager_narration>This Manager controls all repository-based access for the building of 
dynamic objects by the framework.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947432.09" record_version_obj="13755.0766" version_number_seq="1.09" secondary_key_value="LocalizationManager" import_version_number_seq="1.09"><manager_type_obj>1004947432.09</manager_type_obj>
<manager_type_code>LocalizationManager</manager_type_code>
<manager_type_name>Localization Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>TM</static_handle>
<manager_narration>This Manager controls local settings supported by Dynamics eg. Translation.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="1004947448.09" record_version_obj="13754.0766" version_number_seq="1.09" secondary_key_value="GeneralManager" import_version_number_seq="1.09"><manager_type_obj>1004947448.09</manager_type_obj>
<manager_type_code>GeneralManager</manager_type_code>
<manager_type_name>General Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>GM</static_handle>
<manager_narration>Used for useful utility procedures that can be used by various components of 
any application and that do not fit logically into any of the other Dynamics 
managers.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="3000000308.09" record_version_obj="3000000309.09" version_number_seq="5.09" secondary_key_value="UserInterfaceManager" import_version_number_seq="5.09"><manager_type_obj>3000000308.09</manager_type_obj>
<manager_type_code>UserInterfaceManager</manager_type_code>
<manager_type_name>User Interface Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration>This Manager generates all dynamic UI objects and data  for export to the web 
browser. It delivers all the information required for the client to draw the UI and 
control the run-time execution of an application developed using the
Dynamics framework.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="3000000310.09" record_version_obj="3000000311.09" version_number_seq="4.09" secondary_key_value="RequestManager" import_version_number_seq="4.09"><manager_type_obj>3000000310.09</manager_type_obj>
<manager_type_code>RequestManager</manager_type_code>
<manager_type_name>Request Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration>This Manager is the single point of entry for all web requests received by the 
Agent.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="3000000312.09" record_version_obj="3000000313.09" version_number_seq="4.09" secondary_key_value="CustomizationManager" import_version_number_seq="4.09"><manager_type_obj>3000000312.09</manager_type_obj>
<manager_type_code>CustomizationManager</manager_type_code>
<manager_type_name>Customization Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration>The customization manager is an optional manager that may be used to 
perform run-time customizations. It should always be loaded on an 
AppServer and loaded on a client as required.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="06/17/2002" version_time="49287" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="3000000378.09" record_version_obj="3000000379.09" version_number_seq="2.09" secondary_key_value="RepositoryDesignManager" import_version_number_seq="2.09"><manager_type_obj>3000000378.09</manager_type_obj>
<manager_type_code>RepositoryDesignManager</manager_type_code>
<manager_type_name>Repository Design Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration>This manager is required to support a Dynamics design session.</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_manager_type" version_date="03/07/2003" version_time="63468" version_user="admin" deletion_flag="no" entity_mnemonic="gscmt" key_field_value="3000005352.09" record_version_obj="13758.0766" version_number_seq="1.09" secondary_key_value="RIManager" import_version_number_seq="1.09"><manager_type_obj>3000005352.09</manager_type_obj>
<manager_type_code>RIManager</manager_type_code>
<manager_type_name>Referential Integrity Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>RI</static_handle>
<manager_narration>This Manager contains code that supports various functions that need to be 
available for the schema triggers to execute.</manager_narration>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>