<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="1" version_date="02/23/2002" version_time="42934" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000383.09" record_version_obj="3000000384.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600162.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCIA" DateCreated="02/23/2002" TimeCreated="11:55:33" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCIA</dataset_code>
<dataset_description>gsc_instance_attribute - Inst Attr</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600163.08</dataset_entity_obj>
<deploy_dataset_obj>1007600162.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>attribute_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_instance_attribute</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_instance_attribute</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_instance_attribute,1,0,0,attribute_code,0</index-1>
<index-2>XAK2gsc_instance_attribute,1,0,0,attribute_type,0,attribute_code,0</index-2>
<index-3>XIE1gsc_instance_attribute,0,0,0,attribute_description,0</index-3>
<index-4>XPKgsc_instance_attribute,1,1,0,instance_attribute_obj,0</index-4>
<field><name>instance_attribute_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Instance Attribute Obj</label>
<column-label>Instance Attribute Obj</column-label>
</field>
<field><name>attribute_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Attribute Code</label>
<column-label>Attribute Code</column-label>
</field>
<field><name>attribute_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Attribute Description</label>
<column-label>Attribute Description</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>attribute_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Attribute Type</label>
<column-label>Attribute Type</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_instance_attribute"><instance_attribute_obj>1003576832</instance_attribute_obj>
<attribute_code>Join rycag-rycat</attribute_code>
<attribute_description>^attribute_group_obj,attribute_group_obj</attribute_description>
<disabled>no</disabled>
<system_owned>no</system_owned>
<attribute_type>MEN</attribute_type>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>