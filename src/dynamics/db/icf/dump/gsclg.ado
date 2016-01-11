<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="1"><dataset_header DisableRI="yes" DatasetObj="1007600119.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCLG" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<dataset_code>GSCLG</dataset_code>
<dataset_description>gsc_language - Languages</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsc_language</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_translation</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsc_language_text</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>3000031138.09</dataset_entity_obj>
<deploy_dataset_obj>1007600119.08</deploy_dataset_obj>
<entity_sequence>4</entity_sequence>
<entity_mnemonic>GSMTI</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCLG</join_entity_mnemonic>
<join_field_list>language_obj,language_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_translated_menu_item</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_language</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_language,1,0,0,language_code,0</index-1>
<index-2>XIE1gsc_language,0,0,0,language_name,0</index-2>
<index-3>XPKgsc_language,1,1,0,language_obj,0</index-3>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language obj</label>
<column-label>Language obj</column-label>
</field>
<field><name>language_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Language code</label>
<column-label>Language code</column-label>
</field>
<field><name>language_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Language name</label>
<column-label>Language name</column-label>
</field>
<field><name>person_title1_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person title1 label</label>
<column-label>Person title1 label</column-label>
</field>
<field><name>person_title2_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person title2 label</label>
<column-label>Person title2 label</column-label>
</field>
<field><name>person_title3_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Person title3 label</label>
<column-label>Person title3 label</column-label>
</field>
</table_definition>
<table_definition><name>gsm_translation</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_translation,1,0,0,object_filename,0,widget_type,0,widget_name,0,widget_entry,0,language_obj,0,source_language_obj,0</index-1>
<index-2>XAK2gsm_translation,1,0,0,source_language_obj,0,language_obj,0,object_filename,0,widget_type,0,widget_name,0,widget_entry,0</index-2>
<index-3>XIE1gsm_translation,0,0,0,widget_name,0,widget_entry,0,object_filename,0,source_language_obj,0,language_obj,0,widget_type,0</index-3>
<index-4>XIE2gsm_translation,0,0,0,language_obj,0</index-4>
<index-5>XPKgsm_translation,1,1,0,translation_obj,0</index-5>
<field><name>translation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Translation obj</label>
<column-label>Translation obj</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language obj</label>
<column-label>Language obj</column-label>
</field>
<field><name>object_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Object filename</label>
<column-label>Object filename</column-label>
</field>
<field><name>widget_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Widget type</label>
<column-label>Widget type</column-label>
</field>
<field><name>widget_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Widget name</label>
<column-label>Widget name</column-label>
</field>
<field><name>widget_entry</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Widget entry</label>
<column-label>Widget entry</column-label>
</field>
<field><name>original_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Original label</label>
<column-label>Original label</column-label>
</field>
<field><name>translation_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Translation label</label>
<column-label>Translation label</column-label>
</field>
<field><name>original_tooltip</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Original tooltip</label>
<column-label>Original tooltip</column-label>
</field>
<field><name>translation_tooltip</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Translation tooltip</label>
<column-label>Translation tooltip</column-label>
</field>
<field><name>source_language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Source language obj</label>
<column-label>Source language obj</column-label>
</field>
</table_definition>
<table_definition><name>gsc_language_text</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_language_text,1,0,0,category_obj,0,owning_obj,0,language_obj,0,text_tla,0</index-1>
<index-2>XIE1gsc_language_text,0,0,0,search_string,0</index-2>
<index-3>XPKgsc_language_text,1,1,0,language_text_obj,0</index-3>
<field><name>language_text_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language text obj</label>
<column-label>Language text obj</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Owning obj</label>
<column-label>Owning obj</column-label>
</field>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Category obj</label>
<column-label>Category obj</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language obj</label>
<column-label>Language obj</column-label>
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
<label>Physical file name</label>
<column-label>Physical file name</column-label>
</field>
<field><name>text_content</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3000)</format>
<initial></initial>
<label>Text content</label>
<column-label>Text content</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System owned</label>
<column-label>System owned</column-label>
</field>
<field><name>max_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Max. length</label>
<column-label>Max. length</column-label>
</field>
<field><name>print_option_tlas</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Print option TLAs</label>
<column-label>Print option TLAs</column-label>
</field>
<field><name>search_string</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Search string</label>
<column-label>Search string</column-label>
</field>
</table_definition>
<table_definition><name>gsm_translated_menu_item</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_translated_menu_item,1,0,0,menu_item_obj,0,language_obj,0</index-1>
<index-2>XIE1gsm_translated_menu_item,0,0,0,source_language_obj,0</index-2>
<index-3>XIE2gsm_translated_menu_item,0,0,0,language_obj,0</index-3>
<index-4>XPKgsm_translated_menu_item,1,1,0,translated_menu_item_obj,0</index-4>
<field><name>translated_menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Translated menu item obj</label>
<column-label>Translated menu item obj</column-label>
</field>
<field><name>menu_item_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Menu item obj</label>
<column-label>Menu item obj</column-label>
</field>
<field><name>source_language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Source language obj</label>
<column-label>Source language obj</column-label>
</field>
<field><name>language_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Language obj</label>
<column-label>Language obj</column-label>
</field>
<field><name>menu_item_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Menu item label</label>
<column-label>Menu item label</column-label>
</field>
<field><name>tooltip_text</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Tooltip text</label>
<column-label>Tooltip text</column-label>
</field>
<field><name>alternate_shortcut_key</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Alternate shortcut key</label>
<column-label>Alternate shortcut key</column-label>
</field>
<field><name>item_toolbar_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Item toolbar label</label>
<column-label>Item toolbar label</column-label>
</field>
<field><name>image1_up_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 up filename</label>
<column-label>Image1 up filename</column-label>
</field>
<field><name>image1_down_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 down filename</label>
<column-label>Image1 down filename</column-label>
</field>
<field><name>image1_insensitive_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image1 insensitive filename</label>
<column-label>Image1 insensitive filename</column-label>
</field>
<field><name>image2_up_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 up filename</label>
<column-label>Image2 up filename</column-label>
</field>
<field><name>image2_down_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 down filename</label>
<column-label>Image2 down filename</column-label>
</field>
<field><name>image2_insensitive_filename</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Image2 insensitive filename</label>
<column-label>Image2 insensitive filename</column-label>
</field>
<field><name>item_narration</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(500)</format>
<initial></initial>
<label>Item narration</label>
<column-label>Item narration</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_language" version_date="09/28/2002" version_time="29209" version_user="admin" deletion_flag="no" entity_mnemonic="gsclg" key_field_value="426" record_version_obj="3000033272.09" version_number_seq="1.09" secondary_key_value="EN-US" import_version_number_seq="1.09"><language_obj>426</language_obj>
<language_code>EN-US</language_code>
<language_name>English - United States</language_name>
<person_title1_label></person_title1_label>
<person_title2_label></person_title2_label>
<person_title3_label></person_title3_label>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>