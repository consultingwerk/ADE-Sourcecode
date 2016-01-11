<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="4"><dataset_header DisableRI="yes" DatasetObj="3000005364.09" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCLS" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>3000005364.09</deploy_dataset_obj>
<dataset_code>GSCLS</dataset_code>
<dataset_description>gsc_logical_service - Logical Services</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>gscls.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>3000005365.09</dataset_entity_obj>
<deploy_dataset_obj>3000005364.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCLS</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>logical_service_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsc_logical_service</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_logical_service</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_logical_service,1,0,0,logical_service_code,0</index-1>
<index-2>XIE1gsc_logical_service,0,0,0,logical_service_description,0</index-2>
<index-3>XIE2gsc_logical_service,0,0,0,service_type_obj,0</index-3>
<index-4>XPKgsc_logical_service,1,1,0,logical_service_obj,0</index-4>
<field><name>logical_service_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Logical service obj</label>
<column-label>Logical service obj</column-label>
</field>
<field><name>logical_service_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(20)</format>
<initial></initial>
<label>Logical service code</label>
<column-label>Logical service code</column-label>
</field>
<field><name>logical_service_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Logical service description</label>
<column-label>Logical service description</column-label>
</field>
<field><name>service_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Service type obj</label>
<column-label>Service type obj</column-label>
</field>
<field><name>can_run_locally</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Can run locally</label>
<column-label>Can run locally</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>write_to_config</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Write to config</label>
<column-label>Write to config</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="03/01/2002" version_time="55667" version_user="admin" deletion_flag="yes" entity_mnemonic="gscls" key_field_value="1004947456.09" record_version_obj="3000001848.09" version_number_seq="1.09" secondary_key_value="RVDB" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_logical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSCLS" key_field_value="1004947455.09" record_version_obj="3000059016.09" version_number_seq="1.09" secondary_key_value="Astra" import_version_number_seq="1.09"><logical_service_obj>1004947455.09</logical_service_obj>
<logical_service_code>Astra</logical_service_code>
<logical_service_description>Dynamics AppServer Partition</logical_service_description>
<service_type_obj>1004947358.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_logical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSCLS" key_field_value="1004947458.09" record_version_obj="3000059017.09" version_number_seq="1.09" secondary_key_value="ICFDB" import_version_number_seq="1.09"><logical_service_obj>1004947458.09</logical_service_obj>
<logical_service_code>ICFDB</logical_service_code>
<logical_service_description>Application Framework Database</logical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_logical_service" version_date="10/02/2003" version_time="49466" version_user="admin" deletion_flag="no" entity_mnemonic="GSCLS" key_field_value="1007600070.09" record_version_obj="3000059018.09" version_number_seq="1.09" secondary_key_value="RTB" import_version_number_seq="1.09"><logical_service_obj>1007600070.09</logical_service_obj>
<logical_service_code>RTB</logical_service_code>
<logical_service_description>Roundtable Database</logical_service_description>
<service_type_obj>1004947359.09</service_type_obj>
<can_run_locally>yes</can_run_locally>
<system_owned>yes</system_owned>
<write_to_config>yes</write_to_config>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>