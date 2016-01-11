<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="1" version_date="02/23/2002" version_time="42935" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000387.09" record_version_obj="3000000388.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600119.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCLG" DateCreated="02/23/2002" TimeCreated="11:55:34" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCLG</dataset_code>
<dataset_description>gsc_language - Languages</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600120.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCLG</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>language_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_language</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600121.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSMTL</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_translation</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600122.08</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>3</entity_sequence>
<entity_mnemonic>GSCLT</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_language_text</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_language</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_language,1,0,0,language_code,0</index-1>
<index-2>XIE1gsc_language,0,0,0,language_name,0</index-2>
<index-3>XPKgsc_language,1,1,0,language_obj,0</index-3>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Language Obj</label>
<column-label>Language Obj</column-label>
</field>
<field><name>language_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Language Code</label>
<column-label>Language Code</column-label>
</field>
<field><name>language_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Language Name</label>
<column-label>Language Name</column-label>
</field>
<field><name>person_title1_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person Title1 Label</label>
<column-label>Person Title1 Label</column-label>
</field>
<field><name>person_title2_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person Title2 Label</label>
<column-label>Person Title2 Label</column-label>
</field>
<field><name>person_title3_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person Title3 Label</label>
<column-label>Person Title3 Label</column-label>
</field>
</table_definition>
<table_definition><name>gsm_translation</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_translation,1,0,0,object_filename,0,widget_type,0,widget_name,0,widget_entry,0,language_obj,0</index-1>
<index-2>XAK2gsm_translation,1,0,0,language_obj,0,object_filename,0,widget_type,0,widget_name,0,widget_entry,0</index-2>
<index-3>XIE1gsm_translation,0,0,0,widget_name,0,widget_entry,0,object_filename,0,language_obj,0,widget_type,0</index-3>
<index-4>XPKgsm_translation,1,1,0,translation_obj,0</index-4>
<field><name>translation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Translation Obj</label>
<column-label>Translation Obj</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Language Obj</label>
<column-label>Language Obj</column-label>
</field>
<field><name>object_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object Filename</label>
<column-label>Object Filename</column-label>
</field>
<field><name>widget_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Widget Type</label>
<column-label>Widget Type</column-label>
</field>
<field><name>widget_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Widget Name</label>
<column-label>Widget Name</column-label>
</field>
<field><name>widget_entry</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->9</format>
<initial>  0</initial>
<label>Widget Entry</label>
<column-label>Widget Entry</column-label>
</field>
<field><name>original_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Original Label</label>
<column-label>Original Label</column-label>
</field>
<field><name>translation_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Translation Label</label>
<column-label>Translation Label</column-label>
</field>
<field><name>original_tooltip</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Original Tooltip</label>
<column-label>Original Tooltip</column-label>
</field>
<field><name>translation_tooltip</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Translation Tooltip</label>
<column-label>Translation Tooltip</column-label>
</field>
</table_definition>
<table_definition><name>gsc_language_text</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_language_text,1,0,0,category_obj,0,owning_obj,0,language_obj,0,text_tla,0</index-1>
<index-2>XIE1gsc_language_text,0,0,0,search_string,0</index-2>
<index-3>XPKgsc_language_text,1,1,0,language_text_obj,0</index-3>
<field><name>language_text_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Language Text Obj</label>
<column-label>Language Text Obj</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Owning Obj</label>
<column-label>Owning Obj</column-label>
</field>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Category Obj</label>
<column-label>Category Obj</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Language Obj</label>
<column-label>Language Obj</column-label>
</field>
<field><name>text_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Text TLA</label>
<column-label>Text TLA</column-label>
</field>
<field><name>physical_file_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Physical File Name</label>
<column-label>Physical File Name</column-label>
</field>
<field><name>text_content</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Text Content</label>
<column-label>Text Content</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>max_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->>>>>>>9</format>
<initial>        0</initial>
<label>Max. Length</label>
<column-label>Max. Length</column-label>
</field>
<field><name>print_option_tlas</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Print Option TLAs</label>
<column-label>Print Option TLAs</column-label>
</field>
<field><name>search_string</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Search String</label>
<column-label>Search String</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_language"><language_obj>426</language_obj>
<language_code>English</language_code>
<language_name>English</language_name>
<person_title1_label></person_title1_label>
<person_title2_label></person_title2_label>
<person_title3_label></person_title3_label>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>