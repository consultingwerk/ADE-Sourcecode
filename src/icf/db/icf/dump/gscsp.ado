<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="9" version_date="02/23/2002" version_time="43009" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000405.09" record_version_obj="3000000406.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600138.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSP" DateCreated="02/23/2002" TimeCreated="11:56:49" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCSP</dataset_code>
<dataset_description>gsc_session_property - Session Prop</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600139.08</dataset_entity_obj>
<deploy_dataset_obj>1007600138.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSP</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>session_property_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_session_property</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_session_property</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_session_property,1,0,0,session_property_name,0</index-1>
<index-2>XPKgsc_session_property,1,1,0,session_property_obj,0</index-2>
<field><name>session_property_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Session Property Obj</label>
<column-label>Session Property Obj</column-label>
</field>
<field><name>session_property_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Session Property Name</label>
<column-label>Session Property Name</column-label>
</field>
<field><name>session_property_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Session Property Description</label>
<column-label>Session Property Description</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>default_property_value</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Default Property Value</label>
<column-label>Default Property Value</column-label>
</field>
<field><name>always_used</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Always Used</label>
<column-label>Always Used</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004955828.09</session_property_obj>
<session_property_name>session_date_format</session_property_name>
<session_property_description>Session Date Format</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>mdy</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004955844.09</session_property_obj>
<session_property_name>run_local</session_property_name>
<session_property_description>Should this session run locally?</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>no</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004955845.09</session_property_obj>
<session_property_name>session_year_offset</session_property_name>
<session_property_description>Session year offset attribute</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>1950</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956478.09</session_property_obj>
<session_property_name>session_propath</session_property_name>
<session_property_description>Propath</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>.,d:\workarea\possenet\posseicf,d:\workarea\possenet\posseicf\icf,d:\workarea\possenet\posseicf\icf\sup2,d:\workarea\possenet\posseicf\src,$PROPATH</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956479.09</session_property_obj>
<session_property_name>session_debug_alert</session_property_name>
<session_property_description>Debug Alert</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>no</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956480.09</session_property_obj>
<session_property_name>session_time_source</session_property_name>
<session_property_description>Session Time Source</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>LOCAL</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956481.09</session_property_obj>
<session_property_name>session_tooltips</session_property_name>
<session_property_description>Session Tooltips</session_property_description>
<system_owned>yes</system_owned>
<default_property_value>YES</default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956689.09</session_property_obj>
<session_property_name>startup_procedure</session_property_name>
<session_property_description>Startup Procedure</session_property_description>
<system_owned>yes</system_owned>
<default_property_value></default_property_value>
<always_used>no</always_used>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="gsc_session_property"><session_property_obj>1004956778.09</session_property_obj>
<session_property_name>root_directory</session_property_name>
<session_property_description>Root Directory</session_property_description>
<system_owned>no</system_owned>
<default_property_value>.</default_property_value>
<always_used>yes</always_used>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>