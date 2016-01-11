<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="6"><dataset_header DisableRI="yes" DatasetObj="3000004885.09" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCCY" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<dataset_code>RYCCY</dataset_code>
<dataset_description>ryc_customization</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename>ryccy.ado</default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>3000004887.09</dataset_entity_obj>
<deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>customization_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_customization_type</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000004889.09</dataset_entity_obj>
<deploy_dataset_obj>3000004885.09</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>RYCCR</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>RYCCY</join_entity_mnemonic>
<join_field_list>customization_type_obj,customization_type_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>ryc_customization_result</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_customization_type</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_customization_type,1,0,0,customization_type_code,0</index-1>
<index-2>XIE1ryc_customization_type,0,0,0,customization_type_desc,0</index-2>
<index-3>XPKryc_customization_type,1,1,0,customization_type_obj,0</index-3>
<field><name>customization_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Customization type obj</label>
<column-label>Customization type obj</column-label>
</field>
<field><name>customization_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Customization type code</label>
<column-label>Customization type code</column-label>
</field>
<field><name>customization_type_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Customization type desc</label>
<column-label>Customization type desc</column-label>
</field>
<field><name>api_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Api name</label>
<column-label>Api name</column-label>
</field>
</table_definition>
<table_definition><name>ryc_customization_result</name>
<dbname>icfdb</dbname>
<index-1>XAK1ryc_customization_result,1,0,0,customization_result_code,0</index-1>
<index-2>XIE1ryc_customization_result,0,0,0,customization_result_desc,0</index-2>
<index-3>XIE2ryc_customization_result,0,0,0,customization_type_obj,0</index-3>
<index-4>XPKryc_customization_result,1,1,0,customization_result_obj,0</index-4>
<field><name>customization_result_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Customization result obj</label>
<column-label>Customization result obj</column-label>
</field>
<field><name>customization_result_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Customization result code</label>
<column-label>Customization result code</column-label>
</field>
<field><name>customization_result_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Customization result desc</label>
<column-label>Customization result desc</column-label>
</field>
<field><name>customization_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Customization type obj</label>
<column-label>Customization type obj</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11584.24</customization_type_obj>
<customization_type_code>UIType</customization_type_code>
<customization_type_desc>User Interface Type</customization_type_desc>
<api_name>getReferenceUIType</api_name>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11612.24</customization_result_obj>
<customization_result_code>APP</customization_result_code>
<customization_result_desc>AppServer</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11613.24</customization_result_obj>
<customization_result_code>BTC</customization_result_code>
<customization_result_desc>Batch</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11614.24</customization_result_obj>
<customization_result_code>CUI</customization_result_code>
<customization_result_desc>Character UI</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11615.24</customization_result_obj>
<customization_result_code>GUI</customization_result_code>
<customization_result_desc>Graphical UI</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11616.24</customization_result_obj>
<customization_result_code>WBC</customization_result_code>
<customization_result_desc>WebClient</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
<contained_record DB="icfdb" Table="ryc_customization_result"><customization_result_obj>11617.24</customization_result_obj>
<customization_result_code>WBS</customization_result_code>
<customization_result_desc>WebSpeed</customization_result_desc>
<customization_type_obj>11584.24</customization_type_obj>
<system_owned>no</system_owned>
</contained_record>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11607.24</customization_type_obj>
<customization_type_code>Language</customization_type_code>
<customization_type_desc>Language</customization_type_desc>
<api_name>getReferenceLanguage</api_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11608.24</customization_type_obj>
<customization_type_code>LoginCompany</customization_type_code>
<customization_type_desc>Login Company</customization_type_desc>
<api_name>getReferenceLoginCompany</api_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11609.24</customization_type_obj>
<customization_type_code>System</customization_type_code>
<customization_type_desc>System</customization_type_desc>
<api_name>getReferenceSystem</api_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11610.24</customization_type_obj>
<customization_type_code>User</customization_type_code>
<customization_type_desc>User</customization_type_desc>
<api_name>getReferenceUser</api_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="ryc_customization_type"><customization_type_obj>11611.24</customization_type_obj>
<customization_type_code>UserCategory</customization_type_code>
<customization_type_desc>User Category</customization_type_desc>
<api_name>getReferenceUserCategory</api_name>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>