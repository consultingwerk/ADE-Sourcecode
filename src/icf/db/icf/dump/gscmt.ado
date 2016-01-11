<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="7" version_date="02/23/2002" version_time="42936" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000391.09" record_version_obj="3000000392.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600130.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCMT" DateCreated="02/23/2002" TimeCreated="11:55:35" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600130.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCMT</dataset_code>
<dataset_description>gsc_manager_type - Manager Types</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
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
<entity_mnemonic_description>gsc_manager_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_manager_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_manager_type,1,0,0,manager_type_code,0</index-1>
<index-2>XIE1gsc_manager_type,0,0,0,manager_type_name,0</index-2>
<index-3>XPKgsc_manager_type,1,1,0,manager_type_obj,0</index-3>
<field><name>manager_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
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
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947362.09</manager_type_obj>
<manager_type_code>ConnectionManager</manager_type_code>
<manager_type_name>Connection Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>NON</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947428.09</manager_type_obj>
<manager_type_code>SessionManager</manager_type_code>
<manager_type_name>Session Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>SM</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947429.09</manager_type_obj>
<manager_type_code>SecurityManager</manager_type_code>
<manager_type_name>Security Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>SEM</static_handle>
<manager_narration>Some stuff</manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947430.09</manager_type_obj>
<manager_type_code>ProfileManager</manager_type_code>
<manager_type_name>Profile Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>PM</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947431.09</manager_type_obj>
<manager_type_code>RepositoryManager</manager_type_code>
<manager_type_name>Repository Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>RM</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947432.09</manager_type_obj>
<manager_type_code>LocalizationManager</manager_type_code>
<manager_type_name>Localization Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>TM</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_manager_type"><manager_type_obj>1004947448.09</manager_type_obj>
<manager_type_code>GeneralManager</manager_type_code>
<manager_type_name>General Manager</manager_type_name>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
<static_handle>GM</static_handle>
<manager_narration></manager_narration>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>