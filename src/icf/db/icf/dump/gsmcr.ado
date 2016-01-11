<?xml version="1.0" encoding="ISO8859-1" ?>
<dataset Transactions="5" version_date="02/23/2002" version_time="43013" version_user="admin" entity_mnemonic="GSTDF" key_field_value="3000000417.09" record_version_obj="3000000418.09" version_number_seq="2.09" import_version_number_seq="1.09"><dataset_header DisableRI="yes" DatasetObj="1007600113.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMCR" DateCreated="02/23/2002" TimeCreated="11:56:52" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="93" NumericSeparator=","><deploy_dataset_obj>1007600113.08</deploy_dataset_obj>
<owner_site_code></owner_site_code>
<dataset_code>GSMCR</dataset_code>
<dataset_description>gsm_currency - Currencies</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
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
<entity_mnemonic_description>gsm_currency</entity_mnemonic_description>
<entity_dbname>icfdb</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_currency</name>
<dbname>ICFDB</dbname>
<index-1>XAK1gsm_currency,1,0,0,currency_code,0</index-1>
<index-2>XIE1gsm_currency,0,0,0,currency_description,0</index-2>
<index-3>XPKgsm_currency,1,1,0,currency_obj,0</index-3>
<field><name>currency_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>>>>>>>>>>>>>>>>>>9.999999999</format>
<initial>                 0.000000000</initial>
<label>Currency Obj</label>
<column-label>Currency Obj</column-label>
</field>
<field><name>currency_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Currency Code</label>
<column-label>Currency Code</column-label>
</field>
<field><name>currency_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Currency Description</label>
<column-label>Currency Description</column-label>
</field>
<field><name>currency_symbol</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(5)</format>
<initial></initial>
<label>Currency Symbol</label>
<column-label>Currency Symbol</column-label>
</field>
<field><name>symbol_format_mask</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Symbol Format Mask</label>
<column-label>Symbol Format Mask</column-label>
</field>
<field><name>number_of_decimals</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>->9</format>
<initial>  0</initial>
<label>Number of Decimals</label>
<column-label>Number of Decimals</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1"><contained_record DB="ICFDB" Table="gsm_currency"><currency_obj>870</currency_obj>
<currency_code>Rand</currency_code>
<currency_description>South African Rand</currency_description>
<currency_symbol>R</currency_symbol>
<symbol_format_mask>->>,>>>,>>>,>>>,>>>.99</symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2"><contained_record DB="ICFDB" Table="gsm_currency"><currency_obj>871</currency_obj>
<currency_code>Dollar</currency_code>
<currency_description>USA Dollar</currency_description>
<currency_symbol>US$</currency_symbol>
<symbol_format_mask>US$ >>>,>>>,>>>,>></symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3"><contained_record DB="ICFDB" Table="gsm_currency"><currency_obj>872</currency_obj>
<currency_code>Pound</currency_code>
<currency_description>British Pound</currency_description>
<currency_symbol>GBP</currency_symbol>
<symbol_format_mask>GBP >>>,>>>,>>>,>></symbol_format_mask>
<number_of_decimals>2</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4"><contained_record DB="ICFDB" Table="gsm_currency"><currency_obj>1003533484</currency_obj>
<currency_code>ZRB</currency_code>
<currency_description>Zerbits</currency_description>
<currency_symbol>ZRB</currency_symbol>
<symbol_format_mask>>>,>>>,>>>,>>>.&lt;&lt;&lt;&lt;&lt;&lt;+</symbol_format_mask>
<number_of_decimals>4</number_of_decimals>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5"><contained_record DB="ICFDB" Table="gsm_currency"><currency_obj>1004078781</currency_obj>
<currency_code>ZRB1</currency_code>
<currency_description>Zerbits1</currency_description>
<currency_symbol>ZRB1</currency_symbol>
<symbol_format_mask>>>,>>>,>>>,>>>.&lt;&lt;&lt;&lt;&lt;&lt;+</symbol_format_mask>
<number_of_decimals>4</number_of_decimals>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>