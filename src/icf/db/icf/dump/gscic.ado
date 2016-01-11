<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="4" version_date="02/23/2002" version_time="42934" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000385.09" record_version_obj="3000000386.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600151.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCIC" DateCreated="02/23/2002" TimeCreated="11:55:34" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSCIC</dataset_code>
<dataset_description>gsc_item_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600152.08</dataset_entity_obj>
<deploy_dataset_obj>1007600151.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCIC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>item_category_label</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsc_item_category</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_item_category</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsc_item_category,1,0,0,item_category_label,0</index-1>
<index-2>XAK2gsc_item_category,1,0,0,parent_item_category_obj,0,item_category_label,0</index-2>
<index-3>XIE1gsc_item_category,0,0,0,item_category_description,0</index-3>
<index-4>XPKgsc_item_category,1,1,0,item_category_obj,0</index-4>
<field><name>item_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Item Category Obj</label>
<column-label>Item Category Obj</column-label>
</field>
<field><name>item_category_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Item Category Label</label>
<column-label>Item Category Label</column-label>
</field>
<field><name>item_category_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Item Category Description</label>
<column-label>Item Category Description</column-label>
</field>
<field><name>item_link</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Item Link</label>
<column-label>Item Link</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>parent_item_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Parent Item Category Obj</label>
<column-label>Parent Item Category Obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsc_item_category"><item_category_obj>1000709349.09</item_category_obj>
<item_category_label>Commit</item_category_label>
<item_category_description>Commit action items</item_category_description>
<item_link>commit-target</item_link>
<system_owned>yes</system_owned>
<parent_item_category_obj>0</parent_item_category_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsc_item_category"><item_category_obj>1000709350.09</item_category_obj>
<item_category_label>Navigation</item_category_label>
<item_category_description>Navigation action items</item_category_description>
<item_link>navigation-target</item_link>
<system_owned>yes</system_owned>
<parent_item_category_obj>0</parent_item_category_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsc_item_category"><item_category_obj>1000709351.09</item_category_obj>
<item_category_label>Tableio</item_category_label>
<item_category_description>Tableio action items</item_category_description>
<item_link>tableio-target</item_link>
<system_owned>yes</system_owned>
<parent_item_category_obj>0</parent_item_category_obj>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsc_item_category"><item_category_obj>1000709352.09</item_category_obj>
<item_category_label>SubMenu</item_category_label>
<item_category_description>SubMenu items</item_category_description>
<item_link></item_link>
<system_owned>yes</system_owned>
<parent_item_category_obj>0</parent_item_category_obj>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>