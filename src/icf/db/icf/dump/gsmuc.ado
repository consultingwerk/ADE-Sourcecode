<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="4" version_date="02/23/2002" version_time="43072" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000451.09" record_version_obj="3000000452.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600123.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMUC" DateCreated="02/23/2002" TimeCreated="11:57:52" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMUC</dataset_code>
<dataset_description>gsm_user_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<dataset_entity><dataset_entity_obj>1007600124.08</dataset_entity_obj>
<deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMUC</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>user_category_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<entity_mnemonic_description>gsm_user_category</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_user_category</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_user_category,1,0,0,user_category_code,0</index-1>
<index-2>XIE1gsm_user_category,0,0,0,user_category_description,0</index-2>
<index-3>XPKgsm_user_category,1,1,0,user_category_obj,0</index-3>
<field><name>user_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>User Category Obj</label>
<column-label>User Category Obj</column-label>
</field>
<field><name>user_category_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>User Category Code</label>
<column-label>User Category Code</column-label>
</field>
<field><name>user_category_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User Category Description</label>
<column-label>User Category Description</column-label>
</field>
<field><name>disabled</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Disabled</label>
<column-label>Disabled</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_user_category"><user_category_obj>926</user_category_obj>
<user_category_code>Expert</user_category_code>
<user_category_description>At guru level</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_user_category"><user_category_obj>1004819314.2</user_category_obj>
<user_category_code>Competent</user_category_code>
<user_category_description>With productive experience</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsm_user_category"><user_category_obj>1004834867.09</user_category_obj>
<user_category_code>Guest</user_category_code>
<user_category_description>Without portfolio</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsm_user_category"><user_category_obj>1004838386.09</user_category_obj>
<user_category_code>Novice</user_category_code>
<user_category_description>With little or no experience</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>