<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="14" version_date="02/23/2002" version_time="47890" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000001561.09" record_version_obj="3000001562.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600079.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RYCST" DateCreated="02/23/2002" TimeCreated="13:18:09" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RYCST</dataset_code>
<dataset_description>ryc_smartlink_type - SmartLinks</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600080.08</dataset_entity_obj>
<deploy_dataset_obj>1007600079.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RYCST</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>link_name</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>ryc_smartlink_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>ryc_smartlink_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1ryc_smartlink_type,1,0,0,link_name,0</index-1>
<index-2>XPKryc_smartlink_type,1,1,0,smartlink_type_obj,0</index-2>
<field><name>smartlink_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Smartlink Type Obj</label>
<column-label>Smartlink Type Obj</column-label>
</field>
<field><name>link_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Link Name</label>
<column-label>Link Name</column-label>
</field>
<field><name>used_defined_link</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Used Defined Link</label>
<column-label>Used Defined Link</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003183649</smartlink_type_obj>
<link_name>Data</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003183650</smartlink_type_obj>
<link_name>Update</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003183651</smartlink_type_obj>
<link_name>Navigation</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003202300</smartlink_type_obj>
<link_name>Page</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003518015</smartlink_type_obj>
<link_name>ToggleData</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003518046</smartlink_type_obj>
<link_name>TableIO</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003543798</smartlink_type_obj>
<link_name>Toolbar</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003578295</smartlink_type_obj>
<link_name>PrimarySdo</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003585634</smartlink_type_obj>
<link_name>User1</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003585635</smartlink_type_obj>
<link_name>User2</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="11"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1003598458</smartlink_type_obj>
<link_name>GroupAssign</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="12"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1004947046.09</smartlink_type_obj>
<link_name>Commit</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="13"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1005118281.101</smartlink_type_obj>
<link_name>TreeFilter</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>no</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="14"><contained_record DB="ICFDB" Table="ryc_smartlink_type"><smartlink_type_obj>1008000212.09</smartlink_type_obj>
<link_name>Filter</link_name>
<used_defined_link>no</used_defined_link>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>