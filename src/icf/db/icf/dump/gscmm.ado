<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="1" version_date="02/23/2002" version_time="42935" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000389.09" record_version_obj="3000000390.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600194.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCMM" DateCreated="02/23/2002" TimeCreated="11:55:35" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCMM</dataset_code>
<dataset_description>gsc_multi_media_type - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600195.08</dataset_entity_obj>
<deploy_dataset_obj>1007600194.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_type_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_multi_media_type</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_multi_media_type</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_multi_media_type,1,0,0,multi_media_type_code,0</index-1>
<index-2>XIE1gsc_multi_media_type,0,0,0,multi_media_type_description,0</index-2>
<index-3>XPKgsc_multi_media_type,1,1,0,multi_media_type_obj,0</index-3>
<field><name>multi_media_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Multi Media Type Obj</label>
<column-label>Multi Media Type Obj</column-label>
</field>
<field><name>multi_media_type_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Multi Media Type Code</label>
<column-label>Multi Media Type Code</column-label>
</field>
<field><name>multi_media_type_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Multi Media Type Description</label>
<column-label>Multi Media Type Description</column-label>
</field>
<field><name>application_launch_command</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Application Launch Command</label>
<column-label>Application Launch Command</column-label>
</field>
<field><name>file_extension</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>File Extension</label>
<column-label>File Extension</column-label>
</field>
<field><name>template_extension</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Template Extension</label>
<column-label>Template Extension</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_multi_media_type"><multi_media_type_obj>1005100225.101</multi_media_type_obj>
<multi_media_type_code>TVIMG</multi_media_type_code>
<multi_media_type_description>Tree View Image Files</multi_media_type_description>
<application_launch_command></application_launch_command>
<file_extension>ICO</file_extension>
<template_extension></template_extension>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>