<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="4"><dataset_header DisableRI="yes" DatasetObj="1007600123.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMUC" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600123.08</deploy_dataset_obj>
<dataset_code>GSMUC</dataset_code>
<dataset_description>gsm_user_category</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
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
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_user_category</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_user_category</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_user_category,1,0,0,user_category_code,0</index-1>
<index-2>XIE1gsm_user_category,0,0,0,user_category_description,0</index-2>
<index-3>XPKgsm_user_category,1,1,0,user_category_obj,0</index-3>
<field><name>user_category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>User category obj</label>
<column-label>User category obj</column-label>
</field>
<field><name>user_category_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>User category code</label>
<column-label>User category code</column-label>
</field>
<field><name>user_category_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>User category description</label>
<column-label>User category description</column-label>
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
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user_category" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMUC" key_field_value="926" record_version_obj="3000058482.09" version_number_seq="1.09" secondary_key_value="Expert" import_version_number_seq="1.09"><user_category_obj>926</user_category_obj>
<user_category_code>Expert</user_category_code>
<user_category_description>At guru level</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user_category" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMUC" key_field_value="1004819314.2" record_version_obj="3000058483.09" version_number_seq="1.09" secondary_key_value="Competent" import_version_number_seq="1.09"><user_category_obj>1004819314.2</user_category_obj>
<user_category_code>Competent</user_category_code>
<user_category_description>With productive experience</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user_category" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMUC" key_field_value="1004834867.09" record_version_obj="3000058484.09" version_number_seq="1.09" secondary_key_value="Guest" import_version_number_seq="1.09"><user_category_obj>1004834867.09</user_category_obj>
<user_category_code>Guest</user_category_code>
<user_category_description>Without portfolio</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_user_category" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMUC" key_field_value="1004838386.09" record_version_obj="3000058485.09" version_number_seq="1.09" secondary_key_value="Novice" import_version_number_seq="1.09"><user_category_obj>1004838386.09</user_category_obj>
<user_category_code>Novice</user_category_code>
<user_category_description>With little or no experience</user_category_description>
<disabled>no</disabled>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>