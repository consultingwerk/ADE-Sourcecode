<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="3"><dataset_header DisableRI="yes" DatasetObj="1007600117.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCNA" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<dataset_code>GSCNA</dataset_code>
<dataset_description>gsc_nationality - Nationalities</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600118.08</dataset_entity_obj>
<deploy_dataset_obj>1007600117.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCNA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>nationality_code</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsc_nationality</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_nationality</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_nationality,1,0,0,nationality_code,0</index-1>
<index-2>XIE1gsc_nationality,0,0,0,nationality_name,0</index-2>
<index-3>XPKgsc_nationality,1,1,0,nationality_obj,0</index-3>
<field><name>nationality_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Nationality Obj</label>
<column-label>Nationality Obj</column-label>
</field>
<field><name>nationality_code</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(10)</format>
<initial></initial>
<label>Nationality Code</label>
<column-label>Nationality Code</column-label>
</field>
<field><name>nationality_name</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Nationality Name</label>
<column-label>Nationality Name</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_nationality"><nationality_obj>487</nationality_obj>
<nationality_code>ZA</nationality_code>
<nationality_name>South African</nationality_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_nationality" version_date="09/28/2002" version_time="29410" version_user="admin" deletion_flag="no" entity_mnemonic="gscna" key_field_value="488" record_version_obj="3000033275.09" version_number_seq="1.09" secondary_key_value="GB" import_version_number_seq="1.09"><nationality_obj>488</nationality_obj>
<nationality_code>GB</nationality_code>
<nationality_name>British</nationality_name>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_nationality" version_date="09/28/2002" version_time="29360" version_user="admin" deletion_flag="no" entity_mnemonic="gscna" key_field_value="3000033273.09" record_version_obj="3000033274.09" version_number_seq="2.09" secondary_key_value="US" import_version_number_seq="2.09"><nationality_obj>3000033273.09</nationality_obj>
<nationality_code>US</nationality_code>
<nationality_name>American</nationality_name>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>