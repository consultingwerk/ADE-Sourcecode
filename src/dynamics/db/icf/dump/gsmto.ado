<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="10"><dataset_header DisableRI="yes" DatasetObj="1007600203.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMTO" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<dataset_code>GSMTO</dataset_code>
<dataset_description>gsm_token - Tokens</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600204.08</dataset_entity_obj>
<deploy_dataset_obj>1007600203.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMTO</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>token_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_token</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_token</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_token,1,0,0,token_code,0</index-1>
<index-2>XIE1gsm_token,0,0,0,token_description,0</index-2>
<index-3>XPKgsm_token,1,1,0,token_obj,0</index-3>
<field><name>token_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Token obj</label>
<column-label>Token obj</column-label>
</field>
<field><name>token_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Token code</label>
<column-label>Token code</column-label>
</field>
<field><name>token_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Token description</label>
<column-label>Token description</column-label>
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
<label>System owned</label>
<column-label>System owned</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>919</token_obj>
<token_code>add</token_code>
<token_description>Add operation</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>920</token_obj>
<token_code>Cancel</token_code>
<token_description>Change status to cancel</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>921</token_obj>
<token_code>Copy</token_code>
<token_description>Copy operation</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>922</token_obj>
<token_code>Delete</token_code>
<token_description>Delete operation</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>924</token_obj>
<token_code>Modify</token_code>
<token_description>Modify operation</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>925</token_obj>
<token_code>View</token_code>
<token_description>View operation</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="7" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>2122009</token_obj>
<token_code>Update Users Based on Profile</token_code>
<token_description>Update Users Based on Profile</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="8" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>2122020</token_obj>
<token_code>Audit</token_code>
<token_description>Audit tab label</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="9" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>1004897989.09</token_obj>
<token_code>blank</token_code>
<token_description>blank</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="10" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_token"><token_obj>1007600091.09</token_obj>
<token_code>Comments</token_code>
<token_description>Comments</token_description>
<disabled>no</disabled>
<system_owned>yes</system_owned>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>