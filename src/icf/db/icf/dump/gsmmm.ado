<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="2" version_date="02/23/2002" version_time="43044" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000433.09" record_version_obj="3000000434.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600192.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMMM" DateCreated="02/23/2002" TimeCreated="11:57:22" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMMM</dataset_code>
<dataset_description>gsm_multi_media - Multi Media</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600193.08</dataset_entity_obj>
<deploy_dataset_obj>1007600192.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMMM</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>multi_media_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_multi_media</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_multi_media</name>
<dbname>ICFDB</dbname>
<index-1>XIE1gsm_multi_media,0,0,0,category_obj,0,owning_obj,0,multi_media_type_obj,0,creation_date,0</index-1>
<index-2>XIE2gsm_multi_media,0,0,0,physical_file_name,0</index-2>
<index-3>XIE3gsm_multi_media,0,0,0,multi_media_description,0</index-3>
<index-4>XIE4gsm_multi_media,0,0,0,owning_obj,0</index-4>
<index-5>XPKgsm_multi_media,1,1,0,multi_media_obj,0</index-5>
<field><name>multi_media_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Multi Media Obj</label>
<column-label>Multi Media Obj</column-label>
</field>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Category Obj</label>
<column-label>Category Obj</column-label>
</field>
<field><name>owning_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Owning Obj</label>
<column-label>Owning Obj</column-label>
</field>
<field><name>multi_media_type_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Multi Media Type Obj</label>
<column-label>Multi Media Type Obj</column-label>
</field>
<field><name>physical_file_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(70)</format>
<initial></initial>
<label>Physical File Name</label>
<column-label>Physical File Name</column-label>
</field>
<field><name>multi_media_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Multi Media Description</label>
<column-label>Multi Media Description</column-label>
</field>
<field><name>creation_date</name>
<data-type>date</data-type>
<extent>0</extent>
<format>99/99/9999</format>
<initial>02/23/2002</initial>
<label>Creation Date</label>
<column-label>Creation Date</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_multi_media"><multi_media_obj>1005117654.101</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>af/bmp/treefile.ico</physical_file_name>
<multi_media_description>File Folder (Closed)</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_multi_media"><multi_media_obj>1005117656.101</multi_media_obj>
<category_obj>1005081017.28</category_obj>
<owning_obj>0</owning_obj>
<multi_media_type_obj>1005100225.101</multi_media_type_obj>
<physical_file_name>af/bmp/treefils.ico</physical_file_name>
<multi_media_description>File Folder (Open)</multi_media_description>
<creation_date>08/28/01</creation_date>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>