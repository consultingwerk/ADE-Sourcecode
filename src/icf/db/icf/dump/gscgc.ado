<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="1" version_date="02/23/2002" version_time="42930" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000379.09" record_version_obj="3000000380.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600111.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCGC" DateCreated="02/23/2002" TimeCreated="11:55:30" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCGC</dataset_code>
<dataset_description>gsc_global_control - Global Control</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600112.08</dataset_entity_obj>
<deploy_dataset_obj>1007600111.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCGC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>global_control_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_global_control</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_global_control</name>
<dbname>ICFDB</dbname>
<index-1>XPKgsc_global_control,1,1,0,global_control_obj,0</index-1>
<field><name>global_control_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Global Control Obj</label>
<column-label>Global Control Obj</column-label>
</field>
<field><name>default_country_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Default Country Obj</label>
<column-label>Default Country Obj</column-label>
</field>
<field><name>default_nationality_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Default Nationality Obj</label>
<column-label>Default Nationality Obj</column-label>
</field>
<field><name>default_language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Default Language Obj</label>
<column-label>Default Language Obj</column-label>
</field>
<field><name>default_currency_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Default Currency Obj</label>
<column-label>Default Currency Obj</column-label>
</field>
<field><name>date_format</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Date Format</label>
<column-label>Date Format</column-label>
</field>
<field><name>date_format_mask</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Date Format Mask</label>
<column-label>Date Format Mask</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_global_control"><global_control_obj>1003545208</global_control_obj>
<default_country_obj>867</default_country_obj>
<default_nationality_obj>487</default_nationality_obj>
<default_language_obj>426</default_language_obj>
<default_currency_obj>870</default_currency_obj>
<date_format>mdy</date_format>
<date_format_mask>99/99/9999</date_format_mask>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>