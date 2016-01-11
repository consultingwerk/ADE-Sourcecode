<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="5"><dataset_header DisableRI="yes" DatasetObj="1007600115.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMCY" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<dataset_code>GSMCY</dataset_code>
<dataset_description>gsm_country - Countries</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600116.08</dataset_entity_obj>
<deploy_dataset_obj>1007600115.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCY</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>country_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_country</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_country</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_country,1,0,0,country_code,0</index-1>
<index-2>XIE1gsm_country,0,0,0,country_name,0</index-2>
<index-3>XPKgsm_country,1,1,0,country_obj,0</index-3>
<field><name>country_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Country Obj</label>
<column-label>Country Obj</column-label>
</field>
<field><name>country_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Country Code</label>
<column-label>Country Code</column-label>
</field>
<field><name>country_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Country Name</label>
<column-label>Country Name</column-label>
</field>
<field><name>min_postcode_lookup_chars</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>Min. Postcode Lookup Chars</label>
<column-label>Min. Postcode Lookup Chars</column-label>
</field>
<field><name>address_format_procedure_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Address Format Procedure Obj</label>
<column-label>Address Format Procedure Obj</column-label>
</field>
<field><name>properform_address</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Properform Address</label>
<column-label>Properform Address</column-label>
</field>
<field><name>upcase_town</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Upcase Town</label>
<column-label>Upcase Town</column-label>
</field>
<field><name>force_valid_address</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Force Valid Address</label>
<column-label>Force Valid Address</column-label>
</field>
<field><name>address_line1_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Address Line1 Label</label>
<column-label>Address Line1 Label</column-label>
</field>
<field><name>address_line2_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Address Line2 Label</label>
<column-label>Address Line2 Label</column-label>
</field>
<field><name>address_line3_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Address Line3 Label</label>
<column-label>Address Line3 Label</column-label>
</field>
<field><name>address_line4_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Address Line4 Label</label>
<column-label>Address Line4 Label</column-label>
</field>
<field><name>address_line5_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Address Line5 Label</label>
<column-label>Address Line5 Label</column-label>
</field>
<field><name>postcode_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Postcode Label</label>
<column-label>Postcode Label</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_country"><country_obj>867</country_obj>
<country_code>SA</country_code>
<country_name>South Africa</country_name>
<min_postcode_lookup_chars>4</min_postcode_lookup_chars>
<address_format_procedure_obj>0</address_format_procedure_obj>
<properform_address>yes</properform_address>
<upcase_town>yes</upcase_town>
<force_valid_address>no</force_valid_address>
<address_line1_label>SA No. or Name</address_line1_label>
<address_line2_label>SA Street</address_line2_label>
<address_line3_label>SA City</address_line3_label>
<address_line4_label>SA PO Box</address_line4_label>
<address_line5_label>SA Firm</address_line5_label>
<postcode_label>SA Postcode</postcode_label>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_country"><country_obj>868</country_obj>
<country_code>UK</country_code>
<country_name>United Kingdom</country_name>
<min_postcode_lookup_chars>3</min_postcode_lookup_chars>
<address_format_procedure_obj>0</address_format_procedure_obj>
<properform_address>yes</properform_address>
<upcase_town>yes</upcase_town>
<force_valid_address>no</force_valid_address>
<address_line1_label>No. or Name</address_line1_label>
<address_line2_label>Street</address_line2_label>
<address_line3_label>City</address_line3_label>
<address_line4_label>PO Box</address_line4_label>
<address_line5_label>Company</address_line5_label>
<postcode_label>Postcode</postcode_label>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_country"><country_obj>869</country_obj>
<country_code>USA</country_code>
<country_name>United States of America</country_name>
<min_postcode_lookup_chars>0</min_postcode_lookup_chars>
<address_format_procedure_obj>0</address_format_procedure_obj>
<properform_address>yes</properform_address>
<upcase_town>no</upcase_town>
<force_valid_address>no</force_valid_address>
<address_line1_label># or Name</address_line1_label>
<address_line2_label>Street</address_line2_label>
<address_line3_label>City</address_line3_label>
<address_line4_label>Postal Box</address_line4_label>
<address_line5_label>Corporation</address_line5_label>
<postcode_label>ZIP</postcode_label>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_country"><country_obj>256617</country_obj>
<country_code>FR</country_code>
<country_name>France</country_name>
<min_postcode_lookup_chars>5</min_postcode_lookup_chars>
<address_format_procedure_obj>0</address_format_procedure_obj>
<properform_address>yes</properform_address>
<upcase_town>yes</upcase_town>
<force_valid_address>no</force_valid_address>
<address_line1_label>Adr1</address_line1_label>
<address_line2_label>Adr2</address_line2_label>
<address_line3_label>Adr3</address_line3_label>
<address_line4_label>Adr4</address_line4_label>
<address_line5_label>Ville</address_line5_label>
<postcode_label>Code Postal</postcode_label>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_country"><country_obj>1004662966</country_obj>
<country_code>DE</country_code>
<country_name>Germany</country_name>
<min_postcode_lookup_chars>0</min_postcode_lookup_chars>
<address_format_procedure_obj>0</address_format_procedure_obj>
<properform_address>yes</properform_address>
<upcase_town>yes</upcase_town>
<force_valid_address>no</force_valid_address>
<address_line1_label>No. or Name</address_line1_label>
<address_line2_label>Street</address_line2_label>
<address_line3_label>City</address_line3_label>
<address_line4_label>PO Box</address_line4_label>
<address_line5_label>Firm</address_line5_label>
<postcode_label>Postcode</postcode_label>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>