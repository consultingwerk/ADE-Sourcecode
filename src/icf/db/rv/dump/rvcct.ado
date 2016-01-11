<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="2"><dataset_header DisableRI="yes" DatasetObj="1000000152.39" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="RVCCT" DateCreated="02/14/2002" TimeCreated="11:19:23" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1000000152.39</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>RVCCT</dataset_code>
<dataset_description>rvc_configuration_type</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1000000154.39</dataset_entity_obj>
<deploy_dataset_obj>1000000152.39</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>RVCCT</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>configuration_type</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>no</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>rvc_configuration_type</entity_mnemonic_description>
<entity_dbname>rvdb</entity_dbname>
</dataset_entity>
<table_definition><name>rvc_configuration_type</name>
<dbname>RVDB</dbname>
<index-1>XAK1rvc_configuration_type,1,0,0,type_table_name,0</index-1>
<index-2>XAK2rvc_configuration_type,1,0,0,configuration_type_obj,0</index-2>
<index-3>XIE1rvc_configuration_type,0,0,0,type_description,0</index-3>
<index-4>XPKrvc_configuration_type,1,1,0,configuration_type,0</index-4>
<field><name>configuration_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Configuration Type</label>
<column-label>Configuration Type</column-label>
</field>
<field><name>type_table_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Type Table Name</label>
<column-label>Type Table Name</column-label>
</field>
<field><name>type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Type Description</label>
<column-label>Type Description</column-label>
</field>
<field><name>type_locked</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Type Locked</label>
<column-label>Type Locked</column-label>
</field>
<field><name>type_deployable</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Type Deployable</label>
<column-label>Type Deployable</column-label>
</field>
<field><name>baseline_frequency</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->9</format>
<initial>  0</initial>
<label>Baseline Frequency</label>
<column-label>Baseline Frequency</column-label>
</field>
<field><name>scm_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Scm Code</label>
<column-label>Scm Code</column-label>
</field>
<field><name>scm_identifying_fieldname</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Scm Identifying Fieldname</label>
<column-label>Scm Identifying Fieldname</column-label>
</field>
<field><name>scm_primary_key_fields</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Scm Primary Key Fields</label>
<column-label>Scm Primary Key Fields</column-label>
</field>
<field><name>description_fieldname</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Description Fieldname</label>
<column-label>Description Fieldname</column-label>
</field>
<field><name>product_module_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Product Module Obj</label>
<column-label>Product Module Obj</column-label>
</field>
<field><name>product_module_fieldname</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Product Module Fieldname</label>
<column-label>Product Module Fieldname</column-label>
</field>
<field><name>configuration_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Configuration Type Obj</label>
<column-label>Configuration Type Obj</column-label>
</field>
<field><name>dataset_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Dataset Code</label>
<column-label>Dataset Code</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="RVDB" Table="rvc_configuration_type"><configuration_type>rrr</configuration_type>
<type_table_name>tt`</type_table_name>
<type_description>ttttt</type_description>
<type_locked>yes</type_locked>
<type_deployable>yes</type_deployable>
<baseline_frequency>0</baseline_frequency>
<scm_code>rt</scm_code>
<scm_identifying_fieldname>tre</scm_identifying_fieldname>
<scm_primary_key_fields>retret</scm_primary_key_fields>
<description_fieldname>rt</description_fieldname>
<product_module_obj>0</product_module_obj>
<product_module_fieldname>r</product_module_fieldname>
<configuration_type_obj>1004944354.09</configuration_type_obj>
<dataset_code>r</dataset_code>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="RVDB" Table="rvc_configuration_type"><configuration_type>RYCSO</configuration_type>
<type_table_name>ryc_smartobject</type_table_name>
<type_description>ICF Repository Smartobjects</type_description>
<type_locked>no</type_locked>
<type_deployable>yes</type_deployable>
<baseline_frequency>0</baseline_frequency>
<scm_code>LSmartObject</scm_code>
<scm_identifying_fieldname>object_filename</scm_identifying_fieldname>
<scm_primary_key_fields>smartobject_obj</scm_primary_key_fields>
<description_fieldname>object_filename</description_fieldname>
<product_module_obj>0</product_module_obj>
<product_module_fieldname>product_module_obj</product_module_fieldname>
<configuration_type_obj>1003183433</configuration_type_obj>
<dataset_code>RYCSO</dataset_code>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>