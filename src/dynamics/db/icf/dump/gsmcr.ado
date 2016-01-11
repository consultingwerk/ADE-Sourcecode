<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="5"><dataset_header DisableRI="yes" DatasetObj="1007600113.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMCR" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<dataset_code>GSMCR</dataset_code>
<dataset_description>gsm_currency - Currencies</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600114.08</dataset_entity_obj>
<deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCR</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>currency_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list></exclude_field_list>
<entity_mnemonic_description>gsm_currency</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_currency</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_currency,1,0,0,currency_code,0</index-1>
<index-2>XIE1gsm_currency,0,0,0,currency_description,0</index-2>
<index-3>XPKgsm_currency,1,1,0,currency_obj,0</index-3>
<field><name>currency_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Currency obj</label>
<column-label>Currency obj</column-label>
</field>
<field><name>currency_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Currency code</label>
<column-label>Currency code</column-label>
</field>
<field><name>currency_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Currency description</label>
<column-label>Currency description</column-label>
</field>
<field><name>currency_symbol</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(5)</format>
<initial></initial>
<label>Currency symbol</label>
<column-label>Currency symbol</column-label>
</field>
<field><name>symbol_format_mask</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Symbol format mask</label>
<column-label>Symbol format mask</column-label>
</field>
<field><name>number_of_decimals</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Number of decimals</label>
<column-label>Number of decimals</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DELETION"><contained_record version_date="09/28/2002" version_time="29040" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmcr" key_field_value="1003533484" record_version_obj="3000033270.09" version_number_seq="1.09" secondary_key_value="ZRB" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DELETION"><contained_record version_date="09/28/2002" version_time="29045" version_user="admin" deletion_flag="yes" entity_mnemonic="gsmcr" key_field_value="1004078781" record_version_obj="3000033271.09" version_number_seq="1.09" secondary_key_value="ZRB1" import_version_number_seq="1.09"/>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_currency" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMCR" key_field_value="870" record_version_obj="3000058474.09" version_number_seq="1.09" secondary_key_value="Rand" import_version_number_seq="1.09"><currency_obj>870</currency_obj>
<currency_code>Rand</currency_code>
<currency_description>South African Rand</currency_description>
<currency_symbol>R</currency_symbol>
<symbol_format_mask>-&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;.99</symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_currency" version_date="09/28/2002" version_time="29484" version_user="admin" deletion_flag="no" entity_mnemonic="gsmcr" key_field_value="871" record_version_obj="3000033276.09" version_number_seq="1.09" secondary_key_value="USD" import_version_number_seq="1.09"><currency_obj>871</currency_obj>
<currency_code>USD</currency_code>
<currency_description>USA Dollar</currency_description>
<currency_symbol>US$</currency_symbol>
<symbol_format_mask>US$ &gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;</symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_currency" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSMCR" key_field_value="872" record_version_obj="3000058475.09" version_number_seq="1.09" secondary_key_value="Pound" import_version_number_seq="1.09"><currency_obj>872</currency_obj>
<currency_code>Pound</currency_code>
<currency_description>British Pound</currency_description>
<currency_symbol>GBP</currency_symbol>
<symbol_format_mask>GBP &gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;&gt;,&gt;&gt;</symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>