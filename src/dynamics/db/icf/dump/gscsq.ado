<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="6"><dataset_header DisableRI="yes" DatasetObj="1007600105.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSCSQ" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<dataset_code>GSCSQ</dataset_code>
<dataset_description>gsc_sequence - Sequences</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>yes</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600106.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSCSQ</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>min_value,max_value,sequence_format,auto_generate,multi_transaction,next_value,number_of_sequences,sequence_active</exclude_field_list>
<entity_mnemonic_description>gsc_sequence</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<dataset_entity><dataset_entity_obj>1007600107.08</dataset_entity_obj>
<deploy_dataset_obj>1007600105.08</deploy_dataset_obj>
<entity_sequence>2</entity_sequence>
<entity_mnemonic>GSCSN</entity_mnemonic>
<primary_entity>no</primary_entity>
<join_entity_mnemonic>GSCSQ</join_entity_mnemonic>
<join_field_list>sequence_obj,sequence_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<exclude_field_list>next_sequence_value</exclude_field_list>
<entity_mnemonic_description>gsc_next_sequence</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsc_sequence</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsc_sequence,1,0,0,company_organisation_obj,0,owning_entity_mnemonic,0,sequence_tla,0</index-1>
<index-2>XIE1gsc_sequence,0,0,0,sequence_description,0</index-2>
<index-3>XIE2gsc_sequence,0,0,0,sequence_short_desc,0</index-3>
<index-4>XPKgsc_sequence,1,1,0,sequence_obj,0</index-4>
<field><name>sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Sequence obj</label>
<column-label>Sequence obj</column-label>
</field>
<field><name>company_organisation_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Company organisation obj</label>
<column-label>Company organisation obj</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning entity</label>
<column-label>Owning entity</column-label>
</field>
<field><name>sequence_tla</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Sequence TLA</label>
<column-label>Sequence TLA</column-label>
</field>
<field><name>sequence_short_desc</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(15)</format>
<initial></initial>
<label>Sequence short desc.</label>
<column-label>Sequence short desc.</column-label>
</field>
<field><name>sequence_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Sequence description</label>
<column-label>Sequence description</column-label>
</field>
<field><name>min_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Min. value</label>
<column-label>Min. value</column-label>
</field>
<field><name>max_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Max. value</label>
<column-label>Max. value</column-label>
</field>
<field><name>sequence_format</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Sequence format</label>
<column-label>Sequence format</column-label>
</field>
<field><name>auto_generate</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Auto generate</label>
<column-label>Auto generate</column-label>
</field>
<field><name>multi_transaction</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Multi transaction</label>
<column-label>Multi transaction</column-label>
</field>
<field><name>next_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Next value</label>
<column-label>Next value</column-label>
</field>
<field><name>number_of_sequences</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;9</format>
<initial>      0</initial>
<label>Number of sequences</label>
<column-label>Number of sequences</column-label>
</field>
<field><name>sequence_active</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Sequence active</label>
<column-label>Sequence active</column-label>
</field>
</table_definition>
<table_definition><name>gsc_next_sequence</name>
<dbname>icfdb</dbname>
<index-1>XPKgsc_next_sequence,1,1,0,sequence_obj,0,next_sequence_value,0</index-1>
<field><name>sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Sequence obj</label>
<column-label>Sequence obj</column-label>
</field>
<field><name>next_sequence_value</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Next sequence value</label>
<column-label>Next sequence value</column-label>
</field>
<field><name>next_sequence_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Next sequence obj</label>
<column-label>Next sequence obj</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="gscsq" key_field_value="9451.24" record_version_obj="9452.24" version_number_seq="24.09" secondary_key_value="0#CHR(1)#RYCRE#CHR(1)#REL" import_version_number_seq="24.09"><sequence_obj>9451.24</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>RYCRE</owning_entity_mnemonic>
<sequence_tla>REL</sequence_tla>
<sequence_short_desc>RelationshipRef</sequence_short_desc>
<sequence_description>Relationship Reference</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ICFREL&amp;S_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>197</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="gscsq" key_field_value="911073.24" record_version_obj="911074.24" version_number_seq="2.09" secondary_key_value="0#CHR(1)#GSMRL#CHR(1)#VER" import_version_number_seq="2.09"><sequence_obj>911073.24</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRL</owning_entity_mnemonic>
<sequence_tla>VER</sequence_tla>
<sequence_short_desc>ReleaseRef</sequence_short_desc>
<sequence_description>Release Version Reference</sequence_description>
<min_value>0</min_value>
<max_value>99999999</max_value>
<sequence_format>VER&amp;S.&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>2</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="gscsq" key_field_value="2259873" record_version_obj="3000004928.09" version_number_seq="2.09" secondary_key_value="0#CHR(1)#GSMMI#CHR(1)#MNU" import_version_number_seq="2.09"><sequence_obj>2259873</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMMI</owning_entity_mnemonic>
<sequence_tla>MNU</sequence_tla>
<sequence_short_desc>Menu Item Ref.</sequence_short_desc>
<sequence_description>Menu Item Reference</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ICF&amp;S_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>204</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="gscsq" key_field_value="2262945" record_version_obj="3000004930.09" version_number_seq="2.09" secondary_key_value="0#CHR(1)#GSMRD#CHR(1)#RDF" import_version_number_seq="2.09"><sequence_obj>2262945</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRD</owning_entity_mnemonic>
<sequence_tla>RDF</sequence_tla>
<sequence_short_desc>Report Def.</sequence_short_desc>
<sequence_description>Report Definition</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ASRDF&amp;S_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>156</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="gscsq" key_field_value="2262946" record_version_obj="3000004929.09" version_number_seq="2.09" secondary_key_value="0#CHR(1)#GSMRF#CHR(1)#RFM" import_version_number_seq="2.09"><sequence_obj>2262946</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRF</owning_entity_mnemonic>
<sequence_tla>RFM</sequence_tla>
<sequence_short_desc>Report Format</sequence_short_desc>
<sequence_description>Report Format</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>ASRFM&amp;S_&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>218</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="6" TransactionType="DATA"><contained_record DB="icfdb" Table="gsc_sequence" version_date="10/02/2003" version_time="49459" version_user="admin" deletion_flag="no" entity_mnemonic="GSCSQ" key_field_value="1003604197" record_version_obj="3000058473.09" version_number_seq="1.09" secondary_key_value="0#CHR(1)#GSMRD#CHR(1)#SPL" import_version_number_seq="1.09"><sequence_obj>1003604197</sequence_obj>
<company_organisation_obj>0</company_organisation_obj>
<owning_entity_mnemonic>GSMRD</owning_entity_mnemonic>
<sequence_tla>SPL</sequence_tla>
<sequence_short_desc>Spl File Name</sequence_short_desc>
<sequence_description>Spooler File Name</sequence_description>
<min_value>1</min_value>
<max_value>99999999</max_value>
<sequence_format>&amp;9</sequence_format>
<auto_generate>yes</auto_generate>
<multi_transaction>no</multi_transaction>
<next_value>1</next_value>
<number_of_sequences>0</number_of_sequences>
<sequence_active>yes</sequence_active>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>